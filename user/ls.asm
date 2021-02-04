
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 fa 02 00 00       	call   80032b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
  800048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80004e:	83 3d d0 51 80 00 00 	cmpl   $0x0,0x8051d0
  800055:	74 23                	je     80007a <ls1+0x3a>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800057:	89 f0                	mov    %esi,%eax
  800059:	3c 01                	cmp    $0x1,%al
  80005b:	19 c0                	sbb    %eax,%eax
  80005d:	83 e0 c9             	and    $0xffffffc9,%eax
  800060:	83 c0 64             	add    $0x64,%eax
  800063:	89 44 24 08          	mov    %eax,0x8(%esp)
  800067:	8b 45 10             	mov    0x10(%ebp),%eax
  80006a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006e:	c7 04 24 22 2c 80 00 	movl   $0x802c22,(%esp)
  800075:	e8 6c 1d 00 00       	call   801de6 <printf>
	if(prefix) {
  80007a:	85 db                	test   %ebx,%ebx
  80007c:	74 38                	je     8000b6 <ls1+0x76>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80007e:	b8 88 2c 80 00       	mov    $0x802c88,%eax
	const char *sep;

	if(flag['l'])
		printf("%11d %c ", size, isdir ? 'd' : '-');
	if(prefix) {
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800083:	80 3b 00             	cmpb   $0x0,(%ebx)
  800086:	74 1a                	je     8000a2 <ls1+0x62>
  800088:	89 1c 24             	mov    %ebx,(%esp)
  80008b:	e8 f0 09 00 00       	call   800a80 <strlen>
  800090:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
			sep = "/";
  800095:	b8 20 2c 80 00       	mov    $0x802c20,%eax
  80009a:	ba 88 2c 80 00       	mov    $0x802c88,%edx
  80009f:	0f 44 c2             	cmove  %edx,%eax
		else
			sep = "";
		printf("%s%s", prefix, sep);
  8000a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000aa:	c7 04 24 2b 2c 80 00 	movl   $0x802c2b,(%esp)
  8000b1:	e8 30 1d 00 00       	call   801de6 <printf>
	}
	printf("%s", name);
  8000b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8000b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bd:	c7 04 24 01 31 80 00 	movl   $0x803101,(%esp)
  8000c4:	e8 1d 1d 00 00       	call   801de6 <printf>
	if(flag['F'] && isdir)
  8000c9:	83 3d 38 51 80 00 00 	cmpl   $0x0,0x805138
  8000d0:	74 12                	je     8000e4 <ls1+0xa4>
  8000d2:	89 f0                	mov    %esi,%eax
  8000d4:	84 c0                	test   %al,%al
  8000d6:	74 0c                	je     8000e4 <ls1+0xa4>
		printf("/");
  8000d8:	c7 04 24 20 2c 80 00 	movl   $0x802c20,(%esp)
  8000df:	e8 02 1d 00 00       	call   801de6 <printf>
	printf("\n");
  8000e4:	c7 04 24 87 2c 80 00 	movl   $0x802c87,(%esp)
  8000eb:	e8 f6 1c 00 00       	call   801de6 <printf>
}
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5d                   	pop    %ebp
  8000f6:	c3                   	ret    

008000f7 <lsdir>:
		ls1(0, st.st_isdir, st.st_size, path);
}

void
lsdir(const char *path, const char *prefix)
{
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	57                   	push   %edi
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  800103:	8b 7d 08             	mov    0x8(%ebp),%edi
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800106:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80010d:	00 
  80010e:	89 3c 24             	mov    %edi,(%esp)
  800111:	e8 20 1b 00 00       	call   801c36 <open>
  800116:	89 c3                	mov    %eax,%ebx
  800118:	85 c0                	test   %eax,%eax
  80011a:	78 08                	js     800124 <lsdir+0x2d>
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80011c:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800122:	eb 57                	jmp    80017b <lsdir+0x84>
{
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
  800124:	89 44 24 10          	mov    %eax,0x10(%esp)
  800128:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80012c:	c7 44 24 08 30 2c 80 	movl   $0x802c30,0x8(%esp)
  800133:	00 
  800134:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  80013b:	00 
  80013c:	c7 04 24 3c 2c 80 00 	movl   $0x802c3c,(%esp)
  800143:	e8 48 02 00 00       	call   800390 <_panic>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  800148:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  80014f:	74 2a                	je     80017b <lsdir+0x84>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  800151:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800155:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80015b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80015f:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800166:	0f 94 c0             	sete   %al
  800169:	0f b6 c0             	movzbl %al,%eax
  80016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800170:	8b 45 0c             	mov    0xc(%ebp),%eax
  800173:	89 04 24             	mov    %eax,(%esp)
  800176:	e8 c5 fe ff ff       	call   800040 <ls1>
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80017b:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  800182:	00 
  800183:	89 74 24 04          	mov    %esi,0x4(%esp)
  800187:	89 1c 24             	mov    %ebx,(%esp)
  80018a:	e8 6d 16 00 00       	call   8017fc <readn>
  80018f:	3d 00 01 00 00       	cmp    $0x100,%eax
  800194:	74 b2                	je     800148 <lsdir+0x51>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  800196:	85 c0                	test   %eax,%eax
  800198:	7e 20                	jle    8001ba <lsdir+0xc3>
		panic("short read in directory %s", path);
  80019a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80019e:	c7 44 24 08 46 2c 80 	movl   $0x802c46,0x8(%esp)
  8001a5:	00 
  8001a6:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001ad:	00 
  8001ae:	c7 04 24 3c 2c 80 00 	movl   $0x802c3c,(%esp)
  8001b5:	e8 d6 01 00 00       	call   800390 <_panic>
	if (n < 0)
  8001ba:	85 c0                	test   %eax,%eax
  8001bc:	79 24                	jns    8001e2 <lsdir+0xeb>
		panic("error reading directory %s: %e", path, n);
  8001be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001c2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001c6:	c7 44 24 08 8c 2c 80 	movl   $0x802c8c,0x8(%esp)
  8001cd:	00 
  8001ce:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8001d5:	00 
  8001d6:	c7 04 24 3c 2c 80 00 	movl   $0x802c3c,(%esp)
  8001dd:	e8 ae 01 00 00       	call   800390 <_panic>
}
  8001e2:	81 c4 2c 01 00 00    	add    $0x12c,%esp
  8001e8:	5b                   	pop    %ebx
  8001e9:	5e                   	pop    %esi
  8001ea:	5f                   	pop    %edi
  8001eb:	5d                   	pop    %ebp
  8001ec:	c3                   	ret    

008001ed <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	53                   	push   %ebx
  8001f1:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  8001f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  8001fa:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  800200:	89 44 24 04          	mov    %eax,0x4(%esp)
  800204:	89 1c 24             	mov    %ebx,(%esp)
  800207:	e8 f4 17 00 00       	call   801a00 <stat>
  80020c:	85 c0                	test   %eax,%eax
  80020e:	79 24                	jns    800234 <ls+0x47>
		panic("stat %s: %e", path, r);
  800210:	89 44 24 10          	mov    %eax,0x10(%esp)
  800214:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800218:	c7 44 24 08 61 2c 80 	movl   $0x802c61,0x8(%esp)
  80021f:	00 
  800220:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800227:	00 
  800228:	c7 04 24 3c 2c 80 00 	movl   $0x802c3c,(%esp)
  80022f:	e8 5c 01 00 00       	call   800390 <_panic>
	if (st.st_isdir && !flag['d'])
  800234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800237:	85 c0                	test   %eax,%eax
  800239:	74 1a                	je     800255 <ls+0x68>
  80023b:	83 3d b0 51 80 00 00 	cmpl   $0x0,0x8051b0
  800242:	75 11                	jne    800255 <ls+0x68>
		lsdir(path, prefix);
  800244:	8b 45 0c             	mov    0xc(%ebp),%eax
  800247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024b:	89 1c 24             	mov    %ebx,(%esp)
  80024e:	e8 a4 fe ff ff       	call   8000f7 <lsdir>
  800253:	eb 23                	jmp    800278 <ls+0x8b>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  800255:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800259:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80025c:	89 54 24 08          	mov    %edx,0x8(%esp)
  800260:	85 c0                	test   %eax,%eax
  800262:	0f 95 c0             	setne  %al
  800265:	0f b6 c0             	movzbl %al,%eax
  800268:	89 44 24 04          	mov    %eax,0x4(%esp)
  80026c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800273:	e8 c8 fd ff ff       	call   800040 <ls1>
}
  800278:	81 c4 b4 00 00 00    	add    $0xb4,%esp
  80027e:	5b                   	pop    %ebx
  80027f:	5d                   	pop    %ebp
  800280:	c3                   	ret    

00800281 <usage>:
	printf("\n");
}

void
usage(void)
{
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	83 ec 18             	sub    $0x18,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800287:	c7 04 24 6d 2c 80 00 	movl   $0x802c6d,(%esp)
  80028e:	e8 53 1b 00 00       	call   801de6 <printf>
	exit();
  800293:	e8 df 00 00 00       	call   800377 <exit>
}
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <umain>:

void
umain(int argc, char **argv)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	56                   	push   %esi
  80029e:	53                   	push   %ebx
  80029f:	83 ec 20             	sub    $0x20,%esp
  8002a2:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  8002a5:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002b0:	8d 45 08             	lea    0x8(%ebp),%eax
  8002b3:	89 04 24             	mov    %eax,(%esp)
  8002b6:	e8 3d 10 00 00       	call   8012f8 <argstart>
	while ((i = argnext(&args)) >= 0)
  8002bb:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  8002be:	eb 1e                	jmp    8002de <umain+0x44>
		switch (i) {
  8002c0:	83 f8 64             	cmp    $0x64,%eax
  8002c3:	74 0a                	je     8002cf <umain+0x35>
  8002c5:	83 f8 6c             	cmp    $0x6c,%eax
  8002c8:	74 05                	je     8002cf <umain+0x35>
  8002ca:	83 f8 46             	cmp    $0x46,%eax
  8002cd:	75 0a                	jne    8002d9 <umain+0x3f>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  8002cf:	83 04 85 20 50 80 00 	addl   $0x1,0x805020(,%eax,4)
  8002d6:	01 
			break;
  8002d7:	eb 05                	jmp    8002de <umain+0x44>
		default:
			usage();
  8002d9:	e8 a3 ff ff ff       	call   800281 <usage>
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8002de:	89 1c 24             	mov    %ebx,(%esp)
  8002e1:	e8 4a 10 00 00       	call   801330 <argnext>
  8002e6:	85 c0                	test   %eax,%eax
  8002e8:	79 d6                	jns    8002c0 <umain+0x26>
			break;
		default:
			usage();
		}

	if (argc == 1)
  8002ea:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8002ee:	74 07                	je     8002f7 <umain+0x5d>
  8002f0:	bb 01 00 00 00       	mov    $0x1,%ebx
  8002f5:	eb 28                	jmp    80031f <umain+0x85>
		ls("/", "");
  8002f7:	c7 44 24 04 88 2c 80 	movl   $0x802c88,0x4(%esp)
  8002fe:	00 
  8002ff:	c7 04 24 20 2c 80 00 	movl   $0x802c20,(%esp)
  800306:	e8 e2 fe ff ff       	call   8001ed <ls>
  80030b:	eb 17                	jmp    800324 <umain+0x8a>
	else {
		for (i = 1; i < argc; i++)
			ls(argv[i], argv[i]);
  80030d:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800310:	89 44 24 04          	mov    %eax,0x4(%esp)
  800314:	89 04 24             	mov    %eax,(%esp)
  800317:	e8 d1 fe ff ff       	call   8001ed <ls>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  80031c:	83 c3 01             	add    $0x1,%ebx
  80031f:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800322:	7c e9                	jl     80030d <umain+0x73>
			ls(argv[i], argv[i]);
	}
}
  800324:	83 c4 20             	add    $0x20,%esp
  800327:	5b                   	pop    %ebx
  800328:	5e                   	pop    %esi
  800329:	5d                   	pop    %ebp
  80032a:	c3                   	ret    

0080032b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	56                   	push   %esi
  80032f:	53                   	push   %ebx
  800330:	83 ec 10             	sub    $0x10,%esp
  800333:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800336:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800339:	e8 57 0b 00 00       	call   800e95 <sys_getenvid>
  80033e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800343:	89 c2                	mov    %eax,%edx
  800345:	c1 e2 07             	shl    $0x7,%edx
  800348:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  80034f:	a3 20 54 80 00       	mov    %eax,0x805420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800354:	85 db                	test   %ebx,%ebx
  800356:	7e 07                	jle    80035f <libmain+0x34>
		binaryname = argv[0];
  800358:	8b 06                	mov    (%esi),%eax
  80035a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80035f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800363:	89 1c 24             	mov    %ebx,(%esp)
  800366:	e8 2f ff ff ff       	call   80029a <umain>

	// exit gracefully
	exit();
  80036b:	e8 07 00 00 00       	call   800377 <exit>
}
  800370:	83 c4 10             	add    $0x10,%esp
  800373:	5b                   	pop    %ebx
  800374:	5e                   	pop    %esi
  800375:	5d                   	pop    %ebp
  800376:	c3                   	ret    

00800377 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800377:	55                   	push   %ebp
  800378:	89 e5                	mov    %esp,%ebp
  80037a:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80037d:	e8 b8 12 00 00       	call   80163a <close_all>
	sys_env_destroy(0);
  800382:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800389:	e8 b5 0a 00 00       	call   800e43 <sys_env_destroy>
}
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	56                   	push   %esi
  800394:	53                   	push   %ebx
  800395:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800398:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80039b:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8003a1:	e8 ef 0a 00 00       	call   800e95 <sys_getenvid>
  8003a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003b4:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003bc:	c7 04 24 b8 2c 80 00 	movl   $0x802cb8,(%esp)
  8003c3:	e8 c1 00 00 00       	call   800489 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003cf:	89 04 24             	mov    %eax,(%esp)
  8003d2:	e8 51 00 00 00       	call   800428 <vcprintf>
	cprintf("\n");
  8003d7:	c7 04 24 87 2c 80 00 	movl   $0x802c87,(%esp)
  8003de:	e8 a6 00 00 00       	call   800489 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003e3:	cc                   	int3   
  8003e4:	eb fd                	jmp    8003e3 <_panic+0x53>

008003e6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	53                   	push   %ebx
  8003ea:	83 ec 14             	sub    $0x14,%esp
  8003ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003f0:	8b 13                	mov    (%ebx),%edx
  8003f2:	8d 42 01             	lea    0x1(%edx),%eax
  8003f5:	89 03                	mov    %eax,(%ebx)
  8003f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003fa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003fe:	3d ff 00 00 00       	cmp    $0xff,%eax
  800403:	75 19                	jne    80041e <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800405:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80040c:	00 
  80040d:	8d 43 08             	lea    0x8(%ebx),%eax
  800410:	89 04 24             	mov    %eax,(%esp)
  800413:	e8 ee 09 00 00       	call   800e06 <sys_cputs>
		b->idx = 0;
  800418:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80041e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800422:	83 c4 14             	add    $0x14,%esp
  800425:	5b                   	pop    %ebx
  800426:	5d                   	pop    %ebp
  800427:	c3                   	ret    

00800428 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800428:	55                   	push   %ebp
  800429:	89 e5                	mov    %esp,%ebp
  80042b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800431:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800438:	00 00 00 
	b.cnt = 0;
  80043b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800442:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800445:	8b 45 0c             	mov    0xc(%ebp),%eax
  800448:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800453:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800459:	89 44 24 04          	mov    %eax,0x4(%esp)
  80045d:	c7 04 24 e6 03 80 00 	movl   $0x8003e6,(%esp)
  800464:	e8 b5 01 00 00       	call   80061e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800469:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80046f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800473:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800479:	89 04 24             	mov    %eax,(%esp)
  80047c:	e8 85 09 00 00       	call   800e06 <sys_cputs>

	return b.cnt;
}
  800481:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800487:	c9                   	leave  
  800488:	c3                   	ret    

00800489 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800489:	55                   	push   %ebp
  80048a:	89 e5                	mov    %esp,%ebp
  80048c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80048f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800492:	89 44 24 04          	mov    %eax,0x4(%esp)
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	89 04 24             	mov    %eax,(%esp)
  80049c:	e8 87 ff ff ff       	call   800428 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    
  8004a3:	66 90                	xchg   %ax,%ax
  8004a5:	66 90                	xchg   %ax,%ax
  8004a7:	66 90                	xchg   %ax,%ax
  8004a9:	66 90                	xchg   %ax,%ax
  8004ab:	66 90                	xchg   %ax,%ax
  8004ad:	66 90                	xchg   %ax,%ax
  8004af:	90                   	nop

008004b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	57                   	push   %edi
  8004b4:	56                   	push   %esi
  8004b5:	53                   	push   %ebx
  8004b6:	83 ec 3c             	sub    $0x3c,%esp
  8004b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004bc:	89 d7                	mov    %edx,%edi
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c7:	89 c3                	mov    %eax,%ebx
  8004c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004da:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004dd:	39 d9                	cmp    %ebx,%ecx
  8004df:	72 05                	jb     8004e6 <printnum+0x36>
  8004e1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004e4:	77 69                	ja     80054f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004e9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004ed:	83 ee 01             	sub    $0x1,%esi
  8004f0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8004fc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800500:	89 c3                	mov    %eax,%ebx
  800502:	89 d6                	mov    %edx,%esi
  800504:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800507:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80050a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80050e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800512:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800515:	89 04 24             	mov    %eax,(%esp)
  800518:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80051b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051f:	e8 6c 24 00 00       	call   802990 <__udivdi3>
  800524:	89 d9                	mov    %ebx,%ecx
  800526:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80052a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80052e:	89 04 24             	mov    %eax,(%esp)
  800531:	89 54 24 04          	mov    %edx,0x4(%esp)
  800535:	89 fa                	mov    %edi,%edx
  800537:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80053a:	e8 71 ff ff ff       	call   8004b0 <printnum>
  80053f:	eb 1b                	jmp    80055c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800541:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800545:	8b 45 18             	mov    0x18(%ebp),%eax
  800548:	89 04 24             	mov    %eax,(%esp)
  80054b:	ff d3                	call   *%ebx
  80054d:	eb 03                	jmp    800552 <printnum+0xa2>
  80054f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800552:	83 ee 01             	sub    $0x1,%esi
  800555:	85 f6                	test   %esi,%esi
  800557:	7f e8                	jg     800541 <printnum+0x91>
  800559:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80055c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800560:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800564:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800567:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80056a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80056e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800572:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800575:	89 04 24             	mov    %eax,(%esp)
  800578:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80057b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80057f:	e8 3c 25 00 00       	call   802ac0 <__umoddi3>
  800584:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800588:	0f be 80 db 2c 80 00 	movsbl 0x802cdb(%eax),%eax
  80058f:	89 04 24             	mov    %eax,(%esp)
  800592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800595:	ff d0                	call   *%eax
}
  800597:	83 c4 3c             	add    $0x3c,%esp
  80059a:	5b                   	pop    %ebx
  80059b:	5e                   	pop    %esi
  80059c:	5f                   	pop    %edi
  80059d:	5d                   	pop    %ebp
  80059e:	c3                   	ret    

0080059f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80059f:	55                   	push   %ebp
  8005a0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005a2:	83 fa 01             	cmp    $0x1,%edx
  8005a5:	7e 0e                	jle    8005b5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8005a7:	8b 10                	mov    (%eax),%edx
  8005a9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005ac:	89 08                	mov    %ecx,(%eax)
  8005ae:	8b 02                	mov    (%edx),%eax
  8005b0:	8b 52 04             	mov    0x4(%edx),%edx
  8005b3:	eb 22                	jmp    8005d7 <getuint+0x38>
	else if (lflag)
  8005b5:	85 d2                	test   %edx,%edx
  8005b7:	74 10                	je     8005c9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005b9:	8b 10                	mov    (%eax),%edx
  8005bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005be:	89 08                	mov    %ecx,(%eax)
  8005c0:	8b 02                	mov    (%edx),%eax
  8005c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c7:	eb 0e                	jmp    8005d7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005ce:	89 08                	mov    %ecx,(%eax)
  8005d0:	8b 02                	mov    (%edx),%eax
  8005d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d7:	5d                   	pop    %ebp
  8005d8:	c3                   	ret    

008005d9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005df:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005e3:	8b 10                	mov    (%eax),%edx
  8005e5:	3b 50 04             	cmp    0x4(%eax),%edx
  8005e8:	73 0a                	jae    8005f4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005ed:	89 08                	mov    %ecx,(%eax)
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	88 02                	mov    %al,(%edx)
}
  8005f4:	5d                   	pop    %ebp
  8005f5:	c3                   	ret    

008005f6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8005fc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800603:	8b 45 10             	mov    0x10(%ebp),%eax
  800606:	89 44 24 08          	mov    %eax,0x8(%esp)
  80060a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	89 04 24             	mov    %eax,(%esp)
  800617:	e8 02 00 00 00       	call   80061e <vprintfmt>
	va_end(ap);
}
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    

0080061e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80061e:	55                   	push   %ebp
  80061f:	89 e5                	mov    %esp,%ebp
  800621:	57                   	push   %edi
  800622:	56                   	push   %esi
  800623:	53                   	push   %ebx
  800624:	83 ec 3c             	sub    $0x3c,%esp
  800627:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80062a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80062d:	eb 14                	jmp    800643 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80062f:	85 c0                	test   %eax,%eax
  800631:	0f 84 b3 03 00 00    	je     8009ea <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800637:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80063b:	89 04 24             	mov    %eax,(%esp)
  80063e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800641:	89 f3                	mov    %esi,%ebx
  800643:	8d 73 01             	lea    0x1(%ebx),%esi
  800646:	0f b6 03             	movzbl (%ebx),%eax
  800649:	83 f8 25             	cmp    $0x25,%eax
  80064c:	75 e1                	jne    80062f <vprintfmt+0x11>
  80064e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800652:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800659:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800660:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800667:	ba 00 00 00 00       	mov    $0x0,%edx
  80066c:	eb 1d                	jmp    80068b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800670:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800674:	eb 15                	jmp    80068b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800676:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800678:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80067c:	eb 0d                	jmp    80068b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80067e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800681:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800684:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80068e:	0f b6 0e             	movzbl (%esi),%ecx
  800691:	0f b6 c1             	movzbl %cl,%eax
  800694:	83 e9 23             	sub    $0x23,%ecx
  800697:	80 f9 55             	cmp    $0x55,%cl
  80069a:	0f 87 2a 03 00 00    	ja     8009ca <vprintfmt+0x3ac>
  8006a0:	0f b6 c9             	movzbl %cl,%ecx
  8006a3:	ff 24 8d 60 2e 80 00 	jmp    *0x802e60(,%ecx,4)
  8006aa:	89 de                	mov    %ebx,%esi
  8006ac:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8006b1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8006b4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8006b8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8006bb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8006be:	83 fb 09             	cmp    $0x9,%ebx
  8006c1:	77 36                	ja     8006f9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006c3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006c6:	eb e9                	jmp    8006b1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8d 48 04             	lea    0x4(%eax),%ecx
  8006ce:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8006d8:	eb 22                	jmp    8006fc <vprintfmt+0xde>
  8006da:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006dd:	85 c9                	test   %ecx,%ecx
  8006df:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e4:	0f 49 c1             	cmovns %ecx,%eax
  8006e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ea:	89 de                	mov    %ebx,%esi
  8006ec:	eb 9d                	jmp    80068b <vprintfmt+0x6d>
  8006ee:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8006f0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8006f7:	eb 92                	jmp    80068b <vprintfmt+0x6d>
  8006f9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8006fc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800700:	79 89                	jns    80068b <vprintfmt+0x6d>
  800702:	e9 77 ff ff ff       	jmp    80067e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800707:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80070a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80070c:	e9 7a ff ff ff       	jmp    80068b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8d 50 04             	lea    0x4(%eax),%edx
  800717:	89 55 14             	mov    %edx,0x14(%ebp)
  80071a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	89 04 24             	mov    %eax,(%esp)
  800723:	ff 55 08             	call   *0x8(%ebp)
			break;
  800726:	e9 18 ff ff ff       	jmp    800643 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	8d 50 04             	lea    0x4(%eax),%edx
  800731:	89 55 14             	mov    %edx,0x14(%ebp)
  800734:	8b 00                	mov    (%eax),%eax
  800736:	99                   	cltd   
  800737:	31 d0                	xor    %edx,%eax
  800739:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80073b:	83 f8 12             	cmp    $0x12,%eax
  80073e:	7f 0b                	jg     80074b <vprintfmt+0x12d>
  800740:	8b 14 85 c0 2f 80 00 	mov    0x802fc0(,%eax,4),%edx
  800747:	85 d2                	test   %edx,%edx
  800749:	75 20                	jne    80076b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80074b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80074f:	c7 44 24 08 f3 2c 80 	movl   $0x802cf3,0x8(%esp)
  800756:	00 
  800757:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	89 04 24             	mov    %eax,(%esp)
  800761:	e8 90 fe ff ff       	call   8005f6 <printfmt>
  800766:	e9 d8 fe ff ff       	jmp    800643 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80076b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80076f:	c7 44 24 08 01 31 80 	movl   $0x803101,0x8(%esp)
  800776:	00 
  800777:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	89 04 24             	mov    %eax,(%esp)
  800781:	e8 70 fe ff ff       	call   8005f6 <printfmt>
  800786:	e9 b8 fe ff ff       	jmp    800643 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80078b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80078e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800791:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 50 04             	lea    0x4(%eax),%edx
  80079a:	89 55 14             	mov    %edx,0x14(%ebp)
  80079d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80079f:	85 f6                	test   %esi,%esi
  8007a1:	b8 ec 2c 80 00       	mov    $0x802cec,%eax
  8007a6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8007a9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8007ad:	0f 84 97 00 00 00    	je     80084a <vprintfmt+0x22c>
  8007b3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007b7:	0f 8e 9b 00 00 00    	jle    800858 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007bd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007c1:	89 34 24             	mov    %esi,(%esp)
  8007c4:	e8 cf 02 00 00       	call   800a98 <strnlen>
  8007c9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007cc:	29 c2                	sub    %eax,%edx
  8007ce:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8007d1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8007d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007d8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007db:	8b 75 08             	mov    0x8(%ebp),%esi
  8007de:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007e1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e3:	eb 0f                	jmp    8007f4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8007e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007ec:	89 04 24             	mov    %eax,(%esp)
  8007ef:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007f1:	83 eb 01             	sub    $0x1,%ebx
  8007f4:	85 db                	test   %ebx,%ebx
  8007f6:	7f ed                	jg     8007e5 <vprintfmt+0x1c7>
  8007f8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8007fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007fe:	85 d2                	test   %edx,%edx
  800800:	b8 00 00 00 00       	mov    $0x0,%eax
  800805:	0f 49 c2             	cmovns %edx,%eax
  800808:	29 c2                	sub    %eax,%edx
  80080a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80080d:	89 d7                	mov    %edx,%edi
  80080f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800812:	eb 50                	jmp    800864 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800814:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800818:	74 1e                	je     800838 <vprintfmt+0x21a>
  80081a:	0f be d2             	movsbl %dl,%edx
  80081d:	83 ea 20             	sub    $0x20,%edx
  800820:	83 fa 5e             	cmp    $0x5e,%edx
  800823:	76 13                	jbe    800838 <vprintfmt+0x21a>
					putch('?', putdat);
  800825:	8b 45 0c             	mov    0xc(%ebp),%eax
  800828:	89 44 24 04          	mov    %eax,0x4(%esp)
  80082c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800833:	ff 55 08             	call   *0x8(%ebp)
  800836:	eb 0d                	jmp    800845 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800838:	8b 55 0c             	mov    0xc(%ebp),%edx
  80083b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80083f:	89 04 24             	mov    %eax,(%esp)
  800842:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800845:	83 ef 01             	sub    $0x1,%edi
  800848:	eb 1a                	jmp    800864 <vprintfmt+0x246>
  80084a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80084d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800850:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800853:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800856:	eb 0c                	jmp    800864 <vprintfmt+0x246>
  800858:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80085b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80085e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800861:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800864:	83 c6 01             	add    $0x1,%esi
  800867:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80086b:	0f be c2             	movsbl %dl,%eax
  80086e:	85 c0                	test   %eax,%eax
  800870:	74 27                	je     800899 <vprintfmt+0x27b>
  800872:	85 db                	test   %ebx,%ebx
  800874:	78 9e                	js     800814 <vprintfmt+0x1f6>
  800876:	83 eb 01             	sub    $0x1,%ebx
  800879:	79 99                	jns    800814 <vprintfmt+0x1f6>
  80087b:	89 f8                	mov    %edi,%eax
  80087d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800880:	8b 75 08             	mov    0x8(%ebp),%esi
  800883:	89 c3                	mov    %eax,%ebx
  800885:	eb 1a                	jmp    8008a1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800887:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80088b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800892:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800894:	83 eb 01             	sub    $0x1,%ebx
  800897:	eb 08                	jmp    8008a1 <vprintfmt+0x283>
  800899:	89 fb                	mov    %edi,%ebx
  80089b:	8b 75 08             	mov    0x8(%ebp),%esi
  80089e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8008a1:	85 db                	test   %ebx,%ebx
  8008a3:	7f e2                	jg     800887 <vprintfmt+0x269>
  8008a5:	89 75 08             	mov    %esi,0x8(%ebp)
  8008a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008ab:	e9 93 fd ff ff       	jmp    800643 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008b0:	83 fa 01             	cmp    $0x1,%edx
  8008b3:	7e 16                	jle    8008cb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8d 50 08             	lea    0x8(%eax),%edx
  8008bb:	89 55 14             	mov    %edx,0x14(%ebp)
  8008be:	8b 50 04             	mov    0x4(%eax),%edx
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008c9:	eb 32                	jmp    8008fd <vprintfmt+0x2df>
	else if (lflag)
  8008cb:	85 d2                	test   %edx,%edx
  8008cd:	74 18                	je     8008e7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8d 50 04             	lea    0x4(%eax),%edx
  8008d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8008d8:	8b 30                	mov    (%eax),%esi
  8008da:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008dd:	89 f0                	mov    %esi,%eax
  8008df:	c1 f8 1f             	sar    $0x1f,%eax
  8008e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008e5:	eb 16                	jmp    8008fd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8008f0:	8b 30                	mov    (%eax),%esi
  8008f2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008f5:	89 f0                	mov    %esi,%eax
  8008f7:	c1 f8 1f             	sar    $0x1f,%eax
  8008fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800900:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800903:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800908:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80090c:	0f 89 80 00 00 00    	jns    800992 <vprintfmt+0x374>
				putch('-', putdat);
  800912:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800916:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80091d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800920:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800923:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800926:	f7 d8                	neg    %eax
  800928:	83 d2 00             	adc    $0x0,%edx
  80092b:	f7 da                	neg    %edx
			}
			base = 10;
  80092d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800932:	eb 5e                	jmp    800992 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800934:	8d 45 14             	lea    0x14(%ebp),%eax
  800937:	e8 63 fc ff ff       	call   80059f <getuint>
			base = 10;
  80093c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800941:	eb 4f                	jmp    800992 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800943:	8d 45 14             	lea    0x14(%ebp),%eax
  800946:	e8 54 fc ff ff       	call   80059f <getuint>
			base = 8;
  80094b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800950:	eb 40                	jmp    800992 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800952:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800956:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80095d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800960:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800964:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80096b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80096e:	8b 45 14             	mov    0x14(%ebp),%eax
  800971:	8d 50 04             	lea    0x4(%eax),%edx
  800974:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800977:	8b 00                	mov    (%eax),%eax
  800979:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80097e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800983:	eb 0d                	jmp    800992 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800985:	8d 45 14             	lea    0x14(%ebp),%eax
  800988:	e8 12 fc ff ff       	call   80059f <getuint>
			base = 16;
  80098d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800992:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800996:	89 74 24 10          	mov    %esi,0x10(%esp)
  80099a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80099d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8009a1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8009a5:	89 04 24             	mov    %eax,(%esp)
  8009a8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009ac:	89 fa                	mov    %edi,%edx
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	e8 fa fa ff ff       	call   8004b0 <printnum>
			break;
  8009b6:	e9 88 fc ff ff       	jmp    800643 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009bb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009bf:	89 04 24             	mov    %eax,(%esp)
  8009c2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009c5:	e9 79 fc ff ff       	jmp    800643 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ce:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009d5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009d8:	89 f3                	mov    %esi,%ebx
  8009da:	eb 03                	jmp    8009df <vprintfmt+0x3c1>
  8009dc:	83 eb 01             	sub    $0x1,%ebx
  8009df:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8009e3:	75 f7                	jne    8009dc <vprintfmt+0x3be>
  8009e5:	e9 59 fc ff ff       	jmp    800643 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8009ea:	83 c4 3c             	add    $0x3c,%esp
  8009ed:	5b                   	pop    %ebx
  8009ee:	5e                   	pop    %esi
  8009ef:	5f                   	pop    %edi
  8009f0:	5d                   	pop    %ebp
  8009f1:	c3                   	ret    

008009f2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	83 ec 28             	sub    $0x28,%esp
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a01:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a05:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a0f:	85 c0                	test   %eax,%eax
  800a11:	74 30                	je     800a43 <vsnprintf+0x51>
  800a13:	85 d2                	test   %edx,%edx
  800a15:	7e 2c                	jle    800a43 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a25:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a2c:	c7 04 24 d9 05 80 00 	movl   $0x8005d9,(%esp)
  800a33:	e8 e6 fb ff ff       	call   80061e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a3b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a41:	eb 05                	jmp    800a48 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a48:	c9                   	leave  
  800a49:	c3                   	ret    

00800a4a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a50:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a57:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	89 04 24             	mov    %eax,(%esp)
  800a6b:	e8 82 ff ff ff       	call   8009f2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    
  800a72:	66 90                	xchg   %ax,%ax
  800a74:	66 90                	xchg   %ax,%ax
  800a76:	66 90                	xchg   %ax,%ax
  800a78:	66 90                	xchg   %ax,%ax
  800a7a:	66 90                	xchg   %ax,%ax
  800a7c:	66 90                	xchg   %ax,%ax
  800a7e:	66 90                	xchg   %ax,%ax

00800a80 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a86:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8b:	eb 03                	jmp    800a90 <strlen+0x10>
		n++;
  800a8d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a90:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a94:	75 f7                	jne    800a8d <strlen+0xd>
		n++;
	return n;
}
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa6:	eb 03                	jmp    800aab <strnlen+0x13>
		n++;
  800aa8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aab:	39 d0                	cmp    %edx,%eax
  800aad:	74 06                	je     800ab5 <strnlen+0x1d>
  800aaf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ab3:	75 f3                	jne    800aa8 <strnlen+0x10>
		n++;
	return n;
}
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	53                   	push   %ebx
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ac1:	89 c2                	mov    %eax,%edx
  800ac3:	83 c2 01             	add    $0x1,%edx
  800ac6:	83 c1 01             	add    $0x1,%ecx
  800ac9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800acd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ad0:	84 db                	test   %bl,%bl
  800ad2:	75 ef                	jne    800ac3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ad4:	5b                   	pop    %ebx
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	53                   	push   %ebx
  800adb:	83 ec 08             	sub    $0x8,%esp
  800ade:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ae1:	89 1c 24             	mov    %ebx,(%esp)
  800ae4:	e8 97 ff ff ff       	call   800a80 <strlen>
	strcpy(dst + len, src);
  800ae9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aec:	89 54 24 04          	mov    %edx,0x4(%esp)
  800af0:	01 d8                	add    %ebx,%eax
  800af2:	89 04 24             	mov    %eax,(%esp)
  800af5:	e8 bd ff ff ff       	call   800ab7 <strcpy>
	return dst;
}
  800afa:	89 d8                	mov    %ebx,%eax
  800afc:	83 c4 08             	add    $0x8,%esp
  800aff:	5b                   	pop    %ebx
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	56                   	push   %esi
  800b06:	53                   	push   %ebx
  800b07:	8b 75 08             	mov    0x8(%ebp),%esi
  800b0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b0d:	89 f3                	mov    %esi,%ebx
  800b0f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b12:	89 f2                	mov    %esi,%edx
  800b14:	eb 0f                	jmp    800b25 <strncpy+0x23>
		*dst++ = *src;
  800b16:	83 c2 01             	add    $0x1,%edx
  800b19:	0f b6 01             	movzbl (%ecx),%eax
  800b1c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b1f:	80 39 01             	cmpb   $0x1,(%ecx)
  800b22:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b25:	39 da                	cmp    %ebx,%edx
  800b27:	75 ed                	jne    800b16 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b29:	89 f0                	mov    %esi,%eax
  800b2b:	5b                   	pop    %ebx
  800b2c:	5e                   	pop    %esi
  800b2d:	5d                   	pop    %ebp
  800b2e:	c3                   	ret    

00800b2f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	56                   	push   %esi
  800b33:	53                   	push   %ebx
  800b34:	8b 75 08             	mov    0x8(%ebp),%esi
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b3d:	89 f0                	mov    %esi,%eax
  800b3f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b43:	85 c9                	test   %ecx,%ecx
  800b45:	75 0b                	jne    800b52 <strlcpy+0x23>
  800b47:	eb 1d                	jmp    800b66 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b49:	83 c0 01             	add    $0x1,%eax
  800b4c:	83 c2 01             	add    $0x1,%edx
  800b4f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b52:	39 d8                	cmp    %ebx,%eax
  800b54:	74 0b                	je     800b61 <strlcpy+0x32>
  800b56:	0f b6 0a             	movzbl (%edx),%ecx
  800b59:	84 c9                	test   %cl,%cl
  800b5b:	75 ec                	jne    800b49 <strlcpy+0x1a>
  800b5d:	89 c2                	mov    %eax,%edx
  800b5f:	eb 02                	jmp    800b63 <strlcpy+0x34>
  800b61:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800b63:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800b66:	29 f0                	sub    %esi,%eax
}
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b72:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b75:	eb 06                	jmp    800b7d <strcmp+0x11>
		p++, q++;
  800b77:	83 c1 01             	add    $0x1,%ecx
  800b7a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b7d:	0f b6 01             	movzbl (%ecx),%eax
  800b80:	84 c0                	test   %al,%al
  800b82:	74 04                	je     800b88 <strcmp+0x1c>
  800b84:	3a 02                	cmp    (%edx),%al
  800b86:	74 ef                	je     800b77 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b88:	0f b6 c0             	movzbl %al,%eax
  800b8b:	0f b6 12             	movzbl (%edx),%edx
  800b8e:	29 d0                	sub    %edx,%eax
}
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	53                   	push   %ebx
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9c:	89 c3                	mov    %eax,%ebx
  800b9e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ba1:	eb 06                	jmp    800ba9 <strncmp+0x17>
		n--, p++, q++;
  800ba3:	83 c0 01             	add    $0x1,%eax
  800ba6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ba9:	39 d8                	cmp    %ebx,%eax
  800bab:	74 15                	je     800bc2 <strncmp+0x30>
  800bad:	0f b6 08             	movzbl (%eax),%ecx
  800bb0:	84 c9                	test   %cl,%cl
  800bb2:	74 04                	je     800bb8 <strncmp+0x26>
  800bb4:	3a 0a                	cmp    (%edx),%cl
  800bb6:	74 eb                	je     800ba3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bb8:	0f b6 00             	movzbl (%eax),%eax
  800bbb:	0f b6 12             	movzbl (%edx),%edx
  800bbe:	29 d0                	sub    %edx,%eax
  800bc0:	eb 05                	jmp    800bc7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800bc2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bd4:	eb 07                	jmp    800bdd <strchr+0x13>
		if (*s == c)
  800bd6:	38 ca                	cmp    %cl,%dl
  800bd8:	74 0f                	je     800be9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bda:	83 c0 01             	add    $0x1,%eax
  800bdd:	0f b6 10             	movzbl (%eax),%edx
  800be0:	84 d2                	test   %dl,%dl
  800be2:	75 f2                	jne    800bd6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800be4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bf5:	eb 07                	jmp    800bfe <strfind+0x13>
		if (*s == c)
  800bf7:	38 ca                	cmp    %cl,%dl
  800bf9:	74 0a                	je     800c05 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bfb:	83 c0 01             	add    $0x1,%eax
  800bfe:	0f b6 10             	movzbl (%eax),%edx
  800c01:	84 d2                	test   %dl,%dl
  800c03:	75 f2                	jne    800bf7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
  800c0d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c10:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c13:	85 c9                	test   %ecx,%ecx
  800c15:	74 36                	je     800c4d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c17:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c1d:	75 28                	jne    800c47 <memset+0x40>
  800c1f:	f6 c1 03             	test   $0x3,%cl
  800c22:	75 23                	jne    800c47 <memset+0x40>
		c &= 0xFF;
  800c24:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c28:	89 d3                	mov    %edx,%ebx
  800c2a:	c1 e3 08             	shl    $0x8,%ebx
  800c2d:	89 d6                	mov    %edx,%esi
  800c2f:	c1 e6 18             	shl    $0x18,%esi
  800c32:	89 d0                	mov    %edx,%eax
  800c34:	c1 e0 10             	shl    $0x10,%eax
  800c37:	09 f0                	or     %esi,%eax
  800c39:	09 c2                	or     %eax,%edx
  800c3b:	89 d0                	mov    %edx,%eax
  800c3d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c3f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c42:	fc                   	cld    
  800c43:	f3 ab                	rep stos %eax,%es:(%edi)
  800c45:	eb 06                	jmp    800c4d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4a:	fc                   	cld    
  800c4b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c4d:	89 f8                	mov    %edi,%eax
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c62:	39 c6                	cmp    %eax,%esi
  800c64:	73 35                	jae    800c9b <memmove+0x47>
  800c66:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c69:	39 d0                	cmp    %edx,%eax
  800c6b:	73 2e                	jae    800c9b <memmove+0x47>
		s += n;
		d += n;
  800c6d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c70:	89 d6                	mov    %edx,%esi
  800c72:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c74:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c7a:	75 13                	jne    800c8f <memmove+0x3b>
  800c7c:	f6 c1 03             	test   $0x3,%cl
  800c7f:	75 0e                	jne    800c8f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c81:	83 ef 04             	sub    $0x4,%edi
  800c84:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c87:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c8a:	fd                   	std    
  800c8b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c8d:	eb 09                	jmp    800c98 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c8f:	83 ef 01             	sub    $0x1,%edi
  800c92:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c95:	fd                   	std    
  800c96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c98:	fc                   	cld    
  800c99:	eb 1d                	jmp    800cb8 <memmove+0x64>
  800c9b:	89 f2                	mov    %esi,%edx
  800c9d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c9f:	f6 c2 03             	test   $0x3,%dl
  800ca2:	75 0f                	jne    800cb3 <memmove+0x5f>
  800ca4:	f6 c1 03             	test   $0x3,%cl
  800ca7:	75 0a                	jne    800cb3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ca9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800cac:	89 c7                	mov    %eax,%edi
  800cae:	fc                   	cld    
  800caf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cb1:	eb 05                	jmp    800cb8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800cb3:	89 c7                	mov    %eax,%edi
  800cb5:	fc                   	cld    
  800cb6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 04 24             	mov    %eax,(%esp)
  800cd6:	e8 79 ff ff ff       	call   800c54 <memmove>
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	56                   	push   %esi
  800ce1:	53                   	push   %ebx
  800ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce8:	89 d6                	mov    %edx,%esi
  800cea:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ced:	eb 1a                	jmp    800d09 <memcmp+0x2c>
		if (*s1 != *s2)
  800cef:	0f b6 02             	movzbl (%edx),%eax
  800cf2:	0f b6 19             	movzbl (%ecx),%ebx
  800cf5:	38 d8                	cmp    %bl,%al
  800cf7:	74 0a                	je     800d03 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800cf9:	0f b6 c0             	movzbl %al,%eax
  800cfc:	0f b6 db             	movzbl %bl,%ebx
  800cff:	29 d8                	sub    %ebx,%eax
  800d01:	eb 0f                	jmp    800d12 <memcmp+0x35>
		s1++, s2++;
  800d03:	83 c2 01             	add    $0x1,%edx
  800d06:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d09:	39 f2                	cmp    %esi,%edx
  800d0b:	75 e2                	jne    800cef <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    

00800d16 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d1f:	89 c2                	mov    %eax,%edx
  800d21:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d24:	eb 07                	jmp    800d2d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d26:	38 08                	cmp    %cl,(%eax)
  800d28:	74 07                	je     800d31 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d2a:	83 c0 01             	add    $0x1,%eax
  800d2d:	39 d0                	cmp    %edx,%eax
  800d2f:	72 f5                	jb     800d26 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d3f:	eb 03                	jmp    800d44 <strtol+0x11>
		s++;
  800d41:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d44:	0f b6 0a             	movzbl (%edx),%ecx
  800d47:	80 f9 09             	cmp    $0x9,%cl
  800d4a:	74 f5                	je     800d41 <strtol+0xe>
  800d4c:	80 f9 20             	cmp    $0x20,%cl
  800d4f:	74 f0                	je     800d41 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d51:	80 f9 2b             	cmp    $0x2b,%cl
  800d54:	75 0a                	jne    800d60 <strtol+0x2d>
		s++;
  800d56:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d59:	bf 00 00 00 00       	mov    $0x0,%edi
  800d5e:	eb 11                	jmp    800d71 <strtol+0x3e>
  800d60:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d65:	80 f9 2d             	cmp    $0x2d,%cl
  800d68:	75 07                	jne    800d71 <strtol+0x3e>
		s++, neg = 1;
  800d6a:	8d 52 01             	lea    0x1(%edx),%edx
  800d6d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d71:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d76:	75 15                	jne    800d8d <strtol+0x5a>
  800d78:	80 3a 30             	cmpb   $0x30,(%edx)
  800d7b:	75 10                	jne    800d8d <strtol+0x5a>
  800d7d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d81:	75 0a                	jne    800d8d <strtol+0x5a>
		s += 2, base = 16;
  800d83:	83 c2 02             	add    $0x2,%edx
  800d86:	b8 10 00 00 00       	mov    $0x10,%eax
  800d8b:	eb 10                	jmp    800d9d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	75 0c                	jne    800d9d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d91:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d93:	80 3a 30             	cmpb   $0x30,(%edx)
  800d96:	75 05                	jne    800d9d <strtol+0x6a>
		s++, base = 8;
  800d98:	83 c2 01             	add    $0x1,%edx
  800d9b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800da5:	0f b6 0a             	movzbl (%edx),%ecx
  800da8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800dab:	89 f0                	mov    %esi,%eax
  800dad:	3c 09                	cmp    $0x9,%al
  800daf:	77 08                	ja     800db9 <strtol+0x86>
			dig = *s - '0';
  800db1:	0f be c9             	movsbl %cl,%ecx
  800db4:	83 e9 30             	sub    $0x30,%ecx
  800db7:	eb 20                	jmp    800dd9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800db9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800dbc:	89 f0                	mov    %esi,%eax
  800dbe:	3c 19                	cmp    $0x19,%al
  800dc0:	77 08                	ja     800dca <strtol+0x97>
			dig = *s - 'a' + 10;
  800dc2:	0f be c9             	movsbl %cl,%ecx
  800dc5:	83 e9 57             	sub    $0x57,%ecx
  800dc8:	eb 0f                	jmp    800dd9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800dca:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800dcd:	89 f0                	mov    %esi,%eax
  800dcf:	3c 19                	cmp    $0x19,%al
  800dd1:	77 16                	ja     800de9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800dd3:	0f be c9             	movsbl %cl,%ecx
  800dd6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800dd9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800ddc:	7d 0f                	jge    800ded <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800dde:	83 c2 01             	add    $0x1,%edx
  800de1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800de5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800de7:	eb bc                	jmp    800da5 <strtol+0x72>
  800de9:	89 d8                	mov    %ebx,%eax
  800deb:	eb 02                	jmp    800def <strtol+0xbc>
  800ded:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800def:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df3:	74 05                	je     800dfa <strtol+0xc7>
		*endptr = (char *) s;
  800df5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800df8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800dfa:	f7 d8                	neg    %eax
  800dfc:	85 ff                	test   %edi,%edi
  800dfe:	0f 44 c3             	cmove  %ebx,%eax
}
  800e01:	5b                   	pop    %ebx
  800e02:	5e                   	pop    %esi
  800e03:	5f                   	pop    %edi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	57                   	push   %edi
  800e0a:	56                   	push   %esi
  800e0b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e14:	8b 55 08             	mov    0x8(%ebp),%edx
  800e17:	89 c3                	mov    %eax,%ebx
  800e19:	89 c7                	mov    %eax,%edi
  800e1b:	89 c6                	mov    %eax,%esi
  800e1d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e1f:	5b                   	pop    %ebx
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	57                   	push   %edi
  800e28:	56                   	push   %esi
  800e29:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2f:	b8 01 00 00 00       	mov    $0x1,%eax
  800e34:	89 d1                	mov    %edx,%ecx
  800e36:	89 d3                	mov    %edx,%ebx
  800e38:	89 d7                	mov    %edx,%edi
  800e3a:	89 d6                	mov    %edx,%esi
  800e3c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e3e:	5b                   	pop    %ebx
  800e3f:	5e                   	pop    %esi
  800e40:	5f                   	pop    %edi
  800e41:	5d                   	pop    %ebp
  800e42:	c3                   	ret    

00800e43 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	57                   	push   %edi
  800e47:	56                   	push   %esi
  800e48:	53                   	push   %ebx
  800e49:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e51:	b8 03 00 00 00       	mov    $0x3,%eax
  800e56:	8b 55 08             	mov    0x8(%ebp),%edx
  800e59:	89 cb                	mov    %ecx,%ebx
  800e5b:	89 cf                	mov    %ecx,%edi
  800e5d:	89 ce                	mov    %ecx,%esi
  800e5f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e61:	85 c0                	test   %eax,%eax
  800e63:	7e 28                	jle    800e8d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e65:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e69:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e70:	00 
  800e71:	c7 44 24 08 2b 30 80 	movl   $0x80302b,0x8(%esp)
  800e78:	00 
  800e79:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e80:	00 
  800e81:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  800e88:	e8 03 f5 ff ff       	call   800390 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e8d:	83 c4 2c             	add    $0x2c,%esp
  800e90:	5b                   	pop    %ebx
  800e91:	5e                   	pop    %esi
  800e92:	5f                   	pop    %edi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    

00800e95 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	57                   	push   %edi
  800e99:	56                   	push   %esi
  800e9a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea0:	b8 02 00 00 00       	mov    $0x2,%eax
  800ea5:	89 d1                	mov    %edx,%ecx
  800ea7:	89 d3                	mov    %edx,%ebx
  800ea9:	89 d7                	mov    %edx,%edi
  800eab:	89 d6                	mov    %edx,%esi
  800ead:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5f                   	pop    %edi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    

00800eb4 <sys_yield>:

void
sys_yield(void)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	57                   	push   %edi
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eba:	ba 00 00 00 00       	mov    $0x0,%edx
  800ebf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ec4:	89 d1                	mov    %edx,%ecx
  800ec6:	89 d3                	mov    %edx,%ebx
  800ec8:	89 d7                	mov    %edx,%edi
  800eca:	89 d6                	mov    %edx,%esi
  800ecc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800edc:	be 00 00 00 00       	mov    $0x0,%esi
  800ee1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ee6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eef:	89 f7                	mov    %esi,%edi
  800ef1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	7e 28                	jle    800f1f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800efb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f02:	00 
  800f03:	c7 44 24 08 2b 30 80 	movl   $0x80302b,0x8(%esp)
  800f0a:	00 
  800f0b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f12:	00 
  800f13:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  800f1a:	e8 71 f4 ff ff       	call   800390 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f1f:	83 c4 2c             	add    $0x2c,%esp
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5f                   	pop    %edi
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    

00800f27 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	57                   	push   %edi
  800f2b:	56                   	push   %esi
  800f2c:	53                   	push   %ebx
  800f2d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f30:	b8 05 00 00 00       	mov    $0x5,%eax
  800f35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f38:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f3e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f41:	8b 75 18             	mov    0x18(%ebp),%esi
  800f44:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f46:	85 c0                	test   %eax,%eax
  800f48:	7e 28                	jle    800f72 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f4e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f55:	00 
  800f56:	c7 44 24 08 2b 30 80 	movl   $0x80302b,0x8(%esp)
  800f5d:	00 
  800f5e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f65:	00 
  800f66:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  800f6d:	e8 1e f4 ff ff       	call   800390 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f72:	83 c4 2c             	add    $0x2c,%esp
  800f75:	5b                   	pop    %ebx
  800f76:	5e                   	pop    %esi
  800f77:	5f                   	pop    %edi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    

00800f7a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	57                   	push   %edi
  800f7e:	56                   	push   %esi
  800f7f:	53                   	push   %ebx
  800f80:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f88:	b8 06 00 00 00       	mov    $0x6,%eax
  800f8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f90:	8b 55 08             	mov    0x8(%ebp),%edx
  800f93:	89 df                	mov    %ebx,%edi
  800f95:	89 de                	mov    %ebx,%esi
  800f97:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	7e 28                	jle    800fc5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800fa8:	00 
  800fa9:	c7 44 24 08 2b 30 80 	movl   $0x80302b,0x8(%esp)
  800fb0:	00 
  800fb1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb8:	00 
  800fb9:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  800fc0:	e8 cb f3 ff ff       	call   800390 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fc5:	83 c4 2c             	add    $0x2c,%esp
  800fc8:	5b                   	pop    %ebx
  800fc9:	5e                   	pop    %esi
  800fca:	5f                   	pop    %edi
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    

00800fcd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	57                   	push   %edi
  800fd1:	56                   	push   %esi
  800fd2:	53                   	push   %ebx
  800fd3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	b8 08 00 00 00       	mov    $0x8,%eax
  800fe0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe6:	89 df                	mov    %ebx,%edi
  800fe8:	89 de                	mov    %ebx,%esi
  800fea:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fec:	85 c0                	test   %eax,%eax
  800fee:	7e 28                	jle    801018 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ffb:	00 
  800ffc:	c7 44 24 08 2b 30 80 	movl   $0x80302b,0x8(%esp)
  801003:	00 
  801004:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80100b:	00 
  80100c:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  801013:	e8 78 f3 ff ff       	call   800390 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801018:	83 c4 2c             	add    $0x2c,%esp
  80101b:	5b                   	pop    %ebx
  80101c:	5e                   	pop    %esi
  80101d:	5f                   	pop    %edi
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    

00801020 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	57                   	push   %edi
  801024:	56                   	push   %esi
  801025:	53                   	push   %ebx
  801026:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801029:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102e:	b8 09 00 00 00       	mov    $0x9,%eax
  801033:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801036:	8b 55 08             	mov    0x8(%ebp),%edx
  801039:	89 df                	mov    %ebx,%edi
  80103b:	89 de                	mov    %ebx,%esi
  80103d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80103f:	85 c0                	test   %eax,%eax
  801041:	7e 28                	jle    80106b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801043:	89 44 24 10          	mov    %eax,0x10(%esp)
  801047:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80104e:	00 
  80104f:	c7 44 24 08 2b 30 80 	movl   $0x80302b,0x8(%esp)
  801056:	00 
  801057:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80105e:	00 
  80105f:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  801066:	e8 25 f3 ff ff       	call   800390 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80106b:	83 c4 2c             	add    $0x2c,%esp
  80106e:	5b                   	pop    %ebx
  80106f:	5e                   	pop    %esi
  801070:	5f                   	pop    %edi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	57                   	push   %edi
  801077:	56                   	push   %esi
  801078:	53                   	push   %ebx
  801079:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801081:	b8 0a 00 00 00       	mov    $0xa,%eax
  801086:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801089:	8b 55 08             	mov    0x8(%ebp),%edx
  80108c:	89 df                	mov    %ebx,%edi
  80108e:	89 de                	mov    %ebx,%esi
  801090:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801092:	85 c0                	test   %eax,%eax
  801094:	7e 28                	jle    8010be <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801096:	89 44 24 10          	mov    %eax,0x10(%esp)
  80109a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8010a1:	00 
  8010a2:	c7 44 24 08 2b 30 80 	movl   $0x80302b,0x8(%esp)
  8010a9:	00 
  8010aa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b1:	00 
  8010b2:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  8010b9:	e8 d2 f2 ff ff       	call   800390 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010be:	83 c4 2c             	add    $0x2c,%esp
  8010c1:	5b                   	pop    %ebx
  8010c2:	5e                   	pop    %esi
  8010c3:	5f                   	pop    %edi
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    

008010c6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	57                   	push   %edi
  8010ca:	56                   	push   %esi
  8010cb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010cc:	be 00 00 00 00       	mov    $0x0,%esi
  8010d1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010df:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010e2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010e4:	5b                   	pop    %ebx
  8010e5:	5e                   	pop    %esi
  8010e6:	5f                   	pop    %edi
  8010e7:	5d                   	pop    %ebp
  8010e8:	c3                   	ret    

008010e9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	57                   	push   %edi
  8010ed:	56                   	push   %esi
  8010ee:	53                   	push   %ebx
  8010ef:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ff:	89 cb                	mov    %ecx,%ebx
  801101:	89 cf                	mov    %ecx,%edi
  801103:	89 ce                	mov    %ecx,%esi
  801105:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801107:	85 c0                	test   %eax,%eax
  801109:	7e 28                	jle    801133 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80110b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80110f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801116:	00 
  801117:	c7 44 24 08 2b 30 80 	movl   $0x80302b,0x8(%esp)
  80111e:	00 
  80111f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801126:	00 
  801127:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  80112e:	e8 5d f2 ff ff       	call   800390 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801133:	83 c4 2c             	add    $0x2c,%esp
  801136:	5b                   	pop    %ebx
  801137:	5e                   	pop    %esi
  801138:	5f                   	pop    %edi
  801139:	5d                   	pop    %ebp
  80113a:	c3                   	ret    

0080113b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	57                   	push   %edi
  80113f:	56                   	push   %esi
  801140:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801141:	ba 00 00 00 00       	mov    $0x0,%edx
  801146:	b8 0e 00 00 00       	mov    $0xe,%eax
  80114b:	89 d1                	mov    %edx,%ecx
  80114d:	89 d3                	mov    %edx,%ebx
  80114f:	89 d7                	mov    %edx,%edi
  801151:	89 d6                	mov    %edx,%esi
  801153:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801155:	5b                   	pop    %ebx
  801156:	5e                   	pop    %esi
  801157:	5f                   	pop    %edi
  801158:	5d                   	pop    %ebp
  801159:	c3                   	ret    

0080115a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
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
  801168:	b8 0f 00 00 00       	mov    $0xf,%eax
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
  80117b:	7e 28                	jle    8011a5 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80117d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801181:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801188:	00 
  801189:	c7 44 24 08 2b 30 80 	movl   $0x80302b,0x8(%esp)
  801190:	00 
  801191:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801198:	00 
  801199:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  8011a0:	e8 eb f1 ff ff       	call   800390 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  8011a5:	83 c4 2c             	add    $0x2c,%esp
  8011a8:	5b                   	pop    %ebx
  8011a9:	5e                   	pop    %esi
  8011aa:	5f                   	pop    %edi
  8011ab:	5d                   	pop    %ebp
  8011ac:	c3                   	ret    

008011ad <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
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
  8011bb:	b8 10 00 00 00       	mov    $0x10,%eax
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
  8011ce:	7e 28                	jle    8011f8 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011d4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8011db:	00 
  8011dc:	c7 44 24 08 2b 30 80 	movl   $0x80302b,0x8(%esp)
  8011e3:	00 
  8011e4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011eb:	00 
  8011ec:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  8011f3:	e8 98 f1 ff ff       	call   800390 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  8011f8:	83 c4 2c             	add    $0x2c,%esp
  8011fb:	5b                   	pop    %ebx
  8011fc:	5e                   	pop    %esi
  8011fd:	5f                   	pop    %edi
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    

00801200 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
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
  80120e:	b8 11 00 00 00       	mov    $0x11,%eax
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
  801221:	7e 28                	jle    80124b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801223:	89 44 24 10          	mov    %eax,0x10(%esp)
  801227:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  80122e:	00 
  80122f:	c7 44 24 08 2b 30 80 	movl   $0x80302b,0x8(%esp)
  801236:	00 
  801237:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80123e:	00 
  80123f:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  801246:	e8 45 f1 ff ff       	call   800390 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80124b:	83 c4 2c             	add    $0x2c,%esp
  80124e:	5b                   	pop    %ebx
  80124f:	5e                   	pop    %esi
  801250:	5f                   	pop    %edi
  801251:	5d                   	pop    %ebp
  801252:	c3                   	ret    

00801253 <sys_sleep>:

int
sys_sleep(int channel)
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
  80125c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801261:	b8 12 00 00 00       	mov    $0x12,%eax
  801266:	8b 55 08             	mov    0x8(%ebp),%edx
  801269:	89 cb                	mov    %ecx,%ebx
  80126b:	89 cf                	mov    %ecx,%edi
  80126d:	89 ce                	mov    %ecx,%esi
  80126f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801271:	85 c0                	test   %eax,%eax
  801273:	7e 28                	jle    80129d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801275:	89 44 24 10          	mov    %eax,0x10(%esp)
  801279:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801280:	00 
  801281:	c7 44 24 08 2b 30 80 	movl   $0x80302b,0x8(%esp)
  801288:	00 
  801289:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801290:	00 
  801291:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  801298:	e8 f3 f0 ff ff       	call   800390 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80129d:	83 c4 2c             	add    $0x2c,%esp
  8012a0:	5b                   	pop    %ebx
  8012a1:	5e                   	pop    %esi
  8012a2:	5f                   	pop    %edi
  8012a3:	5d                   	pop    %ebp
  8012a4:	c3                   	ret    

008012a5 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	57                   	push   %edi
  8012a9:	56                   	push   %esi
  8012aa:	53                   	push   %ebx
  8012ab:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b3:	b8 13 00 00 00       	mov    $0x13,%eax
  8012b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8012be:	89 df                	mov    %ebx,%edi
  8012c0:	89 de                	mov    %ebx,%esi
  8012c2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	7e 28                	jle    8012f0 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012cc:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  8012d3:	00 
  8012d4:	c7 44 24 08 2b 30 80 	movl   $0x80302b,0x8(%esp)
  8012db:	00 
  8012dc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012e3:	00 
  8012e4:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  8012eb:	e8 a0 f0 ff ff       	call   800390 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  8012f0:	83 c4 2c             	add    $0x2c,%esp
  8012f3:	5b                   	pop    %ebx
  8012f4:	5e                   	pop    %esi
  8012f5:	5f                   	pop    %edi
  8012f6:	5d                   	pop    %ebp
  8012f7:	c3                   	ret    

008012f8 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	53                   	push   %ebx
  8012fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801302:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801305:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  801307:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  80130a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80130f:	83 39 01             	cmpl   $0x1,(%ecx)
  801312:	7e 0f                	jle    801323 <argstart+0x2b>
  801314:	85 d2                	test   %edx,%edx
  801316:	ba 00 00 00 00       	mov    $0x0,%edx
  80131b:	bb 88 2c 80 00       	mov    $0x802c88,%ebx
  801320:	0f 44 da             	cmove  %edx,%ebx
  801323:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  801326:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  80132d:	5b                   	pop    %ebx
  80132e:	5d                   	pop    %ebp
  80132f:	c3                   	ret    

00801330 <argnext>:

int
argnext(struct Argstate *args)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	53                   	push   %ebx
  801334:	83 ec 14             	sub    $0x14,%esp
  801337:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  80133a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801341:	8b 43 08             	mov    0x8(%ebx),%eax
  801344:	85 c0                	test   %eax,%eax
  801346:	74 71                	je     8013b9 <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  801348:	80 38 00             	cmpb   $0x0,(%eax)
  80134b:	75 50                	jne    80139d <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80134d:	8b 0b                	mov    (%ebx),%ecx
  80134f:	83 39 01             	cmpl   $0x1,(%ecx)
  801352:	74 57                	je     8013ab <argnext+0x7b>
		    || args->argv[1][0] != '-'
  801354:	8b 53 04             	mov    0x4(%ebx),%edx
  801357:	8b 42 04             	mov    0x4(%edx),%eax
  80135a:	80 38 2d             	cmpb   $0x2d,(%eax)
  80135d:	75 4c                	jne    8013ab <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  80135f:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801363:	74 46                	je     8013ab <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801365:	83 c0 01             	add    $0x1,%eax
  801368:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80136b:	8b 01                	mov    (%ecx),%eax
  80136d:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801374:	89 44 24 08          	mov    %eax,0x8(%esp)
  801378:	8d 42 08             	lea    0x8(%edx),%eax
  80137b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80137f:	83 c2 04             	add    $0x4,%edx
  801382:	89 14 24             	mov    %edx,(%esp)
  801385:	e8 ca f8 ff ff       	call   800c54 <memmove>
		(*args->argc)--;
  80138a:	8b 03                	mov    (%ebx),%eax
  80138c:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80138f:	8b 43 08             	mov    0x8(%ebx),%eax
  801392:	80 38 2d             	cmpb   $0x2d,(%eax)
  801395:	75 06                	jne    80139d <argnext+0x6d>
  801397:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80139b:	74 0e                	je     8013ab <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  80139d:	8b 53 08             	mov    0x8(%ebx),%edx
  8013a0:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  8013a3:	83 c2 01             	add    $0x1,%edx
  8013a6:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  8013a9:	eb 13                	jmp    8013be <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  8013ab:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8013b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8013b7:	eb 05                	jmp    8013be <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  8013b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8013be:	83 c4 14             	add    $0x14,%esp
  8013c1:	5b                   	pop    %ebx
  8013c2:	5d                   	pop    %ebp
  8013c3:	c3                   	ret    

008013c4 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	53                   	push   %ebx
  8013c8:	83 ec 14             	sub    $0x14,%esp
  8013cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8013ce:	8b 43 08             	mov    0x8(%ebx),%eax
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	74 5a                	je     80142f <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  8013d5:	80 38 00             	cmpb   $0x0,(%eax)
  8013d8:	74 0c                	je     8013e6 <argnextvalue+0x22>
		args->argvalue = args->curarg;
  8013da:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8013dd:	c7 43 08 88 2c 80 00 	movl   $0x802c88,0x8(%ebx)
  8013e4:	eb 44                	jmp    80142a <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  8013e6:	8b 03                	mov    (%ebx),%eax
  8013e8:	83 38 01             	cmpl   $0x1,(%eax)
  8013eb:	7e 2f                	jle    80141c <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  8013ed:	8b 53 04             	mov    0x4(%ebx),%edx
  8013f0:	8b 4a 04             	mov    0x4(%edx),%ecx
  8013f3:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8013f6:	8b 00                	mov    (%eax),%eax
  8013f8:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8013ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  801403:	8d 42 08             	lea    0x8(%edx),%eax
  801406:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140a:	83 c2 04             	add    $0x4,%edx
  80140d:	89 14 24             	mov    %edx,(%esp)
  801410:	e8 3f f8 ff ff       	call   800c54 <memmove>
		(*args->argc)--;
  801415:	8b 03                	mov    (%ebx),%eax
  801417:	83 28 01             	subl   $0x1,(%eax)
  80141a:	eb 0e                	jmp    80142a <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  80141c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801423:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  80142a:	8b 43 0c             	mov    0xc(%ebx),%eax
  80142d:	eb 05                	jmp    801434 <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  80142f:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  801434:	83 c4 14             	add    $0x14,%esp
  801437:	5b                   	pop    %ebx
  801438:	5d                   	pop    %ebp
  801439:	c3                   	ret    

0080143a <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 18             	sub    $0x18,%esp
  801440:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801443:	8b 51 0c             	mov    0xc(%ecx),%edx
  801446:	89 d0                	mov    %edx,%eax
  801448:	85 d2                	test   %edx,%edx
  80144a:	75 08                	jne    801454 <argvalue+0x1a>
  80144c:	89 0c 24             	mov    %ecx,(%esp)
  80144f:	e8 70 ff ff ff       	call   8013c4 <argnextvalue>
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    
  801456:	66 90                	xchg   %ax,%ax
  801458:	66 90                	xchg   %ax,%ax
  80145a:	66 90                	xchg   %ax,%ax
  80145c:	66 90                	xchg   %ax,%ax
  80145e:	66 90                	xchg   %ax,%ax

00801460 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	05 00 00 00 30       	add    $0x30000000,%eax
  80146b:	c1 e8 0c             	shr    $0xc,%eax
}
  80146e:	5d                   	pop    %ebp
  80146f:	c3                   	ret    

00801470 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80147b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801480:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801485:	5d                   	pop    %ebp
  801486:	c3                   	ret    

00801487 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80148d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801492:	89 c2                	mov    %eax,%edx
  801494:	c1 ea 16             	shr    $0x16,%edx
  801497:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80149e:	f6 c2 01             	test   $0x1,%dl
  8014a1:	74 11                	je     8014b4 <fd_alloc+0x2d>
  8014a3:	89 c2                	mov    %eax,%edx
  8014a5:	c1 ea 0c             	shr    $0xc,%edx
  8014a8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014af:	f6 c2 01             	test   $0x1,%dl
  8014b2:	75 09                	jne    8014bd <fd_alloc+0x36>
			*fd_store = fd;
  8014b4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bb:	eb 17                	jmp    8014d4 <fd_alloc+0x4d>
  8014bd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8014c2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014c7:	75 c9                	jne    801492 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014c9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8014cf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8014d4:	5d                   	pop    %ebp
  8014d5:	c3                   	ret    

008014d6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014dc:	83 f8 1f             	cmp    $0x1f,%eax
  8014df:	77 36                	ja     801517 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014e1:	c1 e0 0c             	shl    $0xc,%eax
  8014e4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014e9:	89 c2                	mov    %eax,%edx
  8014eb:	c1 ea 16             	shr    $0x16,%edx
  8014ee:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014f5:	f6 c2 01             	test   $0x1,%dl
  8014f8:	74 24                	je     80151e <fd_lookup+0x48>
  8014fa:	89 c2                	mov    %eax,%edx
  8014fc:	c1 ea 0c             	shr    $0xc,%edx
  8014ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801506:	f6 c2 01             	test   $0x1,%dl
  801509:	74 1a                	je     801525 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80150b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150e:	89 02                	mov    %eax,(%edx)
	return 0;
  801510:	b8 00 00 00 00       	mov    $0x0,%eax
  801515:	eb 13                	jmp    80152a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801517:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80151c:	eb 0c                	jmp    80152a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80151e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801523:	eb 05                	jmp    80152a <fd_lookup+0x54>
  801525:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80152a:	5d                   	pop    %ebp
  80152b:	c3                   	ret    

0080152c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 18             	sub    $0x18,%esp
  801532:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801535:	ba 00 00 00 00       	mov    $0x0,%edx
  80153a:	eb 13                	jmp    80154f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80153c:	39 08                	cmp    %ecx,(%eax)
  80153e:	75 0c                	jne    80154c <dev_lookup+0x20>
			*dev = devtab[i];
  801540:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801543:	89 01                	mov    %eax,(%ecx)
			return 0;
  801545:	b8 00 00 00 00       	mov    $0x0,%eax
  80154a:	eb 38                	jmp    801584 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80154c:	83 c2 01             	add    $0x1,%edx
  80154f:	8b 04 95 d4 30 80 00 	mov    0x8030d4(,%edx,4),%eax
  801556:	85 c0                	test   %eax,%eax
  801558:	75 e2                	jne    80153c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80155a:	a1 20 54 80 00       	mov    0x805420,%eax
  80155f:	8b 40 48             	mov    0x48(%eax),%eax
  801562:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801566:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156a:	c7 04 24 58 30 80 00 	movl   $0x803058,(%esp)
  801571:	e8 13 ef ff ff       	call   800489 <cprintf>
	*dev = 0;
  801576:	8b 45 0c             	mov    0xc(%ebp),%eax
  801579:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80157f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	56                   	push   %esi
  80158a:	53                   	push   %ebx
  80158b:	83 ec 20             	sub    $0x20,%esp
  80158e:	8b 75 08             	mov    0x8(%ebp),%esi
  801591:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801594:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801597:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80159b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015a1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015a4:	89 04 24             	mov    %eax,(%esp)
  8015a7:	e8 2a ff ff ff       	call   8014d6 <fd_lookup>
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 05                	js     8015b5 <fd_close+0x2f>
	    || fd != fd2)
  8015b0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8015b3:	74 0c                	je     8015c1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8015b5:	84 db                	test   %bl,%bl
  8015b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015bc:	0f 44 c2             	cmove  %edx,%eax
  8015bf:	eb 3f                	jmp    801600 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c8:	8b 06                	mov    (%esi),%eax
  8015ca:	89 04 24             	mov    %eax,(%esp)
  8015cd:	e8 5a ff ff ff       	call   80152c <dev_lookup>
  8015d2:	89 c3                	mov    %eax,%ebx
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	78 16                	js     8015ee <fd_close+0x68>
		if (dev->dev_close)
  8015d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015db:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8015de:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	74 07                	je     8015ee <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8015e7:	89 34 24             	mov    %esi,(%esp)
  8015ea:	ff d0                	call   *%eax
  8015ec:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8015ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015f9:	e8 7c f9 ff ff       	call   800f7a <sys_page_unmap>
	return r;
  8015fe:	89 d8                	mov    %ebx,%eax
}
  801600:	83 c4 20             	add    $0x20,%esp
  801603:	5b                   	pop    %ebx
  801604:	5e                   	pop    %esi
  801605:	5d                   	pop    %ebp
  801606:	c3                   	ret    

00801607 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80160d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801610:	89 44 24 04          	mov    %eax,0x4(%esp)
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	89 04 24             	mov    %eax,(%esp)
  80161a:	e8 b7 fe ff ff       	call   8014d6 <fd_lookup>
  80161f:	89 c2                	mov    %eax,%edx
  801621:	85 d2                	test   %edx,%edx
  801623:	78 13                	js     801638 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801625:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80162c:	00 
  80162d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801630:	89 04 24             	mov    %eax,(%esp)
  801633:	e8 4e ff ff ff       	call   801586 <fd_close>
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <close_all>:

void
close_all(void)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	53                   	push   %ebx
  80163e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801641:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801646:	89 1c 24             	mov    %ebx,(%esp)
  801649:	e8 b9 ff ff ff       	call   801607 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80164e:	83 c3 01             	add    $0x1,%ebx
  801651:	83 fb 20             	cmp    $0x20,%ebx
  801654:	75 f0                	jne    801646 <close_all+0xc>
		close(i);
}
  801656:	83 c4 14             	add    $0x14,%esp
  801659:	5b                   	pop    %ebx
  80165a:	5d                   	pop    %ebp
  80165b:	c3                   	ret    

0080165c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	57                   	push   %edi
  801660:	56                   	push   %esi
  801661:	53                   	push   %ebx
  801662:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801665:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801668:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	89 04 24             	mov    %eax,(%esp)
  801672:	e8 5f fe ff ff       	call   8014d6 <fd_lookup>
  801677:	89 c2                	mov    %eax,%edx
  801679:	85 d2                	test   %edx,%edx
  80167b:	0f 88 e1 00 00 00    	js     801762 <dup+0x106>
		return r;
	close(newfdnum);
  801681:	8b 45 0c             	mov    0xc(%ebp),%eax
  801684:	89 04 24             	mov    %eax,(%esp)
  801687:	e8 7b ff ff ff       	call   801607 <close>

	newfd = INDEX2FD(newfdnum);
  80168c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80168f:	c1 e3 0c             	shl    $0xc,%ebx
  801692:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80169b:	89 04 24             	mov    %eax,(%esp)
  80169e:	e8 cd fd ff ff       	call   801470 <fd2data>
  8016a3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8016a5:	89 1c 24             	mov    %ebx,(%esp)
  8016a8:	e8 c3 fd ff ff       	call   801470 <fd2data>
  8016ad:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016af:	89 f0                	mov    %esi,%eax
  8016b1:	c1 e8 16             	shr    $0x16,%eax
  8016b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016bb:	a8 01                	test   $0x1,%al
  8016bd:	74 43                	je     801702 <dup+0xa6>
  8016bf:	89 f0                	mov    %esi,%eax
  8016c1:	c1 e8 0c             	shr    $0xc,%eax
  8016c4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016cb:	f6 c2 01             	test   $0x1,%dl
  8016ce:	74 32                	je     801702 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8016dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016e0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016eb:	00 
  8016ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016f7:	e8 2b f8 ff ff       	call   800f27 <sys_page_map>
  8016fc:	89 c6                	mov    %eax,%esi
  8016fe:	85 c0                	test   %eax,%eax
  801700:	78 3e                	js     801740 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801705:	89 c2                	mov    %eax,%edx
  801707:	c1 ea 0c             	shr    $0xc,%edx
  80170a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801711:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801717:	89 54 24 10          	mov    %edx,0x10(%esp)
  80171b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80171f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801726:	00 
  801727:	89 44 24 04          	mov    %eax,0x4(%esp)
  80172b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801732:	e8 f0 f7 ff ff       	call   800f27 <sys_page_map>
  801737:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801739:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80173c:	85 f6                	test   %esi,%esi
  80173e:	79 22                	jns    801762 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801740:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801744:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80174b:	e8 2a f8 ff ff       	call   800f7a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801750:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801754:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80175b:	e8 1a f8 ff ff       	call   800f7a <sys_page_unmap>
	return r;
  801760:	89 f0                	mov    %esi,%eax
}
  801762:	83 c4 3c             	add    $0x3c,%esp
  801765:	5b                   	pop    %ebx
  801766:	5e                   	pop    %esi
  801767:	5f                   	pop    %edi
  801768:	5d                   	pop    %ebp
  801769:	c3                   	ret    

0080176a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	53                   	push   %ebx
  80176e:	83 ec 24             	sub    $0x24,%esp
  801771:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801774:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801777:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177b:	89 1c 24             	mov    %ebx,(%esp)
  80177e:	e8 53 fd ff ff       	call   8014d6 <fd_lookup>
  801783:	89 c2                	mov    %eax,%edx
  801785:	85 d2                	test   %edx,%edx
  801787:	78 6d                	js     8017f6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801789:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801793:	8b 00                	mov    (%eax),%eax
  801795:	89 04 24             	mov    %eax,(%esp)
  801798:	e8 8f fd ff ff       	call   80152c <dev_lookup>
  80179d:	85 c0                	test   %eax,%eax
  80179f:	78 55                	js     8017f6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a4:	8b 50 08             	mov    0x8(%eax),%edx
  8017a7:	83 e2 03             	and    $0x3,%edx
  8017aa:	83 fa 01             	cmp    $0x1,%edx
  8017ad:	75 23                	jne    8017d2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017af:	a1 20 54 80 00       	mov    0x805420,%eax
  8017b4:	8b 40 48             	mov    0x48(%eax),%eax
  8017b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bf:	c7 04 24 99 30 80 00 	movl   $0x803099,(%esp)
  8017c6:	e8 be ec ff ff       	call   800489 <cprintf>
		return -E_INVAL;
  8017cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d0:	eb 24                	jmp    8017f6 <read+0x8c>
	}
	if (!dev->dev_read)
  8017d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d5:	8b 52 08             	mov    0x8(%edx),%edx
  8017d8:	85 d2                	test   %edx,%edx
  8017da:	74 15                	je     8017f1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017ea:	89 04 24             	mov    %eax,(%esp)
  8017ed:	ff d2                	call   *%edx
  8017ef:	eb 05                	jmp    8017f6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8017f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8017f6:	83 c4 24             	add    $0x24,%esp
  8017f9:	5b                   	pop    %ebx
  8017fa:	5d                   	pop    %ebp
  8017fb:	c3                   	ret    

008017fc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	57                   	push   %edi
  801800:	56                   	push   %esi
  801801:	53                   	push   %ebx
  801802:	83 ec 1c             	sub    $0x1c,%esp
  801805:	8b 7d 08             	mov    0x8(%ebp),%edi
  801808:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80180b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801810:	eb 23                	jmp    801835 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801812:	89 f0                	mov    %esi,%eax
  801814:	29 d8                	sub    %ebx,%eax
  801816:	89 44 24 08          	mov    %eax,0x8(%esp)
  80181a:	89 d8                	mov    %ebx,%eax
  80181c:	03 45 0c             	add    0xc(%ebp),%eax
  80181f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801823:	89 3c 24             	mov    %edi,(%esp)
  801826:	e8 3f ff ff ff       	call   80176a <read>
		if (m < 0)
  80182b:	85 c0                	test   %eax,%eax
  80182d:	78 10                	js     80183f <readn+0x43>
			return m;
		if (m == 0)
  80182f:	85 c0                	test   %eax,%eax
  801831:	74 0a                	je     80183d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801833:	01 c3                	add    %eax,%ebx
  801835:	39 f3                	cmp    %esi,%ebx
  801837:	72 d9                	jb     801812 <readn+0x16>
  801839:	89 d8                	mov    %ebx,%eax
  80183b:	eb 02                	jmp    80183f <readn+0x43>
  80183d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80183f:	83 c4 1c             	add    $0x1c,%esp
  801842:	5b                   	pop    %ebx
  801843:	5e                   	pop    %esi
  801844:	5f                   	pop    %edi
  801845:	5d                   	pop    %ebp
  801846:	c3                   	ret    

00801847 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	53                   	push   %ebx
  80184b:	83 ec 24             	sub    $0x24,%esp
  80184e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801851:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801854:	89 44 24 04          	mov    %eax,0x4(%esp)
  801858:	89 1c 24             	mov    %ebx,(%esp)
  80185b:	e8 76 fc ff ff       	call   8014d6 <fd_lookup>
  801860:	89 c2                	mov    %eax,%edx
  801862:	85 d2                	test   %edx,%edx
  801864:	78 68                	js     8018ce <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801866:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801869:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801870:	8b 00                	mov    (%eax),%eax
  801872:	89 04 24             	mov    %eax,(%esp)
  801875:	e8 b2 fc ff ff       	call   80152c <dev_lookup>
  80187a:	85 c0                	test   %eax,%eax
  80187c:	78 50                	js     8018ce <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80187e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801881:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801885:	75 23                	jne    8018aa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801887:	a1 20 54 80 00       	mov    0x805420,%eax
  80188c:	8b 40 48             	mov    0x48(%eax),%eax
  80188f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801893:	89 44 24 04          	mov    %eax,0x4(%esp)
  801897:	c7 04 24 b5 30 80 00 	movl   $0x8030b5,(%esp)
  80189e:	e8 e6 eb ff ff       	call   800489 <cprintf>
		return -E_INVAL;
  8018a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018a8:	eb 24                	jmp    8018ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ad:	8b 52 0c             	mov    0xc(%edx),%edx
  8018b0:	85 d2                	test   %edx,%edx
  8018b2:	74 15                	je     8018c9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018c2:	89 04 24             	mov    %eax,(%esp)
  8018c5:	ff d2                	call   *%edx
  8018c7:	eb 05                	jmp    8018ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8018c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8018ce:	83 c4 24             	add    $0x24,%esp
  8018d1:	5b                   	pop    %ebx
  8018d2:	5d                   	pop    %ebp
  8018d3:	c3                   	ret    

008018d4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018da:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8018dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	89 04 24             	mov    %eax,(%esp)
  8018e7:	e8 ea fb ff ff       	call   8014d6 <fd_lookup>
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	78 0e                	js     8018fe <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8018f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	53                   	push   %ebx
  801904:	83 ec 24             	sub    $0x24,%esp
  801907:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80190a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80190d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801911:	89 1c 24             	mov    %ebx,(%esp)
  801914:	e8 bd fb ff ff       	call   8014d6 <fd_lookup>
  801919:	89 c2                	mov    %eax,%edx
  80191b:	85 d2                	test   %edx,%edx
  80191d:	78 61                	js     801980 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80191f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801922:	89 44 24 04          	mov    %eax,0x4(%esp)
  801926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801929:	8b 00                	mov    (%eax),%eax
  80192b:	89 04 24             	mov    %eax,(%esp)
  80192e:	e8 f9 fb ff ff       	call   80152c <dev_lookup>
  801933:	85 c0                	test   %eax,%eax
  801935:	78 49                	js     801980 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80193e:	75 23                	jne    801963 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801940:	a1 20 54 80 00       	mov    0x805420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801945:	8b 40 48             	mov    0x48(%eax),%eax
  801948:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80194c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801950:	c7 04 24 78 30 80 00 	movl   $0x803078,(%esp)
  801957:	e8 2d eb ff ff       	call   800489 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80195c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801961:	eb 1d                	jmp    801980 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801963:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801966:	8b 52 18             	mov    0x18(%edx),%edx
  801969:	85 d2                	test   %edx,%edx
  80196b:	74 0e                	je     80197b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80196d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801970:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801974:	89 04 24             	mov    %eax,(%esp)
  801977:	ff d2                	call   *%edx
  801979:	eb 05                	jmp    801980 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80197b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801980:	83 c4 24             	add    $0x24,%esp
  801983:	5b                   	pop    %ebx
  801984:	5d                   	pop    %ebp
  801985:	c3                   	ret    

00801986 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	53                   	push   %ebx
  80198a:	83 ec 24             	sub    $0x24,%esp
  80198d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801990:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801993:	89 44 24 04          	mov    %eax,0x4(%esp)
  801997:	8b 45 08             	mov    0x8(%ebp),%eax
  80199a:	89 04 24             	mov    %eax,(%esp)
  80199d:	e8 34 fb ff ff       	call   8014d6 <fd_lookup>
  8019a2:	89 c2                	mov    %eax,%edx
  8019a4:	85 d2                	test   %edx,%edx
  8019a6:	78 52                	js     8019fa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b2:	8b 00                	mov    (%eax),%eax
  8019b4:	89 04 24             	mov    %eax,(%esp)
  8019b7:	e8 70 fb ff ff       	call   80152c <dev_lookup>
  8019bc:	85 c0                	test   %eax,%eax
  8019be:	78 3a                	js     8019fa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8019c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019c7:	74 2c                	je     8019f5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019c9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019cc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019d3:	00 00 00 
	stat->st_isdir = 0;
  8019d6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019dd:	00 00 00 
	stat->st_dev = dev;
  8019e0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019ed:	89 14 24             	mov    %edx,(%esp)
  8019f0:	ff 50 14             	call   *0x14(%eax)
  8019f3:	eb 05                	jmp    8019fa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8019f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8019fa:	83 c4 24             	add    $0x24,%esp
  8019fd:	5b                   	pop    %ebx
  8019fe:	5d                   	pop    %ebp
  8019ff:	c3                   	ret    

00801a00 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	56                   	push   %esi
  801a04:	53                   	push   %ebx
  801a05:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a08:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a0f:	00 
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	89 04 24             	mov    %eax,(%esp)
  801a16:	e8 1b 02 00 00       	call   801c36 <open>
  801a1b:	89 c3                	mov    %eax,%ebx
  801a1d:	85 db                	test   %ebx,%ebx
  801a1f:	78 1b                	js     801a3c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801a21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a28:	89 1c 24             	mov    %ebx,(%esp)
  801a2b:	e8 56 ff ff ff       	call   801986 <fstat>
  801a30:	89 c6                	mov    %eax,%esi
	close(fd);
  801a32:	89 1c 24             	mov    %ebx,(%esp)
  801a35:	e8 cd fb ff ff       	call   801607 <close>
	return r;
  801a3a:	89 f0                	mov    %esi,%eax
}
  801a3c:	83 c4 10             	add    $0x10,%esp
  801a3f:	5b                   	pop    %ebx
  801a40:	5e                   	pop    %esi
  801a41:	5d                   	pop    %ebp
  801a42:	c3                   	ret    

00801a43 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	56                   	push   %esi
  801a47:	53                   	push   %ebx
  801a48:	83 ec 10             	sub    $0x10,%esp
  801a4b:	89 c6                	mov    %eax,%esi
  801a4d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a4f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a56:	75 11                	jne    801a69 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a58:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a5f:	e8 ab 0e 00 00       	call   80290f <ipc_find_env>
  801a64:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a69:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a70:	00 
  801a71:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a78:	00 
  801a79:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a7d:	a1 00 50 80 00       	mov    0x805000,%eax
  801a82:	89 04 24             	mov    %eax,(%esp)
  801a85:	e8 1a 0e 00 00       	call   8028a4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a8a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a91:	00 
  801a92:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a96:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a9d:	e8 ae 0d 00 00       	call   802850 <ipc_recv>
}
  801aa2:	83 c4 10             	add    $0x10,%esp
  801aa5:	5b                   	pop    %ebx
  801aa6:	5e                   	pop    %esi
  801aa7:	5d                   	pop    %ebp
  801aa8:	c3                   	ret    

00801aa9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac7:	b8 02 00 00 00       	mov    $0x2,%eax
  801acc:	e8 72 ff ff ff       	call   801a43 <fsipc>
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	8b 40 0c             	mov    0xc(%eax),%eax
  801adf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ae4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae9:	b8 06 00 00 00       	mov    $0x6,%eax
  801aee:	e8 50 ff ff ff       	call   801a43 <fsipc>
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	53                   	push   %ebx
  801af9:	83 ec 14             	sub    $0x14,%esp
  801afc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	8b 40 0c             	mov    0xc(%eax),%eax
  801b05:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b0f:	b8 05 00 00 00       	mov    $0x5,%eax
  801b14:	e8 2a ff ff ff       	call   801a43 <fsipc>
  801b19:	89 c2                	mov    %eax,%edx
  801b1b:	85 d2                	test   %edx,%edx
  801b1d:	78 2b                	js     801b4a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b1f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b26:	00 
  801b27:	89 1c 24             	mov    %ebx,(%esp)
  801b2a:	e8 88 ef ff ff       	call   800ab7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b2f:	a1 80 60 80 00       	mov    0x806080,%eax
  801b34:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b3a:	a1 84 60 80 00       	mov    0x806084,%eax
  801b3f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b4a:	83 c4 14             	add    $0x14,%esp
  801b4d:	5b                   	pop    %ebx
  801b4e:	5d                   	pop    %ebp
  801b4f:	c3                   	ret    

00801b50 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	83 ec 18             	sub    $0x18,%esp
  801b56:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b59:	8b 55 08             	mov    0x8(%ebp),%edx
  801b5c:	8b 52 0c             	mov    0xc(%edx),%edx
  801b5f:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801b65:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801b6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b75:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801b7c:	e8 3b f1 ff ff       	call   800cbc <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801b81:	ba 00 00 00 00       	mov    $0x0,%edx
  801b86:	b8 04 00 00 00       	mov    $0x4,%eax
  801b8b:	e8 b3 fe ff ff       	call   801a43 <fsipc>
		return r;
	}

	return r;
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	56                   	push   %esi
  801b96:	53                   	push   %ebx
  801b97:	83 ec 10             	sub    $0x10,%esp
  801b9a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ba8:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bae:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb3:	b8 03 00 00 00       	mov    $0x3,%eax
  801bb8:	e8 86 fe ff ff       	call   801a43 <fsipc>
  801bbd:	89 c3                	mov    %eax,%ebx
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	78 6a                	js     801c2d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801bc3:	39 c6                	cmp    %eax,%esi
  801bc5:	73 24                	jae    801beb <devfile_read+0x59>
  801bc7:	c7 44 24 0c e8 30 80 	movl   $0x8030e8,0xc(%esp)
  801bce:	00 
  801bcf:	c7 44 24 08 ef 30 80 	movl   $0x8030ef,0x8(%esp)
  801bd6:	00 
  801bd7:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801bde:	00 
  801bdf:	c7 04 24 04 31 80 00 	movl   $0x803104,(%esp)
  801be6:	e8 a5 e7 ff ff       	call   800390 <_panic>
	assert(r <= PGSIZE);
  801beb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bf0:	7e 24                	jle    801c16 <devfile_read+0x84>
  801bf2:	c7 44 24 0c 0f 31 80 	movl   $0x80310f,0xc(%esp)
  801bf9:	00 
  801bfa:	c7 44 24 08 ef 30 80 	movl   $0x8030ef,0x8(%esp)
  801c01:	00 
  801c02:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801c09:	00 
  801c0a:	c7 04 24 04 31 80 00 	movl   $0x803104,(%esp)
  801c11:	e8 7a e7 ff ff       	call   800390 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c16:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c1a:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c21:	00 
  801c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c25:	89 04 24             	mov    %eax,(%esp)
  801c28:	e8 27 f0 ff ff       	call   800c54 <memmove>
	return r;
}
  801c2d:	89 d8                	mov    %ebx,%eax
  801c2f:	83 c4 10             	add    $0x10,%esp
  801c32:	5b                   	pop    %ebx
  801c33:	5e                   	pop    %esi
  801c34:	5d                   	pop    %ebp
  801c35:	c3                   	ret    

00801c36 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	53                   	push   %ebx
  801c3a:	83 ec 24             	sub    $0x24,%esp
  801c3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c40:	89 1c 24             	mov    %ebx,(%esp)
  801c43:	e8 38 ee ff ff       	call   800a80 <strlen>
  801c48:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c4d:	7f 60                	jg     801caf <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c52:	89 04 24             	mov    %eax,(%esp)
  801c55:	e8 2d f8 ff ff       	call   801487 <fd_alloc>
  801c5a:	89 c2                	mov    %eax,%edx
  801c5c:	85 d2                	test   %edx,%edx
  801c5e:	78 54                	js     801cb4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c60:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c64:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801c6b:	e8 47 ee ff ff       	call   800ab7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c73:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c7b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c80:	e8 be fd ff ff       	call   801a43 <fsipc>
  801c85:	89 c3                	mov    %eax,%ebx
  801c87:	85 c0                	test   %eax,%eax
  801c89:	79 17                	jns    801ca2 <open+0x6c>
		fd_close(fd, 0);
  801c8b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c92:	00 
  801c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c96:	89 04 24             	mov    %eax,(%esp)
  801c99:	e8 e8 f8 ff ff       	call   801586 <fd_close>
		return r;
  801c9e:	89 d8                	mov    %ebx,%eax
  801ca0:	eb 12                	jmp    801cb4 <open+0x7e>
	}

	return fd2num(fd);
  801ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca5:	89 04 24             	mov    %eax,(%esp)
  801ca8:	e8 b3 f7 ff ff       	call   801460 <fd2num>
  801cad:	eb 05                	jmp    801cb4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801caf:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801cb4:	83 c4 24             	add    $0x24,%esp
  801cb7:	5b                   	pop    %ebx
  801cb8:	5d                   	pop    %ebp
  801cb9:	c3                   	ret    

00801cba <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cc0:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc5:	b8 08 00 00 00       	mov    $0x8,%eax
  801cca:	e8 74 fd ff ff       	call   801a43 <fsipc>
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	53                   	push   %ebx
  801cd5:	83 ec 14             	sub    $0x14,%esp
  801cd8:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801cda:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801cde:	7e 31                	jle    801d11 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801ce0:	8b 40 04             	mov    0x4(%eax),%eax
  801ce3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ce7:	8d 43 10             	lea    0x10(%ebx),%eax
  801cea:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cee:	8b 03                	mov    (%ebx),%eax
  801cf0:	89 04 24             	mov    %eax,(%esp)
  801cf3:	e8 4f fb ff ff       	call   801847 <write>
		if (result > 0)
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	7e 03                	jle    801cff <writebuf+0x2e>
			b->result += result;
  801cfc:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801cff:	39 43 04             	cmp    %eax,0x4(%ebx)
  801d02:	74 0d                	je     801d11 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801d04:	85 c0                	test   %eax,%eax
  801d06:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0b:	0f 4f c2             	cmovg  %edx,%eax
  801d0e:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801d11:	83 c4 14             	add    $0x14,%esp
  801d14:	5b                   	pop    %ebx
  801d15:	5d                   	pop    %ebp
  801d16:	c3                   	ret    

00801d17 <putch>:

static void
putch(int ch, void *thunk)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	53                   	push   %ebx
  801d1b:	83 ec 04             	sub    $0x4,%esp
  801d1e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801d21:	8b 53 04             	mov    0x4(%ebx),%edx
  801d24:	8d 42 01             	lea    0x1(%edx),%eax
  801d27:	89 43 04             	mov    %eax,0x4(%ebx)
  801d2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d2d:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801d31:	3d 00 01 00 00       	cmp    $0x100,%eax
  801d36:	75 0e                	jne    801d46 <putch+0x2f>
		writebuf(b);
  801d38:	89 d8                	mov    %ebx,%eax
  801d3a:	e8 92 ff ff ff       	call   801cd1 <writebuf>
		b->idx = 0;
  801d3f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801d46:	83 c4 04             	add    $0x4,%esp
  801d49:	5b                   	pop    %ebx
  801d4a:	5d                   	pop    %ebp
  801d4b:	c3                   	ret    

00801d4c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801d55:	8b 45 08             	mov    0x8(%ebp),%eax
  801d58:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801d5e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801d65:	00 00 00 
	b.result = 0;
  801d68:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d6f:	00 00 00 
	b.error = 1;
  801d72:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801d79:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d86:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d8a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801d90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d94:	c7 04 24 17 1d 80 00 	movl   $0x801d17,(%esp)
  801d9b:	e8 7e e8 ff ff       	call   80061e <vprintfmt>
	if (b.idx > 0)
  801da0:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801da7:	7e 0b                	jle    801db4 <vfprintf+0x68>
		writebuf(&b);
  801da9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801daf:	e8 1d ff ff ff       	call   801cd1 <writebuf>

	return (b.result ? b.result : b.error);
  801db4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801dba:	85 c0                	test   %eax,%eax
  801dbc:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801dcb:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801dce:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	89 04 24             	mov    %eax,(%esp)
  801ddf:	e8 68 ff ff ff       	call   801d4c <vfprintf>
	va_end(ap);

	return cnt;
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <printf>:

int
printf(const char *fmt, ...)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801dec:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801def:	89 44 24 08          	mov    %eax,0x8(%esp)
  801df3:	8b 45 08             	mov    0x8(%ebp),%eax
  801df6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801e01:	e8 46 ff ff ff       	call   801d4c <vfprintf>
	va_end(ap);

	return cnt;
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    
  801e08:	66 90                	xchg   %ax,%ax
  801e0a:	66 90                	xchg   %ax,%ax
  801e0c:	66 90                	xchg   %ax,%ax
  801e0e:	66 90                	xchg   %ax,%ax

00801e10 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e16:	c7 44 24 04 1b 31 80 	movl   $0x80311b,0x4(%esp)
  801e1d:	00 
  801e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e21:	89 04 24             	mov    %eax,(%esp)
  801e24:	e8 8e ec ff ff       	call   800ab7 <strcpy>
	return 0;
}
  801e29:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	53                   	push   %ebx
  801e34:	83 ec 14             	sub    $0x14,%esp
  801e37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e3a:	89 1c 24             	mov    %ebx,(%esp)
  801e3d:	e8 0c 0b 00 00       	call   80294e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801e42:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801e47:	83 f8 01             	cmp    $0x1,%eax
  801e4a:	75 0d                	jne    801e59 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801e4c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e4f:	89 04 24             	mov    %eax,(%esp)
  801e52:	e8 29 03 00 00       	call   802180 <nsipc_close>
  801e57:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801e59:	89 d0                	mov    %edx,%eax
  801e5b:	83 c4 14             	add    $0x14,%esp
  801e5e:	5b                   	pop    %ebx
  801e5f:	5d                   	pop    %ebp
  801e60:	c3                   	ret    

00801e61 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e67:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e6e:	00 
  801e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e72:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	8b 40 0c             	mov    0xc(%eax),%eax
  801e83:	89 04 24             	mov    %eax,(%esp)
  801e86:	e8 f0 03 00 00       	call   80227b <nsipc_send>
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e93:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e9a:	00 
  801e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	8b 40 0c             	mov    0xc(%eax),%eax
  801eaf:	89 04 24             	mov    %eax,(%esp)
  801eb2:	e8 44 03 00 00       	call   8021fb <nsipc_recv>
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ebf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ec2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ec6:	89 04 24             	mov    %eax,(%esp)
  801ec9:	e8 08 f6 ff ff       	call   8014d6 <fd_lookup>
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	78 17                	js     801ee9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801edb:	39 08                	cmp    %ecx,(%eax)
  801edd:	75 05                	jne    801ee4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801edf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee2:	eb 05                	jmp    801ee9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ee4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	56                   	push   %esi
  801eef:	53                   	push   %ebx
  801ef0:	83 ec 20             	sub    $0x20,%esp
  801ef3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ef5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef8:	89 04 24             	mov    %eax,(%esp)
  801efb:	e8 87 f5 ff ff       	call   801487 <fd_alloc>
  801f00:	89 c3                	mov    %eax,%ebx
  801f02:	85 c0                	test   %eax,%eax
  801f04:	78 21                	js     801f27 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f06:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f0d:	00 
  801f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f11:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f1c:	e8 b2 ef ff ff       	call   800ed3 <sys_page_alloc>
  801f21:	89 c3                	mov    %eax,%ebx
  801f23:	85 c0                	test   %eax,%eax
  801f25:	79 0c                	jns    801f33 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801f27:	89 34 24             	mov    %esi,(%esp)
  801f2a:	e8 51 02 00 00       	call   802180 <nsipc_close>
		return r;
  801f2f:	89 d8                	mov    %ebx,%eax
  801f31:	eb 20                	jmp    801f53 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f33:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f41:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801f48:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801f4b:	89 14 24             	mov    %edx,(%esp)
  801f4e:	e8 0d f5 ff ff       	call   801460 <fd2num>
}
  801f53:	83 c4 20             	add    $0x20,%esp
  801f56:	5b                   	pop    %ebx
  801f57:	5e                   	pop    %esi
  801f58:	5d                   	pop    %ebp
  801f59:	c3                   	ret    

00801f5a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	e8 51 ff ff ff       	call   801eb9 <fd2sockid>
		return r;
  801f68:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	78 23                	js     801f91 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f6e:	8b 55 10             	mov    0x10(%ebp),%edx
  801f71:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f78:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f7c:	89 04 24             	mov    %eax,(%esp)
  801f7f:	e8 45 01 00 00       	call   8020c9 <nsipc_accept>
		return r;
  801f84:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f86:	85 c0                	test   %eax,%eax
  801f88:	78 07                	js     801f91 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801f8a:	e8 5c ff ff ff       	call   801eeb <alloc_sockfd>
  801f8f:	89 c1                	mov    %eax,%ecx
}
  801f91:	89 c8                	mov    %ecx,%eax
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	e8 16 ff ff ff       	call   801eb9 <fd2sockid>
  801fa3:	89 c2                	mov    %eax,%edx
  801fa5:	85 d2                	test   %edx,%edx
  801fa7:	78 16                	js     801fbf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fac:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fb7:	89 14 24             	mov    %edx,(%esp)
  801fba:	e8 60 01 00 00       	call   80211f <nsipc_bind>
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <shutdown>:

int
shutdown(int s, int how)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	e8 ea fe ff ff       	call   801eb9 <fd2sockid>
  801fcf:	89 c2                	mov    %eax,%edx
  801fd1:	85 d2                	test   %edx,%edx
  801fd3:	78 0f                	js     801fe4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fdc:	89 14 24             	mov    %edx,(%esp)
  801fdf:	e8 7a 01 00 00       	call   80215e <nsipc_shutdown>
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fec:	8b 45 08             	mov    0x8(%ebp),%eax
  801fef:	e8 c5 fe ff ff       	call   801eb9 <fd2sockid>
  801ff4:	89 c2                	mov    %eax,%edx
  801ff6:	85 d2                	test   %edx,%edx
  801ff8:	78 16                	js     802010 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  801ffd:	89 44 24 08          	mov    %eax,0x8(%esp)
  802001:	8b 45 0c             	mov    0xc(%ebp),%eax
  802004:	89 44 24 04          	mov    %eax,0x4(%esp)
  802008:	89 14 24             	mov    %edx,(%esp)
  80200b:	e8 8a 01 00 00       	call   80219a <nsipc_connect>
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <listen>:

int
listen(int s, int backlog)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	e8 99 fe ff ff       	call   801eb9 <fd2sockid>
  802020:	89 c2                	mov    %eax,%edx
  802022:	85 d2                	test   %edx,%edx
  802024:	78 0f                	js     802035 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802026:	8b 45 0c             	mov    0xc(%ebp),%eax
  802029:	89 44 24 04          	mov    %eax,0x4(%esp)
  80202d:	89 14 24             	mov    %edx,(%esp)
  802030:	e8 a4 01 00 00       	call   8021d9 <nsipc_listen>
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80203d:	8b 45 10             	mov    0x10(%ebp),%eax
  802040:	89 44 24 08          	mov    %eax,0x8(%esp)
  802044:	8b 45 0c             	mov    0xc(%ebp),%eax
  802047:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	89 04 24             	mov    %eax,(%esp)
  802051:	e8 98 02 00 00       	call   8022ee <nsipc_socket>
  802056:	89 c2                	mov    %eax,%edx
  802058:	85 d2                	test   %edx,%edx
  80205a:	78 05                	js     802061 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80205c:	e8 8a fe ff ff       	call   801eeb <alloc_sockfd>
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	53                   	push   %ebx
  802067:	83 ec 14             	sub    $0x14,%esp
  80206a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80206c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802073:	75 11                	jne    802086 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802075:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80207c:	e8 8e 08 00 00       	call   80290f <ipc_find_env>
  802081:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802086:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80208d:	00 
  80208e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802095:	00 
  802096:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80209a:	a1 04 50 80 00       	mov    0x805004,%eax
  80209f:	89 04 24             	mov    %eax,(%esp)
  8020a2:	e8 fd 07 00 00       	call   8028a4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020ae:	00 
  8020af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020b6:	00 
  8020b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020be:	e8 8d 07 00 00       	call   802850 <ipc_recv>
}
  8020c3:	83 c4 14             	add    $0x14,%esp
  8020c6:	5b                   	pop    %ebx
  8020c7:	5d                   	pop    %ebp
  8020c8:	c3                   	ret    

008020c9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	56                   	push   %esi
  8020cd:	53                   	push   %ebx
  8020ce:	83 ec 10             	sub    $0x10,%esp
  8020d1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020dc:	8b 06                	mov    (%esi),%eax
  8020de:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e8:	e8 76 ff ff ff       	call   802063 <nsipc>
  8020ed:	89 c3                	mov    %eax,%ebx
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	78 23                	js     802116 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020f3:	a1 10 70 80 00       	mov    0x807010,%eax
  8020f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020fc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802103:	00 
  802104:	8b 45 0c             	mov    0xc(%ebp),%eax
  802107:	89 04 24             	mov    %eax,(%esp)
  80210a:	e8 45 eb ff ff       	call   800c54 <memmove>
		*addrlen = ret->ret_addrlen;
  80210f:	a1 10 70 80 00       	mov    0x807010,%eax
  802114:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802116:	89 d8                	mov    %ebx,%eax
  802118:	83 c4 10             	add    $0x10,%esp
  80211b:	5b                   	pop    %ebx
  80211c:	5e                   	pop    %esi
  80211d:	5d                   	pop    %ebp
  80211e:	c3                   	ret    

0080211f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	53                   	push   %ebx
  802123:	83 ec 14             	sub    $0x14,%esp
  802126:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802131:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802135:	8b 45 0c             	mov    0xc(%ebp),%eax
  802138:	89 44 24 04          	mov    %eax,0x4(%esp)
  80213c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802143:	e8 0c eb ff ff       	call   800c54 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802148:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80214e:	b8 02 00 00 00       	mov    $0x2,%eax
  802153:	e8 0b ff ff ff       	call   802063 <nsipc>
}
  802158:	83 c4 14             	add    $0x14,%esp
  80215b:	5b                   	pop    %ebx
  80215c:	5d                   	pop    %ebp
  80215d:	c3                   	ret    

0080215e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80216c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802174:	b8 03 00 00 00       	mov    $0x3,%eax
  802179:	e8 e5 fe ff ff       	call   802063 <nsipc>
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <nsipc_close>:

int
nsipc_close(int s)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80218e:	b8 04 00 00 00       	mov    $0x4,%eax
  802193:	e8 cb fe ff ff       	call   802063 <nsipc>
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	53                   	push   %ebx
  80219e:	83 ec 14             	sub    $0x14,%esp
  8021a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021ac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8021be:	e8 91 ea ff ff       	call   800c54 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021c3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021c9:	b8 05 00 00 00       	mov    $0x5,%eax
  8021ce:	e8 90 fe ff ff       	call   802063 <nsipc>
}
  8021d3:	83 c4 14             	add    $0x14,%esp
  8021d6:	5b                   	pop    %ebx
  8021d7:	5d                   	pop    %ebp
  8021d8:	c3                   	ret    

008021d9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ea:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8021f4:	e8 6a fe ff ff       	call   802063 <nsipc>
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	56                   	push   %esi
  8021ff:	53                   	push   %ebx
  802200:	83 ec 10             	sub    $0x10,%esp
  802203:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80220e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802214:	8b 45 14             	mov    0x14(%ebp),%eax
  802217:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80221c:	b8 07 00 00 00       	mov    $0x7,%eax
  802221:	e8 3d fe ff ff       	call   802063 <nsipc>
  802226:	89 c3                	mov    %eax,%ebx
  802228:	85 c0                	test   %eax,%eax
  80222a:	78 46                	js     802272 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80222c:	39 f0                	cmp    %esi,%eax
  80222e:	7f 07                	jg     802237 <nsipc_recv+0x3c>
  802230:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802235:	7e 24                	jle    80225b <nsipc_recv+0x60>
  802237:	c7 44 24 0c 27 31 80 	movl   $0x803127,0xc(%esp)
  80223e:	00 
  80223f:	c7 44 24 08 ef 30 80 	movl   $0x8030ef,0x8(%esp)
  802246:	00 
  802247:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80224e:	00 
  80224f:	c7 04 24 3c 31 80 00 	movl   $0x80313c,(%esp)
  802256:	e8 35 e1 ff ff       	call   800390 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80225b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80225f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802266:	00 
  802267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226a:	89 04 24             	mov    %eax,(%esp)
  80226d:	e8 e2 e9 ff ff       	call   800c54 <memmove>
	}

	return r;
}
  802272:	89 d8                	mov    %ebx,%eax
  802274:	83 c4 10             	add    $0x10,%esp
  802277:	5b                   	pop    %ebx
  802278:	5e                   	pop    %esi
  802279:	5d                   	pop    %ebp
  80227a:	c3                   	ret    

0080227b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	53                   	push   %ebx
  80227f:	83 ec 14             	sub    $0x14,%esp
  802282:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80228d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802293:	7e 24                	jle    8022b9 <nsipc_send+0x3e>
  802295:	c7 44 24 0c 48 31 80 	movl   $0x803148,0xc(%esp)
  80229c:	00 
  80229d:	c7 44 24 08 ef 30 80 	movl   $0x8030ef,0x8(%esp)
  8022a4:	00 
  8022a5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8022ac:	00 
  8022ad:	c7 04 24 3c 31 80 00 	movl   $0x80313c,(%esp)
  8022b4:	e8 d7 e0 ff ff       	call   800390 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8022cb:	e8 84 e9 ff ff       	call   800c54 <memmove>
	nsipcbuf.send.req_size = size;
  8022d0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022de:	b8 08 00 00 00       	mov    $0x8,%eax
  8022e3:	e8 7b fd ff ff       	call   802063 <nsipc>
}
  8022e8:	83 c4 14             	add    $0x14,%esp
  8022eb:	5b                   	pop    %ebx
  8022ec:	5d                   	pop    %ebp
  8022ed:	c3                   	ret    

008022ee <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ff:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802304:	8b 45 10             	mov    0x10(%ebp),%eax
  802307:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80230c:	b8 09 00 00 00       	mov    $0x9,%eax
  802311:	e8 4d fd ff ff       	call   802063 <nsipc>
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
  80231b:	56                   	push   %esi
  80231c:	53                   	push   %ebx
  80231d:	83 ec 10             	sub    $0x10,%esp
  802320:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	89 04 24             	mov    %eax,(%esp)
  802329:	e8 42 f1 ff ff       	call   801470 <fd2data>
  80232e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802330:	c7 44 24 04 54 31 80 	movl   $0x803154,0x4(%esp)
  802337:	00 
  802338:	89 1c 24             	mov    %ebx,(%esp)
  80233b:	e8 77 e7 ff ff       	call   800ab7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802340:	8b 46 04             	mov    0x4(%esi),%eax
  802343:	2b 06                	sub    (%esi),%eax
  802345:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80234b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802352:	00 00 00 
	stat->st_dev = &devpipe;
  802355:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80235c:	40 80 00 
	return 0;
}
  80235f:	b8 00 00 00 00       	mov    $0x0,%eax
  802364:	83 c4 10             	add    $0x10,%esp
  802367:	5b                   	pop    %ebx
  802368:	5e                   	pop    %esi
  802369:	5d                   	pop    %ebp
  80236a:	c3                   	ret    

0080236b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	53                   	push   %ebx
  80236f:	83 ec 14             	sub    $0x14,%esp
  802372:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802375:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802379:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802380:	e8 f5 eb ff ff       	call   800f7a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802385:	89 1c 24             	mov    %ebx,(%esp)
  802388:	e8 e3 f0 ff ff       	call   801470 <fd2data>
  80238d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802391:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802398:	e8 dd eb ff ff       	call   800f7a <sys_page_unmap>
}
  80239d:	83 c4 14             	add    $0x14,%esp
  8023a0:	5b                   	pop    %ebx
  8023a1:	5d                   	pop    %ebp
  8023a2:	c3                   	ret    

008023a3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	57                   	push   %edi
  8023a7:	56                   	push   %esi
  8023a8:	53                   	push   %ebx
  8023a9:	83 ec 2c             	sub    $0x2c,%esp
  8023ac:	89 c6                	mov    %eax,%esi
  8023ae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8023b1:	a1 20 54 80 00       	mov    0x805420,%eax
  8023b6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023b9:	89 34 24             	mov    %esi,(%esp)
  8023bc:	e8 8d 05 00 00       	call   80294e <pageref>
  8023c1:	89 c7                	mov    %eax,%edi
  8023c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023c6:	89 04 24             	mov    %eax,(%esp)
  8023c9:	e8 80 05 00 00       	call   80294e <pageref>
  8023ce:	39 c7                	cmp    %eax,%edi
  8023d0:	0f 94 c2             	sete   %dl
  8023d3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8023d6:	8b 0d 20 54 80 00    	mov    0x805420,%ecx
  8023dc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8023df:	39 fb                	cmp    %edi,%ebx
  8023e1:	74 21                	je     802404 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8023e3:	84 d2                	test   %dl,%dl
  8023e5:	74 ca                	je     8023b1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023e7:	8b 51 58             	mov    0x58(%ecx),%edx
  8023ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023ee:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023f6:	c7 04 24 5b 31 80 00 	movl   $0x80315b,(%esp)
  8023fd:	e8 87 e0 ff ff       	call   800489 <cprintf>
  802402:	eb ad                	jmp    8023b1 <_pipeisclosed+0xe>
	}
}
  802404:	83 c4 2c             	add    $0x2c,%esp
  802407:	5b                   	pop    %ebx
  802408:	5e                   	pop    %esi
  802409:	5f                   	pop    %edi
  80240a:	5d                   	pop    %ebp
  80240b:	c3                   	ret    

0080240c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	57                   	push   %edi
  802410:	56                   	push   %esi
  802411:	53                   	push   %ebx
  802412:	83 ec 1c             	sub    $0x1c,%esp
  802415:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802418:	89 34 24             	mov    %esi,(%esp)
  80241b:	e8 50 f0 ff ff       	call   801470 <fd2data>
  802420:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802422:	bf 00 00 00 00       	mov    $0x0,%edi
  802427:	eb 45                	jmp    80246e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802429:	89 da                	mov    %ebx,%edx
  80242b:	89 f0                	mov    %esi,%eax
  80242d:	e8 71 ff ff ff       	call   8023a3 <_pipeisclosed>
  802432:	85 c0                	test   %eax,%eax
  802434:	75 41                	jne    802477 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802436:	e8 79 ea ff ff       	call   800eb4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80243b:	8b 43 04             	mov    0x4(%ebx),%eax
  80243e:	8b 0b                	mov    (%ebx),%ecx
  802440:	8d 51 20             	lea    0x20(%ecx),%edx
  802443:	39 d0                	cmp    %edx,%eax
  802445:	73 e2                	jae    802429 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802447:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80244a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80244e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802451:	99                   	cltd   
  802452:	c1 ea 1b             	shr    $0x1b,%edx
  802455:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802458:	83 e1 1f             	and    $0x1f,%ecx
  80245b:	29 d1                	sub    %edx,%ecx
  80245d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802461:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802465:	83 c0 01             	add    $0x1,%eax
  802468:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80246b:	83 c7 01             	add    $0x1,%edi
  80246e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802471:	75 c8                	jne    80243b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802473:	89 f8                	mov    %edi,%eax
  802475:	eb 05                	jmp    80247c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802477:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80247c:	83 c4 1c             	add    $0x1c,%esp
  80247f:	5b                   	pop    %ebx
  802480:	5e                   	pop    %esi
  802481:	5f                   	pop    %edi
  802482:	5d                   	pop    %ebp
  802483:	c3                   	ret    

00802484 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
  802487:	57                   	push   %edi
  802488:	56                   	push   %esi
  802489:	53                   	push   %ebx
  80248a:	83 ec 1c             	sub    $0x1c,%esp
  80248d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802490:	89 3c 24             	mov    %edi,(%esp)
  802493:	e8 d8 ef ff ff       	call   801470 <fd2data>
  802498:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80249a:	be 00 00 00 00       	mov    $0x0,%esi
  80249f:	eb 3d                	jmp    8024de <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8024a1:	85 f6                	test   %esi,%esi
  8024a3:	74 04                	je     8024a9 <devpipe_read+0x25>
				return i;
  8024a5:	89 f0                	mov    %esi,%eax
  8024a7:	eb 43                	jmp    8024ec <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8024a9:	89 da                	mov    %ebx,%edx
  8024ab:	89 f8                	mov    %edi,%eax
  8024ad:	e8 f1 fe ff ff       	call   8023a3 <_pipeisclosed>
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	75 31                	jne    8024e7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8024b6:	e8 f9 e9 ff ff       	call   800eb4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8024bb:	8b 03                	mov    (%ebx),%eax
  8024bd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024c0:	74 df                	je     8024a1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024c2:	99                   	cltd   
  8024c3:	c1 ea 1b             	shr    $0x1b,%edx
  8024c6:	01 d0                	add    %edx,%eax
  8024c8:	83 e0 1f             	and    $0x1f,%eax
  8024cb:	29 d0                	sub    %edx,%eax
  8024cd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024d5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024d8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024db:	83 c6 01             	add    $0x1,%esi
  8024de:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024e1:	75 d8                	jne    8024bb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8024e3:	89 f0                	mov    %esi,%eax
  8024e5:	eb 05                	jmp    8024ec <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024e7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8024ec:	83 c4 1c             	add    $0x1c,%esp
  8024ef:	5b                   	pop    %ebx
  8024f0:	5e                   	pop    %esi
  8024f1:	5f                   	pop    %edi
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    

008024f4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
  8024f7:	56                   	push   %esi
  8024f8:	53                   	push   %ebx
  8024f9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8024fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ff:	89 04 24             	mov    %eax,(%esp)
  802502:	e8 80 ef ff ff       	call   801487 <fd_alloc>
  802507:	89 c2                	mov    %eax,%edx
  802509:	85 d2                	test   %edx,%edx
  80250b:	0f 88 4d 01 00 00    	js     80265e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802511:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802518:	00 
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802520:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802527:	e8 a7 e9 ff ff       	call   800ed3 <sys_page_alloc>
  80252c:	89 c2                	mov    %eax,%edx
  80252e:	85 d2                	test   %edx,%edx
  802530:	0f 88 28 01 00 00    	js     80265e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802536:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802539:	89 04 24             	mov    %eax,(%esp)
  80253c:	e8 46 ef ff ff       	call   801487 <fd_alloc>
  802541:	89 c3                	mov    %eax,%ebx
  802543:	85 c0                	test   %eax,%eax
  802545:	0f 88 fe 00 00 00    	js     802649 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80254b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802552:	00 
  802553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802556:	89 44 24 04          	mov    %eax,0x4(%esp)
  80255a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802561:	e8 6d e9 ff ff       	call   800ed3 <sys_page_alloc>
  802566:	89 c3                	mov    %eax,%ebx
  802568:	85 c0                	test   %eax,%eax
  80256a:	0f 88 d9 00 00 00    	js     802649 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	89 04 24             	mov    %eax,(%esp)
  802576:	e8 f5 ee ff ff       	call   801470 <fd2data>
  80257b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80257d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802584:	00 
  802585:	89 44 24 04          	mov    %eax,0x4(%esp)
  802589:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802590:	e8 3e e9 ff ff       	call   800ed3 <sys_page_alloc>
  802595:	89 c3                	mov    %eax,%ebx
  802597:	85 c0                	test   %eax,%eax
  802599:	0f 88 97 00 00 00    	js     802636 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80259f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a2:	89 04 24             	mov    %eax,(%esp)
  8025a5:	e8 c6 ee ff ff       	call   801470 <fd2data>
  8025aa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8025b1:	00 
  8025b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8025bd:	00 
  8025be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c9:	e8 59 e9 ff ff       	call   800f27 <sys_page_map>
  8025ce:	89 c3                	mov    %eax,%ebx
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	78 52                	js     802626 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8025d4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8025e9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8025f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	89 04 24             	mov    %eax,(%esp)
  802604:	e8 57 ee ff ff       	call   801460 <fd2num>
  802609:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80260c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80260e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802611:	89 04 24             	mov    %eax,(%esp)
  802614:	e8 47 ee ff ff       	call   801460 <fd2num>
  802619:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80261c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80261f:	b8 00 00 00 00       	mov    $0x0,%eax
  802624:	eb 38                	jmp    80265e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802626:	89 74 24 04          	mov    %esi,0x4(%esp)
  80262a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802631:	e8 44 e9 ff ff       	call   800f7a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802639:	89 44 24 04          	mov    %eax,0x4(%esp)
  80263d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802644:	e8 31 e9 ff ff       	call   800f7a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802650:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802657:	e8 1e e9 ff ff       	call   800f7a <sys_page_unmap>
  80265c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80265e:	83 c4 30             	add    $0x30,%esp
  802661:	5b                   	pop    %ebx
  802662:	5e                   	pop    %esi
  802663:	5d                   	pop    %ebp
  802664:	c3                   	ret    

00802665 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80266b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80266e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	89 04 24             	mov    %eax,(%esp)
  802678:	e8 59 ee ff ff       	call   8014d6 <fd_lookup>
  80267d:	89 c2                	mov    %eax,%edx
  80267f:	85 d2                	test   %edx,%edx
  802681:	78 15                	js     802698 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	89 04 24             	mov    %eax,(%esp)
  802689:	e8 e2 ed ff ff       	call   801470 <fd2data>
	return _pipeisclosed(fd, p);
  80268e:	89 c2                	mov    %eax,%edx
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	e8 0b fd ff ff       	call   8023a3 <_pipeisclosed>
}
  802698:	c9                   	leave  
  802699:	c3                   	ret    
  80269a:	66 90                	xchg   %ax,%ax
  80269c:	66 90                	xchg   %ax,%ax
  80269e:	66 90                	xchg   %ax,%ax

008026a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8026a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a8:	5d                   	pop    %ebp
  8026a9:	c3                   	ret    

008026aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
  8026ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8026b0:	c7 44 24 04 73 31 80 	movl   $0x803173,0x4(%esp)
  8026b7:	00 
  8026b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026bb:	89 04 24             	mov    %eax,(%esp)
  8026be:	e8 f4 e3 ff ff       	call   800ab7 <strcpy>
	return 0;
}
  8026c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    

008026ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
  8026cd:	57                   	push   %edi
  8026ce:	56                   	push   %esi
  8026cf:	53                   	push   %ebx
  8026d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026db:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026e1:	eb 31                	jmp    802714 <devcons_write+0x4a>
		m = n - tot;
  8026e3:	8b 75 10             	mov    0x10(%ebp),%esi
  8026e6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8026e8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8026eb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8026f0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026f3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8026f7:	03 45 0c             	add    0xc(%ebp),%eax
  8026fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026fe:	89 3c 24             	mov    %edi,(%esp)
  802701:	e8 4e e5 ff ff       	call   800c54 <memmove>
		sys_cputs(buf, m);
  802706:	89 74 24 04          	mov    %esi,0x4(%esp)
  80270a:	89 3c 24             	mov    %edi,(%esp)
  80270d:	e8 f4 e6 ff ff       	call   800e06 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802712:	01 f3                	add    %esi,%ebx
  802714:	89 d8                	mov    %ebx,%eax
  802716:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802719:	72 c8                	jb     8026e3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80271b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802721:	5b                   	pop    %ebx
  802722:	5e                   	pop    %esi
  802723:	5f                   	pop    %edi
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    

00802726 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802731:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802735:	75 07                	jne    80273e <devcons_read+0x18>
  802737:	eb 2a                	jmp    802763 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802739:	e8 76 e7 ff ff       	call   800eb4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80273e:	66 90                	xchg   %ax,%ax
  802740:	e8 df e6 ff ff       	call   800e24 <sys_cgetc>
  802745:	85 c0                	test   %eax,%eax
  802747:	74 f0                	je     802739 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802749:	85 c0                	test   %eax,%eax
  80274b:	78 16                	js     802763 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80274d:	83 f8 04             	cmp    $0x4,%eax
  802750:	74 0c                	je     80275e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802752:	8b 55 0c             	mov    0xc(%ebp),%edx
  802755:	88 02                	mov    %al,(%edx)
	return 1;
  802757:	b8 01 00 00 00       	mov    $0x1,%eax
  80275c:	eb 05                	jmp    802763 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80275e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802763:	c9                   	leave  
  802764:	c3                   	ret    

00802765 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802765:	55                   	push   %ebp
  802766:	89 e5                	mov    %esp,%ebp
  802768:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80276b:	8b 45 08             	mov    0x8(%ebp),%eax
  80276e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802771:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802778:	00 
  802779:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80277c:	89 04 24             	mov    %eax,(%esp)
  80277f:	e8 82 e6 ff ff       	call   800e06 <sys_cputs>
}
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <getchar>:

int
getchar(void)
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
  802789:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80278c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802793:	00 
  802794:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802797:	89 44 24 04          	mov    %eax,0x4(%esp)
  80279b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027a2:	e8 c3 ef ff ff       	call   80176a <read>
	if (r < 0)
  8027a7:	85 c0                	test   %eax,%eax
  8027a9:	78 0f                	js     8027ba <getchar+0x34>
		return r;
	if (r < 1)
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	7e 06                	jle    8027b5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8027af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8027b3:	eb 05                	jmp    8027ba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8027b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8027ba:	c9                   	leave  
  8027bb:	c3                   	ret    

008027bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8027bc:	55                   	push   %ebp
  8027bd:	89 e5                	mov    %esp,%ebp
  8027bf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cc:	89 04 24             	mov    %eax,(%esp)
  8027cf:	e8 02 ed ff ff       	call   8014d6 <fd_lookup>
  8027d4:	85 c0                	test   %eax,%eax
  8027d6:	78 11                	js     8027e9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027e1:	39 10                	cmp    %edx,(%eax)
  8027e3:	0f 94 c0             	sete   %al
  8027e6:	0f b6 c0             	movzbl %al,%eax
}
  8027e9:	c9                   	leave  
  8027ea:	c3                   	ret    

008027eb <opencons>:

int
opencons(void)
{
  8027eb:	55                   	push   %ebp
  8027ec:	89 e5                	mov    %esp,%ebp
  8027ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8027f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027f4:	89 04 24             	mov    %eax,(%esp)
  8027f7:	e8 8b ec ff ff       	call   801487 <fd_alloc>
		return r;
  8027fc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8027fe:	85 c0                	test   %eax,%eax
  802800:	78 40                	js     802842 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802802:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802809:	00 
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802811:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802818:	e8 b6 e6 ff ff       	call   800ed3 <sys_page_alloc>
		return r;
  80281d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80281f:	85 c0                	test   %eax,%eax
  802821:	78 1f                	js     802842 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802823:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802838:	89 04 24             	mov    %eax,(%esp)
  80283b:	e8 20 ec ff ff       	call   801460 <fd2num>
  802840:	89 c2                	mov    %eax,%edx
}
  802842:	89 d0                	mov    %edx,%eax
  802844:	c9                   	leave  
  802845:	c3                   	ret    
  802846:	66 90                	xchg   %ax,%ax
  802848:	66 90                	xchg   %ax,%ax
  80284a:	66 90                	xchg   %ax,%ax
  80284c:	66 90                	xchg   %ax,%ax
  80284e:	66 90                	xchg   %ax,%ax

00802850 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802850:	55                   	push   %ebp
  802851:	89 e5                	mov    %esp,%ebp
  802853:	56                   	push   %esi
  802854:	53                   	push   %ebx
  802855:	83 ec 10             	sub    $0x10,%esp
  802858:	8b 75 08             	mov    0x8(%ebp),%esi
  80285b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80285e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802861:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802863:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802868:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80286b:	89 04 24             	mov    %eax,(%esp)
  80286e:	e8 76 e8 ff ff       	call   8010e9 <sys_ipc_recv>
  802873:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802875:	85 d2                	test   %edx,%edx
  802877:	75 24                	jne    80289d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802879:	85 f6                	test   %esi,%esi
  80287b:	74 0a                	je     802887 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80287d:	a1 20 54 80 00       	mov    0x805420,%eax
  802882:	8b 40 74             	mov    0x74(%eax),%eax
  802885:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802887:	85 db                	test   %ebx,%ebx
  802889:	74 0a                	je     802895 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80288b:	a1 20 54 80 00       	mov    0x805420,%eax
  802890:	8b 40 78             	mov    0x78(%eax),%eax
  802893:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802895:	a1 20 54 80 00       	mov    0x805420,%eax
  80289a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80289d:	83 c4 10             	add    $0x10,%esp
  8028a0:	5b                   	pop    %ebx
  8028a1:	5e                   	pop    %esi
  8028a2:	5d                   	pop    %ebp
  8028a3:	c3                   	ret    

008028a4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028a4:	55                   	push   %ebp
  8028a5:	89 e5                	mov    %esp,%ebp
  8028a7:	57                   	push   %edi
  8028a8:	56                   	push   %esi
  8028a9:	53                   	push   %ebx
  8028aa:	83 ec 1c             	sub    $0x1c,%esp
  8028ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8028b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  8028b6:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  8028b8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8028bd:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8028c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8028c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028cf:	89 3c 24             	mov    %edi,(%esp)
  8028d2:	e8 ef e7 ff ff       	call   8010c6 <sys_ipc_try_send>

		if (ret == 0)
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	74 2c                	je     802907 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  8028db:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028de:	74 20                	je     802900 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  8028e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028e4:	c7 44 24 08 80 31 80 	movl   $0x803180,0x8(%esp)
  8028eb:	00 
  8028ec:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8028f3:	00 
  8028f4:	c7 04 24 b0 31 80 00 	movl   $0x8031b0,(%esp)
  8028fb:	e8 90 da ff ff       	call   800390 <_panic>
		}

		sys_yield();
  802900:	e8 af e5 ff ff       	call   800eb4 <sys_yield>
	}
  802905:	eb b9                	jmp    8028c0 <ipc_send+0x1c>
}
  802907:	83 c4 1c             	add    $0x1c,%esp
  80290a:	5b                   	pop    %ebx
  80290b:	5e                   	pop    %esi
  80290c:	5f                   	pop    %edi
  80290d:	5d                   	pop    %ebp
  80290e:	c3                   	ret    

0080290f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80290f:	55                   	push   %ebp
  802910:	89 e5                	mov    %esp,%ebp
  802912:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802915:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80291a:	89 c2                	mov    %eax,%edx
  80291c:	c1 e2 07             	shl    $0x7,%edx
  80291f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802926:	8b 52 50             	mov    0x50(%edx),%edx
  802929:	39 ca                	cmp    %ecx,%edx
  80292b:	75 11                	jne    80293e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80292d:	89 c2                	mov    %eax,%edx
  80292f:	c1 e2 07             	shl    $0x7,%edx
  802932:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802939:	8b 40 40             	mov    0x40(%eax),%eax
  80293c:	eb 0e                	jmp    80294c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80293e:	83 c0 01             	add    $0x1,%eax
  802941:	3d 00 04 00 00       	cmp    $0x400,%eax
  802946:	75 d2                	jne    80291a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802948:	66 b8 00 00          	mov    $0x0,%ax
}
  80294c:	5d                   	pop    %ebp
  80294d:	c3                   	ret    

0080294e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
  802951:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802954:	89 d0                	mov    %edx,%eax
  802956:	c1 e8 16             	shr    $0x16,%eax
  802959:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802960:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802965:	f6 c1 01             	test   $0x1,%cl
  802968:	74 1d                	je     802987 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80296a:	c1 ea 0c             	shr    $0xc,%edx
  80296d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802974:	f6 c2 01             	test   $0x1,%dl
  802977:	74 0e                	je     802987 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802979:	c1 ea 0c             	shr    $0xc,%edx
  80297c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802983:	ef 
  802984:	0f b7 c0             	movzwl %ax,%eax
}
  802987:	5d                   	pop    %ebp
  802988:	c3                   	ret    
  802989:	66 90                	xchg   %ax,%ax
  80298b:	66 90                	xchg   %ax,%ax
  80298d:	66 90                	xchg   %ax,%ax
  80298f:	90                   	nop

00802990 <__udivdi3>:
  802990:	55                   	push   %ebp
  802991:	57                   	push   %edi
  802992:	56                   	push   %esi
  802993:	83 ec 0c             	sub    $0xc,%esp
  802996:	8b 44 24 28          	mov    0x28(%esp),%eax
  80299a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80299e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8029a2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8029ac:	89 ea                	mov    %ebp,%edx
  8029ae:	89 0c 24             	mov    %ecx,(%esp)
  8029b1:	75 2d                	jne    8029e0 <__udivdi3+0x50>
  8029b3:	39 e9                	cmp    %ebp,%ecx
  8029b5:	77 61                	ja     802a18 <__udivdi3+0x88>
  8029b7:	85 c9                	test   %ecx,%ecx
  8029b9:	89 ce                	mov    %ecx,%esi
  8029bb:	75 0b                	jne    8029c8 <__udivdi3+0x38>
  8029bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8029c2:	31 d2                	xor    %edx,%edx
  8029c4:	f7 f1                	div    %ecx
  8029c6:	89 c6                	mov    %eax,%esi
  8029c8:	31 d2                	xor    %edx,%edx
  8029ca:	89 e8                	mov    %ebp,%eax
  8029cc:	f7 f6                	div    %esi
  8029ce:	89 c5                	mov    %eax,%ebp
  8029d0:	89 f8                	mov    %edi,%eax
  8029d2:	f7 f6                	div    %esi
  8029d4:	89 ea                	mov    %ebp,%edx
  8029d6:	83 c4 0c             	add    $0xc,%esp
  8029d9:	5e                   	pop    %esi
  8029da:	5f                   	pop    %edi
  8029db:	5d                   	pop    %ebp
  8029dc:	c3                   	ret    
  8029dd:	8d 76 00             	lea    0x0(%esi),%esi
  8029e0:	39 e8                	cmp    %ebp,%eax
  8029e2:	77 24                	ja     802a08 <__udivdi3+0x78>
  8029e4:	0f bd e8             	bsr    %eax,%ebp
  8029e7:	83 f5 1f             	xor    $0x1f,%ebp
  8029ea:	75 3c                	jne    802a28 <__udivdi3+0x98>
  8029ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8029f0:	39 34 24             	cmp    %esi,(%esp)
  8029f3:	0f 86 9f 00 00 00    	jbe    802a98 <__udivdi3+0x108>
  8029f9:	39 d0                	cmp    %edx,%eax
  8029fb:	0f 82 97 00 00 00    	jb     802a98 <__udivdi3+0x108>
  802a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a08:	31 d2                	xor    %edx,%edx
  802a0a:	31 c0                	xor    %eax,%eax
  802a0c:	83 c4 0c             	add    $0xc,%esp
  802a0f:	5e                   	pop    %esi
  802a10:	5f                   	pop    %edi
  802a11:	5d                   	pop    %ebp
  802a12:	c3                   	ret    
  802a13:	90                   	nop
  802a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a18:	89 f8                	mov    %edi,%eax
  802a1a:	f7 f1                	div    %ecx
  802a1c:	31 d2                	xor    %edx,%edx
  802a1e:	83 c4 0c             	add    $0xc,%esp
  802a21:	5e                   	pop    %esi
  802a22:	5f                   	pop    %edi
  802a23:	5d                   	pop    %ebp
  802a24:	c3                   	ret    
  802a25:	8d 76 00             	lea    0x0(%esi),%esi
  802a28:	89 e9                	mov    %ebp,%ecx
  802a2a:	8b 3c 24             	mov    (%esp),%edi
  802a2d:	d3 e0                	shl    %cl,%eax
  802a2f:	89 c6                	mov    %eax,%esi
  802a31:	b8 20 00 00 00       	mov    $0x20,%eax
  802a36:	29 e8                	sub    %ebp,%eax
  802a38:	89 c1                	mov    %eax,%ecx
  802a3a:	d3 ef                	shr    %cl,%edi
  802a3c:	89 e9                	mov    %ebp,%ecx
  802a3e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802a42:	8b 3c 24             	mov    (%esp),%edi
  802a45:	09 74 24 08          	or     %esi,0x8(%esp)
  802a49:	89 d6                	mov    %edx,%esi
  802a4b:	d3 e7                	shl    %cl,%edi
  802a4d:	89 c1                	mov    %eax,%ecx
  802a4f:	89 3c 24             	mov    %edi,(%esp)
  802a52:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a56:	d3 ee                	shr    %cl,%esi
  802a58:	89 e9                	mov    %ebp,%ecx
  802a5a:	d3 e2                	shl    %cl,%edx
  802a5c:	89 c1                	mov    %eax,%ecx
  802a5e:	d3 ef                	shr    %cl,%edi
  802a60:	09 d7                	or     %edx,%edi
  802a62:	89 f2                	mov    %esi,%edx
  802a64:	89 f8                	mov    %edi,%eax
  802a66:	f7 74 24 08          	divl   0x8(%esp)
  802a6a:	89 d6                	mov    %edx,%esi
  802a6c:	89 c7                	mov    %eax,%edi
  802a6e:	f7 24 24             	mull   (%esp)
  802a71:	39 d6                	cmp    %edx,%esi
  802a73:	89 14 24             	mov    %edx,(%esp)
  802a76:	72 30                	jb     802aa8 <__udivdi3+0x118>
  802a78:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a7c:	89 e9                	mov    %ebp,%ecx
  802a7e:	d3 e2                	shl    %cl,%edx
  802a80:	39 c2                	cmp    %eax,%edx
  802a82:	73 05                	jae    802a89 <__udivdi3+0xf9>
  802a84:	3b 34 24             	cmp    (%esp),%esi
  802a87:	74 1f                	je     802aa8 <__udivdi3+0x118>
  802a89:	89 f8                	mov    %edi,%eax
  802a8b:	31 d2                	xor    %edx,%edx
  802a8d:	e9 7a ff ff ff       	jmp    802a0c <__udivdi3+0x7c>
  802a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a98:	31 d2                	xor    %edx,%edx
  802a9a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a9f:	e9 68 ff ff ff       	jmp    802a0c <__udivdi3+0x7c>
  802aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802aa8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802aab:	31 d2                	xor    %edx,%edx
  802aad:	83 c4 0c             	add    $0xc,%esp
  802ab0:	5e                   	pop    %esi
  802ab1:	5f                   	pop    %edi
  802ab2:	5d                   	pop    %ebp
  802ab3:	c3                   	ret    
  802ab4:	66 90                	xchg   %ax,%ax
  802ab6:	66 90                	xchg   %ax,%ax
  802ab8:	66 90                	xchg   %ax,%ax
  802aba:	66 90                	xchg   %ax,%ax
  802abc:	66 90                	xchg   %ax,%ax
  802abe:	66 90                	xchg   %ax,%ax

00802ac0 <__umoddi3>:
  802ac0:	55                   	push   %ebp
  802ac1:	57                   	push   %edi
  802ac2:	56                   	push   %esi
  802ac3:	83 ec 14             	sub    $0x14,%esp
  802ac6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802aca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802ace:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802ad2:	89 c7                	mov    %eax,%edi
  802ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ad8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802adc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ae0:	89 34 24             	mov    %esi,(%esp)
  802ae3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ae7:	85 c0                	test   %eax,%eax
  802ae9:	89 c2                	mov    %eax,%edx
  802aeb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aef:	75 17                	jne    802b08 <__umoddi3+0x48>
  802af1:	39 fe                	cmp    %edi,%esi
  802af3:	76 4b                	jbe    802b40 <__umoddi3+0x80>
  802af5:	89 c8                	mov    %ecx,%eax
  802af7:	89 fa                	mov    %edi,%edx
  802af9:	f7 f6                	div    %esi
  802afb:	89 d0                	mov    %edx,%eax
  802afd:	31 d2                	xor    %edx,%edx
  802aff:	83 c4 14             	add    $0x14,%esp
  802b02:	5e                   	pop    %esi
  802b03:	5f                   	pop    %edi
  802b04:	5d                   	pop    %ebp
  802b05:	c3                   	ret    
  802b06:	66 90                	xchg   %ax,%ax
  802b08:	39 f8                	cmp    %edi,%eax
  802b0a:	77 54                	ja     802b60 <__umoddi3+0xa0>
  802b0c:	0f bd e8             	bsr    %eax,%ebp
  802b0f:	83 f5 1f             	xor    $0x1f,%ebp
  802b12:	75 5c                	jne    802b70 <__umoddi3+0xb0>
  802b14:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802b18:	39 3c 24             	cmp    %edi,(%esp)
  802b1b:	0f 87 e7 00 00 00    	ja     802c08 <__umoddi3+0x148>
  802b21:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b25:	29 f1                	sub    %esi,%ecx
  802b27:	19 c7                	sbb    %eax,%edi
  802b29:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b31:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b35:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802b39:	83 c4 14             	add    $0x14,%esp
  802b3c:	5e                   	pop    %esi
  802b3d:	5f                   	pop    %edi
  802b3e:	5d                   	pop    %ebp
  802b3f:	c3                   	ret    
  802b40:	85 f6                	test   %esi,%esi
  802b42:	89 f5                	mov    %esi,%ebp
  802b44:	75 0b                	jne    802b51 <__umoddi3+0x91>
  802b46:	b8 01 00 00 00       	mov    $0x1,%eax
  802b4b:	31 d2                	xor    %edx,%edx
  802b4d:	f7 f6                	div    %esi
  802b4f:	89 c5                	mov    %eax,%ebp
  802b51:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b55:	31 d2                	xor    %edx,%edx
  802b57:	f7 f5                	div    %ebp
  802b59:	89 c8                	mov    %ecx,%eax
  802b5b:	f7 f5                	div    %ebp
  802b5d:	eb 9c                	jmp    802afb <__umoddi3+0x3b>
  802b5f:	90                   	nop
  802b60:	89 c8                	mov    %ecx,%eax
  802b62:	89 fa                	mov    %edi,%edx
  802b64:	83 c4 14             	add    $0x14,%esp
  802b67:	5e                   	pop    %esi
  802b68:	5f                   	pop    %edi
  802b69:	5d                   	pop    %ebp
  802b6a:	c3                   	ret    
  802b6b:	90                   	nop
  802b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b70:	8b 04 24             	mov    (%esp),%eax
  802b73:	be 20 00 00 00       	mov    $0x20,%esi
  802b78:	89 e9                	mov    %ebp,%ecx
  802b7a:	29 ee                	sub    %ebp,%esi
  802b7c:	d3 e2                	shl    %cl,%edx
  802b7e:	89 f1                	mov    %esi,%ecx
  802b80:	d3 e8                	shr    %cl,%eax
  802b82:	89 e9                	mov    %ebp,%ecx
  802b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b88:	8b 04 24             	mov    (%esp),%eax
  802b8b:	09 54 24 04          	or     %edx,0x4(%esp)
  802b8f:	89 fa                	mov    %edi,%edx
  802b91:	d3 e0                	shl    %cl,%eax
  802b93:	89 f1                	mov    %esi,%ecx
  802b95:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b99:	8b 44 24 10          	mov    0x10(%esp),%eax
  802b9d:	d3 ea                	shr    %cl,%edx
  802b9f:	89 e9                	mov    %ebp,%ecx
  802ba1:	d3 e7                	shl    %cl,%edi
  802ba3:	89 f1                	mov    %esi,%ecx
  802ba5:	d3 e8                	shr    %cl,%eax
  802ba7:	89 e9                	mov    %ebp,%ecx
  802ba9:	09 f8                	or     %edi,%eax
  802bab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802baf:	f7 74 24 04          	divl   0x4(%esp)
  802bb3:	d3 e7                	shl    %cl,%edi
  802bb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bb9:	89 d7                	mov    %edx,%edi
  802bbb:	f7 64 24 08          	mull   0x8(%esp)
  802bbf:	39 d7                	cmp    %edx,%edi
  802bc1:	89 c1                	mov    %eax,%ecx
  802bc3:	89 14 24             	mov    %edx,(%esp)
  802bc6:	72 2c                	jb     802bf4 <__umoddi3+0x134>
  802bc8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802bcc:	72 22                	jb     802bf0 <__umoddi3+0x130>
  802bce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802bd2:	29 c8                	sub    %ecx,%eax
  802bd4:	19 d7                	sbb    %edx,%edi
  802bd6:	89 e9                	mov    %ebp,%ecx
  802bd8:	89 fa                	mov    %edi,%edx
  802bda:	d3 e8                	shr    %cl,%eax
  802bdc:	89 f1                	mov    %esi,%ecx
  802bde:	d3 e2                	shl    %cl,%edx
  802be0:	89 e9                	mov    %ebp,%ecx
  802be2:	d3 ef                	shr    %cl,%edi
  802be4:	09 d0                	or     %edx,%eax
  802be6:	89 fa                	mov    %edi,%edx
  802be8:	83 c4 14             	add    $0x14,%esp
  802beb:	5e                   	pop    %esi
  802bec:	5f                   	pop    %edi
  802bed:	5d                   	pop    %ebp
  802bee:	c3                   	ret    
  802bef:	90                   	nop
  802bf0:	39 d7                	cmp    %edx,%edi
  802bf2:	75 da                	jne    802bce <__umoddi3+0x10e>
  802bf4:	8b 14 24             	mov    (%esp),%edx
  802bf7:	89 c1                	mov    %eax,%ecx
  802bf9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802bfd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802c01:	eb cb                	jmp    802bce <__umoddi3+0x10e>
  802c03:	90                   	nop
  802c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c08:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802c0c:	0f 82 0f ff ff ff    	jb     802b21 <__umoddi3+0x61>
  802c12:	e9 1a ff ff ff       	jmp    802b31 <__umoddi3+0x71>
