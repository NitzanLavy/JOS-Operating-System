
obj/user/sendpage.debug:     file format elf32-i386


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
  80002c:	e8 af 01 00 00       	call   8001e0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 28             	sub    $0x28,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  800039:	e8 4c 12 00 00       	call   80128a <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 85 bd 00 00 00    	jne    800106 <umain+0xd3>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  800049:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800050:	00 
  800051:	c7 44 24 04 00 00 b0 	movl   $0xb00000,0x4(%esp)
  800058:	00 
  800059:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80005c:	89 04 24             	mov    %eax,(%esp)
  80005f:	e8 fc 14 00 00       	call   801560 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800064:	c7 44 24 08 00 00 b0 	movl   $0xb00000,0x8(%esp)
  80006b:	00 
  80006c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80006f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800073:	c7 04 24 00 2d 80 00 	movl   $0x802d00,(%esp)
  80007a:	e8 69 02 00 00       	call   8002e8 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  80007f:	a1 04 40 80 00       	mov    0x804004,%eax
  800084:	89 04 24             	mov    %eax,(%esp)
  800087:	e8 54 08 00 00       	call   8008e0 <strlen>
  80008c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800090:	a1 04 40 80 00       	mov    0x804004,%eax
  800095:	89 44 24 04          	mov    %eax,0x4(%esp)
  800099:	c7 04 24 00 00 b0 00 	movl   $0xb00000,(%esp)
  8000a0:	e8 4d 09 00 00       	call   8009f2 <strncmp>
  8000a5:	85 c0                	test   %eax,%eax
  8000a7:	75 0c                	jne    8000b5 <umain+0x82>
			cprintf("child received correct message\n");
  8000a9:	c7 04 24 14 2d 80 00 	movl   $0x802d14,(%esp)
  8000b0:	e8 33 02 00 00       	call   8002e8 <cprintf>

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  8000b5:	a1 00 40 80 00       	mov    0x804000,%eax
  8000ba:	89 04 24             	mov    %eax,(%esp)
  8000bd:	e8 1e 08 00 00       	call   8008e0 <strlen>
  8000c2:	83 c0 01             	add    $0x1,%eax
  8000c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000c9:	a1 00 40 80 00       	mov    0x804000,%eax
  8000ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000d2:	c7 04 24 00 00 b0 00 	movl   $0xb00000,(%esp)
  8000d9:	e8 3e 0a 00 00       	call   800b1c <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  8000de:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8000e5:	00 
  8000e6:	c7 44 24 08 00 00 b0 	movl   $0xb00000,0x8(%esp)
  8000ed:	00 
  8000ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000f5:	00 
  8000f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f9:	89 04 24             	mov    %eax,(%esp)
  8000fc:	e8 b3 14 00 00       	call   8015b4 <ipc_send>
		return;
  800101:	e9 d8 00 00 00       	jmp    8001de <umain+0x1ab>
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800106:	a1 08 50 80 00       	mov    0x805008,%eax
  80010b:	8b 40 48             	mov    0x48(%eax),%eax
  80010e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800115:	00 
  800116:	c7 44 24 04 00 00 a0 	movl   $0xa00000,0x4(%esp)
  80011d:	00 
  80011e:	89 04 24             	mov    %eax,(%esp)
  800121:	e8 0d 0c 00 00       	call   800d33 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800126:	a1 04 40 80 00       	mov    0x804004,%eax
  80012b:	89 04 24             	mov    %eax,(%esp)
  80012e:	e8 ad 07 00 00       	call   8008e0 <strlen>
  800133:	83 c0 01             	add    $0x1,%eax
  800136:	89 44 24 08          	mov    %eax,0x8(%esp)
  80013a:	a1 04 40 80 00       	mov    0x804004,%eax
  80013f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800143:	c7 04 24 00 00 a0 00 	movl   $0xa00000,(%esp)
  80014a:	e8 cd 09 00 00       	call   800b1c <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80014f:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800156:	00 
  800157:	c7 44 24 08 00 00 a0 	movl   $0xa00000,0x8(%esp)
  80015e:	00 
  80015f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800166:	00 
  800167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80016a:	89 04 24             	mov    %eax,(%esp)
  80016d:	e8 42 14 00 00       	call   8015b4 <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  800172:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800179:	00 
  80017a:	c7 44 24 04 00 00 a0 	movl   $0xa00000,0x4(%esp)
  800181:	00 
  800182:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800185:	89 04 24             	mov    %eax,(%esp)
  800188:	e8 d3 13 00 00       	call   801560 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  80018d:	c7 44 24 08 00 00 a0 	movl   $0xa00000,0x8(%esp)
  800194:	00 
  800195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019c:	c7 04 24 00 2d 80 00 	movl   $0x802d00,(%esp)
  8001a3:	e8 40 01 00 00       	call   8002e8 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8001a8:	a1 00 40 80 00       	mov    0x804000,%eax
  8001ad:	89 04 24             	mov    %eax,(%esp)
  8001b0:	e8 2b 07 00 00       	call   8008e0 <strlen>
  8001b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001b9:	a1 00 40 80 00       	mov    0x804000,%eax
  8001be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001c2:	c7 04 24 00 00 a0 00 	movl   $0xa00000,(%esp)
  8001c9:	e8 24 08 00 00       	call   8009f2 <strncmp>
  8001ce:	85 c0                	test   %eax,%eax
  8001d0:	75 0c                	jne    8001de <umain+0x1ab>
		cprintf("parent received correct message\n");
  8001d2:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  8001d9:	e8 0a 01 00 00       	call   8002e8 <cprintf>
	return;
}
  8001de:	c9                   	leave  
  8001df:	c3                   	ret    

008001e0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	56                   	push   %esi
  8001e4:	53                   	push   %ebx
  8001e5:	83 ec 10             	sub    $0x10,%esp
  8001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  8001ee:	e8 02 0b 00 00       	call   800cf5 <sys_getenvid>
  8001f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001f8:	89 c2                	mov    %eax,%edx
  8001fa:	c1 e2 07             	shl    $0x7,%edx
  8001fd:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800204:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800209:	85 db                	test   %ebx,%ebx
  80020b:	7e 07                	jle    800214 <libmain+0x34>
		binaryname = argv[0];
  80020d:	8b 06                	mov    (%esi),%eax
  80020f:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  800214:	89 74 24 04          	mov    %esi,0x4(%esp)
  800218:	89 1c 24             	mov    %ebx,(%esp)
  80021b:	e8 13 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800220:	e8 07 00 00 00       	call   80022c <exit>
}
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	5b                   	pop    %ebx
  800229:	5e                   	pop    %esi
  80022a:	5d                   	pop    %ebp
  80022b:	c3                   	ret    

0080022c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800232:	e8 03 16 00 00       	call   80183a <close_all>
	sys_env_destroy(0);
  800237:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80023e:	e8 60 0a 00 00       	call   800ca3 <sys_env_destroy>
}
  800243:	c9                   	leave  
  800244:	c3                   	ret    

00800245 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800245:	55                   	push   %ebp
  800246:	89 e5                	mov    %esp,%ebp
  800248:	53                   	push   %ebx
  800249:	83 ec 14             	sub    $0x14,%esp
  80024c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80024f:	8b 13                	mov    (%ebx),%edx
  800251:	8d 42 01             	lea    0x1(%edx),%eax
  800254:	89 03                	mov    %eax,(%ebx)
  800256:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800259:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80025d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800262:	75 19                	jne    80027d <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800264:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80026b:	00 
  80026c:	8d 43 08             	lea    0x8(%ebx),%eax
  80026f:	89 04 24             	mov    %eax,(%esp)
  800272:	e8 ef 09 00 00       	call   800c66 <sys_cputs>
		b->idx = 0;
  800277:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80027d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800281:	83 c4 14             	add    $0x14,%esp
  800284:	5b                   	pop    %ebx
  800285:	5d                   	pop    %ebp
  800286:	c3                   	ret    

00800287 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800290:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800297:	00 00 00 
	b.cnt = 0;
  80029a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002bc:	c7 04 24 45 02 80 00 	movl   $0x800245,(%esp)
  8002c3:	e8 b6 01 00 00       	call   80047e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002c8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002d8:	89 04 24             	mov    %eax,(%esp)
  8002db:	e8 86 09 00 00       	call   800c66 <sys_cputs>

	return b.cnt;
}
  8002e0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002e6:	c9                   	leave  
  8002e7:	c3                   	ret    

008002e8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ee:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f8:	89 04 24             	mov    %eax,(%esp)
  8002fb:	e8 87 ff ff ff       	call   800287 <vcprintf>
	va_end(ap);

	return cnt;
}
  800300:	c9                   	leave  
  800301:	c3                   	ret    
  800302:	66 90                	xchg   %ax,%ax
  800304:	66 90                	xchg   %ax,%ax
  800306:	66 90                	xchg   %ax,%ax
  800308:	66 90                	xchg   %ax,%ax
  80030a:	66 90                	xchg   %ax,%ax
  80030c:	66 90                	xchg   %ax,%ax
  80030e:	66 90                	xchg   %ax,%ax

00800310 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	57                   	push   %edi
  800314:	56                   	push   %esi
  800315:	53                   	push   %ebx
  800316:	83 ec 3c             	sub    $0x3c,%esp
  800319:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80031c:	89 d7                	mov    %edx,%edi
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800324:	8b 45 0c             	mov    0xc(%ebp),%eax
  800327:	89 c3                	mov    %eax,%ebx
  800329:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80032c:	8b 45 10             	mov    0x10(%ebp),%eax
  80032f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800332:	b9 00 00 00 00       	mov    $0x0,%ecx
  800337:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80033d:	39 d9                	cmp    %ebx,%ecx
  80033f:	72 05                	jb     800346 <printnum+0x36>
  800341:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800344:	77 69                	ja     8003af <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800346:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800349:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80034d:	83 ee 01             	sub    $0x1,%esi
  800350:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800354:	89 44 24 08          	mov    %eax,0x8(%esp)
  800358:	8b 44 24 08          	mov    0x8(%esp),%eax
  80035c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800360:	89 c3                	mov    %eax,%ebx
  800362:	89 d6                	mov    %edx,%esi
  800364:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800367:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80036a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80036e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800372:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800375:	89 04 24             	mov    %eax,(%esp)
  800378:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80037b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80037f:	e8 dc 26 00 00       	call   802a60 <__udivdi3>
  800384:	89 d9                	mov    %ebx,%ecx
  800386:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80038a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80038e:	89 04 24             	mov    %eax,(%esp)
  800391:	89 54 24 04          	mov    %edx,0x4(%esp)
  800395:	89 fa                	mov    %edi,%edx
  800397:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80039a:	e8 71 ff ff ff       	call   800310 <printnum>
  80039f:	eb 1b                	jmp    8003bc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003a8:	89 04 24             	mov    %eax,(%esp)
  8003ab:	ff d3                	call   *%ebx
  8003ad:	eb 03                	jmp    8003b2 <printnum+0xa2>
  8003af:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b2:	83 ee 01             	sub    $0x1,%esi
  8003b5:	85 f6                	test   %esi,%esi
  8003b7:	7f e8                	jg     8003a1 <printnum+0x91>
  8003b9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003c0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ce:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d5:	89 04 24             	mov    %eax,(%esp)
  8003d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003df:	e8 ac 27 00 00       	call   802b90 <__umoddi3>
  8003e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003e8:	0f be 80 ac 2d 80 00 	movsbl 0x802dac(%eax),%eax
  8003ef:	89 04 24             	mov    %eax,(%esp)
  8003f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003f5:	ff d0                	call   *%eax
}
  8003f7:	83 c4 3c             	add    $0x3c,%esp
  8003fa:	5b                   	pop    %ebx
  8003fb:	5e                   	pop    %esi
  8003fc:	5f                   	pop    %edi
  8003fd:	5d                   	pop    %ebp
  8003fe:	c3                   	ret    

008003ff <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003ff:	55                   	push   %ebp
  800400:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800402:	83 fa 01             	cmp    $0x1,%edx
  800405:	7e 0e                	jle    800415 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800407:	8b 10                	mov    (%eax),%edx
  800409:	8d 4a 08             	lea    0x8(%edx),%ecx
  80040c:	89 08                	mov    %ecx,(%eax)
  80040e:	8b 02                	mov    (%edx),%eax
  800410:	8b 52 04             	mov    0x4(%edx),%edx
  800413:	eb 22                	jmp    800437 <getuint+0x38>
	else if (lflag)
  800415:	85 d2                	test   %edx,%edx
  800417:	74 10                	je     800429 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800419:	8b 10                	mov    (%eax),%edx
  80041b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80041e:	89 08                	mov    %ecx,(%eax)
  800420:	8b 02                	mov    (%edx),%eax
  800422:	ba 00 00 00 00       	mov    $0x0,%edx
  800427:	eb 0e                	jmp    800437 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800429:	8b 10                	mov    (%eax),%edx
  80042b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80042e:	89 08                	mov    %ecx,(%eax)
  800430:	8b 02                	mov    (%edx),%eax
  800432:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800437:	5d                   	pop    %ebp
  800438:	c3                   	ret    

00800439 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800439:	55                   	push   %ebp
  80043a:	89 e5                	mov    %esp,%ebp
  80043c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80043f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800443:	8b 10                	mov    (%eax),%edx
  800445:	3b 50 04             	cmp    0x4(%eax),%edx
  800448:	73 0a                	jae    800454 <sprintputch+0x1b>
		*b->buf++ = ch;
  80044a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80044d:	89 08                	mov    %ecx,(%eax)
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	88 02                	mov    %al,(%edx)
}
  800454:	5d                   	pop    %ebp
  800455:	c3                   	ret    

00800456 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800456:	55                   	push   %ebp
  800457:	89 e5                	mov    %esp,%ebp
  800459:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80045c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80045f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800463:	8b 45 10             	mov    0x10(%ebp),%eax
  800466:	89 44 24 08          	mov    %eax,0x8(%esp)
  80046a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800471:	8b 45 08             	mov    0x8(%ebp),%eax
  800474:	89 04 24             	mov    %eax,(%esp)
  800477:	e8 02 00 00 00       	call   80047e <vprintfmt>
	va_end(ap);
}
  80047c:	c9                   	leave  
  80047d:	c3                   	ret    

0080047e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80047e:	55                   	push   %ebp
  80047f:	89 e5                	mov    %esp,%ebp
  800481:	57                   	push   %edi
  800482:	56                   	push   %esi
  800483:	53                   	push   %ebx
  800484:	83 ec 3c             	sub    $0x3c,%esp
  800487:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80048a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80048d:	eb 14                	jmp    8004a3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80048f:	85 c0                	test   %eax,%eax
  800491:	0f 84 b3 03 00 00    	je     80084a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800497:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80049b:	89 04 24             	mov    %eax,(%esp)
  80049e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004a1:	89 f3                	mov    %esi,%ebx
  8004a3:	8d 73 01             	lea    0x1(%ebx),%esi
  8004a6:	0f b6 03             	movzbl (%ebx),%eax
  8004a9:	83 f8 25             	cmp    $0x25,%eax
  8004ac:	75 e1                	jne    80048f <vprintfmt+0x11>
  8004ae:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8004b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004b9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8004c0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8004c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004cc:	eb 1d                	jmp    8004eb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ce:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004d0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8004d4:	eb 15                	jmp    8004eb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004d8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8004dc:	eb 0d                	jmp    8004eb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004e4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004eb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8004ee:	0f b6 0e             	movzbl (%esi),%ecx
  8004f1:	0f b6 c1             	movzbl %cl,%eax
  8004f4:	83 e9 23             	sub    $0x23,%ecx
  8004f7:	80 f9 55             	cmp    $0x55,%cl
  8004fa:	0f 87 2a 03 00 00    	ja     80082a <vprintfmt+0x3ac>
  800500:	0f b6 c9             	movzbl %cl,%ecx
  800503:	ff 24 8d 20 2f 80 00 	jmp    *0x802f20(,%ecx,4)
  80050a:	89 de                	mov    %ebx,%esi
  80050c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800511:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800514:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800518:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80051b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80051e:	83 fb 09             	cmp    $0x9,%ebx
  800521:	77 36                	ja     800559 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800523:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800526:	eb e9                	jmp    800511 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800528:	8b 45 14             	mov    0x14(%ebp),%eax
  80052b:	8d 48 04             	lea    0x4(%eax),%ecx
  80052e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800531:	8b 00                	mov    (%eax),%eax
  800533:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800536:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800538:	eb 22                	jmp    80055c <vprintfmt+0xde>
  80053a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80053d:	85 c9                	test   %ecx,%ecx
  80053f:	b8 00 00 00 00       	mov    $0x0,%eax
  800544:	0f 49 c1             	cmovns %ecx,%eax
  800547:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	89 de                	mov    %ebx,%esi
  80054c:	eb 9d                	jmp    8004eb <vprintfmt+0x6d>
  80054e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800550:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800557:	eb 92                	jmp    8004eb <vprintfmt+0x6d>
  800559:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80055c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800560:	79 89                	jns    8004eb <vprintfmt+0x6d>
  800562:	e9 77 ff ff ff       	jmp    8004de <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800567:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80056c:	e9 7a ff ff ff       	jmp    8004eb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8d 50 04             	lea    0x4(%eax),%edx
  800577:	89 55 14             	mov    %edx,0x14(%ebp)
  80057a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	89 04 24             	mov    %eax,(%esp)
  800583:	ff 55 08             	call   *0x8(%ebp)
			break;
  800586:	e9 18 ff ff ff       	jmp    8004a3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80058b:	8b 45 14             	mov    0x14(%ebp),%eax
  80058e:	8d 50 04             	lea    0x4(%eax),%edx
  800591:	89 55 14             	mov    %edx,0x14(%ebp)
  800594:	8b 00                	mov    (%eax),%eax
  800596:	99                   	cltd   
  800597:	31 d0                	xor    %edx,%eax
  800599:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80059b:	83 f8 12             	cmp    $0x12,%eax
  80059e:	7f 0b                	jg     8005ab <vprintfmt+0x12d>
  8005a0:	8b 14 85 80 30 80 00 	mov    0x803080(,%eax,4),%edx
  8005a7:	85 d2                	test   %edx,%edx
  8005a9:	75 20                	jne    8005cb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8005ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005af:	c7 44 24 08 c4 2d 80 	movl   $0x802dc4,0x8(%esp)
  8005b6:	00 
  8005b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	89 04 24             	mov    %eax,(%esp)
  8005c1:	e8 90 fe ff ff       	call   800456 <printfmt>
  8005c6:	e9 d8 fe ff ff       	jmp    8004a3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8005cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005cf:	c7 44 24 08 ed 32 80 	movl   $0x8032ed,0x8(%esp)
  8005d6:	00 
  8005d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	89 04 24             	mov    %eax,(%esp)
  8005e1:	e8 70 fe ff ff       	call   800456 <printfmt>
  8005e6:	e9 b8 fe ff ff       	jmp    8004a3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005eb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8d 50 04             	lea    0x4(%eax),%edx
  8005fa:	89 55 14             	mov    %edx,0x14(%ebp)
  8005fd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8005ff:	85 f6                	test   %esi,%esi
  800601:	b8 bd 2d 80 00       	mov    $0x802dbd,%eax
  800606:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800609:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80060d:	0f 84 97 00 00 00    	je     8006aa <vprintfmt+0x22c>
  800613:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800617:	0f 8e 9b 00 00 00    	jle    8006b8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80061d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800621:	89 34 24             	mov    %esi,(%esp)
  800624:	e8 cf 02 00 00       	call   8008f8 <strnlen>
  800629:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80062c:	29 c2                	sub    %eax,%edx
  80062e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800631:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800635:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800638:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80063b:	8b 75 08             	mov    0x8(%ebp),%esi
  80063e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800641:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800643:	eb 0f                	jmp    800654 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800645:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800649:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80064c:	89 04 24             	mov    %eax,(%esp)
  80064f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800651:	83 eb 01             	sub    $0x1,%ebx
  800654:	85 db                	test   %ebx,%ebx
  800656:	7f ed                	jg     800645 <vprintfmt+0x1c7>
  800658:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80065b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065e:	85 d2                	test   %edx,%edx
  800660:	b8 00 00 00 00       	mov    $0x0,%eax
  800665:	0f 49 c2             	cmovns %edx,%eax
  800668:	29 c2                	sub    %eax,%edx
  80066a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80066d:	89 d7                	mov    %edx,%edi
  80066f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800672:	eb 50                	jmp    8006c4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800674:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800678:	74 1e                	je     800698 <vprintfmt+0x21a>
  80067a:	0f be d2             	movsbl %dl,%edx
  80067d:	83 ea 20             	sub    $0x20,%edx
  800680:	83 fa 5e             	cmp    $0x5e,%edx
  800683:	76 13                	jbe    800698 <vprintfmt+0x21a>
					putch('?', putdat);
  800685:	8b 45 0c             	mov    0xc(%ebp),%eax
  800688:	89 44 24 04          	mov    %eax,0x4(%esp)
  80068c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800693:	ff 55 08             	call   *0x8(%ebp)
  800696:	eb 0d                	jmp    8006a5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80069f:	89 04 24             	mov    %eax,(%esp)
  8006a2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a5:	83 ef 01             	sub    $0x1,%edi
  8006a8:	eb 1a                	jmp    8006c4 <vprintfmt+0x246>
  8006aa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006ad:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006b0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006b3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006b6:	eb 0c                	jmp    8006c4 <vprintfmt+0x246>
  8006b8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006bb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006c1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006c4:	83 c6 01             	add    $0x1,%esi
  8006c7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8006cb:	0f be c2             	movsbl %dl,%eax
  8006ce:	85 c0                	test   %eax,%eax
  8006d0:	74 27                	je     8006f9 <vprintfmt+0x27b>
  8006d2:	85 db                	test   %ebx,%ebx
  8006d4:	78 9e                	js     800674 <vprintfmt+0x1f6>
  8006d6:	83 eb 01             	sub    $0x1,%ebx
  8006d9:	79 99                	jns    800674 <vprintfmt+0x1f6>
  8006db:	89 f8                	mov    %edi,%eax
  8006dd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8006e3:	89 c3                	mov    %eax,%ebx
  8006e5:	eb 1a                	jmp    800701 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006eb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006f2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f4:	83 eb 01             	sub    $0x1,%ebx
  8006f7:	eb 08                	jmp    800701 <vprintfmt+0x283>
  8006f9:	89 fb                	mov    %edi,%ebx
  8006fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006fe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800701:	85 db                	test   %ebx,%ebx
  800703:	7f e2                	jg     8006e7 <vprintfmt+0x269>
  800705:	89 75 08             	mov    %esi,0x8(%ebp)
  800708:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80070b:	e9 93 fd ff ff       	jmp    8004a3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800710:	83 fa 01             	cmp    $0x1,%edx
  800713:	7e 16                	jle    80072b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8d 50 08             	lea    0x8(%eax),%edx
  80071b:	89 55 14             	mov    %edx,0x14(%ebp)
  80071e:	8b 50 04             	mov    0x4(%eax),%edx
  800721:	8b 00                	mov    (%eax),%eax
  800723:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800726:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800729:	eb 32                	jmp    80075d <vprintfmt+0x2df>
	else if (lflag)
  80072b:	85 d2                	test   %edx,%edx
  80072d:	74 18                	je     800747 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8d 50 04             	lea    0x4(%eax),%edx
  800735:	89 55 14             	mov    %edx,0x14(%ebp)
  800738:	8b 30                	mov    (%eax),%esi
  80073a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80073d:	89 f0                	mov    %esi,%eax
  80073f:	c1 f8 1f             	sar    $0x1f,%eax
  800742:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800745:	eb 16                	jmp    80075d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8d 50 04             	lea    0x4(%eax),%edx
  80074d:	89 55 14             	mov    %edx,0x14(%ebp)
  800750:	8b 30                	mov    (%eax),%esi
  800752:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800755:	89 f0                	mov    %esi,%eax
  800757:	c1 f8 1f             	sar    $0x1f,%eax
  80075a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80075d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800760:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800763:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800768:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80076c:	0f 89 80 00 00 00    	jns    8007f2 <vprintfmt+0x374>
				putch('-', putdat);
  800772:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800776:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80077d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800780:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800783:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800786:	f7 d8                	neg    %eax
  800788:	83 d2 00             	adc    $0x0,%edx
  80078b:	f7 da                	neg    %edx
			}
			base = 10;
  80078d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800792:	eb 5e                	jmp    8007f2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800794:	8d 45 14             	lea    0x14(%ebp),%eax
  800797:	e8 63 fc ff ff       	call   8003ff <getuint>
			base = 10;
  80079c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007a1:	eb 4f                	jmp    8007f2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8007a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a6:	e8 54 fc ff ff       	call   8003ff <getuint>
			base = 8;
  8007ab:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007b0:	eb 40                	jmp    8007f2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  8007b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007b6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007bd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007cb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8d 50 04             	lea    0x4(%eax),%edx
  8007d4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007de:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007e3:	eb 0d                	jmp    8007f2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e8:	e8 12 fc ff ff       	call   8003ff <getuint>
			base = 16;
  8007ed:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007f2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8007f6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007fa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8007fd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800801:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800805:	89 04 24             	mov    %eax,(%esp)
  800808:	89 54 24 04          	mov    %edx,0x4(%esp)
  80080c:	89 fa                	mov    %edi,%edx
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	e8 fa fa ff ff       	call   800310 <printnum>
			break;
  800816:	e9 88 fc ff ff       	jmp    8004a3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80081b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80081f:	89 04 24             	mov    %eax,(%esp)
  800822:	ff 55 08             	call   *0x8(%ebp)
			break;
  800825:	e9 79 fc ff ff       	jmp    8004a3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80082a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80082e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800835:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800838:	89 f3                	mov    %esi,%ebx
  80083a:	eb 03                	jmp    80083f <vprintfmt+0x3c1>
  80083c:	83 eb 01             	sub    $0x1,%ebx
  80083f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800843:	75 f7                	jne    80083c <vprintfmt+0x3be>
  800845:	e9 59 fc ff ff       	jmp    8004a3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80084a:	83 c4 3c             	add    $0x3c,%esp
  80084d:	5b                   	pop    %ebx
  80084e:	5e                   	pop    %esi
  80084f:	5f                   	pop    %edi
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	83 ec 28             	sub    $0x28,%esp
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80085e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800861:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800865:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800868:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80086f:	85 c0                	test   %eax,%eax
  800871:	74 30                	je     8008a3 <vsnprintf+0x51>
  800873:	85 d2                	test   %edx,%edx
  800875:	7e 2c                	jle    8008a3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80087e:	8b 45 10             	mov    0x10(%ebp),%eax
  800881:	89 44 24 08          	mov    %eax,0x8(%esp)
  800885:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800888:	89 44 24 04          	mov    %eax,0x4(%esp)
  80088c:	c7 04 24 39 04 80 00 	movl   $0x800439,(%esp)
  800893:	e8 e6 fb ff ff       	call   80047e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800898:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80089b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80089e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a1:	eb 05                	jmp    8008a8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008a8:	c9                   	leave  
  8008a9:	c3                   	ret    

008008aa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008b0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	89 04 24             	mov    %eax,(%esp)
  8008cb:	e8 82 ff ff ff       	call   800852 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008d0:	c9                   	leave  
  8008d1:	c3                   	ret    
  8008d2:	66 90                	xchg   %ax,%ax
  8008d4:	66 90                	xchg   %ax,%ax
  8008d6:	66 90                	xchg   %ax,%ax
  8008d8:	66 90                	xchg   %ax,%ax
  8008da:	66 90                	xchg   %ax,%ax
  8008dc:	66 90                	xchg   %ax,%ax
  8008de:	66 90                	xchg   %ax,%ax

008008e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008eb:	eb 03                	jmp    8008f0 <strlen+0x10>
		n++;
  8008ed:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008f4:	75 f7                	jne    8008ed <strlen+0xd>
		n++;
	return n;
}
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800901:	b8 00 00 00 00       	mov    $0x0,%eax
  800906:	eb 03                	jmp    80090b <strnlen+0x13>
		n++;
  800908:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090b:	39 d0                	cmp    %edx,%eax
  80090d:	74 06                	je     800915 <strnlen+0x1d>
  80090f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800913:	75 f3                	jne    800908 <strnlen+0x10>
		n++;
	return n;
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	53                   	push   %ebx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800921:	89 c2                	mov    %eax,%edx
  800923:	83 c2 01             	add    $0x1,%edx
  800926:	83 c1 01             	add    $0x1,%ecx
  800929:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80092d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800930:	84 db                	test   %bl,%bl
  800932:	75 ef                	jne    800923 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800934:	5b                   	pop    %ebx
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	53                   	push   %ebx
  80093b:	83 ec 08             	sub    $0x8,%esp
  80093e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800941:	89 1c 24             	mov    %ebx,(%esp)
  800944:	e8 97 ff ff ff       	call   8008e0 <strlen>
	strcpy(dst + len, src);
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800950:	01 d8                	add    %ebx,%eax
  800952:	89 04 24             	mov    %eax,(%esp)
  800955:	e8 bd ff ff ff       	call   800917 <strcpy>
	return dst;
}
  80095a:	89 d8                	mov    %ebx,%eax
  80095c:	83 c4 08             	add    $0x8,%esp
  80095f:	5b                   	pop    %ebx
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	56                   	push   %esi
  800966:	53                   	push   %ebx
  800967:	8b 75 08             	mov    0x8(%ebp),%esi
  80096a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80096d:	89 f3                	mov    %esi,%ebx
  80096f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800972:	89 f2                	mov    %esi,%edx
  800974:	eb 0f                	jmp    800985 <strncpy+0x23>
		*dst++ = *src;
  800976:	83 c2 01             	add    $0x1,%edx
  800979:	0f b6 01             	movzbl (%ecx),%eax
  80097c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80097f:	80 39 01             	cmpb   $0x1,(%ecx)
  800982:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800985:	39 da                	cmp    %ebx,%edx
  800987:	75 ed                	jne    800976 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800989:	89 f0                	mov    %esi,%eax
  80098b:	5b                   	pop    %ebx
  80098c:	5e                   	pop    %esi
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    

0080098f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	56                   	push   %esi
  800993:	53                   	push   %ebx
  800994:	8b 75 08             	mov    0x8(%ebp),%esi
  800997:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80099d:	89 f0                	mov    %esi,%eax
  80099f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009a3:	85 c9                	test   %ecx,%ecx
  8009a5:	75 0b                	jne    8009b2 <strlcpy+0x23>
  8009a7:	eb 1d                	jmp    8009c6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009a9:	83 c0 01             	add    $0x1,%eax
  8009ac:	83 c2 01             	add    $0x1,%edx
  8009af:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009b2:	39 d8                	cmp    %ebx,%eax
  8009b4:	74 0b                	je     8009c1 <strlcpy+0x32>
  8009b6:	0f b6 0a             	movzbl (%edx),%ecx
  8009b9:	84 c9                	test   %cl,%cl
  8009bb:	75 ec                	jne    8009a9 <strlcpy+0x1a>
  8009bd:	89 c2                	mov    %eax,%edx
  8009bf:	eb 02                	jmp    8009c3 <strlcpy+0x34>
  8009c1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8009c3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8009c6:	29 f0                	sub    %esi,%eax
}
  8009c8:	5b                   	pop    %ebx
  8009c9:	5e                   	pop    %esi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009d5:	eb 06                	jmp    8009dd <strcmp+0x11>
		p++, q++;
  8009d7:	83 c1 01             	add    $0x1,%ecx
  8009da:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009dd:	0f b6 01             	movzbl (%ecx),%eax
  8009e0:	84 c0                	test   %al,%al
  8009e2:	74 04                	je     8009e8 <strcmp+0x1c>
  8009e4:	3a 02                	cmp    (%edx),%al
  8009e6:	74 ef                	je     8009d7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e8:	0f b6 c0             	movzbl %al,%eax
  8009eb:	0f b6 12             	movzbl (%edx),%edx
  8009ee:	29 d0                	sub    %edx,%eax
}
  8009f0:	5d                   	pop    %ebp
  8009f1:	c3                   	ret    

008009f2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	53                   	push   %ebx
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fc:	89 c3                	mov    %eax,%ebx
  8009fe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a01:	eb 06                	jmp    800a09 <strncmp+0x17>
		n--, p++, q++;
  800a03:	83 c0 01             	add    $0x1,%eax
  800a06:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a09:	39 d8                	cmp    %ebx,%eax
  800a0b:	74 15                	je     800a22 <strncmp+0x30>
  800a0d:	0f b6 08             	movzbl (%eax),%ecx
  800a10:	84 c9                	test   %cl,%cl
  800a12:	74 04                	je     800a18 <strncmp+0x26>
  800a14:	3a 0a                	cmp    (%edx),%cl
  800a16:	74 eb                	je     800a03 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a18:	0f b6 00             	movzbl (%eax),%eax
  800a1b:	0f b6 12             	movzbl (%edx),%edx
  800a1e:	29 d0                	sub    %edx,%eax
  800a20:	eb 05                	jmp    800a27 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a22:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a27:	5b                   	pop    %ebx
  800a28:	5d                   	pop    %ebp
  800a29:	c3                   	ret    

00800a2a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a34:	eb 07                	jmp    800a3d <strchr+0x13>
		if (*s == c)
  800a36:	38 ca                	cmp    %cl,%dl
  800a38:	74 0f                	je     800a49 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a3a:	83 c0 01             	add    $0x1,%eax
  800a3d:	0f b6 10             	movzbl (%eax),%edx
  800a40:	84 d2                	test   %dl,%dl
  800a42:	75 f2                	jne    800a36 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a55:	eb 07                	jmp    800a5e <strfind+0x13>
		if (*s == c)
  800a57:	38 ca                	cmp    %cl,%dl
  800a59:	74 0a                	je     800a65 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a5b:	83 c0 01             	add    $0x1,%eax
  800a5e:	0f b6 10             	movzbl (%eax),%edx
  800a61:	84 d2                	test   %dl,%dl
  800a63:	75 f2                	jne    800a57 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	57                   	push   %edi
  800a6b:	56                   	push   %esi
  800a6c:	53                   	push   %ebx
  800a6d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a70:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a73:	85 c9                	test   %ecx,%ecx
  800a75:	74 36                	je     800aad <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a77:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a7d:	75 28                	jne    800aa7 <memset+0x40>
  800a7f:	f6 c1 03             	test   $0x3,%cl
  800a82:	75 23                	jne    800aa7 <memset+0x40>
		c &= 0xFF;
  800a84:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a88:	89 d3                	mov    %edx,%ebx
  800a8a:	c1 e3 08             	shl    $0x8,%ebx
  800a8d:	89 d6                	mov    %edx,%esi
  800a8f:	c1 e6 18             	shl    $0x18,%esi
  800a92:	89 d0                	mov    %edx,%eax
  800a94:	c1 e0 10             	shl    $0x10,%eax
  800a97:	09 f0                	or     %esi,%eax
  800a99:	09 c2                	or     %eax,%edx
  800a9b:	89 d0                	mov    %edx,%eax
  800a9d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a9f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800aa2:	fc                   	cld    
  800aa3:	f3 ab                	rep stos %eax,%es:(%edi)
  800aa5:	eb 06                	jmp    800aad <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaa:	fc                   	cld    
  800aab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aad:	89 f8                	mov    %edi,%eax
  800aaf:	5b                   	pop    %ebx
  800ab0:	5e                   	pop    %esi
  800ab1:	5f                   	pop    %edi
  800ab2:	5d                   	pop    %ebp
  800ab3:	c3                   	ret    

00800ab4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	57                   	push   %edi
  800ab8:	56                   	push   %esi
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800abf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ac2:	39 c6                	cmp    %eax,%esi
  800ac4:	73 35                	jae    800afb <memmove+0x47>
  800ac6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ac9:	39 d0                	cmp    %edx,%eax
  800acb:	73 2e                	jae    800afb <memmove+0x47>
		s += n;
		d += n;
  800acd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ad0:	89 d6                	mov    %edx,%esi
  800ad2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ada:	75 13                	jne    800aef <memmove+0x3b>
  800adc:	f6 c1 03             	test   $0x3,%cl
  800adf:	75 0e                	jne    800aef <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ae1:	83 ef 04             	sub    $0x4,%edi
  800ae4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ae7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aea:	fd                   	std    
  800aeb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aed:	eb 09                	jmp    800af8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aef:	83 ef 01             	sub    $0x1,%edi
  800af2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800af5:	fd                   	std    
  800af6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800af8:	fc                   	cld    
  800af9:	eb 1d                	jmp    800b18 <memmove+0x64>
  800afb:	89 f2                	mov    %esi,%edx
  800afd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aff:	f6 c2 03             	test   $0x3,%dl
  800b02:	75 0f                	jne    800b13 <memmove+0x5f>
  800b04:	f6 c1 03             	test   $0x3,%cl
  800b07:	75 0a                	jne    800b13 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b09:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b0c:	89 c7                	mov    %eax,%edi
  800b0e:	fc                   	cld    
  800b0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b11:	eb 05                	jmp    800b18 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b13:	89 c7                	mov    %eax,%edi
  800b15:	fc                   	cld    
  800b16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b18:	5e                   	pop    %esi
  800b19:	5f                   	pop    %edi
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b22:	8b 45 10             	mov    0x10(%ebp),%eax
  800b25:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	89 04 24             	mov    %eax,(%esp)
  800b36:	e8 79 ff ff ff       	call   800ab4 <memmove>
}
  800b3b:	c9                   	leave  
  800b3c:	c3                   	ret    

00800b3d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	56                   	push   %esi
  800b41:	53                   	push   %ebx
  800b42:	8b 55 08             	mov    0x8(%ebp),%edx
  800b45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b48:	89 d6                	mov    %edx,%esi
  800b4a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4d:	eb 1a                	jmp    800b69 <memcmp+0x2c>
		if (*s1 != *s2)
  800b4f:	0f b6 02             	movzbl (%edx),%eax
  800b52:	0f b6 19             	movzbl (%ecx),%ebx
  800b55:	38 d8                	cmp    %bl,%al
  800b57:	74 0a                	je     800b63 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b59:	0f b6 c0             	movzbl %al,%eax
  800b5c:	0f b6 db             	movzbl %bl,%ebx
  800b5f:	29 d8                	sub    %ebx,%eax
  800b61:	eb 0f                	jmp    800b72 <memcmp+0x35>
		s1++, s2++;
  800b63:	83 c2 01             	add    $0x1,%edx
  800b66:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b69:	39 f2                	cmp    %esi,%edx
  800b6b:	75 e2                	jne    800b4f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b72:	5b                   	pop    %ebx
  800b73:	5e                   	pop    %esi
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b7f:	89 c2                	mov    %eax,%edx
  800b81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b84:	eb 07                	jmp    800b8d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b86:	38 08                	cmp    %cl,(%eax)
  800b88:	74 07                	je     800b91 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b8a:	83 c0 01             	add    $0x1,%eax
  800b8d:	39 d0                	cmp    %edx,%eax
  800b8f:	72 f5                	jb     800b86 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    

00800b93 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	57                   	push   %edi
  800b97:	56                   	push   %esi
  800b98:	53                   	push   %ebx
  800b99:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9f:	eb 03                	jmp    800ba4 <strtol+0x11>
		s++;
  800ba1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ba4:	0f b6 0a             	movzbl (%edx),%ecx
  800ba7:	80 f9 09             	cmp    $0x9,%cl
  800baa:	74 f5                	je     800ba1 <strtol+0xe>
  800bac:	80 f9 20             	cmp    $0x20,%cl
  800baf:	74 f0                	je     800ba1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bb1:	80 f9 2b             	cmp    $0x2b,%cl
  800bb4:	75 0a                	jne    800bc0 <strtol+0x2d>
		s++;
  800bb6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bb9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bbe:	eb 11                	jmp    800bd1 <strtol+0x3e>
  800bc0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bc5:	80 f9 2d             	cmp    $0x2d,%cl
  800bc8:	75 07                	jne    800bd1 <strtol+0x3e>
		s++, neg = 1;
  800bca:	8d 52 01             	lea    0x1(%edx),%edx
  800bcd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800bd6:	75 15                	jne    800bed <strtol+0x5a>
  800bd8:	80 3a 30             	cmpb   $0x30,(%edx)
  800bdb:	75 10                	jne    800bed <strtol+0x5a>
  800bdd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800be1:	75 0a                	jne    800bed <strtol+0x5a>
		s += 2, base = 16;
  800be3:	83 c2 02             	add    $0x2,%edx
  800be6:	b8 10 00 00 00       	mov    $0x10,%eax
  800beb:	eb 10                	jmp    800bfd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800bed:	85 c0                	test   %eax,%eax
  800bef:	75 0c                	jne    800bfd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bf3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bf6:	75 05                	jne    800bfd <strtol+0x6a>
		s++, base = 8;
  800bf8:	83 c2 01             	add    $0x1,%edx
  800bfb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bfd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c02:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c05:	0f b6 0a             	movzbl (%edx),%ecx
  800c08:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c0b:	89 f0                	mov    %esi,%eax
  800c0d:	3c 09                	cmp    $0x9,%al
  800c0f:	77 08                	ja     800c19 <strtol+0x86>
			dig = *s - '0';
  800c11:	0f be c9             	movsbl %cl,%ecx
  800c14:	83 e9 30             	sub    $0x30,%ecx
  800c17:	eb 20                	jmp    800c39 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c19:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c1c:	89 f0                	mov    %esi,%eax
  800c1e:	3c 19                	cmp    $0x19,%al
  800c20:	77 08                	ja     800c2a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c22:	0f be c9             	movsbl %cl,%ecx
  800c25:	83 e9 57             	sub    $0x57,%ecx
  800c28:	eb 0f                	jmp    800c39 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c2a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c2d:	89 f0                	mov    %esi,%eax
  800c2f:	3c 19                	cmp    $0x19,%al
  800c31:	77 16                	ja     800c49 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c33:	0f be c9             	movsbl %cl,%ecx
  800c36:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c39:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c3c:	7d 0f                	jge    800c4d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c3e:	83 c2 01             	add    $0x1,%edx
  800c41:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c45:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c47:	eb bc                	jmp    800c05 <strtol+0x72>
  800c49:	89 d8                	mov    %ebx,%eax
  800c4b:	eb 02                	jmp    800c4f <strtol+0xbc>
  800c4d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c53:	74 05                	je     800c5a <strtol+0xc7>
		*endptr = (char *) s;
  800c55:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c58:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c5a:	f7 d8                	neg    %eax
  800c5c:	85 ff                	test   %edi,%edi
  800c5e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c61:	5b                   	pop    %ebx
  800c62:	5e                   	pop    %esi
  800c63:	5f                   	pop    %edi
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	57                   	push   %edi
  800c6a:	56                   	push   %esi
  800c6b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c74:	8b 55 08             	mov    0x8(%ebp),%edx
  800c77:	89 c3                	mov    %eax,%ebx
  800c79:	89 c7                	mov    %eax,%edi
  800c7b:	89 c6                	mov    %eax,%esi
  800c7d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c7f:	5b                   	pop    %ebx
  800c80:	5e                   	pop    %esi
  800c81:	5f                   	pop    %edi
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    

00800c84 <sys_cgetc>:

int
sys_cgetc(void)
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
  800c8f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c94:	89 d1                	mov    %edx,%ecx
  800c96:	89 d3                	mov    %edx,%ebx
  800c98:	89 d7                	mov    %edx,%edi
  800c9a:	89 d6                	mov    %edx,%esi
  800c9c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c9e:	5b                   	pop    %ebx
  800c9f:	5e                   	pop    %esi
  800ca0:	5f                   	pop    %edi
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    

00800ca3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800cac:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb9:	89 cb                	mov    %ecx,%ebx
  800cbb:	89 cf                	mov    %ecx,%edi
  800cbd:	89 ce                	mov    %ecx,%esi
  800cbf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cc1:	85 c0                	test   %eax,%eax
  800cc3:	7e 28                	jle    800ced <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cc9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cd0:	00 
  800cd1:	c7 44 24 08 eb 30 80 	movl   $0x8030eb,0x8(%esp)
  800cd8:	00 
  800cd9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ce0:	00 
  800ce1:	c7 04 24 08 31 80 00 	movl   $0x803108,(%esp)
  800ce8:	e8 29 1c 00 00       	call   802916 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ced:	83 c4 2c             	add    $0x2c,%esp
  800cf0:	5b                   	pop    %ebx
  800cf1:	5e                   	pop    %esi
  800cf2:	5f                   	pop    %edi
  800cf3:	5d                   	pop    %ebp
  800cf4:	c3                   	ret    

00800cf5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	57                   	push   %edi
  800cf9:	56                   	push   %esi
  800cfa:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800d00:	b8 02 00 00 00       	mov    $0x2,%eax
  800d05:	89 d1                	mov    %edx,%ecx
  800d07:	89 d3                	mov    %edx,%ebx
  800d09:	89 d7                	mov    %edx,%edi
  800d0b:	89 d6                	mov    %edx,%esi
  800d0d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <sys_yield>:

void
sys_yield(void)
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
  800d1f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d24:	89 d1                	mov    %edx,%ecx
  800d26:	89 d3                	mov    %edx,%ebx
  800d28:	89 d7                	mov    %edx,%edi
  800d2a:	89 d6                	mov    %edx,%esi
  800d2c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800d3c:	be 00 00 00 00       	mov    $0x0,%esi
  800d41:	b8 04 00 00 00       	mov    $0x4,%eax
  800d46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d49:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4f:	89 f7                	mov    %esi,%edi
  800d51:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d53:	85 c0                	test   %eax,%eax
  800d55:	7e 28                	jle    800d7f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d57:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d5b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d62:	00 
  800d63:	c7 44 24 08 eb 30 80 	movl   $0x8030eb,0x8(%esp)
  800d6a:	00 
  800d6b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d72:	00 
  800d73:	c7 04 24 08 31 80 00 	movl   $0x803108,(%esp)
  800d7a:	e8 97 1b 00 00       	call   802916 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d7f:	83 c4 2c             	add    $0x2c,%esp
  800d82:	5b                   	pop    %ebx
  800d83:	5e                   	pop    %esi
  800d84:	5f                   	pop    %edi
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	57                   	push   %edi
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
  800d8d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d90:	b8 05 00 00 00       	mov    $0x5,%eax
  800d95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d98:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da1:	8b 75 18             	mov    0x18(%ebp),%esi
  800da4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da6:	85 c0                	test   %eax,%eax
  800da8:	7e 28                	jle    800dd2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800daa:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dae:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800db5:	00 
  800db6:	c7 44 24 08 eb 30 80 	movl   $0x8030eb,0x8(%esp)
  800dbd:	00 
  800dbe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc5:	00 
  800dc6:	c7 04 24 08 31 80 00 	movl   $0x803108,(%esp)
  800dcd:	e8 44 1b 00 00       	call   802916 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dd2:	83 c4 2c             	add    $0x2c,%esp
  800dd5:	5b                   	pop    %ebx
  800dd6:	5e                   	pop    %esi
  800dd7:	5f                   	pop    %edi
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    

00800dda <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	57                   	push   %edi
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
  800de0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de8:	b8 06 00 00 00       	mov    $0x6,%eax
  800ded:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df0:	8b 55 08             	mov    0x8(%ebp),%edx
  800df3:	89 df                	mov    %ebx,%edi
  800df5:	89 de                	mov    %ebx,%esi
  800df7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	7e 28                	jle    800e25 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e01:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e08:	00 
  800e09:	c7 44 24 08 eb 30 80 	movl   $0x8030eb,0x8(%esp)
  800e10:	00 
  800e11:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e18:	00 
  800e19:	c7 04 24 08 31 80 00 	movl   $0x803108,(%esp)
  800e20:	e8 f1 1a 00 00       	call   802916 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e25:	83 c4 2c             	add    $0x2c,%esp
  800e28:	5b                   	pop    %ebx
  800e29:	5e                   	pop    %esi
  800e2a:	5f                   	pop    %edi
  800e2b:	5d                   	pop    %ebp
  800e2c:	c3                   	ret    

00800e2d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	57                   	push   %edi
  800e31:	56                   	push   %esi
  800e32:	53                   	push   %ebx
  800e33:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e36:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e43:	8b 55 08             	mov    0x8(%ebp),%edx
  800e46:	89 df                	mov    %ebx,%edi
  800e48:	89 de                	mov    %ebx,%esi
  800e4a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e4c:	85 c0                	test   %eax,%eax
  800e4e:	7e 28                	jle    800e78 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e50:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e54:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e5b:	00 
  800e5c:	c7 44 24 08 eb 30 80 	movl   $0x8030eb,0x8(%esp)
  800e63:	00 
  800e64:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e6b:	00 
  800e6c:	c7 04 24 08 31 80 00 	movl   $0x803108,(%esp)
  800e73:	e8 9e 1a 00 00       	call   802916 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e78:	83 c4 2c             	add    $0x2c,%esp
  800e7b:	5b                   	pop    %ebx
  800e7c:	5e                   	pop    %esi
  800e7d:	5f                   	pop    %edi
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    

00800e80 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	57                   	push   %edi
  800e84:	56                   	push   %esi
  800e85:	53                   	push   %ebx
  800e86:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e89:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	89 df                	mov    %ebx,%edi
  800e9b:	89 de                	mov    %ebx,%esi
  800e9d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e9f:	85 c0                	test   %eax,%eax
  800ea1:	7e 28                	jle    800ecb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800eae:	00 
  800eaf:	c7 44 24 08 eb 30 80 	movl   $0x8030eb,0x8(%esp)
  800eb6:	00 
  800eb7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ebe:	00 
  800ebf:	c7 04 24 08 31 80 00 	movl   $0x803108,(%esp)
  800ec6:	e8 4b 1a 00 00       	call   802916 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ecb:	83 c4 2c             	add    $0x2c,%esp
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
  800ed9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800edc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ee6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eec:	89 df                	mov    %ebx,%edi
  800eee:	89 de                	mov    %ebx,%esi
  800ef0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef2:	85 c0                	test   %eax,%eax
  800ef4:	7e 28                	jle    800f1e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800efa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f01:	00 
  800f02:	c7 44 24 08 eb 30 80 	movl   $0x8030eb,0x8(%esp)
  800f09:	00 
  800f0a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f11:	00 
  800f12:	c7 04 24 08 31 80 00 	movl   $0x803108,(%esp)
  800f19:	e8 f8 19 00 00       	call   802916 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f1e:	83 c4 2c             	add    $0x2c,%esp
  800f21:	5b                   	pop    %ebx
  800f22:	5e                   	pop    %esi
  800f23:	5f                   	pop    %edi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	57                   	push   %edi
  800f2a:	56                   	push   %esi
  800f2b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2c:	be 00 00 00 00       	mov    $0x0,%esi
  800f31:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f39:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f42:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f44:	5b                   	pop    %ebx
  800f45:	5e                   	pop    %esi
  800f46:	5f                   	pop    %edi
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    

00800f49 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	57                   	push   %edi
  800f4d:	56                   	push   %esi
  800f4e:	53                   	push   %ebx
  800f4f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f57:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5f:	89 cb                	mov    %ecx,%ebx
  800f61:	89 cf                	mov    %ecx,%edi
  800f63:	89 ce                	mov    %ecx,%esi
  800f65:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f67:	85 c0                	test   %eax,%eax
  800f69:	7e 28                	jle    800f93 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f6f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f76:	00 
  800f77:	c7 44 24 08 eb 30 80 	movl   $0x8030eb,0x8(%esp)
  800f7e:	00 
  800f7f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f86:	00 
  800f87:	c7 04 24 08 31 80 00 	movl   $0x803108,(%esp)
  800f8e:	e8 83 19 00 00       	call   802916 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f93:	83 c4 2c             	add    $0x2c,%esp
  800f96:	5b                   	pop    %ebx
  800f97:	5e                   	pop    %esi
  800f98:	5f                   	pop    %edi
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    

00800f9b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	57                   	push   %edi
  800f9f:	56                   	push   %esi
  800fa0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fab:	89 d1                	mov    %edx,%ecx
  800fad:	89 d3                	mov    %edx,%ebx
  800faf:	89 d7                	mov    %edx,%edi
  800fb1:	89 d6                	mov    %edx,%esi
  800fb3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fb5:	5b                   	pop    %ebx
  800fb6:	5e                   	pop    %esi
  800fb7:	5f                   	pop    %edi
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	57                   	push   %edi
  800fbe:	56                   	push   %esi
  800fbf:	53                   	push   %ebx
  800fc0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fcd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd3:	89 df                	mov    %ebx,%edi
  800fd5:	89 de                	mov    %ebx,%esi
  800fd7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fd9:	85 c0                	test   %eax,%eax
  800fdb:	7e 28                	jle    801005 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fdd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800fe8:	00 
  800fe9:	c7 44 24 08 eb 30 80 	movl   $0x8030eb,0x8(%esp)
  800ff0:	00 
  800ff1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff8:	00 
  800ff9:	c7 04 24 08 31 80 00 	movl   $0x803108,(%esp)
  801000:	e8 11 19 00 00       	call   802916 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  801005:	83 c4 2c             	add    $0x2c,%esp
  801008:	5b                   	pop    %ebx
  801009:	5e                   	pop    %esi
  80100a:	5f                   	pop    %edi
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    

0080100d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	57                   	push   %edi
  801011:	56                   	push   %esi
  801012:	53                   	push   %ebx
  801013:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801016:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101b:	b8 10 00 00 00       	mov    $0x10,%eax
  801020:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801023:	8b 55 08             	mov    0x8(%ebp),%edx
  801026:	89 df                	mov    %ebx,%edi
  801028:	89 de                	mov    %ebx,%esi
  80102a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80102c:	85 c0                	test   %eax,%eax
  80102e:	7e 28                	jle    801058 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801030:	89 44 24 10          	mov    %eax,0x10(%esp)
  801034:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80103b:	00 
  80103c:	c7 44 24 08 eb 30 80 	movl   $0x8030eb,0x8(%esp)
  801043:	00 
  801044:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80104b:	00 
  80104c:	c7 04 24 08 31 80 00 	movl   $0x803108,(%esp)
  801053:	e8 be 18 00 00       	call   802916 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  801058:	83 c4 2c             	add    $0x2c,%esp
  80105b:	5b                   	pop    %ebx
  80105c:	5e                   	pop    %esi
  80105d:	5f                   	pop    %edi
  80105e:	5d                   	pop    %ebp
  80105f:	c3                   	ret    

00801060 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	57                   	push   %edi
  801064:	56                   	push   %esi
  801065:	53                   	push   %ebx
  801066:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801069:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106e:	b8 11 00 00 00       	mov    $0x11,%eax
  801073:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801076:	8b 55 08             	mov    0x8(%ebp),%edx
  801079:	89 df                	mov    %ebx,%edi
  80107b:	89 de                	mov    %ebx,%esi
  80107d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80107f:	85 c0                	test   %eax,%eax
  801081:	7e 28                	jle    8010ab <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801083:	89 44 24 10          	mov    %eax,0x10(%esp)
  801087:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  80108e:	00 
  80108f:	c7 44 24 08 eb 30 80 	movl   $0x8030eb,0x8(%esp)
  801096:	00 
  801097:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80109e:	00 
  80109f:	c7 04 24 08 31 80 00 	movl   $0x803108,(%esp)
  8010a6:	e8 6b 18 00 00       	call   802916 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  8010ab:	83 c4 2c             	add    $0x2c,%esp
  8010ae:	5b                   	pop    %ebx
  8010af:	5e                   	pop    %esi
  8010b0:	5f                   	pop    %edi
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    

008010b3 <sys_sleep>:

int
sys_sleep(int channel)
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
  8010bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010c1:	b8 12 00 00 00       	mov    $0x12,%eax
  8010c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c9:	89 cb                	mov    %ecx,%ebx
  8010cb:	89 cf                	mov    %ecx,%edi
  8010cd:	89 ce                	mov    %ecx,%esi
  8010cf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	7e 28                	jle    8010fd <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010d9:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8010e0:	00 
  8010e1:	c7 44 24 08 eb 30 80 	movl   $0x8030eb,0x8(%esp)
  8010e8:	00 
  8010e9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f0:	00 
  8010f1:	c7 04 24 08 31 80 00 	movl   $0x803108,(%esp)
  8010f8:	e8 19 18 00 00       	call   802916 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  8010fd:	83 c4 2c             	add    $0x2c,%esp
  801100:	5b                   	pop    %ebx
  801101:	5e                   	pop    %esi
  801102:	5f                   	pop    %edi
  801103:	5d                   	pop    %ebp
  801104:	c3                   	ret    

00801105 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	57                   	push   %edi
  801109:	56                   	push   %esi
  80110a:	53                   	push   %ebx
  80110b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80110e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801113:	b8 13 00 00 00       	mov    $0x13,%eax
  801118:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111b:	8b 55 08             	mov    0x8(%ebp),%edx
  80111e:	89 df                	mov    %ebx,%edi
  801120:	89 de                	mov    %ebx,%esi
  801122:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801124:	85 c0                	test   %eax,%eax
  801126:	7e 28                	jle    801150 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801128:	89 44 24 10          	mov    %eax,0x10(%esp)
  80112c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801133:	00 
  801134:	c7 44 24 08 eb 30 80 	movl   $0x8030eb,0x8(%esp)
  80113b:	00 
  80113c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801143:	00 
  801144:	c7 04 24 08 31 80 00 	movl   $0x803108,(%esp)
  80114b:	e8 c6 17 00 00       	call   802916 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801150:	83 c4 2c             	add    $0x2c,%esp
  801153:	5b                   	pop    %ebx
  801154:	5e                   	pop    %esi
  801155:	5f                   	pop    %edi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    

00801158 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	53                   	push   %ebx
  80115c:	83 ec 24             	sub    $0x24,%esp
  80115f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801162:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(((err & FEC_WR) == 0) || ((uvpd[PDX(addr)] & PTE_P) == 0) || (((~uvpt[PGNUM(addr)])&(PTE_COW|PTE_P)) != 0)) {
  801164:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801168:	74 27                	je     801191 <pgfault+0x39>
  80116a:	89 c2                	mov    %eax,%edx
  80116c:	c1 ea 16             	shr    $0x16,%edx
  80116f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801176:	f6 c2 01             	test   $0x1,%dl
  801179:	74 16                	je     801191 <pgfault+0x39>
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	c1 ea 0c             	shr    $0xc,%edx
  801180:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801187:	f7 d2                	not    %edx
  801189:	f7 c2 01 08 00 00    	test   $0x801,%edx
  80118f:	74 1c                	je     8011ad <pgfault+0x55>
		panic("pgfault");
  801191:	c7 44 24 08 16 31 80 	movl   $0x803116,0x8(%esp)
  801198:	00 
  801199:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  8011a0:	00 
  8011a1:	c7 04 24 1e 31 80 00 	movl   $0x80311e,(%esp)
  8011a8:	e8 69 17 00 00       	call   802916 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	addr = (void*)ROUNDDOWN(addr,PGSIZE);
  8011ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011b2:	89 c3                	mov    %eax,%ebx
	
	if(sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U) < 0) {
  8011b4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8011bb:	00 
  8011bc:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011c3:	00 
  8011c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011cb:	e8 63 fb ff ff       	call   800d33 <sys_page_alloc>
  8011d0:	85 c0                	test   %eax,%eax
  8011d2:	79 1c                	jns    8011f0 <pgfault+0x98>
		panic("pgfault(): sys_page_alloc");
  8011d4:	c7 44 24 08 29 31 80 	movl   $0x803129,0x8(%esp)
  8011db:	00 
  8011dc:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8011e3:	00 
  8011e4:	c7 04 24 1e 31 80 00 	movl   $0x80311e,(%esp)
  8011eb:	e8 26 17 00 00       	call   802916 <_panic>
	}
	memcpy((void*)PFTEMP, addr, PGSIZE);
  8011f0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8011f7:	00 
  8011f8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011fc:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801203:	e8 14 f9 ff ff       	call   800b1c <memcpy>

	if(sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0) {
  801208:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80120f:	00 
  801210:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801214:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80121b:	00 
  80121c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801223:	00 
  801224:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80122b:	e8 57 fb ff ff       	call   800d87 <sys_page_map>
  801230:	85 c0                	test   %eax,%eax
  801232:	79 1c                	jns    801250 <pgfault+0xf8>
		panic("pgfault(): sys_page_map");
  801234:	c7 44 24 08 43 31 80 	movl   $0x803143,0x8(%esp)
  80123b:	00 
  80123c:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801243:	00 
  801244:	c7 04 24 1e 31 80 00 	movl   $0x80311e,(%esp)
  80124b:	e8 c6 16 00 00       	call   802916 <_panic>
	}

	if(sys_page_unmap(0, (void*)PFTEMP) < 0) {
  801250:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801257:	00 
  801258:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80125f:	e8 76 fb ff ff       	call   800dda <sys_page_unmap>
  801264:	85 c0                	test   %eax,%eax
  801266:	79 1c                	jns    801284 <pgfault+0x12c>
		panic("pgfault(): sys_page_unmap");
  801268:	c7 44 24 08 5b 31 80 	movl   $0x80315b,0x8(%esp)
  80126f:	00 
  801270:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801277:	00 
  801278:	c7 04 24 1e 31 80 00 	movl   $0x80311e,(%esp)
  80127f:	e8 92 16 00 00       	call   802916 <_panic>
	}
}
  801284:	83 c4 24             	add    $0x24,%esp
  801287:	5b                   	pop    %ebx
  801288:	5d                   	pop    %ebp
  801289:	c3                   	ret    

0080128a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	57                   	push   %edi
  80128e:	56                   	push   %esi
  80128f:	53                   	push   %ebx
  801290:	83 ec 2c             	sub    $0x2c,%esp
	set_pgfault_handler(pgfault);
  801293:	c7 04 24 58 11 80 00 	movl   $0x801158,(%esp)
  80129a:	e8 cd 16 00 00       	call   80296c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80129f:	b8 07 00 00 00       	mov    $0x7,%eax
  8012a4:	cd 30                	int    $0x30
  8012a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t env_id = sys_exofork();
	if(env_id < 0){
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	79 1c                	jns    8012c9 <fork+0x3f>
		panic("fork(): sys_exofork");
  8012ad:	c7 44 24 08 75 31 80 	movl   $0x803175,0x8(%esp)
  8012b4:	00 
  8012b5:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  8012bc:	00 
  8012bd:	c7 04 24 1e 31 80 00 	movl   $0x80311e,(%esp)
  8012c4:	e8 4d 16 00 00       	call   802916 <_panic>
  8012c9:	89 c7                	mov    %eax,%edi
	}
	else if(env_id == 0){
  8012cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012cf:	74 0a                	je     8012db <fork+0x51>
  8012d1:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8012d6:	e9 9d 01 00 00       	jmp    801478 <fork+0x1ee>
		thisenv = envs + ENVX(sys_getenvid());
  8012db:	e8 15 fa ff ff       	call   800cf5 <sys_getenvid>
  8012e0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012e5:	89 c2                	mov    %eax,%edx
  8012e7:	c1 e2 07             	shl    $0x7,%edx
  8012ea:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8012f1:	a3 08 50 80 00       	mov    %eax,0x805008
		return env_id;
  8012f6:	e9 2a 02 00 00       	jmp    801525 <fork+0x29b>
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
		if(addr == UXSTACKTOP - PGSIZE){
  8012fb:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801301:	0f 84 6b 01 00 00    	je     801472 <fork+0x1e8>
			continue;
		}
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
  801307:	89 d8                	mov    %ebx,%eax
  801309:	c1 e8 16             	shr    $0x16,%eax
  80130c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801313:	a8 01                	test   $0x1,%al
  801315:	0f 84 57 01 00 00    	je     801472 <fork+0x1e8>
  80131b:	89 d8                	mov    %ebx,%eax
  80131d:	c1 e8 0c             	shr    $0xc,%eax
  801320:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801327:	f7 d0                	not    %eax
  801329:	a8 05                	test   $0x5,%al
  80132b:	0f 85 41 01 00 00    	jne    801472 <fork+0x1e8>
			duppage(env_id,addr/PGSIZE);
  801331:	89 d8                	mov    %ebx,%eax
  801333:	c1 e8 0c             	shr    $0xc,%eax
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void* addr = (void*)(pn*PGSIZE);
  801336:	89 c6                	mov    %eax,%esi
  801338:	c1 e6 0c             	shl    $0xc,%esi

	if (uvpt[pn] & PTE_SHARE) {
  80133b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801342:	f6 c6 04             	test   $0x4,%dh
  801345:	74 4c                	je     801393 <fork+0x109>
		if (sys_page_map(0, addr, envid, addr, uvpt[pn]&PTE_SYSCALL) < 0)
  801347:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80134e:	25 07 0e 00 00       	and    $0xe07,%eax
  801353:	89 44 24 10          	mov    %eax,0x10(%esp)
  801357:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80135b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80135f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801363:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80136a:	e8 18 fa ff ff       	call   800d87 <sys_page_map>
  80136f:	85 c0                	test   %eax,%eax
  801371:	0f 89 fb 00 00 00    	jns    801472 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801377:	c7 44 24 08 89 31 80 	movl   $0x803189,0x8(%esp)
  80137e:	00 
  80137f:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801386:	00 
  801387:	c7 04 24 1e 31 80 00 	movl   $0x80311e,(%esp)
  80138e:	e8 83 15 00 00       	call   802916 <_panic>
	} else if((uvpt[pn] & PTE_COW) || (uvpt[pn] & PTE_W)) {
  801393:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80139a:	f6 c6 08             	test   $0x8,%dh
  80139d:	75 0f                	jne    8013ae <fork+0x124>
  80139f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013a6:	a8 02                	test   $0x2,%al
  8013a8:	0f 84 84 00 00 00    	je     801432 <fork+0x1a8>
		if(sys_page_map(0, addr, envid, addr, PTE_COW | PTE_U | PTE_P) < 0){
  8013ae:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8013b5:	00 
  8013b6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013ba:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013c9:	e8 b9 f9 ff ff       	call   800d87 <sys_page_map>
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	79 1c                	jns    8013ee <fork+0x164>
			panic("duppage: sys_page_map");
  8013d2:	c7 44 24 08 89 31 80 	movl   $0x803189,0x8(%esp)
  8013d9:	00 
  8013da:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  8013e1:	00 
  8013e2:	c7 04 24 1e 31 80 00 	movl   $0x80311e,(%esp)
  8013e9:	e8 28 15 00 00       	call   802916 <_panic>
		}
		if(sys_page_map(0, addr, 0, addr, PTE_COW | PTE_U | PTE_P) < 0){
  8013ee:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8013f5:	00 
  8013f6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801401:	00 
  801402:	89 74 24 04          	mov    %esi,0x4(%esp)
  801406:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80140d:	e8 75 f9 ff ff       	call   800d87 <sys_page_map>
  801412:	85 c0                	test   %eax,%eax
  801414:	79 5c                	jns    801472 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801416:	c7 44 24 08 89 31 80 	movl   $0x803189,0x8(%esp)
  80141d:	00 
  80141e:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  801425:	00 
  801426:	c7 04 24 1e 31 80 00 	movl   $0x80311e,(%esp)
  80142d:	e8 e4 14 00 00       	call   802916 <_panic>
		}
	} else {
		if(sys_page_map(0, addr, envid, addr, PTE_U | PTE_P) < 0){
  801432:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801439:	00 
  80143a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80143e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801442:	89 74 24 04          	mov    %esi,0x4(%esp)
  801446:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80144d:	e8 35 f9 ff ff       	call   800d87 <sys_page_map>
  801452:	85 c0                	test   %eax,%eax
  801454:	79 1c                	jns    801472 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801456:	c7 44 24 08 89 31 80 	movl   $0x803189,0x8(%esp)
  80145d:	00 
  80145e:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  801465:	00 
  801466:	c7 04 24 1e 31 80 00 	movl   $0x80311e,(%esp)
  80146d:	e8 a4 14 00 00       	call   802916 <_panic>
		thisenv = envs + ENVX(sys_getenvid());
		return env_id;
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
  801472:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801478:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80147e:	0f 85 77 fe ff ff    	jne    8012fb <fork+0x71>
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
			duppage(env_id,addr/PGSIZE);
		}
	}

	if(sys_page_alloc(env_id, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) {
  801484:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80148b:	00 
  80148c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801493:	ee 
  801494:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801497:	89 04 24             	mov    %eax,(%esp)
  80149a:	e8 94 f8 ff ff       	call   800d33 <sys_page_alloc>
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	79 1c                	jns    8014bf <fork+0x235>
		panic("fork(): sys_page_alloc");
  8014a3:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  8014aa:	00 
  8014ab:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  8014b2:	00 
  8014b3:	c7 04 24 1e 31 80 00 	movl   $0x80311e,(%esp)
  8014ba:	e8 57 14 00 00       	call   802916 <_panic>
	}

	extern void _pgfault_upcall(void);
	if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0) {
  8014bf:	c7 44 24 04 f5 29 80 	movl   $0x8029f5,0x4(%esp)
  8014c6:	00 
  8014c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ca:	89 04 24             	mov    %eax,(%esp)
  8014cd:	e8 01 fa ff ff       	call   800ed3 <sys_env_set_pgfault_upcall>
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	79 1c                	jns    8014f2 <fork+0x268>
		panic("fork(): ys_env_set_pgfault_upcall");
  8014d6:	c7 44 24 08 e8 31 80 	movl   $0x8031e8,0x8(%esp)
  8014dd:	00 
  8014de:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  8014e5:	00 
  8014e6:	c7 04 24 1e 31 80 00 	movl   $0x80311e,(%esp)
  8014ed:	e8 24 14 00 00       	call   802916 <_panic>
	}

	if(sys_env_set_status(env_id, ENV_RUNNABLE) < 0) {
  8014f2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8014f9:	00 
  8014fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014fd:	89 04 24             	mov    %eax,(%esp)
  801500:	e8 28 f9 ff ff       	call   800e2d <sys_env_set_status>
  801505:	85 c0                	test   %eax,%eax
  801507:	79 1c                	jns    801525 <fork+0x29b>
		panic("fork(): sys_env_set_status");
  801509:	c7 44 24 08 b6 31 80 	movl   $0x8031b6,0x8(%esp)
  801510:	00 
  801511:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  801518:	00 
  801519:	c7 04 24 1e 31 80 00 	movl   $0x80311e,(%esp)
  801520:	e8 f1 13 00 00       	call   802916 <_panic>
	}

	return env_id;
}
  801525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801528:	83 c4 2c             	add    $0x2c,%esp
  80152b:	5b                   	pop    %ebx
  80152c:	5e                   	pop    %esi
  80152d:	5f                   	pop    %edi
  80152e:	5d                   	pop    %ebp
  80152f:	c3                   	ret    

00801530 <sfork>:

// Challenge!
int
sfork(void)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801536:	c7 44 24 08 d1 31 80 	movl   $0x8031d1,0x8(%esp)
  80153d:	00 
  80153e:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  801545:	00 
  801546:	c7 04 24 1e 31 80 00 	movl   $0x80311e,(%esp)
  80154d:	e8 c4 13 00 00       	call   802916 <_panic>
  801552:	66 90                	xchg   %ax,%ax
  801554:	66 90                	xchg   %ax,%ax
  801556:	66 90                	xchg   %ax,%ax
  801558:	66 90                	xchg   %ax,%ax
  80155a:	66 90                	xchg   %ax,%ax
  80155c:	66 90                	xchg   %ax,%ax
  80155e:	66 90                	xchg   %ax,%ax

00801560 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	56                   	push   %esi
  801564:	53                   	push   %ebx
  801565:	83 ec 10             	sub    $0x10,%esp
  801568:	8b 75 08             	mov    0x8(%ebp),%esi
  80156b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801571:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  801573:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801578:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80157b:	89 04 24             	mov    %eax,(%esp)
  80157e:	e8 c6 f9 ff ff       	call   800f49 <sys_ipc_recv>
  801583:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  801585:	85 d2                	test   %edx,%edx
  801587:	75 24                	jne    8015ad <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  801589:	85 f6                	test   %esi,%esi
  80158b:	74 0a                	je     801597 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80158d:	a1 08 50 80 00       	mov    0x805008,%eax
  801592:	8b 40 74             	mov    0x74(%eax),%eax
  801595:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  801597:	85 db                	test   %ebx,%ebx
  801599:	74 0a                	je     8015a5 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80159b:	a1 08 50 80 00       	mov    0x805008,%eax
  8015a0:	8b 40 78             	mov    0x78(%eax),%eax
  8015a3:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8015a5:	a1 08 50 80 00       	mov    0x805008,%eax
  8015aa:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	5b                   	pop    %ebx
  8015b1:	5e                   	pop    %esi
  8015b2:	5d                   	pop    %ebp
  8015b3:	c3                   	ret    

008015b4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	57                   	push   %edi
  8015b8:	56                   	push   %esi
  8015b9:	53                   	push   %ebx
  8015ba:	83 ec 1c             	sub    $0x1c,%esp
  8015bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015c0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  8015c6:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  8015c8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8015cd:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8015d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015db:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015df:	89 3c 24             	mov    %edi,(%esp)
  8015e2:	e8 3f f9 ff ff       	call   800f26 <sys_ipc_try_send>

		if (ret == 0)
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	74 2c                	je     801617 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  8015eb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8015ee:	74 20                	je     801610 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  8015f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015f4:	c7 44 24 08 0c 32 80 	movl   $0x80320c,0x8(%esp)
  8015fb:	00 
  8015fc:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  801603:	00 
  801604:	c7 04 24 3a 32 80 00 	movl   $0x80323a,(%esp)
  80160b:	e8 06 13 00 00       	call   802916 <_panic>
		}

		sys_yield();
  801610:	e8 ff f6 ff ff       	call   800d14 <sys_yield>
	}
  801615:	eb b9                	jmp    8015d0 <ipc_send+0x1c>
}
  801617:	83 c4 1c             	add    $0x1c,%esp
  80161a:	5b                   	pop    %ebx
  80161b:	5e                   	pop    %esi
  80161c:	5f                   	pop    %edi
  80161d:	5d                   	pop    %ebp
  80161e:	c3                   	ret    

0080161f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801625:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80162a:	89 c2                	mov    %eax,%edx
  80162c:	c1 e2 07             	shl    $0x7,%edx
  80162f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  801636:	8b 52 50             	mov    0x50(%edx),%edx
  801639:	39 ca                	cmp    %ecx,%edx
  80163b:	75 11                	jne    80164e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80163d:	89 c2                	mov    %eax,%edx
  80163f:	c1 e2 07             	shl    $0x7,%edx
  801642:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  801649:	8b 40 40             	mov    0x40(%eax),%eax
  80164c:	eb 0e                	jmp    80165c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80164e:	83 c0 01             	add    $0x1,%eax
  801651:	3d 00 04 00 00       	cmp    $0x400,%eax
  801656:	75 d2                	jne    80162a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801658:	66 b8 00 00          	mov    $0x0,%ax
}
  80165c:	5d                   	pop    %ebp
  80165d:	c3                   	ret    
  80165e:	66 90                	xchg   %ax,%ax

00801660 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	05 00 00 00 30       	add    $0x30000000,%eax
  80166b:	c1 e8 0c             	shr    $0xc,%eax
}
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    

00801670 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80167b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801680:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801685:	5d                   	pop    %ebp
  801686:	c3                   	ret    

00801687 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80168d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801692:	89 c2                	mov    %eax,%edx
  801694:	c1 ea 16             	shr    $0x16,%edx
  801697:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80169e:	f6 c2 01             	test   $0x1,%dl
  8016a1:	74 11                	je     8016b4 <fd_alloc+0x2d>
  8016a3:	89 c2                	mov    %eax,%edx
  8016a5:	c1 ea 0c             	shr    $0xc,%edx
  8016a8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016af:	f6 c2 01             	test   $0x1,%dl
  8016b2:	75 09                	jne    8016bd <fd_alloc+0x36>
			*fd_store = fd;
  8016b4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bb:	eb 17                	jmp    8016d4 <fd_alloc+0x4d>
  8016bd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8016c2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016c7:	75 c9                	jne    801692 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016c9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8016cf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8016d4:	5d                   	pop    %ebp
  8016d5:	c3                   	ret    

008016d6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016dc:	83 f8 1f             	cmp    $0x1f,%eax
  8016df:	77 36                	ja     801717 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016e1:	c1 e0 0c             	shl    $0xc,%eax
  8016e4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016e9:	89 c2                	mov    %eax,%edx
  8016eb:	c1 ea 16             	shr    $0x16,%edx
  8016ee:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016f5:	f6 c2 01             	test   $0x1,%dl
  8016f8:	74 24                	je     80171e <fd_lookup+0x48>
  8016fa:	89 c2                	mov    %eax,%edx
  8016fc:	c1 ea 0c             	shr    $0xc,%edx
  8016ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801706:	f6 c2 01             	test   $0x1,%dl
  801709:	74 1a                	je     801725 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80170b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170e:	89 02                	mov    %eax,(%edx)
	return 0;
  801710:	b8 00 00 00 00       	mov    $0x0,%eax
  801715:	eb 13                	jmp    80172a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801717:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80171c:	eb 0c                	jmp    80172a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80171e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801723:	eb 05                	jmp    80172a <fd_lookup+0x54>
  801725:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80172a:	5d                   	pop    %ebp
  80172b:	c3                   	ret    

0080172c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	83 ec 18             	sub    $0x18,%esp
  801732:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801735:	ba 00 00 00 00       	mov    $0x0,%edx
  80173a:	eb 13                	jmp    80174f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80173c:	39 08                	cmp    %ecx,(%eax)
  80173e:	75 0c                	jne    80174c <dev_lookup+0x20>
			*dev = devtab[i];
  801740:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801743:	89 01                	mov    %eax,(%ecx)
			return 0;
  801745:	b8 00 00 00 00       	mov    $0x0,%eax
  80174a:	eb 38                	jmp    801784 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80174c:	83 c2 01             	add    $0x1,%edx
  80174f:	8b 04 95 c0 32 80 00 	mov    0x8032c0(,%edx,4),%eax
  801756:	85 c0                	test   %eax,%eax
  801758:	75 e2                	jne    80173c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80175a:	a1 08 50 80 00       	mov    0x805008,%eax
  80175f:	8b 40 48             	mov    0x48(%eax),%eax
  801762:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801766:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176a:	c7 04 24 44 32 80 00 	movl   $0x803244,(%esp)
  801771:	e8 72 eb ff ff       	call   8002e8 <cprintf>
	*dev = 0;
  801776:	8b 45 0c             	mov    0xc(%ebp),%eax
  801779:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80177f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	56                   	push   %esi
  80178a:	53                   	push   %ebx
  80178b:	83 ec 20             	sub    $0x20,%esp
  80178e:	8b 75 08             	mov    0x8(%ebp),%esi
  801791:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801794:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801797:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80179b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017a1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017a4:	89 04 24             	mov    %eax,(%esp)
  8017a7:	e8 2a ff ff ff       	call   8016d6 <fd_lookup>
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	78 05                	js     8017b5 <fd_close+0x2f>
	    || fd != fd2)
  8017b0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8017b3:	74 0c                	je     8017c1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8017b5:	84 db                	test   %bl,%bl
  8017b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bc:	0f 44 c2             	cmove  %edx,%eax
  8017bf:	eb 3f                	jmp    801800 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c8:	8b 06                	mov    (%esi),%eax
  8017ca:	89 04 24             	mov    %eax,(%esp)
  8017cd:	e8 5a ff ff ff       	call   80172c <dev_lookup>
  8017d2:	89 c3                	mov    %eax,%ebx
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	78 16                	js     8017ee <fd_close+0x68>
		if (dev->dev_close)
  8017d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017db:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8017de:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	74 07                	je     8017ee <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8017e7:	89 34 24             	mov    %esi,(%esp)
  8017ea:	ff d0                	call   *%eax
  8017ec:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8017ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f9:	e8 dc f5 ff ff       	call   800dda <sys_page_unmap>
	return r;
  8017fe:	89 d8                	mov    %ebx,%eax
}
  801800:	83 c4 20             	add    $0x20,%esp
  801803:	5b                   	pop    %ebx
  801804:	5e                   	pop    %esi
  801805:	5d                   	pop    %ebp
  801806:	c3                   	ret    

00801807 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80180d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801810:	89 44 24 04          	mov    %eax,0x4(%esp)
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	89 04 24             	mov    %eax,(%esp)
  80181a:	e8 b7 fe ff ff       	call   8016d6 <fd_lookup>
  80181f:	89 c2                	mov    %eax,%edx
  801821:	85 d2                	test   %edx,%edx
  801823:	78 13                	js     801838 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801825:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80182c:	00 
  80182d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801830:	89 04 24             	mov    %eax,(%esp)
  801833:	e8 4e ff ff ff       	call   801786 <fd_close>
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <close_all>:

void
close_all(void)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	53                   	push   %ebx
  80183e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801841:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801846:	89 1c 24             	mov    %ebx,(%esp)
  801849:	e8 b9 ff ff ff       	call   801807 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80184e:	83 c3 01             	add    $0x1,%ebx
  801851:	83 fb 20             	cmp    $0x20,%ebx
  801854:	75 f0                	jne    801846 <close_all+0xc>
		close(i);
}
  801856:	83 c4 14             	add    $0x14,%esp
  801859:	5b                   	pop    %ebx
  80185a:	5d                   	pop    %ebp
  80185b:	c3                   	ret    

0080185c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	57                   	push   %edi
  801860:	56                   	push   %esi
  801861:	53                   	push   %ebx
  801862:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801865:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801868:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	89 04 24             	mov    %eax,(%esp)
  801872:	e8 5f fe ff ff       	call   8016d6 <fd_lookup>
  801877:	89 c2                	mov    %eax,%edx
  801879:	85 d2                	test   %edx,%edx
  80187b:	0f 88 e1 00 00 00    	js     801962 <dup+0x106>
		return r;
	close(newfdnum);
  801881:	8b 45 0c             	mov    0xc(%ebp),%eax
  801884:	89 04 24             	mov    %eax,(%esp)
  801887:	e8 7b ff ff ff       	call   801807 <close>

	newfd = INDEX2FD(newfdnum);
  80188c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80188f:	c1 e3 0c             	shl    $0xc,%ebx
  801892:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80189b:	89 04 24             	mov    %eax,(%esp)
  80189e:	e8 cd fd ff ff       	call   801670 <fd2data>
  8018a3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8018a5:	89 1c 24             	mov    %ebx,(%esp)
  8018a8:	e8 c3 fd ff ff       	call   801670 <fd2data>
  8018ad:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018af:	89 f0                	mov    %esi,%eax
  8018b1:	c1 e8 16             	shr    $0x16,%eax
  8018b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018bb:	a8 01                	test   $0x1,%al
  8018bd:	74 43                	je     801902 <dup+0xa6>
  8018bf:	89 f0                	mov    %esi,%eax
  8018c1:	c1 e8 0c             	shr    $0xc,%eax
  8018c4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018cb:	f6 c2 01             	test   $0x1,%dl
  8018ce:	74 32                	je     801902 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8018dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018e0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018eb:	00 
  8018ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018f7:	e8 8b f4 ff ff       	call   800d87 <sys_page_map>
  8018fc:	89 c6                	mov    %eax,%esi
  8018fe:	85 c0                	test   %eax,%eax
  801900:	78 3e                	js     801940 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801902:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801905:	89 c2                	mov    %eax,%edx
  801907:	c1 ea 0c             	shr    $0xc,%edx
  80190a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801911:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801917:	89 54 24 10          	mov    %edx,0x10(%esp)
  80191b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80191f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801926:	00 
  801927:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801932:	e8 50 f4 ff ff       	call   800d87 <sys_page_map>
  801937:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801939:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80193c:	85 f6                	test   %esi,%esi
  80193e:	79 22                	jns    801962 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801940:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801944:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80194b:	e8 8a f4 ff ff       	call   800dda <sys_page_unmap>
	sys_page_unmap(0, nva);
  801950:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801954:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80195b:	e8 7a f4 ff ff       	call   800dda <sys_page_unmap>
	return r;
  801960:	89 f0                	mov    %esi,%eax
}
  801962:	83 c4 3c             	add    $0x3c,%esp
  801965:	5b                   	pop    %ebx
  801966:	5e                   	pop    %esi
  801967:	5f                   	pop    %edi
  801968:	5d                   	pop    %ebp
  801969:	c3                   	ret    

0080196a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	53                   	push   %ebx
  80196e:	83 ec 24             	sub    $0x24,%esp
  801971:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801974:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801977:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197b:	89 1c 24             	mov    %ebx,(%esp)
  80197e:	e8 53 fd ff ff       	call   8016d6 <fd_lookup>
  801983:	89 c2                	mov    %eax,%edx
  801985:	85 d2                	test   %edx,%edx
  801987:	78 6d                	js     8019f6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801989:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801993:	8b 00                	mov    (%eax),%eax
  801995:	89 04 24             	mov    %eax,(%esp)
  801998:	e8 8f fd ff ff       	call   80172c <dev_lookup>
  80199d:	85 c0                	test   %eax,%eax
  80199f:	78 55                	js     8019f6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a4:	8b 50 08             	mov    0x8(%eax),%edx
  8019a7:	83 e2 03             	and    $0x3,%edx
  8019aa:	83 fa 01             	cmp    $0x1,%edx
  8019ad:	75 23                	jne    8019d2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019af:	a1 08 50 80 00       	mov    0x805008,%eax
  8019b4:	8b 40 48             	mov    0x48(%eax),%eax
  8019b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bf:	c7 04 24 85 32 80 00 	movl   $0x803285,(%esp)
  8019c6:	e8 1d e9 ff ff       	call   8002e8 <cprintf>
		return -E_INVAL;
  8019cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d0:	eb 24                	jmp    8019f6 <read+0x8c>
	}
	if (!dev->dev_read)
  8019d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019d5:	8b 52 08             	mov    0x8(%edx),%edx
  8019d8:	85 d2                	test   %edx,%edx
  8019da:	74 15                	je     8019f1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019ea:	89 04 24             	mov    %eax,(%esp)
  8019ed:	ff d2                	call   *%edx
  8019ef:	eb 05                	jmp    8019f6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8019f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8019f6:	83 c4 24             	add    $0x24,%esp
  8019f9:	5b                   	pop    %ebx
  8019fa:	5d                   	pop    %ebp
  8019fb:	c3                   	ret    

008019fc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	57                   	push   %edi
  801a00:	56                   	push   %esi
  801a01:	53                   	push   %ebx
  801a02:	83 ec 1c             	sub    $0x1c,%esp
  801a05:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a08:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a10:	eb 23                	jmp    801a35 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a12:	89 f0                	mov    %esi,%eax
  801a14:	29 d8                	sub    %ebx,%eax
  801a16:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a1a:	89 d8                	mov    %ebx,%eax
  801a1c:	03 45 0c             	add    0xc(%ebp),%eax
  801a1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a23:	89 3c 24             	mov    %edi,(%esp)
  801a26:	e8 3f ff ff ff       	call   80196a <read>
		if (m < 0)
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	78 10                	js     801a3f <readn+0x43>
			return m;
		if (m == 0)
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	74 0a                	je     801a3d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a33:	01 c3                	add    %eax,%ebx
  801a35:	39 f3                	cmp    %esi,%ebx
  801a37:	72 d9                	jb     801a12 <readn+0x16>
  801a39:	89 d8                	mov    %ebx,%eax
  801a3b:	eb 02                	jmp    801a3f <readn+0x43>
  801a3d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801a3f:	83 c4 1c             	add    $0x1c,%esp
  801a42:	5b                   	pop    %ebx
  801a43:	5e                   	pop    %esi
  801a44:	5f                   	pop    %edi
  801a45:	5d                   	pop    %ebp
  801a46:	c3                   	ret    

00801a47 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	53                   	push   %ebx
  801a4b:	83 ec 24             	sub    $0x24,%esp
  801a4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a51:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a58:	89 1c 24             	mov    %ebx,(%esp)
  801a5b:	e8 76 fc ff ff       	call   8016d6 <fd_lookup>
  801a60:	89 c2                	mov    %eax,%edx
  801a62:	85 d2                	test   %edx,%edx
  801a64:	78 68                	js     801ace <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a66:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a70:	8b 00                	mov    (%eax),%eax
  801a72:	89 04 24             	mov    %eax,(%esp)
  801a75:	e8 b2 fc ff ff       	call   80172c <dev_lookup>
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	78 50                	js     801ace <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a81:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a85:	75 23                	jne    801aaa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a87:	a1 08 50 80 00       	mov    0x805008,%eax
  801a8c:	8b 40 48             	mov    0x48(%eax),%eax
  801a8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a97:	c7 04 24 a1 32 80 00 	movl   $0x8032a1,(%esp)
  801a9e:	e8 45 e8 ff ff       	call   8002e8 <cprintf>
		return -E_INVAL;
  801aa3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aa8:	eb 24                	jmp    801ace <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801aaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aad:	8b 52 0c             	mov    0xc(%edx),%edx
  801ab0:	85 d2                	test   %edx,%edx
  801ab2:	74 15                	je     801ac9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ab4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801abb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801abe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ac2:	89 04 24             	mov    %eax,(%esp)
  801ac5:	ff d2                	call   *%edx
  801ac7:	eb 05                	jmp    801ace <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801ac9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801ace:	83 c4 24             	add    $0x24,%esp
  801ad1:	5b                   	pop    %ebx
  801ad2:	5d                   	pop    %ebp
  801ad3:	c3                   	ret    

00801ad4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ada:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801add:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	89 04 24             	mov    %eax,(%esp)
  801ae7:	e8 ea fb ff ff       	call   8016d6 <fd_lookup>
  801aec:	85 c0                	test   %eax,%eax
  801aee:	78 0e                	js     801afe <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801af9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	53                   	push   %ebx
  801b04:	83 ec 24             	sub    $0x24,%esp
  801b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b0a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b11:	89 1c 24             	mov    %ebx,(%esp)
  801b14:	e8 bd fb ff ff       	call   8016d6 <fd_lookup>
  801b19:	89 c2                	mov    %eax,%edx
  801b1b:	85 d2                	test   %edx,%edx
  801b1d:	78 61                	js     801b80 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b1f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b22:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b29:	8b 00                	mov    (%eax),%eax
  801b2b:	89 04 24             	mov    %eax,(%esp)
  801b2e:	e8 f9 fb ff ff       	call   80172c <dev_lookup>
  801b33:	85 c0                	test   %eax,%eax
  801b35:	78 49                	js     801b80 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b3e:	75 23                	jne    801b63 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801b40:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b45:	8b 40 48             	mov    0x48(%eax),%eax
  801b48:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b50:	c7 04 24 64 32 80 00 	movl   $0x803264,(%esp)
  801b57:	e8 8c e7 ff ff       	call   8002e8 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801b5c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b61:	eb 1d                	jmp    801b80 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801b63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b66:	8b 52 18             	mov    0x18(%edx),%edx
  801b69:	85 d2                	test   %edx,%edx
  801b6b:	74 0e                	je     801b7b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b70:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b74:	89 04 24             	mov    %eax,(%esp)
  801b77:	ff d2                	call   *%edx
  801b79:	eb 05                	jmp    801b80 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801b7b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801b80:	83 c4 24             	add    $0x24,%esp
  801b83:	5b                   	pop    %ebx
  801b84:	5d                   	pop    %ebp
  801b85:	c3                   	ret    

00801b86 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	53                   	push   %ebx
  801b8a:	83 ec 24             	sub    $0x24,%esp
  801b8d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b90:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	89 04 24             	mov    %eax,(%esp)
  801b9d:	e8 34 fb ff ff       	call   8016d6 <fd_lookup>
  801ba2:	89 c2                	mov    %eax,%edx
  801ba4:	85 d2                	test   %edx,%edx
  801ba6:	78 52                	js     801bfa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ba8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb2:	8b 00                	mov    (%eax),%eax
  801bb4:	89 04 24             	mov    %eax,(%esp)
  801bb7:	e8 70 fb ff ff       	call   80172c <dev_lookup>
  801bbc:	85 c0                	test   %eax,%eax
  801bbe:	78 3a                	js     801bfa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bc7:	74 2c                	je     801bf5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bc9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bcc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bd3:	00 00 00 
	stat->st_isdir = 0;
  801bd6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bdd:	00 00 00 
	stat->st_dev = dev;
  801be0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801be6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bed:	89 14 24             	mov    %edx,(%esp)
  801bf0:	ff 50 14             	call   *0x14(%eax)
  801bf3:	eb 05                	jmp    801bfa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801bf5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801bfa:	83 c4 24             	add    $0x24,%esp
  801bfd:	5b                   	pop    %ebx
  801bfe:	5d                   	pop    %ebp
  801bff:	c3                   	ret    

00801c00 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	56                   	push   %esi
  801c04:	53                   	push   %ebx
  801c05:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c08:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c0f:	00 
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	89 04 24             	mov    %eax,(%esp)
  801c16:	e8 1b 02 00 00       	call   801e36 <open>
  801c1b:	89 c3                	mov    %eax,%ebx
  801c1d:	85 db                	test   %ebx,%ebx
  801c1f:	78 1b                	js     801c3c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c28:	89 1c 24             	mov    %ebx,(%esp)
  801c2b:	e8 56 ff ff ff       	call   801b86 <fstat>
  801c30:	89 c6                	mov    %eax,%esi
	close(fd);
  801c32:	89 1c 24             	mov    %ebx,(%esp)
  801c35:	e8 cd fb ff ff       	call   801807 <close>
	return r;
  801c3a:	89 f0                	mov    %esi,%eax
}
  801c3c:	83 c4 10             	add    $0x10,%esp
  801c3f:	5b                   	pop    %ebx
  801c40:	5e                   	pop    %esi
  801c41:	5d                   	pop    %ebp
  801c42:	c3                   	ret    

00801c43 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	56                   	push   %esi
  801c47:	53                   	push   %ebx
  801c48:	83 ec 10             	sub    $0x10,%esp
  801c4b:	89 c6                	mov    %eax,%esi
  801c4d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c4f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c56:	75 11                	jne    801c69 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c58:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c5f:	e8 bb f9 ff ff       	call   80161f <ipc_find_env>
  801c64:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c69:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c70:	00 
  801c71:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c78:	00 
  801c79:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c7d:	a1 00 50 80 00       	mov    0x805000,%eax
  801c82:	89 04 24             	mov    %eax,(%esp)
  801c85:	e8 2a f9 ff ff       	call   8015b4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c8a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c91:	00 
  801c92:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c96:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c9d:	e8 be f8 ff ff       	call   801560 <ipc_recv>
}
  801ca2:	83 c4 10             	add    $0x10,%esp
  801ca5:	5b                   	pop    %ebx
  801ca6:	5e                   	pop    %esi
  801ca7:	5d                   	pop    %ebp
  801ca8:	c3                   	ret    

00801ca9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc7:	b8 02 00 00 00       	mov    $0x2,%eax
  801ccc:	e8 72 ff ff ff       	call   801c43 <fsipc>
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	8b 40 0c             	mov    0xc(%eax),%eax
  801cdf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ce4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce9:	b8 06 00 00 00       	mov    $0x6,%eax
  801cee:	e8 50 ff ff ff       	call   801c43 <fsipc>
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	53                   	push   %ebx
  801cf9:	83 ec 14             	sub    $0x14,%esp
  801cfc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	8b 40 0c             	mov    0xc(%eax),%eax
  801d05:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0f:	b8 05 00 00 00       	mov    $0x5,%eax
  801d14:	e8 2a ff ff ff       	call   801c43 <fsipc>
  801d19:	89 c2                	mov    %eax,%edx
  801d1b:	85 d2                	test   %edx,%edx
  801d1d:	78 2b                	js     801d4a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d1f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d26:	00 
  801d27:	89 1c 24             	mov    %ebx,(%esp)
  801d2a:	e8 e8 eb ff ff       	call   800917 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d2f:	a1 80 60 80 00       	mov    0x806080,%eax
  801d34:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d3a:	a1 84 60 80 00       	mov    0x806084,%eax
  801d3f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4a:	83 c4 14             	add    $0x14,%esp
  801d4d:	5b                   	pop    %ebx
  801d4e:	5d                   	pop    %ebp
  801d4f:	c3                   	ret    

00801d50 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	83 ec 18             	sub    $0x18,%esp
  801d56:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d59:	8b 55 08             	mov    0x8(%ebp),%edx
  801d5c:	8b 52 0c             	mov    0xc(%edx),%edx
  801d5f:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801d65:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d75:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801d7c:	e8 9b ed ff ff       	call   800b1c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801d81:	ba 00 00 00 00       	mov    $0x0,%edx
  801d86:	b8 04 00 00 00       	mov    $0x4,%eax
  801d8b:	e8 b3 fe ff ff       	call   801c43 <fsipc>
		return r;
	}

	return r;
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
  801d95:	56                   	push   %esi
  801d96:	53                   	push   %ebx
  801d97:	83 ec 10             	sub    $0x10,%esp
  801d9a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801da0:	8b 40 0c             	mov    0xc(%eax),%eax
  801da3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801da8:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801dae:	ba 00 00 00 00       	mov    $0x0,%edx
  801db3:	b8 03 00 00 00       	mov    $0x3,%eax
  801db8:	e8 86 fe ff ff       	call   801c43 <fsipc>
  801dbd:	89 c3                	mov    %eax,%ebx
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	78 6a                	js     801e2d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801dc3:	39 c6                	cmp    %eax,%esi
  801dc5:	73 24                	jae    801deb <devfile_read+0x59>
  801dc7:	c7 44 24 0c d4 32 80 	movl   $0x8032d4,0xc(%esp)
  801dce:	00 
  801dcf:	c7 44 24 08 db 32 80 	movl   $0x8032db,0x8(%esp)
  801dd6:	00 
  801dd7:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801dde:	00 
  801ddf:	c7 04 24 f0 32 80 00 	movl   $0x8032f0,(%esp)
  801de6:	e8 2b 0b 00 00       	call   802916 <_panic>
	assert(r <= PGSIZE);
  801deb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801df0:	7e 24                	jle    801e16 <devfile_read+0x84>
  801df2:	c7 44 24 0c fb 32 80 	movl   $0x8032fb,0xc(%esp)
  801df9:	00 
  801dfa:	c7 44 24 08 db 32 80 	movl   $0x8032db,0x8(%esp)
  801e01:	00 
  801e02:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801e09:	00 
  801e0a:	c7 04 24 f0 32 80 00 	movl   $0x8032f0,(%esp)
  801e11:	e8 00 0b 00 00       	call   802916 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e16:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e1a:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e21:	00 
  801e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e25:	89 04 24             	mov    %eax,(%esp)
  801e28:	e8 87 ec ff ff       	call   800ab4 <memmove>
	return r;
}
  801e2d:	89 d8                	mov    %ebx,%eax
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	5b                   	pop    %ebx
  801e33:	5e                   	pop    %esi
  801e34:	5d                   	pop    %ebp
  801e35:	c3                   	ret    

00801e36 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	53                   	push   %ebx
  801e3a:	83 ec 24             	sub    $0x24,%esp
  801e3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801e40:	89 1c 24             	mov    %ebx,(%esp)
  801e43:	e8 98 ea ff ff       	call   8008e0 <strlen>
  801e48:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e4d:	7f 60                	jg     801eaf <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801e4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e52:	89 04 24             	mov    %eax,(%esp)
  801e55:	e8 2d f8 ff ff       	call   801687 <fd_alloc>
  801e5a:	89 c2                	mov    %eax,%edx
  801e5c:	85 d2                	test   %edx,%edx
  801e5e:	78 54                	js     801eb4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801e60:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e64:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801e6b:	e8 a7 ea ff ff       	call   800917 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e73:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e80:	e8 be fd ff ff       	call   801c43 <fsipc>
  801e85:	89 c3                	mov    %eax,%ebx
  801e87:	85 c0                	test   %eax,%eax
  801e89:	79 17                	jns    801ea2 <open+0x6c>
		fd_close(fd, 0);
  801e8b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e92:	00 
  801e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e96:	89 04 24             	mov    %eax,(%esp)
  801e99:	e8 e8 f8 ff ff       	call   801786 <fd_close>
		return r;
  801e9e:	89 d8                	mov    %ebx,%eax
  801ea0:	eb 12                	jmp    801eb4 <open+0x7e>
	}

	return fd2num(fd);
  801ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea5:	89 04 24             	mov    %eax,(%esp)
  801ea8:	e8 b3 f7 ff ff       	call   801660 <fd2num>
  801ead:	eb 05                	jmp    801eb4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801eaf:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801eb4:	83 c4 24             	add    $0x24,%esp
  801eb7:	5b                   	pop    %ebx
  801eb8:	5d                   	pop    %ebp
  801eb9:	c3                   	ret    

00801eba <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ec0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec5:	b8 08 00 00 00       	mov    $0x8,%eax
  801eca:	e8 74 fd ff ff       	call   801c43 <fsipc>
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    
  801ed1:	66 90                	xchg   %ax,%ax
  801ed3:	66 90                	xchg   %ax,%ax
  801ed5:	66 90                	xchg   %ax,%ax
  801ed7:	66 90                	xchg   %ax,%ax
  801ed9:	66 90                	xchg   %ax,%ax
  801edb:	66 90                	xchg   %ax,%ax
  801edd:	66 90                	xchg   %ax,%ax
  801edf:	90                   	nop

00801ee0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ee6:	c7 44 24 04 07 33 80 	movl   $0x803307,0x4(%esp)
  801eed:	00 
  801eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef1:	89 04 24             	mov    %eax,(%esp)
  801ef4:	e8 1e ea ff ff       	call   800917 <strcpy>
	return 0;
}
  801ef9:	b8 00 00 00 00       	mov    $0x0,%eax
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	53                   	push   %ebx
  801f04:	83 ec 14             	sub    $0x14,%esp
  801f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f0a:	89 1c 24             	mov    %ebx,(%esp)
  801f0d:	e8 07 0b 00 00       	call   802a19 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801f12:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801f17:	83 f8 01             	cmp    $0x1,%eax
  801f1a:	75 0d                	jne    801f29 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801f1c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f1f:	89 04 24             	mov    %eax,(%esp)
  801f22:	e8 29 03 00 00       	call   802250 <nsipc_close>
  801f27:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801f29:	89 d0                	mov    %edx,%eax
  801f2b:	83 c4 14             	add    $0x14,%esp
  801f2e:	5b                   	pop    %ebx
  801f2f:	5d                   	pop    %ebp
  801f30:	c3                   	ret    

00801f31 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f37:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f3e:	00 
  801f3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f42:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	8b 40 0c             	mov    0xc(%eax),%eax
  801f53:	89 04 24             	mov    %eax,(%esp)
  801f56:	e8 f0 03 00 00       	call   80234b <nsipc_send>
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f63:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f6a:	00 
  801f6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f75:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7f:	89 04 24             	mov    %eax,(%esp)
  801f82:	e8 44 03 00 00       	call   8022cb <nsipc_recv>
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f8f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f92:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f96:	89 04 24             	mov    %eax,(%esp)
  801f99:	e8 38 f7 ff ff       	call   8016d6 <fd_lookup>
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	78 17                	js     801fb9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa5:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  801fab:	39 08                	cmp    %ecx,(%eax)
  801fad:	75 05                	jne    801fb4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801faf:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb2:	eb 05                	jmp    801fb9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801fb4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	56                   	push   %esi
  801fbf:	53                   	push   %ebx
  801fc0:	83 ec 20             	sub    $0x20,%esp
  801fc3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801fc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc8:	89 04 24             	mov    %eax,(%esp)
  801fcb:	e8 b7 f6 ff ff       	call   801687 <fd_alloc>
  801fd0:	89 c3                	mov    %eax,%ebx
  801fd2:	85 c0                	test   %eax,%eax
  801fd4:	78 21                	js     801ff7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fd6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fdd:	00 
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fec:	e8 42 ed ff ff       	call   800d33 <sys_page_alloc>
  801ff1:	89 c3                	mov    %eax,%ebx
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	79 0c                	jns    802003 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801ff7:	89 34 24             	mov    %esi,(%esp)
  801ffa:	e8 51 02 00 00       	call   802250 <nsipc_close>
		return r;
  801fff:	89 d8                	mov    %ebx,%eax
  802001:	eb 20                	jmp    802023 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802003:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80200e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802011:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802018:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80201b:	89 14 24             	mov    %edx,(%esp)
  80201e:	e8 3d f6 ff ff       	call   801660 <fd2num>
}
  802023:	83 c4 20             	add    $0x20,%esp
  802026:	5b                   	pop    %ebx
  802027:	5e                   	pop    %esi
  802028:	5d                   	pop    %ebp
  802029:	c3                   	ret    

0080202a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	e8 51 ff ff ff       	call   801f89 <fd2sockid>
		return r;
  802038:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80203a:	85 c0                	test   %eax,%eax
  80203c:	78 23                	js     802061 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80203e:	8b 55 10             	mov    0x10(%ebp),%edx
  802041:	89 54 24 08          	mov    %edx,0x8(%esp)
  802045:	8b 55 0c             	mov    0xc(%ebp),%edx
  802048:	89 54 24 04          	mov    %edx,0x4(%esp)
  80204c:	89 04 24             	mov    %eax,(%esp)
  80204f:	e8 45 01 00 00       	call   802199 <nsipc_accept>
		return r;
  802054:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802056:	85 c0                	test   %eax,%eax
  802058:	78 07                	js     802061 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80205a:	e8 5c ff ff ff       	call   801fbb <alloc_sockfd>
  80205f:	89 c1                	mov    %eax,%ecx
}
  802061:	89 c8                	mov    %ecx,%eax
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	e8 16 ff ff ff       	call   801f89 <fd2sockid>
  802073:	89 c2                	mov    %eax,%edx
  802075:	85 d2                	test   %edx,%edx
  802077:	78 16                	js     80208f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802079:	8b 45 10             	mov    0x10(%ebp),%eax
  80207c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802080:	8b 45 0c             	mov    0xc(%ebp),%eax
  802083:	89 44 24 04          	mov    %eax,0x4(%esp)
  802087:	89 14 24             	mov    %edx,(%esp)
  80208a:	e8 60 01 00 00       	call   8021ef <nsipc_bind>
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <shutdown>:

int
shutdown(int s, int how)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	e8 ea fe ff ff       	call   801f89 <fd2sockid>
  80209f:	89 c2                	mov    %eax,%edx
  8020a1:	85 d2                	test   %edx,%edx
  8020a3:	78 0f                	js     8020b4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8020a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ac:	89 14 24             	mov    %edx,(%esp)
  8020af:	e8 7a 01 00 00       	call   80222e <nsipc_shutdown>
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	e8 c5 fe ff ff       	call   801f89 <fd2sockid>
  8020c4:	89 c2                	mov    %eax,%edx
  8020c6:	85 d2                	test   %edx,%edx
  8020c8:	78 16                	js     8020e0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8020ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8020cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d8:	89 14 24             	mov    %edx,(%esp)
  8020db:	e8 8a 01 00 00       	call   80226a <nsipc_connect>
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <listen>:

int
listen(int s, int backlog)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	e8 99 fe ff ff       	call   801f89 <fd2sockid>
  8020f0:	89 c2                	mov    %eax,%edx
  8020f2:	85 d2                	test   %edx,%edx
  8020f4:	78 0f                	js     802105 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8020f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fd:	89 14 24             	mov    %edx,(%esp)
  802100:	e8 a4 01 00 00       	call   8022a9 <nsipc_listen>
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80210d:	8b 45 10             	mov    0x10(%ebp),%eax
  802110:	89 44 24 08          	mov    %eax,0x8(%esp)
  802114:	8b 45 0c             	mov    0xc(%ebp),%eax
  802117:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	89 04 24             	mov    %eax,(%esp)
  802121:	e8 98 02 00 00       	call   8023be <nsipc_socket>
  802126:	89 c2                	mov    %eax,%edx
  802128:	85 d2                	test   %edx,%edx
  80212a:	78 05                	js     802131 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80212c:	e8 8a fe ff ff       	call   801fbb <alloc_sockfd>
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	53                   	push   %ebx
  802137:	83 ec 14             	sub    $0x14,%esp
  80213a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80213c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802143:	75 11                	jne    802156 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802145:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80214c:	e8 ce f4 ff ff       	call   80161f <ipc_find_env>
  802151:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802156:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80215d:	00 
  80215e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802165:	00 
  802166:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80216a:	a1 04 50 80 00       	mov    0x805004,%eax
  80216f:	89 04 24             	mov    %eax,(%esp)
  802172:	e8 3d f4 ff ff       	call   8015b4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802177:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80217e:	00 
  80217f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802186:	00 
  802187:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80218e:	e8 cd f3 ff ff       	call   801560 <ipc_recv>
}
  802193:	83 c4 14             	add    $0x14,%esp
  802196:	5b                   	pop    %ebx
  802197:	5d                   	pop    %ebp
  802198:	c3                   	ret    

00802199 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
  80219c:	56                   	push   %esi
  80219d:	53                   	push   %ebx
  80219e:	83 ec 10             	sub    $0x10,%esp
  8021a1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021ac:	8b 06                	mov    (%esi),%eax
  8021ae:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b8:	e8 76 ff ff ff       	call   802133 <nsipc>
  8021bd:	89 c3                	mov    %eax,%ebx
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	78 23                	js     8021e6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021c3:	a1 10 70 80 00       	mov    0x807010,%eax
  8021c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021cc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8021d3:	00 
  8021d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d7:	89 04 24             	mov    %eax,(%esp)
  8021da:	e8 d5 e8 ff ff       	call   800ab4 <memmove>
		*addrlen = ret->ret_addrlen;
  8021df:	a1 10 70 80 00       	mov    0x807010,%eax
  8021e4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8021e6:	89 d8                	mov    %ebx,%eax
  8021e8:	83 c4 10             	add    $0x10,%esp
  8021eb:	5b                   	pop    %ebx
  8021ec:	5e                   	pop    %esi
  8021ed:	5d                   	pop    %ebp
  8021ee:	c3                   	ret    

008021ef <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
  8021f2:	53                   	push   %ebx
  8021f3:	83 ec 14             	sub    $0x14,%esp
  8021f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802201:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802205:	8b 45 0c             	mov    0xc(%ebp),%eax
  802208:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802213:	e8 9c e8 ff ff       	call   800ab4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802218:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80221e:	b8 02 00 00 00       	mov    $0x2,%eax
  802223:	e8 0b ff ff ff       	call   802133 <nsipc>
}
  802228:	83 c4 14             	add    $0x14,%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5d                   	pop    %ebp
  80222d:	c3                   	ret    

0080222e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80223c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802244:	b8 03 00 00 00       	mov    $0x3,%eax
  802249:	e8 e5 fe ff ff       	call   802133 <nsipc>
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <nsipc_close>:

int
nsipc_close(int s)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80225e:	b8 04 00 00 00       	mov    $0x4,%eax
  802263:	e8 cb fe ff ff       	call   802133 <nsipc>
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	53                   	push   %ebx
  80226e:	83 ec 14             	sub    $0x14,%esp
  802271:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80227c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802280:	8b 45 0c             	mov    0xc(%ebp),%eax
  802283:	89 44 24 04          	mov    %eax,0x4(%esp)
  802287:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80228e:	e8 21 e8 ff ff       	call   800ab4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802293:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802299:	b8 05 00 00 00       	mov    $0x5,%eax
  80229e:	e8 90 fe ff ff       	call   802133 <nsipc>
}
  8022a3:	83 c4 14             	add    $0x14,%esp
  8022a6:	5b                   	pop    %ebx
  8022a7:	5d                   	pop    %ebp
  8022a8:	c3                   	ret    

008022a9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ba:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8022bf:	b8 06 00 00 00       	mov    $0x6,%eax
  8022c4:	e8 6a fe ff ff       	call   802133 <nsipc>
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	56                   	push   %esi
  8022cf:	53                   	push   %ebx
  8022d0:	83 ec 10             	sub    $0x10,%esp
  8022d3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022de:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8022e7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022ec:	b8 07 00 00 00       	mov    $0x7,%eax
  8022f1:	e8 3d fe ff ff       	call   802133 <nsipc>
  8022f6:	89 c3                	mov    %eax,%ebx
  8022f8:	85 c0                	test   %eax,%eax
  8022fa:	78 46                	js     802342 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8022fc:	39 f0                	cmp    %esi,%eax
  8022fe:	7f 07                	jg     802307 <nsipc_recv+0x3c>
  802300:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802305:	7e 24                	jle    80232b <nsipc_recv+0x60>
  802307:	c7 44 24 0c 13 33 80 	movl   $0x803313,0xc(%esp)
  80230e:	00 
  80230f:	c7 44 24 08 db 32 80 	movl   $0x8032db,0x8(%esp)
  802316:	00 
  802317:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80231e:	00 
  80231f:	c7 04 24 28 33 80 00 	movl   $0x803328,(%esp)
  802326:	e8 eb 05 00 00       	call   802916 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80232b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80232f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802336:	00 
  802337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233a:	89 04 24             	mov    %eax,(%esp)
  80233d:	e8 72 e7 ff ff       	call   800ab4 <memmove>
	}

	return r;
}
  802342:	89 d8                	mov    %ebx,%eax
  802344:	83 c4 10             	add    $0x10,%esp
  802347:	5b                   	pop    %ebx
  802348:	5e                   	pop    %esi
  802349:	5d                   	pop    %ebp
  80234a:	c3                   	ret    

0080234b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	53                   	push   %ebx
  80234f:	83 ec 14             	sub    $0x14,%esp
  802352:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80235d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802363:	7e 24                	jle    802389 <nsipc_send+0x3e>
  802365:	c7 44 24 0c 34 33 80 	movl   $0x803334,0xc(%esp)
  80236c:	00 
  80236d:	c7 44 24 08 db 32 80 	movl   $0x8032db,0x8(%esp)
  802374:	00 
  802375:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80237c:	00 
  80237d:	c7 04 24 28 33 80 00 	movl   $0x803328,(%esp)
  802384:	e8 8d 05 00 00       	call   802916 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802389:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80238d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802390:	89 44 24 04          	mov    %eax,0x4(%esp)
  802394:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80239b:	e8 14 e7 ff ff       	call   800ab4 <memmove>
	nsipcbuf.send.req_size = size;
  8023a0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8023b3:	e8 7b fd ff ff       	call   802133 <nsipc>
}
  8023b8:	83 c4 14             	add    $0x14,%esp
  8023bb:	5b                   	pop    %ebx
  8023bc:	5d                   	pop    %ebp
  8023bd:	c3                   	ret    

008023be <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023dc:	b8 09 00 00 00       	mov    $0x9,%eax
  8023e1:	e8 4d fd ff ff       	call   802133 <nsipc>
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
  8023eb:	56                   	push   %esi
  8023ec:	53                   	push   %ebx
  8023ed:	83 ec 10             	sub    $0x10,%esp
  8023f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f6:	89 04 24             	mov    %eax,(%esp)
  8023f9:	e8 72 f2 ff ff       	call   801670 <fd2data>
  8023fe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802400:	c7 44 24 04 40 33 80 	movl   $0x803340,0x4(%esp)
  802407:	00 
  802408:	89 1c 24             	mov    %ebx,(%esp)
  80240b:	e8 07 e5 ff ff       	call   800917 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802410:	8b 46 04             	mov    0x4(%esi),%eax
  802413:	2b 06                	sub    (%esi),%eax
  802415:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80241b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802422:	00 00 00 
	stat->st_dev = &devpipe;
  802425:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  80242c:	40 80 00 
	return 0;
}
  80242f:	b8 00 00 00 00       	mov    $0x0,%eax
  802434:	83 c4 10             	add    $0x10,%esp
  802437:	5b                   	pop    %ebx
  802438:	5e                   	pop    %esi
  802439:	5d                   	pop    %ebp
  80243a:	c3                   	ret    

0080243b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
  80243e:	53                   	push   %ebx
  80243f:	83 ec 14             	sub    $0x14,%esp
  802442:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802445:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802449:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802450:	e8 85 e9 ff ff       	call   800dda <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802455:	89 1c 24             	mov    %ebx,(%esp)
  802458:	e8 13 f2 ff ff       	call   801670 <fd2data>
  80245d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802461:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802468:	e8 6d e9 ff ff       	call   800dda <sys_page_unmap>
}
  80246d:	83 c4 14             	add    $0x14,%esp
  802470:	5b                   	pop    %ebx
  802471:	5d                   	pop    %ebp
  802472:	c3                   	ret    

00802473 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
  802476:	57                   	push   %edi
  802477:	56                   	push   %esi
  802478:	53                   	push   %ebx
  802479:	83 ec 2c             	sub    $0x2c,%esp
  80247c:	89 c6                	mov    %eax,%esi
  80247e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802481:	a1 08 50 80 00       	mov    0x805008,%eax
  802486:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802489:	89 34 24             	mov    %esi,(%esp)
  80248c:	e8 88 05 00 00       	call   802a19 <pageref>
  802491:	89 c7                	mov    %eax,%edi
  802493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802496:	89 04 24             	mov    %eax,(%esp)
  802499:	e8 7b 05 00 00       	call   802a19 <pageref>
  80249e:	39 c7                	cmp    %eax,%edi
  8024a0:	0f 94 c2             	sete   %dl
  8024a3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8024a6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8024ac:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8024af:	39 fb                	cmp    %edi,%ebx
  8024b1:	74 21                	je     8024d4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8024b3:	84 d2                	test   %dl,%dl
  8024b5:	74 ca                	je     802481 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024b7:	8b 51 58             	mov    0x58(%ecx),%edx
  8024ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024be:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024c6:	c7 04 24 47 33 80 00 	movl   $0x803347,(%esp)
  8024cd:	e8 16 de ff ff       	call   8002e8 <cprintf>
  8024d2:	eb ad                	jmp    802481 <_pipeisclosed+0xe>
	}
}
  8024d4:	83 c4 2c             	add    $0x2c,%esp
  8024d7:	5b                   	pop    %ebx
  8024d8:	5e                   	pop    %esi
  8024d9:	5f                   	pop    %edi
  8024da:	5d                   	pop    %ebp
  8024db:	c3                   	ret    

008024dc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
  8024df:	57                   	push   %edi
  8024e0:	56                   	push   %esi
  8024e1:	53                   	push   %ebx
  8024e2:	83 ec 1c             	sub    $0x1c,%esp
  8024e5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8024e8:	89 34 24             	mov    %esi,(%esp)
  8024eb:	e8 80 f1 ff ff       	call   801670 <fd2data>
  8024f0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024f7:	eb 45                	jmp    80253e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8024f9:	89 da                	mov    %ebx,%edx
  8024fb:	89 f0                	mov    %esi,%eax
  8024fd:	e8 71 ff ff ff       	call   802473 <_pipeisclosed>
  802502:	85 c0                	test   %eax,%eax
  802504:	75 41                	jne    802547 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802506:	e8 09 e8 ff ff       	call   800d14 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80250b:	8b 43 04             	mov    0x4(%ebx),%eax
  80250e:	8b 0b                	mov    (%ebx),%ecx
  802510:	8d 51 20             	lea    0x20(%ecx),%edx
  802513:	39 d0                	cmp    %edx,%eax
  802515:	73 e2                	jae    8024f9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802517:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80251a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80251e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802521:	99                   	cltd   
  802522:	c1 ea 1b             	shr    $0x1b,%edx
  802525:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802528:	83 e1 1f             	and    $0x1f,%ecx
  80252b:	29 d1                	sub    %edx,%ecx
  80252d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802531:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802535:	83 c0 01             	add    $0x1,%eax
  802538:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80253b:	83 c7 01             	add    $0x1,%edi
  80253e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802541:	75 c8                	jne    80250b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802543:	89 f8                	mov    %edi,%eax
  802545:	eb 05                	jmp    80254c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802547:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80254c:	83 c4 1c             	add    $0x1c,%esp
  80254f:	5b                   	pop    %ebx
  802550:	5e                   	pop    %esi
  802551:	5f                   	pop    %edi
  802552:	5d                   	pop    %ebp
  802553:	c3                   	ret    

00802554 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
  802557:	57                   	push   %edi
  802558:	56                   	push   %esi
  802559:	53                   	push   %ebx
  80255a:	83 ec 1c             	sub    $0x1c,%esp
  80255d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802560:	89 3c 24             	mov    %edi,(%esp)
  802563:	e8 08 f1 ff ff       	call   801670 <fd2data>
  802568:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80256a:	be 00 00 00 00       	mov    $0x0,%esi
  80256f:	eb 3d                	jmp    8025ae <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802571:	85 f6                	test   %esi,%esi
  802573:	74 04                	je     802579 <devpipe_read+0x25>
				return i;
  802575:	89 f0                	mov    %esi,%eax
  802577:	eb 43                	jmp    8025bc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802579:	89 da                	mov    %ebx,%edx
  80257b:	89 f8                	mov    %edi,%eax
  80257d:	e8 f1 fe ff ff       	call   802473 <_pipeisclosed>
  802582:	85 c0                	test   %eax,%eax
  802584:	75 31                	jne    8025b7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802586:	e8 89 e7 ff ff       	call   800d14 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80258b:	8b 03                	mov    (%ebx),%eax
  80258d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802590:	74 df                	je     802571 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802592:	99                   	cltd   
  802593:	c1 ea 1b             	shr    $0x1b,%edx
  802596:	01 d0                	add    %edx,%eax
  802598:	83 e0 1f             	and    $0x1f,%eax
  80259b:	29 d0                	sub    %edx,%eax
  80259d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025a5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025a8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025ab:	83 c6 01             	add    $0x1,%esi
  8025ae:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025b1:	75 d8                	jne    80258b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8025b3:	89 f0                	mov    %esi,%eax
  8025b5:	eb 05                	jmp    8025bc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8025b7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8025bc:	83 c4 1c             	add    $0x1c,%esp
  8025bf:	5b                   	pop    %ebx
  8025c0:	5e                   	pop    %esi
  8025c1:	5f                   	pop    %edi
  8025c2:	5d                   	pop    %ebp
  8025c3:	c3                   	ret    

008025c4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	56                   	push   %esi
  8025c8:	53                   	push   %ebx
  8025c9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8025cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025cf:	89 04 24             	mov    %eax,(%esp)
  8025d2:	e8 b0 f0 ff ff       	call   801687 <fd_alloc>
  8025d7:	89 c2                	mov    %eax,%edx
  8025d9:	85 d2                	test   %edx,%edx
  8025db:	0f 88 4d 01 00 00    	js     80272e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025e1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025e8:	00 
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025f7:	e8 37 e7 ff ff       	call   800d33 <sys_page_alloc>
  8025fc:	89 c2                	mov    %eax,%edx
  8025fe:	85 d2                	test   %edx,%edx
  802600:	0f 88 28 01 00 00    	js     80272e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802606:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802609:	89 04 24             	mov    %eax,(%esp)
  80260c:	e8 76 f0 ff ff       	call   801687 <fd_alloc>
  802611:	89 c3                	mov    %eax,%ebx
  802613:	85 c0                	test   %eax,%eax
  802615:	0f 88 fe 00 00 00    	js     802719 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80261b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802622:	00 
  802623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802626:	89 44 24 04          	mov    %eax,0x4(%esp)
  80262a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802631:	e8 fd e6 ff ff       	call   800d33 <sys_page_alloc>
  802636:	89 c3                	mov    %eax,%ebx
  802638:	85 c0                	test   %eax,%eax
  80263a:	0f 88 d9 00 00 00    	js     802719 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	89 04 24             	mov    %eax,(%esp)
  802646:	e8 25 f0 ff ff       	call   801670 <fd2data>
  80264b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80264d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802654:	00 
  802655:	89 44 24 04          	mov    %eax,0x4(%esp)
  802659:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802660:	e8 ce e6 ff ff       	call   800d33 <sys_page_alloc>
  802665:	89 c3                	mov    %eax,%ebx
  802667:	85 c0                	test   %eax,%eax
  802669:	0f 88 97 00 00 00    	js     802706 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80266f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802672:	89 04 24             	mov    %eax,(%esp)
  802675:	e8 f6 ef ff ff       	call   801670 <fd2data>
  80267a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802681:	00 
  802682:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802686:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80268d:	00 
  80268e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802692:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802699:	e8 e9 e6 ff ff       	call   800d87 <sys_page_map>
  80269e:	89 c3                	mov    %eax,%ebx
  8026a0:	85 c0                	test   %eax,%eax
  8026a2:	78 52                	js     8026f6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8026a4:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8026b9:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8026bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8026c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	89 04 24             	mov    %eax,(%esp)
  8026d4:	e8 87 ef ff ff       	call   801660 <fd2num>
  8026d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026dc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e1:	89 04 24             	mov    %eax,(%esp)
  8026e4:	e8 77 ef ff ff       	call   801660 <fd2num>
  8026e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026ec:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f4:	eb 38                	jmp    80272e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8026f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802701:	e8 d4 e6 ff ff       	call   800dda <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802706:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802709:	89 44 24 04          	mov    %eax,0x4(%esp)
  80270d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802714:	e8 c1 e6 ff ff       	call   800dda <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802720:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802727:	e8 ae e6 ff ff       	call   800dda <sys_page_unmap>
  80272c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80272e:	83 c4 30             	add    $0x30,%esp
  802731:	5b                   	pop    %ebx
  802732:	5e                   	pop    %esi
  802733:	5d                   	pop    %ebp
  802734:	c3                   	ret    

00802735 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802735:	55                   	push   %ebp
  802736:	89 e5                	mov    %esp,%ebp
  802738:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80273b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80273e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802742:	8b 45 08             	mov    0x8(%ebp),%eax
  802745:	89 04 24             	mov    %eax,(%esp)
  802748:	e8 89 ef ff ff       	call   8016d6 <fd_lookup>
  80274d:	89 c2                	mov    %eax,%edx
  80274f:	85 d2                	test   %edx,%edx
  802751:	78 15                	js     802768 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	89 04 24             	mov    %eax,(%esp)
  802759:	e8 12 ef ff ff       	call   801670 <fd2data>
	return _pipeisclosed(fd, p);
  80275e:	89 c2                	mov    %eax,%edx
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	e8 0b fd ff ff       	call   802473 <_pipeisclosed>
}
  802768:	c9                   	leave  
  802769:	c3                   	ret    
  80276a:	66 90                	xchg   %ax,%ax
  80276c:	66 90                	xchg   %ax,%ax
  80276e:	66 90                	xchg   %ax,%ax

00802770 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802773:	b8 00 00 00 00       	mov    $0x0,%eax
  802778:	5d                   	pop    %ebp
  802779:	c3                   	ret    

0080277a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802780:	c7 44 24 04 5f 33 80 	movl   $0x80335f,0x4(%esp)
  802787:	00 
  802788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80278b:	89 04 24             	mov    %eax,(%esp)
  80278e:	e8 84 e1 ff ff       	call   800917 <strcpy>
	return 0;
}
  802793:	b8 00 00 00 00       	mov    $0x0,%eax
  802798:	c9                   	leave  
  802799:	c3                   	ret    

0080279a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80279a:	55                   	push   %ebp
  80279b:	89 e5                	mov    %esp,%ebp
  80279d:	57                   	push   %edi
  80279e:	56                   	push   %esi
  80279f:	53                   	push   %ebx
  8027a0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027ab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027b1:	eb 31                	jmp    8027e4 <devcons_write+0x4a>
		m = n - tot;
  8027b3:	8b 75 10             	mov    0x10(%ebp),%esi
  8027b6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8027b8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8027bb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8027c0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027c3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8027c7:	03 45 0c             	add    0xc(%ebp),%eax
  8027ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ce:	89 3c 24             	mov    %edi,(%esp)
  8027d1:	e8 de e2 ff ff       	call   800ab4 <memmove>
		sys_cputs(buf, m);
  8027d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027da:	89 3c 24             	mov    %edi,(%esp)
  8027dd:	e8 84 e4 ff ff       	call   800c66 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027e2:	01 f3                	add    %esi,%ebx
  8027e4:	89 d8                	mov    %ebx,%eax
  8027e6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8027e9:	72 c8                	jb     8027b3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8027eb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8027f1:	5b                   	pop    %ebx
  8027f2:	5e                   	pop    %esi
  8027f3:	5f                   	pop    %edi
  8027f4:	5d                   	pop    %ebp
  8027f5:	c3                   	ret    

008027f6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027f6:	55                   	push   %ebp
  8027f7:	89 e5                	mov    %esp,%ebp
  8027f9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8027fc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802801:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802805:	75 07                	jne    80280e <devcons_read+0x18>
  802807:	eb 2a                	jmp    802833 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802809:	e8 06 e5 ff ff       	call   800d14 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80280e:	66 90                	xchg   %ax,%ax
  802810:	e8 6f e4 ff ff       	call   800c84 <sys_cgetc>
  802815:	85 c0                	test   %eax,%eax
  802817:	74 f0                	je     802809 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802819:	85 c0                	test   %eax,%eax
  80281b:	78 16                	js     802833 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80281d:	83 f8 04             	cmp    $0x4,%eax
  802820:	74 0c                	je     80282e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802822:	8b 55 0c             	mov    0xc(%ebp),%edx
  802825:	88 02                	mov    %al,(%edx)
	return 1;
  802827:	b8 01 00 00 00       	mov    $0x1,%eax
  80282c:	eb 05                	jmp    802833 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80282e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802833:	c9                   	leave  
  802834:	c3                   	ret    

00802835 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802835:	55                   	push   %ebp
  802836:	89 e5                	mov    %esp,%ebp
  802838:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802841:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802848:	00 
  802849:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80284c:	89 04 24             	mov    %eax,(%esp)
  80284f:	e8 12 e4 ff ff       	call   800c66 <sys_cputs>
}
  802854:	c9                   	leave  
  802855:	c3                   	ret    

00802856 <getchar>:

int
getchar(void)
{
  802856:	55                   	push   %ebp
  802857:	89 e5                	mov    %esp,%ebp
  802859:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80285c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802863:	00 
  802864:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802867:	89 44 24 04          	mov    %eax,0x4(%esp)
  80286b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802872:	e8 f3 f0 ff ff       	call   80196a <read>
	if (r < 0)
  802877:	85 c0                	test   %eax,%eax
  802879:	78 0f                	js     80288a <getchar+0x34>
		return r;
	if (r < 1)
  80287b:	85 c0                	test   %eax,%eax
  80287d:	7e 06                	jle    802885 <getchar+0x2f>
		return -E_EOF;
	return c;
  80287f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802883:	eb 05                	jmp    80288a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802885:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80288a:	c9                   	leave  
  80288b:	c3                   	ret    

0080288c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80288c:	55                   	push   %ebp
  80288d:	89 e5                	mov    %esp,%ebp
  80288f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802892:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802895:	89 44 24 04          	mov    %eax,0x4(%esp)
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	89 04 24             	mov    %eax,(%esp)
  80289f:	e8 32 ee ff ff       	call   8016d6 <fd_lookup>
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	78 11                	js     8028b9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 15 60 40 80 00    	mov    0x804060,%edx
  8028b1:	39 10                	cmp    %edx,(%eax)
  8028b3:	0f 94 c0             	sete   %al
  8028b6:	0f b6 c0             	movzbl %al,%eax
}
  8028b9:	c9                   	leave  
  8028ba:	c3                   	ret    

008028bb <opencons>:

int
opencons(void)
{
  8028bb:	55                   	push   %ebp
  8028bc:	89 e5                	mov    %esp,%ebp
  8028be:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028c4:	89 04 24             	mov    %eax,(%esp)
  8028c7:	e8 bb ed ff ff       	call   801687 <fd_alloc>
		return r;
  8028cc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028ce:	85 c0                	test   %eax,%eax
  8028d0:	78 40                	js     802912 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028d9:	00 
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028e8:	e8 46 e4 ff ff       	call   800d33 <sys_page_alloc>
		return r;
  8028ed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028ef:	85 c0                	test   %eax,%eax
  8028f1:	78 1f                	js     802912 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8028f3:	8b 15 60 40 80 00    	mov    0x804060,%edx
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802908:	89 04 24             	mov    %eax,(%esp)
  80290b:	e8 50 ed ff ff       	call   801660 <fd2num>
  802910:	89 c2                	mov    %eax,%edx
}
  802912:	89 d0                	mov    %edx,%eax
  802914:	c9                   	leave  
  802915:	c3                   	ret    

00802916 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
  802919:	56                   	push   %esi
  80291a:	53                   	push   %ebx
  80291b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80291e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802921:	8b 35 08 40 80 00    	mov    0x804008,%esi
  802927:	e8 c9 e3 ff ff       	call   800cf5 <sys_getenvid>
  80292c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80292f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802933:	8b 55 08             	mov    0x8(%ebp),%edx
  802936:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80293a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80293e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802942:	c7 04 24 6c 33 80 00 	movl   $0x80336c,(%esp)
  802949:	e8 9a d9 ff ff       	call   8002e8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80294e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802952:	8b 45 10             	mov    0x10(%ebp),%eax
  802955:	89 04 24             	mov    %eax,(%esp)
  802958:	e8 2a d9 ff ff       	call   800287 <vcprintf>
	cprintf("\n");
  80295d:	c7 04 24 58 33 80 00 	movl   $0x803358,(%esp)
  802964:	e8 7f d9 ff ff       	call   8002e8 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802969:	cc                   	int3   
  80296a:	eb fd                	jmp    802969 <_panic+0x53>

0080296c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80296c:	55                   	push   %ebp
  80296d:	89 e5                	mov    %esp,%ebp
  80296f:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802972:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802979:	75 70                	jne    8029eb <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  80297b:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  802982:	00 
  802983:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80298a:	ee 
  80298b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802992:	e8 9c e3 ff ff       	call   800d33 <sys_page_alloc>
		if (error < 0)
  802997:	85 c0                	test   %eax,%eax
  802999:	79 1c                	jns    8029b7 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  80299b:	c7 44 24 08 90 33 80 	movl   $0x803390,0x8(%esp)
  8029a2:	00 
  8029a3:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8029aa:	00 
  8029ab:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  8029b2:	e8 5f ff ff ff       	call   802916 <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8029b7:	c7 44 24 04 f5 29 80 	movl   $0x8029f5,0x4(%esp)
  8029be:	00 
  8029bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029c6:	e8 08 e5 ff ff       	call   800ed3 <sys_env_set_pgfault_upcall>
		if (error < 0)
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	79 1c                	jns    8029eb <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  8029cf:	c7 44 24 08 b8 33 80 	movl   $0x8033b8,0x8(%esp)
  8029d6:	00 
  8029d7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8029de:	00 
  8029df:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  8029e6:	e8 2b ff ff ff       	call   802916 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8029f3:	c9                   	leave  
  8029f4:	c3                   	ret    

008029f5 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029f5:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029f6:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8029fb:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029fd:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  802a00:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  802a04:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802a09:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  802a0d:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  802a0f:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802a12:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802a13:	83 c4 04             	add    $0x4,%esp
	popfl
  802a16:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a17:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802a18:	c3                   	ret    

00802a19 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a19:	55                   	push   %ebp
  802a1a:	89 e5                	mov    %esp,%ebp
  802a1c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a1f:	89 d0                	mov    %edx,%eax
  802a21:	c1 e8 16             	shr    $0x16,%eax
  802a24:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a2b:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a30:	f6 c1 01             	test   $0x1,%cl
  802a33:	74 1d                	je     802a52 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802a35:	c1 ea 0c             	shr    $0xc,%edx
  802a38:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a3f:	f6 c2 01             	test   $0x1,%dl
  802a42:	74 0e                	je     802a52 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a44:	c1 ea 0c             	shr    $0xc,%edx
  802a47:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a4e:	ef 
  802a4f:	0f b7 c0             	movzwl %ax,%eax
}
  802a52:	5d                   	pop    %ebp
  802a53:	c3                   	ret    
  802a54:	66 90                	xchg   %ax,%ax
  802a56:	66 90                	xchg   %ax,%ax
  802a58:	66 90                	xchg   %ax,%ax
  802a5a:	66 90                	xchg   %ax,%ax
  802a5c:	66 90                	xchg   %ax,%ax
  802a5e:	66 90                	xchg   %ax,%ax

00802a60 <__udivdi3>:
  802a60:	55                   	push   %ebp
  802a61:	57                   	push   %edi
  802a62:	56                   	push   %esi
  802a63:	83 ec 0c             	sub    $0xc,%esp
  802a66:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a6a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802a6e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802a72:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a76:	85 c0                	test   %eax,%eax
  802a78:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802a7c:	89 ea                	mov    %ebp,%edx
  802a7e:	89 0c 24             	mov    %ecx,(%esp)
  802a81:	75 2d                	jne    802ab0 <__udivdi3+0x50>
  802a83:	39 e9                	cmp    %ebp,%ecx
  802a85:	77 61                	ja     802ae8 <__udivdi3+0x88>
  802a87:	85 c9                	test   %ecx,%ecx
  802a89:	89 ce                	mov    %ecx,%esi
  802a8b:	75 0b                	jne    802a98 <__udivdi3+0x38>
  802a8d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a92:	31 d2                	xor    %edx,%edx
  802a94:	f7 f1                	div    %ecx
  802a96:	89 c6                	mov    %eax,%esi
  802a98:	31 d2                	xor    %edx,%edx
  802a9a:	89 e8                	mov    %ebp,%eax
  802a9c:	f7 f6                	div    %esi
  802a9e:	89 c5                	mov    %eax,%ebp
  802aa0:	89 f8                	mov    %edi,%eax
  802aa2:	f7 f6                	div    %esi
  802aa4:	89 ea                	mov    %ebp,%edx
  802aa6:	83 c4 0c             	add    $0xc,%esp
  802aa9:	5e                   	pop    %esi
  802aaa:	5f                   	pop    %edi
  802aab:	5d                   	pop    %ebp
  802aac:	c3                   	ret    
  802aad:	8d 76 00             	lea    0x0(%esi),%esi
  802ab0:	39 e8                	cmp    %ebp,%eax
  802ab2:	77 24                	ja     802ad8 <__udivdi3+0x78>
  802ab4:	0f bd e8             	bsr    %eax,%ebp
  802ab7:	83 f5 1f             	xor    $0x1f,%ebp
  802aba:	75 3c                	jne    802af8 <__udivdi3+0x98>
  802abc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802ac0:	39 34 24             	cmp    %esi,(%esp)
  802ac3:	0f 86 9f 00 00 00    	jbe    802b68 <__udivdi3+0x108>
  802ac9:	39 d0                	cmp    %edx,%eax
  802acb:	0f 82 97 00 00 00    	jb     802b68 <__udivdi3+0x108>
  802ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ad8:	31 d2                	xor    %edx,%edx
  802ada:	31 c0                	xor    %eax,%eax
  802adc:	83 c4 0c             	add    $0xc,%esp
  802adf:	5e                   	pop    %esi
  802ae0:	5f                   	pop    %edi
  802ae1:	5d                   	pop    %ebp
  802ae2:	c3                   	ret    
  802ae3:	90                   	nop
  802ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ae8:	89 f8                	mov    %edi,%eax
  802aea:	f7 f1                	div    %ecx
  802aec:	31 d2                	xor    %edx,%edx
  802aee:	83 c4 0c             	add    $0xc,%esp
  802af1:	5e                   	pop    %esi
  802af2:	5f                   	pop    %edi
  802af3:	5d                   	pop    %ebp
  802af4:	c3                   	ret    
  802af5:	8d 76 00             	lea    0x0(%esi),%esi
  802af8:	89 e9                	mov    %ebp,%ecx
  802afa:	8b 3c 24             	mov    (%esp),%edi
  802afd:	d3 e0                	shl    %cl,%eax
  802aff:	89 c6                	mov    %eax,%esi
  802b01:	b8 20 00 00 00       	mov    $0x20,%eax
  802b06:	29 e8                	sub    %ebp,%eax
  802b08:	89 c1                	mov    %eax,%ecx
  802b0a:	d3 ef                	shr    %cl,%edi
  802b0c:	89 e9                	mov    %ebp,%ecx
  802b0e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802b12:	8b 3c 24             	mov    (%esp),%edi
  802b15:	09 74 24 08          	or     %esi,0x8(%esp)
  802b19:	89 d6                	mov    %edx,%esi
  802b1b:	d3 e7                	shl    %cl,%edi
  802b1d:	89 c1                	mov    %eax,%ecx
  802b1f:	89 3c 24             	mov    %edi,(%esp)
  802b22:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b26:	d3 ee                	shr    %cl,%esi
  802b28:	89 e9                	mov    %ebp,%ecx
  802b2a:	d3 e2                	shl    %cl,%edx
  802b2c:	89 c1                	mov    %eax,%ecx
  802b2e:	d3 ef                	shr    %cl,%edi
  802b30:	09 d7                	or     %edx,%edi
  802b32:	89 f2                	mov    %esi,%edx
  802b34:	89 f8                	mov    %edi,%eax
  802b36:	f7 74 24 08          	divl   0x8(%esp)
  802b3a:	89 d6                	mov    %edx,%esi
  802b3c:	89 c7                	mov    %eax,%edi
  802b3e:	f7 24 24             	mull   (%esp)
  802b41:	39 d6                	cmp    %edx,%esi
  802b43:	89 14 24             	mov    %edx,(%esp)
  802b46:	72 30                	jb     802b78 <__udivdi3+0x118>
  802b48:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b4c:	89 e9                	mov    %ebp,%ecx
  802b4e:	d3 e2                	shl    %cl,%edx
  802b50:	39 c2                	cmp    %eax,%edx
  802b52:	73 05                	jae    802b59 <__udivdi3+0xf9>
  802b54:	3b 34 24             	cmp    (%esp),%esi
  802b57:	74 1f                	je     802b78 <__udivdi3+0x118>
  802b59:	89 f8                	mov    %edi,%eax
  802b5b:	31 d2                	xor    %edx,%edx
  802b5d:	e9 7a ff ff ff       	jmp    802adc <__udivdi3+0x7c>
  802b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b68:	31 d2                	xor    %edx,%edx
  802b6a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b6f:	e9 68 ff ff ff       	jmp    802adc <__udivdi3+0x7c>
  802b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b78:	8d 47 ff             	lea    -0x1(%edi),%eax
  802b7b:	31 d2                	xor    %edx,%edx
  802b7d:	83 c4 0c             	add    $0xc,%esp
  802b80:	5e                   	pop    %esi
  802b81:	5f                   	pop    %edi
  802b82:	5d                   	pop    %ebp
  802b83:	c3                   	ret    
  802b84:	66 90                	xchg   %ax,%ax
  802b86:	66 90                	xchg   %ax,%ax
  802b88:	66 90                	xchg   %ax,%ax
  802b8a:	66 90                	xchg   %ax,%ax
  802b8c:	66 90                	xchg   %ax,%ax
  802b8e:	66 90                	xchg   %ax,%ax

00802b90 <__umoddi3>:
  802b90:	55                   	push   %ebp
  802b91:	57                   	push   %edi
  802b92:	56                   	push   %esi
  802b93:	83 ec 14             	sub    $0x14,%esp
  802b96:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b9a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b9e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802ba2:	89 c7                	mov    %eax,%edi
  802ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ba8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802bac:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802bb0:	89 34 24             	mov    %esi,(%esp)
  802bb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bb7:	85 c0                	test   %eax,%eax
  802bb9:	89 c2                	mov    %eax,%edx
  802bbb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bbf:	75 17                	jne    802bd8 <__umoddi3+0x48>
  802bc1:	39 fe                	cmp    %edi,%esi
  802bc3:	76 4b                	jbe    802c10 <__umoddi3+0x80>
  802bc5:	89 c8                	mov    %ecx,%eax
  802bc7:	89 fa                	mov    %edi,%edx
  802bc9:	f7 f6                	div    %esi
  802bcb:	89 d0                	mov    %edx,%eax
  802bcd:	31 d2                	xor    %edx,%edx
  802bcf:	83 c4 14             	add    $0x14,%esp
  802bd2:	5e                   	pop    %esi
  802bd3:	5f                   	pop    %edi
  802bd4:	5d                   	pop    %ebp
  802bd5:	c3                   	ret    
  802bd6:	66 90                	xchg   %ax,%ax
  802bd8:	39 f8                	cmp    %edi,%eax
  802bda:	77 54                	ja     802c30 <__umoddi3+0xa0>
  802bdc:	0f bd e8             	bsr    %eax,%ebp
  802bdf:	83 f5 1f             	xor    $0x1f,%ebp
  802be2:	75 5c                	jne    802c40 <__umoddi3+0xb0>
  802be4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802be8:	39 3c 24             	cmp    %edi,(%esp)
  802beb:	0f 87 e7 00 00 00    	ja     802cd8 <__umoddi3+0x148>
  802bf1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802bf5:	29 f1                	sub    %esi,%ecx
  802bf7:	19 c7                	sbb    %eax,%edi
  802bf9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bfd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c01:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c05:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802c09:	83 c4 14             	add    $0x14,%esp
  802c0c:	5e                   	pop    %esi
  802c0d:	5f                   	pop    %edi
  802c0e:	5d                   	pop    %ebp
  802c0f:	c3                   	ret    
  802c10:	85 f6                	test   %esi,%esi
  802c12:	89 f5                	mov    %esi,%ebp
  802c14:	75 0b                	jne    802c21 <__umoddi3+0x91>
  802c16:	b8 01 00 00 00       	mov    $0x1,%eax
  802c1b:	31 d2                	xor    %edx,%edx
  802c1d:	f7 f6                	div    %esi
  802c1f:	89 c5                	mov    %eax,%ebp
  802c21:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c25:	31 d2                	xor    %edx,%edx
  802c27:	f7 f5                	div    %ebp
  802c29:	89 c8                	mov    %ecx,%eax
  802c2b:	f7 f5                	div    %ebp
  802c2d:	eb 9c                	jmp    802bcb <__umoddi3+0x3b>
  802c2f:	90                   	nop
  802c30:	89 c8                	mov    %ecx,%eax
  802c32:	89 fa                	mov    %edi,%edx
  802c34:	83 c4 14             	add    $0x14,%esp
  802c37:	5e                   	pop    %esi
  802c38:	5f                   	pop    %edi
  802c39:	5d                   	pop    %ebp
  802c3a:	c3                   	ret    
  802c3b:	90                   	nop
  802c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c40:	8b 04 24             	mov    (%esp),%eax
  802c43:	be 20 00 00 00       	mov    $0x20,%esi
  802c48:	89 e9                	mov    %ebp,%ecx
  802c4a:	29 ee                	sub    %ebp,%esi
  802c4c:	d3 e2                	shl    %cl,%edx
  802c4e:	89 f1                	mov    %esi,%ecx
  802c50:	d3 e8                	shr    %cl,%eax
  802c52:	89 e9                	mov    %ebp,%ecx
  802c54:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c58:	8b 04 24             	mov    (%esp),%eax
  802c5b:	09 54 24 04          	or     %edx,0x4(%esp)
  802c5f:	89 fa                	mov    %edi,%edx
  802c61:	d3 e0                	shl    %cl,%eax
  802c63:	89 f1                	mov    %esi,%ecx
  802c65:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c69:	8b 44 24 10          	mov    0x10(%esp),%eax
  802c6d:	d3 ea                	shr    %cl,%edx
  802c6f:	89 e9                	mov    %ebp,%ecx
  802c71:	d3 e7                	shl    %cl,%edi
  802c73:	89 f1                	mov    %esi,%ecx
  802c75:	d3 e8                	shr    %cl,%eax
  802c77:	89 e9                	mov    %ebp,%ecx
  802c79:	09 f8                	or     %edi,%eax
  802c7b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802c7f:	f7 74 24 04          	divl   0x4(%esp)
  802c83:	d3 e7                	shl    %cl,%edi
  802c85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c89:	89 d7                	mov    %edx,%edi
  802c8b:	f7 64 24 08          	mull   0x8(%esp)
  802c8f:	39 d7                	cmp    %edx,%edi
  802c91:	89 c1                	mov    %eax,%ecx
  802c93:	89 14 24             	mov    %edx,(%esp)
  802c96:	72 2c                	jb     802cc4 <__umoddi3+0x134>
  802c98:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802c9c:	72 22                	jb     802cc0 <__umoddi3+0x130>
  802c9e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802ca2:	29 c8                	sub    %ecx,%eax
  802ca4:	19 d7                	sbb    %edx,%edi
  802ca6:	89 e9                	mov    %ebp,%ecx
  802ca8:	89 fa                	mov    %edi,%edx
  802caa:	d3 e8                	shr    %cl,%eax
  802cac:	89 f1                	mov    %esi,%ecx
  802cae:	d3 e2                	shl    %cl,%edx
  802cb0:	89 e9                	mov    %ebp,%ecx
  802cb2:	d3 ef                	shr    %cl,%edi
  802cb4:	09 d0                	or     %edx,%eax
  802cb6:	89 fa                	mov    %edi,%edx
  802cb8:	83 c4 14             	add    $0x14,%esp
  802cbb:	5e                   	pop    %esi
  802cbc:	5f                   	pop    %edi
  802cbd:	5d                   	pop    %ebp
  802cbe:	c3                   	ret    
  802cbf:	90                   	nop
  802cc0:	39 d7                	cmp    %edx,%edi
  802cc2:	75 da                	jne    802c9e <__umoddi3+0x10e>
  802cc4:	8b 14 24             	mov    (%esp),%edx
  802cc7:	89 c1                	mov    %eax,%ecx
  802cc9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802ccd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802cd1:	eb cb                	jmp    802c9e <__umoddi3+0x10e>
  802cd3:	90                   	nop
  802cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cd8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802cdc:	0f 82 0f ff ff ff    	jb     802bf1 <__umoddi3+0x61>
  802ce2:	e9 1a ff ff ff       	jmp    802c01 <__umoddi3+0x71>
