
obj/user/echo.debug:     file format elf32-i386


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
  80002c:	e8 c3 00 00 00       	call   8000f4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800042:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800049:	83 ff 01             	cmp    $0x1,%edi
  80004c:	7e 2b                	jle    800079 <umain+0x46>
  80004e:	c7 44 24 04 60 27 80 	movl   $0x802760,0x4(%esp)
  800055:	00 
  800056:	8b 46 04             	mov    0x4(%esi),%eax
  800059:	89 04 24             	mov    %eax,(%esp)
  80005c:	e8 eb 01 00 00       	call   80024c <strcmp>
void
umain(int argc, char **argv)
{
	int i, nflag;

	nflag = 0;
  800061:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800068:	85 c0                	test   %eax,%eax
  80006a:	75 0d                	jne    800079 <umain+0x46>
		nflag = 1;
		argc--;
  80006c:	83 ef 01             	sub    $0x1,%edi
		argv++;
  80006f:	83 c6 04             	add    $0x4,%esi
{
	int i, nflag;

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
  800072:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  800079:	bb 01 00 00 00       	mov    $0x1,%ebx
  80007e:	eb 46                	jmp    8000c6 <umain+0x93>
		if (i > 1)
  800080:	83 fb 01             	cmp    $0x1,%ebx
  800083:	7e 1c                	jle    8000a1 <umain+0x6e>
			write(1, " ", 1);
  800085:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80008c:	00 
  80008d:	c7 44 24 04 63 27 80 	movl   $0x802763,0x4(%esp)
  800094:	00 
  800095:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80009c:	e8 26 0d 00 00       	call   800dc7 <write>
		write(1, argv[i], strlen(argv[i]));
  8000a1:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000a4:	89 04 24             	mov    %eax,(%esp)
  8000a7:	e8 b4 00 00 00       	call   800160 <strlen>
  8000ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000b0:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000be:	e8 04 0d 00 00       	call   800dc7 <write>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  8000c3:	83 c3 01             	add    $0x1,%ebx
  8000c6:	39 df                	cmp    %ebx,%edi
  8000c8:	7f b6                	jg     800080 <umain+0x4d>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  8000ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000ce:	75 1c                	jne    8000ec <umain+0xb9>
		write(1, "\n", 1);
  8000d0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000d7:	00 
  8000d8:	c7 44 24 04 b0 28 80 	movl   $0x8028b0,0x4(%esp)
  8000df:	00 
  8000e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000e7:	e8 db 0c 00 00       	call   800dc7 <write>
}
  8000ec:	83 c4 1c             	add    $0x1c,%esp
  8000ef:	5b                   	pop    %ebx
  8000f0:	5e                   	pop    %esi
  8000f1:	5f                   	pop    %edi
  8000f2:	5d                   	pop    %ebp
  8000f3:	c3                   	ret    

008000f4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 10             	sub    $0x10,%esp
  8000fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ff:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800102:	e8 6e 04 00 00       	call   800575 <sys_getenvid>
  800107:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010c:	89 c2                	mov    %eax,%edx
  80010e:	c1 e2 07             	shl    $0x7,%edx
  800111:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800118:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011d:	85 db                	test   %ebx,%ebx
  80011f:	7e 07                	jle    800128 <libmain+0x34>
		binaryname = argv[0];
  800121:	8b 06                	mov    (%esi),%eax
  800123:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800128:	89 74 24 04          	mov    %esi,0x4(%esp)
  80012c:	89 1c 24             	mov    %ebx,(%esp)
  80012f:	e8 ff fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800134:	e8 07 00 00 00       	call   800140 <exit>
}
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	5b                   	pop    %ebx
  80013d:	5e                   	pop    %esi
  80013e:	5d                   	pop    %ebp
  80013f:	c3                   	ret    

00800140 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800146:	e8 6f 0a 00 00       	call   800bba <close_all>
	sys_env_destroy(0);
  80014b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800152:	e8 cc 03 00 00       	call   800523 <sys_env_destroy>
}
  800157:	c9                   	leave  
  800158:	c3                   	ret    
  800159:	66 90                	xchg   %ax,%ax
  80015b:	66 90                	xchg   %ax,%ax
  80015d:	66 90                	xchg   %ax,%ax
  80015f:	90                   	nop

00800160 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800166:	b8 00 00 00 00       	mov    $0x0,%eax
  80016b:	eb 03                	jmp    800170 <strlen+0x10>
		n++;
  80016d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800170:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800174:	75 f7                	jne    80016d <strlen+0xd>
		n++;
	return n;
}
  800176:	5d                   	pop    %ebp
  800177:	c3                   	ret    

00800178 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800181:	b8 00 00 00 00       	mov    $0x0,%eax
  800186:	eb 03                	jmp    80018b <strnlen+0x13>
		n++;
  800188:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80018b:	39 d0                	cmp    %edx,%eax
  80018d:	74 06                	je     800195 <strnlen+0x1d>
  80018f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800193:	75 f3                	jne    800188 <strnlen+0x10>
		n++;
	return n;
}
  800195:	5d                   	pop    %ebp
  800196:	c3                   	ret    

00800197 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	53                   	push   %ebx
  80019b:	8b 45 08             	mov    0x8(%ebp),%eax
  80019e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8001a1:	89 c2                	mov    %eax,%edx
  8001a3:	83 c2 01             	add    $0x1,%edx
  8001a6:	83 c1 01             	add    $0x1,%ecx
  8001a9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8001ad:	88 5a ff             	mov    %bl,-0x1(%edx)
  8001b0:	84 db                	test   %bl,%bl
  8001b2:	75 ef                	jne    8001a3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8001b4:	5b                   	pop    %ebx
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	53                   	push   %ebx
  8001bb:	83 ec 08             	sub    $0x8,%esp
  8001be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001c1:	89 1c 24             	mov    %ebx,(%esp)
  8001c4:	e8 97 ff ff ff       	call   800160 <strlen>
	strcpy(dst + len, src);
  8001c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8001d0:	01 d8                	add    %ebx,%eax
  8001d2:	89 04 24             	mov    %eax,(%esp)
  8001d5:	e8 bd ff ff ff       	call   800197 <strcpy>
	return dst;
}
  8001da:	89 d8                	mov    %ebx,%eax
  8001dc:	83 c4 08             	add    $0x8,%esp
  8001df:	5b                   	pop    %ebx
  8001e0:	5d                   	pop    %ebp
  8001e1:	c3                   	ret    

008001e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	56                   	push   %esi
  8001e6:	53                   	push   %ebx
  8001e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8001ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ed:	89 f3                	mov    %esi,%ebx
  8001ef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001f2:	89 f2                	mov    %esi,%edx
  8001f4:	eb 0f                	jmp    800205 <strncpy+0x23>
		*dst++ = *src;
  8001f6:	83 c2 01             	add    $0x1,%edx
  8001f9:	0f b6 01             	movzbl (%ecx),%eax
  8001fc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8001ff:	80 39 01             	cmpb   $0x1,(%ecx)
  800202:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800205:	39 da                	cmp    %ebx,%edx
  800207:	75 ed                	jne    8001f6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800209:	89 f0                	mov    %esi,%eax
  80020b:	5b                   	pop    %ebx
  80020c:	5e                   	pop    %esi
  80020d:	5d                   	pop    %ebp
  80020e:	c3                   	ret    

0080020f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	56                   	push   %esi
  800213:	53                   	push   %ebx
  800214:	8b 75 08             	mov    0x8(%ebp),%esi
  800217:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80021d:	89 f0                	mov    %esi,%eax
  80021f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800223:	85 c9                	test   %ecx,%ecx
  800225:	75 0b                	jne    800232 <strlcpy+0x23>
  800227:	eb 1d                	jmp    800246 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800229:	83 c0 01             	add    $0x1,%eax
  80022c:	83 c2 01             	add    $0x1,%edx
  80022f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800232:	39 d8                	cmp    %ebx,%eax
  800234:	74 0b                	je     800241 <strlcpy+0x32>
  800236:	0f b6 0a             	movzbl (%edx),%ecx
  800239:	84 c9                	test   %cl,%cl
  80023b:	75 ec                	jne    800229 <strlcpy+0x1a>
  80023d:	89 c2                	mov    %eax,%edx
  80023f:	eb 02                	jmp    800243 <strlcpy+0x34>
  800241:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800243:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800246:	29 f0                	sub    %esi,%eax
}
  800248:	5b                   	pop    %ebx
  800249:	5e                   	pop    %esi
  80024a:	5d                   	pop    %ebp
  80024b:	c3                   	ret    

0080024c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80024c:	55                   	push   %ebp
  80024d:	89 e5                	mov    %esp,%ebp
  80024f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800252:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800255:	eb 06                	jmp    80025d <strcmp+0x11>
		p++, q++;
  800257:	83 c1 01             	add    $0x1,%ecx
  80025a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80025d:	0f b6 01             	movzbl (%ecx),%eax
  800260:	84 c0                	test   %al,%al
  800262:	74 04                	je     800268 <strcmp+0x1c>
  800264:	3a 02                	cmp    (%edx),%al
  800266:	74 ef                	je     800257 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800268:	0f b6 c0             	movzbl %al,%eax
  80026b:	0f b6 12             	movzbl (%edx),%edx
  80026e:	29 d0                	sub    %edx,%eax
}
  800270:	5d                   	pop    %ebp
  800271:	c3                   	ret    

00800272 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	53                   	push   %ebx
  800276:	8b 45 08             	mov    0x8(%ebp),%eax
  800279:	8b 55 0c             	mov    0xc(%ebp),%edx
  80027c:	89 c3                	mov    %eax,%ebx
  80027e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800281:	eb 06                	jmp    800289 <strncmp+0x17>
		n--, p++, q++;
  800283:	83 c0 01             	add    $0x1,%eax
  800286:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800289:	39 d8                	cmp    %ebx,%eax
  80028b:	74 15                	je     8002a2 <strncmp+0x30>
  80028d:	0f b6 08             	movzbl (%eax),%ecx
  800290:	84 c9                	test   %cl,%cl
  800292:	74 04                	je     800298 <strncmp+0x26>
  800294:	3a 0a                	cmp    (%edx),%cl
  800296:	74 eb                	je     800283 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800298:	0f b6 00             	movzbl (%eax),%eax
  80029b:	0f b6 12             	movzbl (%edx),%edx
  80029e:	29 d0                	sub    %edx,%eax
  8002a0:	eb 05                	jmp    8002a7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8002a2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8002a7:	5b                   	pop    %ebx
  8002a8:	5d                   	pop    %ebp
  8002a9:	c3                   	ret    

008002aa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002b4:	eb 07                	jmp    8002bd <strchr+0x13>
		if (*s == c)
  8002b6:	38 ca                	cmp    %cl,%dl
  8002b8:	74 0f                	je     8002c9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8002ba:	83 c0 01             	add    $0x1,%eax
  8002bd:	0f b6 10             	movzbl (%eax),%edx
  8002c0:	84 d2                	test   %dl,%dl
  8002c2:	75 f2                	jne    8002b6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8002c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    

008002cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002cb:	55                   	push   %ebp
  8002cc:	89 e5                	mov    %esp,%ebp
  8002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002d5:	eb 07                	jmp    8002de <strfind+0x13>
		if (*s == c)
  8002d7:	38 ca                	cmp    %cl,%dl
  8002d9:	74 0a                	je     8002e5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8002db:	83 c0 01             	add    $0x1,%eax
  8002de:	0f b6 10             	movzbl (%eax),%edx
  8002e1:	84 d2                	test   %dl,%dl
  8002e3:	75 f2                	jne    8002d7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8002e5:	5d                   	pop    %ebp
  8002e6:	c3                   	ret    

008002e7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	57                   	push   %edi
  8002eb:	56                   	push   %esi
  8002ec:	53                   	push   %ebx
  8002ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8002f3:	85 c9                	test   %ecx,%ecx
  8002f5:	74 36                	je     80032d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8002f7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8002fd:	75 28                	jne    800327 <memset+0x40>
  8002ff:	f6 c1 03             	test   $0x3,%cl
  800302:	75 23                	jne    800327 <memset+0x40>
		c &= 0xFF;
  800304:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800308:	89 d3                	mov    %edx,%ebx
  80030a:	c1 e3 08             	shl    $0x8,%ebx
  80030d:	89 d6                	mov    %edx,%esi
  80030f:	c1 e6 18             	shl    $0x18,%esi
  800312:	89 d0                	mov    %edx,%eax
  800314:	c1 e0 10             	shl    $0x10,%eax
  800317:	09 f0                	or     %esi,%eax
  800319:	09 c2                	or     %eax,%edx
  80031b:	89 d0                	mov    %edx,%eax
  80031d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80031f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800322:	fc                   	cld    
  800323:	f3 ab                	rep stos %eax,%es:(%edi)
  800325:	eb 06                	jmp    80032d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032a:	fc                   	cld    
  80032b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80032d:	89 f8                	mov    %edi,%eax
  80032f:	5b                   	pop    %ebx
  800330:	5e                   	pop    %esi
  800331:	5f                   	pop    %edi
  800332:	5d                   	pop    %ebp
  800333:	c3                   	ret    

00800334 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800334:	55                   	push   %ebp
  800335:	89 e5                	mov    %esp,%ebp
  800337:	57                   	push   %edi
  800338:	56                   	push   %esi
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80033f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800342:	39 c6                	cmp    %eax,%esi
  800344:	73 35                	jae    80037b <memmove+0x47>
  800346:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800349:	39 d0                	cmp    %edx,%eax
  80034b:	73 2e                	jae    80037b <memmove+0x47>
		s += n;
		d += n;
  80034d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800350:	89 d6                	mov    %edx,%esi
  800352:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800354:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80035a:	75 13                	jne    80036f <memmove+0x3b>
  80035c:	f6 c1 03             	test   $0x3,%cl
  80035f:	75 0e                	jne    80036f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800361:	83 ef 04             	sub    $0x4,%edi
  800364:	8d 72 fc             	lea    -0x4(%edx),%esi
  800367:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80036a:	fd                   	std    
  80036b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80036d:	eb 09                	jmp    800378 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80036f:	83 ef 01             	sub    $0x1,%edi
  800372:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800375:	fd                   	std    
  800376:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800378:	fc                   	cld    
  800379:	eb 1d                	jmp    800398 <memmove+0x64>
  80037b:	89 f2                	mov    %esi,%edx
  80037d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80037f:	f6 c2 03             	test   $0x3,%dl
  800382:	75 0f                	jne    800393 <memmove+0x5f>
  800384:	f6 c1 03             	test   $0x3,%cl
  800387:	75 0a                	jne    800393 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800389:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80038c:	89 c7                	mov    %eax,%edi
  80038e:	fc                   	cld    
  80038f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800391:	eb 05                	jmp    800398 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800393:	89 c7                	mov    %eax,%edi
  800395:	fc                   	cld    
  800396:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800398:	5e                   	pop    %esi
  800399:	5f                   	pop    %edi
  80039a:	5d                   	pop    %ebp
  80039b:	c3                   	ret    

0080039c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8003a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	89 04 24             	mov    %eax,(%esp)
  8003b6:	e8 79 ff ff ff       	call   800334 <memmove>
}
  8003bb:	c9                   	leave  
  8003bc:	c3                   	ret    

008003bd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	56                   	push   %esi
  8003c1:	53                   	push   %ebx
  8003c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003c8:	89 d6                	mov    %edx,%esi
  8003ca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8003cd:	eb 1a                	jmp    8003e9 <memcmp+0x2c>
		if (*s1 != *s2)
  8003cf:	0f b6 02             	movzbl (%edx),%eax
  8003d2:	0f b6 19             	movzbl (%ecx),%ebx
  8003d5:	38 d8                	cmp    %bl,%al
  8003d7:	74 0a                	je     8003e3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8003d9:	0f b6 c0             	movzbl %al,%eax
  8003dc:	0f b6 db             	movzbl %bl,%ebx
  8003df:	29 d8                	sub    %ebx,%eax
  8003e1:	eb 0f                	jmp    8003f2 <memcmp+0x35>
		s1++, s2++;
  8003e3:	83 c2 01             	add    $0x1,%edx
  8003e6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8003e9:	39 f2                	cmp    %esi,%edx
  8003eb:	75 e2                	jne    8003cf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8003ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003f2:	5b                   	pop    %ebx
  8003f3:	5e                   	pop    %esi
  8003f4:	5d                   	pop    %ebp
  8003f5:	c3                   	ret    

008003f6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8003f6:	55                   	push   %ebp
  8003f7:	89 e5                	mov    %esp,%ebp
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8003ff:	89 c2                	mov    %eax,%edx
  800401:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800404:	eb 07                	jmp    80040d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800406:	38 08                	cmp    %cl,(%eax)
  800408:	74 07                	je     800411 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80040a:	83 c0 01             	add    $0x1,%eax
  80040d:	39 d0                	cmp    %edx,%eax
  80040f:	72 f5                	jb     800406 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800411:	5d                   	pop    %ebp
  800412:	c3                   	ret    

00800413 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800413:	55                   	push   %ebp
  800414:	89 e5                	mov    %esp,%ebp
  800416:	57                   	push   %edi
  800417:	56                   	push   %esi
  800418:	53                   	push   %ebx
  800419:	8b 55 08             	mov    0x8(%ebp),%edx
  80041c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80041f:	eb 03                	jmp    800424 <strtol+0x11>
		s++;
  800421:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800424:	0f b6 0a             	movzbl (%edx),%ecx
  800427:	80 f9 09             	cmp    $0x9,%cl
  80042a:	74 f5                	je     800421 <strtol+0xe>
  80042c:	80 f9 20             	cmp    $0x20,%cl
  80042f:	74 f0                	je     800421 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800431:	80 f9 2b             	cmp    $0x2b,%cl
  800434:	75 0a                	jne    800440 <strtol+0x2d>
		s++;
  800436:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800439:	bf 00 00 00 00       	mov    $0x0,%edi
  80043e:	eb 11                	jmp    800451 <strtol+0x3e>
  800440:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800445:	80 f9 2d             	cmp    $0x2d,%cl
  800448:	75 07                	jne    800451 <strtol+0x3e>
		s++, neg = 1;
  80044a:	8d 52 01             	lea    0x1(%edx),%edx
  80044d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800451:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800456:	75 15                	jne    80046d <strtol+0x5a>
  800458:	80 3a 30             	cmpb   $0x30,(%edx)
  80045b:	75 10                	jne    80046d <strtol+0x5a>
  80045d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800461:	75 0a                	jne    80046d <strtol+0x5a>
		s += 2, base = 16;
  800463:	83 c2 02             	add    $0x2,%edx
  800466:	b8 10 00 00 00       	mov    $0x10,%eax
  80046b:	eb 10                	jmp    80047d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80046d:	85 c0                	test   %eax,%eax
  80046f:	75 0c                	jne    80047d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800471:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800473:	80 3a 30             	cmpb   $0x30,(%edx)
  800476:	75 05                	jne    80047d <strtol+0x6a>
		s++, base = 8;
  800478:	83 c2 01             	add    $0x1,%edx
  80047b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80047d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800482:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800485:	0f b6 0a             	movzbl (%edx),%ecx
  800488:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80048b:	89 f0                	mov    %esi,%eax
  80048d:	3c 09                	cmp    $0x9,%al
  80048f:	77 08                	ja     800499 <strtol+0x86>
			dig = *s - '0';
  800491:	0f be c9             	movsbl %cl,%ecx
  800494:	83 e9 30             	sub    $0x30,%ecx
  800497:	eb 20                	jmp    8004b9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800499:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80049c:	89 f0                	mov    %esi,%eax
  80049e:	3c 19                	cmp    $0x19,%al
  8004a0:	77 08                	ja     8004aa <strtol+0x97>
			dig = *s - 'a' + 10;
  8004a2:	0f be c9             	movsbl %cl,%ecx
  8004a5:	83 e9 57             	sub    $0x57,%ecx
  8004a8:	eb 0f                	jmp    8004b9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8004aa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8004ad:	89 f0                	mov    %esi,%eax
  8004af:	3c 19                	cmp    $0x19,%al
  8004b1:	77 16                	ja     8004c9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  8004b3:	0f be c9             	movsbl %cl,%ecx
  8004b6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8004b9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8004bc:	7d 0f                	jge    8004cd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  8004be:	83 c2 01             	add    $0x1,%edx
  8004c1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8004c5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8004c7:	eb bc                	jmp    800485 <strtol+0x72>
  8004c9:	89 d8                	mov    %ebx,%eax
  8004cb:	eb 02                	jmp    8004cf <strtol+0xbc>
  8004cd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8004cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004d3:	74 05                	je     8004da <strtol+0xc7>
		*endptr = (char *) s;
  8004d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004d8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8004da:	f7 d8                	neg    %eax
  8004dc:	85 ff                	test   %edi,%edi
  8004de:	0f 44 c3             	cmove  %ebx,%eax
}
  8004e1:	5b                   	pop    %ebx
  8004e2:	5e                   	pop    %esi
  8004e3:	5f                   	pop    %edi
  8004e4:	5d                   	pop    %ebp
  8004e5:	c3                   	ret    

008004e6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8004e6:	55                   	push   %ebp
  8004e7:	89 e5                	mov    %esp,%ebp
  8004e9:	57                   	push   %edi
  8004ea:	56                   	push   %esi
  8004eb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f7:	89 c3                	mov    %eax,%ebx
  8004f9:	89 c7                	mov    %eax,%edi
  8004fb:	89 c6                	mov    %eax,%esi
  8004fd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8004ff:	5b                   	pop    %ebx
  800500:	5e                   	pop    %esi
  800501:	5f                   	pop    %edi
  800502:	5d                   	pop    %ebp
  800503:	c3                   	ret    

00800504 <sys_cgetc>:

int
sys_cgetc(void)
{
  800504:	55                   	push   %ebp
  800505:	89 e5                	mov    %esp,%ebp
  800507:	57                   	push   %edi
  800508:	56                   	push   %esi
  800509:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80050a:	ba 00 00 00 00       	mov    $0x0,%edx
  80050f:	b8 01 00 00 00       	mov    $0x1,%eax
  800514:	89 d1                	mov    %edx,%ecx
  800516:	89 d3                	mov    %edx,%ebx
  800518:	89 d7                	mov    %edx,%edi
  80051a:	89 d6                	mov    %edx,%esi
  80051c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80051e:	5b                   	pop    %ebx
  80051f:	5e                   	pop    %esi
  800520:	5f                   	pop    %edi
  800521:	5d                   	pop    %ebp
  800522:	c3                   	ret    

00800523 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	57                   	push   %edi
  800527:	56                   	push   %esi
  800528:	53                   	push   %ebx
  800529:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80052c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800531:	b8 03 00 00 00       	mov    $0x3,%eax
  800536:	8b 55 08             	mov    0x8(%ebp),%edx
  800539:	89 cb                	mov    %ecx,%ebx
  80053b:	89 cf                	mov    %ecx,%edi
  80053d:	89 ce                	mov    %ecx,%esi
  80053f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800541:	85 c0                	test   %eax,%eax
  800543:	7e 28                	jle    80056d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800545:	89 44 24 10          	mov    %eax,0x10(%esp)
  800549:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800550:	00 
  800551:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  800558:	00 
  800559:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800560:	00 
  800561:	c7 04 24 8c 27 80 00 	movl   $0x80278c,(%esp)
  800568:	e8 29 17 00 00       	call   801c96 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80056d:	83 c4 2c             	add    $0x2c,%esp
  800570:	5b                   	pop    %ebx
  800571:	5e                   	pop    %esi
  800572:	5f                   	pop    %edi
  800573:	5d                   	pop    %ebp
  800574:	c3                   	ret    

00800575 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	57                   	push   %edi
  800579:	56                   	push   %esi
  80057a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80057b:	ba 00 00 00 00       	mov    $0x0,%edx
  800580:	b8 02 00 00 00       	mov    $0x2,%eax
  800585:	89 d1                	mov    %edx,%ecx
  800587:	89 d3                	mov    %edx,%ebx
  800589:	89 d7                	mov    %edx,%edi
  80058b:	89 d6                	mov    %edx,%esi
  80058d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80058f:	5b                   	pop    %ebx
  800590:	5e                   	pop    %esi
  800591:	5f                   	pop    %edi
  800592:	5d                   	pop    %ebp
  800593:	c3                   	ret    

00800594 <sys_yield>:

void
sys_yield(void)
{
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	57                   	push   %edi
  800598:	56                   	push   %esi
  800599:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80059a:	ba 00 00 00 00       	mov    $0x0,%edx
  80059f:	b8 0b 00 00 00       	mov    $0xb,%eax
  8005a4:	89 d1                	mov    %edx,%ecx
  8005a6:	89 d3                	mov    %edx,%ebx
  8005a8:	89 d7                	mov    %edx,%edi
  8005aa:	89 d6                	mov    %edx,%esi
  8005ac:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8005ae:	5b                   	pop    %ebx
  8005af:	5e                   	pop    %esi
  8005b0:	5f                   	pop    %edi
  8005b1:	5d                   	pop    %ebp
  8005b2:	c3                   	ret    

008005b3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8005b3:	55                   	push   %ebp
  8005b4:	89 e5                	mov    %esp,%ebp
  8005b6:	57                   	push   %edi
  8005b7:	56                   	push   %esi
  8005b8:	53                   	push   %ebx
  8005b9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8005bc:	be 00 00 00 00       	mov    $0x0,%esi
  8005c1:	b8 04 00 00 00       	mov    $0x4,%eax
  8005c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8005cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005cf:	89 f7                	mov    %esi,%edi
  8005d1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8005d3:	85 c0                	test   %eax,%eax
  8005d5:	7e 28                	jle    8005ff <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8005d7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8005db:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8005e2:	00 
  8005e3:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  8005ea:	00 
  8005eb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8005f2:	00 
  8005f3:	c7 04 24 8c 27 80 00 	movl   $0x80278c,(%esp)
  8005fa:	e8 97 16 00 00       	call   801c96 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8005ff:	83 c4 2c             	add    $0x2c,%esp
  800602:	5b                   	pop    %ebx
  800603:	5e                   	pop    %esi
  800604:	5f                   	pop    %edi
  800605:	5d                   	pop    %ebp
  800606:	c3                   	ret    

00800607 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800607:	55                   	push   %ebp
  800608:	89 e5                	mov    %esp,%ebp
  80060a:	57                   	push   %edi
  80060b:	56                   	push   %esi
  80060c:	53                   	push   %ebx
  80060d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800610:	b8 05 00 00 00       	mov    $0x5,%eax
  800615:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800618:	8b 55 08             	mov    0x8(%ebp),%edx
  80061b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80061e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800621:	8b 75 18             	mov    0x18(%ebp),%esi
  800624:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800626:	85 c0                	test   %eax,%eax
  800628:	7e 28                	jle    800652 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80062a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80062e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800635:	00 
  800636:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  80063d:	00 
  80063e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800645:	00 
  800646:	c7 04 24 8c 27 80 00 	movl   $0x80278c,(%esp)
  80064d:	e8 44 16 00 00       	call   801c96 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800652:	83 c4 2c             	add    $0x2c,%esp
  800655:	5b                   	pop    %ebx
  800656:	5e                   	pop    %esi
  800657:	5f                   	pop    %edi
  800658:	5d                   	pop    %ebp
  800659:	c3                   	ret    

0080065a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80065a:	55                   	push   %ebp
  80065b:	89 e5                	mov    %esp,%ebp
  80065d:	57                   	push   %edi
  80065e:	56                   	push   %esi
  80065f:	53                   	push   %ebx
  800660:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800663:	bb 00 00 00 00       	mov    $0x0,%ebx
  800668:	b8 06 00 00 00       	mov    $0x6,%eax
  80066d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800670:	8b 55 08             	mov    0x8(%ebp),%edx
  800673:	89 df                	mov    %ebx,%edi
  800675:	89 de                	mov    %ebx,%esi
  800677:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800679:	85 c0                	test   %eax,%eax
  80067b:	7e 28                	jle    8006a5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80067d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800681:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800688:	00 
  800689:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  800690:	00 
  800691:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800698:	00 
  800699:	c7 04 24 8c 27 80 00 	movl   $0x80278c,(%esp)
  8006a0:	e8 f1 15 00 00       	call   801c96 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8006a5:	83 c4 2c             	add    $0x2c,%esp
  8006a8:	5b                   	pop    %ebx
  8006a9:	5e                   	pop    %esi
  8006aa:	5f                   	pop    %edi
  8006ab:	5d                   	pop    %ebp
  8006ac:	c3                   	ret    

008006ad <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8006ad:	55                   	push   %ebp
  8006ae:	89 e5                	mov    %esp,%ebp
  8006b0:	57                   	push   %edi
  8006b1:	56                   	push   %esi
  8006b2:	53                   	push   %ebx
  8006b3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8006b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006bb:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8006c6:	89 df                	mov    %ebx,%edi
  8006c8:	89 de                	mov    %ebx,%esi
  8006ca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8006cc:	85 c0                	test   %eax,%eax
  8006ce:	7e 28                	jle    8006f8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8006d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006d4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8006db:	00 
  8006dc:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  8006e3:	00 
  8006e4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8006eb:	00 
  8006ec:	c7 04 24 8c 27 80 00 	movl   $0x80278c,(%esp)
  8006f3:	e8 9e 15 00 00       	call   801c96 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8006f8:	83 c4 2c             	add    $0x2c,%esp
  8006fb:	5b                   	pop    %ebx
  8006fc:	5e                   	pop    %esi
  8006fd:	5f                   	pop    %edi
  8006fe:	5d                   	pop    %ebp
  8006ff:	c3                   	ret    

00800700 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
  800703:	57                   	push   %edi
  800704:	56                   	push   %esi
  800705:	53                   	push   %ebx
  800706:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800709:	bb 00 00 00 00       	mov    $0x0,%ebx
  80070e:	b8 09 00 00 00       	mov    $0x9,%eax
  800713:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800716:	8b 55 08             	mov    0x8(%ebp),%edx
  800719:	89 df                	mov    %ebx,%edi
  80071b:	89 de                	mov    %ebx,%esi
  80071d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80071f:	85 c0                	test   %eax,%eax
  800721:	7e 28                	jle    80074b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800723:	89 44 24 10          	mov    %eax,0x10(%esp)
  800727:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80072e:	00 
  80072f:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  800736:	00 
  800737:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80073e:	00 
  80073f:	c7 04 24 8c 27 80 00 	movl   $0x80278c,(%esp)
  800746:	e8 4b 15 00 00       	call   801c96 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80074b:	83 c4 2c             	add    $0x2c,%esp
  80074e:	5b                   	pop    %ebx
  80074f:	5e                   	pop    %esi
  800750:	5f                   	pop    %edi
  800751:	5d                   	pop    %ebp
  800752:	c3                   	ret    

00800753 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	57                   	push   %edi
  800757:	56                   	push   %esi
  800758:	53                   	push   %ebx
  800759:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80075c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800761:	b8 0a 00 00 00       	mov    $0xa,%eax
  800766:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800769:	8b 55 08             	mov    0x8(%ebp),%edx
  80076c:	89 df                	mov    %ebx,%edi
  80076e:	89 de                	mov    %ebx,%esi
  800770:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800772:	85 c0                	test   %eax,%eax
  800774:	7e 28                	jle    80079e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800776:	89 44 24 10          	mov    %eax,0x10(%esp)
  80077a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800781:	00 
  800782:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  800789:	00 
  80078a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800791:	00 
  800792:	c7 04 24 8c 27 80 00 	movl   $0x80278c,(%esp)
  800799:	e8 f8 14 00 00       	call   801c96 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80079e:	83 c4 2c             	add    $0x2c,%esp
  8007a1:	5b                   	pop    %ebx
  8007a2:	5e                   	pop    %esi
  8007a3:	5f                   	pop    %edi
  8007a4:	5d                   	pop    %ebp
  8007a5:	c3                   	ret    

008007a6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	57                   	push   %edi
  8007aa:	56                   	push   %esi
  8007ab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8007ac:	be 00 00 00 00       	mov    $0x0,%esi
  8007b1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8007b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8007bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007bf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8007c2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8007c4:	5b                   	pop    %ebx
  8007c5:	5e                   	pop    %esi
  8007c6:	5f                   	pop    %edi
  8007c7:	5d                   	pop    %ebp
  8007c8:	c3                   	ret    

008007c9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	57                   	push   %edi
  8007cd:	56                   	push   %esi
  8007ce:	53                   	push   %ebx
  8007cf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8007d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8007dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8007df:	89 cb                	mov    %ecx,%ebx
  8007e1:	89 cf                	mov    %ecx,%edi
  8007e3:	89 ce                	mov    %ecx,%esi
  8007e5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8007e7:	85 c0                	test   %eax,%eax
  8007e9:	7e 28                	jle    800813 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8007eb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8007ef:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8007f6:	00 
  8007f7:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  8007fe:	00 
  8007ff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800806:	00 
  800807:	c7 04 24 8c 27 80 00 	movl   $0x80278c,(%esp)
  80080e:	e8 83 14 00 00       	call   801c96 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800813:	83 c4 2c             	add    $0x2c,%esp
  800816:	5b                   	pop    %ebx
  800817:	5e                   	pop    %esi
  800818:	5f                   	pop    %edi
  800819:	5d                   	pop    %ebp
  80081a:	c3                   	ret    

0080081b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	57                   	push   %edi
  80081f:	56                   	push   %esi
  800820:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800821:	ba 00 00 00 00       	mov    $0x0,%edx
  800826:	b8 0e 00 00 00       	mov    $0xe,%eax
  80082b:	89 d1                	mov    %edx,%ecx
  80082d:	89 d3                	mov    %edx,%ebx
  80082f:	89 d7                	mov    %edx,%edi
  800831:	89 d6                	mov    %edx,%esi
  800833:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800835:	5b                   	pop    %ebx
  800836:	5e                   	pop    %esi
  800837:	5f                   	pop    %edi
  800838:	5d                   	pop    %ebp
  800839:	c3                   	ret    

0080083a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	57                   	push   %edi
  80083e:	56                   	push   %esi
  80083f:	53                   	push   %ebx
  800840:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800843:	bb 00 00 00 00       	mov    $0x0,%ebx
  800848:	b8 0f 00 00 00       	mov    $0xf,%eax
  80084d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800850:	8b 55 08             	mov    0x8(%ebp),%edx
  800853:	89 df                	mov    %ebx,%edi
  800855:	89 de                	mov    %ebx,%esi
  800857:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800859:	85 c0                	test   %eax,%eax
  80085b:	7e 28                	jle    800885 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80085d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800861:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800868:	00 
  800869:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  800870:	00 
  800871:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800878:	00 
  800879:	c7 04 24 8c 27 80 00 	movl   $0x80278c,(%esp)
  800880:	e8 11 14 00 00       	call   801c96 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800885:	83 c4 2c             	add    $0x2c,%esp
  800888:	5b                   	pop    %ebx
  800889:	5e                   	pop    %esi
  80088a:	5f                   	pop    %edi
  80088b:	5d                   	pop    %ebp
  80088c:	c3                   	ret    

0080088d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80088d:	55                   	push   %ebp
  80088e:	89 e5                	mov    %esp,%ebp
  800890:	57                   	push   %edi
  800891:	56                   	push   %esi
  800892:	53                   	push   %ebx
  800893:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800896:	bb 00 00 00 00       	mov    $0x0,%ebx
  80089b:	b8 10 00 00 00       	mov    $0x10,%eax
  8008a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8008a6:	89 df                	mov    %ebx,%edi
  8008a8:	89 de                	mov    %ebx,%esi
  8008aa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8008ac:	85 c0                	test   %eax,%eax
  8008ae:	7e 28                	jle    8008d8 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8008b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8008b4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8008bb:	00 
  8008bc:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  8008c3:	00 
  8008c4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8008cb:	00 
  8008cc:	c7 04 24 8c 27 80 00 	movl   $0x80278c,(%esp)
  8008d3:	e8 be 13 00 00       	call   801c96 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  8008d8:	83 c4 2c             	add    $0x2c,%esp
  8008db:	5b                   	pop    %ebx
  8008dc:	5e                   	pop    %esi
  8008dd:	5f                   	pop    %edi
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	57                   	push   %edi
  8008e4:	56                   	push   %esi
  8008e5:	53                   	push   %ebx
  8008e6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8008e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008ee:	b8 11 00 00 00       	mov    $0x11,%eax
  8008f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f9:	89 df                	mov    %ebx,%edi
  8008fb:	89 de                	mov    %ebx,%esi
  8008fd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8008ff:	85 c0                	test   %eax,%eax
  800901:	7e 28                	jle    80092b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800903:	89 44 24 10          	mov    %eax,0x10(%esp)
  800907:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  80090e:	00 
  80090f:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  800916:	00 
  800917:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80091e:	00 
  80091f:	c7 04 24 8c 27 80 00 	movl   $0x80278c,(%esp)
  800926:	e8 6b 13 00 00       	call   801c96 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80092b:	83 c4 2c             	add    $0x2c,%esp
  80092e:	5b                   	pop    %ebx
  80092f:	5e                   	pop    %esi
  800930:	5f                   	pop    %edi
  800931:	5d                   	pop    %ebp
  800932:	c3                   	ret    

00800933 <sys_sleep>:

int
sys_sleep(int channel)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	57                   	push   %edi
  800937:	56                   	push   %esi
  800938:	53                   	push   %ebx
  800939:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80093c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800941:	b8 12 00 00 00       	mov    $0x12,%eax
  800946:	8b 55 08             	mov    0x8(%ebp),%edx
  800949:	89 cb                	mov    %ecx,%ebx
  80094b:	89 cf                	mov    %ecx,%edi
  80094d:	89 ce                	mov    %ecx,%esi
  80094f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800951:	85 c0                	test   %eax,%eax
  800953:	7e 28                	jle    80097d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800955:	89 44 24 10          	mov    %eax,0x10(%esp)
  800959:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800960:	00 
  800961:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  800968:	00 
  800969:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800970:	00 
  800971:	c7 04 24 8c 27 80 00 	movl   $0x80278c,(%esp)
  800978:	e8 19 13 00 00       	call   801c96 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80097d:	83 c4 2c             	add    $0x2c,%esp
  800980:	5b                   	pop    %ebx
  800981:	5e                   	pop    %esi
  800982:	5f                   	pop    %edi
  800983:	5d                   	pop    %ebp
  800984:	c3                   	ret    

00800985 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	57                   	push   %edi
  800989:	56                   	push   %esi
  80098a:	53                   	push   %ebx
  80098b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80098e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800993:	b8 13 00 00 00       	mov    $0x13,%eax
  800998:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80099b:	8b 55 08             	mov    0x8(%ebp),%edx
  80099e:	89 df                	mov    %ebx,%edi
  8009a0:	89 de                	mov    %ebx,%esi
  8009a2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8009a4:	85 c0                	test   %eax,%eax
  8009a6:	7e 28                	jle    8009d0 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8009a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8009ac:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  8009b3:	00 
  8009b4:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  8009bb:	00 
  8009bc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8009c3:	00 
  8009c4:	c7 04 24 8c 27 80 00 	movl   $0x80278c,(%esp)
  8009cb:	e8 c6 12 00 00       	call   801c96 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  8009d0:	83 c4 2c             	add    $0x2c,%esp
  8009d3:	5b                   	pop    %ebx
  8009d4:	5e                   	pop    %esi
  8009d5:	5f                   	pop    %edi
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    
  8009d8:	66 90                	xchg   %ax,%ax
  8009da:	66 90                	xchg   %ax,%ax
  8009dc:	66 90                	xchg   %ax,%ax
  8009de:	66 90                	xchg   %ax,%ax

008009e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8009eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8009ee:	5d                   	pop    %ebp
  8009ef:	c3                   	ret    

008009f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8009fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a00:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800a05:	5d                   	pop    %ebp
  800a06:	c3                   	ret    

00800a07 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800a12:	89 c2                	mov    %eax,%edx
  800a14:	c1 ea 16             	shr    $0x16,%edx
  800a17:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800a1e:	f6 c2 01             	test   $0x1,%dl
  800a21:	74 11                	je     800a34 <fd_alloc+0x2d>
  800a23:	89 c2                	mov    %eax,%edx
  800a25:	c1 ea 0c             	shr    $0xc,%edx
  800a28:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800a2f:	f6 c2 01             	test   $0x1,%dl
  800a32:	75 09                	jne    800a3d <fd_alloc+0x36>
			*fd_store = fd;
  800a34:	89 01                	mov    %eax,(%ecx)
			return 0;
  800a36:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3b:	eb 17                	jmp    800a54 <fd_alloc+0x4d>
  800a3d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800a42:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800a47:	75 c9                	jne    800a12 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800a49:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800a4f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800a5c:	83 f8 1f             	cmp    $0x1f,%eax
  800a5f:	77 36                	ja     800a97 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800a61:	c1 e0 0c             	shl    $0xc,%eax
  800a64:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800a69:	89 c2                	mov    %eax,%edx
  800a6b:	c1 ea 16             	shr    $0x16,%edx
  800a6e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800a75:	f6 c2 01             	test   $0x1,%dl
  800a78:	74 24                	je     800a9e <fd_lookup+0x48>
  800a7a:	89 c2                	mov    %eax,%edx
  800a7c:	c1 ea 0c             	shr    $0xc,%edx
  800a7f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800a86:	f6 c2 01             	test   $0x1,%dl
  800a89:	74 1a                	je     800aa5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8e:	89 02                	mov    %eax,(%edx)
	return 0;
  800a90:	b8 00 00 00 00       	mov    $0x0,%eax
  800a95:	eb 13                	jmp    800aaa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800a97:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a9c:	eb 0c                	jmp    800aaa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800a9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aa3:	eb 05                	jmp    800aaa <fd_lookup+0x54>
  800aa5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	83 ec 18             	sub    $0x18,%esp
  800ab2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aba:	eb 13                	jmp    800acf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  800abc:	39 08                	cmp    %ecx,(%eax)
  800abe:	75 0c                	jne    800acc <dev_lookup+0x20>
			*dev = devtab[i];
  800ac0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac3:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aca:	eb 38                	jmp    800b04 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800acc:	83 c2 01             	add    $0x1,%edx
  800acf:	8b 04 95 18 28 80 00 	mov    0x802818(,%edx,4),%eax
  800ad6:	85 c0                	test   %eax,%eax
  800ad8:	75 e2                	jne    800abc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ada:	a1 08 40 80 00       	mov    0x804008,%eax
  800adf:	8b 40 48             	mov    0x48(%eax),%eax
  800ae2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ae6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aea:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  800af1:	e8 99 12 00 00       	call   801d8f <cprintf>
	*dev = 0;
  800af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800aff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800b04:	c9                   	leave  
  800b05:	c3                   	ret    

00800b06 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	56                   	push   %esi
  800b0a:	53                   	push   %ebx
  800b0b:	83 ec 20             	sub    $0x20,%esp
  800b0e:	8b 75 08             	mov    0x8(%ebp),%esi
  800b11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b17:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800b1b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800b21:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800b24:	89 04 24             	mov    %eax,(%esp)
  800b27:	e8 2a ff ff ff       	call   800a56 <fd_lookup>
  800b2c:	85 c0                	test   %eax,%eax
  800b2e:	78 05                	js     800b35 <fd_close+0x2f>
	    || fd != fd2)
  800b30:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800b33:	74 0c                	je     800b41 <fd_close+0x3b>
		return (must_exist ? r : 0);
  800b35:	84 db                	test   %bl,%bl
  800b37:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3c:	0f 44 c2             	cmove  %edx,%eax
  800b3f:	eb 3f                	jmp    800b80 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800b41:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b48:	8b 06                	mov    (%esi),%eax
  800b4a:	89 04 24             	mov    %eax,(%esp)
  800b4d:	e8 5a ff ff ff       	call   800aac <dev_lookup>
  800b52:	89 c3                	mov    %eax,%ebx
  800b54:	85 c0                	test   %eax,%eax
  800b56:	78 16                	js     800b6e <fd_close+0x68>
		if (dev->dev_close)
  800b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800b5e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800b63:	85 c0                	test   %eax,%eax
  800b65:	74 07                	je     800b6e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800b67:	89 34 24             	mov    %esi,(%esp)
  800b6a:	ff d0                	call   *%eax
  800b6c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800b6e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b79:	e8 dc fa ff ff       	call   80065a <sys_page_unmap>
	return r;
  800b7e:	89 d8                	mov    %ebx,%eax
}
  800b80:	83 c4 20             	add    $0x20,%esp
  800b83:	5b                   	pop    %ebx
  800b84:	5e                   	pop    %esi
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800b8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b90:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	89 04 24             	mov    %eax,(%esp)
  800b9a:	e8 b7 fe ff ff       	call   800a56 <fd_lookup>
  800b9f:	89 c2                	mov    %eax,%edx
  800ba1:	85 d2                	test   %edx,%edx
  800ba3:	78 13                	js     800bb8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800ba5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800bac:	00 
  800bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bb0:	89 04 24             	mov    %eax,(%esp)
  800bb3:	e8 4e ff ff ff       	call   800b06 <fd_close>
}
  800bb8:	c9                   	leave  
  800bb9:	c3                   	ret    

00800bba <close_all>:

void
close_all(void)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	53                   	push   %ebx
  800bbe:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800bc1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800bc6:	89 1c 24             	mov    %ebx,(%esp)
  800bc9:	e8 b9 ff ff ff       	call   800b87 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800bce:	83 c3 01             	add    $0x1,%ebx
  800bd1:	83 fb 20             	cmp    $0x20,%ebx
  800bd4:	75 f0                	jne    800bc6 <close_all+0xc>
		close(i);
}
  800bd6:	83 c4 14             	add    $0x14,%esp
  800bd9:	5b                   	pop    %ebx
  800bda:	5d                   	pop    %ebp
  800bdb:	c3                   	ret    

00800bdc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	57                   	push   %edi
  800be0:	56                   	push   %esi
  800be1:	53                   	push   %ebx
  800be2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800be5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	89 04 24             	mov    %eax,(%esp)
  800bf2:	e8 5f fe ff ff       	call   800a56 <fd_lookup>
  800bf7:	89 c2                	mov    %eax,%edx
  800bf9:	85 d2                	test   %edx,%edx
  800bfb:	0f 88 e1 00 00 00    	js     800ce2 <dup+0x106>
		return r;
	close(newfdnum);
  800c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c04:	89 04 24             	mov    %eax,(%esp)
  800c07:	e8 7b ff ff ff       	call   800b87 <close>

	newfd = INDEX2FD(newfdnum);
  800c0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c0f:	c1 e3 0c             	shl    $0xc,%ebx
  800c12:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800c18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c1b:	89 04 24             	mov    %eax,(%esp)
  800c1e:	e8 cd fd ff ff       	call   8009f0 <fd2data>
  800c23:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800c25:	89 1c 24             	mov    %ebx,(%esp)
  800c28:	e8 c3 fd ff ff       	call   8009f0 <fd2data>
  800c2d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800c2f:	89 f0                	mov    %esi,%eax
  800c31:	c1 e8 16             	shr    $0x16,%eax
  800c34:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800c3b:	a8 01                	test   $0x1,%al
  800c3d:	74 43                	je     800c82 <dup+0xa6>
  800c3f:	89 f0                	mov    %esi,%eax
  800c41:	c1 e8 0c             	shr    $0xc,%eax
  800c44:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800c4b:	f6 c2 01             	test   $0x1,%dl
  800c4e:	74 32                	je     800c82 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800c50:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800c57:	25 07 0e 00 00       	and    $0xe07,%eax
  800c5c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c60:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800c64:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800c6b:	00 
  800c6c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c77:	e8 8b f9 ff ff       	call   800607 <sys_page_map>
  800c7c:	89 c6                	mov    %eax,%esi
  800c7e:	85 c0                	test   %eax,%eax
  800c80:	78 3e                	js     800cc0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800c82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c85:	89 c2                	mov    %eax,%edx
  800c87:	c1 ea 0c             	shr    $0xc,%edx
  800c8a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800c91:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800c97:	89 54 24 10          	mov    %edx,0x10(%esp)
  800c9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800c9f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800ca6:	00 
  800ca7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800cb2:	e8 50 f9 ff ff       	call   800607 <sys_page_map>
  800cb7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  800cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800cbc:	85 f6                	test   %esi,%esi
  800cbe:	79 22                	jns    800ce2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800cc0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800cc4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ccb:	e8 8a f9 ff ff       	call   80065a <sys_page_unmap>
	sys_page_unmap(0, nva);
  800cd0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cd4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800cdb:	e8 7a f9 ff ff       	call   80065a <sys_page_unmap>
	return r;
  800ce0:	89 f0                	mov    %esi,%eax
}
  800ce2:	83 c4 3c             	add    $0x3c,%esp
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5f                   	pop    %edi
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	53                   	push   %ebx
  800cee:	83 ec 24             	sub    $0x24,%esp
  800cf1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cf4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cfb:	89 1c 24             	mov    %ebx,(%esp)
  800cfe:	e8 53 fd ff ff       	call   800a56 <fd_lookup>
  800d03:	89 c2                	mov    %eax,%edx
  800d05:	85 d2                	test   %edx,%edx
  800d07:	78 6d                	js     800d76 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d13:	8b 00                	mov    (%eax),%eax
  800d15:	89 04 24             	mov    %eax,(%esp)
  800d18:	e8 8f fd ff ff       	call   800aac <dev_lookup>
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	78 55                	js     800d76 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d24:	8b 50 08             	mov    0x8(%eax),%edx
  800d27:	83 e2 03             	and    $0x3,%edx
  800d2a:	83 fa 01             	cmp    $0x1,%edx
  800d2d:	75 23                	jne    800d52 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800d2f:	a1 08 40 80 00       	mov    0x804008,%eax
  800d34:	8b 40 48             	mov    0x48(%eax),%eax
  800d37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800d3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d3f:	c7 04 24 dd 27 80 00 	movl   $0x8027dd,(%esp)
  800d46:	e8 44 10 00 00       	call   801d8f <cprintf>
		return -E_INVAL;
  800d4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d50:	eb 24                	jmp    800d76 <read+0x8c>
	}
	if (!dev->dev_read)
  800d52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d55:	8b 52 08             	mov    0x8(%edx),%edx
  800d58:	85 d2                	test   %edx,%edx
  800d5a:	74 15                	je     800d71 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800d5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800d6a:	89 04 24             	mov    %eax,(%esp)
  800d6d:	ff d2                	call   *%edx
  800d6f:	eb 05                	jmp    800d76 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800d71:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800d76:	83 c4 24             	add    $0x24,%esp
  800d79:	5b                   	pop    %ebx
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	57                   	push   %edi
  800d80:	56                   	push   %esi
  800d81:	53                   	push   %ebx
  800d82:	83 ec 1c             	sub    $0x1c,%esp
  800d85:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d88:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800d8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d90:	eb 23                	jmp    800db5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800d92:	89 f0                	mov    %esi,%eax
  800d94:	29 d8                	sub    %ebx,%eax
  800d96:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d9a:	89 d8                	mov    %ebx,%eax
  800d9c:	03 45 0c             	add    0xc(%ebp),%eax
  800d9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800da3:	89 3c 24             	mov    %edi,(%esp)
  800da6:	e8 3f ff ff ff       	call   800cea <read>
		if (m < 0)
  800dab:	85 c0                	test   %eax,%eax
  800dad:	78 10                	js     800dbf <readn+0x43>
			return m;
		if (m == 0)
  800daf:	85 c0                	test   %eax,%eax
  800db1:	74 0a                	je     800dbd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800db3:	01 c3                	add    %eax,%ebx
  800db5:	39 f3                	cmp    %esi,%ebx
  800db7:	72 d9                	jb     800d92 <readn+0x16>
  800db9:	89 d8                	mov    %ebx,%eax
  800dbb:	eb 02                	jmp    800dbf <readn+0x43>
  800dbd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800dbf:	83 c4 1c             	add    $0x1c,%esp
  800dc2:	5b                   	pop    %ebx
  800dc3:	5e                   	pop    %esi
  800dc4:	5f                   	pop    %edi
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    

00800dc7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	53                   	push   %ebx
  800dcb:	83 ec 24             	sub    $0x24,%esp
  800dce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dd1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dd8:	89 1c 24             	mov    %ebx,(%esp)
  800ddb:	e8 76 fc ff ff       	call   800a56 <fd_lookup>
  800de0:	89 c2                	mov    %eax,%edx
  800de2:	85 d2                	test   %edx,%edx
  800de4:	78 68                	js     800e4e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800de6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800de9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df0:	8b 00                	mov    (%eax),%eax
  800df2:	89 04 24             	mov    %eax,(%esp)
  800df5:	e8 b2 fc ff ff       	call   800aac <dev_lookup>
  800dfa:	85 c0                	test   %eax,%eax
  800dfc:	78 50                	js     800e4e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e01:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800e05:	75 23                	jne    800e2a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800e07:	a1 08 40 80 00       	mov    0x804008,%eax
  800e0c:	8b 40 48             	mov    0x48(%eax),%eax
  800e0f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800e13:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e17:	c7 04 24 f9 27 80 00 	movl   $0x8027f9,(%esp)
  800e1e:	e8 6c 0f 00 00       	call   801d8f <cprintf>
		return -E_INVAL;
  800e23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e28:	eb 24                	jmp    800e4e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800e2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e2d:	8b 52 0c             	mov    0xc(%edx),%edx
  800e30:	85 d2                	test   %edx,%edx
  800e32:	74 15                	je     800e49 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800e34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800e37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800e42:	89 04 24             	mov    %eax,(%esp)
  800e45:	ff d2                	call   *%edx
  800e47:	eb 05                	jmp    800e4e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800e49:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  800e4e:	83 c4 24             	add    $0x24,%esp
  800e51:	5b                   	pop    %ebx
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    

00800e54 <seek>:

int
seek(int fdnum, off_t offset)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e5a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800e5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	89 04 24             	mov    %eax,(%esp)
  800e67:	e8 ea fb ff ff       	call   800a56 <fd_lookup>
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	78 0e                	js     800e7e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e76:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800e79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	53                   	push   %ebx
  800e84:	83 ec 24             	sub    $0x24,%esp
  800e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e91:	89 1c 24             	mov    %ebx,(%esp)
  800e94:	e8 bd fb ff ff       	call   800a56 <fd_lookup>
  800e99:	89 c2                	mov    %eax,%edx
  800e9b:	85 d2                	test   %edx,%edx
  800e9d:	78 61                	js     800f00 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ea2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea9:	8b 00                	mov    (%eax),%eax
  800eab:	89 04 24             	mov    %eax,(%esp)
  800eae:	e8 f9 fb ff ff       	call   800aac <dev_lookup>
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	78 49                	js     800f00 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800ebe:	75 23                	jne    800ee3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800ec0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800ec5:	8b 40 48             	mov    0x48(%eax),%eax
  800ec8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800ecc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ed0:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  800ed7:	e8 b3 0e 00 00       	call   801d8f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800edc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ee1:	eb 1d                	jmp    800f00 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  800ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee6:	8b 52 18             	mov    0x18(%edx),%edx
  800ee9:	85 d2                	test   %edx,%edx
  800eeb:	74 0e                	je     800efb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ef4:	89 04 24             	mov    %eax,(%esp)
  800ef7:	ff d2                	call   *%edx
  800ef9:	eb 05                	jmp    800f00 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800efb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800f00:	83 c4 24             	add    $0x24,%esp
  800f03:	5b                   	pop    %ebx
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    

00800f06 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	53                   	push   %ebx
  800f0a:	83 ec 24             	sub    $0x24,%esp
  800f0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f10:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800f13:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	89 04 24             	mov    %eax,(%esp)
  800f1d:	e8 34 fb ff ff       	call   800a56 <fd_lookup>
  800f22:	89 c2                	mov    %eax,%edx
  800f24:	85 d2                	test   %edx,%edx
  800f26:	78 52                	js     800f7a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f32:	8b 00                	mov    (%eax),%eax
  800f34:	89 04 24             	mov    %eax,(%esp)
  800f37:	e8 70 fb ff ff       	call   800aac <dev_lookup>
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	78 3a                	js     800f7a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f43:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800f47:	74 2c                	je     800f75 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800f49:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800f4c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800f53:	00 00 00 
	stat->st_isdir = 0;
  800f56:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800f5d:	00 00 00 
	stat->st_dev = dev;
  800f60:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800f66:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800f6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f6d:	89 14 24             	mov    %edx,(%esp)
  800f70:	ff 50 14             	call   *0x14(%eax)
  800f73:	eb 05                	jmp    800f7a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800f75:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800f7a:	83 c4 24             	add    $0x24,%esp
  800f7d:	5b                   	pop    %ebx
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    

00800f80 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	56                   	push   %esi
  800f84:	53                   	push   %ebx
  800f85:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800f8f:	00 
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 04 24             	mov    %eax,(%esp)
  800f96:	e8 1b 02 00 00       	call   8011b6 <open>
  800f9b:	89 c3                	mov    %eax,%ebx
  800f9d:	85 db                	test   %ebx,%ebx
  800f9f:	78 1b                	js     800fbc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fa8:	89 1c 24             	mov    %ebx,(%esp)
  800fab:	e8 56 ff ff ff       	call   800f06 <fstat>
  800fb0:	89 c6                	mov    %eax,%esi
	close(fd);
  800fb2:	89 1c 24             	mov    %ebx,(%esp)
  800fb5:	e8 cd fb ff ff       	call   800b87 <close>
	return r;
  800fba:	89 f0                	mov    %esi,%eax
}
  800fbc:	83 c4 10             	add    $0x10,%esp
  800fbf:	5b                   	pop    %ebx
  800fc0:	5e                   	pop    %esi
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    

00800fc3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	56                   	push   %esi
  800fc7:	53                   	push   %ebx
  800fc8:	83 ec 10             	sub    $0x10,%esp
  800fcb:	89 c6                	mov    %eax,%esi
  800fcd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800fcf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800fd6:	75 11                	jne    800fe9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800fd8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800fdf:	e8 5b 14 00 00       	call   80243f <ipc_find_env>
  800fe4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800fe9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800ff0:	00 
  800ff1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800ff8:	00 
  800ff9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ffd:	a1 00 40 80 00       	mov    0x804000,%eax
  801002:	89 04 24             	mov    %eax,(%esp)
  801005:	e8 ca 13 00 00       	call   8023d4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80100a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801011:	00 
  801012:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801016:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80101d:	e8 5e 13 00 00       	call   802380 <ipc_recv>
}
  801022:	83 c4 10             	add    $0x10,%esp
  801025:	5b                   	pop    %ebx
  801026:	5e                   	pop    %esi
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8b 40 0c             	mov    0xc(%eax),%eax
  801035:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801042:	ba 00 00 00 00       	mov    $0x0,%edx
  801047:	b8 02 00 00 00       	mov    $0x2,%eax
  80104c:	e8 72 ff ff ff       	call   800fc3 <fsipc>
}
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	8b 40 0c             	mov    0xc(%eax),%eax
  80105f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801064:	ba 00 00 00 00       	mov    $0x0,%edx
  801069:	b8 06 00 00 00       	mov    $0x6,%eax
  80106e:	e8 50 ff ff ff       	call   800fc3 <fsipc>
}
  801073:	c9                   	leave  
  801074:	c3                   	ret    

00801075 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	53                   	push   %ebx
  801079:	83 ec 14             	sub    $0x14,%esp
  80107c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8b 40 0c             	mov    0xc(%eax),%eax
  801085:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80108a:	ba 00 00 00 00       	mov    $0x0,%edx
  80108f:	b8 05 00 00 00       	mov    $0x5,%eax
  801094:	e8 2a ff ff ff       	call   800fc3 <fsipc>
  801099:	89 c2                	mov    %eax,%edx
  80109b:	85 d2                	test   %edx,%edx
  80109d:	78 2b                	js     8010ca <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80109f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8010a6:	00 
  8010a7:	89 1c 24             	mov    %ebx,(%esp)
  8010aa:	e8 e8 f0 ff ff       	call   800197 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8010af:	a1 80 50 80 00       	mov    0x805080,%eax
  8010b4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8010ba:	a1 84 50 80 00       	mov    0x805084,%eax
  8010bf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8010c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ca:	83 c4 14             	add    $0x14,%esp
  8010cd:	5b                   	pop    %ebx
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    

008010d0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	83 ec 18             	sub    $0x18,%esp
  8010d6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8010d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dc:	8b 52 0c             	mov    0xc(%edx),%edx
  8010df:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  8010e5:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8010ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010f5:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8010fc:	e8 9b f2 ff ff       	call   80039c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801101:	ba 00 00 00 00       	mov    $0x0,%edx
  801106:	b8 04 00 00 00       	mov    $0x4,%eax
  80110b:	e8 b3 fe ff ff       	call   800fc3 <fsipc>
		return r;
	}

	return r;
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	56                   	push   %esi
  801116:	53                   	push   %ebx
  801117:	83 ec 10             	sub    $0x10,%esp
  80111a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8b 40 0c             	mov    0xc(%eax),%eax
  801123:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801128:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80112e:	ba 00 00 00 00       	mov    $0x0,%edx
  801133:	b8 03 00 00 00       	mov    $0x3,%eax
  801138:	e8 86 fe ff ff       	call   800fc3 <fsipc>
  80113d:	89 c3                	mov    %eax,%ebx
  80113f:	85 c0                	test   %eax,%eax
  801141:	78 6a                	js     8011ad <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801143:	39 c6                	cmp    %eax,%esi
  801145:	73 24                	jae    80116b <devfile_read+0x59>
  801147:	c7 44 24 0c 2c 28 80 	movl   $0x80282c,0xc(%esp)
  80114e:	00 
  80114f:	c7 44 24 08 33 28 80 	movl   $0x802833,0x8(%esp)
  801156:	00 
  801157:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80115e:	00 
  80115f:	c7 04 24 48 28 80 00 	movl   $0x802848,(%esp)
  801166:	e8 2b 0b 00 00       	call   801c96 <_panic>
	assert(r <= PGSIZE);
  80116b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801170:	7e 24                	jle    801196 <devfile_read+0x84>
  801172:	c7 44 24 0c 53 28 80 	movl   $0x802853,0xc(%esp)
  801179:	00 
  80117a:	c7 44 24 08 33 28 80 	movl   $0x802833,0x8(%esp)
  801181:	00 
  801182:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801189:	00 
  80118a:	c7 04 24 48 28 80 00 	movl   $0x802848,(%esp)
  801191:	e8 00 0b 00 00       	call   801c96 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801196:	89 44 24 08          	mov    %eax,0x8(%esp)
  80119a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8011a1:	00 
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	89 04 24             	mov    %eax,(%esp)
  8011a8:	e8 87 f1 ff ff       	call   800334 <memmove>
	return r;
}
  8011ad:	89 d8                	mov    %ebx,%eax
  8011af:	83 c4 10             	add    $0x10,%esp
  8011b2:	5b                   	pop    %ebx
  8011b3:	5e                   	pop    %esi
  8011b4:	5d                   	pop    %ebp
  8011b5:	c3                   	ret    

008011b6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	53                   	push   %ebx
  8011ba:	83 ec 24             	sub    $0x24,%esp
  8011bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8011c0:	89 1c 24             	mov    %ebx,(%esp)
  8011c3:	e8 98 ef ff ff       	call   800160 <strlen>
  8011c8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8011cd:	7f 60                	jg     80122f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8011cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d2:	89 04 24             	mov    %eax,(%esp)
  8011d5:	e8 2d f8 ff ff       	call   800a07 <fd_alloc>
  8011da:	89 c2                	mov    %eax,%edx
  8011dc:	85 d2                	test   %edx,%edx
  8011de:	78 54                	js     801234 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8011e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011e4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8011eb:	e8 a7 ef ff ff       	call   800197 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8011f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fb:	b8 01 00 00 00       	mov    $0x1,%eax
  801200:	e8 be fd ff ff       	call   800fc3 <fsipc>
  801205:	89 c3                	mov    %eax,%ebx
  801207:	85 c0                	test   %eax,%eax
  801209:	79 17                	jns    801222 <open+0x6c>
		fd_close(fd, 0);
  80120b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801212:	00 
  801213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801216:	89 04 24             	mov    %eax,(%esp)
  801219:	e8 e8 f8 ff ff       	call   800b06 <fd_close>
		return r;
  80121e:	89 d8                	mov    %ebx,%eax
  801220:	eb 12                	jmp    801234 <open+0x7e>
	}

	return fd2num(fd);
  801222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801225:	89 04 24             	mov    %eax,(%esp)
  801228:	e8 b3 f7 ff ff       	call   8009e0 <fd2num>
  80122d:	eb 05                	jmp    801234 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80122f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801234:	83 c4 24             	add    $0x24,%esp
  801237:	5b                   	pop    %ebx
  801238:	5d                   	pop    %ebp
  801239:	c3                   	ret    

0080123a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801240:	ba 00 00 00 00       	mov    $0x0,%edx
  801245:	b8 08 00 00 00       	mov    $0x8,%eax
  80124a:	e8 74 fd ff ff       	call   800fc3 <fsipc>
}
  80124f:	c9                   	leave  
  801250:	c3                   	ret    
  801251:	66 90                	xchg   %ax,%ax
  801253:	66 90                	xchg   %ax,%ax
  801255:	66 90                	xchg   %ax,%ax
  801257:	66 90                	xchg   %ax,%ax
  801259:	66 90                	xchg   %ax,%ax
  80125b:	66 90                	xchg   %ax,%ax
  80125d:	66 90                	xchg   %ax,%ax
  80125f:	90                   	nop

00801260 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
  801263:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801266:	c7 44 24 04 5f 28 80 	movl   $0x80285f,0x4(%esp)
  80126d:	00 
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	89 04 24             	mov    %eax,(%esp)
  801274:	e8 1e ef ff ff       	call   800197 <strcpy>
	return 0;
}
  801279:	b8 00 00 00 00       	mov    $0x0,%eax
  80127e:	c9                   	leave  
  80127f:	c3                   	ret    

00801280 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	53                   	push   %ebx
  801284:	83 ec 14             	sub    $0x14,%esp
  801287:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80128a:	89 1c 24             	mov    %ebx,(%esp)
  80128d:	e8 ec 11 00 00       	call   80247e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801292:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801297:	83 f8 01             	cmp    $0x1,%eax
  80129a:	75 0d                	jne    8012a9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80129c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80129f:	89 04 24             	mov    %eax,(%esp)
  8012a2:	e8 29 03 00 00       	call   8015d0 <nsipc_close>
  8012a7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8012a9:	89 d0                	mov    %edx,%eax
  8012ab:	83 c4 14             	add    $0x14,%esp
  8012ae:	5b                   	pop    %ebx
  8012af:	5d                   	pop    %ebp
  8012b0:	c3                   	ret    

008012b1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8012b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8012be:	00 
  8012bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8012d3:	89 04 24             	mov    %eax,(%esp)
  8012d6:	e8 f0 03 00 00       	call   8016cb <nsipc_send>
}
  8012db:	c9                   	leave  
  8012dc:	c3                   	ret    

008012dd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8012e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8012ea:	00 
  8012eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8012ff:	89 04 24             	mov    %eax,(%esp)
  801302:	e8 44 03 00 00       	call   80164b <nsipc_recv>
}
  801307:	c9                   	leave  
  801308:	c3                   	ret    

00801309 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80130f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801312:	89 54 24 04          	mov    %edx,0x4(%esp)
  801316:	89 04 24             	mov    %eax,(%esp)
  801319:	e8 38 f7 ff ff       	call   800a56 <fd_lookup>
  80131e:	85 c0                	test   %eax,%eax
  801320:	78 17                	js     801339 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801325:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80132b:	39 08                	cmp    %ecx,(%eax)
  80132d:	75 05                	jne    801334 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80132f:	8b 40 0c             	mov    0xc(%eax),%eax
  801332:	eb 05                	jmp    801339 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801334:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801339:	c9                   	leave  
  80133a:	c3                   	ret    

0080133b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	56                   	push   %esi
  80133f:	53                   	push   %ebx
  801340:	83 ec 20             	sub    $0x20,%esp
  801343:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801345:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801348:	89 04 24             	mov    %eax,(%esp)
  80134b:	e8 b7 f6 ff ff       	call   800a07 <fd_alloc>
  801350:	89 c3                	mov    %eax,%ebx
  801352:	85 c0                	test   %eax,%eax
  801354:	78 21                	js     801377 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801356:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80135d:	00 
  80135e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801361:	89 44 24 04          	mov    %eax,0x4(%esp)
  801365:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80136c:	e8 42 f2 ff ff       	call   8005b3 <sys_page_alloc>
  801371:	89 c3                	mov    %eax,%ebx
  801373:	85 c0                	test   %eax,%eax
  801375:	79 0c                	jns    801383 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801377:	89 34 24             	mov    %esi,(%esp)
  80137a:	e8 51 02 00 00       	call   8015d0 <nsipc_close>
		return r;
  80137f:	89 d8                	mov    %ebx,%eax
  801381:	eb 20                	jmp    8013a3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801383:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80138e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801391:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801398:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80139b:	89 14 24             	mov    %edx,(%esp)
  80139e:	e8 3d f6 ff ff       	call   8009e0 <fd2num>
}
  8013a3:	83 c4 20             	add    $0x20,%esp
  8013a6:	5b                   	pop    %ebx
  8013a7:	5e                   	pop    %esi
  8013a8:	5d                   	pop    %ebp
  8013a9:	c3                   	ret    

008013aa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	e8 51 ff ff ff       	call   801309 <fd2sockid>
		return r;
  8013b8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8013ba:	85 c0                	test   %eax,%eax
  8013bc:	78 23                	js     8013e1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8013be:	8b 55 10             	mov    0x10(%ebp),%edx
  8013c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8013cc:	89 04 24             	mov    %eax,(%esp)
  8013cf:	e8 45 01 00 00       	call   801519 <nsipc_accept>
		return r;
  8013d4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	78 07                	js     8013e1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8013da:	e8 5c ff ff ff       	call   80133b <alloc_sockfd>
  8013df:	89 c1                	mov    %eax,%ecx
}
  8013e1:	89 c8                	mov    %ecx,%eax
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    

008013e5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	e8 16 ff ff ff       	call   801309 <fd2sockid>
  8013f3:	89 c2                	mov    %eax,%edx
  8013f5:	85 d2                	test   %edx,%edx
  8013f7:	78 16                	js     80140f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8013f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801400:	8b 45 0c             	mov    0xc(%ebp),%eax
  801403:	89 44 24 04          	mov    %eax,0x4(%esp)
  801407:	89 14 24             	mov    %edx,(%esp)
  80140a:	e8 60 01 00 00       	call   80156f <nsipc_bind>
}
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <shutdown>:

int
shutdown(int s, int how)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
  801414:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	e8 ea fe ff ff       	call   801309 <fd2sockid>
  80141f:	89 c2                	mov    %eax,%edx
  801421:	85 d2                	test   %edx,%edx
  801423:	78 0f                	js     801434 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801425:	8b 45 0c             	mov    0xc(%ebp),%eax
  801428:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142c:	89 14 24             	mov    %edx,(%esp)
  80142f:	e8 7a 01 00 00       	call   8015ae <nsipc_shutdown>
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	e8 c5 fe ff ff       	call   801309 <fd2sockid>
  801444:	89 c2                	mov    %eax,%edx
  801446:	85 d2                	test   %edx,%edx
  801448:	78 16                	js     801460 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80144a:	8b 45 10             	mov    0x10(%ebp),%eax
  80144d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	89 44 24 04          	mov    %eax,0x4(%esp)
  801458:	89 14 24             	mov    %edx,(%esp)
  80145b:	e8 8a 01 00 00       	call   8015ea <nsipc_connect>
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <listen>:

int
listen(int s, int backlog)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	e8 99 fe ff ff       	call   801309 <fd2sockid>
  801470:	89 c2                	mov    %eax,%edx
  801472:	85 d2                	test   %edx,%edx
  801474:	78 0f                	js     801485 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801476:	8b 45 0c             	mov    0xc(%ebp),%eax
  801479:	89 44 24 04          	mov    %eax,0x4(%esp)
  80147d:	89 14 24             	mov    %edx,(%esp)
  801480:	e8 a4 01 00 00       	call   801629 <nsipc_listen>
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80148d:	8b 45 10             	mov    0x10(%ebp),%eax
  801490:	89 44 24 08          	mov    %eax,0x8(%esp)
  801494:	8b 45 0c             	mov    0xc(%ebp),%eax
  801497:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	89 04 24             	mov    %eax,(%esp)
  8014a1:	e8 98 02 00 00       	call   80173e <nsipc_socket>
  8014a6:	89 c2                	mov    %eax,%edx
  8014a8:	85 d2                	test   %edx,%edx
  8014aa:	78 05                	js     8014b1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8014ac:	e8 8a fe ff ff       	call   80133b <alloc_sockfd>
}
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	53                   	push   %ebx
  8014b7:	83 ec 14             	sub    $0x14,%esp
  8014ba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8014bc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8014c3:	75 11                	jne    8014d6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8014c5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8014cc:	e8 6e 0f 00 00       	call   80243f <ipc_find_env>
  8014d1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8014d6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8014dd:	00 
  8014de:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8014e5:	00 
  8014e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8014ef:	89 04 24             	mov    %eax,(%esp)
  8014f2:	e8 dd 0e 00 00       	call   8023d4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8014f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014fe:	00 
  8014ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801506:	00 
  801507:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80150e:	e8 6d 0e 00 00       	call   802380 <ipc_recv>
}
  801513:	83 c4 14             	add    $0x14,%esp
  801516:	5b                   	pop    %ebx
  801517:	5d                   	pop    %ebp
  801518:	c3                   	ret    

00801519 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	56                   	push   %esi
  80151d:	53                   	push   %ebx
  80151e:	83 ec 10             	sub    $0x10,%esp
  801521:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80152c:	8b 06                	mov    (%esi),%eax
  80152e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801533:	b8 01 00 00 00       	mov    $0x1,%eax
  801538:	e8 76 ff ff ff       	call   8014b3 <nsipc>
  80153d:	89 c3                	mov    %eax,%ebx
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 23                	js     801566 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801543:	a1 10 60 80 00       	mov    0x806010,%eax
  801548:	89 44 24 08          	mov    %eax,0x8(%esp)
  80154c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801553:	00 
  801554:	8b 45 0c             	mov    0xc(%ebp),%eax
  801557:	89 04 24             	mov    %eax,(%esp)
  80155a:	e8 d5 ed ff ff       	call   800334 <memmove>
		*addrlen = ret->ret_addrlen;
  80155f:	a1 10 60 80 00       	mov    0x806010,%eax
  801564:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801566:	89 d8                	mov    %ebx,%eax
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	5b                   	pop    %ebx
  80156c:	5e                   	pop    %esi
  80156d:	5d                   	pop    %ebp
  80156e:	c3                   	ret    

0080156f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	53                   	push   %ebx
  801573:	83 ec 14             	sub    $0x14,%esp
  801576:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801581:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801585:	8b 45 0c             	mov    0xc(%ebp),%eax
  801588:	89 44 24 04          	mov    %eax,0x4(%esp)
  80158c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801593:	e8 9c ed ff ff       	call   800334 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801598:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80159e:	b8 02 00 00 00       	mov    $0x2,%eax
  8015a3:	e8 0b ff ff ff       	call   8014b3 <nsipc>
}
  8015a8:	83 c4 14             	add    $0x14,%esp
  8015ab:	5b                   	pop    %ebx
  8015ac:	5d                   	pop    %ebp
  8015ad:	c3                   	ret    

008015ae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8015bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8015c4:	b8 03 00 00 00       	mov    $0x3,%eax
  8015c9:	e8 e5 fe ff ff       	call   8014b3 <nsipc>
}
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <nsipc_close>:

int
nsipc_close(int s)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8015de:	b8 04 00 00 00       	mov    $0x4,%eax
  8015e3:	e8 cb fe ff ff       	call   8014b3 <nsipc>
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	53                   	push   %ebx
  8015ee:	83 ec 14             	sub    $0x14,%esp
  8015f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8015fc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801600:	8b 45 0c             	mov    0xc(%ebp),%eax
  801603:	89 44 24 04          	mov    %eax,0x4(%esp)
  801607:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  80160e:	e8 21 ed ff ff       	call   800334 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801613:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801619:	b8 05 00 00 00       	mov    $0x5,%eax
  80161e:	e8 90 fe ff ff       	call   8014b3 <nsipc>
}
  801623:	83 c4 14             	add    $0x14,%esp
  801626:	5b                   	pop    %ebx
  801627:	5d                   	pop    %ebp
  801628:	c3                   	ret    

00801629 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80163f:	b8 06 00 00 00       	mov    $0x6,%eax
  801644:	e8 6a fe ff ff       	call   8014b3 <nsipc>
}
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	56                   	push   %esi
  80164f:	53                   	push   %ebx
  801650:	83 ec 10             	sub    $0x10,%esp
  801653:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80165e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801664:	8b 45 14             	mov    0x14(%ebp),%eax
  801667:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80166c:	b8 07 00 00 00       	mov    $0x7,%eax
  801671:	e8 3d fe ff ff       	call   8014b3 <nsipc>
  801676:	89 c3                	mov    %eax,%ebx
  801678:	85 c0                	test   %eax,%eax
  80167a:	78 46                	js     8016c2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80167c:	39 f0                	cmp    %esi,%eax
  80167e:	7f 07                	jg     801687 <nsipc_recv+0x3c>
  801680:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801685:	7e 24                	jle    8016ab <nsipc_recv+0x60>
  801687:	c7 44 24 0c 6b 28 80 	movl   $0x80286b,0xc(%esp)
  80168e:	00 
  80168f:	c7 44 24 08 33 28 80 	movl   $0x802833,0x8(%esp)
  801696:	00 
  801697:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80169e:	00 
  80169f:	c7 04 24 80 28 80 00 	movl   $0x802880,(%esp)
  8016a6:	e8 eb 05 00 00       	call   801c96 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8016ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016af:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8016b6:	00 
  8016b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ba:	89 04 24             	mov    %eax,(%esp)
  8016bd:	e8 72 ec ff ff       	call   800334 <memmove>
	}

	return r;
}
  8016c2:	89 d8                	mov    %ebx,%eax
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	5b                   	pop    %ebx
  8016c8:	5e                   	pop    %esi
  8016c9:	5d                   	pop    %ebp
  8016ca:	c3                   	ret    

008016cb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	53                   	push   %ebx
  8016cf:	83 ec 14             	sub    $0x14,%esp
  8016d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8016dd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8016e3:	7e 24                	jle    801709 <nsipc_send+0x3e>
  8016e5:	c7 44 24 0c 8c 28 80 	movl   $0x80288c,0xc(%esp)
  8016ec:	00 
  8016ed:	c7 44 24 08 33 28 80 	movl   $0x802833,0x8(%esp)
  8016f4:	00 
  8016f5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8016fc:	00 
  8016fd:	c7 04 24 80 28 80 00 	movl   $0x802880,(%esp)
  801704:	e8 8d 05 00 00       	call   801c96 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801709:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80170d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801710:	89 44 24 04          	mov    %eax,0x4(%esp)
  801714:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80171b:	e8 14 ec ff ff       	call   800334 <memmove>
	nsipcbuf.send.req_size = size;
  801720:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801726:	8b 45 14             	mov    0x14(%ebp),%eax
  801729:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80172e:	b8 08 00 00 00       	mov    $0x8,%eax
  801733:	e8 7b fd ff ff       	call   8014b3 <nsipc>
}
  801738:	83 c4 14             	add    $0x14,%esp
  80173b:	5b                   	pop    %ebx
  80173c:	5d                   	pop    %ebp
  80173d:	c3                   	ret    

0080173e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80174c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801754:	8b 45 10             	mov    0x10(%ebp),%eax
  801757:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80175c:	b8 09 00 00 00       	mov    $0x9,%eax
  801761:	e8 4d fd ff ff       	call   8014b3 <nsipc>
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	56                   	push   %esi
  80176c:	53                   	push   %ebx
  80176d:	83 ec 10             	sub    $0x10,%esp
  801770:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	89 04 24             	mov    %eax,(%esp)
  801779:	e8 72 f2 ff ff       	call   8009f0 <fd2data>
  80177e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801780:	c7 44 24 04 98 28 80 	movl   $0x802898,0x4(%esp)
  801787:	00 
  801788:	89 1c 24             	mov    %ebx,(%esp)
  80178b:	e8 07 ea ff ff       	call   800197 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801790:	8b 46 04             	mov    0x4(%esi),%eax
  801793:	2b 06                	sub    (%esi),%eax
  801795:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80179b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017a2:	00 00 00 
	stat->st_dev = &devpipe;
  8017a5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8017ac:	30 80 00 
	return 0;
}
  8017af:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b4:	83 c4 10             	add    $0x10,%esp
  8017b7:	5b                   	pop    %ebx
  8017b8:	5e                   	pop    %esi
  8017b9:	5d                   	pop    %ebp
  8017ba:	c3                   	ret    

008017bb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	53                   	push   %ebx
  8017bf:	83 ec 14             	sub    $0x14,%esp
  8017c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017d0:	e8 85 ee ff ff       	call   80065a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017d5:	89 1c 24             	mov    %ebx,(%esp)
  8017d8:	e8 13 f2 ff ff       	call   8009f0 <fd2data>
  8017dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017e8:	e8 6d ee ff ff       	call   80065a <sys_page_unmap>
}
  8017ed:	83 c4 14             	add    $0x14,%esp
  8017f0:	5b                   	pop    %ebx
  8017f1:	5d                   	pop    %ebp
  8017f2:	c3                   	ret    

008017f3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	57                   	push   %edi
  8017f7:	56                   	push   %esi
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 2c             	sub    $0x2c,%esp
  8017fc:	89 c6                	mov    %eax,%esi
  8017fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801801:	a1 08 40 80 00       	mov    0x804008,%eax
  801806:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801809:	89 34 24             	mov    %esi,(%esp)
  80180c:	e8 6d 0c 00 00       	call   80247e <pageref>
  801811:	89 c7                	mov    %eax,%edi
  801813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801816:	89 04 24             	mov    %eax,(%esp)
  801819:	e8 60 0c 00 00       	call   80247e <pageref>
  80181e:	39 c7                	cmp    %eax,%edi
  801820:	0f 94 c2             	sete   %dl
  801823:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801826:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  80182c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80182f:	39 fb                	cmp    %edi,%ebx
  801831:	74 21                	je     801854 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801833:	84 d2                	test   %dl,%dl
  801835:	74 ca                	je     801801 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801837:	8b 51 58             	mov    0x58(%ecx),%edx
  80183a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80183e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801842:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801846:	c7 04 24 9f 28 80 00 	movl   $0x80289f,(%esp)
  80184d:	e8 3d 05 00 00       	call   801d8f <cprintf>
  801852:	eb ad                	jmp    801801 <_pipeisclosed+0xe>
	}
}
  801854:	83 c4 2c             	add    $0x2c,%esp
  801857:	5b                   	pop    %ebx
  801858:	5e                   	pop    %esi
  801859:	5f                   	pop    %edi
  80185a:	5d                   	pop    %ebp
  80185b:	c3                   	ret    

0080185c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	57                   	push   %edi
  801860:	56                   	push   %esi
  801861:	53                   	push   %ebx
  801862:	83 ec 1c             	sub    $0x1c,%esp
  801865:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801868:	89 34 24             	mov    %esi,(%esp)
  80186b:	e8 80 f1 ff ff       	call   8009f0 <fd2data>
  801870:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801872:	bf 00 00 00 00       	mov    $0x0,%edi
  801877:	eb 45                	jmp    8018be <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801879:	89 da                	mov    %ebx,%edx
  80187b:	89 f0                	mov    %esi,%eax
  80187d:	e8 71 ff ff ff       	call   8017f3 <_pipeisclosed>
  801882:	85 c0                	test   %eax,%eax
  801884:	75 41                	jne    8018c7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801886:	e8 09 ed ff ff       	call   800594 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80188b:	8b 43 04             	mov    0x4(%ebx),%eax
  80188e:	8b 0b                	mov    (%ebx),%ecx
  801890:	8d 51 20             	lea    0x20(%ecx),%edx
  801893:	39 d0                	cmp    %edx,%eax
  801895:	73 e2                	jae    801879 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801897:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80189a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80189e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8018a1:	99                   	cltd   
  8018a2:	c1 ea 1b             	shr    $0x1b,%edx
  8018a5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8018a8:	83 e1 1f             	and    $0x1f,%ecx
  8018ab:	29 d1                	sub    %edx,%ecx
  8018ad:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8018b1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8018b5:	83 c0 01             	add    $0x1,%eax
  8018b8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018bb:	83 c7 01             	add    $0x1,%edi
  8018be:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8018c1:	75 c8                	jne    80188b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8018c3:	89 f8                	mov    %edi,%eax
  8018c5:	eb 05                	jmp    8018cc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8018c7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8018cc:	83 c4 1c             	add    $0x1c,%esp
  8018cf:	5b                   	pop    %ebx
  8018d0:	5e                   	pop    %esi
  8018d1:	5f                   	pop    %edi
  8018d2:	5d                   	pop    %ebp
  8018d3:	c3                   	ret    

008018d4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	57                   	push   %edi
  8018d8:	56                   	push   %esi
  8018d9:	53                   	push   %ebx
  8018da:	83 ec 1c             	sub    $0x1c,%esp
  8018dd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8018e0:	89 3c 24             	mov    %edi,(%esp)
  8018e3:	e8 08 f1 ff ff       	call   8009f0 <fd2data>
  8018e8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018ea:	be 00 00 00 00       	mov    $0x0,%esi
  8018ef:	eb 3d                	jmp    80192e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8018f1:	85 f6                	test   %esi,%esi
  8018f3:	74 04                	je     8018f9 <devpipe_read+0x25>
				return i;
  8018f5:	89 f0                	mov    %esi,%eax
  8018f7:	eb 43                	jmp    80193c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8018f9:	89 da                	mov    %ebx,%edx
  8018fb:	89 f8                	mov    %edi,%eax
  8018fd:	e8 f1 fe ff ff       	call   8017f3 <_pipeisclosed>
  801902:	85 c0                	test   %eax,%eax
  801904:	75 31                	jne    801937 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801906:	e8 89 ec ff ff       	call   800594 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80190b:	8b 03                	mov    (%ebx),%eax
  80190d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801910:	74 df                	je     8018f1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801912:	99                   	cltd   
  801913:	c1 ea 1b             	shr    $0x1b,%edx
  801916:	01 d0                	add    %edx,%eax
  801918:	83 e0 1f             	and    $0x1f,%eax
  80191b:	29 d0                	sub    %edx,%eax
  80191d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801922:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801925:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801928:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80192b:	83 c6 01             	add    $0x1,%esi
  80192e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801931:	75 d8                	jne    80190b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801933:	89 f0                	mov    %esi,%eax
  801935:	eb 05                	jmp    80193c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801937:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80193c:	83 c4 1c             	add    $0x1c,%esp
  80193f:	5b                   	pop    %ebx
  801940:	5e                   	pop    %esi
  801941:	5f                   	pop    %edi
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    

00801944 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	56                   	push   %esi
  801948:	53                   	push   %ebx
  801949:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80194c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194f:	89 04 24             	mov    %eax,(%esp)
  801952:	e8 b0 f0 ff ff       	call   800a07 <fd_alloc>
  801957:	89 c2                	mov    %eax,%edx
  801959:	85 d2                	test   %edx,%edx
  80195b:	0f 88 4d 01 00 00    	js     801aae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801961:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801968:	00 
  801969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801970:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801977:	e8 37 ec ff ff       	call   8005b3 <sys_page_alloc>
  80197c:	89 c2                	mov    %eax,%edx
  80197e:	85 d2                	test   %edx,%edx
  801980:	0f 88 28 01 00 00    	js     801aae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801986:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801989:	89 04 24             	mov    %eax,(%esp)
  80198c:	e8 76 f0 ff ff       	call   800a07 <fd_alloc>
  801991:	89 c3                	mov    %eax,%ebx
  801993:	85 c0                	test   %eax,%eax
  801995:	0f 88 fe 00 00 00    	js     801a99 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80199b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019a2:	00 
  8019a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019b1:	e8 fd eb ff ff       	call   8005b3 <sys_page_alloc>
  8019b6:	89 c3                	mov    %eax,%ebx
  8019b8:	85 c0                	test   %eax,%eax
  8019ba:	0f 88 d9 00 00 00    	js     801a99 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8019c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c3:	89 04 24             	mov    %eax,(%esp)
  8019c6:	e8 25 f0 ff ff       	call   8009f0 <fd2data>
  8019cb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019cd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019d4:	00 
  8019d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019e0:	e8 ce eb ff ff       	call   8005b3 <sys_page_alloc>
  8019e5:	89 c3                	mov    %eax,%ebx
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	0f 88 97 00 00 00    	js     801a86 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f2:	89 04 24             	mov    %eax,(%esp)
  8019f5:	e8 f6 ef ff ff       	call   8009f0 <fd2data>
  8019fa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801a01:	00 
  801a02:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a06:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a0d:	00 
  801a0e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a19:	e8 e9 eb ff ff       	call   800607 <sys_page_map>
  801a1e:	89 c3                	mov    %eax,%ebx
  801a20:	85 c0                	test   %eax,%eax
  801a22:	78 52                	js     801a76 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801a24:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801a39:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a42:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a47:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a51:	89 04 24             	mov    %eax,(%esp)
  801a54:	e8 87 ef ff ff       	call   8009e0 <fd2num>
  801a59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a5c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a61:	89 04 24             	mov    %eax,(%esp)
  801a64:	e8 77 ef ff ff       	call   8009e0 <fd2num>
  801a69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a6c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a74:	eb 38                	jmp    801aae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801a76:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a81:	e8 d4 eb ff ff       	call   80065a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a94:	e8 c1 eb ff ff       	call   80065a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aa7:	e8 ae eb ff ff       	call   80065a <sys_page_unmap>
  801aac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801aae:	83 c4 30             	add    $0x30,%esp
  801ab1:	5b                   	pop    %ebx
  801ab2:	5e                   	pop    %esi
  801ab3:	5d                   	pop    %ebp
  801ab4:	c3                   	ret    

00801ab5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801abb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801abe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	89 04 24             	mov    %eax,(%esp)
  801ac8:	e8 89 ef ff ff       	call   800a56 <fd_lookup>
  801acd:	89 c2                	mov    %eax,%edx
  801acf:	85 d2                	test   %edx,%edx
  801ad1:	78 15                	js     801ae8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad6:	89 04 24             	mov    %eax,(%esp)
  801ad9:	e8 12 ef ff ff       	call   8009f0 <fd2data>
	return _pipeisclosed(fd, p);
  801ade:	89 c2                	mov    %eax,%edx
  801ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae3:	e8 0b fd ff ff       	call   8017f3 <_pipeisclosed>
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    
  801aea:	66 90                	xchg   %ax,%ax
  801aec:	66 90                	xchg   %ax,%ax
  801aee:	66 90                	xchg   %ax,%ax

00801af0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801af3:	b8 00 00 00 00       	mov    $0x0,%eax
  801af8:	5d                   	pop    %ebp
  801af9:	c3                   	ret    

00801afa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801b00:	c7 44 24 04 b7 28 80 	movl   $0x8028b7,0x4(%esp)
  801b07:	00 
  801b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0b:	89 04 24             	mov    %eax,(%esp)
  801b0e:	e8 84 e6 ff ff       	call   800197 <strcpy>
	return 0;
}
  801b13:	b8 00 00 00 00       	mov    $0x0,%eax
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	57                   	push   %edi
  801b1e:	56                   	push   %esi
  801b1f:	53                   	push   %ebx
  801b20:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b26:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801b2b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b31:	eb 31                	jmp    801b64 <devcons_write+0x4a>
		m = n - tot;
  801b33:	8b 75 10             	mov    0x10(%ebp),%esi
  801b36:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  801b38:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801b3b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801b40:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801b43:	89 74 24 08          	mov    %esi,0x8(%esp)
  801b47:	03 45 0c             	add    0xc(%ebp),%eax
  801b4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4e:	89 3c 24             	mov    %edi,(%esp)
  801b51:	e8 de e7 ff ff       	call   800334 <memmove>
		sys_cputs(buf, m);
  801b56:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b5a:	89 3c 24             	mov    %edi,(%esp)
  801b5d:	e8 84 e9 ff ff       	call   8004e6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b62:	01 f3                	add    %esi,%ebx
  801b64:	89 d8                	mov    %ebx,%eax
  801b66:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801b69:	72 c8                	jb     801b33 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801b6b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801b71:	5b                   	pop    %ebx
  801b72:	5e                   	pop    %esi
  801b73:	5f                   	pop    %edi
  801b74:	5d                   	pop    %ebp
  801b75:	c3                   	ret    

00801b76 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801b7c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801b81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b85:	75 07                	jne    801b8e <devcons_read+0x18>
  801b87:	eb 2a                	jmp    801bb3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801b89:	e8 06 ea ff ff       	call   800594 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801b8e:	66 90                	xchg   %ax,%ax
  801b90:	e8 6f e9 ff ff       	call   800504 <sys_cgetc>
  801b95:	85 c0                	test   %eax,%eax
  801b97:	74 f0                	je     801b89 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	78 16                	js     801bb3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801b9d:	83 f8 04             	cmp    $0x4,%eax
  801ba0:	74 0c                	je     801bae <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  801ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba5:	88 02                	mov    %al,(%edx)
	return 1;
  801ba7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bac:	eb 05                	jmp    801bb3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801bae:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801bc1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801bc8:	00 
  801bc9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bcc:	89 04 24             	mov    %eax,(%esp)
  801bcf:	e8 12 e9 ff ff       	call   8004e6 <sys_cputs>
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <getchar>:

int
getchar(void)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801bdc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801be3:	00 
  801be4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801beb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bf2:	e8 f3 f0 ff ff       	call   800cea <read>
	if (r < 0)
  801bf7:	85 c0                	test   %eax,%eax
  801bf9:	78 0f                	js     801c0a <getchar+0x34>
		return r;
	if (r < 1)
  801bfb:	85 c0                	test   %eax,%eax
  801bfd:	7e 06                	jle    801c05 <getchar+0x2f>
		return -E_EOF;
	return c;
  801bff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801c03:	eb 05                	jmp    801c0a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801c05:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c12:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	89 04 24             	mov    %eax,(%esp)
  801c1f:	e8 32 ee ff ff       	call   800a56 <fd_lookup>
  801c24:	85 c0                	test   %eax,%eax
  801c26:	78 11                	js     801c39 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801c31:	39 10                	cmp    %edx,(%eax)
  801c33:	0f 94 c0             	sete   %al
  801c36:	0f b6 c0             	movzbl %al,%eax
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <opencons>:

int
opencons(void)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c41:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c44:	89 04 24             	mov    %eax,(%esp)
  801c47:	e8 bb ed ff ff       	call   800a07 <fd_alloc>
		return r;
  801c4c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	78 40                	js     801c92 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c52:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c59:	00 
  801c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c68:	e8 46 e9 ff ff       	call   8005b3 <sys_page_alloc>
		return r;
  801c6d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	78 1f                	js     801c92 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801c73:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c81:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c88:	89 04 24             	mov    %eax,(%esp)
  801c8b:	e8 50 ed ff ff       	call   8009e0 <fd2num>
  801c90:	89 c2                	mov    %eax,%edx
}
  801c92:	89 d0                	mov    %edx,%eax
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	56                   	push   %esi
  801c9a:	53                   	push   %ebx
  801c9b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801c9e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ca1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801ca7:	e8 c9 e8 ff ff       	call   800575 <sys_getenvid>
  801cac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801caf:	89 54 24 10          	mov    %edx,0x10(%esp)
  801cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  801cb6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801cba:	89 74 24 08          	mov    %esi,0x8(%esp)
  801cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc2:	c7 04 24 c4 28 80 00 	movl   $0x8028c4,(%esp)
  801cc9:	e8 c1 00 00 00       	call   801d8f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801cce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cd2:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd5:	89 04 24             	mov    %eax,(%esp)
  801cd8:	e8 51 00 00 00       	call   801d2e <vcprintf>
	cprintf("\n");
  801cdd:	c7 04 24 b0 28 80 00 	movl   $0x8028b0,(%esp)
  801ce4:	e8 a6 00 00 00       	call   801d8f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ce9:	cc                   	int3   
  801cea:	eb fd                	jmp    801ce9 <_panic+0x53>

00801cec <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	53                   	push   %ebx
  801cf0:	83 ec 14             	sub    $0x14,%esp
  801cf3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801cf6:	8b 13                	mov    (%ebx),%edx
  801cf8:	8d 42 01             	lea    0x1(%edx),%eax
  801cfb:	89 03                	mov    %eax,(%ebx)
  801cfd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d00:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801d04:	3d ff 00 00 00       	cmp    $0xff,%eax
  801d09:	75 19                	jne    801d24 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801d0b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801d12:	00 
  801d13:	8d 43 08             	lea    0x8(%ebx),%eax
  801d16:	89 04 24             	mov    %eax,(%esp)
  801d19:	e8 c8 e7 ff ff       	call   8004e6 <sys_cputs>
		b->idx = 0;
  801d1e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801d24:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801d28:	83 c4 14             	add    $0x14,%esp
  801d2b:	5b                   	pop    %ebx
  801d2c:	5d                   	pop    %ebp
  801d2d:	c3                   	ret    

00801d2e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801d37:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d3e:	00 00 00 
	b.cnt = 0;
  801d41:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801d48:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d52:	8b 45 08             	mov    0x8(%ebp),%eax
  801d55:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d59:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d63:	c7 04 24 ec 1c 80 00 	movl   $0x801cec,(%esp)
  801d6a:	e8 af 01 00 00       	call   801f1e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801d6f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801d75:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d79:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801d7f:	89 04 24             	mov    %eax,(%esp)
  801d82:	e8 5f e7 ff ff       	call   8004e6 <sys_cputs>

	return b.cnt;
}
  801d87:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d95:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801d98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	89 04 24             	mov    %eax,(%esp)
  801da2:	e8 87 ff ff ff       	call   801d2e <vcprintf>
	va_end(ap);

	return cnt;
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    
  801da9:	66 90                	xchg   %ax,%ax
  801dab:	66 90                	xchg   %ax,%ax
  801dad:	66 90                	xchg   %ax,%ax
  801daf:	90                   	nop

00801db0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	57                   	push   %edi
  801db4:	56                   	push   %esi
  801db5:	53                   	push   %ebx
  801db6:	83 ec 3c             	sub    $0x3c,%esp
  801db9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dbc:	89 d7                	mov    %edx,%edi
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc7:	89 c3                	mov    %eax,%ebx
  801dc9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801dcc:	8b 45 10             	mov    0x10(%ebp),%eax
  801dcf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801dd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dd7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801dda:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801ddd:	39 d9                	cmp    %ebx,%ecx
  801ddf:	72 05                	jb     801de6 <printnum+0x36>
  801de1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801de4:	77 69                	ja     801e4f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801de6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801de9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801ded:	83 ee 01             	sub    $0x1,%esi
  801df0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801df4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801df8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dfc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801e00:	89 c3                	mov    %eax,%ebx
  801e02:	89 d6                	mov    %edx,%esi
  801e04:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e07:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801e0a:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e0e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e15:	89 04 24             	mov    %eax,(%esp)
  801e18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e1f:	e8 9c 06 00 00       	call   8024c0 <__udivdi3>
  801e24:	89 d9                	mov    %ebx,%ecx
  801e26:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e2a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e2e:	89 04 24             	mov    %eax,(%esp)
  801e31:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e35:	89 fa                	mov    %edi,%edx
  801e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e3a:	e8 71 ff ff ff       	call   801db0 <printnum>
  801e3f:	eb 1b                	jmp    801e5c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801e41:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e45:	8b 45 18             	mov    0x18(%ebp),%eax
  801e48:	89 04 24             	mov    %eax,(%esp)
  801e4b:	ff d3                	call   *%ebx
  801e4d:	eb 03                	jmp    801e52 <printnum+0xa2>
  801e4f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801e52:	83 ee 01             	sub    $0x1,%esi
  801e55:	85 f6                	test   %esi,%esi
  801e57:	7f e8                	jg     801e41 <printnum+0x91>
  801e59:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801e5c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e60:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801e64:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e67:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801e6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e6e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e75:	89 04 24             	mov    %eax,(%esp)
  801e78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7f:	e8 6c 07 00 00       	call   8025f0 <__umoddi3>
  801e84:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e88:	0f be 80 e7 28 80 00 	movsbl 0x8028e7(%eax),%eax
  801e8f:	89 04 24             	mov    %eax,(%esp)
  801e92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e95:	ff d0                	call   *%eax
}
  801e97:	83 c4 3c             	add    $0x3c,%esp
  801e9a:	5b                   	pop    %ebx
  801e9b:	5e                   	pop    %esi
  801e9c:	5f                   	pop    %edi
  801e9d:	5d                   	pop    %ebp
  801e9e:	c3                   	ret    

00801e9f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801ea2:	83 fa 01             	cmp    $0x1,%edx
  801ea5:	7e 0e                	jle    801eb5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801ea7:	8b 10                	mov    (%eax),%edx
  801ea9:	8d 4a 08             	lea    0x8(%edx),%ecx
  801eac:	89 08                	mov    %ecx,(%eax)
  801eae:	8b 02                	mov    (%edx),%eax
  801eb0:	8b 52 04             	mov    0x4(%edx),%edx
  801eb3:	eb 22                	jmp    801ed7 <getuint+0x38>
	else if (lflag)
  801eb5:	85 d2                	test   %edx,%edx
  801eb7:	74 10                	je     801ec9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801eb9:	8b 10                	mov    (%eax),%edx
  801ebb:	8d 4a 04             	lea    0x4(%edx),%ecx
  801ebe:	89 08                	mov    %ecx,(%eax)
  801ec0:	8b 02                	mov    (%edx),%eax
  801ec2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec7:	eb 0e                	jmp    801ed7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801ec9:	8b 10                	mov    (%eax),%edx
  801ecb:	8d 4a 04             	lea    0x4(%edx),%ecx
  801ece:	89 08                	mov    %ecx,(%eax)
  801ed0:	8b 02                	mov    (%edx),%eax
  801ed2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801ed7:	5d                   	pop    %ebp
  801ed8:	c3                   	ret    

00801ed9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801edf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801ee3:	8b 10                	mov    (%eax),%edx
  801ee5:	3b 50 04             	cmp    0x4(%eax),%edx
  801ee8:	73 0a                	jae    801ef4 <sprintputch+0x1b>
		*b->buf++ = ch;
  801eea:	8d 4a 01             	lea    0x1(%edx),%ecx
  801eed:	89 08                	mov    %ecx,(%eax)
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	88 02                	mov    %al,(%edx)
}
  801ef4:	5d                   	pop    %ebp
  801ef5:	c3                   	ret    

00801ef6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801efc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801eff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f03:	8b 45 10             	mov    0x10(%ebp),%eax
  801f06:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	89 04 24             	mov    %eax,(%esp)
  801f17:	e8 02 00 00 00       	call   801f1e <vprintfmt>
	va_end(ap);
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	57                   	push   %edi
  801f22:	56                   	push   %esi
  801f23:	53                   	push   %ebx
  801f24:	83 ec 3c             	sub    $0x3c,%esp
  801f27:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801f2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f2d:	eb 14                	jmp    801f43 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	0f 84 b3 03 00 00    	je     8022ea <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  801f37:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f3b:	89 04 24             	mov    %eax,(%esp)
  801f3e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801f41:	89 f3                	mov    %esi,%ebx
  801f43:	8d 73 01             	lea    0x1(%ebx),%esi
  801f46:	0f b6 03             	movzbl (%ebx),%eax
  801f49:	83 f8 25             	cmp    $0x25,%eax
  801f4c:	75 e1                	jne    801f2f <vprintfmt+0x11>
  801f4e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  801f52:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801f59:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  801f60:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  801f67:	ba 00 00 00 00       	mov    $0x0,%edx
  801f6c:	eb 1d                	jmp    801f8b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f6e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  801f70:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801f74:	eb 15                	jmp    801f8b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f76:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801f78:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801f7c:	eb 0d                	jmp    801f8b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801f7e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f81:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801f84:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f8b:	8d 5e 01             	lea    0x1(%esi),%ebx
  801f8e:	0f b6 0e             	movzbl (%esi),%ecx
  801f91:	0f b6 c1             	movzbl %cl,%eax
  801f94:	83 e9 23             	sub    $0x23,%ecx
  801f97:	80 f9 55             	cmp    $0x55,%cl
  801f9a:	0f 87 2a 03 00 00    	ja     8022ca <vprintfmt+0x3ac>
  801fa0:	0f b6 c9             	movzbl %cl,%ecx
  801fa3:	ff 24 8d 60 2a 80 00 	jmp    *0x802a60(,%ecx,4)
  801faa:	89 de                	mov    %ebx,%esi
  801fac:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801fb1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801fb4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801fb8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801fbb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  801fbe:	83 fb 09             	cmp    $0x9,%ebx
  801fc1:	77 36                	ja     801ff9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801fc3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801fc6:	eb e9                	jmp    801fb1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801fc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801fcb:	8d 48 04             	lea    0x4(%eax),%ecx
  801fce:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801fd1:	8b 00                	mov    (%eax),%eax
  801fd3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801fd6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801fd8:	eb 22                	jmp    801ffc <vprintfmt+0xde>
  801fda:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801fdd:	85 c9                	test   %ecx,%ecx
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe4:	0f 49 c1             	cmovns %ecx,%eax
  801fe7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801fea:	89 de                	mov    %ebx,%esi
  801fec:	eb 9d                	jmp    801f8b <vprintfmt+0x6d>
  801fee:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801ff0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  801ff7:	eb 92                	jmp    801f8b <vprintfmt+0x6d>
  801ff9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  801ffc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802000:	79 89                	jns    801f8b <vprintfmt+0x6d>
  802002:	e9 77 ff ff ff       	jmp    801f7e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  802007:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80200a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80200c:	e9 7a ff ff ff       	jmp    801f8b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  802011:	8b 45 14             	mov    0x14(%ebp),%eax
  802014:	8d 50 04             	lea    0x4(%eax),%edx
  802017:	89 55 14             	mov    %edx,0x14(%ebp)
  80201a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80201e:	8b 00                	mov    (%eax),%eax
  802020:	89 04 24             	mov    %eax,(%esp)
  802023:	ff 55 08             	call   *0x8(%ebp)
			break;
  802026:	e9 18 ff ff ff       	jmp    801f43 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80202b:	8b 45 14             	mov    0x14(%ebp),%eax
  80202e:	8d 50 04             	lea    0x4(%eax),%edx
  802031:	89 55 14             	mov    %edx,0x14(%ebp)
  802034:	8b 00                	mov    (%eax),%eax
  802036:	99                   	cltd   
  802037:	31 d0                	xor    %edx,%eax
  802039:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80203b:	83 f8 12             	cmp    $0x12,%eax
  80203e:	7f 0b                	jg     80204b <vprintfmt+0x12d>
  802040:	8b 14 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%edx
  802047:	85 d2                	test   %edx,%edx
  802049:	75 20                	jne    80206b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80204b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80204f:	c7 44 24 08 ff 28 80 	movl   $0x8028ff,0x8(%esp)
  802056:	00 
  802057:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	89 04 24             	mov    %eax,(%esp)
  802061:	e8 90 fe ff ff       	call   801ef6 <printfmt>
  802066:	e9 d8 fe ff ff       	jmp    801f43 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80206b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80206f:	c7 44 24 08 45 28 80 	movl   $0x802845,0x8(%esp)
  802076:	00 
  802077:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	89 04 24             	mov    %eax,(%esp)
  802081:	e8 70 fe ff ff       	call   801ef6 <printfmt>
  802086:	e9 b8 fe ff ff       	jmp    801f43 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80208b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80208e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802091:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  802094:	8b 45 14             	mov    0x14(%ebp),%eax
  802097:	8d 50 04             	lea    0x4(%eax),%edx
  80209a:	89 55 14             	mov    %edx,0x14(%ebp)
  80209d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80209f:	85 f6                	test   %esi,%esi
  8020a1:	b8 f8 28 80 00       	mov    $0x8028f8,%eax
  8020a6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8020a9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8020ad:	0f 84 97 00 00 00    	je     80214a <vprintfmt+0x22c>
  8020b3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8020b7:	0f 8e 9b 00 00 00    	jle    802158 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8020bd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020c1:	89 34 24             	mov    %esi,(%esp)
  8020c4:	e8 af e0 ff ff       	call   800178 <strnlen>
  8020c9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8020cc:	29 c2                	sub    %eax,%edx
  8020ce:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8020d1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8020d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8020d8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8020db:	8b 75 08             	mov    0x8(%ebp),%esi
  8020de:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8020e1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8020e3:	eb 0f                	jmp    8020f4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8020e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8020e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020ec:	89 04 24             	mov    %eax,(%esp)
  8020ef:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8020f1:	83 eb 01             	sub    $0x1,%ebx
  8020f4:	85 db                	test   %ebx,%ebx
  8020f6:	7f ed                	jg     8020e5 <vprintfmt+0x1c7>
  8020f8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8020fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8020fe:	85 d2                	test   %edx,%edx
  802100:	b8 00 00 00 00       	mov    $0x0,%eax
  802105:	0f 49 c2             	cmovns %edx,%eax
  802108:	29 c2                	sub    %eax,%edx
  80210a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80210d:	89 d7                	mov    %edx,%edi
  80210f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802112:	eb 50                	jmp    802164 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802114:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802118:	74 1e                	je     802138 <vprintfmt+0x21a>
  80211a:	0f be d2             	movsbl %dl,%edx
  80211d:	83 ea 20             	sub    $0x20,%edx
  802120:	83 fa 5e             	cmp    $0x5e,%edx
  802123:	76 13                	jbe    802138 <vprintfmt+0x21a>
					putch('?', putdat);
  802125:	8b 45 0c             	mov    0xc(%ebp),%eax
  802128:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  802133:	ff 55 08             	call   *0x8(%ebp)
  802136:	eb 0d                	jmp    802145 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  802138:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80213f:	89 04 24             	mov    %eax,(%esp)
  802142:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802145:	83 ef 01             	sub    $0x1,%edi
  802148:	eb 1a                	jmp    802164 <vprintfmt+0x246>
  80214a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80214d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  802150:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802153:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802156:	eb 0c                	jmp    802164 <vprintfmt+0x246>
  802158:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80215b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80215e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802161:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802164:	83 c6 01             	add    $0x1,%esi
  802167:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80216b:	0f be c2             	movsbl %dl,%eax
  80216e:	85 c0                	test   %eax,%eax
  802170:	74 27                	je     802199 <vprintfmt+0x27b>
  802172:	85 db                	test   %ebx,%ebx
  802174:	78 9e                	js     802114 <vprintfmt+0x1f6>
  802176:	83 eb 01             	sub    $0x1,%ebx
  802179:	79 99                	jns    802114 <vprintfmt+0x1f6>
  80217b:	89 f8                	mov    %edi,%eax
  80217d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802180:	8b 75 08             	mov    0x8(%ebp),%esi
  802183:	89 c3                	mov    %eax,%ebx
  802185:	eb 1a                	jmp    8021a1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  802187:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80218b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  802192:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802194:	83 eb 01             	sub    $0x1,%ebx
  802197:	eb 08                	jmp    8021a1 <vprintfmt+0x283>
  802199:	89 fb                	mov    %edi,%ebx
  80219b:	8b 75 08             	mov    0x8(%ebp),%esi
  80219e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8021a1:	85 db                	test   %ebx,%ebx
  8021a3:	7f e2                	jg     802187 <vprintfmt+0x269>
  8021a5:	89 75 08             	mov    %esi,0x8(%ebp)
  8021a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021ab:	e9 93 fd ff ff       	jmp    801f43 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8021b0:	83 fa 01             	cmp    $0x1,%edx
  8021b3:	7e 16                	jle    8021cb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8021b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8021b8:	8d 50 08             	lea    0x8(%eax),%edx
  8021bb:	89 55 14             	mov    %edx,0x14(%ebp)
  8021be:	8b 50 04             	mov    0x4(%eax),%edx
  8021c1:	8b 00                	mov    (%eax),%eax
  8021c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8021c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8021c9:	eb 32                	jmp    8021fd <vprintfmt+0x2df>
	else if (lflag)
  8021cb:	85 d2                	test   %edx,%edx
  8021cd:	74 18                	je     8021e7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8021cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d2:	8d 50 04             	lea    0x4(%eax),%edx
  8021d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8021d8:	8b 30                	mov    (%eax),%esi
  8021da:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8021dd:	89 f0                	mov    %esi,%eax
  8021df:	c1 f8 1f             	sar    $0x1f,%eax
  8021e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021e5:	eb 16                	jmp    8021fd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8021e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ea:	8d 50 04             	lea    0x4(%eax),%edx
  8021ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8021f0:	8b 30                	mov    (%eax),%esi
  8021f2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8021f5:	89 f0                	mov    %esi,%eax
  8021f7:	c1 f8 1f             	sar    $0x1f,%eax
  8021fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8021fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802200:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  802203:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  802208:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80220c:	0f 89 80 00 00 00    	jns    802292 <vprintfmt+0x374>
				putch('-', putdat);
  802212:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802216:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80221d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  802220:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802223:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802226:	f7 d8                	neg    %eax
  802228:	83 d2 00             	adc    $0x0,%edx
  80222b:	f7 da                	neg    %edx
			}
			base = 10;
  80222d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802232:	eb 5e                	jmp    802292 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802234:	8d 45 14             	lea    0x14(%ebp),%eax
  802237:	e8 63 fc ff ff       	call   801e9f <getuint>
			base = 10;
  80223c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  802241:	eb 4f                	jmp    802292 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  802243:	8d 45 14             	lea    0x14(%ebp),%eax
  802246:	e8 54 fc ff ff       	call   801e9f <getuint>
			base = 8;
  80224b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  802250:	eb 40                	jmp    802292 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  802252:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802256:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80225d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  802260:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802264:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80226b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80226e:	8b 45 14             	mov    0x14(%ebp),%eax
  802271:	8d 50 04             	lea    0x4(%eax),%edx
  802274:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802277:	8b 00                	mov    (%eax),%eax
  802279:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80227e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  802283:	eb 0d                	jmp    802292 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  802285:	8d 45 14             	lea    0x14(%ebp),%eax
  802288:	e8 12 fc ff ff       	call   801e9f <getuint>
			base = 16;
  80228d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  802292:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  802296:	89 74 24 10          	mov    %esi,0x10(%esp)
  80229a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80229d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8022a1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022a5:	89 04 24             	mov    %eax,(%esp)
  8022a8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022ac:	89 fa                	mov    %edi,%edx
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	e8 fa fa ff ff       	call   801db0 <printnum>
			break;
  8022b6:	e9 88 fc ff ff       	jmp    801f43 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8022bb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8022bf:	89 04 24             	mov    %eax,(%esp)
  8022c2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8022c5:	e9 79 fc ff ff       	jmp    801f43 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8022ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8022ce:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8022d5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8022d8:	89 f3                	mov    %esi,%ebx
  8022da:	eb 03                	jmp    8022df <vprintfmt+0x3c1>
  8022dc:	83 eb 01             	sub    $0x1,%ebx
  8022df:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8022e3:	75 f7                	jne    8022dc <vprintfmt+0x3be>
  8022e5:	e9 59 fc ff ff       	jmp    801f43 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8022ea:	83 c4 3c             	add    $0x3c,%esp
  8022ed:	5b                   	pop    %ebx
  8022ee:	5e                   	pop    %esi
  8022ef:	5f                   	pop    %edi
  8022f0:	5d                   	pop    %ebp
  8022f1:	c3                   	ret    

008022f2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
  8022f5:	83 ec 28             	sub    $0x28,%esp
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8022fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802301:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802305:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802308:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80230f:	85 c0                	test   %eax,%eax
  802311:	74 30                	je     802343 <vsnprintf+0x51>
  802313:	85 d2                	test   %edx,%edx
  802315:	7e 2c                	jle    802343 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802317:	8b 45 14             	mov    0x14(%ebp),%eax
  80231a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80231e:	8b 45 10             	mov    0x10(%ebp),%eax
  802321:	89 44 24 08          	mov    %eax,0x8(%esp)
  802325:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802328:	89 44 24 04          	mov    %eax,0x4(%esp)
  80232c:	c7 04 24 d9 1e 80 00 	movl   $0x801ed9,(%esp)
  802333:	e8 e6 fb ff ff       	call   801f1e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  802338:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	eb 05                	jmp    802348 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  802343:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  802348:	c9                   	leave  
  802349:	c3                   	ret    

0080234a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
  80234d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802350:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  802353:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802357:	8b 45 10             	mov    0x10(%ebp),%eax
  80235a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80235e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802361:	89 44 24 04          	mov    %eax,0x4(%esp)
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	89 04 24             	mov    %eax,(%esp)
  80236b:	e8 82 ff ff ff       	call   8022f2 <vsnprintf>
	va_end(ap);

	return rc;
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    
  802372:	66 90                	xchg   %ax,%ax
  802374:	66 90                	xchg   %ax,%ax
  802376:	66 90                	xchg   %ax,%ax
  802378:	66 90                	xchg   %ax,%ax
  80237a:	66 90                	xchg   %ax,%ax
  80237c:	66 90                	xchg   %ax,%ax
  80237e:	66 90                	xchg   %ax,%ax

00802380 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	56                   	push   %esi
  802384:	53                   	push   %ebx
  802385:	83 ec 10             	sub    $0x10,%esp
  802388:	8b 75 08             	mov    0x8(%ebp),%esi
  80238b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802391:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802393:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802398:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80239b:	89 04 24             	mov    %eax,(%esp)
  80239e:	e8 26 e4 ff ff       	call   8007c9 <sys_ipc_recv>
  8023a3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  8023a5:	85 d2                	test   %edx,%edx
  8023a7:	75 24                	jne    8023cd <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  8023a9:	85 f6                	test   %esi,%esi
  8023ab:	74 0a                	je     8023b7 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  8023ad:	a1 08 40 80 00       	mov    0x804008,%eax
  8023b2:	8b 40 74             	mov    0x74(%eax),%eax
  8023b5:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  8023b7:	85 db                	test   %ebx,%ebx
  8023b9:	74 0a                	je     8023c5 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  8023bb:	a1 08 40 80 00       	mov    0x804008,%eax
  8023c0:	8b 40 78             	mov    0x78(%eax),%eax
  8023c3:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8023c5:	a1 08 40 80 00       	mov    0x804008,%eax
  8023ca:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  8023cd:	83 c4 10             	add    $0x10,%esp
  8023d0:	5b                   	pop    %ebx
  8023d1:	5e                   	pop    %esi
  8023d2:	5d                   	pop    %ebp
  8023d3:	c3                   	ret    

008023d4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
  8023d7:	57                   	push   %edi
  8023d8:	56                   	push   %esi
  8023d9:	53                   	push   %ebx
  8023da:	83 ec 1c             	sub    $0x1c,%esp
  8023dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  8023e6:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  8023e8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023ed:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8023f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023fb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023ff:	89 3c 24             	mov    %edi,(%esp)
  802402:	e8 9f e3 ff ff       	call   8007a6 <sys_ipc_try_send>

		if (ret == 0)
  802407:	85 c0                	test   %eax,%eax
  802409:	74 2c                	je     802437 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80240b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80240e:	74 20                	je     802430 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802410:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802414:	c7 44 24 08 2c 2c 80 	movl   $0x802c2c,0x8(%esp)
  80241b:	00 
  80241c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802423:	00 
  802424:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  80242b:	e8 66 f8 ff ff       	call   801c96 <_panic>
		}

		sys_yield();
  802430:	e8 5f e1 ff ff       	call   800594 <sys_yield>
	}
  802435:	eb b9                	jmp    8023f0 <ipc_send+0x1c>
}
  802437:	83 c4 1c             	add    $0x1c,%esp
  80243a:	5b                   	pop    %ebx
  80243b:	5e                   	pop    %esi
  80243c:	5f                   	pop    %edi
  80243d:	5d                   	pop    %ebp
  80243e:	c3                   	ret    

0080243f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
  802442:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802445:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80244a:	89 c2                	mov    %eax,%edx
  80244c:	c1 e2 07             	shl    $0x7,%edx
  80244f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802456:	8b 52 50             	mov    0x50(%edx),%edx
  802459:	39 ca                	cmp    %ecx,%edx
  80245b:	75 11                	jne    80246e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80245d:	89 c2                	mov    %eax,%edx
  80245f:	c1 e2 07             	shl    $0x7,%edx
  802462:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802469:	8b 40 40             	mov    0x40(%eax),%eax
  80246c:	eb 0e                	jmp    80247c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80246e:	83 c0 01             	add    $0x1,%eax
  802471:	3d 00 04 00 00       	cmp    $0x400,%eax
  802476:	75 d2                	jne    80244a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802478:	66 b8 00 00          	mov    $0x0,%ax
}
  80247c:	5d                   	pop    %ebp
  80247d:	c3                   	ret    

0080247e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
  802481:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802484:	89 d0                	mov    %edx,%eax
  802486:	c1 e8 16             	shr    $0x16,%eax
  802489:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802490:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802495:	f6 c1 01             	test   $0x1,%cl
  802498:	74 1d                	je     8024b7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80249a:	c1 ea 0c             	shr    $0xc,%edx
  80249d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024a4:	f6 c2 01             	test   $0x1,%dl
  8024a7:	74 0e                	je     8024b7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024a9:	c1 ea 0c             	shr    $0xc,%edx
  8024ac:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024b3:	ef 
  8024b4:	0f b7 c0             	movzwl %ax,%eax
}
  8024b7:	5d                   	pop    %ebp
  8024b8:	c3                   	ret    
  8024b9:	66 90                	xchg   %ax,%ax
  8024bb:	66 90                	xchg   %ax,%ax
  8024bd:	66 90                	xchg   %ax,%ax
  8024bf:	90                   	nop

008024c0 <__udivdi3>:
  8024c0:	55                   	push   %ebp
  8024c1:	57                   	push   %edi
  8024c2:	56                   	push   %esi
  8024c3:	83 ec 0c             	sub    $0xc,%esp
  8024c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8024ca:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8024ce:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8024d2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024dc:	89 ea                	mov    %ebp,%edx
  8024de:	89 0c 24             	mov    %ecx,(%esp)
  8024e1:	75 2d                	jne    802510 <__udivdi3+0x50>
  8024e3:	39 e9                	cmp    %ebp,%ecx
  8024e5:	77 61                	ja     802548 <__udivdi3+0x88>
  8024e7:	85 c9                	test   %ecx,%ecx
  8024e9:	89 ce                	mov    %ecx,%esi
  8024eb:	75 0b                	jne    8024f8 <__udivdi3+0x38>
  8024ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f2:	31 d2                	xor    %edx,%edx
  8024f4:	f7 f1                	div    %ecx
  8024f6:	89 c6                	mov    %eax,%esi
  8024f8:	31 d2                	xor    %edx,%edx
  8024fa:	89 e8                	mov    %ebp,%eax
  8024fc:	f7 f6                	div    %esi
  8024fe:	89 c5                	mov    %eax,%ebp
  802500:	89 f8                	mov    %edi,%eax
  802502:	f7 f6                	div    %esi
  802504:	89 ea                	mov    %ebp,%edx
  802506:	83 c4 0c             	add    $0xc,%esp
  802509:	5e                   	pop    %esi
  80250a:	5f                   	pop    %edi
  80250b:	5d                   	pop    %ebp
  80250c:	c3                   	ret    
  80250d:	8d 76 00             	lea    0x0(%esi),%esi
  802510:	39 e8                	cmp    %ebp,%eax
  802512:	77 24                	ja     802538 <__udivdi3+0x78>
  802514:	0f bd e8             	bsr    %eax,%ebp
  802517:	83 f5 1f             	xor    $0x1f,%ebp
  80251a:	75 3c                	jne    802558 <__udivdi3+0x98>
  80251c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802520:	39 34 24             	cmp    %esi,(%esp)
  802523:	0f 86 9f 00 00 00    	jbe    8025c8 <__udivdi3+0x108>
  802529:	39 d0                	cmp    %edx,%eax
  80252b:	0f 82 97 00 00 00    	jb     8025c8 <__udivdi3+0x108>
  802531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802538:	31 d2                	xor    %edx,%edx
  80253a:	31 c0                	xor    %eax,%eax
  80253c:	83 c4 0c             	add    $0xc,%esp
  80253f:	5e                   	pop    %esi
  802540:	5f                   	pop    %edi
  802541:	5d                   	pop    %ebp
  802542:	c3                   	ret    
  802543:	90                   	nop
  802544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802548:	89 f8                	mov    %edi,%eax
  80254a:	f7 f1                	div    %ecx
  80254c:	31 d2                	xor    %edx,%edx
  80254e:	83 c4 0c             	add    $0xc,%esp
  802551:	5e                   	pop    %esi
  802552:	5f                   	pop    %edi
  802553:	5d                   	pop    %ebp
  802554:	c3                   	ret    
  802555:	8d 76 00             	lea    0x0(%esi),%esi
  802558:	89 e9                	mov    %ebp,%ecx
  80255a:	8b 3c 24             	mov    (%esp),%edi
  80255d:	d3 e0                	shl    %cl,%eax
  80255f:	89 c6                	mov    %eax,%esi
  802561:	b8 20 00 00 00       	mov    $0x20,%eax
  802566:	29 e8                	sub    %ebp,%eax
  802568:	89 c1                	mov    %eax,%ecx
  80256a:	d3 ef                	shr    %cl,%edi
  80256c:	89 e9                	mov    %ebp,%ecx
  80256e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802572:	8b 3c 24             	mov    (%esp),%edi
  802575:	09 74 24 08          	or     %esi,0x8(%esp)
  802579:	89 d6                	mov    %edx,%esi
  80257b:	d3 e7                	shl    %cl,%edi
  80257d:	89 c1                	mov    %eax,%ecx
  80257f:	89 3c 24             	mov    %edi,(%esp)
  802582:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802586:	d3 ee                	shr    %cl,%esi
  802588:	89 e9                	mov    %ebp,%ecx
  80258a:	d3 e2                	shl    %cl,%edx
  80258c:	89 c1                	mov    %eax,%ecx
  80258e:	d3 ef                	shr    %cl,%edi
  802590:	09 d7                	or     %edx,%edi
  802592:	89 f2                	mov    %esi,%edx
  802594:	89 f8                	mov    %edi,%eax
  802596:	f7 74 24 08          	divl   0x8(%esp)
  80259a:	89 d6                	mov    %edx,%esi
  80259c:	89 c7                	mov    %eax,%edi
  80259e:	f7 24 24             	mull   (%esp)
  8025a1:	39 d6                	cmp    %edx,%esi
  8025a3:	89 14 24             	mov    %edx,(%esp)
  8025a6:	72 30                	jb     8025d8 <__udivdi3+0x118>
  8025a8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025ac:	89 e9                	mov    %ebp,%ecx
  8025ae:	d3 e2                	shl    %cl,%edx
  8025b0:	39 c2                	cmp    %eax,%edx
  8025b2:	73 05                	jae    8025b9 <__udivdi3+0xf9>
  8025b4:	3b 34 24             	cmp    (%esp),%esi
  8025b7:	74 1f                	je     8025d8 <__udivdi3+0x118>
  8025b9:	89 f8                	mov    %edi,%eax
  8025bb:	31 d2                	xor    %edx,%edx
  8025bd:	e9 7a ff ff ff       	jmp    80253c <__udivdi3+0x7c>
  8025c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025c8:	31 d2                	xor    %edx,%edx
  8025ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8025cf:	e9 68 ff ff ff       	jmp    80253c <__udivdi3+0x7c>
  8025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025d8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8025db:	31 d2                	xor    %edx,%edx
  8025dd:	83 c4 0c             	add    $0xc,%esp
  8025e0:	5e                   	pop    %esi
  8025e1:	5f                   	pop    %edi
  8025e2:	5d                   	pop    %ebp
  8025e3:	c3                   	ret    
  8025e4:	66 90                	xchg   %ax,%ax
  8025e6:	66 90                	xchg   %ax,%ax
  8025e8:	66 90                	xchg   %ax,%ax
  8025ea:	66 90                	xchg   %ax,%ax
  8025ec:	66 90                	xchg   %ax,%ax
  8025ee:	66 90                	xchg   %ax,%ax

008025f0 <__umoddi3>:
  8025f0:	55                   	push   %ebp
  8025f1:	57                   	push   %edi
  8025f2:	56                   	push   %esi
  8025f3:	83 ec 14             	sub    $0x14,%esp
  8025f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025fa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025fe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802602:	89 c7                	mov    %eax,%edi
  802604:	89 44 24 04          	mov    %eax,0x4(%esp)
  802608:	8b 44 24 30          	mov    0x30(%esp),%eax
  80260c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802610:	89 34 24             	mov    %esi,(%esp)
  802613:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802617:	85 c0                	test   %eax,%eax
  802619:	89 c2                	mov    %eax,%edx
  80261b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80261f:	75 17                	jne    802638 <__umoddi3+0x48>
  802621:	39 fe                	cmp    %edi,%esi
  802623:	76 4b                	jbe    802670 <__umoddi3+0x80>
  802625:	89 c8                	mov    %ecx,%eax
  802627:	89 fa                	mov    %edi,%edx
  802629:	f7 f6                	div    %esi
  80262b:	89 d0                	mov    %edx,%eax
  80262d:	31 d2                	xor    %edx,%edx
  80262f:	83 c4 14             	add    $0x14,%esp
  802632:	5e                   	pop    %esi
  802633:	5f                   	pop    %edi
  802634:	5d                   	pop    %ebp
  802635:	c3                   	ret    
  802636:	66 90                	xchg   %ax,%ax
  802638:	39 f8                	cmp    %edi,%eax
  80263a:	77 54                	ja     802690 <__umoddi3+0xa0>
  80263c:	0f bd e8             	bsr    %eax,%ebp
  80263f:	83 f5 1f             	xor    $0x1f,%ebp
  802642:	75 5c                	jne    8026a0 <__umoddi3+0xb0>
  802644:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802648:	39 3c 24             	cmp    %edi,(%esp)
  80264b:	0f 87 e7 00 00 00    	ja     802738 <__umoddi3+0x148>
  802651:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802655:	29 f1                	sub    %esi,%ecx
  802657:	19 c7                	sbb    %eax,%edi
  802659:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80265d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802661:	8b 44 24 08          	mov    0x8(%esp),%eax
  802665:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802669:	83 c4 14             	add    $0x14,%esp
  80266c:	5e                   	pop    %esi
  80266d:	5f                   	pop    %edi
  80266e:	5d                   	pop    %ebp
  80266f:	c3                   	ret    
  802670:	85 f6                	test   %esi,%esi
  802672:	89 f5                	mov    %esi,%ebp
  802674:	75 0b                	jne    802681 <__umoddi3+0x91>
  802676:	b8 01 00 00 00       	mov    $0x1,%eax
  80267b:	31 d2                	xor    %edx,%edx
  80267d:	f7 f6                	div    %esi
  80267f:	89 c5                	mov    %eax,%ebp
  802681:	8b 44 24 04          	mov    0x4(%esp),%eax
  802685:	31 d2                	xor    %edx,%edx
  802687:	f7 f5                	div    %ebp
  802689:	89 c8                	mov    %ecx,%eax
  80268b:	f7 f5                	div    %ebp
  80268d:	eb 9c                	jmp    80262b <__umoddi3+0x3b>
  80268f:	90                   	nop
  802690:	89 c8                	mov    %ecx,%eax
  802692:	89 fa                	mov    %edi,%edx
  802694:	83 c4 14             	add    $0x14,%esp
  802697:	5e                   	pop    %esi
  802698:	5f                   	pop    %edi
  802699:	5d                   	pop    %ebp
  80269a:	c3                   	ret    
  80269b:	90                   	nop
  80269c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026a0:	8b 04 24             	mov    (%esp),%eax
  8026a3:	be 20 00 00 00       	mov    $0x20,%esi
  8026a8:	89 e9                	mov    %ebp,%ecx
  8026aa:	29 ee                	sub    %ebp,%esi
  8026ac:	d3 e2                	shl    %cl,%edx
  8026ae:	89 f1                	mov    %esi,%ecx
  8026b0:	d3 e8                	shr    %cl,%eax
  8026b2:	89 e9                	mov    %ebp,%ecx
  8026b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b8:	8b 04 24             	mov    (%esp),%eax
  8026bb:	09 54 24 04          	or     %edx,0x4(%esp)
  8026bf:	89 fa                	mov    %edi,%edx
  8026c1:	d3 e0                	shl    %cl,%eax
  8026c3:	89 f1                	mov    %esi,%ecx
  8026c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026c9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8026cd:	d3 ea                	shr    %cl,%edx
  8026cf:	89 e9                	mov    %ebp,%ecx
  8026d1:	d3 e7                	shl    %cl,%edi
  8026d3:	89 f1                	mov    %esi,%ecx
  8026d5:	d3 e8                	shr    %cl,%eax
  8026d7:	89 e9                	mov    %ebp,%ecx
  8026d9:	09 f8                	or     %edi,%eax
  8026db:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8026df:	f7 74 24 04          	divl   0x4(%esp)
  8026e3:	d3 e7                	shl    %cl,%edi
  8026e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026e9:	89 d7                	mov    %edx,%edi
  8026eb:	f7 64 24 08          	mull   0x8(%esp)
  8026ef:	39 d7                	cmp    %edx,%edi
  8026f1:	89 c1                	mov    %eax,%ecx
  8026f3:	89 14 24             	mov    %edx,(%esp)
  8026f6:	72 2c                	jb     802724 <__umoddi3+0x134>
  8026f8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8026fc:	72 22                	jb     802720 <__umoddi3+0x130>
  8026fe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802702:	29 c8                	sub    %ecx,%eax
  802704:	19 d7                	sbb    %edx,%edi
  802706:	89 e9                	mov    %ebp,%ecx
  802708:	89 fa                	mov    %edi,%edx
  80270a:	d3 e8                	shr    %cl,%eax
  80270c:	89 f1                	mov    %esi,%ecx
  80270e:	d3 e2                	shl    %cl,%edx
  802710:	89 e9                	mov    %ebp,%ecx
  802712:	d3 ef                	shr    %cl,%edi
  802714:	09 d0                	or     %edx,%eax
  802716:	89 fa                	mov    %edi,%edx
  802718:	83 c4 14             	add    $0x14,%esp
  80271b:	5e                   	pop    %esi
  80271c:	5f                   	pop    %edi
  80271d:	5d                   	pop    %ebp
  80271e:	c3                   	ret    
  80271f:	90                   	nop
  802720:	39 d7                	cmp    %edx,%edi
  802722:	75 da                	jne    8026fe <__umoddi3+0x10e>
  802724:	8b 14 24             	mov    (%esp),%edx
  802727:	89 c1                	mov    %eax,%ecx
  802729:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80272d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802731:	eb cb                	jmp    8026fe <__umoddi3+0x10e>
  802733:	90                   	nop
  802734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802738:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80273c:	0f 82 0f ff ff ff    	jb     802651 <__umoddi3+0x61>
  802742:	e9 1a ff ff ff       	jmp    802661 <__umoddi3+0x71>
