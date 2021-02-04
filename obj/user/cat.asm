
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 34 01 00 00       	call   800165 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 20             	sub    $0x20,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003e:	eb 43                	jmp    800083 <cat+0x50>
		if ((r = write(1, buf, n)) != n)
  800040:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800044:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  80004b:	00 
  80004c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800053:	e8 bf 14 00 00       	call   801517 <write>
  800058:	39 d8                	cmp    %ebx,%eax
  80005a:	74 27                	je     800083 <cat+0x50>
			panic("write error copying %s: %e", s, r);
  80005c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800060:	8b 45 0c             	mov    0xc(%ebp),%eax
  800063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800067:	c7 44 24 08 00 29 80 	movl   $0x802900,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 1b 29 80 00 	movl   $0x80291b,(%esp)
  80007e:	e8 47 01 00 00       	call   8001ca <_panic>
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800083:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
  80008a:	00 
  80008b:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  800092:	00 
  800093:	89 34 24             	mov    %esi,(%esp)
  800096:	e8 9f 13 00 00       	call   80143a <read>
  80009b:	89 c3                	mov    %eax,%ebx
  80009d:	85 c0                	test   %eax,%eax
  80009f:	7f 9f                	jg     800040 <cat+0xd>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	79 27                	jns    8000cc <cat+0x99>
		panic("error reading %s: %e", s, n);
  8000a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b0:	c7 44 24 08 26 29 80 	movl   $0x802926,0x8(%esp)
  8000b7:	00 
  8000b8:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000bf:	00 
  8000c0:	c7 04 24 1b 29 80 00 	movl   $0x80291b,(%esp)
  8000c7:	e8 fe 00 00 00       	call   8001ca <_panic>
}
  8000cc:	83 c4 20             	add    $0x20,%esp
  8000cf:	5b                   	pop    %ebx
  8000d0:	5e                   	pop    %esi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    

008000d3 <umain>:

void
umain(int argc, char **argv)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	57                   	push   %edi
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 1c             	sub    $0x1c,%esp
  8000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000df:	c7 05 00 30 80 00 3b 	movl   $0x80293b,0x803000
  8000e6:	29 80 00 
	if (argc == 1)
  8000e9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ed:	74 07                	je     8000f6 <umain+0x23>
  8000ef:	bb 01 00 00 00       	mov    $0x1,%ebx
  8000f4:	eb 62                	jmp    800158 <umain+0x85>
		cat(0, "<stdin>");
  8000f6:	c7 44 24 04 3f 29 80 	movl   $0x80293f,0x4(%esp)
  8000fd:	00 
  8000fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800105:	e8 29 ff ff ff       	call   800033 <cat>
  80010a:	eb 51                	jmp    80015d <umain+0x8a>
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  80010c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800113:	00 
  800114:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800117:	89 04 24             	mov    %eax,(%esp)
  80011a:	e8 e7 17 00 00       	call   801906 <open>
  80011f:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800121:	85 c0                	test   %eax,%eax
  800123:	79 19                	jns    80013e <umain+0x6b>
				printf("can't open %s: %e\n", argv[i], f);
  800125:	89 44 24 08          	mov    %eax,0x8(%esp)
  800129:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800130:	c7 04 24 47 29 80 00 	movl   $0x802947,(%esp)
  800137:	e8 7a 19 00 00       	call   801ab6 <printf>
  80013c:	eb 17                	jmp    800155 <umain+0x82>
			else {
				cat(f, argv[i]);
  80013e:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800141:	89 44 24 04          	mov    %eax,0x4(%esp)
  800145:	89 34 24             	mov    %esi,(%esp)
  800148:	e8 e6 fe ff ff       	call   800033 <cat>
				close(f);
  80014d:	89 34 24             	mov    %esi,(%esp)
  800150:	e8 82 11 00 00       	call   8012d7 <close>

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800155:	83 c3 01             	add    $0x1,%ebx
  800158:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  80015b:	7c af                	jl     80010c <umain+0x39>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  80015d:	83 c4 1c             	add    $0x1c,%esp
  800160:	5b                   	pop    %ebx
  800161:	5e                   	pop    %esi
  800162:	5f                   	pop    %edi
  800163:	5d                   	pop    %ebp
  800164:	c3                   	ret    

00800165 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	56                   	push   %esi
  800169:	53                   	push   %ebx
  80016a:	83 ec 10             	sub    $0x10,%esp
  80016d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800170:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800173:	e8 4d 0b 00 00       	call   800cc5 <sys_getenvid>
  800178:	25 ff 03 00 00       	and    $0x3ff,%eax
  80017d:	89 c2                	mov    %eax,%edx
  80017f:	c1 e2 07             	shl    $0x7,%edx
  800182:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800189:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018e:	85 db                	test   %ebx,%ebx
  800190:	7e 07                	jle    800199 <libmain+0x34>
		binaryname = argv[0];
  800192:	8b 06                	mov    (%esi),%eax
  800194:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800199:	89 74 24 04          	mov    %esi,0x4(%esp)
  80019d:	89 1c 24             	mov    %ebx,(%esp)
  8001a0:	e8 2e ff ff ff       	call   8000d3 <umain>

	// exit gracefully
	exit();
  8001a5:	e8 07 00 00 00       	call   8001b1 <exit>
}
  8001aa:	83 c4 10             	add    $0x10,%esp
  8001ad:	5b                   	pop    %ebx
  8001ae:	5e                   	pop    %esi
  8001af:	5d                   	pop    %ebp
  8001b0:	c3                   	ret    

008001b1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001b7:	e8 4e 11 00 00       	call   80130a <close_all>
	sys_env_destroy(0);
  8001bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001c3:	e8 ab 0a 00 00       	call   800c73 <sys_env_destroy>
}
  8001c8:	c9                   	leave  
  8001c9:	c3                   	ret    

008001ca <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	56                   	push   %esi
  8001ce:	53                   	push   %ebx
  8001cf:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001d2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001d5:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001db:	e8 e5 0a 00 00       	call   800cc5 <sys_getenvid>
  8001e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ea:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001ee:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f6:	c7 04 24 64 29 80 00 	movl   $0x802964,(%esp)
  8001fd:	e8 c1 00 00 00       	call   8002c3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800202:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800206:	8b 45 10             	mov    0x10(%ebp),%eax
  800209:	89 04 24             	mov    %eax,(%esp)
  80020c:	e8 51 00 00 00       	call   800262 <vcprintf>
	cprintf("\n");
  800211:	c7 04 24 0c 2e 80 00 	movl   $0x802e0c,(%esp)
  800218:	e8 a6 00 00 00       	call   8002c3 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80021d:	cc                   	int3   
  80021e:	eb fd                	jmp    80021d <_panic+0x53>

00800220 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	53                   	push   %ebx
  800224:	83 ec 14             	sub    $0x14,%esp
  800227:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80022a:	8b 13                	mov    (%ebx),%edx
  80022c:	8d 42 01             	lea    0x1(%edx),%eax
  80022f:	89 03                	mov    %eax,(%ebx)
  800231:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800234:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800238:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023d:	75 19                	jne    800258 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80023f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800246:	00 
  800247:	8d 43 08             	lea    0x8(%ebx),%eax
  80024a:	89 04 24             	mov    %eax,(%esp)
  80024d:	e8 e4 09 00 00       	call   800c36 <sys_cputs>
		b->idx = 0;
  800252:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800258:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80025c:	83 c4 14             	add    $0x14,%esp
  80025f:	5b                   	pop    %ebx
  800260:	5d                   	pop    %ebp
  800261:	c3                   	ret    

00800262 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80026b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800272:	00 00 00 
	b.cnt = 0;
  800275:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80027c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80027f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800282:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800286:	8b 45 08             	mov    0x8(%ebp),%eax
  800289:	89 44 24 08          	mov    %eax,0x8(%esp)
  80028d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800293:	89 44 24 04          	mov    %eax,0x4(%esp)
  800297:	c7 04 24 20 02 80 00 	movl   $0x800220,(%esp)
  80029e:	e8 ab 01 00 00       	call   80044e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002a3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ad:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002b3:	89 04 24             	mov    %eax,(%esp)
  8002b6:	e8 7b 09 00 00       	call   800c36 <sys_cputs>

	return b.cnt;
}
  8002bb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    

008002c3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d3:	89 04 24             	mov    %eax,(%esp)
  8002d6:	e8 87 ff ff ff       	call   800262 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    
  8002dd:	66 90                	xchg   %ax,%ax
  8002df:	90                   	nop

008002e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	57                   	push   %edi
  8002e4:	56                   	push   %esi
  8002e5:	53                   	push   %ebx
  8002e6:	83 ec 3c             	sub    $0x3c,%esp
  8002e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ec:	89 d7                	mov    %edx,%edi
  8002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f7:	89 c3                	mov    %eax,%ebx
  8002f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ff:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800302:	b9 00 00 00 00       	mov    $0x0,%ecx
  800307:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80030a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80030d:	39 d9                	cmp    %ebx,%ecx
  80030f:	72 05                	jb     800316 <printnum+0x36>
  800311:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800314:	77 69                	ja     80037f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800316:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800319:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80031d:	83 ee 01             	sub    $0x1,%esi
  800320:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800324:	89 44 24 08          	mov    %eax,0x8(%esp)
  800328:	8b 44 24 08          	mov    0x8(%esp),%eax
  80032c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800330:	89 c3                	mov    %eax,%ebx
  800332:	89 d6                	mov    %edx,%esi
  800334:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800337:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80033a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80033e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800342:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800345:	89 04 24             	mov    %eax,(%esp)
  800348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034f:	e8 0c 23 00 00       	call   802660 <__udivdi3>
  800354:	89 d9                	mov    %ebx,%ecx
  800356:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80035a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80035e:	89 04 24             	mov    %eax,(%esp)
  800361:	89 54 24 04          	mov    %edx,0x4(%esp)
  800365:	89 fa                	mov    %edi,%edx
  800367:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80036a:	e8 71 ff ff ff       	call   8002e0 <printnum>
  80036f:	eb 1b                	jmp    80038c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800371:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800375:	8b 45 18             	mov    0x18(%ebp),%eax
  800378:	89 04 24             	mov    %eax,(%esp)
  80037b:	ff d3                	call   *%ebx
  80037d:	eb 03                	jmp    800382 <printnum+0xa2>
  80037f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800382:	83 ee 01             	sub    $0x1,%esi
  800385:	85 f6                	test   %esi,%esi
  800387:	7f e8                	jg     800371 <printnum+0x91>
  800389:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80038c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800390:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800394:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800397:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80039a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80039e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a5:	89 04 24             	mov    %eax,(%esp)
  8003a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003af:	e8 dc 23 00 00       	call   802790 <__umoddi3>
  8003b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003b8:	0f be 80 87 29 80 00 	movsbl 0x802987(%eax),%eax
  8003bf:	89 04 24             	mov    %eax,(%esp)
  8003c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003c5:	ff d0                	call   *%eax
}
  8003c7:	83 c4 3c             	add    $0x3c,%esp
  8003ca:	5b                   	pop    %ebx
  8003cb:	5e                   	pop    %esi
  8003cc:	5f                   	pop    %edi
  8003cd:	5d                   	pop    %ebp
  8003ce:	c3                   	ret    

008003cf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003cf:	55                   	push   %ebp
  8003d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d2:	83 fa 01             	cmp    $0x1,%edx
  8003d5:	7e 0e                	jle    8003e5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003d7:	8b 10                	mov    (%eax),%edx
  8003d9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003dc:	89 08                	mov    %ecx,(%eax)
  8003de:	8b 02                	mov    (%edx),%eax
  8003e0:	8b 52 04             	mov    0x4(%edx),%edx
  8003e3:	eb 22                	jmp    800407 <getuint+0x38>
	else if (lflag)
  8003e5:	85 d2                	test   %edx,%edx
  8003e7:	74 10                	je     8003f9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ee:	89 08                	mov    %ecx,(%eax)
  8003f0:	8b 02                	mov    (%edx),%eax
  8003f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f7:	eb 0e                	jmp    800407 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003f9:	8b 10                	mov    (%eax),%edx
  8003fb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003fe:	89 08                	mov    %ecx,(%eax)
  800400:	8b 02                	mov    (%edx),%eax
  800402:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800407:	5d                   	pop    %ebp
  800408:	c3                   	ret    

00800409 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80040f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800413:	8b 10                	mov    (%eax),%edx
  800415:	3b 50 04             	cmp    0x4(%eax),%edx
  800418:	73 0a                	jae    800424 <sprintputch+0x1b>
		*b->buf++ = ch;
  80041a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80041d:	89 08                	mov    %ecx,(%eax)
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
  800422:	88 02                	mov    %al,(%edx)
}
  800424:	5d                   	pop    %ebp
  800425:	c3                   	ret    

00800426 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80042c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80042f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800433:	8b 45 10             	mov    0x10(%ebp),%eax
  800436:	89 44 24 08          	mov    %eax,0x8(%esp)
  80043a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	89 04 24             	mov    %eax,(%esp)
  800447:	e8 02 00 00 00       	call   80044e <vprintfmt>
	va_end(ap);
}
  80044c:	c9                   	leave  
  80044d:	c3                   	ret    

0080044e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
  800451:	57                   	push   %edi
  800452:	56                   	push   %esi
  800453:	53                   	push   %ebx
  800454:	83 ec 3c             	sub    $0x3c,%esp
  800457:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80045a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80045d:	eb 14                	jmp    800473 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80045f:	85 c0                	test   %eax,%eax
  800461:	0f 84 b3 03 00 00    	je     80081a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800467:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80046b:	89 04 24             	mov    %eax,(%esp)
  80046e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800471:	89 f3                	mov    %esi,%ebx
  800473:	8d 73 01             	lea    0x1(%ebx),%esi
  800476:	0f b6 03             	movzbl (%ebx),%eax
  800479:	83 f8 25             	cmp    $0x25,%eax
  80047c:	75 e1                	jne    80045f <vprintfmt+0x11>
  80047e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800482:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800489:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800490:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800497:	ba 00 00 00 00       	mov    $0x0,%edx
  80049c:	eb 1d                	jmp    8004bb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004a0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8004a4:	eb 15                	jmp    8004bb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004a8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8004ac:	eb 0d                	jmp    8004bb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004bb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8004be:	0f b6 0e             	movzbl (%esi),%ecx
  8004c1:	0f b6 c1             	movzbl %cl,%eax
  8004c4:	83 e9 23             	sub    $0x23,%ecx
  8004c7:	80 f9 55             	cmp    $0x55,%cl
  8004ca:	0f 87 2a 03 00 00    	ja     8007fa <vprintfmt+0x3ac>
  8004d0:	0f b6 c9             	movzbl %cl,%ecx
  8004d3:	ff 24 8d 00 2b 80 00 	jmp    *0x802b00(,%ecx,4)
  8004da:	89 de                	mov    %ebx,%esi
  8004dc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004e1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004e4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004e8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004eb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004ee:	83 fb 09             	cmp    $0x9,%ebx
  8004f1:	77 36                	ja     800529 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004f3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004f6:	eb e9                	jmp    8004e1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fb:	8d 48 04             	lea    0x4(%eax),%ecx
  8004fe:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800501:	8b 00                	mov    (%eax),%eax
  800503:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800506:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800508:	eb 22                	jmp    80052c <vprintfmt+0xde>
  80050a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80050d:	85 c9                	test   %ecx,%ecx
  80050f:	b8 00 00 00 00       	mov    $0x0,%eax
  800514:	0f 49 c1             	cmovns %ecx,%eax
  800517:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	89 de                	mov    %ebx,%esi
  80051c:	eb 9d                	jmp    8004bb <vprintfmt+0x6d>
  80051e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800520:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800527:	eb 92                	jmp    8004bb <vprintfmt+0x6d>
  800529:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80052c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800530:	79 89                	jns    8004bb <vprintfmt+0x6d>
  800532:	e9 77 ff ff ff       	jmp    8004ae <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800537:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80053c:	e9 7a ff ff ff       	jmp    8004bb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8d 50 04             	lea    0x4(%eax),%edx
  800547:	89 55 14             	mov    %edx,0x14(%ebp)
  80054a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80054e:	8b 00                	mov    (%eax),%eax
  800550:	89 04 24             	mov    %eax,(%esp)
  800553:	ff 55 08             	call   *0x8(%ebp)
			break;
  800556:	e9 18 ff ff ff       	jmp    800473 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8d 50 04             	lea    0x4(%eax),%edx
  800561:	89 55 14             	mov    %edx,0x14(%ebp)
  800564:	8b 00                	mov    (%eax),%eax
  800566:	99                   	cltd   
  800567:	31 d0                	xor    %edx,%eax
  800569:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80056b:	83 f8 12             	cmp    $0x12,%eax
  80056e:	7f 0b                	jg     80057b <vprintfmt+0x12d>
  800570:	8b 14 85 60 2c 80 00 	mov    0x802c60(,%eax,4),%edx
  800577:	85 d2                	test   %edx,%edx
  800579:	75 20                	jne    80059b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80057b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80057f:	c7 44 24 08 9f 29 80 	movl   $0x80299f,0x8(%esp)
  800586:	00 
  800587:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80058b:	8b 45 08             	mov    0x8(%ebp),%eax
  80058e:	89 04 24             	mov    %eax,(%esp)
  800591:	e8 90 fe ff ff       	call   800426 <printfmt>
  800596:	e9 d8 fe ff ff       	jmp    800473 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80059b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80059f:	c7 44 24 08 a1 2d 80 	movl   $0x802da1,0x8(%esp)
  8005a6:	00 
  8005a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	89 04 24             	mov    %eax,(%esp)
  8005b1:	e8 70 fe ff ff       	call   800426 <printfmt>
  8005b6:	e9 b8 fe ff ff       	jmp    800473 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005bb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8d 50 04             	lea    0x4(%eax),%edx
  8005ca:	89 55 14             	mov    %edx,0x14(%ebp)
  8005cd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8005cf:	85 f6                	test   %esi,%esi
  8005d1:	b8 98 29 80 00       	mov    $0x802998,%eax
  8005d6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8005d9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8005dd:	0f 84 97 00 00 00    	je     80067a <vprintfmt+0x22c>
  8005e3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005e7:	0f 8e 9b 00 00 00    	jle    800688 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ed:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005f1:	89 34 24             	mov    %esi,(%esp)
  8005f4:	e8 cf 02 00 00       	call   8008c8 <strnlen>
  8005f9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005fc:	29 c2                	sub    %eax,%edx
  8005fe:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800601:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800605:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800608:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80060b:	8b 75 08             	mov    0x8(%ebp),%esi
  80060e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800611:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800613:	eb 0f                	jmp    800624 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800615:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800619:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80061c:	89 04 24             	mov    %eax,(%esp)
  80061f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800621:	83 eb 01             	sub    $0x1,%ebx
  800624:	85 db                	test   %ebx,%ebx
  800626:	7f ed                	jg     800615 <vprintfmt+0x1c7>
  800628:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80062b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80062e:	85 d2                	test   %edx,%edx
  800630:	b8 00 00 00 00       	mov    $0x0,%eax
  800635:	0f 49 c2             	cmovns %edx,%eax
  800638:	29 c2                	sub    %eax,%edx
  80063a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80063d:	89 d7                	mov    %edx,%edi
  80063f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800642:	eb 50                	jmp    800694 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800644:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800648:	74 1e                	je     800668 <vprintfmt+0x21a>
  80064a:	0f be d2             	movsbl %dl,%edx
  80064d:	83 ea 20             	sub    $0x20,%edx
  800650:	83 fa 5e             	cmp    $0x5e,%edx
  800653:	76 13                	jbe    800668 <vprintfmt+0x21a>
					putch('?', putdat);
  800655:	8b 45 0c             	mov    0xc(%ebp),%eax
  800658:	89 44 24 04          	mov    %eax,0x4(%esp)
  80065c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800663:	ff 55 08             	call   *0x8(%ebp)
  800666:	eb 0d                	jmp    800675 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80066b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80066f:	89 04 24             	mov    %eax,(%esp)
  800672:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800675:	83 ef 01             	sub    $0x1,%edi
  800678:	eb 1a                	jmp    800694 <vprintfmt+0x246>
  80067a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80067d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800680:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800683:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800686:	eb 0c                	jmp    800694 <vprintfmt+0x246>
  800688:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80068b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80068e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800691:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800694:	83 c6 01             	add    $0x1,%esi
  800697:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80069b:	0f be c2             	movsbl %dl,%eax
  80069e:	85 c0                	test   %eax,%eax
  8006a0:	74 27                	je     8006c9 <vprintfmt+0x27b>
  8006a2:	85 db                	test   %ebx,%ebx
  8006a4:	78 9e                	js     800644 <vprintfmt+0x1f6>
  8006a6:	83 eb 01             	sub    $0x1,%ebx
  8006a9:	79 99                	jns    800644 <vprintfmt+0x1f6>
  8006ab:	89 f8                	mov    %edi,%eax
  8006ad:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8006b3:	89 c3                	mov    %eax,%ebx
  8006b5:	eb 1a                	jmp    8006d1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006bb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006c2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006c4:	83 eb 01             	sub    $0x1,%ebx
  8006c7:	eb 08                	jmp    8006d1 <vprintfmt+0x283>
  8006c9:	89 fb                	mov    %edi,%ebx
  8006cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ce:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006d1:	85 db                	test   %ebx,%ebx
  8006d3:	7f e2                	jg     8006b7 <vprintfmt+0x269>
  8006d5:	89 75 08             	mov    %esi,0x8(%ebp)
  8006d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006db:	e9 93 fd ff ff       	jmp    800473 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006e0:	83 fa 01             	cmp    $0x1,%edx
  8006e3:	7e 16                	jle    8006fb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8d 50 08             	lea    0x8(%eax),%edx
  8006eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ee:	8b 50 04             	mov    0x4(%eax),%edx
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006f6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006f9:	eb 32                	jmp    80072d <vprintfmt+0x2df>
	else if (lflag)
  8006fb:	85 d2                	test   %edx,%edx
  8006fd:	74 18                	je     800717 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8d 50 04             	lea    0x4(%eax),%edx
  800705:	89 55 14             	mov    %edx,0x14(%ebp)
  800708:	8b 30                	mov    (%eax),%esi
  80070a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80070d:	89 f0                	mov    %esi,%eax
  80070f:	c1 f8 1f             	sar    $0x1f,%eax
  800712:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800715:	eb 16                	jmp    80072d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 50 04             	lea    0x4(%eax),%edx
  80071d:	89 55 14             	mov    %edx,0x14(%ebp)
  800720:	8b 30                	mov    (%eax),%esi
  800722:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800725:	89 f0                	mov    %esi,%eax
  800727:	c1 f8 1f             	sar    $0x1f,%eax
  80072a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80072d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800730:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800733:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800738:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073c:	0f 89 80 00 00 00    	jns    8007c2 <vprintfmt+0x374>
				putch('-', putdat);
  800742:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800746:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80074d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800750:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800753:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800756:	f7 d8                	neg    %eax
  800758:	83 d2 00             	adc    $0x0,%edx
  80075b:	f7 da                	neg    %edx
			}
			base = 10;
  80075d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800762:	eb 5e                	jmp    8007c2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800764:	8d 45 14             	lea    0x14(%ebp),%eax
  800767:	e8 63 fc ff ff       	call   8003cf <getuint>
			base = 10;
  80076c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800771:	eb 4f                	jmp    8007c2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800773:	8d 45 14             	lea    0x14(%ebp),%eax
  800776:	e8 54 fc ff ff       	call   8003cf <getuint>
			base = 8;
  80077b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800780:	eb 40                	jmp    8007c2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800782:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800786:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80078d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800790:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800794:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80079b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8d 50 04             	lea    0x4(%eax),%edx
  8007a4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007ae:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007b3:	eb 0d                	jmp    8007c2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007b5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b8:	e8 12 fc ff ff       	call   8003cf <getuint>
			base = 16;
  8007bd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007c2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8007c6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007ca:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8007cd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007d1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007d5:	89 04 24             	mov    %eax,(%esp)
  8007d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007dc:	89 fa                	mov    %edi,%edx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	e8 fa fa ff ff       	call   8002e0 <printnum>
			break;
  8007e6:	e9 88 fc ff ff       	jmp    800473 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007eb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ef:	89 04 24             	mov    %eax,(%esp)
  8007f2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007f5:	e9 79 fc ff ff       	jmp    800473 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007fe:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800805:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800808:	89 f3                	mov    %esi,%ebx
  80080a:	eb 03                	jmp    80080f <vprintfmt+0x3c1>
  80080c:	83 eb 01             	sub    $0x1,%ebx
  80080f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800813:	75 f7                	jne    80080c <vprintfmt+0x3be>
  800815:	e9 59 fc ff ff       	jmp    800473 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80081a:	83 c4 3c             	add    $0x3c,%esp
  80081d:	5b                   	pop    %ebx
  80081e:	5e                   	pop    %esi
  80081f:	5f                   	pop    %edi
  800820:	5d                   	pop    %ebp
  800821:	c3                   	ret    

00800822 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	83 ec 28             	sub    $0x28,%esp
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80082e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800831:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800835:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800838:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80083f:	85 c0                	test   %eax,%eax
  800841:	74 30                	je     800873 <vsnprintf+0x51>
  800843:	85 d2                	test   %edx,%edx
  800845:	7e 2c                	jle    800873 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80084e:	8b 45 10             	mov    0x10(%ebp),%eax
  800851:	89 44 24 08          	mov    %eax,0x8(%esp)
  800855:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800858:	89 44 24 04          	mov    %eax,0x4(%esp)
  80085c:	c7 04 24 09 04 80 00 	movl   $0x800409,(%esp)
  800863:	e8 e6 fb ff ff       	call   80044e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800868:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80086e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800871:	eb 05                	jmp    800878 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800873:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800880:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800883:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800887:	8b 45 10             	mov    0x10(%ebp),%eax
  80088a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80088e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800891:	89 44 24 04          	mov    %eax,0x4(%esp)
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	89 04 24             	mov    %eax,(%esp)
  80089b:	e8 82 ff ff ff       	call   800822 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008a0:	c9                   	leave  
  8008a1:	c3                   	ret    
  8008a2:	66 90                	xchg   %ax,%ax
  8008a4:	66 90                	xchg   %ax,%ax
  8008a6:	66 90                	xchg   %ax,%ax
  8008a8:	66 90                	xchg   %ax,%ax
  8008aa:	66 90                	xchg   %ax,%ax
  8008ac:	66 90                	xchg   %ax,%ax
  8008ae:	66 90                	xchg   %ax,%ax

008008b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bb:	eb 03                	jmp    8008c0 <strlen+0x10>
		n++;
  8008bd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c4:	75 f7                	jne    8008bd <strlen+0xd>
		n++;
	return n;
}
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d6:	eb 03                	jmp    8008db <strnlen+0x13>
		n++;
  8008d8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008db:	39 d0                	cmp    %edx,%eax
  8008dd:	74 06                	je     8008e5 <strnlen+0x1d>
  8008df:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008e3:	75 f3                	jne    8008d8 <strnlen+0x10>
		n++;
	return n;
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	53                   	push   %ebx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f1:	89 c2                	mov    %eax,%edx
  8008f3:	83 c2 01             	add    $0x1,%edx
  8008f6:	83 c1 01             	add    $0x1,%ecx
  8008f9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008fd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800900:	84 db                	test   %bl,%bl
  800902:	75 ef                	jne    8008f3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800904:	5b                   	pop    %ebx
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	53                   	push   %ebx
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800911:	89 1c 24             	mov    %ebx,(%esp)
  800914:	e8 97 ff ff ff       	call   8008b0 <strlen>
	strcpy(dst + len, src);
  800919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800920:	01 d8                	add    %ebx,%eax
  800922:	89 04 24             	mov    %eax,(%esp)
  800925:	e8 bd ff ff ff       	call   8008e7 <strcpy>
	return dst;
}
  80092a:	89 d8                	mov    %ebx,%eax
  80092c:	83 c4 08             	add    $0x8,%esp
  80092f:	5b                   	pop    %ebx
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	56                   	push   %esi
  800936:	53                   	push   %ebx
  800937:	8b 75 08             	mov    0x8(%ebp),%esi
  80093a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80093d:	89 f3                	mov    %esi,%ebx
  80093f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800942:	89 f2                	mov    %esi,%edx
  800944:	eb 0f                	jmp    800955 <strncpy+0x23>
		*dst++ = *src;
  800946:	83 c2 01             	add    $0x1,%edx
  800949:	0f b6 01             	movzbl (%ecx),%eax
  80094c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80094f:	80 39 01             	cmpb   $0x1,(%ecx)
  800952:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800955:	39 da                	cmp    %ebx,%edx
  800957:	75 ed                	jne    800946 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800959:	89 f0                	mov    %esi,%eax
  80095b:	5b                   	pop    %ebx
  80095c:	5e                   	pop    %esi
  80095d:	5d                   	pop    %ebp
  80095e:	c3                   	ret    

0080095f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	56                   	push   %esi
  800963:	53                   	push   %ebx
  800964:	8b 75 08             	mov    0x8(%ebp),%esi
  800967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80096d:	89 f0                	mov    %esi,%eax
  80096f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800973:	85 c9                	test   %ecx,%ecx
  800975:	75 0b                	jne    800982 <strlcpy+0x23>
  800977:	eb 1d                	jmp    800996 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800979:	83 c0 01             	add    $0x1,%eax
  80097c:	83 c2 01             	add    $0x1,%edx
  80097f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800982:	39 d8                	cmp    %ebx,%eax
  800984:	74 0b                	je     800991 <strlcpy+0x32>
  800986:	0f b6 0a             	movzbl (%edx),%ecx
  800989:	84 c9                	test   %cl,%cl
  80098b:	75 ec                	jne    800979 <strlcpy+0x1a>
  80098d:	89 c2                	mov    %eax,%edx
  80098f:	eb 02                	jmp    800993 <strlcpy+0x34>
  800991:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800993:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800996:	29 f0                	sub    %esi,%eax
}
  800998:	5b                   	pop    %ebx
  800999:	5e                   	pop    %esi
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009a5:	eb 06                	jmp    8009ad <strcmp+0x11>
		p++, q++;
  8009a7:	83 c1 01             	add    $0x1,%ecx
  8009aa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009ad:	0f b6 01             	movzbl (%ecx),%eax
  8009b0:	84 c0                	test   %al,%al
  8009b2:	74 04                	je     8009b8 <strcmp+0x1c>
  8009b4:	3a 02                	cmp    (%edx),%al
  8009b6:	74 ef                	je     8009a7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b8:	0f b6 c0             	movzbl %al,%eax
  8009bb:	0f b6 12             	movzbl (%edx),%edx
  8009be:	29 d0                	sub    %edx,%eax
}
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	53                   	push   %ebx
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cc:	89 c3                	mov    %eax,%ebx
  8009ce:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009d1:	eb 06                	jmp    8009d9 <strncmp+0x17>
		n--, p++, q++;
  8009d3:	83 c0 01             	add    $0x1,%eax
  8009d6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009d9:	39 d8                	cmp    %ebx,%eax
  8009db:	74 15                	je     8009f2 <strncmp+0x30>
  8009dd:	0f b6 08             	movzbl (%eax),%ecx
  8009e0:	84 c9                	test   %cl,%cl
  8009e2:	74 04                	je     8009e8 <strncmp+0x26>
  8009e4:	3a 0a                	cmp    (%edx),%cl
  8009e6:	74 eb                	je     8009d3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e8:	0f b6 00             	movzbl (%eax),%eax
  8009eb:	0f b6 12             	movzbl (%edx),%edx
  8009ee:	29 d0                	sub    %edx,%eax
  8009f0:	eb 05                	jmp    8009f7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009f2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009f7:	5b                   	pop    %ebx
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a04:	eb 07                	jmp    800a0d <strchr+0x13>
		if (*s == c)
  800a06:	38 ca                	cmp    %cl,%dl
  800a08:	74 0f                	je     800a19 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a0a:	83 c0 01             	add    $0x1,%eax
  800a0d:	0f b6 10             	movzbl (%eax),%edx
  800a10:	84 d2                	test   %dl,%dl
  800a12:	75 f2                	jne    800a06 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a25:	eb 07                	jmp    800a2e <strfind+0x13>
		if (*s == c)
  800a27:	38 ca                	cmp    %cl,%dl
  800a29:	74 0a                	je     800a35 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a2b:	83 c0 01             	add    $0x1,%eax
  800a2e:	0f b6 10             	movzbl (%eax),%edx
  800a31:	84 d2                	test   %dl,%dl
  800a33:	75 f2                	jne    800a27 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    

00800a37 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	57                   	push   %edi
  800a3b:	56                   	push   %esi
  800a3c:	53                   	push   %ebx
  800a3d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a40:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a43:	85 c9                	test   %ecx,%ecx
  800a45:	74 36                	je     800a7d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a47:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a4d:	75 28                	jne    800a77 <memset+0x40>
  800a4f:	f6 c1 03             	test   $0x3,%cl
  800a52:	75 23                	jne    800a77 <memset+0x40>
		c &= 0xFF;
  800a54:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a58:	89 d3                	mov    %edx,%ebx
  800a5a:	c1 e3 08             	shl    $0x8,%ebx
  800a5d:	89 d6                	mov    %edx,%esi
  800a5f:	c1 e6 18             	shl    $0x18,%esi
  800a62:	89 d0                	mov    %edx,%eax
  800a64:	c1 e0 10             	shl    $0x10,%eax
  800a67:	09 f0                	or     %esi,%eax
  800a69:	09 c2                	or     %eax,%edx
  800a6b:	89 d0                	mov    %edx,%eax
  800a6d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a6f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a72:	fc                   	cld    
  800a73:	f3 ab                	rep stos %eax,%es:(%edi)
  800a75:	eb 06                	jmp    800a7d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7a:	fc                   	cld    
  800a7b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a7d:	89 f8                	mov    %edi,%eax
  800a7f:	5b                   	pop    %ebx
  800a80:	5e                   	pop    %esi
  800a81:	5f                   	pop    %edi
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    

00800a84 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	57                   	push   %edi
  800a88:	56                   	push   %esi
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a92:	39 c6                	cmp    %eax,%esi
  800a94:	73 35                	jae    800acb <memmove+0x47>
  800a96:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a99:	39 d0                	cmp    %edx,%eax
  800a9b:	73 2e                	jae    800acb <memmove+0x47>
		s += n;
		d += n;
  800a9d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800aa0:	89 d6                	mov    %edx,%esi
  800aa2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aaa:	75 13                	jne    800abf <memmove+0x3b>
  800aac:	f6 c1 03             	test   $0x3,%cl
  800aaf:	75 0e                	jne    800abf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab1:	83 ef 04             	sub    $0x4,%edi
  800ab4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aba:	fd                   	std    
  800abb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abd:	eb 09                	jmp    800ac8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800abf:	83 ef 01             	sub    $0x1,%edi
  800ac2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ac5:	fd                   	std    
  800ac6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac8:	fc                   	cld    
  800ac9:	eb 1d                	jmp    800ae8 <memmove+0x64>
  800acb:	89 f2                	mov    %esi,%edx
  800acd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acf:	f6 c2 03             	test   $0x3,%dl
  800ad2:	75 0f                	jne    800ae3 <memmove+0x5f>
  800ad4:	f6 c1 03             	test   $0x3,%cl
  800ad7:	75 0a                	jne    800ae3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800adc:	89 c7                	mov    %eax,%edi
  800ade:	fc                   	cld    
  800adf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae1:	eb 05                	jmp    800ae8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ae3:	89 c7                	mov    %eax,%edi
  800ae5:	fc                   	cld    
  800ae6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae8:	5e                   	pop    %esi
  800ae9:	5f                   	pop    %edi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800af2:	8b 45 10             	mov    0x10(%ebp),%eax
  800af5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	89 04 24             	mov    %eax,(%esp)
  800b06:	e8 79 ff ff ff       	call   800a84 <memmove>
}
  800b0b:	c9                   	leave  
  800b0c:	c3                   	ret    

00800b0d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	56                   	push   %esi
  800b11:	53                   	push   %ebx
  800b12:	8b 55 08             	mov    0x8(%ebp),%edx
  800b15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b18:	89 d6                	mov    %edx,%esi
  800b1a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b1d:	eb 1a                	jmp    800b39 <memcmp+0x2c>
		if (*s1 != *s2)
  800b1f:	0f b6 02             	movzbl (%edx),%eax
  800b22:	0f b6 19             	movzbl (%ecx),%ebx
  800b25:	38 d8                	cmp    %bl,%al
  800b27:	74 0a                	je     800b33 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b29:	0f b6 c0             	movzbl %al,%eax
  800b2c:	0f b6 db             	movzbl %bl,%ebx
  800b2f:	29 d8                	sub    %ebx,%eax
  800b31:	eb 0f                	jmp    800b42 <memcmp+0x35>
		s1++, s2++;
  800b33:	83 c2 01             	add    $0x1,%edx
  800b36:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b39:	39 f2                	cmp    %esi,%edx
  800b3b:	75 e2                	jne    800b1f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b42:	5b                   	pop    %ebx
  800b43:	5e                   	pop    %esi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b4f:	89 c2                	mov    %eax,%edx
  800b51:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b54:	eb 07                	jmp    800b5d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b56:	38 08                	cmp    %cl,(%eax)
  800b58:	74 07                	je     800b61 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b5a:	83 c0 01             	add    $0x1,%eax
  800b5d:	39 d0                	cmp    %edx,%eax
  800b5f:	72 f5                	jb     800b56 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	57                   	push   %edi
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b6f:	eb 03                	jmp    800b74 <strtol+0x11>
		s++;
  800b71:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b74:	0f b6 0a             	movzbl (%edx),%ecx
  800b77:	80 f9 09             	cmp    $0x9,%cl
  800b7a:	74 f5                	je     800b71 <strtol+0xe>
  800b7c:	80 f9 20             	cmp    $0x20,%cl
  800b7f:	74 f0                	je     800b71 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b81:	80 f9 2b             	cmp    $0x2b,%cl
  800b84:	75 0a                	jne    800b90 <strtol+0x2d>
		s++;
  800b86:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b89:	bf 00 00 00 00       	mov    $0x0,%edi
  800b8e:	eb 11                	jmp    800ba1 <strtol+0x3e>
  800b90:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b95:	80 f9 2d             	cmp    $0x2d,%cl
  800b98:	75 07                	jne    800ba1 <strtol+0x3e>
		s++, neg = 1;
  800b9a:	8d 52 01             	lea    0x1(%edx),%edx
  800b9d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ba6:	75 15                	jne    800bbd <strtol+0x5a>
  800ba8:	80 3a 30             	cmpb   $0x30,(%edx)
  800bab:	75 10                	jne    800bbd <strtol+0x5a>
  800bad:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bb1:	75 0a                	jne    800bbd <strtol+0x5a>
		s += 2, base = 16;
  800bb3:	83 c2 02             	add    $0x2,%edx
  800bb6:	b8 10 00 00 00       	mov    $0x10,%eax
  800bbb:	eb 10                	jmp    800bcd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800bbd:	85 c0                	test   %eax,%eax
  800bbf:	75 0c                	jne    800bcd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bc3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bc6:	75 05                	jne    800bcd <strtol+0x6a>
		s++, base = 8;
  800bc8:	83 c2 01             	add    $0x1,%edx
  800bcb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bd2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bd5:	0f b6 0a             	movzbl (%edx),%ecx
  800bd8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bdb:	89 f0                	mov    %esi,%eax
  800bdd:	3c 09                	cmp    $0x9,%al
  800bdf:	77 08                	ja     800be9 <strtol+0x86>
			dig = *s - '0';
  800be1:	0f be c9             	movsbl %cl,%ecx
  800be4:	83 e9 30             	sub    $0x30,%ecx
  800be7:	eb 20                	jmp    800c09 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800be9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bec:	89 f0                	mov    %esi,%eax
  800bee:	3c 19                	cmp    $0x19,%al
  800bf0:	77 08                	ja     800bfa <strtol+0x97>
			dig = *s - 'a' + 10;
  800bf2:	0f be c9             	movsbl %cl,%ecx
  800bf5:	83 e9 57             	sub    $0x57,%ecx
  800bf8:	eb 0f                	jmp    800c09 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bfa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bfd:	89 f0                	mov    %esi,%eax
  800bff:	3c 19                	cmp    $0x19,%al
  800c01:	77 16                	ja     800c19 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c03:	0f be c9             	movsbl %cl,%ecx
  800c06:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c09:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c0c:	7d 0f                	jge    800c1d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c0e:	83 c2 01             	add    $0x1,%edx
  800c11:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c15:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c17:	eb bc                	jmp    800bd5 <strtol+0x72>
  800c19:	89 d8                	mov    %ebx,%eax
  800c1b:	eb 02                	jmp    800c1f <strtol+0xbc>
  800c1d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c23:	74 05                	je     800c2a <strtol+0xc7>
		*endptr = (char *) s;
  800c25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c28:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c2a:	f7 d8                	neg    %eax
  800c2c:	85 ff                	test   %edi,%edi
  800c2e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c31:	5b                   	pop    %ebx
  800c32:	5e                   	pop    %esi
  800c33:	5f                   	pop    %edi
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	57                   	push   %edi
  800c3a:	56                   	push   %esi
  800c3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c44:	8b 55 08             	mov    0x8(%ebp),%edx
  800c47:	89 c3                	mov    %eax,%ebx
  800c49:	89 c7                	mov    %eax,%edi
  800c4b:	89 c6                	mov    %eax,%esi
  800c4d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c64:	89 d1                	mov    %edx,%ecx
  800c66:	89 d3                	mov    %edx,%ebx
  800c68:	89 d7                	mov    %edx,%edi
  800c6a:	89 d6                	mov    %edx,%esi
  800c6c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	57                   	push   %edi
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
  800c79:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c81:	b8 03 00 00 00       	mov    $0x3,%eax
  800c86:	8b 55 08             	mov    0x8(%ebp),%edx
  800c89:	89 cb                	mov    %ecx,%ebx
  800c8b:	89 cf                	mov    %ecx,%edi
  800c8d:	89 ce                	mov    %ecx,%esi
  800c8f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c91:	85 c0                	test   %eax,%eax
  800c93:	7e 28                	jle    800cbd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c95:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c99:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ca0:	00 
  800ca1:	c7 44 24 08 cb 2c 80 	movl   $0x802ccb,0x8(%esp)
  800ca8:	00 
  800ca9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cb0:	00 
  800cb1:	c7 04 24 e8 2c 80 00 	movl   $0x802ce8,(%esp)
  800cb8:	e8 0d f5 ff ff       	call   8001ca <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cbd:	83 c4 2c             	add    $0x2c,%esp
  800cc0:	5b                   	pop    %ebx
  800cc1:	5e                   	pop    %esi
  800cc2:	5f                   	pop    %edi
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd0:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd5:	89 d1                	mov    %edx,%ecx
  800cd7:	89 d3                	mov    %edx,%ebx
  800cd9:	89 d7                	mov    %edx,%edi
  800cdb:	89 d6                	mov    %edx,%esi
  800cdd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <sys_yield>:

void
sys_yield(void)
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
  800cef:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cf4:	89 d1                	mov    %edx,%ecx
  800cf6:	89 d3                	mov    %edx,%ebx
  800cf8:	89 d7                	mov    %edx,%edi
  800cfa:	89 d6                	mov    %edx,%esi
  800cfc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800d0c:	be 00 00 00 00       	mov    $0x0,%esi
  800d11:	b8 04 00 00 00       	mov    $0x4,%eax
  800d16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1f:	89 f7                	mov    %esi,%edi
  800d21:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d23:	85 c0                	test   %eax,%eax
  800d25:	7e 28                	jle    800d4f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d27:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d2b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d32:	00 
  800d33:	c7 44 24 08 cb 2c 80 	movl   $0x802ccb,0x8(%esp)
  800d3a:	00 
  800d3b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d42:	00 
  800d43:	c7 04 24 e8 2c 80 00 	movl   $0x802ce8,(%esp)
  800d4a:	e8 7b f4 ff ff       	call   8001ca <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4f:	83 c4 2c             	add    $0x2c,%esp
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5f                   	pop    %edi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	57                   	push   %edi
  800d5b:	56                   	push   %esi
  800d5c:	53                   	push   %ebx
  800d5d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d60:	b8 05 00 00 00       	mov    $0x5,%eax
  800d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d68:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d71:	8b 75 18             	mov    0x18(%ebp),%esi
  800d74:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d76:	85 c0                	test   %eax,%eax
  800d78:	7e 28                	jle    800da2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d7e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d85:	00 
  800d86:	c7 44 24 08 cb 2c 80 	movl   $0x802ccb,0x8(%esp)
  800d8d:	00 
  800d8e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d95:	00 
  800d96:	c7 04 24 e8 2c 80 00 	movl   $0x802ce8,(%esp)
  800d9d:	e8 28 f4 ff ff       	call   8001ca <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da2:	83 c4 2c             	add    $0x2c,%esp
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db8:	b8 06 00 00 00       	mov    $0x6,%eax
  800dbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc3:	89 df                	mov    %ebx,%edi
  800dc5:	89 de                	mov    %ebx,%esi
  800dc7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	7e 28                	jle    800df5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dd1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800dd8:	00 
  800dd9:	c7 44 24 08 cb 2c 80 	movl   $0x802ccb,0x8(%esp)
  800de0:	00 
  800de1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800de8:	00 
  800de9:	c7 04 24 e8 2c 80 00 	movl   $0x802ce8,(%esp)
  800df0:	e8 d5 f3 ff ff       	call   8001ca <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800df5:	83 c4 2c             	add    $0x2c,%esp
  800df8:	5b                   	pop    %ebx
  800df9:	5e                   	pop    %esi
  800dfa:	5f                   	pop    %edi
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	57                   	push   %edi
  800e01:	56                   	push   %esi
  800e02:	53                   	push   %ebx
  800e03:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e13:	8b 55 08             	mov    0x8(%ebp),%edx
  800e16:	89 df                	mov    %ebx,%edi
  800e18:	89 de                	mov    %ebx,%esi
  800e1a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	7e 28                	jle    800e48 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e20:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e24:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e2b:	00 
  800e2c:	c7 44 24 08 cb 2c 80 	movl   $0x802ccb,0x8(%esp)
  800e33:	00 
  800e34:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e3b:	00 
  800e3c:	c7 04 24 e8 2c 80 00 	movl   $0x802ce8,(%esp)
  800e43:	e8 82 f3 ff ff       	call   8001ca <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e48:	83 c4 2c             	add    $0x2c,%esp
  800e4b:	5b                   	pop    %ebx
  800e4c:	5e                   	pop    %esi
  800e4d:	5f                   	pop    %edi
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    

00800e50 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	57                   	push   %edi
  800e54:	56                   	push   %esi
  800e55:	53                   	push   %ebx
  800e56:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e66:	8b 55 08             	mov    0x8(%ebp),%edx
  800e69:	89 df                	mov    %ebx,%edi
  800e6b:	89 de                	mov    %ebx,%esi
  800e6d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	7e 28                	jle    800e9b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e73:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e77:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e7e:	00 
  800e7f:	c7 44 24 08 cb 2c 80 	movl   $0x802ccb,0x8(%esp)
  800e86:	00 
  800e87:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8e:	00 
  800e8f:	c7 04 24 e8 2c 80 00 	movl   $0x802ce8,(%esp)
  800e96:	e8 2f f3 ff ff       	call   8001ca <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e9b:	83 c4 2c             	add    $0x2c,%esp
  800e9e:	5b                   	pop    %ebx
  800e9f:	5e                   	pop    %esi
  800ea0:	5f                   	pop    %edi
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    

00800ea3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	57                   	push   %edi
  800ea7:	56                   	push   %esi
  800ea8:	53                   	push   %ebx
  800ea9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebc:	89 df                	mov    %ebx,%edi
  800ebe:	89 de                	mov    %ebx,%esi
  800ec0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	7e 28                	jle    800eee <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eca:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ed1:	00 
  800ed2:	c7 44 24 08 cb 2c 80 	movl   $0x802ccb,0x8(%esp)
  800ed9:	00 
  800eda:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee1:	00 
  800ee2:	c7 04 24 e8 2c 80 00 	movl   $0x802ce8,(%esp)
  800ee9:	e8 dc f2 ff ff       	call   8001ca <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eee:	83 c4 2c             	add    $0x2c,%esp
  800ef1:	5b                   	pop    %ebx
  800ef2:	5e                   	pop    %esi
  800ef3:	5f                   	pop    %edi
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    

00800ef6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	57                   	push   %edi
  800efa:	56                   	push   %esi
  800efb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efc:	be 00 00 00 00       	mov    $0x0,%esi
  800f01:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f12:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    

00800f19 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
  800f1f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f22:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f27:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2f:	89 cb                	mov    %ecx,%ebx
  800f31:	89 cf                	mov    %ecx,%edi
  800f33:	89 ce                	mov    %ecx,%esi
  800f35:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	7e 28                	jle    800f63 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f46:	00 
  800f47:	c7 44 24 08 cb 2c 80 	movl   $0x802ccb,0x8(%esp)
  800f4e:	00 
  800f4f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f56:	00 
  800f57:	c7 04 24 e8 2c 80 00 	movl   $0x802ce8,(%esp)
  800f5e:	e8 67 f2 ff ff       	call   8001ca <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f63:	83 c4 2c             	add    $0x2c,%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    

00800f6b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	57                   	push   %edi
  800f6f:	56                   	push   %esi
  800f70:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f71:	ba 00 00 00 00       	mov    $0x0,%edx
  800f76:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f7b:	89 d1                	mov    %edx,%ecx
  800f7d:	89 d3                	mov    %edx,%ebx
  800f7f:	89 d7                	mov    %edx,%edi
  800f81:	89 d6                	mov    %edx,%esi
  800f83:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f85:	5b                   	pop    %ebx
  800f86:	5e                   	pop    %esi
  800f87:	5f                   	pop    %edi
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    

00800f8a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
  800f90:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f98:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa3:	89 df                	mov    %ebx,%edi
  800fa5:	89 de                	mov    %ebx,%esi
  800fa7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fa9:	85 c0                	test   %eax,%eax
  800fab:	7e 28                	jle    800fd5 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fad:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800fb8:	00 
  800fb9:	c7 44 24 08 cb 2c 80 	movl   $0x802ccb,0x8(%esp)
  800fc0:	00 
  800fc1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc8:	00 
  800fc9:	c7 04 24 e8 2c 80 00 	movl   $0x802ce8,(%esp)
  800fd0:	e8 f5 f1 ff ff       	call   8001ca <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800fd5:	83 c4 2c             	add    $0x2c,%esp
  800fd8:	5b                   	pop    %ebx
  800fd9:	5e                   	pop    %esi
  800fda:	5f                   	pop    %edi
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	57                   	push   %edi
  800fe1:	56                   	push   %esi
  800fe2:	53                   	push   %ebx
  800fe3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800feb:	b8 10 00 00 00       	mov    $0x10,%eax
  800ff0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff6:	89 df                	mov    %ebx,%edi
  800ff8:	89 de                	mov    %ebx,%esi
  800ffa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	7e 28                	jle    801028 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801000:	89 44 24 10          	mov    %eax,0x10(%esp)
  801004:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80100b:	00 
  80100c:	c7 44 24 08 cb 2c 80 	movl   $0x802ccb,0x8(%esp)
  801013:	00 
  801014:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80101b:	00 
  80101c:	c7 04 24 e8 2c 80 00 	movl   $0x802ce8,(%esp)
  801023:	e8 a2 f1 ff ff       	call   8001ca <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  801028:	83 c4 2c             	add    $0x2c,%esp
  80102b:	5b                   	pop    %ebx
  80102c:	5e                   	pop    %esi
  80102d:	5f                   	pop    %edi
  80102e:	5d                   	pop    %ebp
  80102f:	c3                   	ret    

00801030 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	57                   	push   %edi
  801034:	56                   	push   %esi
  801035:	53                   	push   %ebx
  801036:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801039:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103e:	b8 11 00 00 00       	mov    $0x11,%eax
  801043:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	89 df                	mov    %ebx,%edi
  80104b:	89 de                	mov    %ebx,%esi
  80104d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80104f:	85 c0                	test   %eax,%eax
  801051:	7e 28                	jle    80107b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801053:	89 44 24 10          	mov    %eax,0x10(%esp)
  801057:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  80105e:	00 
  80105f:	c7 44 24 08 cb 2c 80 	movl   $0x802ccb,0x8(%esp)
  801066:	00 
  801067:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80106e:	00 
  80106f:	c7 04 24 e8 2c 80 00 	movl   $0x802ce8,(%esp)
  801076:	e8 4f f1 ff ff       	call   8001ca <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80107b:	83 c4 2c             	add    $0x2c,%esp
  80107e:	5b                   	pop    %ebx
  80107f:	5e                   	pop    %esi
  801080:	5f                   	pop    %edi
  801081:	5d                   	pop    %ebp
  801082:	c3                   	ret    

00801083 <sys_sleep>:

int
sys_sleep(int channel)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	57                   	push   %edi
  801087:	56                   	push   %esi
  801088:	53                   	push   %ebx
  801089:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801091:	b8 12 00 00 00       	mov    $0x12,%eax
  801096:	8b 55 08             	mov    0x8(%ebp),%edx
  801099:	89 cb                	mov    %ecx,%ebx
  80109b:	89 cf                	mov    %ecx,%edi
  80109d:	89 ce                	mov    %ecx,%esi
  80109f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	7e 28                	jle    8010cd <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010a9:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8010b0:	00 
  8010b1:	c7 44 24 08 cb 2c 80 	movl   $0x802ccb,0x8(%esp)
  8010b8:	00 
  8010b9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c0:	00 
  8010c1:	c7 04 24 e8 2c 80 00 	movl   $0x802ce8,(%esp)
  8010c8:	e8 fd f0 ff ff       	call   8001ca <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  8010cd:	83 c4 2c             	add    $0x2c,%esp
  8010d0:	5b                   	pop    %ebx
  8010d1:	5e                   	pop    %esi
  8010d2:	5f                   	pop    %edi
  8010d3:	5d                   	pop    %ebp
  8010d4:	c3                   	ret    

008010d5 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	57                   	push   %edi
  8010d9:	56                   	push   %esi
  8010da:	53                   	push   %ebx
  8010db:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e3:	b8 13 00 00 00       	mov    $0x13,%eax
  8010e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ee:	89 df                	mov    %ebx,%edi
  8010f0:	89 de                	mov    %ebx,%esi
  8010f2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	7e 28                	jle    801120 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010fc:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801103:	00 
  801104:	c7 44 24 08 cb 2c 80 	movl   $0x802ccb,0x8(%esp)
  80110b:	00 
  80110c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801113:	00 
  801114:	c7 04 24 e8 2c 80 00 	movl   $0x802ce8,(%esp)
  80111b:	e8 aa f0 ff ff       	call   8001ca <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801120:	83 c4 2c             	add    $0x2c,%esp
  801123:	5b                   	pop    %ebx
  801124:	5e                   	pop    %esi
  801125:	5f                   	pop    %edi
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    
  801128:	66 90                	xchg   %ax,%ax
  80112a:	66 90                	xchg   %ax,%ax
  80112c:	66 90                	xchg   %ax,%ax
  80112e:	66 90                	xchg   %ax,%ax

00801130 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	05 00 00 00 30       	add    $0x30000000,%eax
  80113b:	c1 e8 0c             	shr    $0xc,%eax
}
  80113e:	5d                   	pop    %ebp
  80113f:	c3                   	ret    

00801140 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80114b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801150:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    

00801157 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80115d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801162:	89 c2                	mov    %eax,%edx
  801164:	c1 ea 16             	shr    $0x16,%edx
  801167:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80116e:	f6 c2 01             	test   $0x1,%dl
  801171:	74 11                	je     801184 <fd_alloc+0x2d>
  801173:	89 c2                	mov    %eax,%edx
  801175:	c1 ea 0c             	shr    $0xc,%edx
  801178:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80117f:	f6 c2 01             	test   $0x1,%dl
  801182:	75 09                	jne    80118d <fd_alloc+0x36>
			*fd_store = fd;
  801184:	89 01                	mov    %eax,(%ecx)
			return 0;
  801186:	b8 00 00 00 00       	mov    $0x0,%eax
  80118b:	eb 17                	jmp    8011a4 <fd_alloc+0x4d>
  80118d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801192:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801197:	75 c9                	jne    801162 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801199:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80119f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    

008011a6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011ac:	83 f8 1f             	cmp    $0x1f,%eax
  8011af:	77 36                	ja     8011e7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011b1:	c1 e0 0c             	shl    $0xc,%eax
  8011b4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011b9:	89 c2                	mov    %eax,%edx
  8011bb:	c1 ea 16             	shr    $0x16,%edx
  8011be:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011c5:	f6 c2 01             	test   $0x1,%dl
  8011c8:	74 24                	je     8011ee <fd_lookup+0x48>
  8011ca:	89 c2                	mov    %eax,%edx
  8011cc:	c1 ea 0c             	shr    $0xc,%edx
  8011cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d6:	f6 c2 01             	test   $0x1,%dl
  8011d9:	74 1a                	je     8011f5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011de:	89 02                	mov    %eax,(%edx)
	return 0;
  8011e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e5:	eb 13                	jmp    8011fa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ec:	eb 0c                	jmp    8011fa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f3:	eb 05                	jmp    8011fa <fd_lookup+0x54>
  8011f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8011fa:	5d                   	pop    %ebp
  8011fb:	c3                   	ret    

008011fc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	83 ec 18             	sub    $0x18,%esp
  801202:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801205:	ba 00 00 00 00       	mov    $0x0,%edx
  80120a:	eb 13                	jmp    80121f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80120c:	39 08                	cmp    %ecx,(%eax)
  80120e:	75 0c                	jne    80121c <dev_lookup+0x20>
			*dev = devtab[i];
  801210:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801213:	89 01                	mov    %eax,(%ecx)
			return 0;
  801215:	b8 00 00 00 00       	mov    $0x0,%eax
  80121a:	eb 38                	jmp    801254 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80121c:	83 c2 01             	add    $0x1,%edx
  80121f:	8b 04 95 74 2d 80 00 	mov    0x802d74(,%edx,4),%eax
  801226:	85 c0                	test   %eax,%eax
  801228:	75 e2                	jne    80120c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80122a:	a1 20 60 80 00       	mov    0x806020,%eax
  80122f:	8b 40 48             	mov    0x48(%eax),%eax
  801232:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801236:	89 44 24 04          	mov    %eax,0x4(%esp)
  80123a:	c7 04 24 f8 2c 80 00 	movl   $0x802cf8,(%esp)
  801241:	e8 7d f0 ff ff       	call   8002c3 <cprintf>
	*dev = 0;
  801246:	8b 45 0c             	mov    0xc(%ebp),%eax
  801249:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80124f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801254:	c9                   	leave  
  801255:	c3                   	ret    

00801256 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	56                   	push   %esi
  80125a:	53                   	push   %ebx
  80125b:	83 ec 20             	sub    $0x20,%esp
  80125e:	8b 75 08             	mov    0x8(%ebp),%esi
  801261:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801264:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801267:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80126b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801271:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801274:	89 04 24             	mov    %eax,(%esp)
  801277:	e8 2a ff ff ff       	call   8011a6 <fd_lookup>
  80127c:	85 c0                	test   %eax,%eax
  80127e:	78 05                	js     801285 <fd_close+0x2f>
	    || fd != fd2)
  801280:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801283:	74 0c                	je     801291 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801285:	84 db                	test   %bl,%bl
  801287:	ba 00 00 00 00       	mov    $0x0,%edx
  80128c:	0f 44 c2             	cmove  %edx,%eax
  80128f:	eb 3f                	jmp    8012d0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801291:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801294:	89 44 24 04          	mov    %eax,0x4(%esp)
  801298:	8b 06                	mov    (%esi),%eax
  80129a:	89 04 24             	mov    %eax,(%esp)
  80129d:	e8 5a ff ff ff       	call   8011fc <dev_lookup>
  8012a2:	89 c3                	mov    %eax,%ebx
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	78 16                	js     8012be <fd_close+0x68>
		if (dev->dev_close)
  8012a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ab:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8012ae:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8012b3:	85 c0                	test   %eax,%eax
  8012b5:	74 07                	je     8012be <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8012b7:	89 34 24             	mov    %esi,(%esp)
  8012ba:	ff d0                	call   *%eax
  8012bc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012c9:	e8 dc fa ff ff       	call   800daa <sys_page_unmap>
	return r;
  8012ce:	89 d8                	mov    %ebx,%eax
}
  8012d0:	83 c4 20             	add    $0x20,%esp
  8012d3:	5b                   	pop    %ebx
  8012d4:	5e                   	pop    %esi
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    

008012d7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	89 04 24             	mov    %eax,(%esp)
  8012ea:	e8 b7 fe ff ff       	call   8011a6 <fd_lookup>
  8012ef:	89 c2                	mov    %eax,%edx
  8012f1:	85 d2                	test   %edx,%edx
  8012f3:	78 13                	js     801308 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8012f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012fc:	00 
  8012fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801300:	89 04 24             	mov    %eax,(%esp)
  801303:	e8 4e ff ff ff       	call   801256 <fd_close>
}
  801308:	c9                   	leave  
  801309:	c3                   	ret    

0080130a <close_all>:

void
close_all(void)
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
  80130d:	53                   	push   %ebx
  80130e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801311:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801316:	89 1c 24             	mov    %ebx,(%esp)
  801319:	e8 b9 ff ff ff       	call   8012d7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80131e:	83 c3 01             	add    $0x1,%ebx
  801321:	83 fb 20             	cmp    $0x20,%ebx
  801324:	75 f0                	jne    801316 <close_all+0xc>
		close(i);
}
  801326:	83 c4 14             	add    $0x14,%esp
  801329:	5b                   	pop    %ebx
  80132a:	5d                   	pop    %ebp
  80132b:	c3                   	ret    

0080132c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	57                   	push   %edi
  801330:	56                   	push   %esi
  801331:	53                   	push   %ebx
  801332:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801335:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801338:	89 44 24 04          	mov    %eax,0x4(%esp)
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	89 04 24             	mov    %eax,(%esp)
  801342:	e8 5f fe ff ff       	call   8011a6 <fd_lookup>
  801347:	89 c2                	mov    %eax,%edx
  801349:	85 d2                	test   %edx,%edx
  80134b:	0f 88 e1 00 00 00    	js     801432 <dup+0x106>
		return r;
	close(newfdnum);
  801351:	8b 45 0c             	mov    0xc(%ebp),%eax
  801354:	89 04 24             	mov    %eax,(%esp)
  801357:	e8 7b ff ff ff       	call   8012d7 <close>

	newfd = INDEX2FD(newfdnum);
  80135c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80135f:	c1 e3 0c             	shl    $0xc,%ebx
  801362:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801368:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80136b:	89 04 24             	mov    %eax,(%esp)
  80136e:	e8 cd fd ff ff       	call   801140 <fd2data>
  801373:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801375:	89 1c 24             	mov    %ebx,(%esp)
  801378:	e8 c3 fd ff ff       	call   801140 <fd2data>
  80137d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80137f:	89 f0                	mov    %esi,%eax
  801381:	c1 e8 16             	shr    $0x16,%eax
  801384:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80138b:	a8 01                	test   $0x1,%al
  80138d:	74 43                	je     8013d2 <dup+0xa6>
  80138f:	89 f0                	mov    %esi,%eax
  801391:	c1 e8 0c             	shr    $0xc,%eax
  801394:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80139b:	f6 c2 01             	test   $0x1,%dl
  80139e:	74 32                	je     8013d2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013a0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013a7:	25 07 0e 00 00       	and    $0xe07,%eax
  8013ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013b0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013b4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013bb:	00 
  8013bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013c7:	e8 8b f9 ff ff       	call   800d57 <sys_page_map>
  8013cc:	89 c6                	mov    %eax,%esi
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	78 3e                	js     801410 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d5:	89 c2                	mov    %eax,%edx
  8013d7:	c1 ea 0c             	shr    $0xc,%edx
  8013da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013e1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013e7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013f6:	00 
  8013f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801402:	e8 50 f9 ff ff       	call   800d57 <sys_page_map>
  801407:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801409:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80140c:	85 f6                	test   %esi,%esi
  80140e:	79 22                	jns    801432 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801410:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801414:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80141b:	e8 8a f9 ff ff       	call   800daa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801420:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801424:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80142b:	e8 7a f9 ff ff       	call   800daa <sys_page_unmap>
	return r;
  801430:	89 f0                	mov    %esi,%eax
}
  801432:	83 c4 3c             	add    $0x3c,%esp
  801435:	5b                   	pop    %ebx
  801436:	5e                   	pop    %esi
  801437:	5f                   	pop    %edi
  801438:	5d                   	pop    %ebp
  801439:	c3                   	ret    

0080143a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	53                   	push   %ebx
  80143e:	83 ec 24             	sub    $0x24,%esp
  801441:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801444:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801447:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144b:	89 1c 24             	mov    %ebx,(%esp)
  80144e:	e8 53 fd ff ff       	call   8011a6 <fd_lookup>
  801453:	89 c2                	mov    %eax,%edx
  801455:	85 d2                	test   %edx,%edx
  801457:	78 6d                	js     8014c6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801459:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801460:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801463:	8b 00                	mov    (%eax),%eax
  801465:	89 04 24             	mov    %eax,(%esp)
  801468:	e8 8f fd ff ff       	call   8011fc <dev_lookup>
  80146d:	85 c0                	test   %eax,%eax
  80146f:	78 55                	js     8014c6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801474:	8b 50 08             	mov    0x8(%eax),%edx
  801477:	83 e2 03             	and    $0x3,%edx
  80147a:	83 fa 01             	cmp    $0x1,%edx
  80147d:	75 23                	jne    8014a2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80147f:	a1 20 60 80 00       	mov    0x806020,%eax
  801484:	8b 40 48             	mov    0x48(%eax),%eax
  801487:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80148b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80148f:	c7 04 24 39 2d 80 00 	movl   $0x802d39,(%esp)
  801496:	e8 28 ee ff ff       	call   8002c3 <cprintf>
		return -E_INVAL;
  80149b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a0:	eb 24                	jmp    8014c6 <read+0x8c>
	}
	if (!dev->dev_read)
  8014a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a5:	8b 52 08             	mov    0x8(%edx),%edx
  8014a8:	85 d2                	test   %edx,%edx
  8014aa:	74 15                	je     8014c1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014ba:	89 04 24             	mov    %eax,(%esp)
  8014bd:	ff d2                	call   *%edx
  8014bf:	eb 05                	jmp    8014c6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8014c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8014c6:	83 c4 24             	add    $0x24,%esp
  8014c9:	5b                   	pop    %ebx
  8014ca:	5d                   	pop    %ebp
  8014cb:	c3                   	ret    

008014cc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	57                   	push   %edi
  8014d0:	56                   	push   %esi
  8014d1:	53                   	push   %ebx
  8014d2:	83 ec 1c             	sub    $0x1c,%esp
  8014d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014d8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e0:	eb 23                	jmp    801505 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014e2:	89 f0                	mov    %esi,%eax
  8014e4:	29 d8                	sub    %ebx,%eax
  8014e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014ea:	89 d8                	mov    %ebx,%eax
  8014ec:	03 45 0c             	add    0xc(%ebp),%eax
  8014ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f3:	89 3c 24             	mov    %edi,(%esp)
  8014f6:	e8 3f ff ff ff       	call   80143a <read>
		if (m < 0)
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	78 10                	js     80150f <readn+0x43>
			return m;
		if (m == 0)
  8014ff:	85 c0                	test   %eax,%eax
  801501:	74 0a                	je     80150d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801503:	01 c3                	add    %eax,%ebx
  801505:	39 f3                	cmp    %esi,%ebx
  801507:	72 d9                	jb     8014e2 <readn+0x16>
  801509:	89 d8                	mov    %ebx,%eax
  80150b:	eb 02                	jmp    80150f <readn+0x43>
  80150d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80150f:	83 c4 1c             	add    $0x1c,%esp
  801512:	5b                   	pop    %ebx
  801513:	5e                   	pop    %esi
  801514:	5f                   	pop    %edi
  801515:	5d                   	pop    %ebp
  801516:	c3                   	ret    

00801517 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	53                   	push   %ebx
  80151b:	83 ec 24             	sub    $0x24,%esp
  80151e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801521:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801524:	89 44 24 04          	mov    %eax,0x4(%esp)
  801528:	89 1c 24             	mov    %ebx,(%esp)
  80152b:	e8 76 fc ff ff       	call   8011a6 <fd_lookup>
  801530:	89 c2                	mov    %eax,%edx
  801532:	85 d2                	test   %edx,%edx
  801534:	78 68                	js     80159e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801536:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801539:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801540:	8b 00                	mov    (%eax),%eax
  801542:	89 04 24             	mov    %eax,(%esp)
  801545:	e8 b2 fc ff ff       	call   8011fc <dev_lookup>
  80154a:	85 c0                	test   %eax,%eax
  80154c:	78 50                	js     80159e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80154e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801551:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801555:	75 23                	jne    80157a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801557:	a1 20 60 80 00       	mov    0x806020,%eax
  80155c:	8b 40 48             	mov    0x48(%eax),%eax
  80155f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801563:	89 44 24 04          	mov    %eax,0x4(%esp)
  801567:	c7 04 24 55 2d 80 00 	movl   $0x802d55,(%esp)
  80156e:	e8 50 ed ff ff       	call   8002c3 <cprintf>
		return -E_INVAL;
  801573:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801578:	eb 24                	jmp    80159e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80157a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157d:	8b 52 0c             	mov    0xc(%edx),%edx
  801580:	85 d2                	test   %edx,%edx
  801582:	74 15                	je     801599 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801584:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801587:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80158b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80158e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801592:	89 04 24             	mov    %eax,(%esp)
  801595:	ff d2                	call   *%edx
  801597:	eb 05                	jmp    80159e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801599:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80159e:	83 c4 24             	add    $0x24,%esp
  8015a1:	5b                   	pop    %ebx
  8015a2:	5d                   	pop    %ebp
  8015a3:	c3                   	ret    

008015a4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015aa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	89 04 24             	mov    %eax,(%esp)
  8015b7:	e8 ea fb ff ff       	call   8011a6 <fd_lookup>
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	78 0e                	js     8015ce <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	53                   	push   %ebx
  8015d4:	83 ec 24             	sub    $0x24,%esp
  8015d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e1:	89 1c 24             	mov    %ebx,(%esp)
  8015e4:	e8 bd fb ff ff       	call   8011a6 <fd_lookup>
  8015e9:	89 c2                	mov    %eax,%edx
  8015eb:	85 d2                	test   %edx,%edx
  8015ed:	78 61                	js     801650 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f9:	8b 00                	mov    (%eax),%eax
  8015fb:	89 04 24             	mov    %eax,(%esp)
  8015fe:	e8 f9 fb ff ff       	call   8011fc <dev_lookup>
  801603:	85 c0                	test   %eax,%eax
  801605:	78 49                	js     801650 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80160e:	75 23                	jne    801633 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801610:	a1 20 60 80 00       	mov    0x806020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801615:	8b 40 48             	mov    0x48(%eax),%eax
  801618:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80161c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801620:	c7 04 24 18 2d 80 00 	movl   $0x802d18,(%esp)
  801627:	e8 97 ec ff ff       	call   8002c3 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80162c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801631:	eb 1d                	jmp    801650 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801633:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801636:	8b 52 18             	mov    0x18(%edx),%edx
  801639:	85 d2                	test   %edx,%edx
  80163b:	74 0e                	je     80164b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80163d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801640:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801644:	89 04 24             	mov    %eax,(%esp)
  801647:	ff d2                	call   *%edx
  801649:	eb 05                	jmp    801650 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80164b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801650:	83 c4 24             	add    $0x24,%esp
  801653:	5b                   	pop    %ebx
  801654:	5d                   	pop    %ebp
  801655:	c3                   	ret    

00801656 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	53                   	push   %ebx
  80165a:	83 ec 24             	sub    $0x24,%esp
  80165d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801660:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801663:	89 44 24 04          	mov    %eax,0x4(%esp)
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	89 04 24             	mov    %eax,(%esp)
  80166d:	e8 34 fb ff ff       	call   8011a6 <fd_lookup>
  801672:	89 c2                	mov    %eax,%edx
  801674:	85 d2                	test   %edx,%edx
  801676:	78 52                	js     8016ca <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801678:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801682:	8b 00                	mov    (%eax),%eax
  801684:	89 04 24             	mov    %eax,(%esp)
  801687:	e8 70 fb ff ff       	call   8011fc <dev_lookup>
  80168c:	85 c0                	test   %eax,%eax
  80168e:	78 3a                	js     8016ca <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801693:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801697:	74 2c                	je     8016c5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801699:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80169c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016a3:	00 00 00 
	stat->st_isdir = 0;
  8016a6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016ad:	00 00 00 
	stat->st_dev = dev;
  8016b0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016bd:	89 14 24             	mov    %edx,(%esp)
  8016c0:	ff 50 14             	call   *0x14(%eax)
  8016c3:	eb 05                	jmp    8016ca <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016ca:	83 c4 24             	add    $0x24,%esp
  8016cd:	5b                   	pop    %ebx
  8016ce:	5d                   	pop    %ebp
  8016cf:	c3                   	ret    

008016d0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	56                   	push   %esi
  8016d4:	53                   	push   %ebx
  8016d5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016df:	00 
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	89 04 24             	mov    %eax,(%esp)
  8016e6:	e8 1b 02 00 00       	call   801906 <open>
  8016eb:	89 c3                	mov    %eax,%ebx
  8016ed:	85 db                	test   %ebx,%ebx
  8016ef:	78 1b                	js     80170c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8016f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f8:	89 1c 24             	mov    %ebx,(%esp)
  8016fb:	e8 56 ff ff ff       	call   801656 <fstat>
  801700:	89 c6                	mov    %eax,%esi
	close(fd);
  801702:	89 1c 24             	mov    %ebx,(%esp)
  801705:	e8 cd fb ff ff       	call   8012d7 <close>
	return r;
  80170a:	89 f0                	mov    %esi,%eax
}
  80170c:	83 c4 10             	add    $0x10,%esp
  80170f:	5b                   	pop    %ebx
  801710:	5e                   	pop    %esi
  801711:	5d                   	pop    %ebp
  801712:	c3                   	ret    

00801713 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	56                   	push   %esi
  801717:	53                   	push   %ebx
  801718:	83 ec 10             	sub    $0x10,%esp
  80171b:	89 c6                	mov    %eax,%esi
  80171d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80171f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801726:	75 11                	jne    801739 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801728:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80172f:	e8 ab 0e 00 00       	call   8025df <ipc_find_env>
  801734:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801739:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801740:	00 
  801741:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801748:	00 
  801749:	89 74 24 04          	mov    %esi,0x4(%esp)
  80174d:	a1 00 40 80 00       	mov    0x804000,%eax
  801752:	89 04 24             	mov    %eax,(%esp)
  801755:	e8 1a 0e 00 00       	call   802574 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80175a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801761:	00 
  801762:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801766:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80176d:	e8 ae 0d 00 00       	call   802520 <ipc_recv>
}
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	5b                   	pop    %ebx
  801776:	5e                   	pop    %esi
  801777:	5d                   	pop    %ebp
  801778:	c3                   	ret    

00801779 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8b 40 0c             	mov    0xc(%eax),%eax
  801785:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  80178a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178d:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801792:	ba 00 00 00 00       	mov    $0x0,%edx
  801797:	b8 02 00 00 00       	mov    $0x2,%eax
  80179c:	e8 72 ff ff ff       	call   801713 <fsipc>
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8017af:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8017b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b9:	b8 06 00 00 00       	mov    $0x6,%eax
  8017be:	e8 50 ff ff ff       	call   801713 <fsipc>
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	53                   	push   %ebx
  8017c9:	83 ec 14             	sub    $0x14,%esp
  8017cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d5:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017da:	ba 00 00 00 00       	mov    $0x0,%edx
  8017df:	b8 05 00 00 00       	mov    $0x5,%eax
  8017e4:	e8 2a ff ff ff       	call   801713 <fsipc>
  8017e9:	89 c2                	mov    %eax,%edx
  8017eb:	85 d2                	test   %edx,%edx
  8017ed:	78 2b                	js     80181a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017ef:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8017f6:	00 
  8017f7:	89 1c 24             	mov    %ebx,(%esp)
  8017fa:	e8 e8 f0 ff ff       	call   8008e7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017ff:	a1 80 70 80 00       	mov    0x807080,%eax
  801804:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80180a:	a1 84 70 80 00       	mov    0x807084,%eax
  80180f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801815:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181a:	83 c4 14             	add    $0x14,%esp
  80181d:	5b                   	pop    %ebx
  80181e:	5d                   	pop    %ebp
  80181f:	c3                   	ret    

00801820 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 18             	sub    $0x18,%esp
  801826:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801829:	8b 55 08             	mov    0x8(%ebp),%edx
  80182c:	8b 52 0c             	mov    0xc(%edx),%edx
  80182f:	89 15 00 70 80 00    	mov    %edx,0x807000
	fsipcbuf.write.req_n = n;
  801835:	a3 04 70 80 00       	mov    %eax,0x807004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80183a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80183e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801841:	89 44 24 04          	mov    %eax,0x4(%esp)
  801845:	c7 04 24 08 70 80 00 	movl   $0x807008,(%esp)
  80184c:	e8 9b f2 ff ff       	call   800aec <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
  801856:	b8 04 00 00 00       	mov    $0x4,%eax
  80185b:	e8 b3 fe ff ff       	call   801713 <fsipc>
		return r;
	}

	return r;
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	56                   	push   %esi
  801866:	53                   	push   %ebx
  801867:	83 ec 10             	sub    $0x10,%esp
  80186a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	8b 40 0c             	mov    0xc(%eax),%eax
  801873:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801878:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80187e:	ba 00 00 00 00       	mov    $0x0,%edx
  801883:	b8 03 00 00 00       	mov    $0x3,%eax
  801888:	e8 86 fe ff ff       	call   801713 <fsipc>
  80188d:	89 c3                	mov    %eax,%ebx
  80188f:	85 c0                	test   %eax,%eax
  801891:	78 6a                	js     8018fd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801893:	39 c6                	cmp    %eax,%esi
  801895:	73 24                	jae    8018bb <devfile_read+0x59>
  801897:	c7 44 24 0c 88 2d 80 	movl   $0x802d88,0xc(%esp)
  80189e:	00 
  80189f:	c7 44 24 08 8f 2d 80 	movl   $0x802d8f,0x8(%esp)
  8018a6:	00 
  8018a7:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8018ae:	00 
  8018af:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  8018b6:	e8 0f e9 ff ff       	call   8001ca <_panic>
	assert(r <= PGSIZE);
  8018bb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018c0:	7e 24                	jle    8018e6 <devfile_read+0x84>
  8018c2:	c7 44 24 0c af 2d 80 	movl   $0x802daf,0xc(%esp)
  8018c9:	00 
  8018ca:	c7 44 24 08 8f 2d 80 	movl   $0x802d8f,0x8(%esp)
  8018d1:	00 
  8018d2:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8018d9:	00 
  8018da:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  8018e1:	e8 e4 e8 ff ff       	call   8001ca <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018ea:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8018f1:	00 
  8018f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f5:	89 04 24             	mov    %eax,(%esp)
  8018f8:	e8 87 f1 ff ff       	call   800a84 <memmove>
	return r;
}
  8018fd:	89 d8                	mov    %ebx,%eax
  8018ff:	83 c4 10             	add    $0x10,%esp
  801902:	5b                   	pop    %ebx
  801903:	5e                   	pop    %esi
  801904:	5d                   	pop    %ebp
  801905:	c3                   	ret    

00801906 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	53                   	push   %ebx
  80190a:	83 ec 24             	sub    $0x24,%esp
  80190d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801910:	89 1c 24             	mov    %ebx,(%esp)
  801913:	e8 98 ef ff ff       	call   8008b0 <strlen>
  801918:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80191d:	7f 60                	jg     80197f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80191f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801922:	89 04 24             	mov    %eax,(%esp)
  801925:	e8 2d f8 ff ff       	call   801157 <fd_alloc>
  80192a:	89 c2                	mov    %eax,%edx
  80192c:	85 d2                	test   %edx,%edx
  80192e:	78 54                	js     801984 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801930:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801934:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  80193b:	e8 a7 ef ff ff       	call   8008e7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801948:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80194b:	b8 01 00 00 00       	mov    $0x1,%eax
  801950:	e8 be fd ff ff       	call   801713 <fsipc>
  801955:	89 c3                	mov    %eax,%ebx
  801957:	85 c0                	test   %eax,%eax
  801959:	79 17                	jns    801972 <open+0x6c>
		fd_close(fd, 0);
  80195b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801962:	00 
  801963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801966:	89 04 24             	mov    %eax,(%esp)
  801969:	e8 e8 f8 ff ff       	call   801256 <fd_close>
		return r;
  80196e:	89 d8                	mov    %ebx,%eax
  801970:	eb 12                	jmp    801984 <open+0x7e>
	}

	return fd2num(fd);
  801972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801975:	89 04 24             	mov    %eax,(%esp)
  801978:	e8 b3 f7 ff ff       	call   801130 <fd2num>
  80197d:	eb 05                	jmp    801984 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80197f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801984:	83 c4 24             	add    $0x24,%esp
  801987:	5b                   	pop    %ebx
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    

0080198a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801990:	ba 00 00 00 00       	mov    $0x0,%edx
  801995:	b8 08 00 00 00       	mov    $0x8,%eax
  80199a:	e8 74 fd ff ff       	call   801713 <fsipc>
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	53                   	push   %ebx
  8019a5:	83 ec 14             	sub    $0x14,%esp
  8019a8:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  8019aa:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8019ae:	7e 31                	jle    8019e1 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8019b0:	8b 40 04             	mov    0x4(%eax),%eax
  8019b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019b7:	8d 43 10             	lea    0x10(%ebx),%eax
  8019ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019be:	8b 03                	mov    (%ebx),%eax
  8019c0:	89 04 24             	mov    %eax,(%esp)
  8019c3:	e8 4f fb ff ff       	call   801517 <write>
		if (result > 0)
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	7e 03                	jle    8019cf <writebuf+0x2e>
			b->result += result;
  8019cc:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8019cf:	39 43 04             	cmp    %eax,0x4(%ebx)
  8019d2:	74 0d                	je     8019e1 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  8019d4:	85 c0                	test   %eax,%eax
  8019d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019db:	0f 4f c2             	cmovg  %edx,%eax
  8019de:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019e1:	83 c4 14             	add    $0x14,%esp
  8019e4:	5b                   	pop    %ebx
  8019e5:	5d                   	pop    %ebp
  8019e6:	c3                   	ret    

008019e7 <putch>:

static void
putch(int ch, void *thunk)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	53                   	push   %ebx
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019f1:	8b 53 04             	mov    0x4(%ebx),%edx
  8019f4:	8d 42 01             	lea    0x1(%edx),%eax
  8019f7:	89 43 04             	mov    %eax,0x4(%ebx)
  8019fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019fd:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a01:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a06:	75 0e                	jne    801a16 <putch+0x2f>
		writebuf(b);
  801a08:	89 d8                	mov    %ebx,%eax
  801a0a:	e8 92 ff ff ff       	call   8019a1 <writebuf>
		b->idx = 0;
  801a0f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801a16:	83 c4 04             	add    $0x4,%esp
  801a19:	5b                   	pop    %ebx
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    

00801a1c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a2e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a35:	00 00 00 
	b.result = 0;
  801a38:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a3f:	00 00 00 
	b.error = 1;
  801a42:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a49:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a56:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a5a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a60:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a64:	c7 04 24 e7 19 80 00 	movl   $0x8019e7,(%esp)
  801a6b:	e8 de e9 ff ff       	call   80044e <vprintfmt>
	if (b.idx > 0)
  801a70:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a77:	7e 0b                	jle    801a84 <vfprintf+0x68>
		writebuf(&b);
  801a79:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a7f:	e8 1d ff ff ff       	call   8019a1 <writebuf>

	return (b.result ? b.result : b.error);
  801a84:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a8a:	85 c0                	test   %eax,%eax
  801a8c:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a9b:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	89 04 24             	mov    %eax,(%esp)
  801aaf:	e8 68 ff ff ff       	call   801a1c <vfprintf>
	va_end(ap);

	return cnt;
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <printf>:

int
printf(const char *fmt, ...)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801abc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801abf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801ad1:	e8 46 ff ff ff       	call   801a1c <vfprintf>
	va_end(ap);

	return cnt;
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    
  801ad8:	66 90                	xchg   %ax,%ax
  801ada:	66 90                	xchg   %ax,%ax
  801adc:	66 90                	xchg   %ax,%ax
  801ade:	66 90                	xchg   %ax,%ax

00801ae0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ae6:	c7 44 24 04 bb 2d 80 	movl   $0x802dbb,0x4(%esp)
  801aed:	00 
  801aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af1:	89 04 24             	mov    %eax,(%esp)
  801af4:	e8 ee ed ff ff       	call   8008e7 <strcpy>
	return 0;
}
  801af9:	b8 00 00 00 00       	mov    $0x0,%eax
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	53                   	push   %ebx
  801b04:	83 ec 14             	sub    $0x14,%esp
  801b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b0a:	89 1c 24             	mov    %ebx,(%esp)
  801b0d:	e8 0c 0b 00 00       	call   80261e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801b12:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801b17:	83 f8 01             	cmp    $0x1,%eax
  801b1a:	75 0d                	jne    801b29 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801b1c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801b1f:	89 04 24             	mov    %eax,(%esp)
  801b22:	e8 29 03 00 00       	call   801e50 <nsipc_close>
  801b27:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801b29:	89 d0                	mov    %edx,%eax
  801b2b:	83 c4 14             	add    $0x14,%esp
  801b2e:	5b                   	pop    %ebx
  801b2f:	5d                   	pop    %ebp
  801b30:	c3                   	ret    

00801b31 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b37:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b3e:	00 
  801b3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b42:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	8b 40 0c             	mov    0xc(%eax),%eax
  801b53:	89 04 24             	mov    %eax,(%esp)
  801b56:	e8 f0 03 00 00       	call   801f4b <nsipc_send>
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b63:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b6a:	00 
  801b6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b75:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7f:	89 04 24             	mov    %eax,(%esp)
  801b82:	e8 44 03 00 00       	call   801ecb <nsipc_recv>
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b8f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b92:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b96:	89 04 24             	mov    %eax,(%esp)
  801b99:	e8 08 f6 ff ff       	call   8011a6 <fd_lookup>
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	78 17                	js     801bb9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801bab:	39 08                	cmp    %ecx,(%eax)
  801bad:	75 05                	jne    801bb4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801baf:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb2:	eb 05                	jmp    801bb9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801bb4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	56                   	push   %esi
  801bbf:	53                   	push   %ebx
  801bc0:	83 ec 20             	sub    $0x20,%esp
  801bc3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801bc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc8:	89 04 24             	mov    %eax,(%esp)
  801bcb:	e8 87 f5 ff ff       	call   801157 <fd_alloc>
  801bd0:	89 c3                	mov    %eax,%ebx
  801bd2:	85 c0                	test   %eax,%eax
  801bd4:	78 21                	js     801bf7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801bd6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801bdd:	00 
  801bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bec:	e8 12 f1 ff ff       	call   800d03 <sys_page_alloc>
  801bf1:	89 c3                	mov    %eax,%ebx
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	79 0c                	jns    801c03 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801bf7:	89 34 24             	mov    %esi,(%esp)
  801bfa:	e8 51 02 00 00       	call   801e50 <nsipc_close>
		return r;
  801bff:	89 d8                	mov    %ebx,%eax
  801c01:	eb 20                	jmp    801c23 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801c03:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c11:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801c18:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801c1b:	89 14 24             	mov    %edx,(%esp)
  801c1e:	e8 0d f5 ff ff       	call   801130 <fd2num>
}
  801c23:	83 c4 20             	add    $0x20,%esp
  801c26:	5b                   	pop    %ebx
  801c27:	5e                   	pop    %esi
  801c28:	5d                   	pop    %ebp
  801c29:	c3                   	ret    

00801c2a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	e8 51 ff ff ff       	call   801b89 <fd2sockid>
		return r;
  801c38:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c3a:	85 c0                	test   %eax,%eax
  801c3c:	78 23                	js     801c61 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c3e:	8b 55 10             	mov    0x10(%ebp),%edx
  801c41:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c48:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c4c:	89 04 24             	mov    %eax,(%esp)
  801c4f:	e8 45 01 00 00       	call   801d99 <nsipc_accept>
		return r;
  801c54:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c56:	85 c0                	test   %eax,%eax
  801c58:	78 07                	js     801c61 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801c5a:	e8 5c ff ff ff       	call   801bbb <alloc_sockfd>
  801c5f:	89 c1                	mov    %eax,%ecx
}
  801c61:	89 c8                	mov    %ecx,%eax
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	e8 16 ff ff ff       	call   801b89 <fd2sockid>
  801c73:	89 c2                	mov    %eax,%edx
  801c75:	85 d2                	test   %edx,%edx
  801c77:	78 16                	js     801c8f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801c79:	8b 45 10             	mov    0x10(%ebp),%eax
  801c7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c87:	89 14 24             	mov    %edx,(%esp)
  801c8a:	e8 60 01 00 00       	call   801def <nsipc_bind>
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <shutdown>:

int
shutdown(int s, int how)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	e8 ea fe ff ff       	call   801b89 <fd2sockid>
  801c9f:	89 c2                	mov    %eax,%edx
  801ca1:	85 d2                	test   %edx,%edx
  801ca3:	78 0f                	js     801cb4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801ca5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cac:	89 14 24             	mov    %edx,(%esp)
  801caf:	e8 7a 01 00 00       	call   801e2e <nsipc_shutdown>
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	e8 c5 fe ff ff       	call   801b89 <fd2sockid>
  801cc4:	89 c2                	mov    %eax,%edx
  801cc6:	85 d2                	test   %edx,%edx
  801cc8:	78 16                	js     801ce0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801cca:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd8:	89 14 24             	mov    %edx,(%esp)
  801cdb:	e8 8a 01 00 00       	call   801e6a <nsipc_connect>
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <listen>:

int
listen(int s, int backlog)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	e8 99 fe ff ff       	call   801b89 <fd2sockid>
  801cf0:	89 c2                	mov    %eax,%edx
  801cf2:	85 d2                	test   %edx,%edx
  801cf4:	78 0f                	js     801d05 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cfd:	89 14 24             	mov    %edx,(%esp)
  801d00:	e8 a4 01 00 00       	call   801ea9 <nsipc_listen>
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d10:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	89 04 24             	mov    %eax,(%esp)
  801d21:	e8 98 02 00 00       	call   801fbe <nsipc_socket>
  801d26:	89 c2                	mov    %eax,%edx
  801d28:	85 d2                	test   %edx,%edx
  801d2a:	78 05                	js     801d31 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801d2c:	e8 8a fe ff ff       	call   801bbb <alloc_sockfd>
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	53                   	push   %ebx
  801d37:	83 ec 14             	sub    $0x14,%esp
  801d3a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d3c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801d43:	75 11                	jne    801d56 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d45:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801d4c:	e8 8e 08 00 00       	call   8025df <ipc_find_env>
  801d51:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d56:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d5d:	00 
  801d5e:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  801d65:	00 
  801d66:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d6a:	a1 04 40 80 00       	mov    0x804004,%eax
  801d6f:	89 04 24             	mov    %eax,(%esp)
  801d72:	e8 fd 07 00 00       	call   802574 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d77:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d7e:	00 
  801d7f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d86:	00 
  801d87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d8e:	e8 8d 07 00 00       	call   802520 <ipc_recv>
}
  801d93:	83 c4 14             	add    $0x14,%esp
  801d96:	5b                   	pop    %ebx
  801d97:	5d                   	pop    %ebp
  801d98:	c3                   	ret    

00801d99 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	56                   	push   %esi
  801d9d:	53                   	push   %ebx
  801d9e:	83 ec 10             	sub    $0x10,%esp
  801da1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801dac:	8b 06                	mov    (%esi),%eax
  801dae:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801db3:	b8 01 00 00 00       	mov    $0x1,%eax
  801db8:	e8 76 ff ff ff       	call   801d33 <nsipc>
  801dbd:	89 c3                	mov    %eax,%ebx
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	78 23                	js     801de6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801dc3:	a1 10 80 80 00       	mov    0x808010,%eax
  801dc8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dcc:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801dd3:	00 
  801dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd7:	89 04 24             	mov    %eax,(%esp)
  801dda:	e8 a5 ec ff ff       	call   800a84 <memmove>
		*addrlen = ret->ret_addrlen;
  801ddf:	a1 10 80 80 00       	mov    0x808010,%eax
  801de4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801de6:	89 d8                	mov    %ebx,%eax
  801de8:	83 c4 10             	add    $0x10,%esp
  801deb:	5b                   	pop    %ebx
  801dec:	5e                   	pop    %esi
  801ded:	5d                   	pop    %ebp
  801dee:	c3                   	ret    

00801def <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	53                   	push   %ebx
  801df3:	83 ec 14             	sub    $0x14,%esp
  801df6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e01:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e0c:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  801e13:	e8 6c ec ff ff       	call   800a84 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e18:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  801e1e:	b8 02 00 00 00       	mov    $0x2,%eax
  801e23:	e8 0b ff ff ff       	call   801d33 <nsipc>
}
  801e28:	83 c4 14             	add    $0x14,%esp
  801e2b:	5b                   	pop    %ebx
  801e2c:	5d                   	pop    %ebp
  801e2d:	c3                   	ret    

00801e2e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  801e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3f:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  801e44:	b8 03 00 00 00       	mov    $0x3,%eax
  801e49:	e8 e5 fe ff ff       	call   801d33 <nsipc>
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <nsipc_close>:

int
nsipc_close(int s)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e56:	8b 45 08             	mov    0x8(%ebp),%eax
  801e59:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  801e5e:	b8 04 00 00 00       	mov    $0x4,%eax
  801e63:	e8 cb fe ff ff       	call   801d33 <nsipc>
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	53                   	push   %ebx
  801e6e:	83 ec 14             	sub    $0x14,%esp
  801e71:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e74:	8b 45 08             	mov    0x8(%ebp),%eax
  801e77:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e7c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e87:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  801e8e:	e8 f1 eb ff ff       	call   800a84 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e93:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  801e99:	b8 05 00 00 00       	mov    $0x5,%eax
  801e9e:	e8 90 fe ff ff       	call   801d33 <nsipc>
}
  801ea3:	83 c4 14             	add    $0x14,%esp
  801ea6:	5b                   	pop    %ebx
  801ea7:	5d                   	pop    %ebp
  801ea8:	c3                   	ret    

00801ea9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  801eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eba:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  801ebf:	b8 06 00 00 00       	mov    $0x6,%eax
  801ec4:	e8 6a fe ff ff       	call   801d33 <nsipc>
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	56                   	push   %esi
  801ecf:	53                   	push   %ebx
  801ed0:	83 ec 10             	sub    $0x10,%esp
  801ed3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed9:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  801ede:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  801ee4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee7:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801eec:	b8 07 00 00 00       	mov    $0x7,%eax
  801ef1:	e8 3d fe ff ff       	call   801d33 <nsipc>
  801ef6:	89 c3                	mov    %eax,%ebx
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	78 46                	js     801f42 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801efc:	39 f0                	cmp    %esi,%eax
  801efe:	7f 07                	jg     801f07 <nsipc_recv+0x3c>
  801f00:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f05:	7e 24                	jle    801f2b <nsipc_recv+0x60>
  801f07:	c7 44 24 0c c7 2d 80 	movl   $0x802dc7,0xc(%esp)
  801f0e:	00 
  801f0f:	c7 44 24 08 8f 2d 80 	movl   $0x802d8f,0x8(%esp)
  801f16:	00 
  801f17:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801f1e:	00 
  801f1f:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  801f26:	e8 9f e2 ff ff       	call   8001ca <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f2f:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801f36:	00 
  801f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3a:	89 04 24             	mov    %eax,(%esp)
  801f3d:	e8 42 eb ff ff       	call   800a84 <memmove>
	}

	return r;
}
  801f42:	89 d8                	mov    %ebx,%eax
  801f44:	83 c4 10             	add    $0x10,%esp
  801f47:	5b                   	pop    %ebx
  801f48:	5e                   	pop    %esi
  801f49:	5d                   	pop    %ebp
  801f4a:	c3                   	ret    

00801f4b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	53                   	push   %ebx
  801f4f:	83 ec 14             	sub    $0x14,%esp
  801f52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  801f5d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f63:	7e 24                	jle    801f89 <nsipc_send+0x3e>
  801f65:	c7 44 24 0c e8 2d 80 	movl   $0x802de8,0xc(%esp)
  801f6c:	00 
  801f6d:	c7 44 24 08 8f 2d 80 	movl   $0x802d8f,0x8(%esp)
  801f74:	00 
  801f75:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801f7c:	00 
  801f7d:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  801f84:	e8 41 e2 ff ff       	call   8001ca <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f89:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f94:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  801f9b:	e8 e4 ea ff ff       	call   800a84 <memmove>
	nsipcbuf.send.req_size = size;
  801fa0:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  801fa6:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa9:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  801fae:	b8 08 00 00 00       	mov    $0x8,%eax
  801fb3:	e8 7b fd ff ff       	call   801d33 <nsipc>
}
  801fb8:	83 c4 14             	add    $0x14,%esp
  801fbb:	5b                   	pop    %ebx
  801fbc:	5d                   	pop    %ebp
  801fbd:	c3                   	ret    

00801fbe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  801fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fcf:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  801fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd7:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  801fdc:	b8 09 00 00 00       	mov    $0x9,%eax
  801fe1:	e8 4d fd ff ff       	call   801d33 <nsipc>
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
  801feb:	56                   	push   %esi
  801fec:	53                   	push   %ebx
  801fed:	83 ec 10             	sub    $0x10,%esp
  801ff0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	89 04 24             	mov    %eax,(%esp)
  801ff9:	e8 42 f1 ff ff       	call   801140 <fd2data>
  801ffe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802000:	c7 44 24 04 f4 2d 80 	movl   $0x802df4,0x4(%esp)
  802007:	00 
  802008:	89 1c 24             	mov    %ebx,(%esp)
  80200b:	e8 d7 e8 ff ff       	call   8008e7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802010:	8b 46 04             	mov    0x4(%esi),%eax
  802013:	2b 06                	sub    (%esi),%eax
  802015:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80201b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802022:	00 00 00 
	stat->st_dev = &devpipe;
  802025:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80202c:	30 80 00 
	return 0;
}
  80202f:	b8 00 00 00 00       	mov    $0x0,%eax
  802034:	83 c4 10             	add    $0x10,%esp
  802037:	5b                   	pop    %ebx
  802038:	5e                   	pop    %esi
  802039:	5d                   	pop    %ebp
  80203a:	c3                   	ret    

0080203b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	53                   	push   %ebx
  80203f:	83 ec 14             	sub    $0x14,%esp
  802042:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802045:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802049:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802050:	e8 55 ed ff ff       	call   800daa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802055:	89 1c 24             	mov    %ebx,(%esp)
  802058:	e8 e3 f0 ff ff       	call   801140 <fd2data>
  80205d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802061:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802068:	e8 3d ed ff ff       	call   800daa <sys_page_unmap>
}
  80206d:	83 c4 14             	add    $0x14,%esp
  802070:	5b                   	pop    %ebx
  802071:	5d                   	pop    %ebp
  802072:	c3                   	ret    

00802073 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
  802076:	57                   	push   %edi
  802077:	56                   	push   %esi
  802078:	53                   	push   %ebx
  802079:	83 ec 2c             	sub    $0x2c,%esp
  80207c:	89 c6                	mov    %eax,%esi
  80207e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802081:	a1 20 60 80 00       	mov    0x806020,%eax
  802086:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802089:	89 34 24             	mov    %esi,(%esp)
  80208c:	e8 8d 05 00 00       	call   80261e <pageref>
  802091:	89 c7                	mov    %eax,%edi
  802093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802096:	89 04 24             	mov    %eax,(%esp)
  802099:	e8 80 05 00 00       	call   80261e <pageref>
  80209e:	39 c7                	cmp    %eax,%edi
  8020a0:	0f 94 c2             	sete   %dl
  8020a3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8020a6:	8b 0d 20 60 80 00    	mov    0x806020,%ecx
  8020ac:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8020af:	39 fb                	cmp    %edi,%ebx
  8020b1:	74 21                	je     8020d4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8020b3:	84 d2                	test   %dl,%dl
  8020b5:	74 ca                	je     802081 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020b7:	8b 51 58             	mov    0x58(%ecx),%edx
  8020ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020be:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020c6:	c7 04 24 fb 2d 80 00 	movl   $0x802dfb,(%esp)
  8020cd:	e8 f1 e1 ff ff       	call   8002c3 <cprintf>
  8020d2:	eb ad                	jmp    802081 <_pipeisclosed+0xe>
	}
}
  8020d4:	83 c4 2c             	add    $0x2c,%esp
  8020d7:	5b                   	pop    %ebx
  8020d8:	5e                   	pop    %esi
  8020d9:	5f                   	pop    %edi
  8020da:	5d                   	pop    %ebp
  8020db:	c3                   	ret    

008020dc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	57                   	push   %edi
  8020e0:	56                   	push   %esi
  8020e1:	53                   	push   %ebx
  8020e2:	83 ec 1c             	sub    $0x1c,%esp
  8020e5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8020e8:	89 34 24             	mov    %esi,(%esp)
  8020eb:	e8 50 f0 ff ff       	call   801140 <fd2data>
  8020f0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f7:	eb 45                	jmp    80213e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8020f9:	89 da                	mov    %ebx,%edx
  8020fb:	89 f0                	mov    %esi,%eax
  8020fd:	e8 71 ff ff ff       	call   802073 <_pipeisclosed>
  802102:	85 c0                	test   %eax,%eax
  802104:	75 41                	jne    802147 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802106:	e8 d9 eb ff ff       	call   800ce4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80210b:	8b 43 04             	mov    0x4(%ebx),%eax
  80210e:	8b 0b                	mov    (%ebx),%ecx
  802110:	8d 51 20             	lea    0x20(%ecx),%edx
  802113:	39 d0                	cmp    %edx,%eax
  802115:	73 e2                	jae    8020f9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802117:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80211a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80211e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802121:	99                   	cltd   
  802122:	c1 ea 1b             	shr    $0x1b,%edx
  802125:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802128:	83 e1 1f             	and    $0x1f,%ecx
  80212b:	29 d1                	sub    %edx,%ecx
  80212d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802131:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802135:	83 c0 01             	add    $0x1,%eax
  802138:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80213b:	83 c7 01             	add    $0x1,%edi
  80213e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802141:	75 c8                	jne    80210b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802143:	89 f8                	mov    %edi,%eax
  802145:	eb 05                	jmp    80214c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802147:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80214c:	83 c4 1c             	add    $0x1c,%esp
  80214f:	5b                   	pop    %ebx
  802150:	5e                   	pop    %esi
  802151:	5f                   	pop    %edi
  802152:	5d                   	pop    %ebp
  802153:	c3                   	ret    

00802154 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	57                   	push   %edi
  802158:	56                   	push   %esi
  802159:	53                   	push   %ebx
  80215a:	83 ec 1c             	sub    $0x1c,%esp
  80215d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802160:	89 3c 24             	mov    %edi,(%esp)
  802163:	e8 d8 ef ff ff       	call   801140 <fd2data>
  802168:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80216a:	be 00 00 00 00       	mov    $0x0,%esi
  80216f:	eb 3d                	jmp    8021ae <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802171:	85 f6                	test   %esi,%esi
  802173:	74 04                	je     802179 <devpipe_read+0x25>
				return i;
  802175:	89 f0                	mov    %esi,%eax
  802177:	eb 43                	jmp    8021bc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802179:	89 da                	mov    %ebx,%edx
  80217b:	89 f8                	mov    %edi,%eax
  80217d:	e8 f1 fe ff ff       	call   802073 <_pipeisclosed>
  802182:	85 c0                	test   %eax,%eax
  802184:	75 31                	jne    8021b7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802186:	e8 59 eb ff ff       	call   800ce4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80218b:	8b 03                	mov    (%ebx),%eax
  80218d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802190:	74 df                	je     802171 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802192:	99                   	cltd   
  802193:	c1 ea 1b             	shr    $0x1b,%edx
  802196:	01 d0                	add    %edx,%eax
  802198:	83 e0 1f             	and    $0x1f,%eax
  80219b:	29 d0                	sub    %edx,%eax
  80219d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021a5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021a8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021ab:	83 c6 01             	add    $0x1,%esi
  8021ae:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021b1:	75 d8                	jne    80218b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8021b3:	89 f0                	mov    %esi,%eax
  8021b5:	eb 05                	jmp    8021bc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8021b7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8021bc:	83 c4 1c             	add    $0x1c,%esp
  8021bf:	5b                   	pop    %ebx
  8021c0:	5e                   	pop    %esi
  8021c1:	5f                   	pop    %edi
  8021c2:	5d                   	pop    %ebp
  8021c3:	c3                   	ret    

008021c4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
  8021c7:	56                   	push   %esi
  8021c8:	53                   	push   %ebx
  8021c9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8021cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021cf:	89 04 24             	mov    %eax,(%esp)
  8021d2:	e8 80 ef ff ff       	call   801157 <fd_alloc>
  8021d7:	89 c2                	mov    %eax,%edx
  8021d9:	85 d2                	test   %edx,%edx
  8021db:	0f 88 4d 01 00 00    	js     80232e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021e1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021e8:	00 
  8021e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021f7:	e8 07 eb ff ff       	call   800d03 <sys_page_alloc>
  8021fc:	89 c2                	mov    %eax,%edx
  8021fe:	85 d2                	test   %edx,%edx
  802200:	0f 88 28 01 00 00    	js     80232e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802206:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802209:	89 04 24             	mov    %eax,(%esp)
  80220c:	e8 46 ef ff ff       	call   801157 <fd_alloc>
  802211:	89 c3                	mov    %eax,%ebx
  802213:	85 c0                	test   %eax,%eax
  802215:	0f 88 fe 00 00 00    	js     802319 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80221b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802222:	00 
  802223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802226:	89 44 24 04          	mov    %eax,0x4(%esp)
  80222a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802231:	e8 cd ea ff ff       	call   800d03 <sys_page_alloc>
  802236:	89 c3                	mov    %eax,%ebx
  802238:	85 c0                	test   %eax,%eax
  80223a:	0f 88 d9 00 00 00    	js     802319 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802243:	89 04 24             	mov    %eax,(%esp)
  802246:	e8 f5 ee ff ff       	call   801140 <fd2data>
  80224b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80224d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802254:	00 
  802255:	89 44 24 04          	mov    %eax,0x4(%esp)
  802259:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802260:	e8 9e ea ff ff       	call   800d03 <sys_page_alloc>
  802265:	89 c3                	mov    %eax,%ebx
  802267:	85 c0                	test   %eax,%eax
  802269:	0f 88 97 00 00 00    	js     802306 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80226f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802272:	89 04 24             	mov    %eax,(%esp)
  802275:	e8 c6 ee ff ff       	call   801140 <fd2data>
  80227a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802281:	00 
  802282:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802286:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80228d:	00 
  80228e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802292:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802299:	e8 b9 ea ff ff       	call   800d57 <sys_page_map>
  80229e:	89 c3                	mov    %eax,%ebx
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	78 52                	js     8022f6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8022a4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8022b9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8022c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	89 04 24             	mov    %eax,(%esp)
  8022d4:	e8 57 ee ff ff       	call   801130 <fd2num>
  8022d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022dc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e1:	89 04 24             	mov    %eax,(%esp)
  8022e4:	e8 47 ee ff ff       	call   801130 <fd2num>
  8022e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022ec:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f4:	eb 38                	jmp    80232e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8022f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802301:	e8 a4 ea ff ff       	call   800daa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802306:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802309:	89 44 24 04          	mov    %eax,0x4(%esp)
  80230d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802314:	e8 91 ea ff ff       	call   800daa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802320:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802327:	e8 7e ea ff ff       	call   800daa <sys_page_unmap>
  80232c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80232e:	83 c4 30             	add    $0x30,%esp
  802331:	5b                   	pop    %ebx
  802332:	5e                   	pop    %esi
  802333:	5d                   	pop    %ebp
  802334:	c3                   	ret    

00802335 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80233b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80233e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	89 04 24             	mov    %eax,(%esp)
  802348:	e8 59 ee ff ff       	call   8011a6 <fd_lookup>
  80234d:	89 c2                	mov    %eax,%edx
  80234f:	85 d2                	test   %edx,%edx
  802351:	78 15                	js     802368 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802356:	89 04 24             	mov    %eax,(%esp)
  802359:	e8 e2 ed ff ff       	call   801140 <fd2data>
	return _pipeisclosed(fd, p);
  80235e:	89 c2                	mov    %eax,%edx
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	e8 0b fd ff ff       	call   802073 <_pipeisclosed>
}
  802368:	c9                   	leave  
  802369:	c3                   	ret    
  80236a:	66 90                	xchg   %ax,%ax
  80236c:	66 90                	xchg   %ax,%ax
  80236e:	66 90                	xchg   %ax,%ax

00802370 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802373:	b8 00 00 00 00       	mov    $0x0,%eax
  802378:	5d                   	pop    %ebp
  802379:	c3                   	ret    

0080237a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802380:	c7 44 24 04 13 2e 80 	movl   $0x802e13,0x4(%esp)
  802387:	00 
  802388:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238b:	89 04 24             	mov    %eax,(%esp)
  80238e:	e8 54 e5 ff ff       	call   8008e7 <strcpy>
	return 0;
}
  802393:	b8 00 00 00 00       	mov    $0x0,%eax
  802398:	c9                   	leave  
  802399:	c3                   	ret    

0080239a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
  80239d:	57                   	push   %edi
  80239e:	56                   	push   %esi
  80239f:	53                   	push   %ebx
  8023a0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8023ab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023b1:	eb 31                	jmp    8023e4 <devcons_write+0x4a>
		m = n - tot;
  8023b3:	8b 75 10             	mov    0x10(%ebp),%esi
  8023b6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8023b8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8023bb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8023c0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8023c3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8023c7:	03 45 0c             	add    0xc(%ebp),%eax
  8023ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ce:	89 3c 24             	mov    %edi,(%esp)
  8023d1:	e8 ae e6 ff ff       	call   800a84 <memmove>
		sys_cputs(buf, m);
  8023d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023da:	89 3c 24             	mov    %edi,(%esp)
  8023dd:	e8 54 e8 ff ff       	call   800c36 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023e2:	01 f3                	add    %esi,%ebx
  8023e4:	89 d8                	mov    %ebx,%eax
  8023e6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8023e9:	72 c8                	jb     8023b3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8023eb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8023f1:	5b                   	pop    %ebx
  8023f2:	5e                   	pop    %esi
  8023f3:	5f                   	pop    %edi
  8023f4:	5d                   	pop    %ebp
  8023f5:	c3                   	ret    

008023f6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
  8023f9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8023fc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802401:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802405:	75 07                	jne    80240e <devcons_read+0x18>
  802407:	eb 2a                	jmp    802433 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802409:	e8 d6 e8 ff ff       	call   800ce4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80240e:	66 90                	xchg   %ax,%ax
  802410:	e8 3f e8 ff ff       	call   800c54 <sys_cgetc>
  802415:	85 c0                	test   %eax,%eax
  802417:	74 f0                	je     802409 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802419:	85 c0                	test   %eax,%eax
  80241b:	78 16                	js     802433 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80241d:	83 f8 04             	cmp    $0x4,%eax
  802420:	74 0c                	je     80242e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802422:	8b 55 0c             	mov    0xc(%ebp),%edx
  802425:	88 02                	mov    %al,(%edx)
	return 1;
  802427:	b8 01 00 00 00       	mov    $0x1,%eax
  80242c:	eb 05                	jmp    802433 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80242e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
  802438:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802441:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802448:	00 
  802449:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80244c:	89 04 24             	mov    %eax,(%esp)
  80244f:	e8 e2 e7 ff ff       	call   800c36 <sys_cputs>
}
  802454:	c9                   	leave  
  802455:	c3                   	ret    

00802456 <getchar>:

int
getchar(void)
{
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
  802459:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80245c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802463:	00 
  802464:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802467:	89 44 24 04          	mov    %eax,0x4(%esp)
  80246b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802472:	e8 c3 ef ff ff       	call   80143a <read>
	if (r < 0)
  802477:	85 c0                	test   %eax,%eax
  802479:	78 0f                	js     80248a <getchar+0x34>
		return r;
	if (r < 1)
  80247b:	85 c0                	test   %eax,%eax
  80247d:	7e 06                	jle    802485 <getchar+0x2f>
		return -E_EOF;
	return c;
  80247f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802483:	eb 05                	jmp    80248a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802485:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802492:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802495:	89 44 24 04          	mov    %eax,0x4(%esp)
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	89 04 24             	mov    %eax,(%esp)
  80249f:	e8 02 ed ff ff       	call   8011a6 <fd_lookup>
  8024a4:	85 c0                	test   %eax,%eax
  8024a6:	78 11                	js     8024b9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024b1:	39 10                	cmp    %edx,(%eax)
  8024b3:	0f 94 c0             	sete   %al
  8024b6:	0f b6 c0             	movzbl %al,%eax
}
  8024b9:	c9                   	leave  
  8024ba:	c3                   	ret    

008024bb <opencons>:

int
opencons(void)
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
  8024be:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024c4:	89 04 24             	mov    %eax,(%esp)
  8024c7:	e8 8b ec ff ff       	call   801157 <fd_alloc>
		return r;
  8024cc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	78 40                	js     802512 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024d9:	00 
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024e8:	e8 16 e8 ff ff       	call   800d03 <sys_page_alloc>
		return r;
  8024ed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024ef:	85 c0                	test   %eax,%eax
  8024f1:	78 1f                	js     802512 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8024f3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802508:	89 04 24             	mov    %eax,(%esp)
  80250b:	e8 20 ec ff ff       	call   801130 <fd2num>
  802510:	89 c2                	mov    %eax,%edx
}
  802512:	89 d0                	mov    %edx,%eax
  802514:	c9                   	leave  
  802515:	c3                   	ret    
  802516:	66 90                	xchg   %ax,%ax
  802518:	66 90                	xchg   %ax,%ax
  80251a:	66 90                	xchg   %ax,%ax
  80251c:	66 90                	xchg   %ax,%ax
  80251e:	66 90                	xchg   %ax,%ax

00802520 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
  802523:	56                   	push   %esi
  802524:	53                   	push   %ebx
  802525:	83 ec 10             	sub    $0x10,%esp
  802528:	8b 75 08             	mov    0x8(%ebp),%esi
  80252b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80252e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802531:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802533:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802538:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80253b:	89 04 24             	mov    %eax,(%esp)
  80253e:	e8 d6 e9 ff ff       	call   800f19 <sys_ipc_recv>
  802543:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802545:	85 d2                	test   %edx,%edx
  802547:	75 24                	jne    80256d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802549:	85 f6                	test   %esi,%esi
  80254b:	74 0a                	je     802557 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80254d:	a1 20 60 80 00       	mov    0x806020,%eax
  802552:	8b 40 74             	mov    0x74(%eax),%eax
  802555:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802557:	85 db                	test   %ebx,%ebx
  802559:	74 0a                	je     802565 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80255b:	a1 20 60 80 00       	mov    0x806020,%eax
  802560:	8b 40 78             	mov    0x78(%eax),%eax
  802563:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802565:	a1 20 60 80 00       	mov    0x806020,%eax
  80256a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80256d:	83 c4 10             	add    $0x10,%esp
  802570:	5b                   	pop    %ebx
  802571:	5e                   	pop    %esi
  802572:	5d                   	pop    %ebp
  802573:	c3                   	ret    

00802574 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
  802577:	57                   	push   %edi
  802578:	56                   	push   %esi
  802579:	53                   	push   %ebx
  80257a:	83 ec 1c             	sub    $0x1c,%esp
  80257d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802580:	8b 75 0c             	mov    0xc(%ebp),%esi
  802583:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802586:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802588:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80258d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802590:	8b 45 14             	mov    0x14(%ebp),%eax
  802593:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802597:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80259b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80259f:	89 3c 24             	mov    %edi,(%esp)
  8025a2:	e8 4f e9 ff ff       	call   800ef6 <sys_ipc_try_send>

		if (ret == 0)
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	74 2c                	je     8025d7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  8025ab:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8025ae:	74 20                	je     8025d0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  8025b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025b4:	c7 44 24 08 20 2e 80 	movl   $0x802e20,0x8(%esp)
  8025bb:	00 
  8025bc:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8025c3:	00 
  8025c4:	c7 04 24 50 2e 80 00 	movl   $0x802e50,(%esp)
  8025cb:	e8 fa db ff ff       	call   8001ca <_panic>
		}

		sys_yield();
  8025d0:	e8 0f e7 ff ff       	call   800ce4 <sys_yield>
	}
  8025d5:	eb b9                	jmp    802590 <ipc_send+0x1c>
}
  8025d7:	83 c4 1c             	add    $0x1c,%esp
  8025da:	5b                   	pop    %ebx
  8025db:	5e                   	pop    %esi
  8025dc:	5f                   	pop    %edi
  8025dd:	5d                   	pop    %ebp
  8025de:	c3                   	ret    

008025df <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
  8025e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025e5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025ea:	89 c2                	mov    %eax,%edx
  8025ec:	c1 e2 07             	shl    $0x7,%edx
  8025ef:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  8025f6:	8b 52 50             	mov    0x50(%edx),%edx
  8025f9:	39 ca                	cmp    %ecx,%edx
  8025fb:	75 11                	jne    80260e <ipc_find_env+0x2f>
			return envs[i].env_id;
  8025fd:	89 c2                	mov    %eax,%edx
  8025ff:	c1 e2 07             	shl    $0x7,%edx
  802602:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802609:	8b 40 40             	mov    0x40(%eax),%eax
  80260c:	eb 0e                	jmp    80261c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80260e:	83 c0 01             	add    $0x1,%eax
  802611:	3d 00 04 00 00       	cmp    $0x400,%eax
  802616:	75 d2                	jne    8025ea <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802618:	66 b8 00 00          	mov    $0x0,%ax
}
  80261c:	5d                   	pop    %ebp
  80261d:	c3                   	ret    

0080261e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80261e:	55                   	push   %ebp
  80261f:	89 e5                	mov    %esp,%ebp
  802621:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802624:	89 d0                	mov    %edx,%eax
  802626:	c1 e8 16             	shr    $0x16,%eax
  802629:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802630:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802635:	f6 c1 01             	test   $0x1,%cl
  802638:	74 1d                	je     802657 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80263a:	c1 ea 0c             	shr    $0xc,%edx
  80263d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802644:	f6 c2 01             	test   $0x1,%dl
  802647:	74 0e                	je     802657 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802649:	c1 ea 0c             	shr    $0xc,%edx
  80264c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802653:	ef 
  802654:	0f b7 c0             	movzwl %ax,%eax
}
  802657:	5d                   	pop    %ebp
  802658:	c3                   	ret    
  802659:	66 90                	xchg   %ax,%ax
  80265b:	66 90                	xchg   %ax,%ax
  80265d:	66 90                	xchg   %ax,%ax
  80265f:	90                   	nop

00802660 <__udivdi3>:
  802660:	55                   	push   %ebp
  802661:	57                   	push   %edi
  802662:	56                   	push   %esi
  802663:	83 ec 0c             	sub    $0xc,%esp
  802666:	8b 44 24 28          	mov    0x28(%esp),%eax
  80266a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80266e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802672:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802676:	85 c0                	test   %eax,%eax
  802678:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80267c:	89 ea                	mov    %ebp,%edx
  80267e:	89 0c 24             	mov    %ecx,(%esp)
  802681:	75 2d                	jne    8026b0 <__udivdi3+0x50>
  802683:	39 e9                	cmp    %ebp,%ecx
  802685:	77 61                	ja     8026e8 <__udivdi3+0x88>
  802687:	85 c9                	test   %ecx,%ecx
  802689:	89 ce                	mov    %ecx,%esi
  80268b:	75 0b                	jne    802698 <__udivdi3+0x38>
  80268d:	b8 01 00 00 00       	mov    $0x1,%eax
  802692:	31 d2                	xor    %edx,%edx
  802694:	f7 f1                	div    %ecx
  802696:	89 c6                	mov    %eax,%esi
  802698:	31 d2                	xor    %edx,%edx
  80269a:	89 e8                	mov    %ebp,%eax
  80269c:	f7 f6                	div    %esi
  80269e:	89 c5                	mov    %eax,%ebp
  8026a0:	89 f8                	mov    %edi,%eax
  8026a2:	f7 f6                	div    %esi
  8026a4:	89 ea                	mov    %ebp,%edx
  8026a6:	83 c4 0c             	add    $0xc,%esp
  8026a9:	5e                   	pop    %esi
  8026aa:	5f                   	pop    %edi
  8026ab:	5d                   	pop    %ebp
  8026ac:	c3                   	ret    
  8026ad:	8d 76 00             	lea    0x0(%esi),%esi
  8026b0:	39 e8                	cmp    %ebp,%eax
  8026b2:	77 24                	ja     8026d8 <__udivdi3+0x78>
  8026b4:	0f bd e8             	bsr    %eax,%ebp
  8026b7:	83 f5 1f             	xor    $0x1f,%ebp
  8026ba:	75 3c                	jne    8026f8 <__udivdi3+0x98>
  8026bc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8026c0:	39 34 24             	cmp    %esi,(%esp)
  8026c3:	0f 86 9f 00 00 00    	jbe    802768 <__udivdi3+0x108>
  8026c9:	39 d0                	cmp    %edx,%eax
  8026cb:	0f 82 97 00 00 00    	jb     802768 <__udivdi3+0x108>
  8026d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026d8:	31 d2                	xor    %edx,%edx
  8026da:	31 c0                	xor    %eax,%eax
  8026dc:	83 c4 0c             	add    $0xc,%esp
  8026df:	5e                   	pop    %esi
  8026e0:	5f                   	pop    %edi
  8026e1:	5d                   	pop    %ebp
  8026e2:	c3                   	ret    
  8026e3:	90                   	nop
  8026e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026e8:	89 f8                	mov    %edi,%eax
  8026ea:	f7 f1                	div    %ecx
  8026ec:	31 d2                	xor    %edx,%edx
  8026ee:	83 c4 0c             	add    $0xc,%esp
  8026f1:	5e                   	pop    %esi
  8026f2:	5f                   	pop    %edi
  8026f3:	5d                   	pop    %ebp
  8026f4:	c3                   	ret    
  8026f5:	8d 76 00             	lea    0x0(%esi),%esi
  8026f8:	89 e9                	mov    %ebp,%ecx
  8026fa:	8b 3c 24             	mov    (%esp),%edi
  8026fd:	d3 e0                	shl    %cl,%eax
  8026ff:	89 c6                	mov    %eax,%esi
  802701:	b8 20 00 00 00       	mov    $0x20,%eax
  802706:	29 e8                	sub    %ebp,%eax
  802708:	89 c1                	mov    %eax,%ecx
  80270a:	d3 ef                	shr    %cl,%edi
  80270c:	89 e9                	mov    %ebp,%ecx
  80270e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802712:	8b 3c 24             	mov    (%esp),%edi
  802715:	09 74 24 08          	or     %esi,0x8(%esp)
  802719:	89 d6                	mov    %edx,%esi
  80271b:	d3 e7                	shl    %cl,%edi
  80271d:	89 c1                	mov    %eax,%ecx
  80271f:	89 3c 24             	mov    %edi,(%esp)
  802722:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802726:	d3 ee                	shr    %cl,%esi
  802728:	89 e9                	mov    %ebp,%ecx
  80272a:	d3 e2                	shl    %cl,%edx
  80272c:	89 c1                	mov    %eax,%ecx
  80272e:	d3 ef                	shr    %cl,%edi
  802730:	09 d7                	or     %edx,%edi
  802732:	89 f2                	mov    %esi,%edx
  802734:	89 f8                	mov    %edi,%eax
  802736:	f7 74 24 08          	divl   0x8(%esp)
  80273a:	89 d6                	mov    %edx,%esi
  80273c:	89 c7                	mov    %eax,%edi
  80273e:	f7 24 24             	mull   (%esp)
  802741:	39 d6                	cmp    %edx,%esi
  802743:	89 14 24             	mov    %edx,(%esp)
  802746:	72 30                	jb     802778 <__udivdi3+0x118>
  802748:	8b 54 24 04          	mov    0x4(%esp),%edx
  80274c:	89 e9                	mov    %ebp,%ecx
  80274e:	d3 e2                	shl    %cl,%edx
  802750:	39 c2                	cmp    %eax,%edx
  802752:	73 05                	jae    802759 <__udivdi3+0xf9>
  802754:	3b 34 24             	cmp    (%esp),%esi
  802757:	74 1f                	je     802778 <__udivdi3+0x118>
  802759:	89 f8                	mov    %edi,%eax
  80275b:	31 d2                	xor    %edx,%edx
  80275d:	e9 7a ff ff ff       	jmp    8026dc <__udivdi3+0x7c>
  802762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802768:	31 d2                	xor    %edx,%edx
  80276a:	b8 01 00 00 00       	mov    $0x1,%eax
  80276f:	e9 68 ff ff ff       	jmp    8026dc <__udivdi3+0x7c>
  802774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802778:	8d 47 ff             	lea    -0x1(%edi),%eax
  80277b:	31 d2                	xor    %edx,%edx
  80277d:	83 c4 0c             	add    $0xc,%esp
  802780:	5e                   	pop    %esi
  802781:	5f                   	pop    %edi
  802782:	5d                   	pop    %ebp
  802783:	c3                   	ret    
  802784:	66 90                	xchg   %ax,%ax
  802786:	66 90                	xchg   %ax,%ax
  802788:	66 90                	xchg   %ax,%ax
  80278a:	66 90                	xchg   %ax,%ax
  80278c:	66 90                	xchg   %ax,%ax
  80278e:	66 90                	xchg   %ax,%ax

00802790 <__umoddi3>:
  802790:	55                   	push   %ebp
  802791:	57                   	push   %edi
  802792:	56                   	push   %esi
  802793:	83 ec 14             	sub    $0x14,%esp
  802796:	8b 44 24 28          	mov    0x28(%esp),%eax
  80279a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80279e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8027a2:	89 c7                	mov    %eax,%edi
  8027a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027a8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8027ac:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8027b0:	89 34 24             	mov    %esi,(%esp)
  8027b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	89 c2                	mov    %eax,%edx
  8027bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027bf:	75 17                	jne    8027d8 <__umoddi3+0x48>
  8027c1:	39 fe                	cmp    %edi,%esi
  8027c3:	76 4b                	jbe    802810 <__umoddi3+0x80>
  8027c5:	89 c8                	mov    %ecx,%eax
  8027c7:	89 fa                	mov    %edi,%edx
  8027c9:	f7 f6                	div    %esi
  8027cb:	89 d0                	mov    %edx,%eax
  8027cd:	31 d2                	xor    %edx,%edx
  8027cf:	83 c4 14             	add    $0x14,%esp
  8027d2:	5e                   	pop    %esi
  8027d3:	5f                   	pop    %edi
  8027d4:	5d                   	pop    %ebp
  8027d5:	c3                   	ret    
  8027d6:	66 90                	xchg   %ax,%ax
  8027d8:	39 f8                	cmp    %edi,%eax
  8027da:	77 54                	ja     802830 <__umoddi3+0xa0>
  8027dc:	0f bd e8             	bsr    %eax,%ebp
  8027df:	83 f5 1f             	xor    $0x1f,%ebp
  8027e2:	75 5c                	jne    802840 <__umoddi3+0xb0>
  8027e4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8027e8:	39 3c 24             	cmp    %edi,(%esp)
  8027eb:	0f 87 e7 00 00 00    	ja     8028d8 <__umoddi3+0x148>
  8027f1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8027f5:	29 f1                	sub    %esi,%ecx
  8027f7:	19 c7                	sbb    %eax,%edi
  8027f9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802801:	8b 44 24 08          	mov    0x8(%esp),%eax
  802805:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802809:	83 c4 14             	add    $0x14,%esp
  80280c:	5e                   	pop    %esi
  80280d:	5f                   	pop    %edi
  80280e:	5d                   	pop    %ebp
  80280f:	c3                   	ret    
  802810:	85 f6                	test   %esi,%esi
  802812:	89 f5                	mov    %esi,%ebp
  802814:	75 0b                	jne    802821 <__umoddi3+0x91>
  802816:	b8 01 00 00 00       	mov    $0x1,%eax
  80281b:	31 d2                	xor    %edx,%edx
  80281d:	f7 f6                	div    %esi
  80281f:	89 c5                	mov    %eax,%ebp
  802821:	8b 44 24 04          	mov    0x4(%esp),%eax
  802825:	31 d2                	xor    %edx,%edx
  802827:	f7 f5                	div    %ebp
  802829:	89 c8                	mov    %ecx,%eax
  80282b:	f7 f5                	div    %ebp
  80282d:	eb 9c                	jmp    8027cb <__umoddi3+0x3b>
  80282f:	90                   	nop
  802830:	89 c8                	mov    %ecx,%eax
  802832:	89 fa                	mov    %edi,%edx
  802834:	83 c4 14             	add    $0x14,%esp
  802837:	5e                   	pop    %esi
  802838:	5f                   	pop    %edi
  802839:	5d                   	pop    %ebp
  80283a:	c3                   	ret    
  80283b:	90                   	nop
  80283c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802840:	8b 04 24             	mov    (%esp),%eax
  802843:	be 20 00 00 00       	mov    $0x20,%esi
  802848:	89 e9                	mov    %ebp,%ecx
  80284a:	29 ee                	sub    %ebp,%esi
  80284c:	d3 e2                	shl    %cl,%edx
  80284e:	89 f1                	mov    %esi,%ecx
  802850:	d3 e8                	shr    %cl,%eax
  802852:	89 e9                	mov    %ebp,%ecx
  802854:	89 44 24 04          	mov    %eax,0x4(%esp)
  802858:	8b 04 24             	mov    (%esp),%eax
  80285b:	09 54 24 04          	or     %edx,0x4(%esp)
  80285f:	89 fa                	mov    %edi,%edx
  802861:	d3 e0                	shl    %cl,%eax
  802863:	89 f1                	mov    %esi,%ecx
  802865:	89 44 24 08          	mov    %eax,0x8(%esp)
  802869:	8b 44 24 10          	mov    0x10(%esp),%eax
  80286d:	d3 ea                	shr    %cl,%edx
  80286f:	89 e9                	mov    %ebp,%ecx
  802871:	d3 e7                	shl    %cl,%edi
  802873:	89 f1                	mov    %esi,%ecx
  802875:	d3 e8                	shr    %cl,%eax
  802877:	89 e9                	mov    %ebp,%ecx
  802879:	09 f8                	or     %edi,%eax
  80287b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80287f:	f7 74 24 04          	divl   0x4(%esp)
  802883:	d3 e7                	shl    %cl,%edi
  802885:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802889:	89 d7                	mov    %edx,%edi
  80288b:	f7 64 24 08          	mull   0x8(%esp)
  80288f:	39 d7                	cmp    %edx,%edi
  802891:	89 c1                	mov    %eax,%ecx
  802893:	89 14 24             	mov    %edx,(%esp)
  802896:	72 2c                	jb     8028c4 <__umoddi3+0x134>
  802898:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80289c:	72 22                	jb     8028c0 <__umoddi3+0x130>
  80289e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8028a2:	29 c8                	sub    %ecx,%eax
  8028a4:	19 d7                	sbb    %edx,%edi
  8028a6:	89 e9                	mov    %ebp,%ecx
  8028a8:	89 fa                	mov    %edi,%edx
  8028aa:	d3 e8                	shr    %cl,%eax
  8028ac:	89 f1                	mov    %esi,%ecx
  8028ae:	d3 e2                	shl    %cl,%edx
  8028b0:	89 e9                	mov    %ebp,%ecx
  8028b2:	d3 ef                	shr    %cl,%edi
  8028b4:	09 d0                	or     %edx,%eax
  8028b6:	89 fa                	mov    %edi,%edx
  8028b8:	83 c4 14             	add    $0x14,%esp
  8028bb:	5e                   	pop    %esi
  8028bc:	5f                   	pop    %edi
  8028bd:	5d                   	pop    %ebp
  8028be:	c3                   	ret    
  8028bf:	90                   	nop
  8028c0:	39 d7                	cmp    %edx,%edi
  8028c2:	75 da                	jne    80289e <__umoddi3+0x10e>
  8028c4:	8b 14 24             	mov    (%esp),%edx
  8028c7:	89 c1                	mov    %eax,%ecx
  8028c9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8028cd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8028d1:	eb cb                	jmp    80289e <__umoddi3+0x10e>
  8028d3:	90                   	nop
  8028d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028d8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8028dc:	0f 82 0f ff ff ff    	jb     8027f1 <__umoddi3+0x61>
  8028e2:	e9 1a ff ff ff       	jmp    802801 <__umoddi3+0x71>
