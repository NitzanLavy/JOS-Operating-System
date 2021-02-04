
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 e5 09 00 00       	call   800a16 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	83 ec 1c             	sub    $0x1c,%esp
  800049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004c:	8b 75 0c             	mov    0xc(%ebp),%esi
	int t;

	if (s == 0) {
  80004f:	85 db                	test   %ebx,%ebx
  800051:	75 28                	jne    80007b <_gettoken+0x3b>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
  800053:	b8 00 00 00 00       	mov    $0x0,%eax
_gettoken(char *s, char **p1, char **p2)
{
	int t;

	if (s == 0) {
		if (debug > 1)
  800058:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80005f:	0f 8e 33 01 00 00    	jle    800198 <_gettoken+0x158>
			cprintf("GETTOKEN NULL\n");
  800065:	c7 04 24 00 3f 80 00 	movl   $0x803f00,(%esp)
  80006c:	e8 03 0b 00 00       	call   800b74 <cprintf>
		return 0;
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	e9 1d 01 00 00       	jmp    800198 <_gettoken+0x158>
	}

	if (debug > 1)
  80007b:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800082:	7e 10                	jle    800094 <_gettoken+0x54>
		cprintf("GETTOKEN: %s\n", s);
  800084:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800088:	c7 04 24 0f 3f 80 00 	movl   $0x803f0f,(%esp)
  80008f:	e8 e0 0a 00 00       	call   800b74 <cprintf>

	*p1 = 0;
  800094:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	*p2 = 0;
  80009a:	8b 45 10             	mov    0x10(%ebp),%eax
  80009d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  8000a3:	eb 07                	jmp    8000ac <_gettoken+0x6c>
		*s++ = 0;
  8000a5:	83 c3 01             	add    $0x1,%ebx
  8000a8:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8000ac:	0f be 03             	movsbl (%ebx),%eax
  8000af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b3:	c7 04 24 1d 3f 80 00 	movl   $0x803f1d,(%esp)
  8000ba:	e8 3b 14 00 00       	call   8014fa <strchr>
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	75 e2                	jne    8000a5 <_gettoken+0x65>
  8000c3:	89 df                	mov    %ebx,%edi
		*s++ = 0;
	if (*s == 0) {
  8000c5:	0f b6 03             	movzbl (%ebx),%eax
  8000c8:	84 c0                	test   %al,%al
  8000ca:	75 28                	jne    8000f4 <_gettoken+0xb4>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000cc:	b8 00 00 00 00       	mov    $0x0,%eax
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
		*s++ = 0;
	if (*s == 0) {
		if (debug > 1)
  8000d1:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  8000d8:	0f 8e ba 00 00 00    	jle    800198 <_gettoken+0x158>
			cprintf("EOL\n");
  8000de:	c7 04 24 22 3f 80 00 	movl   $0x803f22,(%esp)
  8000e5:	e8 8a 0a 00 00       	call   800b74 <cprintf>
		return 0;
  8000ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ef:	e9 a4 00 00 00       	jmp    800198 <_gettoken+0x158>
	}
	if (strchr(SYMBOLS, *s)) {
  8000f4:	0f be c0             	movsbl %al,%eax
  8000f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000fb:	c7 04 24 33 3f 80 00 	movl   $0x803f33,(%esp)
  800102:	e8 f3 13 00 00       	call   8014fa <strchr>
  800107:	85 c0                	test   %eax,%eax
  800109:	74 2f                	je     80013a <_gettoken+0xfa>
		t = *s;
  80010b:	0f be 1b             	movsbl (%ebx),%ebx
		*p1 = s;
  80010e:	89 3e                	mov    %edi,(%esi)
		*s++ = 0;
  800110:	c6 07 00             	movb   $0x0,(%edi)
  800113:	83 c7 01             	add    $0x1,%edi
  800116:	8b 45 10             	mov    0x10(%ebp),%eax
  800119:	89 38                	mov    %edi,(%eax)
		*p2 = s;
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
  80011b:	89 d8                	mov    %ebx,%eax
	if (strchr(SYMBOLS, *s)) {
		t = *s;
		*p1 = s;
		*s++ = 0;
		*p2 = s;
		if (debug > 1)
  80011d:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800124:	7e 72                	jle    800198 <_gettoken+0x158>
			cprintf("TOK %c\n", t);
  800126:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80012a:	c7 04 24 27 3f 80 00 	movl   $0x803f27,(%esp)
  800131:	e8 3e 0a 00 00       	call   800b74 <cprintf>
		return t;
  800136:	89 d8                	mov    %ebx,%eax
  800138:	eb 5e                	jmp    800198 <_gettoken+0x158>
	}
	*p1 = s;
  80013a:	89 1e                	mov    %ebx,(%esi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80013c:	eb 03                	jmp    800141 <_gettoken+0x101>
		s++;
  80013e:	83 c3 01             	add    $0x1,%ebx
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800141:	0f b6 03             	movzbl (%ebx),%eax
  800144:	84 c0                	test   %al,%al
  800146:	74 17                	je     80015f <_gettoken+0x11f>
  800148:	0f be c0             	movsbl %al,%eax
  80014b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014f:	c7 04 24 2f 3f 80 00 	movl   $0x803f2f,(%esp)
  800156:	e8 9f 13 00 00       	call   8014fa <strchr>
  80015b:	85 c0                	test   %eax,%eax
  80015d:	74 df                	je     80013e <_gettoken+0xfe>
		s++;
	*p2 = s;
  80015f:	8b 45 10             	mov    0x10(%ebp),%eax
  800162:	89 18                	mov    %ebx,(%eax)
		t = **p2;
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
  800164:	b8 77 00 00 00       	mov    $0x77,%eax
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
		s++;
	*p2 = s;
	if (debug > 1) {
  800169:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800170:	7e 26                	jle    800198 <_gettoken+0x158>
		t = **p2;
  800172:	0f b6 3b             	movzbl (%ebx),%edi
		**p2 = 0;
  800175:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  800178:	8b 06                	mov    (%esi),%eax
  80017a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017e:	c7 04 24 3b 3f 80 00 	movl   $0x803f3b,(%esp)
  800185:	e8 ea 09 00 00       	call   800b74 <cprintf>
		**p2 = t;
  80018a:	8b 45 10             	mov    0x10(%ebp),%eax
  80018d:	8b 00                	mov    (%eax),%eax
  80018f:	89 fa                	mov    %edi,%edx
  800191:	88 10                	mov    %dl,(%eax)
	}
	return 'w';
  800193:	b8 77 00 00 00       	mov    $0x77,%eax
}
  800198:	83 c4 1c             	add    $0x1c,%esp
  80019b:	5b                   	pop    %ebx
  80019c:	5e                   	pop    %esi
  80019d:	5f                   	pop    %edi
  80019e:	5d                   	pop    %ebp
  80019f:	c3                   	ret    

008001a0 <gettoken>:

int
gettoken(char *s, char **p1)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 18             	sub    $0x18,%esp
  8001a6:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  8001a9:	85 c0                	test   %eax,%eax
  8001ab:	74 24                	je     8001d1 <gettoken+0x31>
		nc = _gettoken(s, &np1, &np2);
  8001ad:	c7 44 24 08 0c 60 80 	movl   $0x80600c,0x8(%esp)
  8001b4:	00 
  8001b5:	c7 44 24 04 10 60 80 	movl   $0x806010,0x4(%esp)
  8001bc:	00 
  8001bd:	89 04 24             	mov    %eax,(%esp)
  8001c0:	e8 7b fe ff ff       	call   800040 <_gettoken>
  8001c5:	a3 08 60 80 00       	mov    %eax,0x806008
		return 0;
  8001ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cf:	eb 3c                	jmp    80020d <gettoken+0x6d>
	}
	c = nc;
  8001d1:	a1 08 60 80 00       	mov    0x806008,%eax
  8001d6:	a3 04 60 80 00       	mov    %eax,0x806004
	*p1 = np1;
  8001db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001de:	8b 15 10 60 80 00    	mov    0x806010,%edx
  8001e4:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001e6:	c7 44 24 08 0c 60 80 	movl   $0x80600c,0x8(%esp)
  8001ed:	00 
  8001ee:	c7 44 24 04 10 60 80 	movl   $0x806010,0x4(%esp)
  8001f5:	00 
  8001f6:	a1 0c 60 80 00       	mov    0x80600c,%eax
  8001fb:	89 04 24             	mov    %eax,(%esp)
  8001fe:	e8 3d fe ff ff       	call   800040 <_gettoken>
  800203:	a3 08 60 80 00       	mov    %eax,0x806008
	return c;
  800208:	a1 04 60 80 00       	mov    0x806004,%eax
}
  80020d:	c9                   	leave  
  80020e:	c3                   	ret    

0080020f <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	57                   	push   %edi
  800213:	56                   	push   %esi
  800214:	53                   	push   %ebx
  800215:	81 ec 6c 04 00 00    	sub    $0x46c,%esp
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
	gettoken(s, 0);
  80021b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800222:	00 
  800223:	8b 45 08             	mov    0x8(%ebp),%eax
  800226:	89 04 24             	mov    %eax,(%esp)
  800229:	e8 72 ff ff ff       	call   8001a0 <gettoken>

again:
	argc = 0;
  80022e:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		switch ((c = gettoken(0, &t))) {
  800233:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
  800236:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80023a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800241:	e8 5a ff ff ff       	call   8001a0 <gettoken>
  800246:	83 f8 3e             	cmp    $0x3e,%eax
  800249:	0f 84 d4 00 00 00    	je     800323 <runcmd+0x114>
  80024f:	83 f8 3e             	cmp    $0x3e,%eax
  800252:	7f 13                	jg     800267 <runcmd+0x58>
  800254:	85 c0                	test   %eax,%eax
  800256:	0f 84 55 02 00 00    	je     8004b1 <runcmd+0x2a2>
  80025c:	83 f8 3c             	cmp    $0x3c,%eax
  80025f:	90                   	nop
  800260:	74 3d                	je     80029f <runcmd+0x90>
  800262:	e9 2a 02 00 00       	jmp    800491 <runcmd+0x282>
  800267:	83 f8 77             	cmp    $0x77,%eax
  80026a:	74 0f                	je     80027b <runcmd+0x6c>
  80026c:	83 f8 7c             	cmp    $0x7c,%eax
  80026f:	90                   	nop
  800270:	0f 84 2e 01 00 00    	je     8003a4 <runcmd+0x195>
  800276:	e9 16 02 00 00       	jmp    800491 <runcmd+0x282>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  80027b:	83 fe 10             	cmp    $0x10,%esi
  80027e:	66 90                	xchg   %ax,%ax
  800280:	75 11                	jne    800293 <runcmd+0x84>
				cprintf("too many arguments\n");
  800282:	c7 04 24 45 3f 80 00 	movl   $0x803f45,(%esp)
  800289:	e8 e6 08 00 00       	call   800b74 <cprintf>
				exit();
  80028e:	e8 cf 07 00 00       	call   800a62 <exit>
			}
			argv[argc++] = t;
  800293:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800296:	89 44 b5 a8          	mov    %eax,-0x58(%ebp,%esi,4)
  80029a:	8d 76 01             	lea    0x1(%esi),%esi
			break;
  80029d:	eb 97                	jmp    800236 <runcmd+0x27>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80029f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002aa:	e8 f1 fe ff ff       	call   8001a0 <gettoken>
  8002af:	83 f8 77             	cmp    $0x77,%eax
  8002b2:	74 11                	je     8002c5 <runcmd+0xb6>
				cprintf("syntax error: < not followed by word\n");
  8002b4:	c7 04 24 b0 40 80 00 	movl   $0x8040b0,(%esp)
  8002bb:	e8 b4 08 00 00       	call   800b74 <cprintf>
				exit();
  8002c0:	e8 9d 07 00 00       	call   800a62 <exit>
			// then check whether 'fd' is 0.
			// If not, dup 'fd' onto file descriptor 0,
			// then close the original 'fd'.

			// LAB 5: Your code here.
			if ((fd = open(t, O_RDONLY)) < 0) {
  8002c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002cc:	00 
  8002cd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002d0:	89 04 24             	mov    %eax,(%esp)
  8002d3:	e8 7e 26 00 00       	call   802956 <open>
  8002d8:	89 c7                	mov    %eax,%edi
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	79 1e                	jns    8002fc <runcmd+0xed>
				cprintf("open %s for read: %e", t, fd);
  8002de:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e9:	c7 04 24 59 3f 80 00 	movl   $0x803f59,(%esp)
  8002f0:	e8 7f 08 00 00       	call   800b74 <cprintf>
				exit();
  8002f5:	e8 68 07 00 00       	call   800a62 <exit>
  8002fa:	eb 0a                	jmp    800306 <runcmd+0xf7>
			}
			if (fd != 0) {
  8002fc:	85 c0                	test   %eax,%eax
  8002fe:	66 90                	xchg   %ax,%ax
  800300:	0f 84 30 ff ff ff    	je     800236 <runcmd+0x27>
				dup(fd, 0);
  800306:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80030d:	00 
  80030e:	89 3c 24             	mov    %edi,(%esp)
  800311:	e8 66 20 00 00       	call   80237c <dup>
				close(fd);
  800316:	89 3c 24             	mov    %edi,(%esp)
  800319:	e8 09 20 00 00       	call   802327 <close>
  80031e:	e9 13 ff ff ff       	jmp    800236 <runcmd+0x27>
			}
			break;

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  800323:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800327:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80032e:	e8 6d fe ff ff       	call   8001a0 <gettoken>
  800333:	83 f8 77             	cmp    $0x77,%eax
  800336:	74 11                	je     800349 <runcmd+0x13a>
				cprintf("syntax error: > not followed by word\n");
  800338:	c7 04 24 d8 40 80 00 	movl   $0x8040d8,(%esp)
  80033f:	e8 30 08 00 00       	call   800b74 <cprintf>
				exit();
  800344:	e8 19 07 00 00       	call   800a62 <exit>
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800349:	c7 44 24 04 01 03 00 	movl   $0x301,0x4(%esp)
  800350:	00 
  800351:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800354:	89 04 24             	mov    %eax,(%esp)
  800357:	e8 fa 25 00 00       	call   802956 <open>
  80035c:	89 c7                	mov    %eax,%edi
  80035e:	85 c0                	test   %eax,%eax
  800360:	79 1c                	jns    80037e <runcmd+0x16f>
				cprintf("open %s for write: %e", t, fd);
  800362:	89 44 24 08          	mov    %eax,0x8(%esp)
  800366:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800369:	89 44 24 04          	mov    %eax,0x4(%esp)
  80036d:	c7 04 24 6e 3f 80 00 	movl   $0x803f6e,(%esp)
  800374:	e8 fb 07 00 00       	call   800b74 <cprintf>
				exit();
  800379:	e8 e4 06 00 00       	call   800a62 <exit>
			}
			if (fd != 1) {
  80037e:	83 ff 01             	cmp    $0x1,%edi
  800381:	0f 84 af fe ff ff    	je     800236 <runcmd+0x27>
				dup(fd, 1);
  800387:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80038e:	00 
  80038f:	89 3c 24             	mov    %edi,(%esp)
  800392:	e8 e5 1f 00 00       	call   80237c <dup>
				close(fd);
  800397:	89 3c 24             	mov    %edi,(%esp)
  80039a:	e8 88 1f 00 00       	call   802327 <close>
  80039f:	e9 92 fe ff ff       	jmp    800236 <runcmd+0x27>
			}
			break;

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8003a4:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  8003aa:	89 04 24             	mov    %eax,(%esp)
  8003ad:	e8 c2 34 00 00       	call   803874 <pipe>
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	79 15                	jns    8003cb <runcmd+0x1bc>
				cprintf("pipe: %e", r);
  8003b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ba:	c7 04 24 84 3f 80 00 	movl   $0x803f84,(%esp)
  8003c1:	e8 ae 07 00 00       	call   800b74 <cprintf>
				exit();
  8003c6:	e8 97 06 00 00       	call   800a62 <exit>
			}
			if (debug)
  8003cb:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8003d2:	74 20                	je     8003f4 <runcmd+0x1e5>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  8003d4:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  8003da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003de:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8003e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e8:	c7 04 24 8d 3f 80 00 	movl   $0x803f8d,(%esp)
  8003ef:	e8 80 07 00 00       	call   800b74 <cprintf>
			if ((r = fork()) < 0) {
  8003f4:	e8 61 19 00 00       	call   801d5a <fork>
  8003f9:	89 c7                	mov    %eax,%edi
  8003fb:	85 c0                	test   %eax,%eax
  8003fd:	79 15                	jns    800414 <runcmd+0x205>
				cprintf("fork: %e", r);
  8003ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800403:	c7 04 24 9a 3f 80 00 	movl   $0x803f9a,(%esp)
  80040a:	e8 65 07 00 00       	call   800b74 <cprintf>
				exit();
  80040f:	e8 4e 06 00 00       	call   800a62 <exit>
			}
			if (r == 0) {
  800414:	85 ff                	test   %edi,%edi
  800416:	75 40                	jne    800458 <runcmd+0x249>
				if (p[0] != 0) {
  800418:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  80041e:	85 c0                	test   %eax,%eax
  800420:	74 1e                	je     800440 <runcmd+0x231>
					dup(p[0], 0);
  800422:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800429:	00 
  80042a:	89 04 24             	mov    %eax,(%esp)
  80042d:	e8 4a 1f 00 00       	call   80237c <dup>
					close(p[0]);
  800432:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800438:	89 04 24             	mov    %eax,(%esp)
  80043b:	e8 e7 1e 00 00       	call   802327 <close>
				}
				close(p[1]);
  800440:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800446:	89 04 24             	mov    %eax,(%esp)
  800449:	e8 d9 1e 00 00       	call   802327 <close>

	pipe_child = 0;
	gettoken(s, 0);

again:
	argc = 0;
  80044e:	be 00 00 00 00       	mov    $0x0,%esi
				if (p[0] != 0) {
					dup(p[0], 0);
					close(p[0]);
				}
				close(p[1]);
				goto again;
  800453:	e9 de fd ff ff       	jmp    800236 <runcmd+0x27>
			} else {
				pipe_child = r;
				if (p[1] != 1) {
  800458:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80045e:	83 f8 01             	cmp    $0x1,%eax
  800461:	74 1e                	je     800481 <runcmd+0x272>
					dup(p[1], 1);
  800463:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80046a:	00 
  80046b:	89 04 24             	mov    %eax,(%esp)
  80046e:	e8 09 1f 00 00       	call   80237c <dup>
					close(p[1]);
  800473:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800479:	89 04 24             	mov    %eax,(%esp)
  80047c:	e8 a6 1e 00 00       	call   802327 <close>
				}
				close(p[0]);
  800481:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800487:	89 04 24             	mov    %eax,(%esp)
  80048a:	e8 98 1e 00 00       	call   802327 <close>
				goto runit;
  80048f:	eb 25                	jmp    8004b6 <runcmd+0x2a7>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  800491:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800495:	c7 44 24 08 a3 3f 80 	movl   $0x803fa3,0x8(%esp)
  80049c:	00 
  80049d:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
  8004a4:	00 
  8004a5:	c7 04 24 bf 3f 80 00 	movl   $0x803fbf,(%esp)
  8004ac:	e8 ca 05 00 00       	call   800a7b <_panic>
runcmd(char* s)
{
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  8004b1:	bf 00 00 00 00       	mov    $0x0,%edi
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  8004b6:	85 f6                	test   %esi,%esi
  8004b8:	75 1e                	jne    8004d8 <runcmd+0x2c9>
		if (debug)
  8004ba:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004c1:	0f 84 91 01 00 00    	je     800658 <runcmd+0x449>
			cprintf("EMPTY COMMAND\n");
  8004c7:	c7 04 24 c9 3f 80 00 	movl   $0x803fc9,(%esp)
  8004ce:	e8 a1 06 00 00       	call   800b74 <cprintf>
  8004d3:	e9 80 01 00 00       	jmp    800658 <runcmd+0x449>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  8004d8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004db:	80 38 2f             	cmpb   $0x2f,(%eax)
  8004de:	74 22                	je     800502 <runcmd+0x2f3>
		argv0buf[0] = '/';
  8004e0:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  8004e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004eb:	8d 9d a4 fb ff ff    	lea    -0x45c(%ebp),%ebx
  8004f1:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  8004f7:	89 04 24             	mov    %eax,(%esp)
  8004fa:	e8 e8 0e 00 00       	call   8013e7 <strcpy>
		argv[0] = argv0buf;
  8004ff:	89 5d a8             	mov    %ebx,-0x58(%ebp)
	}
	argv[argc] = 0;
  800502:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
  800509:	00 

	// Print the command.
	if (debug) {
  80050a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800511:	74 43                	je     800556 <runcmd+0x347>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  800513:	a1 28 64 80 00       	mov    0x806428,%eax
  800518:	8b 40 48             	mov    0x48(%eax),%eax
  80051b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051f:	c7 04 24 d8 3f 80 00 	movl   $0x803fd8,(%esp)
  800526:	e8 49 06 00 00       	call   800b74 <cprintf>
  80052b:	8d 5d a8             	lea    -0x58(%ebp),%ebx
		for (i = 0; argv[i]; i++)
  80052e:	eb 10                	jmp    800540 <runcmd+0x331>
			cprintf(" %s", argv[i]);
  800530:	89 44 24 04          	mov    %eax,0x4(%esp)
  800534:	c7 04 24 7a 40 80 00 	movl   $0x80407a,(%esp)
  80053b:	e8 34 06 00 00       	call   800b74 <cprintf>
  800540:	83 c3 04             	add    $0x4,%ebx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  800543:	8b 43 fc             	mov    -0x4(%ebx),%eax
  800546:	85 c0                	test   %eax,%eax
  800548:	75 e6                	jne    800530 <runcmd+0x321>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  80054a:	c7 04 24 20 3f 80 00 	movl   $0x803f20,(%esp)
  800551:	e8 1e 06 00 00       	call   800b74 <cprintf>
	}

	// Spawn the command!
	cprintf("RUNNING SPAWN FROM SH\n");
  800556:	c7 04 24 e6 3f 80 00 	movl   $0x803fe6,(%esp)
  80055d:	e8 12 06 00 00       	call   800b74 <cprintf>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800562:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800565:	89 44 24 04          	mov    %eax,0x4(%esp)
  800569:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80056c:	89 04 24             	mov    %eax,(%esp)
  80056f:	e8 bc 25 00 00       	call   802b30 <spawn>
  800574:	89 c3                	mov    %eax,%ebx
  800576:	85 c0                	test   %eax,%eax
  800578:	0f 89 c3 00 00 00    	jns    800641 <runcmd+0x432>
		cprintf("spawn %s: %e\n", argv[0], r);
  80057e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800582:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800585:	89 44 24 04          	mov    %eax,0x4(%esp)
  800589:	c7 04 24 fd 3f 80 00 	movl   $0x803ffd,(%esp)
  800590:	e8 df 05 00 00       	call   800b74 <cprintf>

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  800595:	e8 c0 1d 00 00       	call   80235a <close_all>
  80059a:	eb 4c                	jmp    8005e8 <runcmd+0x3d9>
	if (r >= 0) {
		if (debug)
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  80059c:	a1 28 64 80 00       	mov    0x806428,%eax
  8005a1:	8b 40 48             	mov    0x48(%eax),%eax
  8005a4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005a8:	8b 55 a8             	mov    -0x58(%ebp),%edx
  8005ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8005af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005b3:	c7 04 24 0b 40 80 00 	movl   $0x80400b,(%esp)
  8005ba:	e8 b5 05 00 00       	call   800b74 <cprintf>
		wait(r);
  8005bf:	89 1c 24             	mov    %ebx,(%esp)
  8005c2:	e8 53 34 00 00       	call   803a1a <wait>
		if (debug)
  8005c7:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8005ce:	74 18                	je     8005e8 <runcmd+0x3d9>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8005d0:	a1 28 64 80 00       	mov    0x806428,%eax
  8005d5:	8b 40 48             	mov    0x48(%eax),%eax
  8005d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005dc:	c7 04 24 20 40 80 00 	movl   $0x804020,(%esp)
  8005e3:	e8 8c 05 00 00       	call   800b74 <cprintf>
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  8005e8:	85 ff                	test   %edi,%edi
  8005ea:	74 4e                	je     80063a <runcmd+0x42b>
		if (debug)
  8005ec:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8005f3:	74 1c                	je     800611 <runcmd+0x402>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  8005f5:	a1 28 64 80 00       	mov    0x806428,%eax
  8005fa:	8b 40 48             	mov    0x48(%eax),%eax
  8005fd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800601:	89 44 24 04          	mov    %eax,0x4(%esp)
  800605:	c7 04 24 36 40 80 00 	movl   $0x804036,(%esp)
  80060c:	e8 63 05 00 00       	call   800b74 <cprintf>
		wait(pipe_child);
  800611:	89 3c 24             	mov    %edi,(%esp)
  800614:	e8 01 34 00 00       	call   803a1a <wait>
		if (debug)
  800619:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800620:	74 18                	je     80063a <runcmd+0x42b>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800622:	a1 28 64 80 00       	mov    0x806428,%eax
  800627:	8b 40 48             	mov    0x48(%eax),%eax
  80062a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80062e:	c7 04 24 20 40 80 00 	movl   $0x804020,(%esp)
  800635:	e8 3a 05 00 00       	call   800b74 <cprintf>
	}

	// Done!
	exit();
  80063a:	e8 23 04 00 00       	call   800a62 <exit>
  80063f:	eb 17                	jmp    800658 <runcmd+0x449>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
		cprintf("spawn %s: %e\n", argv[0], r);

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  800641:	e8 14 1d 00 00       	call   80235a <close_all>
	if (r >= 0) {
		if (debug)
  800646:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80064d:	0f 84 6c ff ff ff    	je     8005bf <runcmd+0x3b0>
  800653:	e9 44 ff ff ff       	jmp    80059c <runcmd+0x38d>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
	}

	// Done!
	exit();
}
  800658:	81 c4 6c 04 00 00    	add    $0x46c,%esp
  80065e:	5b                   	pop    %ebx
  80065f:	5e                   	pop    %esi
  800660:	5f                   	pop    %edi
  800661:	5d                   	pop    %ebp
  800662:	c3                   	ret    

00800663 <usage>:
}


void
usage(void)
{
  800663:	55                   	push   %ebp
  800664:	89 e5                	mov    %esp,%ebp
  800666:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800669:	c7 04 24 00 41 80 00 	movl   $0x804100,(%esp)
  800670:	e8 ff 04 00 00       	call   800b74 <cprintf>
	exit();
  800675:	e8 e8 03 00 00       	call   800a62 <exit>
}
  80067a:	c9                   	leave  
  80067b:	c3                   	ret    

0080067c <umain>:

void
umain(int argc, char **argv)
{
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
  80067f:	57                   	push   %edi
  800680:	56                   	push   %esi
  800681:	53                   	push   %ebx
  800682:	83 ec 3c             	sub    $0x3c,%esp
  800685:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  800688:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80068b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80068f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800693:	8d 45 08             	lea    0x8(%ebp),%eax
  800696:	89 04 24             	mov    %eax,(%esp)
  800699:	e8 84 19 00 00       	call   802022 <argstart>
{
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
  80069e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
umain(int argc, char **argv)
{
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
  8006a5:	bf 3f 00 00 00       	mov    $0x3f,%edi
	echocmds = 0;
	argstart(&argc, argv, &args);

	while ((r = argnext(&args)) >= 0)
  8006aa:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8006ad:	eb 31                	jmp    8006e0 <umain+0x64>
		switch (r) {
  8006af:	83 f8 69             	cmp    $0x69,%eax
  8006b2:	74 0e                	je     8006c2 <umain+0x46>
  8006b4:	83 f8 78             	cmp    $0x78,%eax
  8006b7:	74 20                	je     8006d9 <umain+0x5d>
  8006b9:	83 f8 64             	cmp    $0x64,%eax
  8006bc:	75 14                	jne    8006d2 <umain+0x56>
  8006be:	66 90                	xchg   %ax,%ax
  8006c0:	eb 07                	jmp    8006c9 <umain+0x4d>
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006c2:	bf 01 00 00 00       	mov    $0x1,%edi
  8006c7:	eb 17                	jmp    8006e0 <umain+0x64>
	argstart(&argc, argv, &args);

	while ((r = argnext(&args)) >= 0)
		switch (r) {
		case 'd':
			debug++;
  8006c9:	83 05 00 60 80 00 01 	addl   $0x1,0x806000
			break;
  8006d0:	eb 0e                	jmp    8006e0 <umain+0x64>
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
  8006d2:	e8 8c ff ff ff       	call   800663 <usage>
  8006d7:	eb 07                	jmp    8006e0 <umain+0x64>
			break;
		case 'i':
			interactive = 1;
			break;
		case 'x':
			echocmds = 1;
  8006d9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);

	while ((r = argnext(&args)) >= 0)
  8006e0:	89 1c 24             	mov    %ebx,(%esp)
  8006e3:	e8 72 19 00 00       	call   80205a <argnext>
  8006e8:	85 c0                	test   %eax,%eax
  8006ea:	79 c3                	jns    8006af <umain+0x33>
  8006ec:	89 fb                	mov    %edi,%ebx
			break;
		default:
			usage();
		}

	if (argc > 2)
  8006ee:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006f2:	7e 05                	jle    8006f9 <umain+0x7d>
		usage();
  8006f4:	e8 6a ff ff ff       	call   800663 <usage>
	if (argc == 2) {
  8006f9:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006fd:	75 72                	jne    800771 <umain+0xf5>
		close(0);
  8006ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800706:	e8 1c 1c 00 00       	call   802327 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  80070b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800712:	00 
  800713:	8b 46 04             	mov    0x4(%esi),%eax
  800716:	89 04 24             	mov    %eax,(%esp)
  800719:	e8 38 22 00 00       	call   802956 <open>
  80071e:	85 c0                	test   %eax,%eax
  800720:	79 27                	jns    800749 <umain+0xcd>
			panic("open %s: %e", argv[1], r);
  800722:	89 44 24 10          	mov    %eax,0x10(%esp)
  800726:	8b 46 04             	mov    0x4(%esi),%eax
  800729:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80072d:	c7 44 24 08 56 40 80 	movl   $0x804056,0x8(%esp)
  800734:	00 
  800735:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  80073c:	00 
  80073d:	c7 04 24 bf 3f 80 00 	movl   $0x803fbf,(%esp)
  800744:	e8 32 03 00 00       	call   800a7b <_panic>
		assert(r == 0);
  800749:	85 c0                	test   %eax,%eax
  80074b:	74 24                	je     800771 <umain+0xf5>
  80074d:	c7 44 24 0c 62 40 80 	movl   $0x804062,0xc(%esp)
  800754:	00 
  800755:	c7 44 24 08 69 40 80 	movl   $0x804069,0x8(%esp)
  80075c:	00 
  80075d:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  800764:	00 
  800765:	c7 04 24 bf 3f 80 00 	movl   $0x803fbf,(%esp)
  80076c:	e8 0a 03 00 00       	call   800a7b <_panic>
	}
	if (interactive == '?')
  800771:	83 fb 3f             	cmp    $0x3f,%ebx
  800774:	75 0e                	jne    800784 <umain+0x108>
		interactive = iscons(0);
  800776:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80077d:	e8 0a 02 00 00       	call   80098c <iscons>
  800782:	89 c7                	mov    %eax,%edi

	while (1) {
		char *buf;
		buf = readline(interactive ? "$ " : NULL);
  800784:	85 ff                	test   %edi,%edi
  800786:	b8 00 00 00 00       	mov    $0x0,%eax
  80078b:	ba 53 40 80 00       	mov    $0x804053,%edx
  800790:	0f 45 c2             	cmovne %edx,%eax
  800793:	89 04 24             	mov    %eax,(%esp)
  800796:	e8 17 0b 00 00       	call   8012b2 <readline>
  80079b:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  80079d:	85 c0                	test   %eax,%eax
  80079f:	75 1a                	jne    8007bb <umain+0x13f>
			if (debug)
  8007a1:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007a8:	74 0c                	je     8007b6 <umain+0x13a>
				cprintf("EXITING\n");
  8007aa:	c7 04 24 7e 40 80 00 	movl   $0x80407e,(%esp)
  8007b1:	e8 be 03 00 00       	call   800b74 <cprintf>
			exit();	// end of file
  8007b6:	e8 a7 02 00 00       	call   800a62 <exit>
		}
		
		if (debug)
  8007bb:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007c2:	74 10                	je     8007d4 <umain+0x158>
			cprintf("LINE: %s\n", buf);
  8007c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007c8:	c7 04 24 87 40 80 00 	movl   $0x804087,(%esp)
  8007cf:	e8 a0 03 00 00       	call   800b74 <cprintf>
		if (buf[0] == '#')
  8007d4:	80 3b 23             	cmpb   $0x23,(%ebx)
  8007d7:	74 ab                	je     800784 <umain+0x108>
			continue;
		if (echocmds)
  8007d9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007dd:	74 10                	je     8007ef <umain+0x173>
			printf("# %s\n", buf);
  8007df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007e3:	c7 04 24 91 40 80 00 	movl   $0x804091,(%esp)
  8007ea:	e8 17 23 00 00       	call   802b06 <printf>
		if (debug)
  8007ef:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007f6:	74 0c                	je     800804 <umain+0x188>
			cprintf("BEFORE FORK\n");
  8007f8:	c7 04 24 97 40 80 00 	movl   $0x804097,(%esp)
  8007ff:	e8 70 03 00 00       	call   800b74 <cprintf>
		if ((r = fork()) < 0)
  800804:	e8 51 15 00 00       	call   801d5a <fork>
  800809:	89 c6                	mov    %eax,%esi
  80080b:	85 c0                	test   %eax,%eax
  80080d:	79 20                	jns    80082f <umain+0x1b3>
			panic("fork: %e", r);
  80080f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800813:	c7 44 24 08 9a 3f 80 	movl   $0x803f9a,0x8(%esp)
  80081a:	00 
  80081b:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
  800822:	00 
  800823:	c7 04 24 bf 3f 80 00 	movl   $0x803fbf,(%esp)
  80082a:	e8 4c 02 00 00       	call   800a7b <_panic>
		if (debug)
  80082f:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800836:	74 10                	je     800848 <umain+0x1cc>
			cprintf("FORK: %d\n", r);
  800838:	89 44 24 04          	mov    %eax,0x4(%esp)
  80083c:	c7 04 24 a4 40 80 00 	movl   $0x8040a4,(%esp)
  800843:	e8 2c 03 00 00       	call   800b74 <cprintf>
		if (r == 0) {
  800848:	85 f6                	test   %esi,%esi
  80084a:	75 12                	jne    80085e <umain+0x1e2>
			runcmd(buf);
  80084c:	89 1c 24             	mov    %ebx,(%esp)
  80084f:	e8 bb f9 ff ff       	call   80020f <runcmd>
			exit();
  800854:	e8 09 02 00 00       	call   800a62 <exit>
  800859:	e9 26 ff ff ff       	jmp    800784 <umain+0x108>
		} else
			wait(r);
  80085e:	89 34 24             	mov    %esi,(%esp)
  800861:	e8 b4 31 00 00       	call   803a1a <wait>
  800866:	e9 19 ff ff ff       	jmp    800784 <umain+0x108>
  80086b:	66 90                	xchg   %ax,%ax
  80086d:	66 90                	xchg   %ax,%ax
  80086f:	90                   	nop

00800870 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800873:	b8 00 00 00 00       	mov    $0x0,%eax
  800878:	5d                   	pop    %ebp
  800879:	c3                   	ret    

0080087a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800880:	c7 44 24 04 21 41 80 	movl   $0x804121,0x4(%esp)
  800887:	00 
  800888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088b:	89 04 24             	mov    %eax,(%esp)
  80088e:	e8 54 0b 00 00       	call   8013e7 <strcpy>
	return 0;
}
  800893:	b8 00 00 00 00       	mov    $0x0,%eax
  800898:	c9                   	leave  
  800899:	c3                   	ret    

0080089a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	57                   	push   %edi
  80089e:	56                   	push   %esi
  80089f:	53                   	push   %ebx
  8008a0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8008a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8008ab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8008b1:	eb 31                	jmp    8008e4 <devcons_write+0x4a>
		m = n - tot;
  8008b3:	8b 75 10             	mov    0x10(%ebp),%esi
  8008b6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8008b8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8008bb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8008c0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8008c3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8008c7:	03 45 0c             	add    0xc(%ebp),%eax
  8008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ce:	89 3c 24             	mov    %edi,(%esp)
  8008d1:	e8 ae 0c 00 00       	call   801584 <memmove>
		sys_cputs(buf, m);
  8008d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008da:	89 3c 24             	mov    %edi,(%esp)
  8008dd:	e8 54 0e 00 00       	call   801736 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8008e2:	01 f3                	add    %esi,%ebx
  8008e4:	89 d8                	mov    %ebx,%eax
  8008e6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8008e9:	72 c8                	jb     8008b3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8008eb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8008f1:	5b                   	pop    %ebx
  8008f2:	5e                   	pop    %esi
  8008f3:	5f                   	pop    %edi
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  800901:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800905:	75 07                	jne    80090e <devcons_read+0x18>
  800907:	eb 2a                	jmp    800933 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800909:	e8 d6 0e 00 00       	call   8017e4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80090e:	66 90                	xchg   %ax,%ax
  800910:	e8 3f 0e 00 00       	call   801754 <sys_cgetc>
  800915:	85 c0                	test   %eax,%eax
  800917:	74 f0                	je     800909 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800919:	85 c0                	test   %eax,%eax
  80091b:	78 16                	js     800933 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80091d:	83 f8 04             	cmp    $0x4,%eax
  800920:	74 0c                	je     80092e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  800922:	8b 55 0c             	mov    0xc(%ebp),%edx
  800925:	88 02                	mov    %al,(%edx)
	return 1;
  800927:	b8 01 00 00 00       	mov    $0x1,%eax
  80092c:	eb 05                	jmp    800933 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80092e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800933:	c9                   	leave  
  800934:	c3                   	ret    

00800935 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800941:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800948:	00 
  800949:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80094c:	89 04 24             	mov    %eax,(%esp)
  80094f:	e8 e2 0d 00 00       	call   801736 <sys_cputs>
}
  800954:	c9                   	leave  
  800955:	c3                   	ret    

00800956 <getchar>:

int
getchar(void)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80095c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800963:	00 
  800964:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800967:	89 44 24 04          	mov    %eax,0x4(%esp)
  80096b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800972:	e8 13 1b 00 00       	call   80248a <read>
	if (r < 0)
  800977:	85 c0                	test   %eax,%eax
  800979:	78 0f                	js     80098a <getchar+0x34>
		return r;
	if (r < 1)
  80097b:	85 c0                	test   %eax,%eax
  80097d:	7e 06                	jle    800985 <getchar+0x2f>
		return -E_EOF;
	return c;
  80097f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800983:	eb 05                	jmp    80098a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800985:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80098a:	c9                   	leave  
  80098b:	c3                   	ret    

0080098c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800992:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800995:	89 44 24 04          	mov    %eax,0x4(%esp)
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	89 04 24             	mov    %eax,(%esp)
  80099f:	e8 52 18 00 00       	call   8021f6 <fd_lookup>
  8009a4:	85 c0                	test   %eax,%eax
  8009a6:	78 11                	js     8009b9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8009a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ab:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009b1:	39 10                	cmp    %edx,(%eax)
  8009b3:	0f 94 c0             	sete   %al
  8009b6:	0f b6 c0             	movzbl %al,%eax
}
  8009b9:	c9                   	leave  
  8009ba:	c3                   	ret    

008009bb <opencons>:

int
opencons(void)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8009c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009c4:	89 04 24             	mov    %eax,(%esp)
  8009c7:	e8 db 17 00 00       	call   8021a7 <fd_alloc>
		return r;
  8009cc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8009ce:	85 c0                	test   %eax,%eax
  8009d0:	78 40                	js     800a12 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8009d9:	00 
  8009da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009e8:	e8 16 0e 00 00       	call   801803 <sys_page_alloc>
		return r;
  8009ed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009ef:	85 c0                	test   %eax,%eax
  8009f1:	78 1f                	js     800a12 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8009f3:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009fc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8009fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a01:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800a08:	89 04 24             	mov    %eax,(%esp)
  800a0b:	e8 70 17 00 00       	call   802180 <fd2num>
  800a10:	89 c2                	mov    %eax,%edx
}
  800a12:	89 d0                	mov    %edx,%eax
  800a14:	c9                   	leave  
  800a15:	c3                   	ret    

00800a16 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	56                   	push   %esi
  800a1a:	53                   	push   %ebx
  800a1b:	83 ec 10             	sub    $0x10,%esp
  800a1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a21:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800a24:	e8 9c 0d 00 00       	call   8017c5 <sys_getenvid>
  800a29:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a2e:	89 c2                	mov    %eax,%edx
  800a30:	c1 e2 07             	shl    $0x7,%edx
  800a33:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800a3a:	a3 28 64 80 00       	mov    %eax,0x806428

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a3f:	85 db                	test   %ebx,%ebx
  800a41:	7e 07                	jle    800a4a <libmain+0x34>
		binaryname = argv[0];
  800a43:	8b 06                	mov    (%esi),%eax
  800a45:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	umain(argc, argv);
  800a4a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a4e:	89 1c 24             	mov    %ebx,(%esp)
  800a51:	e8 26 fc ff ff       	call   80067c <umain>

	// exit gracefully
	exit();
  800a56:	e8 07 00 00 00       	call   800a62 <exit>
}
  800a5b:	83 c4 10             	add    $0x10,%esp
  800a5e:	5b                   	pop    %ebx
  800a5f:	5e                   	pop    %esi
  800a60:	5d                   	pop    %ebp
  800a61:	c3                   	ret    

00800a62 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800a68:	e8 ed 18 00 00       	call   80235a <close_all>
	sys_env_destroy(0);
  800a6d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a74:	e8 fa 0c 00 00       	call   801773 <sys_env_destroy>
}
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	56                   	push   %esi
  800a7f:	53                   	push   %ebx
  800a80:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800a83:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a86:	8b 35 1c 50 80 00    	mov    0x80501c,%esi
  800a8c:	e8 34 0d 00 00       	call   8017c5 <sys_getenvid>
  800a91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a94:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a98:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a9f:	89 74 24 08          	mov    %esi,0x8(%esp)
  800aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa7:	c7 04 24 38 41 80 00 	movl   $0x804138,(%esp)
  800aae:	e8 c1 00 00 00       	call   800b74 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ab3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ab7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aba:	89 04 24             	mov    %eax,(%esp)
  800abd:	e8 51 00 00 00       	call   800b13 <vcprintf>
	cprintf("\n");
  800ac2:	c7 04 24 20 3f 80 00 	movl   $0x803f20,(%esp)
  800ac9:	e8 a6 00 00 00       	call   800b74 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800ace:	cc                   	int3   
  800acf:	eb fd                	jmp    800ace <_panic+0x53>

00800ad1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	53                   	push   %ebx
  800ad5:	83 ec 14             	sub    $0x14,%esp
  800ad8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800adb:	8b 13                	mov    (%ebx),%edx
  800add:	8d 42 01             	lea    0x1(%edx),%eax
  800ae0:	89 03                	mov    %eax,(%ebx)
  800ae2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800ae9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800aee:	75 19                	jne    800b09 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800af0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800af7:	00 
  800af8:	8d 43 08             	lea    0x8(%ebx),%eax
  800afb:	89 04 24             	mov    %eax,(%esp)
  800afe:	e8 33 0c 00 00       	call   801736 <sys_cputs>
		b->idx = 0;
  800b03:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800b09:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800b0d:	83 c4 14             	add    $0x14,%esp
  800b10:	5b                   	pop    %ebx
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800b1c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b23:	00 00 00 
	b.cnt = 0;
  800b26:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b2d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b3e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b48:	c7 04 24 d1 0a 80 00 	movl   $0x800ad1,(%esp)
  800b4f:	e8 aa 01 00 00       	call   800cfe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b54:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b5e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b64:	89 04 24             	mov    %eax,(%esp)
  800b67:	e8 ca 0b 00 00       	call   801736 <sys_cputs>

	return b.cnt;
}
  800b6c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b7a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	89 04 24             	mov    %eax,(%esp)
  800b87:	e8 87 ff ff ff       	call   800b13 <vcprintf>
	va_end(ap);

	return cnt;
}
  800b8c:	c9                   	leave  
  800b8d:	c3                   	ret    
  800b8e:	66 90                	xchg   %ax,%ax

00800b90 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	57                   	push   %edi
  800b94:	56                   	push   %esi
  800b95:	53                   	push   %ebx
  800b96:	83 ec 3c             	sub    $0x3c,%esp
  800b99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b9c:	89 d7                	mov    %edx,%edi
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba7:	89 c3                	mov    %eax,%ebx
  800ba9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800bac:	8b 45 10             	mov    0x10(%ebp),%eax
  800baf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bb7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800bbd:	39 d9                	cmp    %ebx,%ecx
  800bbf:	72 05                	jb     800bc6 <printnum+0x36>
  800bc1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800bc4:	77 69                	ja     800c2f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bc6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bc9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800bcd:	83 ee 01             	sub    $0x1,%esi
  800bd0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800bd4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bd8:	8b 44 24 08          	mov    0x8(%esp),%eax
  800bdc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800be0:	89 c3                	mov    %eax,%ebx
  800be2:	89 d6                	mov    %edx,%esi
  800be4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800be7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800bea:	89 54 24 08          	mov    %edx,0x8(%esp)
  800bee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800bf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bf5:	89 04 24             	mov    %eax,(%esp)
  800bf8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bff:	e8 6c 30 00 00       	call   803c70 <__udivdi3>
  800c04:	89 d9                	mov    %ebx,%ecx
  800c06:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800c0a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800c0e:	89 04 24             	mov    %eax,(%esp)
  800c11:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c15:	89 fa                	mov    %edi,%edx
  800c17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c1a:	e8 71 ff ff ff       	call   800b90 <printnum>
  800c1f:	eb 1b                	jmp    800c3c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c21:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c25:	8b 45 18             	mov    0x18(%ebp),%eax
  800c28:	89 04 24             	mov    %eax,(%esp)
  800c2b:	ff d3                	call   *%ebx
  800c2d:	eb 03                	jmp    800c32 <printnum+0xa2>
  800c2f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c32:	83 ee 01             	sub    $0x1,%esi
  800c35:	85 f6                	test   %esi,%esi
  800c37:	7f e8                	jg     800c21 <printnum+0x91>
  800c39:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c3c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c40:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c44:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c47:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c4e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c55:	89 04 24             	mov    %eax,(%esp)
  800c58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c5f:	e8 3c 31 00 00       	call   803da0 <__umoddi3>
  800c64:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c68:	0f be 80 5b 41 80 00 	movsbl 0x80415b(%eax),%eax
  800c6f:	89 04 24             	mov    %eax,(%esp)
  800c72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c75:	ff d0                	call   *%eax
}
  800c77:	83 c4 3c             	add    $0x3c,%esp
  800c7a:	5b                   	pop    %ebx
  800c7b:	5e                   	pop    %esi
  800c7c:	5f                   	pop    %edi
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c82:	83 fa 01             	cmp    $0x1,%edx
  800c85:	7e 0e                	jle    800c95 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800c87:	8b 10                	mov    (%eax),%edx
  800c89:	8d 4a 08             	lea    0x8(%edx),%ecx
  800c8c:	89 08                	mov    %ecx,(%eax)
  800c8e:	8b 02                	mov    (%edx),%eax
  800c90:	8b 52 04             	mov    0x4(%edx),%edx
  800c93:	eb 22                	jmp    800cb7 <getuint+0x38>
	else if (lflag)
  800c95:	85 d2                	test   %edx,%edx
  800c97:	74 10                	je     800ca9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800c99:	8b 10                	mov    (%eax),%edx
  800c9b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c9e:	89 08                	mov    %ecx,(%eax)
  800ca0:	8b 02                	mov    (%edx),%eax
  800ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca7:	eb 0e                	jmp    800cb7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800ca9:	8b 10                	mov    (%eax),%edx
  800cab:	8d 4a 04             	lea    0x4(%edx),%ecx
  800cae:	89 08                	mov    %ecx,(%eax)
  800cb0:	8b 02                	mov    (%edx),%eax
  800cb2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    

00800cb9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800cbf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800cc3:	8b 10                	mov    (%eax),%edx
  800cc5:	3b 50 04             	cmp    0x4(%eax),%edx
  800cc8:	73 0a                	jae    800cd4 <sprintputch+0x1b>
		*b->buf++ = ch;
  800cca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccd:	89 08                	mov    %ecx,(%eax)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	88 02                	mov    %al,(%edx)
}
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    

00800cd6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cdc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800cdf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ce3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce6:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ced:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	89 04 24             	mov    %eax,(%esp)
  800cf7:	e8 02 00 00 00       	call   800cfe <vprintfmt>
	va_end(ap);
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	57                   	push   %edi
  800d02:	56                   	push   %esi
  800d03:	53                   	push   %ebx
  800d04:	83 ec 3c             	sub    $0x3c,%esp
  800d07:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0d:	eb 14                	jmp    800d23 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800d0f:	85 c0                	test   %eax,%eax
  800d11:	0f 84 b3 03 00 00    	je     8010ca <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800d17:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d1b:	89 04 24             	mov    %eax,(%esp)
  800d1e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d21:	89 f3                	mov    %esi,%ebx
  800d23:	8d 73 01             	lea    0x1(%ebx),%esi
  800d26:	0f b6 03             	movzbl (%ebx),%eax
  800d29:	83 f8 25             	cmp    $0x25,%eax
  800d2c:	75 e1                	jne    800d0f <vprintfmt+0x11>
  800d2e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800d32:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800d39:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800d40:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800d47:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4c:	eb 1d                	jmp    800d6b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d4e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800d50:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800d54:	eb 15                	jmp    800d6b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d56:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d58:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800d5c:	eb 0d                	jmp    800d6b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800d5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d61:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d64:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d6b:	8d 5e 01             	lea    0x1(%esi),%ebx
  800d6e:	0f b6 0e             	movzbl (%esi),%ecx
  800d71:	0f b6 c1             	movzbl %cl,%eax
  800d74:	83 e9 23             	sub    $0x23,%ecx
  800d77:	80 f9 55             	cmp    $0x55,%cl
  800d7a:	0f 87 2a 03 00 00    	ja     8010aa <vprintfmt+0x3ac>
  800d80:	0f b6 c9             	movzbl %cl,%ecx
  800d83:	ff 24 8d e0 42 80 00 	jmp    *0x8042e0(,%ecx,4)
  800d8a:	89 de                	mov    %ebx,%esi
  800d8c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800d91:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800d94:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800d98:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800d9b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800d9e:	83 fb 09             	cmp    $0x9,%ebx
  800da1:	77 36                	ja     800dd9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800da3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800da6:	eb e9                	jmp    800d91 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800da8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dab:	8d 48 04             	lea    0x4(%eax),%ecx
  800dae:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800db1:	8b 00                	mov    (%eax),%eax
  800db3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800db6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800db8:	eb 22                	jmp    800ddc <vprintfmt+0xde>
  800dba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800dbd:	85 c9                	test   %ecx,%ecx
  800dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc4:	0f 49 c1             	cmovns %ecx,%eax
  800dc7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dca:	89 de                	mov    %ebx,%esi
  800dcc:	eb 9d                	jmp    800d6b <vprintfmt+0x6d>
  800dce:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800dd0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800dd7:	eb 92                	jmp    800d6b <vprintfmt+0x6d>
  800dd9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  800ddc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800de0:	79 89                	jns    800d6b <vprintfmt+0x6d>
  800de2:	e9 77 ff ff ff       	jmp    800d5e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800de7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dea:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800dec:	e9 7a ff ff ff       	jmp    800d6b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800df1:	8b 45 14             	mov    0x14(%ebp),%eax
  800df4:	8d 50 04             	lea    0x4(%eax),%edx
  800df7:	89 55 14             	mov    %edx,0x14(%ebp)
  800dfa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800dfe:	8b 00                	mov    (%eax),%eax
  800e00:	89 04 24             	mov    %eax,(%esp)
  800e03:	ff 55 08             	call   *0x8(%ebp)
			break;
  800e06:	e9 18 ff ff ff       	jmp    800d23 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0e:	8d 50 04             	lea    0x4(%eax),%edx
  800e11:	89 55 14             	mov    %edx,0x14(%ebp)
  800e14:	8b 00                	mov    (%eax),%eax
  800e16:	99                   	cltd   
  800e17:	31 d0                	xor    %edx,%eax
  800e19:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e1b:	83 f8 12             	cmp    $0x12,%eax
  800e1e:	7f 0b                	jg     800e2b <vprintfmt+0x12d>
  800e20:	8b 14 85 40 44 80 00 	mov    0x804440(,%eax,4),%edx
  800e27:	85 d2                	test   %edx,%edx
  800e29:	75 20                	jne    800e4b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  800e2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e2f:	c7 44 24 08 73 41 80 	movl   $0x804173,0x8(%esp)
  800e36:	00 
  800e37:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	89 04 24             	mov    %eax,(%esp)
  800e41:	e8 90 fe ff ff       	call   800cd6 <printfmt>
  800e46:	e9 d8 fe ff ff       	jmp    800d23 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800e4b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e4f:	c7 44 24 08 7b 40 80 	movl   $0x80407b,0x8(%esp)
  800e56:	00 
  800e57:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	89 04 24             	mov    %eax,(%esp)
  800e61:	e8 70 fe ff ff       	call   800cd6 <printfmt>
  800e66:	e9 b8 fe ff ff       	jmp    800d23 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e6b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800e6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e71:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e74:	8b 45 14             	mov    0x14(%ebp),%eax
  800e77:	8d 50 04             	lea    0x4(%eax),%edx
  800e7a:	89 55 14             	mov    %edx,0x14(%ebp)
  800e7d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800e7f:	85 f6                	test   %esi,%esi
  800e81:	b8 6c 41 80 00       	mov    $0x80416c,%eax
  800e86:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800e89:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800e8d:	0f 84 97 00 00 00    	je     800f2a <vprintfmt+0x22c>
  800e93:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800e97:	0f 8e 9b 00 00 00    	jle    800f38 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e9d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ea1:	89 34 24             	mov    %esi,(%esp)
  800ea4:	e8 1f 05 00 00       	call   8013c8 <strnlen>
  800ea9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800eac:	29 c2                	sub    %eax,%edx
  800eae:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800eb1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800eb5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800eb8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800ebb:	8b 75 08             	mov    0x8(%ebp),%esi
  800ebe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ec1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ec3:	eb 0f                	jmp    800ed4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800ec5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ec9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ecc:	89 04 24             	mov    %eax,(%esp)
  800ecf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ed1:	83 eb 01             	sub    $0x1,%ebx
  800ed4:	85 db                	test   %ebx,%ebx
  800ed6:	7f ed                	jg     800ec5 <vprintfmt+0x1c7>
  800ed8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800edb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800ede:	85 d2                	test   %edx,%edx
  800ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee5:	0f 49 c2             	cmovns %edx,%eax
  800ee8:	29 c2                	sub    %eax,%edx
  800eea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800eed:	89 d7                	mov    %edx,%edi
  800eef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ef2:	eb 50                	jmp    800f44 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800ef4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ef8:	74 1e                	je     800f18 <vprintfmt+0x21a>
  800efa:	0f be d2             	movsbl %dl,%edx
  800efd:	83 ea 20             	sub    $0x20,%edx
  800f00:	83 fa 5e             	cmp    $0x5e,%edx
  800f03:	76 13                	jbe    800f18 <vprintfmt+0x21a>
					putch('?', putdat);
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f0c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800f13:	ff 55 08             	call   *0x8(%ebp)
  800f16:	eb 0d                	jmp    800f25 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800f18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f1f:	89 04 24             	mov    %eax,(%esp)
  800f22:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f25:	83 ef 01             	sub    $0x1,%edi
  800f28:	eb 1a                	jmp    800f44 <vprintfmt+0x246>
  800f2a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800f2d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800f30:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f33:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800f36:	eb 0c                	jmp    800f44 <vprintfmt+0x246>
  800f38:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800f3b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800f3e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f41:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800f44:	83 c6 01             	add    $0x1,%esi
  800f47:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800f4b:	0f be c2             	movsbl %dl,%eax
  800f4e:	85 c0                	test   %eax,%eax
  800f50:	74 27                	je     800f79 <vprintfmt+0x27b>
  800f52:	85 db                	test   %ebx,%ebx
  800f54:	78 9e                	js     800ef4 <vprintfmt+0x1f6>
  800f56:	83 eb 01             	sub    $0x1,%ebx
  800f59:	79 99                	jns    800ef4 <vprintfmt+0x1f6>
  800f5b:	89 f8                	mov    %edi,%eax
  800f5d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f60:	8b 75 08             	mov    0x8(%ebp),%esi
  800f63:	89 c3                	mov    %eax,%ebx
  800f65:	eb 1a                	jmp    800f81 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800f67:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f6b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800f72:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f74:	83 eb 01             	sub    $0x1,%ebx
  800f77:	eb 08                	jmp    800f81 <vprintfmt+0x283>
  800f79:	89 fb                	mov    %edi,%ebx
  800f7b:	8b 75 08             	mov    0x8(%ebp),%esi
  800f7e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f81:	85 db                	test   %ebx,%ebx
  800f83:	7f e2                	jg     800f67 <vprintfmt+0x269>
  800f85:	89 75 08             	mov    %esi,0x8(%ebp)
  800f88:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f8b:	e9 93 fd ff ff       	jmp    800d23 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800f90:	83 fa 01             	cmp    $0x1,%edx
  800f93:	7e 16                	jle    800fab <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800f95:	8b 45 14             	mov    0x14(%ebp),%eax
  800f98:	8d 50 08             	lea    0x8(%eax),%edx
  800f9b:	89 55 14             	mov    %edx,0x14(%ebp)
  800f9e:	8b 50 04             	mov    0x4(%eax),%edx
  800fa1:	8b 00                	mov    (%eax),%eax
  800fa3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800fa6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800fa9:	eb 32                	jmp    800fdd <vprintfmt+0x2df>
	else if (lflag)
  800fab:	85 d2                	test   %edx,%edx
  800fad:	74 18                	je     800fc7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800faf:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb2:	8d 50 04             	lea    0x4(%eax),%edx
  800fb5:	89 55 14             	mov    %edx,0x14(%ebp)
  800fb8:	8b 30                	mov    (%eax),%esi
  800fba:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800fbd:	89 f0                	mov    %esi,%eax
  800fbf:	c1 f8 1f             	sar    $0x1f,%eax
  800fc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fc5:	eb 16                	jmp    800fdd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800fc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fca:	8d 50 04             	lea    0x4(%eax),%edx
  800fcd:	89 55 14             	mov    %edx,0x14(%ebp)
  800fd0:	8b 30                	mov    (%eax),%esi
  800fd2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800fd5:	89 f0                	mov    %esi,%eax
  800fd7:	c1 f8 1f             	sar    $0x1f,%eax
  800fda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800fe3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800fe8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fec:	0f 89 80 00 00 00    	jns    801072 <vprintfmt+0x374>
				putch('-', putdat);
  800ff2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ff6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800ffd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801000:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801003:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801006:	f7 d8                	neg    %eax
  801008:	83 d2 00             	adc    $0x0,%edx
  80100b:	f7 da                	neg    %edx
			}
			base = 10;
  80100d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801012:	eb 5e                	jmp    801072 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801014:	8d 45 14             	lea    0x14(%ebp),%eax
  801017:	e8 63 fc ff ff       	call   800c7f <getuint>
			base = 10;
  80101c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801021:	eb 4f                	jmp    801072 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  801023:	8d 45 14             	lea    0x14(%ebp),%eax
  801026:	e8 54 fc ff ff       	call   800c7f <getuint>
			base = 8;
  80102b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801030:	eb 40                	jmp    801072 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  801032:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801036:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80103d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801040:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801044:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80104b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80104e:	8b 45 14             	mov    0x14(%ebp),%eax
  801051:	8d 50 04             	lea    0x4(%eax),%edx
  801054:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801057:	8b 00                	mov    (%eax),%eax
  801059:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80105e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801063:	eb 0d                	jmp    801072 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801065:	8d 45 14             	lea    0x14(%ebp),%eax
  801068:	e8 12 fc ff ff       	call   800c7f <getuint>
			base = 16;
  80106d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801072:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  801076:	89 74 24 10          	mov    %esi,0x10(%esp)
  80107a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80107d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801081:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801085:	89 04 24             	mov    %eax,(%esp)
  801088:	89 54 24 04          	mov    %edx,0x4(%esp)
  80108c:	89 fa                	mov    %edi,%edx
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	e8 fa fa ff ff       	call   800b90 <printnum>
			break;
  801096:	e9 88 fc ff ff       	jmp    800d23 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80109b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80109f:	89 04 24             	mov    %eax,(%esp)
  8010a2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8010a5:	e9 79 fc ff ff       	jmp    800d23 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010ae:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8010b5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010b8:	89 f3                	mov    %esi,%ebx
  8010ba:	eb 03                	jmp    8010bf <vprintfmt+0x3c1>
  8010bc:	83 eb 01             	sub    $0x1,%ebx
  8010bf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8010c3:	75 f7                	jne    8010bc <vprintfmt+0x3be>
  8010c5:	e9 59 fc ff ff       	jmp    800d23 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8010ca:	83 c4 3c             	add    $0x3c,%esp
  8010cd:	5b                   	pop    %ebx
  8010ce:	5e                   	pop    %esi
  8010cf:	5f                   	pop    %edi
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 28             	sub    $0x28,%esp
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010e1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8010e5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8010e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010ef:	85 c0                	test   %eax,%eax
  8010f1:	74 30                	je     801123 <vsnprintf+0x51>
  8010f3:	85 d2                	test   %edx,%edx
  8010f5:	7e 2c                	jle    801123 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801101:	89 44 24 08          	mov    %eax,0x8(%esp)
  801105:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801108:	89 44 24 04          	mov    %eax,0x4(%esp)
  80110c:	c7 04 24 b9 0c 80 00 	movl   $0x800cb9,(%esp)
  801113:	e8 e6 fb ff ff       	call   800cfe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801118:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80111b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80111e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801121:	eb 05                	jmp    801128 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801123:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801128:	c9                   	leave  
  801129:	c3                   	ret    

0080112a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801130:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801133:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801137:	8b 45 10             	mov    0x10(%ebp),%eax
  80113a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	89 44 24 04          	mov    %eax,0x4(%esp)
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	89 04 24             	mov    %eax,(%esp)
  80114b:	e8 82 ff ff ff       	call   8010d2 <vsnprintf>
	va_end(ap);

	return rc;
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    
  801152:	66 90                	xchg   %ax,%ax
  801154:	66 90                	xchg   %ax,%ax
  801156:	66 90                	xchg   %ax,%ax
  801158:	66 90                	xchg   %ax,%ax
  80115a:	66 90                	xchg   %ax,%ax
  80115c:	66 90                	xchg   %ax,%ax
  80115e:	66 90                	xchg   %ax,%ax

00801160 <tab_handler>:
	}
}

int
tab_handler(int tab_pos)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	57                   	push   %edi
  801164:	56                   	push   %esi
  801165:	53                   	push   %ebx
  801166:	83 ec 3c             	sub    $0x3c,%esp
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
	char* begin = buf + tab_pos;
  80116c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80116f:	05 20 60 80 00       	add    $0x806020,%eax
  801174:	89 c6                	mov    %eax,%esi
	while ((begin > buf) && (*(begin -1) != ' '))
  801176:	eb 03                	jmp    80117b <tab_handler+0x1b>
		begin--;
  801178:	83 ee 01             	sub    $0x1,%esi

int
tab_handler(int tab_pos)
{
	char* begin = buf + tab_pos;
	while ((begin > buf) && (*(begin -1) != ' '))
  80117b:	81 fe 20 60 80 00    	cmp    $0x806020,%esi
  801181:	76 06                	jbe    801189 <tab_handler+0x29>
  801183:	80 7e ff 20          	cmpb   $0x20,-0x1(%esi)
  801187:	75 ef                	jne    801178 <tab_handler+0x18>
		begin--;
	
	int len = buf + tab_pos - begin, found_num = 0, cmd_append_len = 0, i;
  801189:	29 f0                	sub    %esi,%eax
  80118b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	char* cmd = 0;
  80118e:	bb 00 00 00 00       	mov    $0x0,%ebx

    	for (i = 0; len > 0 && i < NUM_CMDS; i++) {
  801193:	bf 00 00 00 00       	mov    $0x0,%edi
{
	char* begin = buf + tab_pos;
	while ((begin > buf) && (*(begin -1) != ' '))
		begin--;
	
	int len = buf + tab_pos - begin, found_num = 0, cmd_append_len = 0, i;
  801198:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  80119f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8011a6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8011a9:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8011ac:	89 c6                	mov    %eax,%esi
	char* cmd = 0;

    	for (i = 0; len > 0 && i < NUM_CMDS; i++) {
  8011ae:	eb 35                	jmp    8011e5 <tab_handler+0x85>
      		if (strncmp(begin, commands[i], len) == 0) {
  8011b0:	8b 1c bd 60 45 80 00 	mov    0x804560(,%edi,4),%ebx
  8011b7:	89 74 24 08          	mov    %esi,0x8(%esp)
  8011bb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011c2:	89 04 24             	mov    %eax,(%esp)
  8011c5:	e8 f8 02 00 00       	call   8014c2 <strncmp>
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	75 14                	jne    8011e2 <tab_handler+0x82>
			found_num++;
  8011ce:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
         		cmd = commands[i];
         		cmd_append_len = strlen(cmd) - len;
  8011d2:	89 1c 24             	mov    %ebx,(%esp)
  8011d5:	e8 d6 01 00 00       	call   8013b0 <strlen>
  8011da:	29 f0                	sub    %esi,%eax
  8011dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	char* cmd = 0;

    	for (i = 0; len > 0 && i < NUM_CMDS; i++) {
      		if (strncmp(begin, commands[i], len) == 0) {
			found_num++;
         		cmd = commands[i];
  8011df:	89 5d d8             	mov    %ebx,-0x28(%ebp)
		begin--;
	
	int len = buf + tab_pos - begin, found_num = 0, cmd_append_len = 0, i;
	char* cmd = 0;

    	for (i = 0; len > 0 && i < NUM_CMDS; i++) {
  8011e2:	83 c7 01             	add    $0x1,%edi
  8011e5:	83 ff 10             	cmp    $0x10,%edi
  8011e8:	7f 04                	jg     8011ee <tab_handler+0x8e>
  8011ea:	85 f6                	test   %esi,%esi
  8011ec:	7f c2                	jg     8011b0 <tab_handler+0x50>
  8011ee:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8011f1:	8b 5d d8             	mov    -0x28(%ebp),%ebx
         		cmd = commands[i];
         		cmd_append_len = strlen(cmd) - len;
      		}
   	}

	if (found_num > 1) {
  8011f4:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8011f8:	7e 72                	jle    80126c <tab_handler+0x10c>
		#if JOS_KERNEL
			cprintf("\nYour options are:\n");
		#else
			fprintf(1, "\nYour options are:\n");
  8011fa:	c7 44 24 04 ab 44 80 	movl   $0x8044ab,0x4(%esp)
  801201:	00 
  801202:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801209:	e8 d7 18 00 00       	call   802ae5 <fprintf>
		#endif
		for (i = 0; i < NUM_CMDS; i++) {
  80120e:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (strncmp(begin, commands[i], len) == 0) {
  801213:	8b 3c 9d 60 45 80 00 	mov    0x804560(,%ebx,4),%edi
  80121a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80121d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801221:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801225:	89 34 24             	mov    %esi,(%esp)
  801228:	e8 95 02 00 00       	call   8014c2 <strncmp>
  80122d:	85 c0                	test   %eax,%eax
  80122f:	75 18                	jne    801249 <tab_handler+0xe9>
                    		#if JOS_KERNEL
                            		cprintf("%s\n", commands[i]);
                   		 #else
                           		fprintf(1, "%s\n", commands[i]);
  801231:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801235:	c7 44 24 04 93 40 80 	movl   $0x804093,0x4(%esp)
  80123c:	00 
  80123d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801244:	e8 9c 18 00 00       	call   802ae5 <fprintf>
		#if JOS_KERNEL
			cprintf("\nYour options are:\n");
		#else
			fprintf(1, "\nYour options are:\n");
		#endif
		for (i = 0; i < NUM_CMDS; i++) {
  801249:	83 c3 01             	add    $0x1,%ebx
  80124c:	83 fb 11             	cmp    $0x11,%ebx
  80124f:	75 c2                	jne    801213 <tab_handler+0xb3>
                 	}
            	}
		#if JOS_KERNEL
			cprintf("$ ");
		#else
			fprintf(1, "$ ");
  801251:	c7 44 24 04 53 40 80 	movl   $0x804053,0x4(%esp)
  801258:	00 
  801259:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801260:	e8 80 18 00 00       	call   802ae5 <fprintf>
		#endif
		return -len;
  801265:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801268:	f7 d8                	neg    %eax
  80126a:	eb 3e                	jmp    8012aa <tab_handler+0x14a>
  80126c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80126f:	89 d0                	mov    %edx,%eax
	}

	int pos_to_write = tab_pos;

	if (cmd_append_len > 0){
  801271:	85 d2                	test   %edx,%edx
  801273:	7e 35                	jle    8012aa <tab_handler+0x14a>
  801275:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801278:	89 c6                	mov    %eax,%esi
  80127a:	8b 7d d0             	mov    -0x30(%ebp),%edi
  80127d:	29 c7                	sub    %eax,%edi
  80127f:	eb 1a                	jmp    80129b <tab_handler+0x13b>
		for (i = len; i < strlen(cmd); i++) {
      			buf[pos_to_write] = cmd[i];
  801281:	0f b6 04 33          	movzbl (%ebx,%esi,1),%eax
  801285:	88 84 37 20 60 80 00 	mov    %al,0x806020(%edi,%esi,1)
			pos_to_write++;
      			cputchar(cmd[i]);
  80128c:	0f be 04 33          	movsbl (%ebx,%esi,1),%eax
  801290:	89 04 24             	mov    %eax,(%esp)
  801293:	e8 9d f6 ff ff       	call   800935 <cputchar>
	}

	int pos_to_write = tab_pos;

	if (cmd_append_len > 0){
		for (i = len; i < strlen(cmd); i++) {
  801298:	83 c6 01             	add    $0x1,%esi
  80129b:	89 1c 24             	mov    %ebx,(%esp)
  80129e:	e8 0d 01 00 00       	call   8013b0 <strlen>
  8012a3:	39 c6                	cmp    %eax,%esi
  8012a5:	7c da                	jl     801281 <tab_handler+0x121>
  8012a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   		}

	}

	return cmd_append_len;
}
  8012aa:	83 c4 3c             	add    $0x3c,%esp
  8012ad:	5b                   	pop    %ebx
  8012ae:	5e                   	pop    %esi
  8012af:	5f                   	pop    %edi
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    

008012b2 <readline>:
int tab_handler(int tab_pos);


char *
readline(const char *prompt)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	57                   	push   %edi
  8012b6:	56                   	push   %esi
  8012b7:	53                   	push   %ebx
  8012b8:	83 ec 1c             	sub    $0x1c,%esp
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	74 18                	je     8012da <readline+0x28>
		fprintf(1, "%s", prompt);
  8012c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012c6:	c7 44 24 04 7b 40 80 	movl   $0x80407b,0x4(%esp)
  8012cd:	00 
  8012ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8012d5:	e8 0b 18 00 00       	call   802ae5 <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  8012da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012e1:	e8 a6 f6 ff ff       	call   80098c <iscons>
  8012e6:	89 c7                	mov    %eax,%edi
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
  8012e8:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
  8012ed:	e8 64 f6 ff ff       	call   800956 <getchar>
  8012f2:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	79 28                	jns    801320 <readline+0x6e>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  8012f8:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  8012fd:	83 fb f8             	cmp    $0xfffffff8,%ebx
  801300:	0f 84 a1 00 00 00    	je     8013a7 <readline+0xf5>
				cprintf("read error: %e\n", c);
  801306:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80130a:	c7 04 24 bf 44 80 00 	movl   $0x8044bf,(%esp)
  801311:	e8 5e f8 ff ff       	call   800b74 <cprintf>
			return NULL;
  801316:	b8 00 00 00 00       	mov    $0x0,%eax
  80131b:	e9 87 00 00 00       	jmp    8013a7 <readline+0xf5>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  801320:	83 f8 7f             	cmp    $0x7f,%eax
  801323:	74 05                	je     80132a <readline+0x78>
  801325:	83 f8 08             	cmp    $0x8,%eax
  801328:	75 19                	jne    801343 <readline+0x91>
  80132a:	85 f6                	test   %esi,%esi
  80132c:	7e 15                	jle    801343 <readline+0x91>
			if (echoing)
  80132e:	85 ff                	test   %edi,%edi
  801330:	74 0c                	je     80133e <readline+0x8c>
				cputchar('\b');
  801332:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  801339:	e8 f7 f5 ff ff       	call   800935 <cputchar>
			i--;
  80133e:	83 ee 01             	sub    $0x1,%esi
  801341:	eb aa                	jmp    8012ed <readline+0x3b>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801343:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  801349:	7f 1c                	jg     801367 <readline+0xb5>
  80134b:	83 fb 1f             	cmp    $0x1f,%ebx
  80134e:	7e 17                	jle    801367 <readline+0xb5>
			if (echoing)
  801350:	85 ff                	test   %edi,%edi
  801352:	74 08                	je     80135c <readline+0xaa>
				cputchar(c);
  801354:	89 1c 24             	mov    %ebx,(%esp)
  801357:	e8 d9 f5 ff ff       	call   800935 <cputchar>
			buf[i++] = c;
  80135c:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
  801362:	8d 76 01             	lea    0x1(%esi),%esi
  801365:	eb 86                	jmp    8012ed <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  801367:	83 fb 0d             	cmp    $0xd,%ebx
  80136a:	74 05                	je     801371 <readline+0xbf>
  80136c:	83 fb 0a             	cmp    $0xa,%ebx
  80136f:	75 1e                	jne    80138f <readline+0xdd>
			if (echoing)
  801371:	85 ff                	test   %edi,%edi
  801373:	74 0c                	je     801381 <readline+0xcf>
				cputchar('\n');
  801375:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80137c:	e8 b4 f5 ff ff       	call   800935 <cputchar>
			buf[i] = 0;
  801381:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
			return buf;
  801388:	b8 20 60 80 00       	mov    $0x806020,%eax
  80138d:	eb 18                	jmp    8013a7 <readline+0xf5>
		} else if (c == '\t') {
  80138f:	83 fb 09             	cmp    $0x9,%ebx
  801392:	0f 85 55 ff ff ff    	jne    8012ed <readline+0x3b>
			i += tab_handler(i);
  801398:	89 34 24             	mov    %esi,(%esp)
  80139b:	e8 c0 fd ff ff       	call   801160 <tab_handler>
  8013a0:	01 c6                	add    %eax,%esi
  8013a2:	e9 46 ff ff ff       	jmp    8012ed <readline+0x3b>
		}
	}
}
  8013a7:	83 c4 1c             	add    $0x1c,%esp
  8013aa:	5b                   	pop    %ebx
  8013ab:	5e                   	pop    %esi
  8013ac:	5f                   	pop    %edi
  8013ad:	5d                   	pop    %ebp
  8013ae:	c3                   	ret    
  8013af:	90                   	nop

008013b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8013b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bb:	eb 03                	jmp    8013c0 <strlen+0x10>
		n++;
  8013bd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8013c4:	75 f7                	jne    8013bd <strlen+0xd>
		n++;
	return n;
}
  8013c6:	5d                   	pop    %ebp
  8013c7:	c3                   	ret    

008013c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d6:	eb 03                	jmp    8013db <strnlen+0x13>
		n++;
  8013d8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013db:	39 d0                	cmp    %edx,%eax
  8013dd:	74 06                	je     8013e5 <strnlen+0x1d>
  8013df:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8013e3:	75 f3                	jne    8013d8 <strnlen+0x10>
		n++;
	return n;
}
  8013e5:	5d                   	pop    %ebp
  8013e6:	c3                   	ret    

008013e7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	53                   	push   %ebx
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8013f1:	89 c2                	mov    %eax,%edx
  8013f3:	83 c2 01             	add    $0x1,%edx
  8013f6:	83 c1 01             	add    $0x1,%ecx
  8013f9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8013fd:	88 5a ff             	mov    %bl,-0x1(%edx)
  801400:	84 db                	test   %bl,%bl
  801402:	75 ef                	jne    8013f3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801404:	5b                   	pop    %ebx
  801405:	5d                   	pop    %ebp
  801406:	c3                   	ret    

00801407 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
  80140a:	53                   	push   %ebx
  80140b:	83 ec 08             	sub    $0x8,%esp
  80140e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801411:	89 1c 24             	mov    %ebx,(%esp)
  801414:	e8 97 ff ff ff       	call   8013b0 <strlen>
	strcpy(dst + len, src);
  801419:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801420:	01 d8                	add    %ebx,%eax
  801422:	89 04 24             	mov    %eax,(%esp)
  801425:	e8 bd ff ff ff       	call   8013e7 <strcpy>
	return dst;
}
  80142a:	89 d8                	mov    %ebx,%eax
  80142c:	83 c4 08             	add    $0x8,%esp
  80142f:	5b                   	pop    %ebx
  801430:	5d                   	pop    %ebp
  801431:	c3                   	ret    

00801432 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	56                   	push   %esi
  801436:	53                   	push   %ebx
  801437:	8b 75 08             	mov    0x8(%ebp),%esi
  80143a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80143d:	89 f3                	mov    %esi,%ebx
  80143f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801442:	89 f2                	mov    %esi,%edx
  801444:	eb 0f                	jmp    801455 <strncpy+0x23>
		*dst++ = *src;
  801446:	83 c2 01             	add    $0x1,%edx
  801449:	0f b6 01             	movzbl (%ecx),%eax
  80144c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80144f:	80 39 01             	cmpb   $0x1,(%ecx)
  801452:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801455:	39 da                	cmp    %ebx,%edx
  801457:	75 ed                	jne    801446 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801459:	89 f0                	mov    %esi,%eax
  80145b:	5b                   	pop    %ebx
  80145c:	5e                   	pop    %esi
  80145d:	5d                   	pop    %ebp
  80145e:	c3                   	ret    

0080145f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	56                   	push   %esi
  801463:	53                   	push   %ebx
  801464:	8b 75 08             	mov    0x8(%ebp),%esi
  801467:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80146d:	89 f0                	mov    %esi,%eax
  80146f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801473:	85 c9                	test   %ecx,%ecx
  801475:	75 0b                	jne    801482 <strlcpy+0x23>
  801477:	eb 1d                	jmp    801496 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801479:	83 c0 01             	add    $0x1,%eax
  80147c:	83 c2 01             	add    $0x1,%edx
  80147f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801482:	39 d8                	cmp    %ebx,%eax
  801484:	74 0b                	je     801491 <strlcpy+0x32>
  801486:	0f b6 0a             	movzbl (%edx),%ecx
  801489:	84 c9                	test   %cl,%cl
  80148b:	75 ec                	jne    801479 <strlcpy+0x1a>
  80148d:	89 c2                	mov    %eax,%edx
  80148f:	eb 02                	jmp    801493 <strlcpy+0x34>
  801491:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  801493:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  801496:	29 f0                	sub    %esi,%eax
}
  801498:	5b                   	pop    %ebx
  801499:	5e                   	pop    %esi
  80149a:	5d                   	pop    %ebp
  80149b:	c3                   	ret    

0080149c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8014a5:	eb 06                	jmp    8014ad <strcmp+0x11>
		p++, q++;
  8014a7:	83 c1 01             	add    $0x1,%ecx
  8014aa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014ad:	0f b6 01             	movzbl (%ecx),%eax
  8014b0:	84 c0                	test   %al,%al
  8014b2:	74 04                	je     8014b8 <strcmp+0x1c>
  8014b4:	3a 02                	cmp    (%edx),%al
  8014b6:	74 ef                	je     8014a7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014b8:	0f b6 c0             	movzbl %al,%eax
  8014bb:	0f b6 12             	movzbl (%edx),%edx
  8014be:	29 d0                	sub    %edx,%eax
}
  8014c0:	5d                   	pop    %ebp
  8014c1:	c3                   	ret    

008014c2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	53                   	push   %ebx
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014cc:	89 c3                	mov    %eax,%ebx
  8014ce:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8014d1:	eb 06                	jmp    8014d9 <strncmp+0x17>
		n--, p++, q++;
  8014d3:	83 c0 01             	add    $0x1,%eax
  8014d6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014d9:	39 d8                	cmp    %ebx,%eax
  8014db:	74 15                	je     8014f2 <strncmp+0x30>
  8014dd:	0f b6 08             	movzbl (%eax),%ecx
  8014e0:	84 c9                	test   %cl,%cl
  8014e2:	74 04                	je     8014e8 <strncmp+0x26>
  8014e4:	3a 0a                	cmp    (%edx),%cl
  8014e6:	74 eb                	je     8014d3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014e8:	0f b6 00             	movzbl (%eax),%eax
  8014eb:	0f b6 12             	movzbl (%edx),%edx
  8014ee:	29 d0                	sub    %edx,%eax
  8014f0:	eb 05                	jmp    8014f7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8014f2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8014f7:	5b                   	pop    %ebx
  8014f8:	5d                   	pop    %ebp
  8014f9:	c3                   	ret    

008014fa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801504:	eb 07                	jmp    80150d <strchr+0x13>
		if (*s == c)
  801506:	38 ca                	cmp    %cl,%dl
  801508:	74 0f                	je     801519 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80150a:	83 c0 01             	add    $0x1,%eax
  80150d:	0f b6 10             	movzbl (%eax),%edx
  801510:	84 d2                	test   %dl,%dl
  801512:	75 f2                	jne    801506 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801514:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801519:	5d                   	pop    %ebp
  80151a:	c3                   	ret    

0080151b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801525:	eb 07                	jmp    80152e <strfind+0x13>
		if (*s == c)
  801527:	38 ca                	cmp    %cl,%dl
  801529:	74 0a                	je     801535 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80152b:	83 c0 01             	add    $0x1,%eax
  80152e:	0f b6 10             	movzbl (%eax),%edx
  801531:	84 d2                	test   %dl,%dl
  801533:	75 f2                	jne    801527 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  801535:	5d                   	pop    %ebp
  801536:	c3                   	ret    

00801537 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	57                   	push   %edi
  80153b:	56                   	push   %esi
  80153c:	53                   	push   %ebx
  80153d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801540:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801543:	85 c9                	test   %ecx,%ecx
  801545:	74 36                	je     80157d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801547:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80154d:	75 28                	jne    801577 <memset+0x40>
  80154f:	f6 c1 03             	test   $0x3,%cl
  801552:	75 23                	jne    801577 <memset+0x40>
		c &= 0xFF;
  801554:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801558:	89 d3                	mov    %edx,%ebx
  80155a:	c1 e3 08             	shl    $0x8,%ebx
  80155d:	89 d6                	mov    %edx,%esi
  80155f:	c1 e6 18             	shl    $0x18,%esi
  801562:	89 d0                	mov    %edx,%eax
  801564:	c1 e0 10             	shl    $0x10,%eax
  801567:	09 f0                	or     %esi,%eax
  801569:	09 c2                	or     %eax,%edx
  80156b:	89 d0                	mov    %edx,%eax
  80156d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80156f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801572:	fc                   	cld    
  801573:	f3 ab                	rep stos %eax,%es:(%edi)
  801575:	eb 06                	jmp    80157d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801577:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157a:	fc                   	cld    
  80157b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80157d:	89 f8                	mov    %edi,%eax
  80157f:	5b                   	pop    %ebx
  801580:	5e                   	pop    %esi
  801581:	5f                   	pop    %edi
  801582:	5d                   	pop    %ebp
  801583:	c3                   	ret    

00801584 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	57                   	push   %edi
  801588:	56                   	push   %esi
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80158f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801592:	39 c6                	cmp    %eax,%esi
  801594:	73 35                	jae    8015cb <memmove+0x47>
  801596:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801599:	39 d0                	cmp    %edx,%eax
  80159b:	73 2e                	jae    8015cb <memmove+0x47>
		s += n;
		d += n;
  80159d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8015a0:	89 d6                	mov    %edx,%esi
  8015a2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8015a4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8015aa:	75 13                	jne    8015bf <memmove+0x3b>
  8015ac:	f6 c1 03             	test   $0x3,%cl
  8015af:	75 0e                	jne    8015bf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015b1:	83 ef 04             	sub    $0x4,%edi
  8015b4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8015b7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015ba:	fd                   	std    
  8015bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8015bd:	eb 09                	jmp    8015c8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015bf:	83 ef 01             	sub    $0x1,%edi
  8015c2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015c5:	fd                   	std    
  8015c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015c8:	fc                   	cld    
  8015c9:	eb 1d                	jmp    8015e8 <memmove+0x64>
  8015cb:	89 f2                	mov    %esi,%edx
  8015cd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8015cf:	f6 c2 03             	test   $0x3,%dl
  8015d2:	75 0f                	jne    8015e3 <memmove+0x5f>
  8015d4:	f6 c1 03             	test   $0x3,%cl
  8015d7:	75 0a                	jne    8015e3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015d9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015dc:	89 c7                	mov    %eax,%edi
  8015de:	fc                   	cld    
  8015df:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8015e1:	eb 05                	jmp    8015e8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015e3:	89 c7                	mov    %eax,%edi
  8015e5:	fc                   	cld    
  8015e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8015e8:	5e                   	pop    %esi
  8015e9:	5f                   	pop    %edi
  8015ea:	5d                   	pop    %ebp
  8015eb:	c3                   	ret    

008015ec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8015f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	89 04 24             	mov    %eax,(%esp)
  801606:	e8 79 ff ff ff       	call   801584 <memmove>
}
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	56                   	push   %esi
  801611:	53                   	push   %ebx
  801612:	8b 55 08             	mov    0x8(%ebp),%edx
  801615:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801618:	89 d6                	mov    %edx,%esi
  80161a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80161d:	eb 1a                	jmp    801639 <memcmp+0x2c>
		if (*s1 != *s2)
  80161f:	0f b6 02             	movzbl (%edx),%eax
  801622:	0f b6 19             	movzbl (%ecx),%ebx
  801625:	38 d8                	cmp    %bl,%al
  801627:	74 0a                	je     801633 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801629:	0f b6 c0             	movzbl %al,%eax
  80162c:	0f b6 db             	movzbl %bl,%ebx
  80162f:	29 d8                	sub    %ebx,%eax
  801631:	eb 0f                	jmp    801642 <memcmp+0x35>
		s1++, s2++;
  801633:	83 c2 01             	add    $0x1,%edx
  801636:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801639:	39 f2                	cmp    %esi,%edx
  80163b:	75 e2                	jne    80161f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80163d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801642:	5b                   	pop    %ebx
  801643:	5e                   	pop    %esi
  801644:	5d                   	pop    %ebp
  801645:	c3                   	ret    

00801646 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80164f:	89 c2                	mov    %eax,%edx
  801651:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801654:	eb 07                	jmp    80165d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  801656:	38 08                	cmp    %cl,(%eax)
  801658:	74 07                	je     801661 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80165a:	83 c0 01             	add    $0x1,%eax
  80165d:	39 d0                	cmp    %edx,%eax
  80165f:	72 f5                	jb     801656 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801661:	5d                   	pop    %ebp
  801662:	c3                   	ret    

00801663 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	57                   	push   %edi
  801667:	56                   	push   %esi
  801668:	53                   	push   %ebx
  801669:	8b 55 08             	mov    0x8(%ebp),%edx
  80166c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80166f:	eb 03                	jmp    801674 <strtol+0x11>
		s++;
  801671:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801674:	0f b6 0a             	movzbl (%edx),%ecx
  801677:	80 f9 09             	cmp    $0x9,%cl
  80167a:	74 f5                	je     801671 <strtol+0xe>
  80167c:	80 f9 20             	cmp    $0x20,%cl
  80167f:	74 f0                	je     801671 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  801681:	80 f9 2b             	cmp    $0x2b,%cl
  801684:	75 0a                	jne    801690 <strtol+0x2d>
		s++;
  801686:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801689:	bf 00 00 00 00       	mov    $0x0,%edi
  80168e:	eb 11                	jmp    8016a1 <strtol+0x3e>
  801690:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801695:	80 f9 2d             	cmp    $0x2d,%cl
  801698:	75 07                	jne    8016a1 <strtol+0x3e>
		s++, neg = 1;
  80169a:	8d 52 01             	lea    0x1(%edx),%edx
  80169d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016a1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8016a6:	75 15                	jne    8016bd <strtol+0x5a>
  8016a8:	80 3a 30             	cmpb   $0x30,(%edx)
  8016ab:	75 10                	jne    8016bd <strtol+0x5a>
  8016ad:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8016b1:	75 0a                	jne    8016bd <strtol+0x5a>
		s += 2, base = 16;
  8016b3:	83 c2 02             	add    $0x2,%edx
  8016b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8016bb:	eb 10                	jmp    8016cd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	75 0c                	jne    8016cd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8016c1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8016c3:	80 3a 30             	cmpb   $0x30,(%edx)
  8016c6:	75 05                	jne    8016cd <strtol+0x6a>
		s++, base = 8;
  8016c8:	83 c2 01             	add    $0x1,%edx
  8016cb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8016cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016d2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016d5:	0f b6 0a             	movzbl (%edx),%ecx
  8016d8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8016db:	89 f0                	mov    %esi,%eax
  8016dd:	3c 09                	cmp    $0x9,%al
  8016df:	77 08                	ja     8016e9 <strtol+0x86>
			dig = *s - '0';
  8016e1:	0f be c9             	movsbl %cl,%ecx
  8016e4:	83 e9 30             	sub    $0x30,%ecx
  8016e7:	eb 20                	jmp    801709 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  8016e9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8016ec:	89 f0                	mov    %esi,%eax
  8016ee:	3c 19                	cmp    $0x19,%al
  8016f0:	77 08                	ja     8016fa <strtol+0x97>
			dig = *s - 'a' + 10;
  8016f2:	0f be c9             	movsbl %cl,%ecx
  8016f5:	83 e9 57             	sub    $0x57,%ecx
  8016f8:	eb 0f                	jmp    801709 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8016fa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8016fd:	89 f0                	mov    %esi,%eax
  8016ff:	3c 19                	cmp    $0x19,%al
  801701:	77 16                	ja     801719 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801703:	0f be c9             	movsbl %cl,%ecx
  801706:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801709:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80170c:	7d 0f                	jge    80171d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80170e:	83 c2 01             	add    $0x1,%edx
  801711:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801715:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801717:	eb bc                	jmp    8016d5 <strtol+0x72>
  801719:	89 d8                	mov    %ebx,%eax
  80171b:	eb 02                	jmp    80171f <strtol+0xbc>
  80171d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80171f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801723:	74 05                	je     80172a <strtol+0xc7>
		*endptr = (char *) s;
  801725:	8b 75 0c             	mov    0xc(%ebp),%esi
  801728:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80172a:	f7 d8                	neg    %eax
  80172c:	85 ff                	test   %edi,%edi
  80172e:	0f 44 c3             	cmove  %ebx,%eax
}
  801731:	5b                   	pop    %ebx
  801732:	5e                   	pop    %esi
  801733:	5f                   	pop    %edi
  801734:	5d                   	pop    %ebp
  801735:	c3                   	ret    

00801736 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	57                   	push   %edi
  80173a:	56                   	push   %esi
  80173b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80173c:	b8 00 00 00 00       	mov    $0x0,%eax
  801741:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801744:	8b 55 08             	mov    0x8(%ebp),%edx
  801747:	89 c3                	mov    %eax,%ebx
  801749:	89 c7                	mov    %eax,%edi
  80174b:	89 c6                	mov    %eax,%esi
  80174d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5f                   	pop    %edi
  801752:	5d                   	pop    %ebp
  801753:	c3                   	ret    

00801754 <sys_cgetc>:

int
sys_cgetc(void)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	57                   	push   %edi
  801758:	56                   	push   %esi
  801759:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80175a:	ba 00 00 00 00       	mov    $0x0,%edx
  80175f:	b8 01 00 00 00       	mov    $0x1,%eax
  801764:	89 d1                	mov    %edx,%ecx
  801766:	89 d3                	mov    %edx,%ebx
  801768:	89 d7                	mov    %edx,%edi
  80176a:	89 d6                	mov    %edx,%esi
  80176c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80176e:	5b                   	pop    %ebx
  80176f:	5e                   	pop    %esi
  801770:	5f                   	pop    %edi
  801771:	5d                   	pop    %ebp
  801772:	c3                   	ret    

00801773 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	57                   	push   %edi
  801777:	56                   	push   %esi
  801778:	53                   	push   %ebx
  801779:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80177c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801781:	b8 03 00 00 00       	mov    $0x3,%eax
  801786:	8b 55 08             	mov    0x8(%ebp),%edx
  801789:	89 cb                	mov    %ecx,%ebx
  80178b:	89 cf                	mov    %ecx,%edi
  80178d:	89 ce                	mov    %ecx,%esi
  80178f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801791:	85 c0                	test   %eax,%eax
  801793:	7e 28                	jle    8017bd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801795:	89 44 24 10          	mov    %eax,0x10(%esp)
  801799:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8017a0:	00 
  8017a1:	c7 44 24 08 a4 45 80 	movl   $0x8045a4,0x8(%esp)
  8017a8:	00 
  8017a9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8017b0:	00 
  8017b1:	c7 04 24 c1 45 80 00 	movl   $0x8045c1,(%esp)
  8017b8:	e8 be f2 ff ff       	call   800a7b <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8017bd:	83 c4 2c             	add    $0x2c,%esp
  8017c0:	5b                   	pop    %ebx
  8017c1:	5e                   	pop    %esi
  8017c2:	5f                   	pop    %edi
  8017c3:	5d                   	pop    %ebp
  8017c4:	c3                   	ret    

008017c5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	57                   	push   %edi
  8017c9:	56                   	push   %esi
  8017ca:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d0:	b8 02 00 00 00       	mov    $0x2,%eax
  8017d5:	89 d1                	mov    %edx,%ecx
  8017d7:	89 d3                	mov    %edx,%ebx
  8017d9:	89 d7                	mov    %edx,%edi
  8017db:	89 d6                	mov    %edx,%esi
  8017dd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8017df:	5b                   	pop    %ebx
  8017e0:	5e                   	pop    %esi
  8017e1:	5f                   	pop    %edi
  8017e2:	5d                   	pop    %ebp
  8017e3:	c3                   	ret    

008017e4 <sys_yield>:

void
sys_yield(void)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	57                   	push   %edi
  8017e8:	56                   	push   %esi
  8017e9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ef:	b8 0b 00 00 00       	mov    $0xb,%eax
  8017f4:	89 d1                	mov    %edx,%ecx
  8017f6:	89 d3                	mov    %edx,%ebx
  8017f8:	89 d7                	mov    %edx,%edi
  8017fa:	89 d6                	mov    %edx,%esi
  8017fc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8017fe:	5b                   	pop    %ebx
  8017ff:	5e                   	pop    %esi
  801800:	5f                   	pop    %edi
  801801:	5d                   	pop    %ebp
  801802:	c3                   	ret    

00801803 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	57                   	push   %edi
  801807:	56                   	push   %esi
  801808:	53                   	push   %ebx
  801809:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80180c:	be 00 00 00 00       	mov    $0x0,%esi
  801811:	b8 04 00 00 00       	mov    $0x4,%eax
  801816:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801819:	8b 55 08             	mov    0x8(%ebp),%edx
  80181c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80181f:	89 f7                	mov    %esi,%edi
  801821:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801823:	85 c0                	test   %eax,%eax
  801825:	7e 28                	jle    80184f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801827:	89 44 24 10          	mov    %eax,0x10(%esp)
  80182b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801832:	00 
  801833:	c7 44 24 08 a4 45 80 	movl   $0x8045a4,0x8(%esp)
  80183a:	00 
  80183b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801842:	00 
  801843:	c7 04 24 c1 45 80 00 	movl   $0x8045c1,(%esp)
  80184a:	e8 2c f2 ff ff       	call   800a7b <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80184f:	83 c4 2c             	add    $0x2c,%esp
  801852:	5b                   	pop    %ebx
  801853:	5e                   	pop    %esi
  801854:	5f                   	pop    %edi
  801855:	5d                   	pop    %ebp
  801856:	c3                   	ret    

00801857 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	57                   	push   %edi
  80185b:	56                   	push   %esi
  80185c:	53                   	push   %ebx
  80185d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801860:	b8 05 00 00 00       	mov    $0x5,%eax
  801865:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801868:	8b 55 08             	mov    0x8(%ebp),%edx
  80186b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80186e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801871:	8b 75 18             	mov    0x18(%ebp),%esi
  801874:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801876:	85 c0                	test   %eax,%eax
  801878:	7e 28                	jle    8018a2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80187a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80187e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801885:	00 
  801886:	c7 44 24 08 a4 45 80 	movl   $0x8045a4,0x8(%esp)
  80188d:	00 
  80188e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801895:	00 
  801896:	c7 04 24 c1 45 80 00 	movl   $0x8045c1,(%esp)
  80189d:	e8 d9 f1 ff ff       	call   800a7b <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8018a2:	83 c4 2c             	add    $0x2c,%esp
  8018a5:	5b                   	pop    %ebx
  8018a6:	5e                   	pop    %esi
  8018a7:	5f                   	pop    %edi
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    

008018aa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	57                   	push   %edi
  8018ae:	56                   	push   %esi
  8018af:	53                   	push   %ebx
  8018b0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018b8:	b8 06 00 00 00       	mov    $0x6,%eax
  8018bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c3:	89 df                	mov    %ebx,%edi
  8018c5:	89 de                	mov    %ebx,%esi
  8018c7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8018c9:	85 c0                	test   %eax,%eax
  8018cb:	7e 28                	jle    8018f5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018d1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8018d8:	00 
  8018d9:	c7 44 24 08 a4 45 80 	movl   $0x8045a4,0x8(%esp)
  8018e0:	00 
  8018e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8018e8:	00 
  8018e9:	c7 04 24 c1 45 80 00 	movl   $0x8045c1,(%esp)
  8018f0:	e8 86 f1 ff ff       	call   800a7b <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8018f5:	83 c4 2c             	add    $0x2c,%esp
  8018f8:	5b                   	pop    %ebx
  8018f9:	5e                   	pop    %esi
  8018fa:	5f                   	pop    %edi
  8018fb:	5d                   	pop    %ebp
  8018fc:	c3                   	ret    

008018fd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	57                   	push   %edi
  801901:	56                   	push   %esi
  801902:	53                   	push   %ebx
  801903:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801906:	bb 00 00 00 00       	mov    $0x0,%ebx
  80190b:	b8 08 00 00 00       	mov    $0x8,%eax
  801910:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801913:	8b 55 08             	mov    0x8(%ebp),%edx
  801916:	89 df                	mov    %ebx,%edi
  801918:	89 de                	mov    %ebx,%esi
  80191a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80191c:	85 c0                	test   %eax,%eax
  80191e:	7e 28                	jle    801948 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801920:	89 44 24 10          	mov    %eax,0x10(%esp)
  801924:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80192b:	00 
  80192c:	c7 44 24 08 a4 45 80 	movl   $0x8045a4,0x8(%esp)
  801933:	00 
  801934:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80193b:	00 
  80193c:	c7 04 24 c1 45 80 00 	movl   $0x8045c1,(%esp)
  801943:	e8 33 f1 ff ff       	call   800a7b <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801948:	83 c4 2c             	add    $0x2c,%esp
  80194b:	5b                   	pop    %ebx
  80194c:	5e                   	pop    %esi
  80194d:	5f                   	pop    %edi
  80194e:	5d                   	pop    %ebp
  80194f:	c3                   	ret    

00801950 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	57                   	push   %edi
  801954:	56                   	push   %esi
  801955:	53                   	push   %ebx
  801956:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801959:	bb 00 00 00 00       	mov    $0x0,%ebx
  80195e:	b8 09 00 00 00       	mov    $0x9,%eax
  801963:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801966:	8b 55 08             	mov    0x8(%ebp),%edx
  801969:	89 df                	mov    %ebx,%edi
  80196b:	89 de                	mov    %ebx,%esi
  80196d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80196f:	85 c0                	test   %eax,%eax
  801971:	7e 28                	jle    80199b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801973:	89 44 24 10          	mov    %eax,0x10(%esp)
  801977:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80197e:	00 
  80197f:	c7 44 24 08 a4 45 80 	movl   $0x8045a4,0x8(%esp)
  801986:	00 
  801987:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80198e:	00 
  80198f:	c7 04 24 c1 45 80 00 	movl   $0x8045c1,(%esp)
  801996:	e8 e0 f0 ff ff       	call   800a7b <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80199b:	83 c4 2c             	add    $0x2c,%esp
  80199e:	5b                   	pop    %ebx
  80199f:	5e                   	pop    %esi
  8019a0:	5f                   	pop    %edi
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    

008019a3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	57                   	push   %edi
  8019a7:	56                   	push   %esi
  8019a8:	53                   	push   %ebx
  8019a9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8019bc:	89 df                	mov    %ebx,%edi
  8019be:	89 de                	mov    %ebx,%esi
  8019c0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	7e 28                	jle    8019ee <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019c6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019ca:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8019d1:	00 
  8019d2:	c7 44 24 08 a4 45 80 	movl   $0x8045a4,0x8(%esp)
  8019d9:	00 
  8019da:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8019e1:	00 
  8019e2:	c7 04 24 c1 45 80 00 	movl   $0x8045c1,(%esp)
  8019e9:	e8 8d f0 ff ff       	call   800a7b <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8019ee:	83 c4 2c             	add    $0x2c,%esp
  8019f1:	5b                   	pop    %ebx
  8019f2:	5e                   	pop    %esi
  8019f3:	5f                   	pop    %edi
  8019f4:	5d                   	pop    %ebp
  8019f5:	c3                   	ret    

008019f6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	57                   	push   %edi
  8019fa:	56                   	push   %esi
  8019fb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019fc:	be 00 00 00 00       	mov    $0x0,%esi
  801a01:	b8 0c 00 00 00       	mov    $0xc,%eax
  801a06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a09:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801a12:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801a14:	5b                   	pop    %ebx
  801a15:	5e                   	pop    %esi
  801a16:	5f                   	pop    %edi
  801a17:	5d                   	pop    %ebp
  801a18:	c3                   	ret    

00801a19 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	57                   	push   %edi
  801a1d:	56                   	push   %esi
  801a1e:	53                   	push   %ebx
  801a1f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a22:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a27:	b8 0d 00 00 00       	mov    $0xd,%eax
  801a2c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a2f:	89 cb                	mov    %ecx,%ebx
  801a31:	89 cf                	mov    %ecx,%edi
  801a33:	89 ce                	mov    %ecx,%esi
  801a35:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801a37:	85 c0                	test   %eax,%eax
  801a39:	7e 28                	jle    801a63 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a3b:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a3f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801a46:	00 
  801a47:	c7 44 24 08 a4 45 80 	movl   $0x8045a4,0x8(%esp)
  801a4e:	00 
  801a4f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801a56:	00 
  801a57:	c7 04 24 c1 45 80 00 	movl   $0x8045c1,(%esp)
  801a5e:	e8 18 f0 ff ff       	call   800a7b <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801a63:	83 c4 2c             	add    $0x2c,%esp
  801a66:	5b                   	pop    %ebx
  801a67:	5e                   	pop    %esi
  801a68:	5f                   	pop    %edi
  801a69:	5d                   	pop    %ebp
  801a6a:	c3                   	ret    

00801a6b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	57                   	push   %edi
  801a6f:	56                   	push   %esi
  801a70:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a71:	ba 00 00 00 00       	mov    $0x0,%edx
  801a76:	b8 0e 00 00 00       	mov    $0xe,%eax
  801a7b:	89 d1                	mov    %edx,%ecx
  801a7d:	89 d3                	mov    %edx,%ebx
  801a7f:	89 d7                	mov    %edx,%edi
  801a81:	89 d6                	mov    %edx,%esi
  801a83:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801a85:	5b                   	pop    %ebx
  801a86:	5e                   	pop    %esi
  801a87:	5f                   	pop    %edi
  801a88:	5d                   	pop    %ebp
  801a89:	c3                   	ret    

00801a8a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	57                   	push   %edi
  801a8e:	56                   	push   %esi
  801a8f:	53                   	push   %ebx
  801a90:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a93:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a98:	b8 0f 00 00 00       	mov    $0xf,%eax
  801a9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801aa0:	8b 55 08             	mov    0x8(%ebp),%edx
  801aa3:	89 df                	mov    %ebx,%edi
  801aa5:	89 de                	mov    %ebx,%esi
  801aa7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	7e 28                	jle    801ad5 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801aad:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ab1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801ab8:	00 
  801ab9:	c7 44 24 08 a4 45 80 	movl   $0x8045a4,0x8(%esp)
  801ac0:	00 
  801ac1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801ac8:	00 
  801ac9:	c7 04 24 c1 45 80 00 	movl   $0x8045c1,(%esp)
  801ad0:	e8 a6 ef ff ff       	call   800a7b <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  801ad5:	83 c4 2c             	add    $0x2c,%esp
  801ad8:	5b                   	pop    %ebx
  801ad9:	5e                   	pop    %esi
  801ada:	5f                   	pop    %edi
  801adb:	5d                   	pop    %ebp
  801adc:	c3                   	ret    

00801add <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	57                   	push   %edi
  801ae1:	56                   	push   %esi
  801ae2:	53                   	push   %ebx
  801ae3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ae6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aeb:	b8 10 00 00 00       	mov    $0x10,%eax
  801af0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801af3:	8b 55 08             	mov    0x8(%ebp),%edx
  801af6:	89 df                	mov    %ebx,%edi
  801af8:	89 de                	mov    %ebx,%esi
  801afa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801afc:	85 c0                	test   %eax,%eax
  801afe:	7e 28                	jle    801b28 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b00:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b04:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  801b0b:	00 
  801b0c:	c7 44 24 08 a4 45 80 	movl   $0x8045a4,0x8(%esp)
  801b13:	00 
  801b14:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801b1b:	00 
  801b1c:	c7 04 24 c1 45 80 00 	movl   $0x8045c1,(%esp)
  801b23:	e8 53 ef ff ff       	call   800a7b <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  801b28:	83 c4 2c             	add    $0x2c,%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5f                   	pop    %edi
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    

00801b30 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	57                   	push   %edi
  801b34:	56                   	push   %esi
  801b35:	53                   	push   %ebx
  801b36:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b39:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b3e:	b8 11 00 00 00       	mov    $0x11,%eax
  801b43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b46:	8b 55 08             	mov    0x8(%ebp),%edx
  801b49:	89 df                	mov    %ebx,%edi
  801b4b:	89 de                	mov    %ebx,%esi
  801b4d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	7e 28                	jle    801b7b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b53:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b57:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  801b5e:	00 
  801b5f:	c7 44 24 08 a4 45 80 	movl   $0x8045a4,0x8(%esp)
  801b66:	00 
  801b67:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801b6e:	00 
  801b6f:	c7 04 24 c1 45 80 00 	movl   $0x8045c1,(%esp)
  801b76:	e8 00 ef ff ff       	call   800a7b <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  801b7b:	83 c4 2c             	add    $0x2c,%esp
  801b7e:	5b                   	pop    %ebx
  801b7f:	5e                   	pop    %esi
  801b80:	5f                   	pop    %edi
  801b81:	5d                   	pop    %ebp
  801b82:	c3                   	ret    

00801b83 <sys_sleep>:

int
sys_sleep(int channel)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	57                   	push   %edi
  801b87:	56                   	push   %esi
  801b88:	53                   	push   %ebx
  801b89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b91:	b8 12 00 00 00       	mov    $0x12,%eax
  801b96:	8b 55 08             	mov    0x8(%ebp),%edx
  801b99:	89 cb                	mov    %ecx,%ebx
  801b9b:	89 cf                	mov    %ecx,%edi
  801b9d:	89 ce                	mov    %ecx,%esi
  801b9f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801ba1:	85 c0                	test   %eax,%eax
  801ba3:	7e 28                	jle    801bcd <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ba5:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ba9:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801bb0:	00 
  801bb1:	c7 44 24 08 a4 45 80 	movl   $0x8045a4,0x8(%esp)
  801bb8:	00 
  801bb9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801bc0:	00 
  801bc1:	c7 04 24 c1 45 80 00 	movl   $0x8045c1,(%esp)
  801bc8:	e8 ae ee ff ff       	call   800a7b <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  801bcd:	83 c4 2c             	add    $0x2c,%esp
  801bd0:	5b                   	pop    %ebx
  801bd1:	5e                   	pop    %esi
  801bd2:	5f                   	pop    %edi
  801bd3:	5d                   	pop    %ebp
  801bd4:	c3                   	ret    

00801bd5 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	57                   	push   %edi
  801bd9:	56                   	push   %esi
  801bda:	53                   	push   %ebx
  801bdb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bde:	bb 00 00 00 00       	mov    $0x0,%ebx
  801be3:	b8 13 00 00 00       	mov    $0x13,%eax
  801be8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801beb:	8b 55 08             	mov    0x8(%ebp),%edx
  801bee:	89 df                	mov    %ebx,%edi
  801bf0:	89 de                	mov    %ebx,%esi
  801bf2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	7e 28                	jle    801c20 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801bf8:	89 44 24 10          	mov    %eax,0x10(%esp)
  801bfc:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801c03:	00 
  801c04:	c7 44 24 08 a4 45 80 	movl   $0x8045a4,0x8(%esp)
  801c0b:	00 
  801c0c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801c13:	00 
  801c14:	c7 04 24 c1 45 80 00 	movl   $0x8045c1,(%esp)
  801c1b:	e8 5b ee ff ff       	call   800a7b <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801c20:	83 c4 2c             	add    $0x2c,%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5f                   	pop    %edi
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    

00801c28 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	53                   	push   %ebx
  801c2c:	83 ec 24             	sub    $0x24,%esp
  801c2f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801c32:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(((err & FEC_WR) == 0) || ((uvpd[PDX(addr)] & PTE_P) == 0) || (((~uvpt[PGNUM(addr)])&(PTE_COW|PTE_P)) != 0)) {
  801c34:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801c38:	74 27                	je     801c61 <pgfault+0x39>
  801c3a:	89 c2                	mov    %eax,%edx
  801c3c:	c1 ea 16             	shr    $0x16,%edx
  801c3f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801c46:	f6 c2 01             	test   $0x1,%dl
  801c49:	74 16                	je     801c61 <pgfault+0x39>
  801c4b:	89 c2                	mov    %eax,%edx
  801c4d:	c1 ea 0c             	shr    $0xc,%edx
  801c50:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c57:	f7 d2                	not    %edx
  801c59:	f7 c2 01 08 00 00    	test   $0x801,%edx
  801c5f:	74 1c                	je     801c7d <pgfault+0x55>
		panic("pgfault");
  801c61:	c7 44 24 08 cf 45 80 	movl   $0x8045cf,0x8(%esp)
  801c68:	00 
  801c69:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  801c70:	00 
  801c71:	c7 04 24 d7 45 80 00 	movl   $0x8045d7,(%esp)
  801c78:	e8 fe ed ff ff       	call   800a7b <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	addr = (void*)ROUNDDOWN(addr,PGSIZE);
  801c7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c82:	89 c3                	mov    %eax,%ebx
	
	if(sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U) < 0) {
  801c84:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c8b:	00 
  801c8c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801c93:	00 
  801c94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c9b:	e8 63 fb ff ff       	call   801803 <sys_page_alloc>
  801ca0:	85 c0                	test   %eax,%eax
  801ca2:	79 1c                	jns    801cc0 <pgfault+0x98>
		panic("pgfault(): sys_page_alloc");
  801ca4:	c7 44 24 08 e2 45 80 	movl   $0x8045e2,0x8(%esp)
  801cab:	00 
  801cac:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801cb3:	00 
  801cb4:	c7 04 24 d7 45 80 00 	movl   $0x8045d7,(%esp)
  801cbb:	e8 bb ed ff ff       	call   800a7b <_panic>
	}
	memcpy((void*)PFTEMP, addr, PGSIZE);
  801cc0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801cc7:	00 
  801cc8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ccc:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801cd3:	e8 14 f9 ff ff       	call   8015ec <memcpy>

	if(sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0) {
  801cd8:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801cdf:	00 
  801ce0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801ce4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ceb:	00 
  801cec:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801cf3:	00 
  801cf4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cfb:	e8 57 fb ff ff       	call   801857 <sys_page_map>
  801d00:	85 c0                	test   %eax,%eax
  801d02:	79 1c                	jns    801d20 <pgfault+0xf8>
		panic("pgfault(): sys_page_map");
  801d04:	c7 44 24 08 fc 45 80 	movl   $0x8045fc,0x8(%esp)
  801d0b:	00 
  801d0c:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801d13:	00 
  801d14:	c7 04 24 d7 45 80 00 	movl   $0x8045d7,(%esp)
  801d1b:	e8 5b ed ff ff       	call   800a7b <_panic>
	}

	if(sys_page_unmap(0, (void*)PFTEMP) < 0) {
  801d20:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801d27:	00 
  801d28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d2f:	e8 76 fb ff ff       	call   8018aa <sys_page_unmap>
  801d34:	85 c0                	test   %eax,%eax
  801d36:	79 1c                	jns    801d54 <pgfault+0x12c>
		panic("pgfault(): sys_page_unmap");
  801d38:	c7 44 24 08 14 46 80 	movl   $0x804614,0x8(%esp)
  801d3f:	00 
  801d40:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801d47:	00 
  801d48:	c7 04 24 d7 45 80 00 	movl   $0x8045d7,(%esp)
  801d4f:	e8 27 ed ff ff       	call   800a7b <_panic>
	}
}
  801d54:	83 c4 24             	add    $0x24,%esp
  801d57:	5b                   	pop    %ebx
  801d58:	5d                   	pop    %ebp
  801d59:	c3                   	ret    

00801d5a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	57                   	push   %edi
  801d5e:	56                   	push   %esi
  801d5f:	53                   	push   %ebx
  801d60:	83 ec 2c             	sub    $0x2c,%esp
	set_pgfault_handler(pgfault);
  801d63:	c7 04 24 28 1c 80 00 	movl   $0x801c28,(%esp)
  801d6a:	e8 0d 1d 00 00       	call   803a7c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801d6f:	b8 07 00 00 00       	mov    $0x7,%eax
  801d74:	cd 30                	int    $0x30
  801d76:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t env_id = sys_exofork();
	if(env_id < 0){
  801d79:	85 c0                	test   %eax,%eax
  801d7b:	79 1c                	jns    801d99 <fork+0x3f>
		panic("fork(): sys_exofork");
  801d7d:	c7 44 24 08 2e 46 80 	movl   $0x80462e,0x8(%esp)
  801d84:	00 
  801d85:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  801d8c:	00 
  801d8d:	c7 04 24 d7 45 80 00 	movl   $0x8045d7,(%esp)
  801d94:	e8 e2 ec ff ff       	call   800a7b <_panic>
  801d99:	89 c7                	mov    %eax,%edi
	}
	else if(env_id == 0){
  801d9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d9f:	74 0a                	je     801dab <fork+0x51>
  801da1:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801da6:	e9 9d 01 00 00       	jmp    801f48 <fork+0x1ee>
		thisenv = envs + ENVX(sys_getenvid());
  801dab:	e8 15 fa ff ff       	call   8017c5 <sys_getenvid>
  801db0:	25 ff 03 00 00       	and    $0x3ff,%eax
  801db5:	89 c2                	mov    %eax,%edx
  801db7:	c1 e2 07             	shl    $0x7,%edx
  801dba:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  801dc1:	a3 28 64 80 00       	mov    %eax,0x806428
		return env_id;
  801dc6:	e9 2a 02 00 00       	jmp    801ff5 <fork+0x29b>
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
		if(addr == UXSTACKTOP - PGSIZE){
  801dcb:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801dd1:	0f 84 6b 01 00 00    	je     801f42 <fork+0x1e8>
			continue;
		}
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
  801dd7:	89 d8                	mov    %ebx,%eax
  801dd9:	c1 e8 16             	shr    $0x16,%eax
  801ddc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801de3:	a8 01                	test   $0x1,%al
  801de5:	0f 84 57 01 00 00    	je     801f42 <fork+0x1e8>
  801deb:	89 d8                	mov    %ebx,%eax
  801ded:	c1 e8 0c             	shr    $0xc,%eax
  801df0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801df7:	f7 d0                	not    %eax
  801df9:	a8 05                	test   $0x5,%al
  801dfb:	0f 85 41 01 00 00    	jne    801f42 <fork+0x1e8>
			duppage(env_id,addr/PGSIZE);
  801e01:	89 d8                	mov    %ebx,%eax
  801e03:	c1 e8 0c             	shr    $0xc,%eax
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void* addr = (void*)(pn*PGSIZE);
  801e06:	89 c6                	mov    %eax,%esi
  801e08:	c1 e6 0c             	shl    $0xc,%esi

	if (uvpt[pn] & PTE_SHARE) {
  801e0b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e12:	f6 c6 04             	test   $0x4,%dh
  801e15:	74 4c                	je     801e63 <fork+0x109>
		if (sys_page_map(0, addr, envid, addr, uvpt[pn]&PTE_SYSCALL) < 0)
  801e17:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801e1e:	25 07 0e 00 00       	and    $0xe07,%eax
  801e23:	89 44 24 10          	mov    %eax,0x10(%esp)
  801e27:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e2b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801e2f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e3a:	e8 18 fa ff ff       	call   801857 <sys_page_map>
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	0f 89 fb 00 00 00    	jns    801f42 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801e47:	c7 44 24 08 42 46 80 	movl   $0x804642,0x8(%esp)
  801e4e:	00 
  801e4f:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801e56:	00 
  801e57:	c7 04 24 d7 45 80 00 	movl   $0x8045d7,(%esp)
  801e5e:	e8 18 ec ff ff       	call   800a7b <_panic>
	} else if((uvpt[pn] & PTE_COW) || (uvpt[pn] & PTE_W)) {
  801e63:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e6a:	f6 c6 08             	test   $0x8,%dh
  801e6d:	75 0f                	jne    801e7e <fork+0x124>
  801e6f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801e76:	a8 02                	test   $0x2,%al
  801e78:	0f 84 84 00 00 00    	je     801f02 <fork+0x1a8>
		if(sys_page_map(0, addr, envid, addr, PTE_COW | PTE_U | PTE_P) < 0){
  801e7e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801e85:	00 
  801e86:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e8a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801e8e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e99:	e8 b9 f9 ff ff       	call   801857 <sys_page_map>
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	79 1c                	jns    801ebe <fork+0x164>
			panic("duppage: sys_page_map");
  801ea2:	c7 44 24 08 42 46 80 	movl   $0x804642,0x8(%esp)
  801ea9:	00 
  801eaa:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  801eb1:	00 
  801eb2:	c7 04 24 d7 45 80 00 	movl   $0x8045d7,(%esp)
  801eb9:	e8 bd eb ff ff       	call   800a7b <_panic>
		}
		if(sys_page_map(0, addr, 0, addr, PTE_COW | PTE_U | PTE_P) < 0){
  801ebe:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801ec5:	00 
  801ec6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801eca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ed1:	00 
  801ed2:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ed6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801edd:	e8 75 f9 ff ff       	call   801857 <sys_page_map>
  801ee2:	85 c0                	test   %eax,%eax
  801ee4:	79 5c                	jns    801f42 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801ee6:	c7 44 24 08 42 46 80 	movl   $0x804642,0x8(%esp)
  801eed:	00 
  801eee:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  801ef5:	00 
  801ef6:	c7 04 24 d7 45 80 00 	movl   $0x8045d7,(%esp)
  801efd:	e8 79 eb ff ff       	call   800a7b <_panic>
		}
	} else {
		if(sys_page_map(0, addr, envid, addr, PTE_U | PTE_P) < 0){
  801f02:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801f09:	00 
  801f0a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801f0e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f12:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f1d:	e8 35 f9 ff ff       	call   801857 <sys_page_map>
  801f22:	85 c0                	test   %eax,%eax
  801f24:	79 1c                	jns    801f42 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801f26:	c7 44 24 08 42 46 80 	movl   $0x804642,0x8(%esp)
  801f2d:	00 
  801f2e:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  801f35:	00 
  801f36:	c7 04 24 d7 45 80 00 	movl   $0x8045d7,(%esp)
  801f3d:	e8 39 eb ff ff       	call   800a7b <_panic>
		thisenv = envs + ENVX(sys_getenvid());
		return env_id;
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
  801f42:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f48:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801f4e:	0f 85 77 fe ff ff    	jne    801dcb <fork+0x71>
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
			duppage(env_id,addr/PGSIZE);
		}
	}

	if(sys_page_alloc(env_id, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) {
  801f54:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801f5b:	00 
  801f5c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801f63:	ee 
  801f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f67:	89 04 24             	mov    %eax,(%esp)
  801f6a:	e8 94 f8 ff ff       	call   801803 <sys_page_alloc>
  801f6f:	85 c0                	test   %eax,%eax
  801f71:	79 1c                	jns    801f8f <fork+0x235>
		panic("fork(): sys_page_alloc");
  801f73:	c7 44 24 08 58 46 80 	movl   $0x804658,0x8(%esp)
  801f7a:	00 
  801f7b:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801f82:	00 
  801f83:	c7 04 24 d7 45 80 00 	movl   $0x8045d7,(%esp)
  801f8a:	e8 ec ea ff ff       	call   800a7b <_panic>
	}

	extern void _pgfault_upcall(void);
	if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0) {
  801f8f:	c7 44 24 04 05 3b 80 	movl   $0x803b05,0x4(%esp)
  801f96:	00 
  801f97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f9a:	89 04 24             	mov    %eax,(%esp)
  801f9d:	e8 01 fa ff ff       	call   8019a3 <sys_env_set_pgfault_upcall>
  801fa2:	85 c0                	test   %eax,%eax
  801fa4:	79 1c                	jns    801fc2 <fork+0x268>
		panic("fork(): ys_env_set_pgfault_upcall");
  801fa6:	c7 44 24 08 a0 46 80 	movl   $0x8046a0,0x8(%esp)
  801fad:	00 
  801fae:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  801fb5:	00 
  801fb6:	c7 04 24 d7 45 80 00 	movl   $0x8045d7,(%esp)
  801fbd:	e8 b9 ea ff ff       	call   800a7b <_panic>
	}

	if(sys_env_set_status(env_id, ENV_RUNNABLE) < 0) {
  801fc2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801fc9:	00 
  801fca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fcd:	89 04 24             	mov    %eax,(%esp)
  801fd0:	e8 28 f9 ff ff       	call   8018fd <sys_env_set_status>
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	79 1c                	jns    801ff5 <fork+0x29b>
		panic("fork(): sys_env_set_status");
  801fd9:	c7 44 24 08 6f 46 80 	movl   $0x80466f,0x8(%esp)
  801fe0:	00 
  801fe1:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  801fe8:	00 
  801fe9:	c7 04 24 d7 45 80 00 	movl   $0x8045d7,(%esp)
  801ff0:	e8 86 ea ff ff       	call   800a7b <_panic>
	}

	return env_id;
}
  801ff5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ff8:	83 c4 2c             	add    $0x2c,%esp
  801ffb:	5b                   	pop    %ebx
  801ffc:	5e                   	pop    %esi
  801ffd:	5f                   	pop    %edi
  801ffe:	5d                   	pop    %ebp
  801fff:	c3                   	ret    

00802000 <sfork>:

// Challenge!
int
sfork(void)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  802006:	c7 44 24 08 8a 46 80 	movl   $0x80468a,0x8(%esp)
  80200d:	00 
  80200e:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  802015:	00 
  802016:	c7 04 24 d7 45 80 00 	movl   $0x8045d7,(%esp)
  80201d:	e8 59 ea ff ff       	call   800a7b <_panic>

00802022 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	53                   	push   %ebx
  802026:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802029:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202c:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  80202f:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  802031:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  802034:	bb 00 00 00 00       	mov    $0x0,%ebx
  802039:	83 39 01             	cmpl   $0x1,(%ecx)
  80203c:	7e 0f                	jle    80204d <argstart+0x2b>
  80203e:	85 d2                	test   %edx,%edx
  802040:	ba 00 00 00 00       	mov    $0x0,%edx
  802045:	bb 21 3f 80 00       	mov    $0x803f21,%ebx
  80204a:	0f 44 da             	cmove  %edx,%ebx
  80204d:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  802050:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  802057:	5b                   	pop    %ebx
  802058:	5d                   	pop    %ebp
  802059:	c3                   	ret    

0080205a <argnext>:

int
argnext(struct Argstate *args)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	53                   	push   %ebx
  80205e:	83 ec 14             	sub    $0x14,%esp
  802061:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  802064:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  80206b:	8b 43 08             	mov    0x8(%ebx),%eax
  80206e:	85 c0                	test   %eax,%eax
  802070:	74 71                	je     8020e3 <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  802072:	80 38 00             	cmpb   $0x0,(%eax)
  802075:	75 50                	jne    8020c7 <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  802077:	8b 0b                	mov    (%ebx),%ecx
  802079:	83 39 01             	cmpl   $0x1,(%ecx)
  80207c:	74 57                	je     8020d5 <argnext+0x7b>
		    || args->argv[1][0] != '-'
  80207e:	8b 53 04             	mov    0x4(%ebx),%edx
  802081:	8b 42 04             	mov    0x4(%edx),%eax
  802084:	80 38 2d             	cmpb   $0x2d,(%eax)
  802087:	75 4c                	jne    8020d5 <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  802089:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80208d:	74 46                	je     8020d5 <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80208f:	83 c0 01             	add    $0x1,%eax
  802092:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802095:	8b 01                	mov    (%ecx),%eax
  802097:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  80209e:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020a2:	8d 42 08             	lea    0x8(%edx),%eax
  8020a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a9:	83 c2 04             	add    $0x4,%edx
  8020ac:	89 14 24             	mov    %edx,(%esp)
  8020af:	e8 d0 f4 ff ff       	call   801584 <memmove>
		(*args->argc)--;
  8020b4:	8b 03                	mov    (%ebx),%eax
  8020b6:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8020b9:	8b 43 08             	mov    0x8(%ebx),%eax
  8020bc:	80 38 2d             	cmpb   $0x2d,(%eax)
  8020bf:	75 06                	jne    8020c7 <argnext+0x6d>
  8020c1:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8020c5:	74 0e                	je     8020d5 <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8020c7:	8b 53 08             	mov    0x8(%ebx),%edx
  8020ca:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  8020cd:	83 c2 01             	add    $0x1,%edx
  8020d0:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  8020d3:	eb 13                	jmp    8020e8 <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  8020d5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8020dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8020e1:	eb 05                	jmp    8020e8 <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  8020e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8020e8:	83 c4 14             	add    $0x14,%esp
  8020eb:	5b                   	pop    %ebx
  8020ec:	5d                   	pop    %ebp
  8020ed:	c3                   	ret    

008020ee <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	53                   	push   %ebx
  8020f2:	83 ec 14             	sub    $0x14,%esp
  8020f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8020f8:	8b 43 08             	mov    0x8(%ebx),%eax
  8020fb:	85 c0                	test   %eax,%eax
  8020fd:	74 5a                	je     802159 <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  8020ff:	80 38 00             	cmpb   $0x0,(%eax)
  802102:	74 0c                	je     802110 <argnextvalue+0x22>
		args->argvalue = args->curarg;
  802104:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  802107:	c7 43 08 21 3f 80 00 	movl   $0x803f21,0x8(%ebx)
  80210e:	eb 44                	jmp    802154 <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  802110:	8b 03                	mov    (%ebx),%eax
  802112:	83 38 01             	cmpl   $0x1,(%eax)
  802115:	7e 2f                	jle    802146 <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  802117:	8b 53 04             	mov    0x4(%ebx),%edx
  80211a:	8b 4a 04             	mov    0x4(%edx),%ecx
  80211d:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802120:	8b 00                	mov    (%eax),%eax
  802122:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  802129:	89 44 24 08          	mov    %eax,0x8(%esp)
  80212d:	8d 42 08             	lea    0x8(%edx),%eax
  802130:	89 44 24 04          	mov    %eax,0x4(%esp)
  802134:	83 c2 04             	add    $0x4,%edx
  802137:	89 14 24             	mov    %edx,(%esp)
  80213a:	e8 45 f4 ff ff       	call   801584 <memmove>
		(*args->argc)--;
  80213f:	8b 03                	mov    (%ebx),%eax
  802141:	83 28 01             	subl   $0x1,(%eax)
  802144:	eb 0e                	jmp    802154 <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  802146:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  80214d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  802154:	8b 43 0c             	mov    0xc(%ebx),%eax
  802157:	eb 05                	jmp    80215e <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  802159:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  80215e:	83 c4 14             	add    $0x14,%esp
  802161:	5b                   	pop    %ebx
  802162:	5d                   	pop    %ebp
  802163:	c3                   	ret    

00802164 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
  802167:	83 ec 18             	sub    $0x18,%esp
  80216a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80216d:	8b 51 0c             	mov    0xc(%ecx),%edx
  802170:	89 d0                	mov    %edx,%eax
  802172:	85 d2                	test   %edx,%edx
  802174:	75 08                	jne    80217e <argvalue+0x1a>
  802176:	89 0c 24             	mov    %ecx,(%esp)
  802179:	e8 70 ff ff ff       	call   8020ee <argnextvalue>
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	05 00 00 00 30       	add    $0x30000000,%eax
  80218b:	c1 e8 0c             	shr    $0xc,%eax
}
  80218e:	5d                   	pop    %ebp
  80218f:	c3                   	ret    

00802190 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80219b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8021a0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8021a5:	5d                   	pop    %ebp
  8021a6:	c3                   	ret    

008021a7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021ad:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8021b2:	89 c2                	mov    %eax,%edx
  8021b4:	c1 ea 16             	shr    $0x16,%edx
  8021b7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8021be:	f6 c2 01             	test   $0x1,%dl
  8021c1:	74 11                	je     8021d4 <fd_alloc+0x2d>
  8021c3:	89 c2                	mov    %eax,%edx
  8021c5:	c1 ea 0c             	shr    $0xc,%edx
  8021c8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8021cf:	f6 c2 01             	test   $0x1,%dl
  8021d2:	75 09                	jne    8021dd <fd_alloc+0x36>
			*fd_store = fd;
  8021d4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8021d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021db:	eb 17                	jmp    8021f4 <fd_alloc+0x4d>
  8021dd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021e2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8021e7:	75 c9                	jne    8021b2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8021e9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8021ef:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8021f4:	5d                   	pop    %ebp
  8021f5:	c3                   	ret    

008021f6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021fc:	83 f8 1f             	cmp    $0x1f,%eax
  8021ff:	77 36                	ja     802237 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802201:	c1 e0 0c             	shl    $0xc,%eax
  802204:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802209:	89 c2                	mov    %eax,%edx
  80220b:	c1 ea 16             	shr    $0x16,%edx
  80220e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802215:	f6 c2 01             	test   $0x1,%dl
  802218:	74 24                	je     80223e <fd_lookup+0x48>
  80221a:	89 c2                	mov    %eax,%edx
  80221c:	c1 ea 0c             	shr    $0xc,%edx
  80221f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802226:	f6 c2 01             	test   $0x1,%dl
  802229:	74 1a                	je     802245 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80222b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222e:	89 02                	mov    %eax,(%edx)
	return 0;
  802230:	b8 00 00 00 00       	mov    $0x0,%eax
  802235:	eb 13                	jmp    80224a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802237:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80223c:	eb 0c                	jmp    80224a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80223e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802243:	eb 05                	jmp    80224a <fd_lookup+0x54>
  802245:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80224a:	5d                   	pop    %ebp
  80224b:	c3                   	ret    

0080224c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	83 ec 18             	sub    $0x18,%esp
  802252:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  802255:	ba 00 00 00 00       	mov    $0x0,%edx
  80225a:	eb 13                	jmp    80226f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80225c:	39 08                	cmp    %ecx,(%eax)
  80225e:	75 0c                	jne    80226c <dev_lookup+0x20>
			*dev = devtab[i];
  802260:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802263:	89 01                	mov    %eax,(%ecx)
			return 0;
  802265:	b8 00 00 00 00       	mov    $0x0,%eax
  80226a:	eb 38                	jmp    8022a4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80226c:	83 c2 01             	add    $0x1,%edx
  80226f:	8b 04 95 40 47 80 00 	mov    0x804740(,%edx,4),%eax
  802276:	85 c0                	test   %eax,%eax
  802278:	75 e2                	jne    80225c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80227a:	a1 28 64 80 00       	mov    0x806428,%eax
  80227f:	8b 40 48             	mov    0x48(%eax),%eax
  802282:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802286:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228a:	c7 04 24 c4 46 80 00 	movl   $0x8046c4,(%esp)
  802291:	e8 de e8 ff ff       	call   800b74 <cprintf>
	*dev = 0;
  802296:	8b 45 0c             	mov    0xc(%ebp),%eax
  802299:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80229f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	56                   	push   %esi
  8022aa:	53                   	push   %ebx
  8022ab:	83 ec 20             	sub    $0x20,%esp
  8022ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8022b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8022b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022b7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8022bb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8022c1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8022c4:	89 04 24             	mov    %eax,(%esp)
  8022c7:	e8 2a ff ff ff       	call   8021f6 <fd_lookup>
  8022cc:	85 c0                	test   %eax,%eax
  8022ce:	78 05                	js     8022d5 <fd_close+0x2f>
	    || fd != fd2)
  8022d0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8022d3:	74 0c                	je     8022e1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8022d5:	84 db                	test   %bl,%bl
  8022d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8022dc:	0f 44 c2             	cmove  %edx,%eax
  8022df:	eb 3f                	jmp    802320 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8022e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e8:	8b 06                	mov    (%esi),%eax
  8022ea:	89 04 24             	mov    %eax,(%esp)
  8022ed:	e8 5a ff ff ff       	call   80224c <dev_lookup>
  8022f2:	89 c3                	mov    %eax,%ebx
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	78 16                	js     80230e <fd_close+0x68>
		if (dev->dev_close)
  8022f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8022fe:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  802303:	85 c0                	test   %eax,%eax
  802305:	74 07                	je     80230e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  802307:	89 34 24             	mov    %esi,(%esp)
  80230a:	ff d0                	call   *%eax
  80230c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80230e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802312:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802319:	e8 8c f5 ff ff       	call   8018aa <sys_page_unmap>
	return r;
  80231e:	89 d8                	mov    %ebx,%eax
}
  802320:	83 c4 20             	add    $0x20,%esp
  802323:	5b                   	pop    %ebx
  802324:	5e                   	pop    %esi
  802325:	5d                   	pop    %ebp
  802326:	c3                   	ret    

00802327 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80232d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802330:	89 44 24 04          	mov    %eax,0x4(%esp)
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	89 04 24             	mov    %eax,(%esp)
  80233a:	e8 b7 fe ff ff       	call   8021f6 <fd_lookup>
  80233f:	89 c2                	mov    %eax,%edx
  802341:	85 d2                	test   %edx,%edx
  802343:	78 13                	js     802358 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  802345:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80234c:	00 
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	89 04 24             	mov    %eax,(%esp)
  802353:	e8 4e ff ff ff       	call   8022a6 <fd_close>
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <close_all>:

void
close_all(void)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
  80235d:	53                   	push   %ebx
  80235e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802361:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802366:	89 1c 24             	mov    %ebx,(%esp)
  802369:	e8 b9 ff ff ff       	call   802327 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80236e:	83 c3 01             	add    $0x1,%ebx
  802371:	83 fb 20             	cmp    $0x20,%ebx
  802374:	75 f0                	jne    802366 <close_all+0xc>
		close(i);
}
  802376:	83 c4 14             	add    $0x14,%esp
  802379:	5b                   	pop    %ebx
  80237a:	5d                   	pop    %ebp
  80237b:	c3                   	ret    

0080237c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	57                   	push   %edi
  802380:	56                   	push   %esi
  802381:	53                   	push   %ebx
  802382:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802385:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802388:	89 44 24 04          	mov    %eax,0x4(%esp)
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	89 04 24             	mov    %eax,(%esp)
  802392:	e8 5f fe ff ff       	call   8021f6 <fd_lookup>
  802397:	89 c2                	mov    %eax,%edx
  802399:	85 d2                	test   %edx,%edx
  80239b:	0f 88 e1 00 00 00    	js     802482 <dup+0x106>
		return r;
	close(newfdnum);
  8023a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a4:	89 04 24             	mov    %eax,(%esp)
  8023a7:	e8 7b ff ff ff       	call   802327 <close>

	newfd = INDEX2FD(newfdnum);
  8023ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8023af:	c1 e3 0c             	shl    $0xc,%ebx
  8023b2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8023b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023bb:	89 04 24             	mov    %eax,(%esp)
  8023be:	e8 cd fd ff ff       	call   802190 <fd2data>
  8023c3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8023c5:	89 1c 24             	mov    %ebx,(%esp)
  8023c8:	e8 c3 fd ff ff       	call   802190 <fd2data>
  8023cd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8023cf:	89 f0                	mov    %esi,%eax
  8023d1:	c1 e8 16             	shr    $0x16,%eax
  8023d4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8023db:	a8 01                	test   $0x1,%al
  8023dd:	74 43                	je     802422 <dup+0xa6>
  8023df:	89 f0                	mov    %esi,%eax
  8023e1:	c1 e8 0c             	shr    $0xc,%eax
  8023e4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8023eb:	f6 c2 01             	test   $0x1,%dl
  8023ee:	74 32                	je     802422 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8023f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8023f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8023fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  802400:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802404:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80240b:	00 
  80240c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802410:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802417:	e8 3b f4 ff ff       	call   801857 <sys_page_map>
  80241c:	89 c6                	mov    %eax,%esi
  80241e:	85 c0                	test   %eax,%eax
  802420:	78 3e                	js     802460 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802425:	89 c2                	mov    %eax,%edx
  802427:	c1 ea 0c             	shr    $0xc,%edx
  80242a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802431:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  802437:	89 54 24 10          	mov    %edx,0x10(%esp)
  80243b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80243f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802446:	00 
  802447:	89 44 24 04          	mov    %eax,0x4(%esp)
  80244b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802452:	e8 00 f4 ff ff       	call   801857 <sys_page_map>
  802457:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  802459:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80245c:	85 f6                	test   %esi,%esi
  80245e:	79 22                	jns    802482 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802460:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802464:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80246b:	e8 3a f4 ff ff       	call   8018aa <sys_page_unmap>
	sys_page_unmap(0, nva);
  802470:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802474:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80247b:	e8 2a f4 ff ff       	call   8018aa <sys_page_unmap>
	return r;
  802480:	89 f0                	mov    %esi,%eax
}
  802482:	83 c4 3c             	add    $0x3c,%esp
  802485:	5b                   	pop    %ebx
  802486:	5e                   	pop    %esi
  802487:	5f                   	pop    %edi
  802488:	5d                   	pop    %ebp
  802489:	c3                   	ret    

0080248a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	53                   	push   %ebx
  80248e:	83 ec 24             	sub    $0x24,%esp
  802491:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802494:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802497:	89 44 24 04          	mov    %eax,0x4(%esp)
  80249b:	89 1c 24             	mov    %ebx,(%esp)
  80249e:	e8 53 fd ff ff       	call   8021f6 <fd_lookup>
  8024a3:	89 c2                	mov    %eax,%edx
  8024a5:	85 d2                	test   %edx,%edx
  8024a7:	78 6d                	js     802516 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	89 04 24             	mov    %eax,(%esp)
  8024b8:	e8 8f fd ff ff       	call   80224c <dev_lookup>
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	78 55                	js     802516 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8024c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c4:	8b 50 08             	mov    0x8(%eax),%edx
  8024c7:	83 e2 03             	and    $0x3,%edx
  8024ca:	83 fa 01             	cmp    $0x1,%edx
  8024cd:	75 23                	jne    8024f2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8024cf:	a1 28 64 80 00       	mov    0x806428,%eax
  8024d4:	8b 40 48             	mov    0x48(%eax),%eax
  8024d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024df:	c7 04 24 05 47 80 00 	movl   $0x804705,(%esp)
  8024e6:	e8 89 e6 ff ff       	call   800b74 <cprintf>
		return -E_INVAL;
  8024eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024f0:	eb 24                	jmp    802516 <read+0x8c>
	}
	if (!dev->dev_read)
  8024f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f5:	8b 52 08             	mov    0x8(%edx),%edx
  8024f8:	85 d2                	test   %edx,%edx
  8024fa:	74 15                	je     802511 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8024fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802503:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802506:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80250a:	89 04 24             	mov    %eax,(%esp)
  80250d:	ff d2                	call   *%edx
  80250f:	eb 05                	jmp    802516 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  802511:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  802516:	83 c4 24             	add    $0x24,%esp
  802519:	5b                   	pop    %ebx
  80251a:	5d                   	pop    %ebp
  80251b:	c3                   	ret    

0080251c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80251c:	55                   	push   %ebp
  80251d:	89 e5                	mov    %esp,%ebp
  80251f:	57                   	push   %edi
  802520:	56                   	push   %esi
  802521:	53                   	push   %ebx
  802522:	83 ec 1c             	sub    $0x1c,%esp
  802525:	8b 7d 08             	mov    0x8(%ebp),%edi
  802528:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80252b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802530:	eb 23                	jmp    802555 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802532:	89 f0                	mov    %esi,%eax
  802534:	29 d8                	sub    %ebx,%eax
  802536:	89 44 24 08          	mov    %eax,0x8(%esp)
  80253a:	89 d8                	mov    %ebx,%eax
  80253c:	03 45 0c             	add    0xc(%ebp),%eax
  80253f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802543:	89 3c 24             	mov    %edi,(%esp)
  802546:	e8 3f ff ff ff       	call   80248a <read>
		if (m < 0)
  80254b:	85 c0                	test   %eax,%eax
  80254d:	78 10                	js     80255f <readn+0x43>
			return m;
		if (m == 0)
  80254f:	85 c0                	test   %eax,%eax
  802551:	74 0a                	je     80255d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802553:	01 c3                	add    %eax,%ebx
  802555:	39 f3                	cmp    %esi,%ebx
  802557:	72 d9                	jb     802532 <readn+0x16>
  802559:	89 d8                	mov    %ebx,%eax
  80255b:	eb 02                	jmp    80255f <readn+0x43>
  80255d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80255f:	83 c4 1c             	add    $0x1c,%esp
  802562:	5b                   	pop    %ebx
  802563:	5e                   	pop    %esi
  802564:	5f                   	pop    %edi
  802565:	5d                   	pop    %ebp
  802566:	c3                   	ret    

00802567 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
  80256a:	53                   	push   %ebx
  80256b:	83 ec 24             	sub    $0x24,%esp
  80256e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802571:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802574:	89 44 24 04          	mov    %eax,0x4(%esp)
  802578:	89 1c 24             	mov    %ebx,(%esp)
  80257b:	e8 76 fc ff ff       	call   8021f6 <fd_lookup>
  802580:	89 c2                	mov    %eax,%edx
  802582:	85 d2                	test   %edx,%edx
  802584:	78 68                	js     8025ee <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802586:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802589:	89 44 24 04          	mov    %eax,0x4(%esp)
  80258d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802590:	8b 00                	mov    (%eax),%eax
  802592:	89 04 24             	mov    %eax,(%esp)
  802595:	e8 b2 fc ff ff       	call   80224c <dev_lookup>
  80259a:	85 c0                	test   %eax,%eax
  80259c:	78 50                	js     8025ee <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80259e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8025a5:	75 23                	jne    8025ca <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8025a7:	a1 28 64 80 00       	mov    0x806428,%eax
  8025ac:	8b 40 48             	mov    0x48(%eax),%eax
  8025af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b7:	c7 04 24 21 47 80 00 	movl   $0x804721,(%esp)
  8025be:	e8 b1 e5 ff ff       	call   800b74 <cprintf>
		return -E_INVAL;
  8025c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025c8:	eb 24                	jmp    8025ee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8025ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cd:	8b 52 0c             	mov    0xc(%edx),%edx
  8025d0:	85 d2                	test   %edx,%edx
  8025d2:	74 15                	je     8025e9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8025d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025e2:	89 04 24             	mov    %eax,(%esp)
  8025e5:	ff d2                	call   *%edx
  8025e7:	eb 05                	jmp    8025ee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8025e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8025ee:	83 c4 24             	add    $0x24,%esp
  8025f1:	5b                   	pop    %ebx
  8025f2:	5d                   	pop    %ebp
  8025f3:	c3                   	ret    

008025f4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
  8025f7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025fa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8025fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	89 04 24             	mov    %eax,(%esp)
  802607:	e8 ea fb ff ff       	call   8021f6 <fd_lookup>
  80260c:	85 c0                	test   %eax,%eax
  80260e:	78 0e                	js     80261e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  802610:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802613:	8b 55 0c             	mov    0xc(%ebp),%edx
  802616:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	53                   	push   %ebx
  802624:	83 ec 24             	sub    $0x24,%esp
  802627:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80262a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80262d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802631:	89 1c 24             	mov    %ebx,(%esp)
  802634:	e8 bd fb ff ff       	call   8021f6 <fd_lookup>
  802639:	89 c2                	mov    %eax,%edx
  80263b:	85 d2                	test   %edx,%edx
  80263d:	78 61                	js     8026a0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80263f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802642:	89 44 24 04          	mov    %eax,0x4(%esp)
  802646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802649:	8b 00                	mov    (%eax),%eax
  80264b:	89 04 24             	mov    %eax,(%esp)
  80264e:	e8 f9 fb ff ff       	call   80224c <dev_lookup>
  802653:	85 c0                	test   %eax,%eax
  802655:	78 49                	js     8026a0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80265e:	75 23                	jne    802683 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802660:	a1 28 64 80 00       	mov    0x806428,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802665:	8b 40 48             	mov    0x48(%eax),%eax
  802668:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80266c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802670:	c7 04 24 e4 46 80 00 	movl   $0x8046e4,(%esp)
  802677:	e8 f8 e4 ff ff       	call   800b74 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80267c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802681:	eb 1d                	jmp    8026a0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  802683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802686:	8b 52 18             	mov    0x18(%edx),%edx
  802689:	85 d2                	test   %edx,%edx
  80268b:	74 0e                	je     80269b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80268d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802690:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802694:	89 04 24             	mov    %eax,(%esp)
  802697:	ff d2                	call   *%edx
  802699:	eb 05                	jmp    8026a0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80269b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8026a0:	83 c4 24             	add    $0x24,%esp
  8026a3:	5b                   	pop    %ebx
  8026a4:	5d                   	pop    %ebp
  8026a5:	c3                   	ret    

008026a6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	53                   	push   %ebx
  8026aa:	83 ec 24             	sub    $0x24,%esp
  8026ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8026b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ba:	89 04 24             	mov    %eax,(%esp)
  8026bd:	e8 34 fb ff ff       	call   8021f6 <fd_lookup>
  8026c2:	89 c2                	mov    %eax,%edx
  8026c4:	85 d2                	test   %edx,%edx
  8026c6:	78 52                	js     80271a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d2:	8b 00                	mov    (%eax),%eax
  8026d4:	89 04 24             	mov    %eax,(%esp)
  8026d7:	e8 70 fb ff ff       	call   80224c <dev_lookup>
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	78 3a                	js     80271a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8026e7:	74 2c                	je     802715 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8026e9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8026ec:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8026f3:	00 00 00 
	stat->st_isdir = 0;
  8026f6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8026fd:	00 00 00 
	stat->st_dev = dev;
  802700:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802706:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80270a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80270d:	89 14 24             	mov    %edx,(%esp)
  802710:	ff 50 14             	call   *0x14(%eax)
  802713:	eb 05                	jmp    80271a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  802715:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80271a:	83 c4 24             	add    $0x24,%esp
  80271d:	5b                   	pop    %ebx
  80271e:	5d                   	pop    %ebp
  80271f:	c3                   	ret    

00802720 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
  802723:	56                   	push   %esi
  802724:	53                   	push   %ebx
  802725:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802728:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80272f:	00 
  802730:	8b 45 08             	mov    0x8(%ebp),%eax
  802733:	89 04 24             	mov    %eax,(%esp)
  802736:	e8 1b 02 00 00       	call   802956 <open>
  80273b:	89 c3                	mov    %eax,%ebx
  80273d:	85 db                	test   %ebx,%ebx
  80273f:	78 1b                	js     80275c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  802741:	8b 45 0c             	mov    0xc(%ebp),%eax
  802744:	89 44 24 04          	mov    %eax,0x4(%esp)
  802748:	89 1c 24             	mov    %ebx,(%esp)
  80274b:	e8 56 ff ff ff       	call   8026a6 <fstat>
  802750:	89 c6                	mov    %eax,%esi
	close(fd);
  802752:	89 1c 24             	mov    %ebx,(%esp)
  802755:	e8 cd fb ff ff       	call   802327 <close>
	return r;
  80275a:	89 f0                	mov    %esi,%eax
}
  80275c:	83 c4 10             	add    $0x10,%esp
  80275f:	5b                   	pop    %ebx
  802760:	5e                   	pop    %esi
  802761:	5d                   	pop    %ebp
  802762:	c3                   	ret    

00802763 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802763:	55                   	push   %ebp
  802764:	89 e5                	mov    %esp,%ebp
  802766:	56                   	push   %esi
  802767:	53                   	push   %ebx
  802768:	83 ec 10             	sub    $0x10,%esp
  80276b:	89 c6                	mov    %eax,%esi
  80276d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80276f:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  802776:	75 11                	jne    802789 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802778:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80277f:	e8 6b 14 00 00       	call   803bef <ipc_find_env>
  802784:	a3 20 64 80 00       	mov    %eax,0x806420
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802789:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802790:	00 
  802791:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802798:	00 
  802799:	89 74 24 04          	mov    %esi,0x4(%esp)
  80279d:	a1 20 64 80 00       	mov    0x806420,%eax
  8027a2:	89 04 24             	mov    %eax,(%esp)
  8027a5:	e8 da 13 00 00       	call   803b84 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8027aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8027b1:	00 
  8027b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027bd:	e8 6e 13 00 00       	call   803b30 <ipc_recv>
}
  8027c2:	83 c4 10             	add    $0x10,%esp
  8027c5:	5b                   	pop    %ebx
  8027c6:	5e                   	pop    %esi
  8027c7:	5d                   	pop    %ebp
  8027c8:	c3                   	ret    

008027c9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8027c9:	55                   	push   %ebp
  8027ca:	89 e5                	mov    %esp,%ebp
  8027cc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8027cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d5:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8027da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027dd:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8027e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8027e7:	b8 02 00 00 00       	mov    $0x2,%eax
  8027ec:	e8 72 ff ff ff       	call   802763 <fsipc>
}
  8027f1:	c9                   	leave  
  8027f2:	c3                   	ret    

008027f3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8027f3:	55                   	push   %ebp
  8027f4:	89 e5                	mov    %esp,%ebp
  8027f6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ff:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  802804:	ba 00 00 00 00       	mov    $0x0,%edx
  802809:	b8 06 00 00 00       	mov    $0x6,%eax
  80280e:	e8 50 ff ff ff       	call   802763 <fsipc>
}
  802813:	c9                   	leave  
  802814:	c3                   	ret    

00802815 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802815:	55                   	push   %ebp
  802816:	89 e5                	mov    %esp,%ebp
  802818:	53                   	push   %ebx
  802819:	83 ec 14             	sub    $0x14,%esp
  80281c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80281f:	8b 45 08             	mov    0x8(%ebp),%eax
  802822:	8b 40 0c             	mov    0xc(%eax),%eax
  802825:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80282a:	ba 00 00 00 00       	mov    $0x0,%edx
  80282f:	b8 05 00 00 00       	mov    $0x5,%eax
  802834:	e8 2a ff ff ff       	call   802763 <fsipc>
  802839:	89 c2                	mov    %eax,%edx
  80283b:	85 d2                	test   %edx,%edx
  80283d:	78 2b                	js     80286a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80283f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802846:	00 
  802847:	89 1c 24             	mov    %ebx,(%esp)
  80284a:	e8 98 eb ff ff       	call   8013e7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80284f:	a1 80 70 80 00       	mov    0x807080,%eax
  802854:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80285a:	a1 84 70 80 00       	mov    0x807084,%eax
  80285f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802865:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80286a:	83 c4 14             	add    $0x14,%esp
  80286d:	5b                   	pop    %ebx
  80286e:	5d                   	pop    %ebp
  80286f:	c3                   	ret    

00802870 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802870:	55                   	push   %ebp
  802871:	89 e5                	mov    %esp,%ebp
  802873:	83 ec 18             	sub    $0x18,%esp
  802876:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802879:	8b 55 08             	mov    0x8(%ebp),%edx
  80287c:	8b 52 0c             	mov    0xc(%edx),%edx
  80287f:	89 15 00 70 80 00    	mov    %edx,0x807000
	fsipcbuf.write.req_n = n;
  802885:	a3 04 70 80 00       	mov    %eax,0x807004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80288a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80288e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802891:	89 44 24 04          	mov    %eax,0x4(%esp)
  802895:	c7 04 24 08 70 80 00 	movl   $0x807008,(%esp)
  80289c:	e8 4b ed ff ff       	call   8015ec <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  8028a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8028a6:	b8 04 00 00 00       	mov    $0x4,%eax
  8028ab:	e8 b3 fe ff ff       	call   802763 <fsipc>
		return r;
	}

	return r;
}
  8028b0:	c9                   	leave  
  8028b1:	c3                   	ret    

008028b2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028b2:	55                   	push   %ebp
  8028b3:	89 e5                	mov    %esp,%ebp
  8028b5:	56                   	push   %esi
  8028b6:	53                   	push   %ebx
  8028b7:	83 ec 10             	sub    $0x10,%esp
  8028ba:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c3:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  8028c8:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8028ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8028d3:	b8 03 00 00 00       	mov    $0x3,%eax
  8028d8:	e8 86 fe ff ff       	call   802763 <fsipc>
  8028dd:	89 c3                	mov    %eax,%ebx
  8028df:	85 c0                	test   %eax,%eax
  8028e1:	78 6a                	js     80294d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8028e3:	39 c6                	cmp    %eax,%esi
  8028e5:	73 24                	jae    80290b <devfile_read+0x59>
  8028e7:	c7 44 24 0c 54 47 80 	movl   $0x804754,0xc(%esp)
  8028ee:	00 
  8028ef:	c7 44 24 08 69 40 80 	movl   $0x804069,0x8(%esp)
  8028f6:	00 
  8028f7:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8028fe:	00 
  8028ff:	c7 04 24 5b 47 80 00 	movl   $0x80475b,(%esp)
  802906:	e8 70 e1 ff ff       	call   800a7b <_panic>
	assert(r <= PGSIZE);
  80290b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802910:	7e 24                	jle    802936 <devfile_read+0x84>
  802912:	c7 44 24 0c 66 47 80 	movl   $0x804766,0xc(%esp)
  802919:	00 
  80291a:	c7 44 24 08 69 40 80 	movl   $0x804069,0x8(%esp)
  802921:	00 
  802922:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  802929:	00 
  80292a:	c7 04 24 5b 47 80 00 	movl   $0x80475b,(%esp)
  802931:	e8 45 e1 ff ff       	call   800a7b <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802936:	89 44 24 08          	mov    %eax,0x8(%esp)
  80293a:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802941:	00 
  802942:	8b 45 0c             	mov    0xc(%ebp),%eax
  802945:	89 04 24             	mov    %eax,(%esp)
  802948:	e8 37 ec ff ff       	call   801584 <memmove>
	return r;
}
  80294d:	89 d8                	mov    %ebx,%eax
  80294f:	83 c4 10             	add    $0x10,%esp
  802952:	5b                   	pop    %ebx
  802953:	5e                   	pop    %esi
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    

00802956 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802956:	55                   	push   %ebp
  802957:	89 e5                	mov    %esp,%ebp
  802959:	53                   	push   %ebx
  80295a:	83 ec 24             	sub    $0x24,%esp
  80295d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802960:	89 1c 24             	mov    %ebx,(%esp)
  802963:	e8 48 ea ff ff       	call   8013b0 <strlen>
  802968:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80296d:	7f 60                	jg     8029cf <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80296f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802972:	89 04 24             	mov    %eax,(%esp)
  802975:	e8 2d f8 ff ff       	call   8021a7 <fd_alloc>
  80297a:	89 c2                	mov    %eax,%edx
  80297c:	85 d2                	test   %edx,%edx
  80297e:	78 54                	js     8029d4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  802980:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802984:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  80298b:	e8 57 ea ff ff       	call   8013e7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802990:	8b 45 0c             	mov    0xc(%ebp),%eax
  802993:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802998:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80299b:	b8 01 00 00 00       	mov    $0x1,%eax
  8029a0:	e8 be fd ff ff       	call   802763 <fsipc>
  8029a5:	89 c3                	mov    %eax,%ebx
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	79 17                	jns    8029c2 <open+0x6c>
		fd_close(fd, 0);
  8029ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8029b2:	00 
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	89 04 24             	mov    %eax,(%esp)
  8029b9:	e8 e8 f8 ff ff       	call   8022a6 <fd_close>
		return r;
  8029be:	89 d8                	mov    %ebx,%eax
  8029c0:	eb 12                	jmp    8029d4 <open+0x7e>
	}

	return fd2num(fd);
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	89 04 24             	mov    %eax,(%esp)
  8029c8:	e8 b3 f7 ff ff       	call   802180 <fd2num>
  8029cd:	eb 05                	jmp    8029d4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8029cf:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8029d4:	83 c4 24             	add    $0x24,%esp
  8029d7:	5b                   	pop    %ebx
  8029d8:	5d                   	pop    %ebp
  8029d9:	c3                   	ret    

008029da <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8029da:	55                   	push   %ebp
  8029db:	89 e5                	mov    %esp,%ebp
  8029dd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8029e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8029e5:	b8 08 00 00 00       	mov    $0x8,%eax
  8029ea:	e8 74 fd ff ff       	call   802763 <fsipc>
}
  8029ef:	c9                   	leave  
  8029f0:	c3                   	ret    

008029f1 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8029f1:	55                   	push   %ebp
  8029f2:	89 e5                	mov    %esp,%ebp
  8029f4:	53                   	push   %ebx
  8029f5:	83 ec 14             	sub    $0x14,%esp
  8029f8:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  8029fa:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8029fe:	7e 31                	jle    802a31 <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802a00:	8b 40 04             	mov    0x4(%eax),%eax
  802a03:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a07:	8d 43 10             	lea    0x10(%ebx),%eax
  802a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a0e:	8b 03                	mov    (%ebx),%eax
  802a10:	89 04 24             	mov    %eax,(%esp)
  802a13:	e8 4f fb ff ff       	call   802567 <write>
		if (result > 0)
  802a18:	85 c0                	test   %eax,%eax
  802a1a:	7e 03                	jle    802a1f <writebuf+0x2e>
			b->result += result;
  802a1c:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  802a1f:	39 43 04             	cmp    %eax,0x4(%ebx)
  802a22:	74 0d                	je     802a31 <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  802a24:	85 c0                	test   %eax,%eax
  802a26:	ba 00 00 00 00       	mov    $0x0,%edx
  802a2b:	0f 4f c2             	cmovg  %edx,%eax
  802a2e:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  802a31:	83 c4 14             	add    $0x14,%esp
  802a34:	5b                   	pop    %ebx
  802a35:	5d                   	pop    %ebp
  802a36:	c3                   	ret    

00802a37 <putch>:

static void
putch(int ch, void *thunk)
{
  802a37:	55                   	push   %ebp
  802a38:	89 e5                	mov    %esp,%ebp
  802a3a:	53                   	push   %ebx
  802a3b:	83 ec 04             	sub    $0x4,%esp
  802a3e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  802a41:	8b 53 04             	mov    0x4(%ebx),%edx
  802a44:	8d 42 01             	lea    0x1(%edx),%eax
  802a47:	89 43 04             	mov    %eax,0x4(%ebx)
  802a4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a4d:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  802a51:	3d 00 01 00 00       	cmp    $0x100,%eax
  802a56:	75 0e                	jne    802a66 <putch+0x2f>
		writebuf(b);
  802a58:	89 d8                	mov    %ebx,%eax
  802a5a:	e8 92 ff ff ff       	call   8029f1 <writebuf>
		b->idx = 0;
  802a5f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  802a66:	83 c4 04             	add    $0x4,%esp
  802a69:	5b                   	pop    %ebx
  802a6a:	5d                   	pop    %ebp
  802a6b:	c3                   	ret    

00802a6c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802a6c:	55                   	push   %ebp
  802a6d:	89 e5                	mov    %esp,%ebp
  802a6f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  802a75:	8b 45 08             	mov    0x8(%ebp),%eax
  802a78:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  802a7e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802a85:	00 00 00 
	b.result = 0;
  802a88:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802a8f:	00 00 00 
	b.error = 1;
  802a92:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802a99:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802a9c:	8b 45 10             	mov    0x10(%ebp),%eax
  802a9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aa6:	89 44 24 08          	mov    %eax,0x8(%esp)
  802aaa:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ab4:	c7 04 24 37 2a 80 00 	movl   $0x802a37,(%esp)
  802abb:	e8 3e e2 ff ff       	call   800cfe <vprintfmt>
	if (b.idx > 0)
  802ac0:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  802ac7:	7e 0b                	jle    802ad4 <vfprintf+0x68>
		writebuf(&b);
  802ac9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802acf:	e8 1d ff ff ff       	call   8029f1 <writebuf>

	return (b.result ? b.result : b.error);
  802ad4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802ada:	85 c0                	test   %eax,%eax
  802adc:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  802ae3:	c9                   	leave  
  802ae4:	c3                   	ret    

00802ae5 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802ae5:	55                   	push   %ebp
  802ae6:	89 e5                	mov    %esp,%ebp
  802ae8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802aeb:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802aee:	89 44 24 08          	mov    %eax,0x8(%esp)
  802af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802af5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802af9:	8b 45 08             	mov    0x8(%ebp),%eax
  802afc:	89 04 24             	mov    %eax,(%esp)
  802aff:	e8 68 ff ff ff       	call   802a6c <vfprintf>
	va_end(ap);

	return cnt;
}
  802b04:	c9                   	leave  
  802b05:	c3                   	ret    

00802b06 <printf>:

int
printf(const char *fmt, ...)
{
  802b06:	55                   	push   %ebp
  802b07:	89 e5                	mov    %esp,%ebp
  802b09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802b0c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802b0f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b13:	8b 45 08             	mov    0x8(%ebp),%eax
  802b16:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  802b21:	e8 46 ff ff ff       	call   802a6c <vfprintf>
	va_end(ap);

	return cnt;
}
  802b26:	c9                   	leave  
  802b27:	c3                   	ret    
  802b28:	66 90                	xchg   %ax,%ax
  802b2a:	66 90                	xchg   %ax,%ax
  802b2c:	66 90                	xchg   %ax,%ax
  802b2e:	66 90                	xchg   %ax,%ax

00802b30 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802b30:	55                   	push   %ebp
  802b31:	89 e5                	mov    %esp,%ebp
  802b33:	57                   	push   %edi
  802b34:	56                   	push   %esi
  802b35:	53                   	push   %ebx
  802b36:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802b3c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802b43:	00 
  802b44:	8b 45 08             	mov    0x8(%ebp),%eax
  802b47:	89 04 24             	mov    %eax,(%esp)
  802b4a:	e8 07 fe ff ff       	call   802956 <open>
  802b4f:	89 c1                	mov    %eax,%ecx
  802b51:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  802b57:	85 c0                	test   %eax,%eax
  802b59:	0f 88 fd 04 00 00    	js     80305c <spawn+0x52c>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802b5f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802b66:	00 
  802b67:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b71:	89 0c 24             	mov    %ecx,(%esp)
  802b74:	e8 a3 f9 ff ff       	call   80251c <readn>
  802b79:	3d 00 02 00 00       	cmp    $0x200,%eax
  802b7e:	75 0c                	jne    802b8c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  802b80:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802b87:	45 4c 46 
  802b8a:	74 36                	je     802bc2 <spawn+0x92>
		close(fd);
  802b8c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802b92:	89 04 24             	mov    %eax,(%esp)
  802b95:	e8 8d f7 ff ff       	call   802327 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802b9a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802ba1:	46 
  802ba2:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bac:	c7 04 24 72 47 80 00 	movl   $0x804772,(%esp)
  802bb3:	e8 bc df ff ff       	call   800b74 <cprintf>
		return -E_NOT_EXEC;
  802bb8:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  802bbd:	e9 4a 05 00 00       	jmp    80310c <spawn+0x5dc>
  802bc2:	b8 07 00 00 00       	mov    $0x7,%eax
  802bc7:	cd 30                	int    $0x30
  802bc9:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  802bcf:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802bd5:	85 c0                	test   %eax,%eax
  802bd7:	0f 88 8a 04 00 00    	js     803067 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802bdd:	25 ff 03 00 00       	and    $0x3ff,%eax
  802be2:	89 c2                	mov    %eax,%edx
  802be4:	c1 e2 07             	shl    $0x7,%edx
  802be7:	8d b4 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%esi
  802bee:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802bf4:	b9 11 00 00 00       	mov    $0x11,%ecx
  802bf9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802bfb:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802c01:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802c07:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802c0c:	be 00 00 00 00       	mov    $0x0,%esi
  802c11:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802c14:	eb 0f                	jmp    802c25 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  802c16:	89 04 24             	mov    %eax,(%esp)
  802c19:	e8 92 e7 ff ff       	call   8013b0 <strlen>
  802c1e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802c22:	83 c3 01             	add    $0x1,%ebx
  802c25:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802c2c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802c2f:	85 c0                	test   %eax,%eax
  802c31:	75 e3                	jne    802c16 <spawn+0xe6>
  802c33:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802c39:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802c3f:	bf 00 10 40 00       	mov    $0x401000,%edi
  802c44:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802c46:	89 fa                	mov    %edi,%edx
  802c48:	83 e2 fc             	and    $0xfffffffc,%edx
  802c4b:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802c52:	29 c2                	sub    %eax,%edx
  802c54:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802c5a:	8d 42 f8             	lea    -0x8(%edx),%eax
  802c5d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802c62:	0f 86 15 04 00 00    	jbe    80307d <spawn+0x54d>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802c68:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802c6f:	00 
  802c70:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802c77:	00 
  802c78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c7f:	e8 7f eb ff ff       	call   801803 <sys_page_alloc>
  802c84:	85 c0                	test   %eax,%eax
  802c86:	0f 88 80 04 00 00    	js     80310c <spawn+0x5dc>
  802c8c:	be 00 00 00 00       	mov    $0x0,%esi
  802c91:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  802c97:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802c9a:	eb 30                	jmp    802ccc <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  802c9c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802ca2:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802ca8:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802cab:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  802cae:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cb2:	89 3c 24             	mov    %edi,(%esp)
  802cb5:	e8 2d e7 ff ff       	call   8013e7 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802cba:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  802cbd:	89 04 24             	mov    %eax,(%esp)
  802cc0:	e8 eb e6 ff ff       	call   8013b0 <strlen>
  802cc5:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802cc9:	83 c6 01             	add    $0x1,%esi
  802ccc:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  802cd2:	7f c8                	jg     802c9c <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802cd4:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802cda:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802ce0:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802ce7:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802ced:	74 24                	je     802d13 <spawn+0x1e3>
  802cef:	c7 44 24 0c fc 47 80 	movl   $0x8047fc,0xc(%esp)
  802cf6:	00 
  802cf7:	c7 44 24 08 69 40 80 	movl   $0x804069,0x8(%esp)
  802cfe:	00 
  802cff:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  802d06:	00 
  802d07:	c7 04 24 8c 47 80 00 	movl   $0x80478c,(%esp)
  802d0e:	e8 68 dd ff ff       	call   800a7b <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802d13:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802d19:	89 c8                	mov    %ecx,%eax
  802d1b:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802d20:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802d23:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802d29:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802d2c:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  802d32:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802d38:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802d3f:	00 
  802d40:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802d47:	ee 
  802d48:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802d4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d52:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802d59:	00 
  802d5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d61:	e8 f1 ea ff ff       	call   801857 <sys_page_map>
  802d66:	89 c3                	mov    %eax,%ebx
  802d68:	85 c0                	test   %eax,%eax
  802d6a:	0f 88 86 03 00 00    	js     8030f6 <spawn+0x5c6>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802d70:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802d77:	00 
  802d78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d7f:	e8 26 eb ff ff       	call   8018aa <sys_page_unmap>
  802d84:	89 c3                	mov    %eax,%ebx
  802d86:	85 c0                	test   %eax,%eax
  802d88:	0f 88 68 03 00 00    	js     8030f6 <spawn+0x5c6>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802d8e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802d94:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802d9b:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802da1:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  802da8:	00 00 00 
  802dab:	e9 b6 01 00 00       	jmp    802f66 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  802db0:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802db6:	83 38 01             	cmpl   $0x1,(%eax)
  802db9:	0f 85 99 01 00 00    	jne    802f58 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802dbf:	89 c1                	mov    %eax,%ecx
  802dc1:	8b 40 18             	mov    0x18(%eax),%eax
  802dc4:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  802dc7:	83 f8 01             	cmp    $0x1,%eax
  802dca:	19 c0                	sbb    %eax,%eax
  802dcc:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802dd2:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  802dd9:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802de0:	89 c8                	mov    %ecx,%eax
  802de2:	8b 49 04             	mov    0x4(%ecx),%ecx
  802de5:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802deb:	8b 48 10             	mov    0x10(%eax),%ecx
  802dee:	89 8d 94 fd ff ff    	mov    %ecx,-0x26c(%ebp)
  802df4:	8b 50 14             	mov    0x14(%eax),%edx
  802df7:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  802dfd:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802e00:	89 f0                	mov    %esi,%eax
  802e02:	25 ff 0f 00 00       	and    $0xfff,%eax
  802e07:	74 14                	je     802e1d <spawn+0x2ed>
		va -= i;
  802e09:	29 c6                	sub    %eax,%esi
		memsz += i;
  802e0b:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  802e11:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  802e17:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802e1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802e22:	e9 23 01 00 00       	jmp    802f4a <spawn+0x41a>
		if (i >= filesz) {
  802e27:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  802e2d:	77 2b                	ja     802e5a <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802e2f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802e35:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e39:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e3d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802e43:	89 04 24             	mov    %eax,(%esp)
  802e46:	e8 b8 e9 ff ff       	call   801803 <sys_page_alloc>
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	0f 89 eb 00 00 00    	jns    802f3e <spawn+0x40e>
  802e53:	89 c3                	mov    %eax,%ebx
  802e55:	e9 37 02 00 00       	jmp    803091 <spawn+0x561>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802e5a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802e61:	00 
  802e62:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802e69:	00 
  802e6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e71:	e8 8d e9 ff ff       	call   801803 <sys_page_alloc>
  802e76:	85 c0                	test   %eax,%eax
  802e78:	0f 88 09 02 00 00    	js     803087 <spawn+0x557>
  802e7e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802e84:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802e86:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e8a:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802e90:	89 04 24             	mov    %eax,(%esp)
  802e93:	e8 5c f7 ff ff       	call   8025f4 <seek>
  802e98:	85 c0                	test   %eax,%eax
  802e9a:	0f 88 eb 01 00 00    	js     80308b <spawn+0x55b>
  802ea0:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802ea6:	29 f9                	sub    %edi,%ecx
  802ea8:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802eaa:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  802eb0:	ba 00 10 00 00       	mov    $0x1000,%edx
  802eb5:	0f 47 c2             	cmova  %edx,%eax
  802eb8:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ebc:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802ec3:	00 
  802ec4:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802eca:	89 04 24             	mov    %eax,(%esp)
  802ecd:	e8 4a f6 ff ff       	call   80251c <readn>
  802ed2:	85 c0                	test   %eax,%eax
  802ed4:	0f 88 b5 01 00 00    	js     80308f <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802eda:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802ee0:	89 44 24 10          	mov    %eax,0x10(%esp)
  802ee4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802ee8:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802eee:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ef2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802ef9:	00 
  802efa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f01:	e8 51 e9 ff ff       	call   801857 <sys_page_map>
  802f06:	85 c0                	test   %eax,%eax
  802f08:	79 20                	jns    802f2a <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  802f0a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f0e:	c7 44 24 08 98 47 80 	movl   $0x804798,0x8(%esp)
  802f15:	00 
  802f16:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
  802f1d:	00 
  802f1e:	c7 04 24 8c 47 80 00 	movl   $0x80478c,(%esp)
  802f25:	e8 51 db ff ff       	call   800a7b <_panic>
			sys_page_unmap(0, UTEMP);
  802f2a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802f31:	00 
  802f32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f39:	e8 6c e9 ff ff       	call   8018aa <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802f3e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802f44:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802f4a:	89 df                	mov    %ebx,%edi
  802f4c:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  802f52:	0f 87 cf fe ff ff    	ja     802e27 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802f58:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  802f5f:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  802f66:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802f6d:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  802f73:	0f 8c 37 fe ff ff    	jl     802db0 <spawn+0x280>
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	
	close(fd);
  802f79:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802f7f:	89 04 24             	mov    %eax,(%esp)
  802f82:	e8 a0 f3 ff ff       	call   802327 <close>
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE){
  802f87:	bb 00 00 00 00       	mov    $0x0,%ebx
  802f8c:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
		if(((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_SHARE))
  802f92:	89 d8                	mov    %ebx,%eax
  802f94:	c1 e8 16             	shr    $0x16,%eax
  802f97:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802f9e:	a8 01                	test   $0x1,%al
  802fa0:	74 4d                	je     802fef <spawn+0x4bf>
  802fa2:	89 d8                	mov    %ebx,%eax
  802fa4:	c1 e8 0c             	shr    $0xc,%eax
  802fa7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802fae:	f6 c2 01             	test   $0x1,%dl
  802fb1:	74 3c                	je     802fef <spawn+0x4bf>
  802fb3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802fba:	f6 c6 04             	test   $0x4,%dh
  802fbd:	74 30                	je     802fef <spawn+0x4bf>
		&& ((r = sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[PGNUM(addr)]&PTE_SYSCALL)) < 0)){
  802fbf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802fc6:	25 07 0e 00 00       	and    $0xe07,%eax
  802fcb:	89 44 24 10          	mov    %eax,0x10(%esp)
  802fcf:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802fd3:	89 74 24 08          	mov    %esi,0x8(%esp)
  802fd7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802fdb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802fe2:	e8 70 e8 ff ff       	call   801857 <sys_page_map>
  802fe7:	85 c0                	test   %eax,%eax
  802fe9:	0f 88 e7 00 00 00    	js     8030d6 <spawn+0x5a6>
{
	// LAB 5: Your code here.
	uint32_t addr;
	int r;

	for (addr = 0; addr < USTACKTOP; addr += PGSIZE){
  802fef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802ff5:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802ffb:	75 95                	jne    802f92 <spawn+0x462>
  802ffd:	e9 af 00 00 00       	jmp    8030b1 <spawn+0x581>
	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  803002:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803006:	c7 44 24 08 b5 47 80 	movl   $0x8047b5,0x8(%esp)
  80300d:	00 
  80300e:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
  803015:	00 
  803016:	c7 04 24 8c 47 80 00 	movl   $0x80478c,(%esp)
  80301d:	e8 59 da ff ff       	call   800a7b <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803022:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  803029:	00 
  80302a:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  803030:	89 04 24             	mov    %eax,(%esp)
  803033:	e8 c5 e8 ff ff       	call   8018fd <sys_env_set_status>
  803038:	85 c0                	test   %eax,%eax
  80303a:	79 36                	jns    803072 <spawn+0x542>
		panic("sys_env_set_status: %e", r);
  80303c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803040:	c7 44 24 08 cf 47 80 	movl   $0x8047cf,0x8(%esp)
  803047:	00 
  803048:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  80304f:	00 
  803050:	c7 04 24 8c 47 80 00 	movl   $0x80478c,(%esp)
  803057:	e8 1f da ff ff       	call   800a7b <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  80305c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  803062:	e9 a5 00 00 00       	jmp    80310c <spawn+0x5dc>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  803067:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80306d:	e9 9a 00 00 00       	jmp    80310c <spawn+0x5dc>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  803072:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  803078:	e9 8f 00 00 00       	jmp    80310c <spawn+0x5dc>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  80307d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803082:	e9 85 00 00 00       	jmp    80310c <spawn+0x5dc>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803087:	89 c3                	mov    %eax,%ebx
  803089:	eb 06                	jmp    803091 <spawn+0x561>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80308b:	89 c3                	mov    %eax,%ebx
  80308d:	eb 02                	jmp    803091 <spawn+0x561>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80308f:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803091:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  803097:	89 04 24             	mov    %eax,(%esp)
  80309a:	e8 d4 e6 ff ff       	call   801773 <sys_env_destroy>
	close(fd);
  80309f:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8030a5:	89 04 24             	mov    %eax,(%esp)
  8030a8:	e8 7a f2 ff ff       	call   802327 <close>
	return r;
  8030ad:	89 d8                	mov    %ebx,%eax
  8030af:	eb 5b                	jmp    80310c <spawn+0x5dc>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8030b1:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8030b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030bb:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8030c1:	89 04 24             	mov    %eax,(%esp)
  8030c4:	e8 87 e8 ff ff       	call   801950 <sys_env_set_trapframe>
  8030c9:	85 c0                	test   %eax,%eax
  8030cb:	0f 89 51 ff ff ff    	jns    803022 <spawn+0x4f2>
  8030d1:	e9 2c ff ff ff       	jmp    803002 <spawn+0x4d2>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  8030d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030da:	c7 44 24 08 e6 47 80 	movl   $0x8047e6,0x8(%esp)
  8030e1:	00 
  8030e2:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
  8030e9:	00 
  8030ea:	c7 04 24 8c 47 80 00 	movl   $0x80478c,(%esp)
  8030f1:	e8 85 d9 ff ff       	call   800a7b <_panic>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8030f6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8030fd:	00 
  8030fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803105:	e8 a0 e7 ff ff       	call   8018aa <sys_page_unmap>
  80310a:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80310c:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  803112:	5b                   	pop    %ebx
  803113:	5e                   	pop    %esi
  803114:	5f                   	pop    %edi
  803115:	5d                   	pop    %ebp
  803116:	c3                   	ret    

00803117 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803117:	55                   	push   %ebp
  803118:	89 e5                	mov    %esp,%ebp
  80311a:	56                   	push   %esi
  80311b:	53                   	push   %ebx
  80311c:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80311f:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803122:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803127:	eb 03                	jmp    80312c <spawnl+0x15>
		argc++;
  803129:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80312c:	83 c0 04             	add    $0x4,%eax
  80312f:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  803133:	75 f4                	jne    803129 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803135:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  80313c:	83 e0 f0             	and    $0xfffffff0,%eax
  80313f:	29 c4                	sub    %eax,%esp
  803141:	8d 44 24 0b          	lea    0xb(%esp),%eax
  803145:	c1 e8 02             	shr    $0x2,%eax
  803148:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  80314f:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  803151:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803154:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  80315b:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  803162:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803163:	b8 00 00 00 00       	mov    $0x0,%eax
  803168:	eb 0a                	jmp    803174 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  80316a:	83 c0 01             	add    $0x1,%eax
  80316d:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  803171:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803174:	39 d0                	cmp    %edx,%eax
  803176:	75 f2                	jne    80316a <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803178:	89 74 24 04          	mov    %esi,0x4(%esp)
  80317c:	8b 45 08             	mov    0x8(%ebp),%eax
  80317f:	89 04 24             	mov    %eax,(%esp)
  803182:	e8 a9 f9 ff ff       	call   802b30 <spawn>
}
  803187:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80318a:	5b                   	pop    %ebx
  80318b:	5e                   	pop    %esi
  80318c:	5d                   	pop    %ebp
  80318d:	c3                   	ret    
  80318e:	66 90                	xchg   %ax,%ax

00803190 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803190:	55                   	push   %ebp
  803191:	89 e5                	mov    %esp,%ebp
  803193:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803196:	c7 44 24 04 22 48 80 	movl   $0x804822,0x4(%esp)
  80319d:	00 
  80319e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a1:	89 04 24             	mov    %eax,(%esp)
  8031a4:	e8 3e e2 ff ff       	call   8013e7 <strcpy>
	return 0;
}
  8031a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ae:	c9                   	leave  
  8031af:	c3                   	ret    

008031b0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8031b0:	55                   	push   %ebp
  8031b1:	89 e5                	mov    %esp,%ebp
  8031b3:	53                   	push   %ebx
  8031b4:	83 ec 14             	sub    $0x14,%esp
  8031b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8031ba:	89 1c 24             	mov    %ebx,(%esp)
  8031bd:	e8 6c 0a 00 00       	call   803c2e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8031c2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8031c7:	83 f8 01             	cmp    $0x1,%eax
  8031ca:	75 0d                	jne    8031d9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8031cc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8031cf:	89 04 24             	mov    %eax,(%esp)
  8031d2:	e8 29 03 00 00       	call   803500 <nsipc_close>
  8031d7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8031d9:	89 d0                	mov    %edx,%eax
  8031db:	83 c4 14             	add    $0x14,%esp
  8031de:	5b                   	pop    %ebx
  8031df:	5d                   	pop    %ebp
  8031e0:	c3                   	ret    

008031e1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8031e1:	55                   	push   %ebp
  8031e2:	89 e5                	mov    %esp,%ebp
  8031e4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8031e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8031ee:	00 
  8031ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8031f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8031f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803200:	8b 40 0c             	mov    0xc(%eax),%eax
  803203:	89 04 24             	mov    %eax,(%esp)
  803206:	e8 f0 03 00 00       	call   8035fb <nsipc_send>
}
  80320b:	c9                   	leave  
  80320c:	c3                   	ret    

0080320d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80320d:	55                   	push   %ebp
  80320e:	89 e5                	mov    %esp,%ebp
  803210:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803213:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80321a:	00 
  80321b:	8b 45 10             	mov    0x10(%ebp),%eax
  80321e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803222:	8b 45 0c             	mov    0xc(%ebp),%eax
  803225:	89 44 24 04          	mov    %eax,0x4(%esp)
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	8b 40 0c             	mov    0xc(%eax),%eax
  80322f:	89 04 24             	mov    %eax,(%esp)
  803232:	e8 44 03 00 00       	call   80357b <nsipc_recv>
}
  803237:	c9                   	leave  
  803238:	c3                   	ret    

00803239 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803239:	55                   	push   %ebp
  80323a:	89 e5                	mov    %esp,%ebp
  80323c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80323f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803242:	89 54 24 04          	mov    %edx,0x4(%esp)
  803246:	89 04 24             	mov    %eax,(%esp)
  803249:	e8 a8 ef ff ff       	call   8021f6 <fd_lookup>
  80324e:	85 c0                	test   %eax,%eax
  803250:	78 17                	js     803269 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803255:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  80325b:	39 08                	cmp    %ecx,(%eax)
  80325d:	75 05                	jne    803264 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80325f:	8b 40 0c             	mov    0xc(%eax),%eax
  803262:	eb 05                	jmp    803269 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  803264:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  803269:	c9                   	leave  
  80326a:	c3                   	ret    

0080326b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80326b:	55                   	push   %ebp
  80326c:	89 e5                	mov    %esp,%ebp
  80326e:	56                   	push   %esi
  80326f:	53                   	push   %ebx
  803270:	83 ec 20             	sub    $0x20,%esp
  803273:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803275:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803278:	89 04 24             	mov    %eax,(%esp)
  80327b:	e8 27 ef ff ff       	call   8021a7 <fd_alloc>
  803280:	89 c3                	mov    %eax,%ebx
  803282:	85 c0                	test   %eax,%eax
  803284:	78 21                	js     8032a7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803286:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80328d:	00 
  80328e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803291:	89 44 24 04          	mov    %eax,0x4(%esp)
  803295:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80329c:	e8 62 e5 ff ff       	call   801803 <sys_page_alloc>
  8032a1:	89 c3                	mov    %eax,%ebx
  8032a3:	85 c0                	test   %eax,%eax
  8032a5:	79 0c                	jns    8032b3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8032a7:	89 34 24             	mov    %esi,(%esp)
  8032aa:	e8 51 02 00 00       	call   803500 <nsipc_close>
		return r;
  8032af:	89 d8                	mov    %ebx,%eax
  8032b1:	eb 20                	jmp    8032d3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8032b3:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  8032b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8032be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032c1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8032c8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8032cb:	89 14 24             	mov    %edx,(%esp)
  8032ce:	e8 ad ee ff ff       	call   802180 <fd2num>
}
  8032d3:	83 c4 20             	add    $0x20,%esp
  8032d6:	5b                   	pop    %ebx
  8032d7:	5e                   	pop    %esi
  8032d8:	5d                   	pop    %ebp
  8032d9:	c3                   	ret    

008032da <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032da:	55                   	push   %ebp
  8032db:	89 e5                	mov    %esp,%ebp
  8032dd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e3:	e8 51 ff ff ff       	call   803239 <fd2sockid>
		return r;
  8032e8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032ea:	85 c0                	test   %eax,%eax
  8032ec:	78 23                	js     803311 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8032ee:	8b 55 10             	mov    0x10(%ebp),%edx
  8032f1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8032f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032f8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8032fc:	89 04 24             	mov    %eax,(%esp)
  8032ff:	e8 45 01 00 00       	call   803449 <nsipc_accept>
		return r;
  803304:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803306:	85 c0                	test   %eax,%eax
  803308:	78 07                	js     803311 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80330a:	e8 5c ff ff ff       	call   80326b <alloc_sockfd>
  80330f:	89 c1                	mov    %eax,%ecx
}
  803311:	89 c8                	mov    %ecx,%eax
  803313:	c9                   	leave  
  803314:	c3                   	ret    

00803315 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803315:	55                   	push   %ebp
  803316:	89 e5                	mov    %esp,%ebp
  803318:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80331b:	8b 45 08             	mov    0x8(%ebp),%eax
  80331e:	e8 16 ff ff ff       	call   803239 <fd2sockid>
  803323:	89 c2                	mov    %eax,%edx
  803325:	85 d2                	test   %edx,%edx
  803327:	78 16                	js     80333f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  803329:	8b 45 10             	mov    0x10(%ebp),%eax
  80332c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803330:	8b 45 0c             	mov    0xc(%ebp),%eax
  803333:	89 44 24 04          	mov    %eax,0x4(%esp)
  803337:	89 14 24             	mov    %edx,(%esp)
  80333a:	e8 60 01 00 00       	call   80349f <nsipc_bind>
}
  80333f:	c9                   	leave  
  803340:	c3                   	ret    

00803341 <shutdown>:

int
shutdown(int s, int how)
{
  803341:	55                   	push   %ebp
  803342:	89 e5                	mov    %esp,%ebp
  803344:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803347:	8b 45 08             	mov    0x8(%ebp),%eax
  80334a:	e8 ea fe ff ff       	call   803239 <fd2sockid>
  80334f:	89 c2                	mov    %eax,%edx
  803351:	85 d2                	test   %edx,%edx
  803353:	78 0f                	js     803364 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  803355:	8b 45 0c             	mov    0xc(%ebp),%eax
  803358:	89 44 24 04          	mov    %eax,0x4(%esp)
  80335c:	89 14 24             	mov    %edx,(%esp)
  80335f:	e8 7a 01 00 00       	call   8034de <nsipc_shutdown>
}
  803364:	c9                   	leave  
  803365:	c3                   	ret    

00803366 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803366:	55                   	push   %ebp
  803367:	89 e5                	mov    %esp,%ebp
  803369:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80336c:	8b 45 08             	mov    0x8(%ebp),%eax
  80336f:	e8 c5 fe ff ff       	call   803239 <fd2sockid>
  803374:	89 c2                	mov    %eax,%edx
  803376:	85 d2                	test   %edx,%edx
  803378:	78 16                	js     803390 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80337a:	8b 45 10             	mov    0x10(%ebp),%eax
  80337d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803381:	8b 45 0c             	mov    0xc(%ebp),%eax
  803384:	89 44 24 04          	mov    %eax,0x4(%esp)
  803388:	89 14 24             	mov    %edx,(%esp)
  80338b:	e8 8a 01 00 00       	call   80351a <nsipc_connect>
}
  803390:	c9                   	leave  
  803391:	c3                   	ret    

00803392 <listen>:

int
listen(int s, int backlog)
{
  803392:	55                   	push   %ebp
  803393:	89 e5                	mov    %esp,%ebp
  803395:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803398:	8b 45 08             	mov    0x8(%ebp),%eax
  80339b:	e8 99 fe ff ff       	call   803239 <fd2sockid>
  8033a0:	89 c2                	mov    %eax,%edx
  8033a2:	85 d2                	test   %edx,%edx
  8033a4:	78 0f                	js     8033b5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8033a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033ad:	89 14 24             	mov    %edx,(%esp)
  8033b0:	e8 a4 01 00 00       	call   803559 <nsipc_listen>
}
  8033b5:	c9                   	leave  
  8033b6:	c3                   	ret    

008033b7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8033b7:	55                   	push   %ebp
  8033b8:	89 e5                	mov    %esp,%ebp
  8033ba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8033bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8033c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8033c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ce:	89 04 24             	mov    %eax,(%esp)
  8033d1:	e8 98 02 00 00       	call   80366e <nsipc_socket>
  8033d6:	89 c2                	mov    %eax,%edx
  8033d8:	85 d2                	test   %edx,%edx
  8033da:	78 05                	js     8033e1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8033dc:	e8 8a fe ff ff       	call   80326b <alloc_sockfd>
}
  8033e1:	c9                   	leave  
  8033e2:	c3                   	ret    

008033e3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8033e3:	55                   	push   %ebp
  8033e4:	89 e5                	mov    %esp,%ebp
  8033e6:	53                   	push   %ebx
  8033e7:	83 ec 14             	sub    $0x14,%esp
  8033ea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8033ec:	83 3d 24 64 80 00 00 	cmpl   $0x0,0x806424
  8033f3:	75 11                	jne    803406 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8033f5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8033fc:	e8 ee 07 00 00       	call   803bef <ipc_find_env>
  803401:	a3 24 64 80 00       	mov    %eax,0x806424
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803406:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80340d:	00 
  80340e:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  803415:	00 
  803416:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80341a:	a1 24 64 80 00       	mov    0x806424,%eax
  80341f:	89 04 24             	mov    %eax,(%esp)
  803422:	e8 5d 07 00 00       	call   803b84 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803427:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80342e:	00 
  80342f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803436:	00 
  803437:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80343e:	e8 ed 06 00 00       	call   803b30 <ipc_recv>
}
  803443:	83 c4 14             	add    $0x14,%esp
  803446:	5b                   	pop    %ebx
  803447:	5d                   	pop    %ebp
  803448:	c3                   	ret    

00803449 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803449:	55                   	push   %ebp
  80344a:	89 e5                	mov    %esp,%ebp
  80344c:	56                   	push   %esi
  80344d:	53                   	push   %ebx
  80344e:	83 ec 10             	sub    $0x10,%esp
  803451:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  803454:	8b 45 08             	mov    0x8(%ebp),%eax
  803457:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80345c:	8b 06                	mov    (%esi),%eax
  80345e:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803463:	b8 01 00 00 00       	mov    $0x1,%eax
  803468:	e8 76 ff ff ff       	call   8033e3 <nsipc>
  80346d:	89 c3                	mov    %eax,%ebx
  80346f:	85 c0                	test   %eax,%eax
  803471:	78 23                	js     803496 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803473:	a1 10 80 80 00       	mov    0x808010,%eax
  803478:	89 44 24 08          	mov    %eax,0x8(%esp)
  80347c:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803483:	00 
  803484:	8b 45 0c             	mov    0xc(%ebp),%eax
  803487:	89 04 24             	mov    %eax,(%esp)
  80348a:	e8 f5 e0 ff ff       	call   801584 <memmove>
		*addrlen = ret->ret_addrlen;
  80348f:	a1 10 80 80 00       	mov    0x808010,%eax
  803494:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  803496:	89 d8                	mov    %ebx,%eax
  803498:	83 c4 10             	add    $0x10,%esp
  80349b:	5b                   	pop    %ebx
  80349c:	5e                   	pop    %esi
  80349d:	5d                   	pop    %ebp
  80349e:	c3                   	ret    

0080349f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80349f:	55                   	push   %ebp
  8034a0:	89 e5                	mov    %esp,%ebp
  8034a2:	53                   	push   %ebx
  8034a3:	83 ec 14             	sub    $0x14,%esp
  8034a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8034a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ac:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8034b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034bc:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8034c3:	e8 bc e0 ff ff       	call   801584 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8034c8:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  8034ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8034d3:	e8 0b ff ff ff       	call   8033e3 <nsipc>
}
  8034d8:	83 c4 14             	add    $0x14,%esp
  8034db:	5b                   	pop    %ebx
  8034dc:	5d                   	pop    %ebp
  8034dd:	c3                   	ret    

008034de <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8034de:	55                   	push   %ebp
  8034df:	89 e5                	mov    %esp,%ebp
  8034e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8034e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  8034ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ef:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  8034f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8034f9:	e8 e5 fe ff ff       	call   8033e3 <nsipc>
}
  8034fe:	c9                   	leave  
  8034ff:	c3                   	ret    

00803500 <nsipc_close>:

int
nsipc_close(int s)
{
  803500:	55                   	push   %ebp
  803501:	89 e5                	mov    %esp,%ebp
  803503:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803506:	8b 45 08             	mov    0x8(%ebp),%eax
  803509:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  80350e:	b8 04 00 00 00       	mov    $0x4,%eax
  803513:	e8 cb fe ff ff       	call   8033e3 <nsipc>
}
  803518:	c9                   	leave  
  803519:	c3                   	ret    

0080351a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80351a:	55                   	push   %ebp
  80351b:	89 e5                	mov    %esp,%ebp
  80351d:	53                   	push   %ebx
  80351e:	83 ec 14             	sub    $0x14,%esp
  803521:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803524:	8b 45 08             	mov    0x8(%ebp),%eax
  803527:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80352c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803530:	8b 45 0c             	mov    0xc(%ebp),%eax
  803533:	89 44 24 04          	mov    %eax,0x4(%esp)
  803537:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80353e:	e8 41 e0 ff ff       	call   801584 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803543:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  803549:	b8 05 00 00 00       	mov    $0x5,%eax
  80354e:	e8 90 fe ff ff       	call   8033e3 <nsipc>
}
  803553:	83 c4 14             	add    $0x14,%esp
  803556:	5b                   	pop    %ebx
  803557:	5d                   	pop    %ebp
  803558:	c3                   	ret    

00803559 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803559:	55                   	push   %ebp
  80355a:	89 e5                	mov    %esp,%ebp
  80355c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80355f:	8b 45 08             	mov    0x8(%ebp),%eax
  803562:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  803567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80356a:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  80356f:	b8 06 00 00 00       	mov    $0x6,%eax
  803574:	e8 6a fe ff ff       	call   8033e3 <nsipc>
}
  803579:	c9                   	leave  
  80357a:	c3                   	ret    

0080357b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80357b:	55                   	push   %ebp
  80357c:	89 e5                	mov    %esp,%ebp
  80357e:	56                   	push   %esi
  80357f:	53                   	push   %ebx
  803580:	83 ec 10             	sub    $0x10,%esp
  803583:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803586:	8b 45 08             	mov    0x8(%ebp),%eax
  803589:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  80358e:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  803594:	8b 45 14             	mov    0x14(%ebp),%eax
  803597:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80359c:	b8 07 00 00 00       	mov    $0x7,%eax
  8035a1:	e8 3d fe ff ff       	call   8033e3 <nsipc>
  8035a6:	89 c3                	mov    %eax,%ebx
  8035a8:	85 c0                	test   %eax,%eax
  8035aa:	78 46                	js     8035f2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8035ac:	39 f0                	cmp    %esi,%eax
  8035ae:	7f 07                	jg     8035b7 <nsipc_recv+0x3c>
  8035b0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8035b5:	7e 24                	jle    8035db <nsipc_recv+0x60>
  8035b7:	c7 44 24 0c 2e 48 80 	movl   $0x80482e,0xc(%esp)
  8035be:	00 
  8035bf:	c7 44 24 08 69 40 80 	movl   $0x804069,0x8(%esp)
  8035c6:	00 
  8035c7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8035ce:	00 
  8035cf:	c7 04 24 43 48 80 00 	movl   $0x804843,(%esp)
  8035d6:	e8 a0 d4 ff ff       	call   800a7b <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8035db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8035df:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8035e6:	00 
  8035e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ea:	89 04 24             	mov    %eax,(%esp)
  8035ed:	e8 92 df ff ff       	call   801584 <memmove>
	}

	return r;
}
  8035f2:	89 d8                	mov    %ebx,%eax
  8035f4:	83 c4 10             	add    $0x10,%esp
  8035f7:	5b                   	pop    %ebx
  8035f8:	5e                   	pop    %esi
  8035f9:	5d                   	pop    %ebp
  8035fa:	c3                   	ret    

008035fb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8035fb:	55                   	push   %ebp
  8035fc:	89 e5                	mov    %esp,%ebp
  8035fe:	53                   	push   %ebx
  8035ff:	83 ec 14             	sub    $0x14,%esp
  803602:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803605:	8b 45 08             	mov    0x8(%ebp),%eax
  803608:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  80360d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803613:	7e 24                	jle    803639 <nsipc_send+0x3e>
  803615:	c7 44 24 0c 4f 48 80 	movl   $0x80484f,0xc(%esp)
  80361c:	00 
  80361d:	c7 44 24 08 69 40 80 	movl   $0x804069,0x8(%esp)
  803624:	00 
  803625:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80362c:	00 
  80362d:	c7 04 24 43 48 80 00 	movl   $0x804843,(%esp)
  803634:	e8 42 d4 ff ff       	call   800a7b <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803639:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80363d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803640:	89 44 24 04          	mov    %eax,0x4(%esp)
  803644:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  80364b:	e8 34 df ff ff       	call   801584 <memmove>
	nsipcbuf.send.req_size = size;
  803650:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  803656:	8b 45 14             	mov    0x14(%ebp),%eax
  803659:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  80365e:	b8 08 00 00 00       	mov    $0x8,%eax
  803663:	e8 7b fd ff ff       	call   8033e3 <nsipc>
}
  803668:	83 c4 14             	add    $0x14,%esp
  80366b:	5b                   	pop    %ebx
  80366c:	5d                   	pop    %ebp
  80366d:	c3                   	ret    

0080366e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80366e:	55                   	push   %ebp
  80366f:	89 e5                	mov    %esp,%ebp
  803671:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803674:	8b 45 08             	mov    0x8(%ebp),%eax
  803677:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  80367c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80367f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  803684:	8b 45 10             	mov    0x10(%ebp),%eax
  803687:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80368c:	b8 09 00 00 00       	mov    $0x9,%eax
  803691:	e8 4d fd ff ff       	call   8033e3 <nsipc>
}
  803696:	c9                   	leave  
  803697:	c3                   	ret    

00803698 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803698:	55                   	push   %ebp
  803699:	89 e5                	mov    %esp,%ebp
  80369b:	56                   	push   %esi
  80369c:	53                   	push   %ebx
  80369d:	83 ec 10             	sub    $0x10,%esp
  8036a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8036a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a6:	89 04 24             	mov    %eax,(%esp)
  8036a9:	e8 e2 ea ff ff       	call   802190 <fd2data>
  8036ae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8036b0:	c7 44 24 04 5b 48 80 	movl   $0x80485b,0x4(%esp)
  8036b7:	00 
  8036b8:	89 1c 24             	mov    %ebx,(%esp)
  8036bb:	e8 27 dd ff ff       	call   8013e7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8036c0:	8b 46 04             	mov    0x4(%esi),%eax
  8036c3:	2b 06                	sub    (%esi),%eax
  8036c5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8036cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8036d2:	00 00 00 
	stat->st_dev = &devpipe;
  8036d5:	c7 83 88 00 00 00 58 	movl   $0x805058,0x88(%ebx)
  8036dc:	50 80 00 
	return 0;
}
  8036df:	b8 00 00 00 00       	mov    $0x0,%eax
  8036e4:	83 c4 10             	add    $0x10,%esp
  8036e7:	5b                   	pop    %ebx
  8036e8:	5e                   	pop    %esi
  8036e9:	5d                   	pop    %ebp
  8036ea:	c3                   	ret    

008036eb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8036eb:	55                   	push   %ebp
  8036ec:	89 e5                	mov    %esp,%ebp
  8036ee:	53                   	push   %ebx
  8036ef:	83 ec 14             	sub    $0x14,%esp
  8036f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8036f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8036f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803700:	e8 a5 e1 ff ff       	call   8018aa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803705:	89 1c 24             	mov    %ebx,(%esp)
  803708:	e8 83 ea ff ff       	call   802190 <fd2data>
  80370d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803711:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803718:	e8 8d e1 ff ff       	call   8018aa <sys_page_unmap>
}
  80371d:	83 c4 14             	add    $0x14,%esp
  803720:	5b                   	pop    %ebx
  803721:	5d                   	pop    %ebp
  803722:	c3                   	ret    

00803723 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803723:	55                   	push   %ebp
  803724:	89 e5                	mov    %esp,%ebp
  803726:	57                   	push   %edi
  803727:	56                   	push   %esi
  803728:	53                   	push   %ebx
  803729:	83 ec 2c             	sub    $0x2c,%esp
  80372c:	89 c6                	mov    %eax,%esi
  80372e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803731:	a1 28 64 80 00       	mov    0x806428,%eax
  803736:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803739:	89 34 24             	mov    %esi,(%esp)
  80373c:	e8 ed 04 00 00       	call   803c2e <pageref>
  803741:	89 c7                	mov    %eax,%edi
  803743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803746:	89 04 24             	mov    %eax,(%esp)
  803749:	e8 e0 04 00 00       	call   803c2e <pageref>
  80374e:	39 c7                	cmp    %eax,%edi
  803750:	0f 94 c2             	sete   %dl
  803753:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  803756:	8b 0d 28 64 80 00    	mov    0x806428,%ecx
  80375c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80375f:	39 fb                	cmp    %edi,%ebx
  803761:	74 21                	je     803784 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  803763:	84 d2                	test   %dl,%dl
  803765:	74 ca                	je     803731 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803767:	8b 51 58             	mov    0x58(%ecx),%edx
  80376a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80376e:	89 54 24 08          	mov    %edx,0x8(%esp)
  803772:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803776:	c7 04 24 62 48 80 00 	movl   $0x804862,(%esp)
  80377d:	e8 f2 d3 ff ff       	call   800b74 <cprintf>
  803782:	eb ad                	jmp    803731 <_pipeisclosed+0xe>
	}
}
  803784:	83 c4 2c             	add    $0x2c,%esp
  803787:	5b                   	pop    %ebx
  803788:	5e                   	pop    %esi
  803789:	5f                   	pop    %edi
  80378a:	5d                   	pop    %ebp
  80378b:	c3                   	ret    

0080378c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80378c:	55                   	push   %ebp
  80378d:	89 e5                	mov    %esp,%ebp
  80378f:	57                   	push   %edi
  803790:	56                   	push   %esi
  803791:	53                   	push   %ebx
  803792:	83 ec 1c             	sub    $0x1c,%esp
  803795:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803798:	89 34 24             	mov    %esi,(%esp)
  80379b:	e8 f0 e9 ff ff       	call   802190 <fd2data>
  8037a0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a7:	eb 45                	jmp    8037ee <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8037a9:	89 da                	mov    %ebx,%edx
  8037ab:	89 f0                	mov    %esi,%eax
  8037ad:	e8 71 ff ff ff       	call   803723 <_pipeisclosed>
  8037b2:	85 c0                	test   %eax,%eax
  8037b4:	75 41                	jne    8037f7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8037b6:	e8 29 e0 ff ff       	call   8017e4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8037bb:	8b 43 04             	mov    0x4(%ebx),%eax
  8037be:	8b 0b                	mov    (%ebx),%ecx
  8037c0:	8d 51 20             	lea    0x20(%ecx),%edx
  8037c3:	39 d0                	cmp    %edx,%eax
  8037c5:	73 e2                	jae    8037a9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8037c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8037ca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8037ce:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8037d1:	99                   	cltd   
  8037d2:	c1 ea 1b             	shr    $0x1b,%edx
  8037d5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8037d8:	83 e1 1f             	and    $0x1f,%ecx
  8037db:	29 d1                	sub    %edx,%ecx
  8037dd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8037e1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8037e5:	83 c0 01             	add    $0x1,%eax
  8037e8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037eb:	83 c7 01             	add    $0x1,%edi
  8037ee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8037f1:	75 c8                	jne    8037bb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8037f3:	89 f8                	mov    %edi,%eax
  8037f5:	eb 05                	jmp    8037fc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8037f7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8037fc:	83 c4 1c             	add    $0x1c,%esp
  8037ff:	5b                   	pop    %ebx
  803800:	5e                   	pop    %esi
  803801:	5f                   	pop    %edi
  803802:	5d                   	pop    %ebp
  803803:	c3                   	ret    

00803804 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803804:	55                   	push   %ebp
  803805:	89 e5                	mov    %esp,%ebp
  803807:	57                   	push   %edi
  803808:	56                   	push   %esi
  803809:	53                   	push   %ebx
  80380a:	83 ec 1c             	sub    $0x1c,%esp
  80380d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803810:	89 3c 24             	mov    %edi,(%esp)
  803813:	e8 78 e9 ff ff       	call   802190 <fd2data>
  803818:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80381a:	be 00 00 00 00       	mov    $0x0,%esi
  80381f:	eb 3d                	jmp    80385e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803821:	85 f6                	test   %esi,%esi
  803823:	74 04                	je     803829 <devpipe_read+0x25>
				return i;
  803825:	89 f0                	mov    %esi,%eax
  803827:	eb 43                	jmp    80386c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803829:	89 da                	mov    %ebx,%edx
  80382b:	89 f8                	mov    %edi,%eax
  80382d:	e8 f1 fe ff ff       	call   803723 <_pipeisclosed>
  803832:	85 c0                	test   %eax,%eax
  803834:	75 31                	jne    803867 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803836:	e8 a9 df ff ff       	call   8017e4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80383b:	8b 03                	mov    (%ebx),%eax
  80383d:	3b 43 04             	cmp    0x4(%ebx),%eax
  803840:	74 df                	je     803821 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803842:	99                   	cltd   
  803843:	c1 ea 1b             	shr    $0x1b,%edx
  803846:	01 d0                	add    %edx,%eax
  803848:	83 e0 1f             	and    $0x1f,%eax
  80384b:	29 d0                	sub    %edx,%eax
  80384d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803852:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803855:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803858:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80385b:	83 c6 01             	add    $0x1,%esi
  80385e:	3b 75 10             	cmp    0x10(%ebp),%esi
  803861:	75 d8                	jne    80383b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803863:	89 f0                	mov    %esi,%eax
  803865:	eb 05                	jmp    80386c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803867:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80386c:	83 c4 1c             	add    $0x1c,%esp
  80386f:	5b                   	pop    %ebx
  803870:	5e                   	pop    %esi
  803871:	5f                   	pop    %edi
  803872:	5d                   	pop    %ebp
  803873:	c3                   	ret    

00803874 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803874:	55                   	push   %ebp
  803875:	89 e5                	mov    %esp,%ebp
  803877:	56                   	push   %esi
  803878:	53                   	push   %ebx
  803879:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80387c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80387f:	89 04 24             	mov    %eax,(%esp)
  803882:	e8 20 e9 ff ff       	call   8021a7 <fd_alloc>
  803887:	89 c2                	mov    %eax,%edx
  803889:	85 d2                	test   %edx,%edx
  80388b:	0f 88 4d 01 00 00    	js     8039de <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803891:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803898:	00 
  803899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038a7:	e8 57 df ff ff       	call   801803 <sys_page_alloc>
  8038ac:	89 c2                	mov    %eax,%edx
  8038ae:	85 d2                	test   %edx,%edx
  8038b0:	0f 88 28 01 00 00    	js     8039de <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8038b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8038b9:	89 04 24             	mov    %eax,(%esp)
  8038bc:	e8 e6 e8 ff ff       	call   8021a7 <fd_alloc>
  8038c1:	89 c3                	mov    %eax,%ebx
  8038c3:	85 c0                	test   %eax,%eax
  8038c5:	0f 88 fe 00 00 00    	js     8039c9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038cb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8038d2:	00 
  8038d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038e1:	e8 1d df ff ff       	call   801803 <sys_page_alloc>
  8038e6:	89 c3                	mov    %eax,%ebx
  8038e8:	85 c0                	test   %eax,%eax
  8038ea:	0f 88 d9 00 00 00    	js     8039c9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8038f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f3:	89 04 24             	mov    %eax,(%esp)
  8038f6:	e8 95 e8 ff ff       	call   802190 <fd2data>
  8038fb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038fd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803904:	00 
  803905:	89 44 24 04          	mov    %eax,0x4(%esp)
  803909:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803910:	e8 ee de ff ff       	call   801803 <sys_page_alloc>
  803915:	89 c3                	mov    %eax,%ebx
  803917:	85 c0                	test   %eax,%eax
  803919:	0f 88 97 00 00 00    	js     8039b6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80391f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803922:	89 04 24             	mov    %eax,(%esp)
  803925:	e8 66 e8 ff ff       	call   802190 <fd2data>
  80392a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803931:	00 
  803932:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803936:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80393d:	00 
  80393e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803942:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803949:	e8 09 df ff ff       	call   801857 <sys_page_map>
  80394e:	89 c3                	mov    %eax,%ebx
  803950:	85 c0                	test   %eax,%eax
  803952:	78 52                	js     8039a6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803954:	8b 15 58 50 80 00    	mov    0x805058,%edx
  80395a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80395f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803962:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803969:	8b 15 58 50 80 00    	mov    0x805058,%edx
  80396f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803972:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803977:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80397e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803981:	89 04 24             	mov    %eax,(%esp)
  803984:	e8 f7 e7 ff ff       	call   802180 <fd2num>
  803989:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80398c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80398e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803991:	89 04 24             	mov    %eax,(%esp)
  803994:	e8 e7 e7 ff ff       	call   802180 <fd2num>
  803999:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80399c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80399f:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a4:	eb 38                	jmp    8039de <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8039a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8039aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039b1:	e8 f4 de ff ff       	call   8018aa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8039b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039c4:	e8 e1 de ff ff       	call   8018aa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8039c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039d7:	e8 ce de ff ff       	call   8018aa <sys_page_unmap>
  8039dc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8039de:	83 c4 30             	add    $0x30,%esp
  8039e1:	5b                   	pop    %ebx
  8039e2:	5e                   	pop    %esi
  8039e3:	5d                   	pop    %ebp
  8039e4:	c3                   	ret    

008039e5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8039e5:	55                   	push   %ebp
  8039e6:	89 e5                	mov    %esp,%ebp
  8039e8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8039eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8039ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f5:	89 04 24             	mov    %eax,(%esp)
  8039f8:	e8 f9 e7 ff ff       	call   8021f6 <fd_lookup>
  8039fd:	89 c2                	mov    %eax,%edx
  8039ff:	85 d2                	test   %edx,%edx
  803a01:	78 15                	js     803a18 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a06:	89 04 24             	mov    %eax,(%esp)
  803a09:	e8 82 e7 ff ff       	call   802190 <fd2data>
	return _pipeisclosed(fd, p);
  803a0e:	89 c2                	mov    %eax,%edx
  803a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a13:	e8 0b fd ff ff       	call   803723 <_pipeisclosed>
}
  803a18:	c9                   	leave  
  803a19:	c3                   	ret    

00803a1a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803a1a:	55                   	push   %ebp
  803a1b:	89 e5                	mov    %esp,%ebp
  803a1d:	56                   	push   %esi
  803a1e:	53                   	push   %ebx
  803a1f:	83 ec 10             	sub    $0x10,%esp
  803a22:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803a25:	85 f6                	test   %esi,%esi
  803a27:	75 24                	jne    803a4d <wait+0x33>
  803a29:	c7 44 24 0c 75 48 80 	movl   $0x804875,0xc(%esp)
  803a30:	00 
  803a31:	c7 44 24 08 69 40 80 	movl   $0x804069,0x8(%esp)
  803a38:	00 
  803a39:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  803a40:	00 
  803a41:	c7 04 24 80 48 80 00 	movl   $0x804880,(%esp)
  803a48:	e8 2e d0 ff ff       	call   800a7b <_panic>
	e = &envs[ENVX(envid)];
  803a4d:	89 f0                	mov    %esi,%eax
  803a4f:	25 ff 03 00 00       	and    $0x3ff,%eax
  803a54:	89 c2                	mov    %eax,%edx
  803a56:	c1 e2 07             	shl    $0x7,%edx
  803a59:	8d 9c 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803a60:	eb 05                	jmp    803a67 <wait+0x4d>
		sys_yield();
  803a62:	e8 7d dd ff ff       	call   8017e4 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803a67:	8b 43 48             	mov    0x48(%ebx),%eax
  803a6a:	39 f0                	cmp    %esi,%eax
  803a6c:	75 07                	jne    803a75 <wait+0x5b>
  803a6e:	8b 43 54             	mov    0x54(%ebx),%eax
  803a71:	85 c0                	test   %eax,%eax
  803a73:	75 ed                	jne    803a62 <wait+0x48>
		sys_yield();
}
  803a75:	83 c4 10             	add    $0x10,%esp
  803a78:	5b                   	pop    %ebx
  803a79:	5e                   	pop    %esi
  803a7a:	5d                   	pop    %ebp
  803a7b:	c3                   	ret    

00803a7c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803a7c:	55                   	push   %ebp
  803a7d:	89 e5                	mov    %esp,%ebp
  803a7f:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  803a82:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  803a89:	75 70                	jne    803afb <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  803a8b:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  803a92:	00 
  803a93:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  803a9a:	ee 
  803a9b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803aa2:	e8 5c dd ff ff       	call   801803 <sys_page_alloc>
		if (error < 0)
  803aa7:	85 c0                	test   %eax,%eax
  803aa9:	79 1c                	jns    803ac7 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  803aab:	c7 44 24 08 8c 48 80 	movl   $0x80488c,0x8(%esp)
  803ab2:	00 
  803ab3:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  803aba:	00 
  803abb:	c7 04 24 df 48 80 00 	movl   $0x8048df,(%esp)
  803ac2:	e8 b4 cf ff ff       	call   800a7b <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803ac7:	c7 44 24 04 05 3b 80 	movl   $0x803b05,0x4(%esp)
  803ace:	00 
  803acf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ad6:	e8 c8 de ff ff       	call   8019a3 <sys_env_set_pgfault_upcall>
		if (error < 0)
  803adb:	85 c0                	test   %eax,%eax
  803add:	79 1c                	jns    803afb <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  803adf:	c7 44 24 08 b4 48 80 	movl   $0x8048b4,0x8(%esp)
  803ae6:	00 
  803ae7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  803aee:	00 
  803aef:	c7 04 24 df 48 80 00 	movl   $0x8048df,(%esp)
  803af6:	e8 80 cf ff ff       	call   800a7b <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803afb:	8b 45 08             	mov    0x8(%ebp),%eax
  803afe:	a3 00 90 80 00       	mov    %eax,0x809000
}
  803b03:	c9                   	leave  
  803b04:	c3                   	ret    

00803b05 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803b05:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803b06:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  803b0b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803b0d:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  803b10:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  803b14:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  803b19:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  803b1d:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  803b1f:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  803b22:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803b23:	83 c4 04             	add    $0x4,%esp
	popfl
  803b26:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803b27:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803b28:	c3                   	ret    
  803b29:	66 90                	xchg   %ax,%ax
  803b2b:	66 90                	xchg   %ax,%ax
  803b2d:	66 90                	xchg   %ax,%ax
  803b2f:	90                   	nop

00803b30 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803b30:	55                   	push   %ebp
  803b31:	89 e5                	mov    %esp,%ebp
  803b33:	56                   	push   %esi
  803b34:	53                   	push   %ebx
  803b35:	83 ec 10             	sub    $0x10,%esp
  803b38:	8b 75 08             	mov    0x8(%ebp),%esi
  803b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  803b41:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  803b43:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  803b48:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  803b4b:	89 04 24             	mov    %eax,(%esp)
  803b4e:	e8 c6 de ff ff       	call   801a19 <sys_ipc_recv>
  803b53:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  803b55:	85 d2                	test   %edx,%edx
  803b57:	75 24                	jne    803b7d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  803b59:	85 f6                	test   %esi,%esi
  803b5b:	74 0a                	je     803b67 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  803b5d:	a1 28 64 80 00       	mov    0x806428,%eax
  803b62:	8b 40 74             	mov    0x74(%eax),%eax
  803b65:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  803b67:	85 db                	test   %ebx,%ebx
  803b69:	74 0a                	je     803b75 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  803b6b:	a1 28 64 80 00       	mov    0x806428,%eax
  803b70:	8b 40 78             	mov    0x78(%eax),%eax
  803b73:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  803b75:	a1 28 64 80 00       	mov    0x806428,%eax
  803b7a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  803b7d:	83 c4 10             	add    $0x10,%esp
  803b80:	5b                   	pop    %ebx
  803b81:	5e                   	pop    %esi
  803b82:	5d                   	pop    %ebp
  803b83:	c3                   	ret    

00803b84 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b84:	55                   	push   %ebp
  803b85:	89 e5                	mov    %esp,%ebp
  803b87:	57                   	push   %edi
  803b88:	56                   	push   %esi
  803b89:	53                   	push   %ebx
  803b8a:	83 ec 1c             	sub    $0x1c,%esp
  803b8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  803b90:	8b 75 0c             	mov    0xc(%ebp),%esi
  803b93:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  803b96:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  803b98:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  803b9d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  803ba0:	8b 45 14             	mov    0x14(%ebp),%eax
  803ba3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ba7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bab:	89 74 24 04          	mov    %esi,0x4(%esp)
  803baf:	89 3c 24             	mov    %edi,(%esp)
  803bb2:	e8 3f de ff ff       	call   8019f6 <sys_ipc_try_send>

		if (ret == 0)
  803bb7:	85 c0                	test   %eax,%eax
  803bb9:	74 2c                	je     803be7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  803bbb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803bbe:	74 20                	je     803be0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  803bc0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bc4:	c7 44 24 08 f0 48 80 	movl   $0x8048f0,0x8(%esp)
  803bcb:	00 
  803bcc:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  803bd3:	00 
  803bd4:	c7 04 24 20 49 80 00 	movl   $0x804920,(%esp)
  803bdb:	e8 9b ce ff ff       	call   800a7b <_panic>
		}

		sys_yield();
  803be0:	e8 ff db ff ff       	call   8017e4 <sys_yield>
	}
  803be5:	eb b9                	jmp    803ba0 <ipc_send+0x1c>
}
  803be7:	83 c4 1c             	add    $0x1c,%esp
  803bea:	5b                   	pop    %ebx
  803beb:	5e                   	pop    %esi
  803bec:	5f                   	pop    %edi
  803bed:	5d                   	pop    %ebp
  803bee:	c3                   	ret    

00803bef <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803bef:	55                   	push   %ebp
  803bf0:	89 e5                	mov    %esp,%ebp
  803bf2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  803bf5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803bfa:	89 c2                	mov    %eax,%edx
  803bfc:	c1 e2 07             	shl    $0x7,%edx
  803bff:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  803c06:	8b 52 50             	mov    0x50(%edx),%edx
  803c09:	39 ca                	cmp    %ecx,%edx
  803c0b:	75 11                	jne    803c1e <ipc_find_env+0x2f>
			return envs[i].env_id;
  803c0d:	89 c2                	mov    %eax,%edx
  803c0f:	c1 e2 07             	shl    $0x7,%edx
  803c12:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  803c19:	8b 40 40             	mov    0x40(%eax),%eax
  803c1c:	eb 0e                	jmp    803c2c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803c1e:	83 c0 01             	add    $0x1,%eax
  803c21:	3d 00 04 00 00       	cmp    $0x400,%eax
  803c26:	75 d2                	jne    803bfa <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803c28:	66 b8 00 00          	mov    $0x0,%ax
}
  803c2c:	5d                   	pop    %ebp
  803c2d:	c3                   	ret    

00803c2e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c2e:	55                   	push   %ebp
  803c2f:	89 e5                	mov    %esp,%ebp
  803c31:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803c34:	89 d0                	mov    %edx,%eax
  803c36:	c1 e8 16             	shr    $0x16,%eax
  803c39:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803c40:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803c45:	f6 c1 01             	test   $0x1,%cl
  803c48:	74 1d                	je     803c67 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  803c4a:	c1 ea 0c             	shr    $0xc,%edx
  803c4d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803c54:	f6 c2 01             	test   $0x1,%dl
  803c57:	74 0e                	je     803c67 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803c59:	c1 ea 0c             	shr    $0xc,%edx
  803c5c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803c63:	ef 
  803c64:	0f b7 c0             	movzwl %ax,%eax
}
  803c67:	5d                   	pop    %ebp
  803c68:	c3                   	ret    
  803c69:	66 90                	xchg   %ax,%ax
  803c6b:	66 90                	xchg   %ax,%ax
  803c6d:	66 90                	xchg   %ax,%ax
  803c6f:	90                   	nop

00803c70 <__udivdi3>:
  803c70:	55                   	push   %ebp
  803c71:	57                   	push   %edi
  803c72:	56                   	push   %esi
  803c73:	83 ec 0c             	sub    $0xc,%esp
  803c76:	8b 44 24 28          	mov    0x28(%esp),%eax
  803c7a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  803c7e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  803c82:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803c86:	85 c0                	test   %eax,%eax
  803c88:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803c8c:	89 ea                	mov    %ebp,%edx
  803c8e:	89 0c 24             	mov    %ecx,(%esp)
  803c91:	75 2d                	jne    803cc0 <__udivdi3+0x50>
  803c93:	39 e9                	cmp    %ebp,%ecx
  803c95:	77 61                	ja     803cf8 <__udivdi3+0x88>
  803c97:	85 c9                	test   %ecx,%ecx
  803c99:	89 ce                	mov    %ecx,%esi
  803c9b:	75 0b                	jne    803ca8 <__udivdi3+0x38>
  803c9d:	b8 01 00 00 00       	mov    $0x1,%eax
  803ca2:	31 d2                	xor    %edx,%edx
  803ca4:	f7 f1                	div    %ecx
  803ca6:	89 c6                	mov    %eax,%esi
  803ca8:	31 d2                	xor    %edx,%edx
  803caa:	89 e8                	mov    %ebp,%eax
  803cac:	f7 f6                	div    %esi
  803cae:	89 c5                	mov    %eax,%ebp
  803cb0:	89 f8                	mov    %edi,%eax
  803cb2:	f7 f6                	div    %esi
  803cb4:	89 ea                	mov    %ebp,%edx
  803cb6:	83 c4 0c             	add    $0xc,%esp
  803cb9:	5e                   	pop    %esi
  803cba:	5f                   	pop    %edi
  803cbb:	5d                   	pop    %ebp
  803cbc:	c3                   	ret    
  803cbd:	8d 76 00             	lea    0x0(%esi),%esi
  803cc0:	39 e8                	cmp    %ebp,%eax
  803cc2:	77 24                	ja     803ce8 <__udivdi3+0x78>
  803cc4:	0f bd e8             	bsr    %eax,%ebp
  803cc7:	83 f5 1f             	xor    $0x1f,%ebp
  803cca:	75 3c                	jne    803d08 <__udivdi3+0x98>
  803ccc:	8b 74 24 04          	mov    0x4(%esp),%esi
  803cd0:	39 34 24             	cmp    %esi,(%esp)
  803cd3:	0f 86 9f 00 00 00    	jbe    803d78 <__udivdi3+0x108>
  803cd9:	39 d0                	cmp    %edx,%eax
  803cdb:	0f 82 97 00 00 00    	jb     803d78 <__udivdi3+0x108>
  803ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803ce8:	31 d2                	xor    %edx,%edx
  803cea:	31 c0                	xor    %eax,%eax
  803cec:	83 c4 0c             	add    $0xc,%esp
  803cef:	5e                   	pop    %esi
  803cf0:	5f                   	pop    %edi
  803cf1:	5d                   	pop    %ebp
  803cf2:	c3                   	ret    
  803cf3:	90                   	nop
  803cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803cf8:	89 f8                	mov    %edi,%eax
  803cfa:	f7 f1                	div    %ecx
  803cfc:	31 d2                	xor    %edx,%edx
  803cfe:	83 c4 0c             	add    $0xc,%esp
  803d01:	5e                   	pop    %esi
  803d02:	5f                   	pop    %edi
  803d03:	5d                   	pop    %ebp
  803d04:	c3                   	ret    
  803d05:	8d 76 00             	lea    0x0(%esi),%esi
  803d08:	89 e9                	mov    %ebp,%ecx
  803d0a:	8b 3c 24             	mov    (%esp),%edi
  803d0d:	d3 e0                	shl    %cl,%eax
  803d0f:	89 c6                	mov    %eax,%esi
  803d11:	b8 20 00 00 00       	mov    $0x20,%eax
  803d16:	29 e8                	sub    %ebp,%eax
  803d18:	89 c1                	mov    %eax,%ecx
  803d1a:	d3 ef                	shr    %cl,%edi
  803d1c:	89 e9                	mov    %ebp,%ecx
  803d1e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803d22:	8b 3c 24             	mov    (%esp),%edi
  803d25:	09 74 24 08          	or     %esi,0x8(%esp)
  803d29:	89 d6                	mov    %edx,%esi
  803d2b:	d3 e7                	shl    %cl,%edi
  803d2d:	89 c1                	mov    %eax,%ecx
  803d2f:	89 3c 24             	mov    %edi,(%esp)
  803d32:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803d36:	d3 ee                	shr    %cl,%esi
  803d38:	89 e9                	mov    %ebp,%ecx
  803d3a:	d3 e2                	shl    %cl,%edx
  803d3c:	89 c1                	mov    %eax,%ecx
  803d3e:	d3 ef                	shr    %cl,%edi
  803d40:	09 d7                	or     %edx,%edi
  803d42:	89 f2                	mov    %esi,%edx
  803d44:	89 f8                	mov    %edi,%eax
  803d46:	f7 74 24 08          	divl   0x8(%esp)
  803d4a:	89 d6                	mov    %edx,%esi
  803d4c:	89 c7                	mov    %eax,%edi
  803d4e:	f7 24 24             	mull   (%esp)
  803d51:	39 d6                	cmp    %edx,%esi
  803d53:	89 14 24             	mov    %edx,(%esp)
  803d56:	72 30                	jb     803d88 <__udivdi3+0x118>
  803d58:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d5c:	89 e9                	mov    %ebp,%ecx
  803d5e:	d3 e2                	shl    %cl,%edx
  803d60:	39 c2                	cmp    %eax,%edx
  803d62:	73 05                	jae    803d69 <__udivdi3+0xf9>
  803d64:	3b 34 24             	cmp    (%esp),%esi
  803d67:	74 1f                	je     803d88 <__udivdi3+0x118>
  803d69:	89 f8                	mov    %edi,%eax
  803d6b:	31 d2                	xor    %edx,%edx
  803d6d:	e9 7a ff ff ff       	jmp    803cec <__udivdi3+0x7c>
  803d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803d78:	31 d2                	xor    %edx,%edx
  803d7a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d7f:	e9 68 ff ff ff       	jmp    803cec <__udivdi3+0x7c>
  803d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803d88:	8d 47 ff             	lea    -0x1(%edi),%eax
  803d8b:	31 d2                	xor    %edx,%edx
  803d8d:	83 c4 0c             	add    $0xc,%esp
  803d90:	5e                   	pop    %esi
  803d91:	5f                   	pop    %edi
  803d92:	5d                   	pop    %ebp
  803d93:	c3                   	ret    
  803d94:	66 90                	xchg   %ax,%ax
  803d96:	66 90                	xchg   %ax,%ax
  803d98:	66 90                	xchg   %ax,%ax
  803d9a:	66 90                	xchg   %ax,%ax
  803d9c:	66 90                	xchg   %ax,%ax
  803d9e:	66 90                	xchg   %ax,%ax

00803da0 <__umoddi3>:
  803da0:	55                   	push   %ebp
  803da1:	57                   	push   %edi
  803da2:	56                   	push   %esi
  803da3:	83 ec 14             	sub    $0x14,%esp
  803da6:	8b 44 24 28          	mov    0x28(%esp),%eax
  803daa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803dae:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803db2:	89 c7                	mov    %eax,%edi
  803db4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803db8:	8b 44 24 30          	mov    0x30(%esp),%eax
  803dbc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803dc0:	89 34 24             	mov    %esi,(%esp)
  803dc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803dc7:	85 c0                	test   %eax,%eax
  803dc9:	89 c2                	mov    %eax,%edx
  803dcb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803dcf:	75 17                	jne    803de8 <__umoddi3+0x48>
  803dd1:	39 fe                	cmp    %edi,%esi
  803dd3:	76 4b                	jbe    803e20 <__umoddi3+0x80>
  803dd5:	89 c8                	mov    %ecx,%eax
  803dd7:	89 fa                	mov    %edi,%edx
  803dd9:	f7 f6                	div    %esi
  803ddb:	89 d0                	mov    %edx,%eax
  803ddd:	31 d2                	xor    %edx,%edx
  803ddf:	83 c4 14             	add    $0x14,%esp
  803de2:	5e                   	pop    %esi
  803de3:	5f                   	pop    %edi
  803de4:	5d                   	pop    %ebp
  803de5:	c3                   	ret    
  803de6:	66 90                	xchg   %ax,%ax
  803de8:	39 f8                	cmp    %edi,%eax
  803dea:	77 54                	ja     803e40 <__umoddi3+0xa0>
  803dec:	0f bd e8             	bsr    %eax,%ebp
  803def:	83 f5 1f             	xor    $0x1f,%ebp
  803df2:	75 5c                	jne    803e50 <__umoddi3+0xb0>
  803df4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803df8:	39 3c 24             	cmp    %edi,(%esp)
  803dfb:	0f 87 e7 00 00 00    	ja     803ee8 <__umoddi3+0x148>
  803e01:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803e05:	29 f1                	sub    %esi,%ecx
  803e07:	19 c7                	sbb    %eax,%edi
  803e09:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e11:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e15:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803e19:	83 c4 14             	add    $0x14,%esp
  803e1c:	5e                   	pop    %esi
  803e1d:	5f                   	pop    %edi
  803e1e:	5d                   	pop    %ebp
  803e1f:	c3                   	ret    
  803e20:	85 f6                	test   %esi,%esi
  803e22:	89 f5                	mov    %esi,%ebp
  803e24:	75 0b                	jne    803e31 <__umoddi3+0x91>
  803e26:	b8 01 00 00 00       	mov    $0x1,%eax
  803e2b:	31 d2                	xor    %edx,%edx
  803e2d:	f7 f6                	div    %esi
  803e2f:	89 c5                	mov    %eax,%ebp
  803e31:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e35:	31 d2                	xor    %edx,%edx
  803e37:	f7 f5                	div    %ebp
  803e39:	89 c8                	mov    %ecx,%eax
  803e3b:	f7 f5                	div    %ebp
  803e3d:	eb 9c                	jmp    803ddb <__umoddi3+0x3b>
  803e3f:	90                   	nop
  803e40:	89 c8                	mov    %ecx,%eax
  803e42:	89 fa                	mov    %edi,%edx
  803e44:	83 c4 14             	add    $0x14,%esp
  803e47:	5e                   	pop    %esi
  803e48:	5f                   	pop    %edi
  803e49:	5d                   	pop    %ebp
  803e4a:	c3                   	ret    
  803e4b:	90                   	nop
  803e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803e50:	8b 04 24             	mov    (%esp),%eax
  803e53:	be 20 00 00 00       	mov    $0x20,%esi
  803e58:	89 e9                	mov    %ebp,%ecx
  803e5a:	29 ee                	sub    %ebp,%esi
  803e5c:	d3 e2                	shl    %cl,%edx
  803e5e:	89 f1                	mov    %esi,%ecx
  803e60:	d3 e8                	shr    %cl,%eax
  803e62:	89 e9                	mov    %ebp,%ecx
  803e64:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e68:	8b 04 24             	mov    (%esp),%eax
  803e6b:	09 54 24 04          	or     %edx,0x4(%esp)
  803e6f:	89 fa                	mov    %edi,%edx
  803e71:	d3 e0                	shl    %cl,%eax
  803e73:	89 f1                	mov    %esi,%ecx
  803e75:	89 44 24 08          	mov    %eax,0x8(%esp)
  803e79:	8b 44 24 10          	mov    0x10(%esp),%eax
  803e7d:	d3 ea                	shr    %cl,%edx
  803e7f:	89 e9                	mov    %ebp,%ecx
  803e81:	d3 e7                	shl    %cl,%edi
  803e83:	89 f1                	mov    %esi,%ecx
  803e85:	d3 e8                	shr    %cl,%eax
  803e87:	89 e9                	mov    %ebp,%ecx
  803e89:	09 f8                	or     %edi,%eax
  803e8b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  803e8f:	f7 74 24 04          	divl   0x4(%esp)
  803e93:	d3 e7                	shl    %cl,%edi
  803e95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e99:	89 d7                	mov    %edx,%edi
  803e9b:	f7 64 24 08          	mull   0x8(%esp)
  803e9f:	39 d7                	cmp    %edx,%edi
  803ea1:	89 c1                	mov    %eax,%ecx
  803ea3:	89 14 24             	mov    %edx,(%esp)
  803ea6:	72 2c                	jb     803ed4 <__umoddi3+0x134>
  803ea8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  803eac:	72 22                	jb     803ed0 <__umoddi3+0x130>
  803eae:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803eb2:	29 c8                	sub    %ecx,%eax
  803eb4:	19 d7                	sbb    %edx,%edi
  803eb6:	89 e9                	mov    %ebp,%ecx
  803eb8:	89 fa                	mov    %edi,%edx
  803eba:	d3 e8                	shr    %cl,%eax
  803ebc:	89 f1                	mov    %esi,%ecx
  803ebe:	d3 e2                	shl    %cl,%edx
  803ec0:	89 e9                	mov    %ebp,%ecx
  803ec2:	d3 ef                	shr    %cl,%edi
  803ec4:	09 d0                	or     %edx,%eax
  803ec6:	89 fa                	mov    %edi,%edx
  803ec8:	83 c4 14             	add    $0x14,%esp
  803ecb:	5e                   	pop    %esi
  803ecc:	5f                   	pop    %edi
  803ecd:	5d                   	pop    %ebp
  803ece:	c3                   	ret    
  803ecf:	90                   	nop
  803ed0:	39 d7                	cmp    %edx,%edi
  803ed2:	75 da                	jne    803eae <__umoddi3+0x10e>
  803ed4:	8b 14 24             	mov    (%esp),%edx
  803ed7:	89 c1                	mov    %eax,%ecx
  803ed9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  803edd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803ee1:	eb cb                	jmp    803eae <__umoddi3+0x10e>
  803ee3:	90                   	nop
  803ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803ee8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  803eec:	0f 82 0f ff ff ff    	jb     803e01 <__umoddi3+0x61>
  803ef2:	e9 1a ff ff ff       	jmp    803e11 <__umoddi3+0x71>
