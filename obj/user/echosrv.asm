
obj/user/echosrv.debug:     file format elf32-i386


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
  80002c:	e8 fc 04 00 00       	call   80052d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  800039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80003d:	c7 04 24 d0 2b 80 00 	movl   $0x802bd0,(%esp)
  800044:	e8 ec 05 00 00       	call   800635 <cprintf>
	exit();
  800049:	e8 2b 05 00 00       	call   800579 <exit>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <handle_client>:

void
handle_client(int sock)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	57                   	push   %edi
  800054:	56                   	push   %esi
  800055:	53                   	push   %ebx
  800056:	83 ec 3c             	sub    $0x3c,%esp
  800059:	8b 75 08             	mov    0x8(%ebp),%esi
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005c:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  800063:	00 
  800064:	8d 45 c8             	lea    -0x38(%ebp),%eax
  800067:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006b:	89 34 24             	mov    %esi,(%esp)
  80006e:	e8 37 17 00 00       	call   8017aa <read>
  800073:	89 c3                	mov    %eax,%ebx
  800075:	85 c0                	test   %eax,%eax
  800077:	78 05                	js     80007e <handle_client+0x2e>
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  800079:	8d 7d c8             	lea    -0x38(%ebp),%edi
  80007c:	eb 4e                	jmp    8000cc <handle_client+0x7c>
{
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");
  80007e:	b8 d4 2b 80 00       	mov    $0x802bd4,%eax
  800083:	e8 ab ff ff ff       	call   800033 <die>
  800088:	eb ef                	jmp    800079 <handle_client+0x29>

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  80008a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80008e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800092:	89 34 24             	mov    %esi,(%esp)
  800095:	e8 ed 17 00 00       	call   801887 <write>
  80009a:	39 d8                	cmp    %ebx,%eax
  80009c:	74 0a                	je     8000a8 <handle_client+0x58>
			die("Failed to send bytes to client");
  80009e:	b8 00 2c 80 00       	mov    $0x802c00,%eax
  8000a3:	e8 8b ff ff ff       	call   800033 <die>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  8000a8:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  8000af:	00 
  8000b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8000b4:	89 34 24             	mov    %esi,(%esp)
  8000b7:	e8 ee 16 00 00       	call   8017aa <read>
  8000bc:	89 c3                	mov    %eax,%ebx
  8000be:	85 c0                	test   %eax,%eax
  8000c0:	79 0a                	jns    8000cc <handle_client+0x7c>
			die("Failed to receive additional bytes from client");
  8000c2:	b8 20 2c 80 00       	mov    $0x802c20,%eax
  8000c7:	e8 67 ff ff ff       	call   800033 <die>
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  8000cc:	85 db                	test   %ebx,%ebx
  8000ce:	7f ba                	jg     80008a <handle_client+0x3a>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 6f 15 00 00       	call   801647 <close>
}
  8000d8:	83 c4 3c             	add    $0x3c,%esp
  8000db:	5b                   	pop    %ebx
  8000dc:	5e                   	pop    %esi
  8000dd:	5f                   	pop    %edi
  8000de:	5d                   	pop    %ebp
  8000df:	c3                   	ret    

008000e0 <umain>:

void
umain(int argc, char **argv)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	57                   	push   %edi
  8000e4:	56                   	push   %esi
  8000e5:	53                   	push   %ebx
  8000e6:	83 ec 4c             	sub    $0x4c,%esp
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000e9:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8000f0:	00 
  8000f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8000f8:	00 
  8000f9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800100:	e8 42 1e 00 00       	call   801f47 <socket>
  800105:	89 c6                	mov    %eax,%esi
  800107:	85 c0                	test   %eax,%eax
  800109:	79 0a                	jns    800115 <umain+0x35>
		die("Failed to create socket");
  80010b:	b8 80 2b 80 00       	mov    $0x802b80,%eax
  800110:	e8 1e ff ff ff       	call   800033 <die>

	cprintf("opened socket\n");
  800115:	c7 04 24 98 2b 80 00 	movl   $0x802b98,(%esp)
  80011c:	e8 14 05 00 00       	call   800635 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800121:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800128:	00 
  800129:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800130:	00 
  800131:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  800134:	89 1c 24             	mov    %ebx,(%esp)
  800137:	e8 6b 0c 00 00       	call   800da7 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  80013c:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  800140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800147:	e8 94 01 00 00       	call   8002e0 <htonl>
  80014c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  80014f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800156:	e8 6b 01 00 00       	call   8002c6 <htons>
  80015b:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to bind\n");
  80015f:	c7 04 24 a7 2b 80 00 	movl   $0x802ba7,(%esp)
  800166:	e8 ca 04 00 00       	call   800635 <cprintf>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  80016b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800172:	00 
  800173:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800177:	89 34 24             	mov    %esi,(%esp)
  80017a:	e8 26 1d 00 00       	call   801ea5 <bind>
  80017f:	85 c0                	test   %eax,%eax
  800181:	79 0a                	jns    80018d <umain+0xad>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
  800183:	b8 50 2c 80 00       	mov    $0x802c50,%eax
  800188:	e8 a6 fe ff ff       	call   800033 <die>
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  80018d:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  800194:	00 
  800195:	89 34 24             	mov    %esi,(%esp)
  800198:	e8 85 1d 00 00       	call   801f22 <listen>
  80019d:	85 c0                	test   %eax,%eax
  80019f:	79 0a                	jns    8001ab <umain+0xcb>
		die("Failed to listen on server socket");
  8001a1:	b8 74 2c 80 00       	mov    $0x802c74,%eax
  8001a6:	e8 88 fe ff ff       	call   800033 <die>

	cprintf("bound\n");
  8001ab:	c7 04 24 b7 2b 80 00 	movl   $0x802bb7,(%esp)
  8001b2:	e8 7e 04 00 00       	call   800635 <cprintf>

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
  8001b7:	8d 7d c4             	lea    -0x3c(%ebp),%edi

	cprintf("bound\n");

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
  8001ba:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		// Wait for client connection
		if ((clientsock =
  8001c1:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8001c5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001cc:	89 34 24             	mov    %esi,(%esp)
  8001cf:	e8 96 1c 00 00       	call   801e6a <accept>
  8001d4:	89 c3                	mov    %eax,%ebx
  8001d6:	85 c0                	test   %eax,%eax
  8001d8:	79 0a                	jns    8001e4 <umain+0x104>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8001da:	b8 98 2c 80 00       	mov    $0x802c98,%eax
  8001df:	e8 4f fe ff ff       	call   800033 <die>
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8001e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001e7:	89 04 24             	mov    %eax,(%esp)
  8001ea:	e8 21 00 00 00       	call   800210 <inet_ntoa>
  8001ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f3:	c7 04 24 be 2b 80 00 	movl   $0x802bbe,(%esp)
  8001fa:	e8 36 04 00 00       	call   800635 <cprintf>
		handle_client(clientsock);
  8001ff:	89 1c 24             	mov    %ebx,(%esp)
  800202:	e8 49 fe ff ff       	call   800050 <handle_client>
	}
  800207:	eb b1                	jmp    8001ba <umain+0xda>
  800209:	66 90                	xchg   %ax,%ax
  80020b:	66 90                	xchg   %ax,%ax
  80020d:	66 90                	xchg   %ax,%ax
  80020f:	90                   	nop

00800210 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	57                   	push   %edi
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	83 ec 19             	sub    $0x19,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800219:	8b 45 08             	mov    0x8(%ebp),%eax
  80021c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80021f:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800223:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  800226:	c7 45 dc 00 50 80 00 	movl   $0x805000,-0x24(%ebp)
 */
char *
inet_ntoa(struct in_addr addr)
{
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80022d:	be 00 00 00 00       	mov    $0x0,%esi
  800232:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800235:	eb 02                	jmp    800239 <inet_ntoa+0x29>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800237:	89 ce                	mov    %ecx,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800239:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80023c:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  80023f:	0f b6 c2             	movzbl %dl,%eax
  800242:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  800245:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
  800248:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80024b:	66 c1 e8 0b          	shr    $0xb,%ax
  80024f:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  800251:	8d 4e 01             	lea    0x1(%esi),%ecx
  800254:	89 f3                	mov    %esi,%ebx
  800256:	0f b6 f3             	movzbl %bl,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800259:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  80025c:	01 ff                	add    %edi,%edi
  80025e:	89 fb                	mov    %edi,%ebx
  800260:	29 da                	sub    %ebx,%edx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
  800262:	83 c2 30             	add    $0x30,%edx
  800265:	88 54 35 ed          	mov    %dl,-0x13(%ebp,%esi,1)
    } while(*ap);
  800269:	84 c0                	test   %al,%al
  80026b:	75 ca                	jne    800237 <inet_ntoa+0x27>
  80026d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800270:	89 c8                	mov    %ecx,%eax
  800272:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800275:	89 cf                	mov    %ecx,%edi
  800277:	eb 0d                	jmp    800286 <inet_ntoa+0x76>
    while(i--)
      *rp++ = inv[i];
  800279:	0f b6 f0             	movzbl %al,%esi
  80027c:	0f b6 4c 35 ed       	movzbl -0x13(%ebp,%esi,1),%ecx
  800281:	88 0a                	mov    %cl,(%edx)
  800283:	83 c2 01             	add    $0x1,%edx
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  800286:	83 e8 01             	sub    $0x1,%eax
  800289:	3c ff                	cmp    $0xff,%al
  80028b:	75 ec                	jne    800279 <inet_ntoa+0x69>
  80028d:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800290:	89 f9                	mov    %edi,%ecx
  800292:	0f b6 c9             	movzbl %cl,%ecx
  800295:	03 4d dc             	add    -0x24(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  800298:	8d 41 01             	lea    0x1(%ecx),%eax
  80029b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    ap++;
  80029e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8002a2:	80 45 db 01          	addb   $0x1,-0x25(%ebp)
  8002a6:	80 7d db 03          	cmpb   $0x3,-0x25(%ebp)
  8002aa:	77 0a                	ja     8002b6 <inet_ntoa+0xa6>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  8002ac:	c6 01 2e             	movb   $0x2e,(%ecx)
  8002af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b4:	eb 81                	jmp    800237 <inet_ntoa+0x27>
    ap++;
  }
  *--rp = 0;
  8002b6:	c6 01 00             	movb   $0x0,(%ecx)
  return str;
}
  8002b9:	b8 00 50 80 00       	mov    $0x805000,%eax
  8002be:	83 c4 19             	add    $0x19,%esp
  8002c1:	5b                   	pop    %ebx
  8002c2:	5e                   	pop    %esi
  8002c3:	5f                   	pop    %edi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002c9:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002cd:	66 c1 c0 08          	rol    $0x8,%ax
}
  8002d1:	5d                   	pop    %ebp
  8002d2:	c3                   	ret    

008002d3 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002d6:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002da:	66 c1 c0 08          	rol    $0x8,%ax
 */
u16_t
ntohs(u16_t n)
{
  return htons(n);
}
  8002de:	5d                   	pop    %ebp
  8002df:	c3                   	ret    

008002e0 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8002e6:	89 d1                	mov    %edx,%ecx
  8002e8:	c1 e9 18             	shr    $0x18,%ecx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8002eb:	89 d0                	mov    %edx,%eax
  8002ed:	c1 e0 18             	shl    $0x18,%eax
  8002f0:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002f2:	89 d1                	mov    %edx,%ecx
  8002f4:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  8002fa:	c1 e1 08             	shl    $0x8,%ecx
  8002fd:	09 c8                	or     %ecx,%eax
    ((n & 0xff0000UL) >> 8) |
  8002ff:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  800305:	c1 ea 08             	shr    $0x8,%edx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  800308:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80030a:	5d                   	pop    %ebp
  80030b:	c3                   	ret    

0080030c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
  80030f:	57                   	push   %edi
  800310:	56                   	push   %esi
  800311:	53                   	push   %ebx
  800312:	83 ec 20             	sub    $0x20,%esp
  800315:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  800318:	0f be 10             	movsbl (%eax),%edx
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80031b:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80031e:	89 75 d8             	mov    %esi,-0x28(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800321:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800324:	80 f9 09             	cmp    $0x9,%cl
  800327:	0f 87 a6 01 00 00    	ja     8004d3 <inet_aton+0x1c7>
      return (0);
    val = 0;
    base = 10;
  80032d:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
    if (c == '0') {
  800334:	83 fa 30             	cmp    $0x30,%edx
  800337:	75 2b                	jne    800364 <inet_aton+0x58>
      c = *++cp;
  800339:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80033d:	89 d1                	mov    %edx,%ecx
  80033f:	83 e1 df             	and    $0xffffffdf,%ecx
  800342:	80 f9 58             	cmp    $0x58,%cl
  800345:	74 0f                	je     800356 <inet_aton+0x4a>
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
  800347:	83 c0 01             	add    $0x1,%eax
  80034a:	0f be d2             	movsbl %dl,%edx
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
      } else
        base = 8;
  80034d:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  800354:	eb 0e                	jmp    800364 <inet_aton+0x58>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  800356:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80035a:	8d 40 02             	lea    0x2(%eax),%eax
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  80035d:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  800364:	83 c0 01             	add    $0x1,%eax
  800367:	bf 00 00 00 00       	mov    $0x0,%edi
  80036c:	eb 03                	jmp    800371 <inet_aton+0x65>
  80036e:	83 c0 01             	add    $0x1,%eax
  800371:	8d 70 ff             	lea    -0x1(%eax),%esi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  800374:	89 d3                	mov    %edx,%ebx
  800376:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800379:	80 f9 09             	cmp    $0x9,%cl
  80037c:	77 0d                	ja     80038b <inet_aton+0x7f>
        val = (val * base) + (int)(c - '0');
  80037e:	0f af 7d e0          	imul   -0x20(%ebp),%edi
  800382:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800386:	0f be 10             	movsbl (%eax),%edx
  800389:	eb e3                	jmp    80036e <inet_aton+0x62>
      } else if (base == 16 && isxdigit(c)) {
  80038b:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  80038f:	75 30                	jne    8003c1 <inet_aton+0xb5>
  800391:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  800394:	88 4d df             	mov    %cl,-0x21(%ebp)
  800397:	89 d1                	mov    %edx,%ecx
  800399:	83 e1 df             	and    $0xffffffdf,%ecx
  80039c:	83 e9 41             	sub    $0x41,%ecx
  80039f:	80 f9 05             	cmp    $0x5,%cl
  8003a2:	77 23                	ja     8003c7 <inet_aton+0xbb>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8003a4:	89 fb                	mov    %edi,%ebx
  8003a6:	c1 e3 04             	shl    $0x4,%ebx
  8003a9:	8d 7a 0a             	lea    0xa(%edx),%edi
  8003ac:	80 7d df 1a          	cmpb   $0x1a,-0x21(%ebp)
  8003b0:	19 c9                	sbb    %ecx,%ecx
  8003b2:	83 e1 20             	and    $0x20,%ecx
  8003b5:	83 c1 41             	add    $0x41,%ecx
  8003b8:	29 cf                	sub    %ecx,%edi
  8003ba:	09 df                	or     %ebx,%edi
        c = *++cp;
  8003bc:	0f be 10             	movsbl (%eax),%edx
  8003bf:	eb ad                	jmp    80036e <inet_aton+0x62>
  8003c1:	89 d0                	mov    %edx,%eax
  8003c3:	89 f9                	mov    %edi,%ecx
  8003c5:	eb 04                	jmp    8003cb <inet_aton+0xbf>
  8003c7:	89 d0                	mov    %edx,%eax
  8003c9:	89 f9                	mov    %edi,%ecx
      } else
        break;
    }
    if (c == '.') {
  8003cb:	83 f8 2e             	cmp    $0x2e,%eax
  8003ce:	75 22                	jne    8003f2 <inet_aton+0xe6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8003d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8003d3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8003d6:	0f 84 fe 00 00 00    	je     8004da <inet_aton+0x1ce>
        return (0);
      *pp++ = val;
  8003dc:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  8003e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e3:	89 48 fc             	mov    %ecx,-0x4(%eax)
      c = *++cp;
  8003e6:	8d 46 01             	lea    0x1(%esi),%eax
  8003e9:	0f be 56 01          	movsbl 0x1(%esi),%edx
    } else
      break;
  }
  8003ed:	e9 2f ff ff ff       	jmp    800321 <inet_aton+0x15>
  8003f2:	89 f9                	mov    %edi,%ecx
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003f4:	85 d2                	test   %edx,%edx
  8003f6:	74 27                	je     80041f <inet_aton+0x113>
    return (0);
  8003f8:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003fd:	80 fb 1f             	cmp    $0x1f,%bl
  800400:	0f 86 e7 00 00 00    	jbe    8004ed <inet_aton+0x1e1>
  800406:	84 d2                	test   %dl,%dl
  800408:	0f 88 d3 00 00 00    	js     8004e1 <inet_aton+0x1d5>
  80040e:	83 fa 20             	cmp    $0x20,%edx
  800411:	74 0c                	je     80041f <inet_aton+0x113>
  800413:	83 ea 09             	sub    $0x9,%edx
  800416:	83 fa 04             	cmp    $0x4,%edx
  800419:	0f 87 ce 00 00 00    	ja     8004ed <inet_aton+0x1e1>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80041f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800422:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800425:	29 c2                	sub    %eax,%edx
  800427:	c1 fa 02             	sar    $0x2,%edx
  80042a:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80042d:	83 fa 02             	cmp    $0x2,%edx
  800430:	74 22                	je     800454 <inet_aton+0x148>
  800432:	83 fa 02             	cmp    $0x2,%edx
  800435:	7f 0f                	jg     800446 <inet_aton+0x13a>

  case 0:
    return (0);       /* initial nondigit */
  800437:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  80043c:	85 d2                	test   %edx,%edx
  80043e:	0f 84 a9 00 00 00    	je     8004ed <inet_aton+0x1e1>
  800444:	eb 73                	jmp    8004b9 <inet_aton+0x1ad>
  800446:	83 fa 03             	cmp    $0x3,%edx
  800449:	74 26                	je     800471 <inet_aton+0x165>
  80044b:	83 fa 04             	cmp    $0x4,%edx
  80044e:	66 90                	xchg   %ax,%ax
  800450:	74 40                	je     800492 <inet_aton+0x186>
  800452:	eb 65                	jmp    8004b9 <inet_aton+0x1ad>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  800454:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  800459:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  80045f:	0f 87 88 00 00 00    	ja     8004ed <inet_aton+0x1e1>
      return (0);
    val |= parts[0] << 24;
  800465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800468:	c1 e0 18             	shl    $0x18,%eax
  80046b:	89 cf                	mov    %ecx,%edi
  80046d:	09 c7                	or     %eax,%edi
    break;
  80046f:	eb 48                	jmp    8004b9 <inet_aton+0x1ad>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  800471:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  800476:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  80047c:	77 6f                	ja     8004ed <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  80047e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800481:	c1 e2 10             	shl    $0x10,%edx
  800484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800487:	c1 e0 18             	shl    $0x18,%eax
  80048a:	09 d0                	or     %edx,%eax
  80048c:	09 c8                	or     %ecx,%eax
  80048e:	89 c7                	mov    %eax,%edi
    break;
  800490:	eb 27                	jmp    8004b9 <inet_aton+0x1ad>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  800492:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  800497:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
  80049d:	77 4e                	ja     8004ed <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80049f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a2:	c1 e2 10             	shl    $0x10,%edx
  8004a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a8:	c1 e0 18             	shl    $0x18,%eax
  8004ab:	09 c2                	or     %eax,%edx
  8004ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004b0:	c1 e0 08             	shl    $0x8,%eax
  8004b3:	09 d0                	or     %edx,%eax
  8004b5:	09 c8                	or     %ecx,%eax
  8004b7:	89 c7                	mov    %eax,%edi
    break;
  }
  if (addr)
  8004b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004bd:	74 29                	je     8004e8 <inet_aton+0x1dc>
    addr->s_addr = htonl(val);
  8004bf:	89 3c 24             	mov    %edi,(%esp)
  8004c2:	e8 19 fe ff ff       	call   8002e0 <htonl>
  8004c7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004ca:	89 06                	mov    %eax,(%esi)
  return (1);
  8004cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8004d1:	eb 1a                	jmp    8004ed <inet_aton+0x1e1>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  8004d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d8:	eb 13                	jmp    8004ed <inet_aton+0x1e1>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  8004da:	b8 00 00 00 00       	mov    $0x0,%eax
  8004df:	eb 0c                	jmp    8004ed <inet_aton+0x1e1>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  8004e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e6:	eb 05                	jmp    8004ed <inet_aton+0x1e1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  8004e8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8004ed:	83 c4 20             	add    $0x20,%esp
  8004f0:	5b                   	pop    %ebx
  8004f1:	5e                   	pop    %esi
  8004f2:	5f                   	pop    %edi
  8004f3:	5d                   	pop    %ebp
  8004f4:	c3                   	ret    

008004f5 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8004fb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8004fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800502:	8b 45 08             	mov    0x8(%ebp),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	e8 ff fd ff ff       	call   80030c <inet_aton>
  80050d:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80050f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800514:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  800518:	c9                   	leave  
  800519:	c3                   	ret    

0080051a <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	89 04 24             	mov    %eax,(%esp)
  800526:	e8 b5 fd ff ff       	call   8002e0 <htonl>
}
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	56                   	push   %esi
  800531:	53                   	push   %ebx
  800532:	83 ec 10             	sub    $0x10,%esp
  800535:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800538:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  80053b:	e8 f5 0a 00 00       	call   801035 <sys_getenvid>
  800540:	25 ff 03 00 00       	and    $0x3ff,%eax
  800545:	89 c2                	mov    %eax,%edx
  800547:	c1 e2 07             	shl    $0x7,%edx
  80054a:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800551:	a3 18 50 80 00       	mov    %eax,0x805018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800556:	85 db                	test   %ebx,%ebx
  800558:	7e 07                	jle    800561 <libmain+0x34>
		binaryname = argv[0];
  80055a:	8b 06                	mov    (%esi),%eax
  80055c:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800561:	89 74 24 04          	mov    %esi,0x4(%esp)
  800565:	89 1c 24             	mov    %ebx,(%esp)
  800568:	e8 73 fb ff ff       	call   8000e0 <umain>

	// exit gracefully
	exit();
  80056d:	e8 07 00 00 00       	call   800579 <exit>
}
  800572:	83 c4 10             	add    $0x10,%esp
  800575:	5b                   	pop    %ebx
  800576:	5e                   	pop    %esi
  800577:	5d                   	pop    %ebp
  800578:	c3                   	ret    

00800579 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800579:	55                   	push   %ebp
  80057a:	89 e5                	mov    %esp,%ebp
  80057c:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80057f:	e8 f6 10 00 00       	call   80167a <close_all>
	sys_env_destroy(0);
  800584:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80058b:	e8 53 0a 00 00       	call   800fe3 <sys_env_destroy>
}
  800590:	c9                   	leave  
  800591:	c3                   	ret    

00800592 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	53                   	push   %ebx
  800596:	83 ec 14             	sub    $0x14,%esp
  800599:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80059c:	8b 13                	mov    (%ebx),%edx
  80059e:	8d 42 01             	lea    0x1(%edx),%eax
  8005a1:	89 03                	mov    %eax,(%ebx)
  8005a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005a6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8005aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005af:	75 19                	jne    8005ca <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8005b1:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8005b8:	00 
  8005b9:	8d 43 08             	lea    0x8(%ebx),%eax
  8005bc:	89 04 24             	mov    %eax,(%esp)
  8005bf:	e8 e2 09 00 00       	call   800fa6 <sys_cputs>
		b->idx = 0;
  8005c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8005ca:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8005ce:	83 c4 14             	add    $0x14,%esp
  8005d1:	5b                   	pop    %ebx
  8005d2:	5d                   	pop    %ebp
  8005d3:	c3                   	ret    

008005d4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8005dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005e4:	00 00 00 
	b.cnt = 0;
  8005e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005ee:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800605:	89 44 24 04          	mov    %eax,0x4(%esp)
  800609:	c7 04 24 92 05 80 00 	movl   $0x800592,(%esp)
  800610:	e8 a9 01 00 00       	call   8007be <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800615:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80061b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800625:	89 04 24             	mov    %eax,(%esp)
  800628:	e8 79 09 00 00       	call   800fa6 <sys_cputs>

	return b.cnt;
}
  80062d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800633:	c9                   	leave  
  800634:	c3                   	ret    

00800635 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
  800638:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80063b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80063e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800642:	8b 45 08             	mov    0x8(%ebp),%eax
  800645:	89 04 24             	mov    %eax,(%esp)
  800648:	e8 87 ff ff ff       	call   8005d4 <vcprintf>
	va_end(ap);

	return cnt;
}
  80064d:	c9                   	leave  
  80064e:	c3                   	ret    
  80064f:	90                   	nop

00800650 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800650:	55                   	push   %ebp
  800651:	89 e5                	mov    %esp,%ebp
  800653:	57                   	push   %edi
  800654:	56                   	push   %esi
  800655:	53                   	push   %ebx
  800656:	83 ec 3c             	sub    $0x3c,%esp
  800659:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80065c:	89 d7                	mov    %edx,%edi
  80065e:	8b 45 08             	mov    0x8(%ebp),%eax
  800661:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800664:	8b 45 0c             	mov    0xc(%ebp),%eax
  800667:	89 c3                	mov    %eax,%ebx
  800669:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80066c:	8b 45 10             	mov    0x10(%ebp),%eax
  80066f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800672:	b9 00 00 00 00       	mov    $0x0,%ecx
  800677:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80067d:	39 d9                	cmp    %ebx,%ecx
  80067f:	72 05                	jb     800686 <printnum+0x36>
  800681:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800684:	77 69                	ja     8006ef <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800686:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800689:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80068d:	83 ee 01             	sub    $0x1,%esi
  800690:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800694:	89 44 24 08          	mov    %eax,0x8(%esp)
  800698:	8b 44 24 08          	mov    0x8(%esp),%eax
  80069c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8006a0:	89 c3                	mov    %eax,%ebx
  8006a2:	89 d6                	mov    %edx,%esi
  8006a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8006ae:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8006b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b5:	89 04 24             	mov    %eax,(%esp)
  8006b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006bf:	e8 2c 22 00 00       	call   8028f0 <__udivdi3>
  8006c4:	89 d9                	mov    %ebx,%ecx
  8006c6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006ca:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006ce:	89 04 24             	mov    %eax,(%esp)
  8006d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006d5:	89 fa                	mov    %edi,%edx
  8006d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006da:	e8 71 ff ff ff       	call   800650 <printnum>
  8006df:	eb 1b                	jmp    8006fc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006e1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e8:	89 04 24             	mov    %eax,(%esp)
  8006eb:	ff d3                	call   *%ebx
  8006ed:	eb 03                	jmp    8006f2 <printnum+0xa2>
  8006ef:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f2:	83 ee 01             	sub    $0x1,%esi
  8006f5:	85 f6                	test   %esi,%esi
  8006f7:	7f e8                	jg     8006e1 <printnum+0x91>
  8006f9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800700:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800704:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800707:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80070a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80070e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800712:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800715:	89 04 24             	mov    %eax,(%esp)
  800718:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80071b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071f:	e8 fc 22 00 00       	call   802a20 <__umoddi3>
  800724:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800728:	0f be 80 c5 2c 80 00 	movsbl 0x802cc5(%eax),%eax
  80072f:	89 04 24             	mov    %eax,(%esp)
  800732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800735:	ff d0                	call   *%eax
}
  800737:	83 c4 3c             	add    $0x3c,%esp
  80073a:	5b                   	pop    %ebx
  80073b:	5e                   	pop    %esi
  80073c:	5f                   	pop    %edi
  80073d:	5d                   	pop    %ebp
  80073e:	c3                   	ret    

0080073f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80073f:	55                   	push   %ebp
  800740:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800742:	83 fa 01             	cmp    $0x1,%edx
  800745:	7e 0e                	jle    800755 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800747:	8b 10                	mov    (%eax),%edx
  800749:	8d 4a 08             	lea    0x8(%edx),%ecx
  80074c:	89 08                	mov    %ecx,(%eax)
  80074e:	8b 02                	mov    (%edx),%eax
  800750:	8b 52 04             	mov    0x4(%edx),%edx
  800753:	eb 22                	jmp    800777 <getuint+0x38>
	else if (lflag)
  800755:	85 d2                	test   %edx,%edx
  800757:	74 10                	je     800769 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800759:	8b 10                	mov    (%eax),%edx
  80075b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80075e:	89 08                	mov    %ecx,(%eax)
  800760:	8b 02                	mov    (%edx),%eax
  800762:	ba 00 00 00 00       	mov    $0x0,%edx
  800767:	eb 0e                	jmp    800777 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800769:	8b 10                	mov    (%eax),%edx
  80076b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80076e:	89 08                	mov    %ecx,(%eax)
  800770:	8b 02                	mov    (%edx),%eax
  800772:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800777:	5d                   	pop    %ebp
  800778:	c3                   	ret    

00800779 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80077f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800783:	8b 10                	mov    (%eax),%edx
  800785:	3b 50 04             	cmp    0x4(%eax),%edx
  800788:	73 0a                	jae    800794 <sprintputch+0x1b>
		*b->buf++ = ch;
  80078a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80078d:	89 08                	mov    %ecx,(%eax)
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	88 02                	mov    %al,(%edx)
}
  800794:	5d                   	pop    %ebp
  800795:	c3                   	ret    

00800796 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800796:	55                   	push   %ebp
  800797:	89 e5                	mov    %esp,%ebp
  800799:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80079c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80079f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	89 04 24             	mov    %eax,(%esp)
  8007b7:	e8 02 00 00 00       	call   8007be <vprintfmt>
	va_end(ap);
}
  8007bc:	c9                   	leave  
  8007bd:	c3                   	ret    

008007be <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007be:	55                   	push   %ebp
  8007bf:	89 e5                	mov    %esp,%ebp
  8007c1:	57                   	push   %edi
  8007c2:	56                   	push   %esi
  8007c3:	53                   	push   %ebx
  8007c4:	83 ec 3c             	sub    $0x3c,%esp
  8007c7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007cd:	eb 14                	jmp    8007e3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8007cf:	85 c0                	test   %eax,%eax
  8007d1:	0f 84 b3 03 00 00    	je     800b8a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8007d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007db:	89 04 24             	mov    %eax,(%esp)
  8007de:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e1:	89 f3                	mov    %esi,%ebx
  8007e3:	8d 73 01             	lea    0x1(%ebx),%esi
  8007e6:	0f b6 03             	movzbl (%ebx),%eax
  8007e9:	83 f8 25             	cmp    $0x25,%eax
  8007ec:	75 e1                	jne    8007cf <vprintfmt+0x11>
  8007ee:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8007f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8007f9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800800:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800807:	ba 00 00 00 00       	mov    $0x0,%edx
  80080c:	eb 1d                	jmp    80082b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80080e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800810:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800814:	eb 15                	jmp    80082b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800816:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800818:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80081c:	eb 0d                	jmp    80082b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80081e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800821:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800824:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80082b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80082e:	0f b6 0e             	movzbl (%esi),%ecx
  800831:	0f b6 c1             	movzbl %cl,%eax
  800834:	83 e9 23             	sub    $0x23,%ecx
  800837:	80 f9 55             	cmp    $0x55,%cl
  80083a:	0f 87 2a 03 00 00    	ja     800b6a <vprintfmt+0x3ac>
  800840:	0f b6 c9             	movzbl %cl,%ecx
  800843:	ff 24 8d 40 2e 80 00 	jmp    *0x802e40(,%ecx,4)
  80084a:	89 de                	mov    %ebx,%esi
  80084c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800851:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800854:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800858:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80085b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80085e:	83 fb 09             	cmp    $0x9,%ebx
  800861:	77 36                	ja     800899 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800863:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800866:	eb e9                	jmp    800851 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8d 48 04             	lea    0x4(%eax),%ecx
  80086e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800871:	8b 00                	mov    (%eax),%eax
  800873:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800876:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800878:	eb 22                	jmp    80089c <vprintfmt+0xde>
  80087a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80087d:	85 c9                	test   %ecx,%ecx
  80087f:	b8 00 00 00 00       	mov    $0x0,%eax
  800884:	0f 49 c1             	cmovns %ecx,%eax
  800887:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80088a:	89 de                	mov    %ebx,%esi
  80088c:	eb 9d                	jmp    80082b <vprintfmt+0x6d>
  80088e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800890:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800897:	eb 92                	jmp    80082b <vprintfmt+0x6d>
  800899:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80089c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008a0:	79 89                	jns    80082b <vprintfmt+0x6d>
  8008a2:	e9 77 ff ff ff       	jmp    80081e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008a7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008aa:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8008ac:	e9 7a ff ff ff       	jmp    80082b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	8d 50 04             	lea    0x4(%eax),%edx
  8008b7:	89 55 14             	mov    %edx,0x14(%ebp)
  8008ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	89 04 24             	mov    %eax,(%esp)
  8008c3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008c6:	e9 18 ff ff ff       	jmp    8007e3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	8d 50 04             	lea    0x4(%eax),%edx
  8008d1:	89 55 14             	mov    %edx,0x14(%ebp)
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	99                   	cltd   
  8008d7:	31 d0                	xor    %edx,%eax
  8008d9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008db:	83 f8 12             	cmp    $0x12,%eax
  8008de:	7f 0b                	jg     8008eb <vprintfmt+0x12d>
  8008e0:	8b 14 85 a0 2f 80 00 	mov    0x802fa0(,%eax,4),%edx
  8008e7:	85 d2                	test   %edx,%edx
  8008e9:	75 20                	jne    80090b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8008eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008ef:	c7 44 24 08 dd 2c 80 	movl   $0x802cdd,0x8(%esp)
  8008f6:	00 
  8008f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 04 24             	mov    %eax,(%esp)
  800901:	e8 90 fe ff ff       	call   800796 <printfmt>
  800906:	e9 d8 fe ff ff       	jmp    8007e3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80090b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80090f:	c7 44 24 08 e1 30 80 	movl   $0x8030e1,0x8(%esp)
  800916:	00 
  800917:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	89 04 24             	mov    %eax,(%esp)
  800921:	e8 70 fe ff ff       	call   800796 <printfmt>
  800926:	e9 b8 fe ff ff       	jmp    8007e3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80092b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80092e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800931:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	8d 50 04             	lea    0x4(%eax),%edx
  80093a:	89 55 14             	mov    %edx,0x14(%ebp)
  80093d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80093f:	85 f6                	test   %esi,%esi
  800941:	b8 d6 2c 80 00       	mov    $0x802cd6,%eax
  800946:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800949:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80094d:	0f 84 97 00 00 00    	je     8009ea <vprintfmt+0x22c>
  800953:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800957:	0f 8e 9b 00 00 00    	jle    8009f8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80095d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800961:	89 34 24             	mov    %esi,(%esp)
  800964:	e8 cf 02 00 00       	call   800c38 <strnlen>
  800969:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80096c:	29 c2                	sub    %eax,%edx
  80096e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800971:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800975:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800978:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80097b:	8b 75 08             	mov    0x8(%ebp),%esi
  80097e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800981:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800983:	eb 0f                	jmp    800994 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800985:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800989:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80098c:	89 04 24             	mov    %eax,(%esp)
  80098f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800991:	83 eb 01             	sub    $0x1,%ebx
  800994:	85 db                	test   %ebx,%ebx
  800996:	7f ed                	jg     800985 <vprintfmt+0x1c7>
  800998:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80099b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80099e:	85 d2                	test   %edx,%edx
  8009a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a5:	0f 49 c2             	cmovns %edx,%eax
  8009a8:	29 c2                	sub    %eax,%edx
  8009aa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8009ad:	89 d7                	mov    %edx,%edi
  8009af:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009b2:	eb 50                	jmp    800a04 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8009b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009b8:	74 1e                	je     8009d8 <vprintfmt+0x21a>
  8009ba:	0f be d2             	movsbl %dl,%edx
  8009bd:	83 ea 20             	sub    $0x20,%edx
  8009c0:	83 fa 5e             	cmp    $0x5e,%edx
  8009c3:	76 13                	jbe    8009d8 <vprintfmt+0x21a>
					putch('?', putdat);
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009cc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8009d3:	ff 55 08             	call   *0x8(%ebp)
  8009d6:	eb 0d                	jmp    8009e5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8009d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009db:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009df:	89 04 24             	mov    %eax,(%esp)
  8009e2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e5:	83 ef 01             	sub    $0x1,%edi
  8009e8:	eb 1a                	jmp    800a04 <vprintfmt+0x246>
  8009ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8009ed:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8009f0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009f3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009f6:	eb 0c                	jmp    800a04 <vprintfmt+0x246>
  8009f8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8009fb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8009fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a01:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a04:	83 c6 01             	add    $0x1,%esi
  800a07:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800a0b:	0f be c2             	movsbl %dl,%eax
  800a0e:	85 c0                	test   %eax,%eax
  800a10:	74 27                	je     800a39 <vprintfmt+0x27b>
  800a12:	85 db                	test   %ebx,%ebx
  800a14:	78 9e                	js     8009b4 <vprintfmt+0x1f6>
  800a16:	83 eb 01             	sub    $0x1,%ebx
  800a19:	79 99                	jns    8009b4 <vprintfmt+0x1f6>
  800a1b:	89 f8                	mov    %edi,%eax
  800a1d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a20:	8b 75 08             	mov    0x8(%ebp),%esi
  800a23:	89 c3                	mov    %eax,%ebx
  800a25:	eb 1a                	jmp    800a41 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a27:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a2b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a32:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a34:	83 eb 01             	sub    $0x1,%ebx
  800a37:	eb 08                	jmp    800a41 <vprintfmt+0x283>
  800a39:	89 fb                	mov    %edi,%ebx
  800a3b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a3e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	7f e2                	jg     800a27 <vprintfmt+0x269>
  800a45:	89 75 08             	mov    %esi,0x8(%ebp)
  800a48:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800a4b:	e9 93 fd ff ff       	jmp    8007e3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a50:	83 fa 01             	cmp    $0x1,%edx
  800a53:	7e 16                	jle    800a6b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800a55:	8b 45 14             	mov    0x14(%ebp),%eax
  800a58:	8d 50 08             	lea    0x8(%eax),%edx
  800a5b:	89 55 14             	mov    %edx,0x14(%ebp)
  800a5e:	8b 50 04             	mov    0x4(%eax),%edx
  800a61:	8b 00                	mov    (%eax),%eax
  800a63:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a66:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a69:	eb 32                	jmp    800a9d <vprintfmt+0x2df>
	else if (lflag)
  800a6b:	85 d2                	test   %edx,%edx
  800a6d:	74 18                	je     800a87 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800a6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a72:	8d 50 04             	lea    0x4(%eax),%edx
  800a75:	89 55 14             	mov    %edx,0x14(%ebp)
  800a78:	8b 30                	mov    (%eax),%esi
  800a7a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800a7d:	89 f0                	mov    %esi,%eax
  800a7f:	c1 f8 1f             	sar    $0x1f,%eax
  800a82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a85:	eb 16                	jmp    800a9d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800a87:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8a:	8d 50 04             	lea    0x4(%eax),%edx
  800a8d:	89 55 14             	mov    %edx,0x14(%ebp)
  800a90:	8b 30                	mov    (%eax),%esi
  800a92:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800a95:	89 f0                	mov    %esi,%eax
  800a97:	c1 f8 1f             	sar    $0x1f,%eax
  800a9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800aa3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800aa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aac:	0f 89 80 00 00 00    	jns    800b32 <vprintfmt+0x374>
				putch('-', putdat);
  800ab2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ab6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800abd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800ac0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ac6:	f7 d8                	neg    %eax
  800ac8:	83 d2 00             	adc    $0x0,%edx
  800acb:	f7 da                	neg    %edx
			}
			base = 10;
  800acd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ad2:	eb 5e                	jmp    800b32 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ad4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad7:	e8 63 fc ff ff       	call   80073f <getuint>
			base = 10;
  800adc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800ae1:	eb 4f                	jmp    800b32 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800ae3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae6:	e8 54 fc ff ff       	call   80073f <getuint>
			base = 8;
  800aeb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800af0:	eb 40                	jmp    800b32 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800af2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800af6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800afd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800b00:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b04:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b0b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b11:	8d 50 04             	lea    0x4(%eax),%edx
  800b14:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b17:	8b 00                	mov    (%eax),%eax
  800b19:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800b1e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800b23:	eb 0d                	jmp    800b32 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b25:	8d 45 14             	lea    0x14(%ebp),%eax
  800b28:	e8 12 fc ff ff       	call   80073f <getuint>
			base = 16;
  800b2d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b32:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800b36:	89 74 24 10          	mov    %esi,0x10(%esp)
  800b3a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800b3d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b41:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800b45:	89 04 24             	mov    %eax,(%esp)
  800b48:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b4c:	89 fa                	mov    %edi,%edx
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	e8 fa fa ff ff       	call   800650 <printnum>
			break;
  800b56:	e9 88 fc ff ff       	jmp    8007e3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b5b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b5f:	89 04 24             	mov    %eax,(%esp)
  800b62:	ff 55 08             	call   *0x8(%ebp)
			break;
  800b65:	e9 79 fc ff ff       	jmp    8007e3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b6a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b6e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800b75:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b78:	89 f3                	mov    %esi,%ebx
  800b7a:	eb 03                	jmp    800b7f <vprintfmt+0x3c1>
  800b7c:	83 eb 01             	sub    $0x1,%ebx
  800b7f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800b83:	75 f7                	jne    800b7c <vprintfmt+0x3be>
  800b85:	e9 59 fc ff ff       	jmp    8007e3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800b8a:	83 c4 3c             	add    $0x3c,%esp
  800b8d:	5b                   	pop    %ebx
  800b8e:	5e                   	pop    %esi
  800b8f:	5f                   	pop    %edi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	83 ec 28             	sub    $0x28,%esp
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ba5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ba8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800baf:	85 c0                	test   %eax,%eax
  800bb1:	74 30                	je     800be3 <vsnprintf+0x51>
  800bb3:	85 d2                	test   %edx,%edx
  800bb5:	7e 2c                	jle    800be3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bc5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bcc:	c7 04 24 79 07 80 00 	movl   $0x800779,(%esp)
  800bd3:	e8 e6 fb ff ff       	call   8007be <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bdb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800be1:	eb 05                	jmp    800be8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800be3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bf0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bf3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	89 04 24             	mov    %eax,(%esp)
  800c0b:	e8 82 ff ff ff       	call   800b92 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    
  800c12:	66 90                	xchg   %ax,%ax
  800c14:	66 90                	xchg   %ax,%ax
  800c16:	66 90                	xchg   %ax,%ax
  800c18:	66 90                	xchg   %ax,%ax
  800c1a:	66 90                	xchg   %ax,%ax
  800c1c:	66 90                	xchg   %ax,%ax
  800c1e:	66 90                	xchg   %ax,%ax

00800c20 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c26:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2b:	eb 03                	jmp    800c30 <strlen+0x10>
		n++;
  800c2d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c30:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c34:	75 f7                	jne    800c2d <strlen+0xd>
		n++;
	return n;
}
  800c36:	5d                   	pop    %ebp
  800c37:	c3                   	ret    

00800c38 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c41:	b8 00 00 00 00       	mov    $0x0,%eax
  800c46:	eb 03                	jmp    800c4b <strnlen+0x13>
		n++;
  800c48:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c4b:	39 d0                	cmp    %edx,%eax
  800c4d:	74 06                	je     800c55 <strnlen+0x1d>
  800c4f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800c53:	75 f3                	jne    800c48 <strnlen+0x10>
		n++;
	return n;
}
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    

00800c57 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	53                   	push   %ebx
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c61:	89 c2                	mov    %eax,%edx
  800c63:	83 c2 01             	add    $0x1,%edx
  800c66:	83 c1 01             	add    $0x1,%ecx
  800c69:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800c6d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c70:	84 db                	test   %bl,%bl
  800c72:	75 ef                	jne    800c63 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800c74:	5b                   	pop    %ebx
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    

00800c77 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	53                   	push   %ebx
  800c7b:	83 ec 08             	sub    $0x8,%esp
  800c7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c81:	89 1c 24             	mov    %ebx,(%esp)
  800c84:	e8 97 ff ff ff       	call   800c20 <strlen>
	strcpy(dst + len, src);
  800c89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c90:	01 d8                	add    %ebx,%eax
  800c92:	89 04 24             	mov    %eax,(%esp)
  800c95:	e8 bd ff ff ff       	call   800c57 <strcpy>
	return dst;
}
  800c9a:	89 d8                	mov    %ebx,%eax
  800c9c:	83 c4 08             	add    $0x8,%esp
  800c9f:	5b                   	pop    %ebx
  800ca0:	5d                   	pop    %ebp
  800ca1:	c3                   	ret    

00800ca2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	56                   	push   %esi
  800ca6:	53                   	push   %ebx
  800ca7:	8b 75 08             	mov    0x8(%ebp),%esi
  800caa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cad:	89 f3                	mov    %esi,%ebx
  800caf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb2:	89 f2                	mov    %esi,%edx
  800cb4:	eb 0f                	jmp    800cc5 <strncpy+0x23>
		*dst++ = *src;
  800cb6:	83 c2 01             	add    $0x1,%edx
  800cb9:	0f b6 01             	movzbl (%ecx),%eax
  800cbc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800cbf:	80 39 01             	cmpb   $0x1,(%ecx)
  800cc2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cc5:	39 da                	cmp    %ebx,%edx
  800cc7:	75 ed                	jne    800cb6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800cc9:	89 f0                	mov    %esi,%eax
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5d                   	pop    %ebp
  800cce:	c3                   	ret    

00800ccf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	56                   	push   %esi
  800cd3:	53                   	push   %ebx
  800cd4:	8b 75 08             	mov    0x8(%ebp),%esi
  800cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cda:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800cdd:	89 f0                	mov    %esi,%eax
  800cdf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ce3:	85 c9                	test   %ecx,%ecx
  800ce5:	75 0b                	jne    800cf2 <strlcpy+0x23>
  800ce7:	eb 1d                	jmp    800d06 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ce9:	83 c0 01             	add    $0x1,%eax
  800cec:	83 c2 01             	add    $0x1,%edx
  800cef:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cf2:	39 d8                	cmp    %ebx,%eax
  800cf4:	74 0b                	je     800d01 <strlcpy+0x32>
  800cf6:	0f b6 0a             	movzbl (%edx),%ecx
  800cf9:	84 c9                	test   %cl,%cl
  800cfb:	75 ec                	jne    800ce9 <strlcpy+0x1a>
  800cfd:	89 c2                	mov    %eax,%edx
  800cff:	eb 02                	jmp    800d03 <strlcpy+0x34>
  800d01:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800d03:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800d06:	29 f0                	sub    %esi,%eax
}
  800d08:	5b                   	pop    %ebx
  800d09:	5e                   	pop    %esi
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    

00800d0c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d12:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d15:	eb 06                	jmp    800d1d <strcmp+0x11>
		p++, q++;
  800d17:	83 c1 01             	add    $0x1,%ecx
  800d1a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1d:	0f b6 01             	movzbl (%ecx),%eax
  800d20:	84 c0                	test   %al,%al
  800d22:	74 04                	je     800d28 <strcmp+0x1c>
  800d24:	3a 02                	cmp    (%edx),%al
  800d26:	74 ef                	je     800d17 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d28:	0f b6 c0             	movzbl %al,%eax
  800d2b:	0f b6 12             	movzbl (%edx),%edx
  800d2e:	29 d0                	sub    %edx,%eax
}
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    

00800d32 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	53                   	push   %ebx
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3c:	89 c3                	mov    %eax,%ebx
  800d3e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d41:	eb 06                	jmp    800d49 <strncmp+0x17>
		n--, p++, q++;
  800d43:	83 c0 01             	add    $0x1,%eax
  800d46:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d49:	39 d8                	cmp    %ebx,%eax
  800d4b:	74 15                	je     800d62 <strncmp+0x30>
  800d4d:	0f b6 08             	movzbl (%eax),%ecx
  800d50:	84 c9                	test   %cl,%cl
  800d52:	74 04                	je     800d58 <strncmp+0x26>
  800d54:	3a 0a                	cmp    (%edx),%cl
  800d56:	74 eb                	je     800d43 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d58:	0f b6 00             	movzbl (%eax),%eax
  800d5b:	0f b6 12             	movzbl (%edx),%edx
  800d5e:	29 d0                	sub    %edx,%eax
  800d60:	eb 05                	jmp    800d67 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800d62:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800d67:	5b                   	pop    %ebx
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d74:	eb 07                	jmp    800d7d <strchr+0x13>
		if (*s == c)
  800d76:	38 ca                	cmp    %cl,%dl
  800d78:	74 0f                	je     800d89 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d7a:	83 c0 01             	add    $0x1,%eax
  800d7d:	0f b6 10             	movzbl (%eax),%edx
  800d80:	84 d2                	test   %dl,%dl
  800d82:	75 f2                	jne    800d76 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800d84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    

00800d8b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d95:	eb 07                	jmp    800d9e <strfind+0x13>
		if (*s == c)
  800d97:	38 ca                	cmp    %cl,%dl
  800d99:	74 0a                	je     800da5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d9b:	83 c0 01             	add    $0x1,%eax
  800d9e:	0f b6 10             	movzbl (%eax),%edx
  800da1:	84 d2                	test   %dl,%dl
  800da3:	75 f2                	jne    800d97 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800da5:	5d                   	pop    %ebp
  800da6:	c3                   	ret    

00800da7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	57                   	push   %edi
  800dab:	56                   	push   %esi
  800dac:	53                   	push   %ebx
  800dad:	8b 7d 08             	mov    0x8(%ebp),%edi
  800db0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800db3:	85 c9                	test   %ecx,%ecx
  800db5:	74 36                	je     800ded <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800db7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800dbd:	75 28                	jne    800de7 <memset+0x40>
  800dbf:	f6 c1 03             	test   $0x3,%cl
  800dc2:	75 23                	jne    800de7 <memset+0x40>
		c &= 0xFF;
  800dc4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800dc8:	89 d3                	mov    %edx,%ebx
  800dca:	c1 e3 08             	shl    $0x8,%ebx
  800dcd:	89 d6                	mov    %edx,%esi
  800dcf:	c1 e6 18             	shl    $0x18,%esi
  800dd2:	89 d0                	mov    %edx,%eax
  800dd4:	c1 e0 10             	shl    $0x10,%eax
  800dd7:	09 f0                	or     %esi,%eax
  800dd9:	09 c2                	or     %eax,%edx
  800ddb:	89 d0                	mov    %edx,%eax
  800ddd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ddf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800de2:	fc                   	cld    
  800de3:	f3 ab                	rep stos %eax,%es:(%edi)
  800de5:	eb 06                	jmp    800ded <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	fc                   	cld    
  800deb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ded:	89 f8                	mov    %edi,%eax
  800def:	5b                   	pop    %ebx
  800df0:	5e                   	pop    %esi
  800df1:	5f                   	pop    %edi
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	57                   	push   %edi
  800df8:	56                   	push   %esi
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e02:	39 c6                	cmp    %eax,%esi
  800e04:	73 35                	jae    800e3b <memmove+0x47>
  800e06:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e09:	39 d0                	cmp    %edx,%eax
  800e0b:	73 2e                	jae    800e3b <memmove+0x47>
		s += n;
		d += n;
  800e0d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800e10:	89 d6                	mov    %edx,%esi
  800e12:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e14:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e1a:	75 13                	jne    800e2f <memmove+0x3b>
  800e1c:	f6 c1 03             	test   $0x3,%cl
  800e1f:	75 0e                	jne    800e2f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e21:	83 ef 04             	sub    $0x4,%edi
  800e24:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e27:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800e2a:	fd                   	std    
  800e2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e2d:	eb 09                	jmp    800e38 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e2f:	83 ef 01             	sub    $0x1,%edi
  800e32:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800e35:	fd                   	std    
  800e36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e38:	fc                   	cld    
  800e39:	eb 1d                	jmp    800e58 <memmove+0x64>
  800e3b:	89 f2                	mov    %esi,%edx
  800e3d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e3f:	f6 c2 03             	test   $0x3,%dl
  800e42:	75 0f                	jne    800e53 <memmove+0x5f>
  800e44:	f6 c1 03             	test   $0x3,%cl
  800e47:	75 0a                	jne    800e53 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e49:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800e4c:	89 c7                	mov    %eax,%edi
  800e4e:	fc                   	cld    
  800e4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e51:	eb 05                	jmp    800e58 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e53:	89 c7                	mov    %eax,%edi
  800e55:	fc                   	cld    
  800e56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    

00800e5c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e62:	8b 45 10             	mov    0x10(%ebp),%eax
  800e65:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	89 04 24             	mov    %eax,(%esp)
  800e76:	e8 79 ff ff ff       	call   800df4 <memmove>
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
  800e82:	8b 55 08             	mov    0x8(%ebp),%edx
  800e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e88:	89 d6                	mov    %edx,%esi
  800e8a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e8d:	eb 1a                	jmp    800ea9 <memcmp+0x2c>
		if (*s1 != *s2)
  800e8f:	0f b6 02             	movzbl (%edx),%eax
  800e92:	0f b6 19             	movzbl (%ecx),%ebx
  800e95:	38 d8                	cmp    %bl,%al
  800e97:	74 0a                	je     800ea3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800e99:	0f b6 c0             	movzbl %al,%eax
  800e9c:	0f b6 db             	movzbl %bl,%ebx
  800e9f:	29 d8                	sub    %ebx,%eax
  800ea1:	eb 0f                	jmp    800eb2 <memcmp+0x35>
		s1++, s2++;
  800ea3:	83 c2 01             	add    $0x1,%edx
  800ea6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ea9:	39 f2                	cmp    %esi,%edx
  800eab:	75 e2                	jne    800e8f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ead:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb2:	5b                   	pop    %ebx
  800eb3:	5e                   	pop    %esi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    

00800eb6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ebf:	89 c2                	mov    %eax,%edx
  800ec1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ec4:	eb 07                	jmp    800ecd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ec6:	38 08                	cmp    %cl,(%eax)
  800ec8:	74 07                	je     800ed1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eca:	83 c0 01             	add    $0x1,%eax
  800ecd:	39 d0                	cmp    %edx,%eax
  800ecf:	72 f5                	jb     800ec6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
  800ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  800edc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800edf:	eb 03                	jmp    800ee4 <strtol+0x11>
		s++;
  800ee1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ee4:	0f b6 0a             	movzbl (%edx),%ecx
  800ee7:	80 f9 09             	cmp    $0x9,%cl
  800eea:	74 f5                	je     800ee1 <strtol+0xe>
  800eec:	80 f9 20             	cmp    $0x20,%cl
  800eef:	74 f0                	je     800ee1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ef1:	80 f9 2b             	cmp    $0x2b,%cl
  800ef4:	75 0a                	jne    800f00 <strtol+0x2d>
		s++;
  800ef6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ef9:	bf 00 00 00 00       	mov    $0x0,%edi
  800efe:	eb 11                	jmp    800f11 <strtol+0x3e>
  800f00:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800f05:	80 f9 2d             	cmp    $0x2d,%cl
  800f08:	75 07                	jne    800f11 <strtol+0x3e>
		s++, neg = 1;
  800f0a:	8d 52 01             	lea    0x1(%edx),%edx
  800f0d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f11:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800f16:	75 15                	jne    800f2d <strtol+0x5a>
  800f18:	80 3a 30             	cmpb   $0x30,(%edx)
  800f1b:	75 10                	jne    800f2d <strtol+0x5a>
  800f1d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f21:	75 0a                	jne    800f2d <strtol+0x5a>
		s += 2, base = 16;
  800f23:	83 c2 02             	add    $0x2,%edx
  800f26:	b8 10 00 00 00       	mov    $0x10,%eax
  800f2b:	eb 10                	jmp    800f3d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	75 0c                	jne    800f3d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f31:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f33:	80 3a 30             	cmpb   $0x30,(%edx)
  800f36:	75 05                	jne    800f3d <strtol+0x6a>
		s++, base = 8;
  800f38:	83 c2 01             	add    $0x1,%edx
  800f3b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800f3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f42:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f45:	0f b6 0a             	movzbl (%edx),%ecx
  800f48:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800f4b:	89 f0                	mov    %esi,%eax
  800f4d:	3c 09                	cmp    $0x9,%al
  800f4f:	77 08                	ja     800f59 <strtol+0x86>
			dig = *s - '0';
  800f51:	0f be c9             	movsbl %cl,%ecx
  800f54:	83 e9 30             	sub    $0x30,%ecx
  800f57:	eb 20                	jmp    800f79 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800f59:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800f5c:	89 f0                	mov    %esi,%eax
  800f5e:	3c 19                	cmp    $0x19,%al
  800f60:	77 08                	ja     800f6a <strtol+0x97>
			dig = *s - 'a' + 10;
  800f62:	0f be c9             	movsbl %cl,%ecx
  800f65:	83 e9 57             	sub    $0x57,%ecx
  800f68:	eb 0f                	jmp    800f79 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800f6a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800f6d:	89 f0                	mov    %esi,%eax
  800f6f:	3c 19                	cmp    $0x19,%al
  800f71:	77 16                	ja     800f89 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800f73:	0f be c9             	movsbl %cl,%ecx
  800f76:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f79:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800f7c:	7d 0f                	jge    800f8d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800f7e:	83 c2 01             	add    $0x1,%edx
  800f81:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800f85:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800f87:	eb bc                	jmp    800f45 <strtol+0x72>
  800f89:	89 d8                	mov    %ebx,%eax
  800f8b:	eb 02                	jmp    800f8f <strtol+0xbc>
  800f8d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800f8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f93:	74 05                	je     800f9a <strtol+0xc7>
		*endptr = (char *) s;
  800f95:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f98:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800f9a:	f7 d8                	neg    %eax
  800f9c:	85 ff                	test   %edi,%edi
  800f9e:	0f 44 c3             	cmove  %ebx,%eax
}
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5f                   	pop    %edi
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    

00800fa6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	57                   	push   %edi
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fac:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb7:	89 c3                	mov    %eax,%ebx
  800fb9:	89 c7                	mov    %eax,%edi
  800fbb:	89 c6                	mov    %eax,%esi
  800fbd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fbf:	5b                   	pop    %ebx
  800fc0:	5e                   	pop    %esi
  800fc1:	5f                   	pop    %edi
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	57                   	push   %edi
  800fc8:	56                   	push   %esi
  800fc9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fca:	ba 00 00 00 00       	mov    $0x0,%edx
  800fcf:	b8 01 00 00 00       	mov    $0x1,%eax
  800fd4:	89 d1                	mov    %edx,%ecx
  800fd6:	89 d3                	mov    %edx,%ebx
  800fd8:	89 d7                	mov    %edx,%edi
  800fda:	89 d6                	mov    %edx,%esi
  800fdc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fde:	5b                   	pop    %ebx
  800fdf:	5e                   	pop    %esi
  800fe0:	5f                   	pop    %edi
  800fe1:	5d                   	pop    %ebp
  800fe2:	c3                   	ret    

00800fe3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fe3:	55                   	push   %ebp
  800fe4:	89 e5                	mov    %esp,%ebp
  800fe6:	57                   	push   %edi
  800fe7:	56                   	push   %esi
  800fe8:	53                   	push   %ebx
  800fe9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fec:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff1:	b8 03 00 00 00       	mov    $0x3,%eax
  800ff6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff9:	89 cb                	mov    %ecx,%ebx
  800ffb:	89 cf                	mov    %ecx,%edi
  800ffd:	89 ce                	mov    %ecx,%esi
  800fff:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801001:	85 c0                	test   %eax,%eax
  801003:	7e 28                	jle    80102d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801005:	89 44 24 10          	mov    %eax,0x10(%esp)
  801009:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801010:	00 
  801011:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  801018:	00 
  801019:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801020:	00 
  801021:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  801028:	e8 29 17 00 00       	call   802756 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80102d:	83 c4 2c             	add    $0x2c,%esp
  801030:	5b                   	pop    %ebx
  801031:	5e                   	pop    %esi
  801032:	5f                   	pop    %edi
  801033:	5d                   	pop    %ebp
  801034:	c3                   	ret    

00801035 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	57                   	push   %edi
  801039:	56                   	push   %esi
  80103a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80103b:	ba 00 00 00 00       	mov    $0x0,%edx
  801040:	b8 02 00 00 00       	mov    $0x2,%eax
  801045:	89 d1                	mov    %edx,%ecx
  801047:	89 d3                	mov    %edx,%ebx
  801049:	89 d7                	mov    %edx,%edi
  80104b:	89 d6                	mov    %edx,%esi
  80104d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80104f:	5b                   	pop    %ebx
  801050:	5e                   	pop    %esi
  801051:	5f                   	pop    %edi
  801052:	5d                   	pop    %ebp
  801053:	c3                   	ret    

00801054 <sys_yield>:

void
sys_yield(void)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	57                   	push   %edi
  801058:	56                   	push   %esi
  801059:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105a:	ba 00 00 00 00       	mov    $0x0,%edx
  80105f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801064:	89 d1                	mov    %edx,%ecx
  801066:	89 d3                	mov    %edx,%ebx
  801068:	89 d7                	mov    %edx,%edi
  80106a:	89 d6                	mov    %edx,%esi
  80106c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80106e:	5b                   	pop    %ebx
  80106f:	5e                   	pop    %esi
  801070:	5f                   	pop    %edi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  80107c:	be 00 00 00 00       	mov    $0x0,%esi
  801081:	b8 04 00 00 00       	mov    $0x4,%eax
  801086:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801089:	8b 55 08             	mov    0x8(%ebp),%edx
  80108c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80108f:	89 f7                	mov    %esi,%edi
  801091:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801093:	85 c0                	test   %eax,%eax
  801095:	7e 28                	jle    8010bf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801097:	89 44 24 10          	mov    %eax,0x10(%esp)
  80109b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8010a2:	00 
  8010a3:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  8010aa:	00 
  8010ab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b2:	00 
  8010b3:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  8010ba:	e8 97 16 00 00       	call   802756 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010bf:	83 c4 2c             	add    $0x2c,%esp
  8010c2:	5b                   	pop    %ebx
  8010c3:	5e                   	pop    %esi
  8010c4:	5f                   	pop    %edi
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    

008010c7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	57                   	push   %edi
  8010cb:	56                   	push   %esi
  8010cc:	53                   	push   %ebx
  8010cd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d0:	b8 05 00 00 00       	mov    $0x5,%eax
  8010d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010db:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010de:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010e1:	8b 75 18             	mov    0x18(%ebp),%esi
  8010e4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	7e 28                	jle    801112 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ee:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8010f5:	00 
  8010f6:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  8010fd:	00 
  8010fe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801105:	00 
  801106:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  80110d:	e8 44 16 00 00       	call   802756 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801112:	83 c4 2c             	add    $0x2c,%esp
  801115:	5b                   	pop    %ebx
  801116:	5e                   	pop    %esi
  801117:	5f                   	pop    %edi
  801118:	5d                   	pop    %ebp
  801119:	c3                   	ret    

0080111a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	57                   	push   %edi
  80111e:	56                   	push   %esi
  80111f:	53                   	push   %ebx
  801120:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801123:	bb 00 00 00 00       	mov    $0x0,%ebx
  801128:	b8 06 00 00 00       	mov    $0x6,%eax
  80112d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801130:	8b 55 08             	mov    0x8(%ebp),%edx
  801133:	89 df                	mov    %ebx,%edi
  801135:	89 de                	mov    %ebx,%esi
  801137:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801139:	85 c0                	test   %eax,%eax
  80113b:	7e 28                	jle    801165 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80113d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801141:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801148:	00 
  801149:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  801150:	00 
  801151:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801158:	00 
  801159:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  801160:	e8 f1 15 00 00       	call   802756 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801165:	83 c4 2c             	add    $0x2c,%esp
  801168:	5b                   	pop    %ebx
  801169:	5e                   	pop    %esi
  80116a:	5f                   	pop    %edi
  80116b:	5d                   	pop    %ebp
  80116c:	c3                   	ret    

0080116d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	57                   	push   %edi
  801171:	56                   	push   %esi
  801172:	53                   	push   %ebx
  801173:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801176:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117b:	b8 08 00 00 00       	mov    $0x8,%eax
  801180:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801183:	8b 55 08             	mov    0x8(%ebp),%edx
  801186:	89 df                	mov    %ebx,%edi
  801188:	89 de                	mov    %ebx,%esi
  80118a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80118c:	85 c0                	test   %eax,%eax
  80118e:	7e 28                	jle    8011b8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801190:	89 44 24 10          	mov    %eax,0x10(%esp)
  801194:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80119b:	00 
  80119c:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  8011a3:	00 
  8011a4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011ab:	00 
  8011ac:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  8011b3:	e8 9e 15 00 00       	call   802756 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011b8:	83 c4 2c             	add    $0x2c,%esp
  8011bb:	5b                   	pop    %ebx
  8011bc:	5e                   	pop    %esi
  8011bd:	5f                   	pop    %edi
  8011be:	5d                   	pop    %ebp
  8011bf:	c3                   	ret    

008011c0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	57                   	push   %edi
  8011c4:	56                   	push   %esi
  8011c5:	53                   	push   %ebx
  8011c6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ce:	b8 09 00 00 00       	mov    $0x9,%eax
  8011d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d9:	89 df                	mov    %ebx,%edi
  8011db:	89 de                	mov    %ebx,%esi
  8011dd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	7e 28                	jle    80120b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011e7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8011ee:	00 
  8011ef:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  8011f6:	00 
  8011f7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011fe:	00 
  8011ff:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  801206:	e8 4b 15 00 00       	call   802756 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80120b:	83 c4 2c             	add    $0x2c,%esp
  80120e:	5b                   	pop    %ebx
  80120f:	5e                   	pop    %esi
  801210:	5f                   	pop    %edi
  801211:	5d                   	pop    %ebp
  801212:	c3                   	ret    

00801213 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	57                   	push   %edi
  801217:	56                   	push   %esi
  801218:	53                   	push   %ebx
  801219:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80121c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801221:	b8 0a 00 00 00       	mov    $0xa,%eax
  801226:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801229:	8b 55 08             	mov    0x8(%ebp),%edx
  80122c:	89 df                	mov    %ebx,%edi
  80122e:	89 de                	mov    %ebx,%esi
  801230:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801232:	85 c0                	test   %eax,%eax
  801234:	7e 28                	jle    80125e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801236:	89 44 24 10          	mov    %eax,0x10(%esp)
  80123a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801241:	00 
  801242:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  801249:	00 
  80124a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801251:	00 
  801252:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  801259:	e8 f8 14 00 00       	call   802756 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80125e:	83 c4 2c             	add    $0x2c,%esp
  801261:	5b                   	pop    %ebx
  801262:	5e                   	pop    %esi
  801263:	5f                   	pop    %edi
  801264:	5d                   	pop    %ebp
  801265:	c3                   	ret    

00801266 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	57                   	push   %edi
  80126a:	56                   	push   %esi
  80126b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80126c:	be 00 00 00 00       	mov    $0x0,%esi
  801271:	b8 0c 00 00 00       	mov    $0xc,%eax
  801276:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801279:	8b 55 08             	mov    0x8(%ebp),%edx
  80127c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80127f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801282:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801284:	5b                   	pop    %ebx
  801285:	5e                   	pop    %esi
  801286:	5f                   	pop    %edi
  801287:	5d                   	pop    %ebp
  801288:	c3                   	ret    

00801289 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	57                   	push   %edi
  80128d:	56                   	push   %esi
  80128e:	53                   	push   %ebx
  80128f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801292:	b9 00 00 00 00       	mov    $0x0,%ecx
  801297:	b8 0d 00 00 00       	mov    $0xd,%eax
  80129c:	8b 55 08             	mov    0x8(%ebp),%edx
  80129f:	89 cb                	mov    %ecx,%ebx
  8012a1:	89 cf                	mov    %ecx,%edi
  8012a3:	89 ce                	mov    %ecx,%esi
  8012a5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012a7:	85 c0                	test   %eax,%eax
  8012a9:	7e 28                	jle    8012d3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ab:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012af:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8012b6:	00 
  8012b7:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  8012be:	00 
  8012bf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012c6:	00 
  8012c7:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  8012ce:	e8 83 14 00 00       	call   802756 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012d3:	83 c4 2c             	add    $0x2c,%esp
  8012d6:	5b                   	pop    %ebx
  8012d7:	5e                   	pop    %esi
  8012d8:	5f                   	pop    %edi
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    

008012db <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	57                   	push   %edi
  8012df:	56                   	push   %esi
  8012e0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8012e6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012eb:	89 d1                	mov    %edx,%ecx
  8012ed:	89 d3                	mov    %edx,%ebx
  8012ef:	89 d7                	mov    %edx,%edi
  8012f1:	89 d6                	mov    %edx,%esi
  8012f3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8012f5:	5b                   	pop    %ebx
  8012f6:	5e                   	pop    %esi
  8012f7:	5f                   	pop    %edi
  8012f8:	5d                   	pop    %ebp
  8012f9:	c3                   	ret    

008012fa <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	57                   	push   %edi
  8012fe:	56                   	push   %esi
  8012ff:	53                   	push   %ebx
  801300:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801303:	bb 00 00 00 00       	mov    $0x0,%ebx
  801308:	b8 0f 00 00 00       	mov    $0xf,%eax
  80130d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801310:	8b 55 08             	mov    0x8(%ebp),%edx
  801313:	89 df                	mov    %ebx,%edi
  801315:	89 de                	mov    %ebx,%esi
  801317:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801319:	85 c0                	test   %eax,%eax
  80131b:	7e 28                	jle    801345 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80131d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801321:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801328:	00 
  801329:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  801330:	00 
  801331:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801338:	00 
  801339:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  801340:	e8 11 14 00 00       	call   802756 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  801345:	83 c4 2c             	add    $0x2c,%esp
  801348:	5b                   	pop    %ebx
  801349:	5e                   	pop    %esi
  80134a:	5f                   	pop    %edi
  80134b:	5d                   	pop    %ebp
  80134c:	c3                   	ret    

0080134d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
  801350:	57                   	push   %edi
  801351:	56                   	push   %esi
  801352:	53                   	push   %ebx
  801353:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801356:	bb 00 00 00 00       	mov    $0x0,%ebx
  80135b:	b8 10 00 00 00       	mov    $0x10,%eax
  801360:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801363:	8b 55 08             	mov    0x8(%ebp),%edx
  801366:	89 df                	mov    %ebx,%edi
  801368:	89 de                	mov    %ebx,%esi
  80136a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80136c:	85 c0                	test   %eax,%eax
  80136e:	7e 28                	jle    801398 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801370:	89 44 24 10          	mov    %eax,0x10(%esp)
  801374:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80137b:	00 
  80137c:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  801383:	00 
  801384:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80138b:	00 
  80138c:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  801393:	e8 be 13 00 00       	call   802756 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  801398:	83 c4 2c             	add    $0x2c,%esp
  80139b:	5b                   	pop    %ebx
  80139c:	5e                   	pop    %esi
  80139d:	5f                   	pop    %edi
  80139e:	5d                   	pop    %ebp
  80139f:	c3                   	ret    

008013a0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	57                   	push   %edi
  8013a4:	56                   	push   %esi
  8013a5:	53                   	push   %ebx
  8013a6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ae:	b8 11 00 00 00       	mov    $0x11,%eax
  8013b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b9:	89 df                	mov    %ebx,%edi
  8013bb:	89 de                	mov    %ebx,%esi
  8013bd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	7e 28                	jle    8013eb <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013c7:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  8013ce:	00 
  8013cf:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  8013d6:	00 
  8013d7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013de:	00 
  8013df:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  8013e6:	e8 6b 13 00 00       	call   802756 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  8013eb:	83 c4 2c             	add    $0x2c,%esp
  8013ee:	5b                   	pop    %ebx
  8013ef:	5e                   	pop    %esi
  8013f0:	5f                   	pop    %edi
  8013f1:	5d                   	pop    %ebp
  8013f2:	c3                   	ret    

008013f3 <sys_sleep>:

int
sys_sleep(int channel)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	57                   	push   %edi
  8013f7:	56                   	push   %esi
  8013f8:	53                   	push   %ebx
  8013f9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801401:	b8 12 00 00 00       	mov    $0x12,%eax
  801406:	8b 55 08             	mov    0x8(%ebp),%edx
  801409:	89 cb                	mov    %ecx,%ebx
  80140b:	89 cf                	mov    %ecx,%edi
  80140d:	89 ce                	mov    %ecx,%esi
  80140f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801411:	85 c0                	test   %eax,%eax
  801413:	7e 28                	jle    80143d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801415:	89 44 24 10          	mov    %eax,0x10(%esp)
  801419:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801420:	00 
  801421:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  801428:	00 
  801429:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801430:	00 
  801431:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  801438:	e8 19 13 00 00       	call   802756 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80143d:	83 c4 2c             	add    $0x2c,%esp
  801440:	5b                   	pop    %ebx
  801441:	5e                   	pop    %esi
  801442:	5f                   	pop    %edi
  801443:	5d                   	pop    %ebp
  801444:	c3                   	ret    

00801445 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	57                   	push   %edi
  801449:	56                   	push   %esi
  80144a:	53                   	push   %ebx
  80144b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80144e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801453:	b8 13 00 00 00       	mov    $0x13,%eax
  801458:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145b:	8b 55 08             	mov    0x8(%ebp),%edx
  80145e:	89 df                	mov    %ebx,%edi
  801460:	89 de                	mov    %ebx,%esi
  801462:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801464:	85 c0                	test   %eax,%eax
  801466:	7e 28                	jle    801490 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801468:	89 44 24 10          	mov    %eax,0x10(%esp)
  80146c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801473:	00 
  801474:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  80147b:	00 
  80147c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801483:	00 
  801484:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  80148b:	e8 c6 12 00 00       	call   802756 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801490:	83 c4 2c             	add    $0x2c,%esp
  801493:	5b                   	pop    %ebx
  801494:	5e                   	pop    %esi
  801495:	5f                   	pop    %edi
  801496:	5d                   	pop    %ebp
  801497:	c3                   	ret    
  801498:	66 90                	xchg   %ax,%ax
  80149a:	66 90                	xchg   %ax,%ax
  80149c:	66 90                	xchg   %ax,%ax
  80149e:	66 90                	xchg   %ax,%ax

008014a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8014ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8014ae:	5d                   	pop    %ebp
  8014af:	c3                   	ret    

008014b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8014bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014c5:	5d                   	pop    %ebp
  8014c6:	c3                   	ret    

008014c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014d2:	89 c2                	mov    %eax,%edx
  8014d4:	c1 ea 16             	shr    $0x16,%edx
  8014d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014de:	f6 c2 01             	test   $0x1,%dl
  8014e1:	74 11                	je     8014f4 <fd_alloc+0x2d>
  8014e3:	89 c2                	mov    %eax,%edx
  8014e5:	c1 ea 0c             	shr    $0xc,%edx
  8014e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014ef:	f6 c2 01             	test   $0x1,%dl
  8014f2:	75 09                	jne    8014fd <fd_alloc+0x36>
			*fd_store = fd;
  8014f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fb:	eb 17                	jmp    801514 <fd_alloc+0x4d>
  8014fd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801502:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801507:	75 c9                	jne    8014d2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801509:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80150f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801514:	5d                   	pop    %ebp
  801515:	c3                   	ret    

00801516 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80151c:	83 f8 1f             	cmp    $0x1f,%eax
  80151f:	77 36                	ja     801557 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801521:	c1 e0 0c             	shl    $0xc,%eax
  801524:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801529:	89 c2                	mov    %eax,%edx
  80152b:	c1 ea 16             	shr    $0x16,%edx
  80152e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801535:	f6 c2 01             	test   $0x1,%dl
  801538:	74 24                	je     80155e <fd_lookup+0x48>
  80153a:	89 c2                	mov    %eax,%edx
  80153c:	c1 ea 0c             	shr    $0xc,%edx
  80153f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801546:	f6 c2 01             	test   $0x1,%dl
  801549:	74 1a                	je     801565 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80154b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154e:	89 02                	mov    %eax,(%edx)
	return 0;
  801550:	b8 00 00 00 00       	mov    $0x0,%eax
  801555:	eb 13                	jmp    80156a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801557:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80155c:	eb 0c                	jmp    80156a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80155e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801563:	eb 05                	jmp    80156a <fd_lookup+0x54>
  801565:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80156a:	5d                   	pop    %ebp
  80156b:	c3                   	ret    

0080156c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	83 ec 18             	sub    $0x18,%esp
  801572:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801575:	ba 00 00 00 00       	mov    $0x0,%edx
  80157a:	eb 13                	jmp    80158f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80157c:	39 08                	cmp    %ecx,(%eax)
  80157e:	75 0c                	jne    80158c <dev_lookup+0x20>
			*dev = devtab[i];
  801580:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801583:	89 01                	mov    %eax,(%ecx)
			return 0;
  801585:	b8 00 00 00 00       	mov    $0x0,%eax
  80158a:	eb 38                	jmp    8015c4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80158c:	83 c2 01             	add    $0x1,%edx
  80158f:	8b 04 95 b4 30 80 00 	mov    0x8030b4(,%edx,4),%eax
  801596:	85 c0                	test   %eax,%eax
  801598:	75 e2                	jne    80157c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80159a:	a1 18 50 80 00       	mov    0x805018,%eax
  80159f:	8b 40 48             	mov    0x48(%eax),%eax
  8015a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015aa:	c7 04 24 38 30 80 00 	movl   $0x803038,(%esp)
  8015b1:	e8 7f f0 ff ff       	call   800635 <cprintf>
	*dev = 0;
  8015b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	56                   	push   %esi
  8015ca:	53                   	push   %ebx
  8015cb:	83 ec 20             	sub    $0x20,%esp
  8015ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8015d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015e1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015e4:	89 04 24             	mov    %eax,(%esp)
  8015e7:	e8 2a ff ff ff       	call   801516 <fd_lookup>
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	78 05                	js     8015f5 <fd_close+0x2f>
	    || fd != fd2)
  8015f0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8015f3:	74 0c                	je     801601 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8015f5:	84 db                	test   %bl,%bl
  8015f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fc:	0f 44 c2             	cmove  %edx,%eax
  8015ff:	eb 3f                	jmp    801640 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801601:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801604:	89 44 24 04          	mov    %eax,0x4(%esp)
  801608:	8b 06                	mov    (%esi),%eax
  80160a:	89 04 24             	mov    %eax,(%esp)
  80160d:	e8 5a ff ff ff       	call   80156c <dev_lookup>
  801612:	89 c3                	mov    %eax,%ebx
  801614:	85 c0                	test   %eax,%eax
  801616:	78 16                	js     80162e <fd_close+0x68>
		if (dev->dev_close)
  801618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80161e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801623:	85 c0                	test   %eax,%eax
  801625:	74 07                	je     80162e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801627:	89 34 24             	mov    %esi,(%esp)
  80162a:	ff d0                	call   *%eax
  80162c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80162e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801632:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801639:	e8 dc fa ff ff       	call   80111a <sys_page_unmap>
	return r;
  80163e:	89 d8                	mov    %ebx,%eax
}
  801640:	83 c4 20             	add    $0x20,%esp
  801643:	5b                   	pop    %ebx
  801644:	5e                   	pop    %esi
  801645:	5d                   	pop    %ebp
  801646:	c3                   	ret    

00801647 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80164d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801650:	89 44 24 04          	mov    %eax,0x4(%esp)
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	89 04 24             	mov    %eax,(%esp)
  80165a:	e8 b7 fe ff ff       	call   801516 <fd_lookup>
  80165f:	89 c2                	mov    %eax,%edx
  801661:	85 d2                	test   %edx,%edx
  801663:	78 13                	js     801678 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801665:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80166c:	00 
  80166d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801670:	89 04 24             	mov    %eax,(%esp)
  801673:	e8 4e ff ff ff       	call   8015c6 <fd_close>
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <close_all>:

void
close_all(void)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	53                   	push   %ebx
  80167e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801681:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801686:	89 1c 24             	mov    %ebx,(%esp)
  801689:	e8 b9 ff ff ff       	call   801647 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80168e:	83 c3 01             	add    $0x1,%ebx
  801691:	83 fb 20             	cmp    $0x20,%ebx
  801694:	75 f0                	jne    801686 <close_all+0xc>
		close(i);
}
  801696:	83 c4 14             	add    $0x14,%esp
  801699:	5b                   	pop    %ebx
  80169a:	5d                   	pop    %ebp
  80169b:	c3                   	ret    

0080169c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	57                   	push   %edi
  8016a0:	56                   	push   %esi
  8016a1:	53                   	push   %ebx
  8016a2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	89 04 24             	mov    %eax,(%esp)
  8016b2:	e8 5f fe ff ff       	call   801516 <fd_lookup>
  8016b7:	89 c2                	mov    %eax,%edx
  8016b9:	85 d2                	test   %edx,%edx
  8016bb:	0f 88 e1 00 00 00    	js     8017a2 <dup+0x106>
		return r;
	close(newfdnum);
  8016c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c4:	89 04 24             	mov    %eax,(%esp)
  8016c7:	e8 7b ff ff ff       	call   801647 <close>

	newfd = INDEX2FD(newfdnum);
  8016cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016cf:	c1 e3 0c             	shl    $0xc,%ebx
  8016d2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8016d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016db:	89 04 24             	mov    %eax,(%esp)
  8016de:	e8 cd fd ff ff       	call   8014b0 <fd2data>
  8016e3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8016e5:	89 1c 24             	mov    %ebx,(%esp)
  8016e8:	e8 c3 fd ff ff       	call   8014b0 <fd2data>
  8016ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016ef:	89 f0                	mov    %esi,%eax
  8016f1:	c1 e8 16             	shr    $0x16,%eax
  8016f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016fb:	a8 01                	test   $0x1,%al
  8016fd:	74 43                	je     801742 <dup+0xa6>
  8016ff:	89 f0                	mov    %esi,%eax
  801701:	c1 e8 0c             	shr    $0xc,%eax
  801704:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80170b:	f6 c2 01             	test   $0x1,%dl
  80170e:	74 32                	je     801742 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801710:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801717:	25 07 0e 00 00       	and    $0xe07,%eax
  80171c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801720:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801724:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80172b:	00 
  80172c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801730:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801737:	e8 8b f9 ff ff       	call   8010c7 <sys_page_map>
  80173c:	89 c6                	mov    %eax,%esi
  80173e:	85 c0                	test   %eax,%eax
  801740:	78 3e                	js     801780 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801745:	89 c2                	mov    %eax,%edx
  801747:	c1 ea 0c             	shr    $0xc,%edx
  80174a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801751:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801757:	89 54 24 10          	mov    %edx,0x10(%esp)
  80175b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80175f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801766:	00 
  801767:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801772:	e8 50 f9 ff ff       	call   8010c7 <sys_page_map>
  801777:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801779:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80177c:	85 f6                	test   %esi,%esi
  80177e:	79 22                	jns    8017a2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801780:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801784:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80178b:	e8 8a f9 ff ff       	call   80111a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801790:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801794:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80179b:	e8 7a f9 ff ff       	call   80111a <sys_page_unmap>
	return r;
  8017a0:	89 f0                	mov    %esi,%eax
}
  8017a2:	83 c4 3c             	add    $0x3c,%esp
  8017a5:	5b                   	pop    %ebx
  8017a6:	5e                   	pop    %esi
  8017a7:	5f                   	pop    %edi
  8017a8:	5d                   	pop    %ebp
  8017a9:	c3                   	ret    

008017aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	53                   	push   %ebx
  8017ae:	83 ec 24             	sub    $0x24,%esp
  8017b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bb:	89 1c 24             	mov    %ebx,(%esp)
  8017be:	e8 53 fd ff ff       	call   801516 <fd_lookup>
  8017c3:	89 c2                	mov    %eax,%edx
  8017c5:	85 d2                	test   %edx,%edx
  8017c7:	78 6d                	js     801836 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d3:	8b 00                	mov    (%eax),%eax
  8017d5:	89 04 24             	mov    %eax,(%esp)
  8017d8:	e8 8f fd ff ff       	call   80156c <dev_lookup>
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	78 55                	js     801836 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e4:	8b 50 08             	mov    0x8(%eax),%edx
  8017e7:	83 e2 03             	and    $0x3,%edx
  8017ea:	83 fa 01             	cmp    $0x1,%edx
  8017ed:	75 23                	jne    801812 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ef:	a1 18 50 80 00       	mov    0x805018,%eax
  8017f4:	8b 40 48             	mov    0x48(%eax),%eax
  8017f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ff:	c7 04 24 79 30 80 00 	movl   $0x803079,(%esp)
  801806:	e8 2a ee ff ff       	call   800635 <cprintf>
		return -E_INVAL;
  80180b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801810:	eb 24                	jmp    801836 <read+0x8c>
	}
	if (!dev->dev_read)
  801812:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801815:	8b 52 08             	mov    0x8(%edx),%edx
  801818:	85 d2                	test   %edx,%edx
  80181a:	74 15                	je     801831 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80181c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80181f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801823:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801826:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80182a:	89 04 24             	mov    %eax,(%esp)
  80182d:	ff d2                	call   *%edx
  80182f:	eb 05                	jmp    801836 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801831:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801836:	83 c4 24             	add    $0x24,%esp
  801839:	5b                   	pop    %ebx
  80183a:	5d                   	pop    %ebp
  80183b:	c3                   	ret    

0080183c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	57                   	push   %edi
  801840:	56                   	push   %esi
  801841:	53                   	push   %ebx
  801842:	83 ec 1c             	sub    $0x1c,%esp
  801845:	8b 7d 08             	mov    0x8(%ebp),%edi
  801848:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80184b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801850:	eb 23                	jmp    801875 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801852:	89 f0                	mov    %esi,%eax
  801854:	29 d8                	sub    %ebx,%eax
  801856:	89 44 24 08          	mov    %eax,0x8(%esp)
  80185a:	89 d8                	mov    %ebx,%eax
  80185c:	03 45 0c             	add    0xc(%ebp),%eax
  80185f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801863:	89 3c 24             	mov    %edi,(%esp)
  801866:	e8 3f ff ff ff       	call   8017aa <read>
		if (m < 0)
  80186b:	85 c0                	test   %eax,%eax
  80186d:	78 10                	js     80187f <readn+0x43>
			return m;
		if (m == 0)
  80186f:	85 c0                	test   %eax,%eax
  801871:	74 0a                	je     80187d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801873:	01 c3                	add    %eax,%ebx
  801875:	39 f3                	cmp    %esi,%ebx
  801877:	72 d9                	jb     801852 <readn+0x16>
  801879:	89 d8                	mov    %ebx,%eax
  80187b:	eb 02                	jmp    80187f <readn+0x43>
  80187d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80187f:	83 c4 1c             	add    $0x1c,%esp
  801882:	5b                   	pop    %ebx
  801883:	5e                   	pop    %esi
  801884:	5f                   	pop    %edi
  801885:	5d                   	pop    %ebp
  801886:	c3                   	ret    

00801887 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	53                   	push   %ebx
  80188b:	83 ec 24             	sub    $0x24,%esp
  80188e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801891:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801894:	89 44 24 04          	mov    %eax,0x4(%esp)
  801898:	89 1c 24             	mov    %ebx,(%esp)
  80189b:	e8 76 fc ff ff       	call   801516 <fd_lookup>
  8018a0:	89 c2                	mov    %eax,%edx
  8018a2:	85 d2                	test   %edx,%edx
  8018a4:	78 68                	js     80190e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b0:	8b 00                	mov    (%eax),%eax
  8018b2:	89 04 24             	mov    %eax,(%esp)
  8018b5:	e8 b2 fc ff ff       	call   80156c <dev_lookup>
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	78 50                	js     80190e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018c5:	75 23                	jne    8018ea <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018c7:	a1 18 50 80 00       	mov    0x805018,%eax
  8018cc:	8b 40 48             	mov    0x48(%eax),%eax
  8018cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d7:	c7 04 24 95 30 80 00 	movl   $0x803095,(%esp)
  8018de:	e8 52 ed ff ff       	call   800635 <cprintf>
		return -E_INVAL;
  8018e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018e8:	eb 24                	jmp    80190e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8018f0:	85 d2                	test   %edx,%edx
  8018f2:	74 15                	je     801909 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801902:	89 04 24             	mov    %eax,(%esp)
  801905:	ff d2                	call   *%edx
  801907:	eb 05                	jmp    80190e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801909:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80190e:	83 c4 24             	add    $0x24,%esp
  801911:	5b                   	pop    %ebx
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    

00801914 <seek>:

int
seek(int fdnum, off_t offset)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80191a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80191d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	89 04 24             	mov    %eax,(%esp)
  801927:	e8 ea fb ff ff       	call   801516 <fd_lookup>
  80192c:	85 c0                	test   %eax,%eax
  80192e:	78 0e                	js     80193e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801930:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801933:	8b 55 0c             	mov    0xc(%ebp),%edx
  801936:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801939:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	53                   	push   %ebx
  801944:	83 ec 24             	sub    $0x24,%esp
  801947:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80194a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80194d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801951:	89 1c 24             	mov    %ebx,(%esp)
  801954:	e8 bd fb ff ff       	call   801516 <fd_lookup>
  801959:	89 c2                	mov    %eax,%edx
  80195b:	85 d2                	test   %edx,%edx
  80195d:	78 61                	js     8019c0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80195f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801962:	89 44 24 04          	mov    %eax,0x4(%esp)
  801966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801969:	8b 00                	mov    (%eax),%eax
  80196b:	89 04 24             	mov    %eax,(%esp)
  80196e:	e8 f9 fb ff ff       	call   80156c <dev_lookup>
  801973:	85 c0                	test   %eax,%eax
  801975:	78 49                	js     8019c0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80197e:	75 23                	jne    8019a3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801980:	a1 18 50 80 00       	mov    0x805018,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801985:	8b 40 48             	mov    0x48(%eax),%eax
  801988:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80198c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801990:	c7 04 24 58 30 80 00 	movl   $0x803058,(%esp)
  801997:	e8 99 ec ff ff       	call   800635 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80199c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019a1:	eb 1d                	jmp    8019c0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8019a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a6:	8b 52 18             	mov    0x18(%edx),%edx
  8019a9:	85 d2                	test   %edx,%edx
  8019ab:	74 0e                	je     8019bb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019b0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019b4:	89 04 24             	mov    %eax,(%esp)
  8019b7:	ff d2                	call   *%edx
  8019b9:	eb 05                	jmp    8019c0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8019bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8019c0:	83 c4 24             	add    $0x24,%esp
  8019c3:	5b                   	pop    %ebx
  8019c4:	5d                   	pop    %ebp
  8019c5:	c3                   	ret    

008019c6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	53                   	push   %ebx
  8019ca:	83 ec 24             	sub    $0x24,%esp
  8019cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	89 04 24             	mov    %eax,(%esp)
  8019dd:	e8 34 fb ff ff       	call   801516 <fd_lookup>
  8019e2:	89 c2                	mov    %eax,%edx
  8019e4:	85 d2                	test   %edx,%edx
  8019e6:	78 52                	js     801a3a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f2:	8b 00                	mov    (%eax),%eax
  8019f4:	89 04 24             	mov    %eax,(%esp)
  8019f7:	e8 70 fb ff ff       	call   80156c <dev_lookup>
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 3a                	js     801a3a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a03:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a07:	74 2c                	je     801a35 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a09:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a0c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a13:	00 00 00 
	stat->st_isdir = 0;
  801a16:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a1d:	00 00 00 
	stat->st_dev = dev;
  801a20:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a26:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a2d:	89 14 24             	mov    %edx,(%esp)
  801a30:	ff 50 14             	call   *0x14(%eax)
  801a33:	eb 05                	jmp    801a3a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801a35:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801a3a:	83 c4 24             	add    $0x24,%esp
  801a3d:	5b                   	pop    %ebx
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    

00801a40 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	56                   	push   %esi
  801a44:	53                   	push   %ebx
  801a45:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a48:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a4f:	00 
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	89 04 24             	mov    %eax,(%esp)
  801a56:	e8 1b 02 00 00       	call   801c76 <open>
  801a5b:	89 c3                	mov    %eax,%ebx
  801a5d:	85 db                	test   %ebx,%ebx
  801a5f:	78 1b                	js     801a7c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a68:	89 1c 24             	mov    %ebx,(%esp)
  801a6b:	e8 56 ff ff ff       	call   8019c6 <fstat>
  801a70:	89 c6                	mov    %eax,%esi
	close(fd);
  801a72:	89 1c 24             	mov    %ebx,(%esp)
  801a75:	e8 cd fb ff ff       	call   801647 <close>
	return r;
  801a7a:	89 f0                	mov    %esi,%eax
}
  801a7c:	83 c4 10             	add    $0x10,%esp
  801a7f:	5b                   	pop    %ebx
  801a80:	5e                   	pop    %esi
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    

00801a83 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	56                   	push   %esi
  801a87:	53                   	push   %ebx
  801a88:	83 ec 10             	sub    $0x10,%esp
  801a8b:	89 c6                	mov    %eax,%esi
  801a8d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a8f:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801a96:	75 11                	jne    801aa9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a9f:	e8 cb 0d 00 00       	call   80286f <ipc_find_env>
  801aa4:	a3 10 50 80 00       	mov    %eax,0x805010
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801aa9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ab0:	00 
  801ab1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801ab8:	00 
  801ab9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801abd:	a1 10 50 80 00       	mov    0x805010,%eax
  801ac2:	89 04 24             	mov    %eax,(%esp)
  801ac5:	e8 3a 0d 00 00       	call   802804 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801aca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ad1:	00 
  801ad2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ad6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801add:	e8 ce 0c 00 00       	call   8027b0 <ipc_recv>
}
  801ae2:	83 c4 10             	add    $0x10,%esp
  801ae5:	5b                   	pop    %ebx
  801ae6:	5e                   	pop    %esi
  801ae7:	5d                   	pop    %ebp
  801ae8:	c3                   	ret    

00801ae9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	8b 40 0c             	mov    0xc(%eax),%eax
  801af5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b02:	ba 00 00 00 00       	mov    $0x0,%edx
  801b07:	b8 02 00 00 00       	mov    $0x2,%eax
  801b0c:	e8 72 ff ff ff       	call   801a83 <fsipc>
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b1f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b24:	ba 00 00 00 00       	mov    $0x0,%edx
  801b29:	b8 06 00 00 00       	mov    $0x6,%eax
  801b2e:	e8 50 ff ff ff       	call   801a83 <fsipc>
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	53                   	push   %ebx
  801b39:	83 ec 14             	sub    $0x14,%esp
  801b3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	8b 40 0c             	mov    0xc(%eax),%eax
  801b45:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4f:	b8 05 00 00 00       	mov    $0x5,%eax
  801b54:	e8 2a ff ff ff       	call   801a83 <fsipc>
  801b59:	89 c2                	mov    %eax,%edx
  801b5b:	85 d2                	test   %edx,%edx
  801b5d:	78 2b                	js     801b8a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b5f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b66:	00 
  801b67:	89 1c 24             	mov    %ebx,(%esp)
  801b6a:	e8 e8 f0 ff ff       	call   800c57 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b6f:	a1 80 60 80 00       	mov    0x806080,%eax
  801b74:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b7a:	a1 84 60 80 00       	mov    0x806084,%eax
  801b7f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8a:	83 c4 14             	add    $0x14,%esp
  801b8d:	5b                   	pop    %ebx
  801b8e:	5d                   	pop    %ebp
  801b8f:	c3                   	ret    

00801b90 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 18             	sub    $0x18,%esp
  801b96:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b99:	8b 55 08             	mov    0x8(%ebp),%edx
  801b9c:	8b 52 0c             	mov    0xc(%edx),%edx
  801b9f:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801ba5:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801baa:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb5:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801bbc:	e8 9b f2 ff ff       	call   800e5c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801bc1:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc6:	b8 04 00 00 00       	mov    $0x4,%eax
  801bcb:	e8 b3 fe ff ff       	call   801a83 <fsipc>
		return r;
	}

	return r;
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	56                   	push   %esi
  801bd6:	53                   	push   %ebx
  801bd7:	83 ec 10             	sub    $0x10,%esp
  801bda:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	8b 40 0c             	mov    0xc(%eax),%eax
  801be3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801be8:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bee:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf3:	b8 03 00 00 00       	mov    $0x3,%eax
  801bf8:	e8 86 fe ff ff       	call   801a83 <fsipc>
  801bfd:	89 c3                	mov    %eax,%ebx
  801bff:	85 c0                	test   %eax,%eax
  801c01:	78 6a                	js     801c6d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c03:	39 c6                	cmp    %eax,%esi
  801c05:	73 24                	jae    801c2b <devfile_read+0x59>
  801c07:	c7 44 24 0c c8 30 80 	movl   $0x8030c8,0xc(%esp)
  801c0e:	00 
  801c0f:	c7 44 24 08 cf 30 80 	movl   $0x8030cf,0x8(%esp)
  801c16:	00 
  801c17:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801c1e:	00 
  801c1f:	c7 04 24 e4 30 80 00 	movl   $0x8030e4,(%esp)
  801c26:	e8 2b 0b 00 00       	call   802756 <_panic>
	assert(r <= PGSIZE);
  801c2b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c30:	7e 24                	jle    801c56 <devfile_read+0x84>
  801c32:	c7 44 24 0c ef 30 80 	movl   $0x8030ef,0xc(%esp)
  801c39:	00 
  801c3a:	c7 44 24 08 cf 30 80 	movl   $0x8030cf,0x8(%esp)
  801c41:	00 
  801c42:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801c49:	00 
  801c4a:	c7 04 24 e4 30 80 00 	movl   $0x8030e4,(%esp)
  801c51:	e8 00 0b 00 00       	call   802756 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c56:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c5a:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c61:	00 
  801c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c65:	89 04 24             	mov    %eax,(%esp)
  801c68:	e8 87 f1 ff ff       	call   800df4 <memmove>
	return r;
}
  801c6d:	89 d8                	mov    %ebx,%eax
  801c6f:	83 c4 10             	add    $0x10,%esp
  801c72:	5b                   	pop    %ebx
  801c73:	5e                   	pop    %esi
  801c74:	5d                   	pop    %ebp
  801c75:	c3                   	ret    

00801c76 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	53                   	push   %ebx
  801c7a:	83 ec 24             	sub    $0x24,%esp
  801c7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c80:	89 1c 24             	mov    %ebx,(%esp)
  801c83:	e8 98 ef ff ff       	call   800c20 <strlen>
  801c88:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c8d:	7f 60                	jg     801cef <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c92:	89 04 24             	mov    %eax,(%esp)
  801c95:	e8 2d f8 ff ff       	call   8014c7 <fd_alloc>
  801c9a:	89 c2                	mov    %eax,%edx
  801c9c:	85 d2                	test   %edx,%edx
  801c9e:	78 54                	js     801cf4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801ca0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ca4:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801cab:	e8 a7 ef ff ff       	call   800c57 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb3:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801cb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cbb:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc0:	e8 be fd ff ff       	call   801a83 <fsipc>
  801cc5:	89 c3                	mov    %eax,%ebx
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	79 17                	jns    801ce2 <open+0x6c>
		fd_close(fd, 0);
  801ccb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cd2:	00 
  801cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd6:	89 04 24             	mov    %eax,(%esp)
  801cd9:	e8 e8 f8 ff ff       	call   8015c6 <fd_close>
		return r;
  801cde:	89 d8                	mov    %ebx,%eax
  801ce0:	eb 12                	jmp    801cf4 <open+0x7e>
	}

	return fd2num(fd);
  801ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce5:	89 04 24             	mov    %eax,(%esp)
  801ce8:	e8 b3 f7 ff ff       	call   8014a0 <fd2num>
  801ced:	eb 05                	jmp    801cf4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801cef:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801cf4:	83 c4 24             	add    $0x24,%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5d                   	pop    %ebp
  801cf9:	c3                   	ret    

00801cfa <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d00:	ba 00 00 00 00       	mov    $0x0,%edx
  801d05:	b8 08 00 00 00       	mov    $0x8,%eax
  801d0a:	e8 74 fd ff ff       	call   801a83 <fsipc>
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    
  801d11:	66 90                	xchg   %ax,%ax
  801d13:	66 90                	xchg   %ax,%ax
  801d15:	66 90                	xchg   %ax,%ax
  801d17:	66 90                	xchg   %ax,%ax
  801d19:	66 90                	xchg   %ax,%ax
  801d1b:	66 90                	xchg   %ax,%ax
  801d1d:	66 90                	xchg   %ax,%ax
  801d1f:	90                   	nop

00801d20 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801d26:	c7 44 24 04 fb 30 80 	movl   $0x8030fb,0x4(%esp)
  801d2d:	00 
  801d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d31:	89 04 24             	mov    %eax,(%esp)
  801d34:	e8 1e ef ff ff       	call   800c57 <strcpy>
	return 0;
}
  801d39:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	53                   	push   %ebx
  801d44:	83 ec 14             	sub    $0x14,%esp
  801d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d4a:	89 1c 24             	mov    %ebx,(%esp)
  801d4d:	e8 5c 0b 00 00       	call   8028ae <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801d52:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801d57:	83 f8 01             	cmp    $0x1,%eax
  801d5a:	75 0d                	jne    801d69 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801d5c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801d5f:	89 04 24             	mov    %eax,(%esp)
  801d62:	e8 29 03 00 00       	call   802090 <nsipc_close>
  801d67:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801d69:	89 d0                	mov    %edx,%eax
  801d6b:	83 c4 14             	add    $0x14,%esp
  801d6e:	5b                   	pop    %ebx
  801d6f:	5d                   	pop    %ebp
  801d70:	c3                   	ret    

00801d71 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d77:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d7e:	00 
  801d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d82:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d90:	8b 40 0c             	mov    0xc(%eax),%eax
  801d93:	89 04 24             	mov    %eax,(%esp)
  801d96:	e8 f0 03 00 00       	call   80218b <nsipc_send>
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801da3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801daa:	00 
  801dab:	8b 45 10             	mov    0x10(%ebp),%eax
  801dae:	89 44 24 08          	mov    %eax,0x8(%esp)
  801db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	8b 40 0c             	mov    0xc(%eax),%eax
  801dbf:	89 04 24             	mov    %eax,(%esp)
  801dc2:	e8 44 03 00 00       	call   80210b <nsipc_recv>
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801dcf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801dd2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dd6:	89 04 24             	mov    %eax,(%esp)
  801dd9:	e8 38 f7 ff ff       	call   801516 <fd_lookup>
  801dde:	85 c0                	test   %eax,%eax
  801de0:	78 17                	js     801df9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801deb:	39 08                	cmp    %ecx,(%eax)
  801ded:	75 05                	jne    801df4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801def:	8b 40 0c             	mov    0xc(%eax),%eax
  801df2:	eb 05                	jmp    801df9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801df4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	56                   	push   %esi
  801dff:	53                   	push   %ebx
  801e00:	83 ec 20             	sub    $0x20,%esp
  801e03:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801e05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e08:	89 04 24             	mov    %eax,(%esp)
  801e0b:	e8 b7 f6 ff ff       	call   8014c7 <fd_alloc>
  801e10:	89 c3                	mov    %eax,%ebx
  801e12:	85 c0                	test   %eax,%eax
  801e14:	78 21                	js     801e37 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e16:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e1d:	00 
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e2c:	e8 42 f2 ff ff       	call   801073 <sys_page_alloc>
  801e31:	89 c3                	mov    %eax,%ebx
  801e33:	85 c0                	test   %eax,%eax
  801e35:	79 0c                	jns    801e43 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801e37:	89 34 24             	mov    %esi,(%esp)
  801e3a:	e8 51 02 00 00       	call   802090 <nsipc_close>
		return r;
  801e3f:	89 d8                	mov    %ebx,%eax
  801e41:	eb 20                	jmp    801e63 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801e43:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e51:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801e58:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801e5b:	89 14 24             	mov    %edx,(%esp)
  801e5e:	e8 3d f6 ff ff       	call   8014a0 <fd2num>
}
  801e63:	83 c4 20             	add    $0x20,%esp
  801e66:	5b                   	pop    %ebx
  801e67:	5e                   	pop    %esi
  801e68:	5d                   	pop    %ebp
  801e69:	c3                   	ret    

00801e6a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	e8 51 ff ff ff       	call   801dc9 <fd2sockid>
		return r;
  801e78:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	78 23                	js     801ea1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e7e:	8b 55 10             	mov    0x10(%ebp),%edx
  801e81:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e88:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e8c:	89 04 24             	mov    %eax,(%esp)
  801e8f:	e8 45 01 00 00       	call   801fd9 <nsipc_accept>
		return r;
  801e94:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e96:	85 c0                	test   %eax,%eax
  801e98:	78 07                	js     801ea1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801e9a:	e8 5c ff ff ff       	call   801dfb <alloc_sockfd>
  801e9f:	89 c1                	mov    %eax,%ecx
}
  801ea1:	89 c8                	mov    %ecx,%eax
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	e8 16 ff ff ff       	call   801dc9 <fd2sockid>
  801eb3:	89 c2                	mov    %eax,%edx
  801eb5:	85 d2                	test   %edx,%edx
  801eb7:	78 16                	js     801ecf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec7:	89 14 24             	mov    %edx,(%esp)
  801eca:	e8 60 01 00 00       	call   80202f <nsipc_bind>
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <shutdown>:

int
shutdown(int s, int how)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	e8 ea fe ff ff       	call   801dc9 <fd2sockid>
  801edf:	89 c2                	mov    %eax,%edx
  801ee1:	85 d2                	test   %edx,%edx
  801ee3:	78 0f                	js     801ef4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eec:	89 14 24             	mov    %edx,(%esp)
  801eef:	e8 7a 01 00 00       	call   80206e <nsipc_shutdown>
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	e8 c5 fe ff ff       	call   801dc9 <fd2sockid>
  801f04:	89 c2                	mov    %eax,%edx
  801f06:	85 d2                	test   %edx,%edx
  801f08:	78 16                	js     801f20 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f18:	89 14 24             	mov    %edx,(%esp)
  801f1b:	e8 8a 01 00 00       	call   8020aa <nsipc_connect>
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <listen>:

int
listen(int s, int backlog)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	e8 99 fe ff ff       	call   801dc9 <fd2sockid>
  801f30:	89 c2                	mov    %eax,%edx
  801f32:	85 d2                	test   %edx,%edx
  801f34:	78 0f                	js     801f45 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3d:	89 14 24             	mov    %edx,(%esp)
  801f40:	e8 a4 01 00 00       	call   8020e9 <nsipc_listen>
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
  801f4a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f50:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	89 04 24             	mov    %eax,(%esp)
  801f61:	e8 98 02 00 00       	call   8021fe <nsipc_socket>
  801f66:	89 c2                	mov    %eax,%edx
  801f68:	85 d2                	test   %edx,%edx
  801f6a:	78 05                	js     801f71 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801f6c:	e8 8a fe ff ff       	call   801dfb <alloc_sockfd>
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	53                   	push   %ebx
  801f77:	83 ec 14             	sub    $0x14,%esp
  801f7a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f7c:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801f83:	75 11                	jne    801f96 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f85:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801f8c:	e8 de 08 00 00       	call   80286f <ipc_find_env>
  801f91:	a3 14 50 80 00       	mov    %eax,0x805014
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f96:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f9d:	00 
  801f9e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801fa5:	00 
  801fa6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801faa:	a1 14 50 80 00       	mov    0x805014,%eax
  801faf:	89 04 24             	mov    %eax,(%esp)
  801fb2:	e8 4d 08 00 00       	call   802804 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fb7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fbe:	00 
  801fbf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fc6:	00 
  801fc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fce:	e8 dd 07 00 00       	call   8027b0 <ipc_recv>
}
  801fd3:	83 c4 14             	add    $0x14,%esp
  801fd6:	5b                   	pop    %ebx
  801fd7:	5d                   	pop    %ebp
  801fd8:	c3                   	ret    

00801fd9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	56                   	push   %esi
  801fdd:	53                   	push   %ebx
  801fde:	83 ec 10             	sub    $0x10,%esp
  801fe1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801fec:	8b 06                	mov    (%esi),%eax
  801fee:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ff3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff8:	e8 76 ff ff ff       	call   801f73 <nsipc>
  801ffd:	89 c3                	mov    %eax,%ebx
  801fff:	85 c0                	test   %eax,%eax
  802001:	78 23                	js     802026 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802003:	a1 10 70 80 00       	mov    0x807010,%eax
  802008:	89 44 24 08          	mov    %eax,0x8(%esp)
  80200c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802013:	00 
  802014:	8b 45 0c             	mov    0xc(%ebp),%eax
  802017:	89 04 24             	mov    %eax,(%esp)
  80201a:	e8 d5 ed ff ff       	call   800df4 <memmove>
		*addrlen = ret->ret_addrlen;
  80201f:	a1 10 70 80 00       	mov    0x807010,%eax
  802024:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802026:	89 d8                	mov    %ebx,%eax
  802028:	83 c4 10             	add    $0x10,%esp
  80202b:	5b                   	pop    %ebx
  80202c:	5e                   	pop    %esi
  80202d:	5d                   	pop    %ebp
  80202e:	c3                   	ret    

0080202f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	53                   	push   %ebx
  802033:	83 ec 14             	sub    $0x14,%esp
  802036:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802041:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802045:	8b 45 0c             	mov    0xc(%ebp),%eax
  802048:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802053:	e8 9c ed ff ff       	call   800df4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802058:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80205e:	b8 02 00 00 00       	mov    $0x2,%eax
  802063:	e8 0b ff ff ff       	call   801f73 <nsipc>
}
  802068:	83 c4 14             	add    $0x14,%esp
  80206b:	5b                   	pop    %ebx
  80206c:	5d                   	pop    %ebp
  80206d:	c3                   	ret    

0080206e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80207c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802084:	b8 03 00 00 00       	mov    $0x3,%eax
  802089:	e8 e5 fe ff ff       	call   801f73 <nsipc>
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <nsipc_close>:

int
nsipc_close(int s)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80209e:	b8 04 00 00 00       	mov    $0x4,%eax
  8020a3:	e8 cb fe ff ff       	call   801f73 <nsipc>
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	53                   	push   %ebx
  8020ae:	83 ec 14             	sub    $0x14,%esp
  8020b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8020ce:	e8 21 ed ff ff       	call   800df4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020d3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020d9:	b8 05 00 00 00       	mov    $0x5,%eax
  8020de:	e8 90 fe ff ff       	call   801f73 <nsipc>
}
  8020e3:	83 c4 14             	add    $0x14,%esp
  8020e6:	5b                   	pop    %ebx
  8020e7:	5d                   	pop    %ebp
  8020e8:	c3                   	ret    

008020e9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fa:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020ff:	b8 06 00 00 00       	mov    $0x6,%eax
  802104:	e8 6a fe ff ff       	call   801f73 <nsipc>
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	56                   	push   %esi
  80210f:	53                   	push   %ebx
  802110:	83 ec 10             	sub    $0x10,%esp
  802113:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80211e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802124:	8b 45 14             	mov    0x14(%ebp),%eax
  802127:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80212c:	b8 07 00 00 00       	mov    $0x7,%eax
  802131:	e8 3d fe ff ff       	call   801f73 <nsipc>
  802136:	89 c3                	mov    %eax,%ebx
  802138:	85 c0                	test   %eax,%eax
  80213a:	78 46                	js     802182 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80213c:	39 f0                	cmp    %esi,%eax
  80213e:	7f 07                	jg     802147 <nsipc_recv+0x3c>
  802140:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802145:	7e 24                	jle    80216b <nsipc_recv+0x60>
  802147:	c7 44 24 0c 07 31 80 	movl   $0x803107,0xc(%esp)
  80214e:	00 
  80214f:	c7 44 24 08 cf 30 80 	movl   $0x8030cf,0x8(%esp)
  802156:	00 
  802157:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80215e:	00 
  80215f:	c7 04 24 1c 31 80 00 	movl   $0x80311c,(%esp)
  802166:	e8 eb 05 00 00       	call   802756 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80216b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80216f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802176:	00 
  802177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217a:	89 04 24             	mov    %eax,(%esp)
  80217d:	e8 72 ec ff ff       	call   800df4 <memmove>
	}

	return r;
}
  802182:	89 d8                	mov    %ebx,%eax
  802184:	83 c4 10             	add    $0x10,%esp
  802187:	5b                   	pop    %ebx
  802188:	5e                   	pop    %esi
  802189:	5d                   	pop    %ebp
  80218a:	c3                   	ret    

0080218b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	53                   	push   %ebx
  80218f:	83 ec 14             	sub    $0x14,%esp
  802192:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80219d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021a3:	7e 24                	jle    8021c9 <nsipc_send+0x3e>
  8021a5:	c7 44 24 0c 28 31 80 	movl   $0x803128,0xc(%esp)
  8021ac:	00 
  8021ad:	c7 44 24 08 cf 30 80 	movl   $0x8030cf,0x8(%esp)
  8021b4:	00 
  8021b5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8021bc:	00 
  8021bd:	c7 04 24 1c 31 80 00 	movl   $0x80311c,(%esp)
  8021c4:	e8 8d 05 00 00       	call   802756 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8021db:	e8 14 ec ff ff       	call   800df4 <memmove>
	nsipcbuf.send.req_size = size;
  8021e0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8021f3:	e8 7b fd ff ff       	call   801f73 <nsipc>
}
  8021f8:	83 c4 14             	add    $0x14,%esp
  8021fb:	5b                   	pop    %ebx
  8021fc:	5d                   	pop    %ebp
  8021fd:	c3                   	ret    

008021fe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80220c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802214:	8b 45 10             	mov    0x10(%ebp),%eax
  802217:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80221c:	b8 09 00 00 00       	mov    $0x9,%eax
  802221:	e8 4d fd ff ff       	call   801f73 <nsipc>
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	56                   	push   %esi
  80222c:	53                   	push   %ebx
  80222d:	83 ec 10             	sub    $0x10,%esp
  802230:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	89 04 24             	mov    %eax,(%esp)
  802239:	e8 72 f2 ff ff       	call   8014b0 <fd2data>
  80223e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802240:	c7 44 24 04 34 31 80 	movl   $0x803134,0x4(%esp)
  802247:	00 
  802248:	89 1c 24             	mov    %ebx,(%esp)
  80224b:	e8 07 ea ff ff       	call   800c57 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802250:	8b 46 04             	mov    0x4(%esi),%eax
  802253:	2b 06                	sub    (%esi),%eax
  802255:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80225b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802262:	00 00 00 
	stat->st_dev = &devpipe;
  802265:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80226c:	40 80 00 
	return 0;
}
  80226f:	b8 00 00 00 00       	mov    $0x0,%eax
  802274:	83 c4 10             	add    $0x10,%esp
  802277:	5b                   	pop    %ebx
  802278:	5e                   	pop    %esi
  802279:	5d                   	pop    %ebp
  80227a:	c3                   	ret    

0080227b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	53                   	push   %ebx
  80227f:	83 ec 14             	sub    $0x14,%esp
  802282:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802285:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802289:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802290:	e8 85 ee ff ff       	call   80111a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802295:	89 1c 24             	mov    %ebx,(%esp)
  802298:	e8 13 f2 ff ff       	call   8014b0 <fd2data>
  80229d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022a8:	e8 6d ee ff ff       	call   80111a <sys_page_unmap>
}
  8022ad:	83 c4 14             	add    $0x14,%esp
  8022b0:	5b                   	pop    %ebx
  8022b1:	5d                   	pop    %ebp
  8022b2:	c3                   	ret    

008022b3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
  8022b6:	57                   	push   %edi
  8022b7:	56                   	push   %esi
  8022b8:	53                   	push   %ebx
  8022b9:	83 ec 2c             	sub    $0x2c,%esp
  8022bc:	89 c6                	mov    %eax,%esi
  8022be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8022c1:	a1 18 50 80 00       	mov    0x805018,%eax
  8022c6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022c9:	89 34 24             	mov    %esi,(%esp)
  8022cc:	e8 dd 05 00 00       	call   8028ae <pageref>
  8022d1:	89 c7                	mov    %eax,%edi
  8022d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022d6:	89 04 24             	mov    %eax,(%esp)
  8022d9:	e8 d0 05 00 00       	call   8028ae <pageref>
  8022de:	39 c7                	cmp    %eax,%edi
  8022e0:	0f 94 c2             	sete   %dl
  8022e3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8022e6:	8b 0d 18 50 80 00    	mov    0x805018,%ecx
  8022ec:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8022ef:	39 fb                	cmp    %edi,%ebx
  8022f1:	74 21                	je     802314 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8022f3:	84 d2                	test   %dl,%dl
  8022f5:	74 ca                	je     8022c1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022f7:	8b 51 58             	mov    0x58(%ecx),%edx
  8022fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022fe:	89 54 24 08          	mov    %edx,0x8(%esp)
  802302:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802306:	c7 04 24 3b 31 80 00 	movl   $0x80313b,(%esp)
  80230d:	e8 23 e3 ff ff       	call   800635 <cprintf>
  802312:	eb ad                	jmp    8022c1 <_pipeisclosed+0xe>
	}
}
  802314:	83 c4 2c             	add    $0x2c,%esp
  802317:	5b                   	pop    %ebx
  802318:	5e                   	pop    %esi
  802319:	5f                   	pop    %edi
  80231a:	5d                   	pop    %ebp
  80231b:	c3                   	ret    

0080231c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	57                   	push   %edi
  802320:	56                   	push   %esi
  802321:	53                   	push   %ebx
  802322:	83 ec 1c             	sub    $0x1c,%esp
  802325:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802328:	89 34 24             	mov    %esi,(%esp)
  80232b:	e8 80 f1 ff ff       	call   8014b0 <fd2data>
  802330:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802332:	bf 00 00 00 00       	mov    $0x0,%edi
  802337:	eb 45                	jmp    80237e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802339:	89 da                	mov    %ebx,%edx
  80233b:	89 f0                	mov    %esi,%eax
  80233d:	e8 71 ff ff ff       	call   8022b3 <_pipeisclosed>
  802342:	85 c0                	test   %eax,%eax
  802344:	75 41                	jne    802387 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802346:	e8 09 ed ff ff       	call   801054 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80234b:	8b 43 04             	mov    0x4(%ebx),%eax
  80234e:	8b 0b                	mov    (%ebx),%ecx
  802350:	8d 51 20             	lea    0x20(%ecx),%edx
  802353:	39 d0                	cmp    %edx,%eax
  802355:	73 e2                	jae    802339 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802357:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80235a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80235e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802361:	99                   	cltd   
  802362:	c1 ea 1b             	shr    $0x1b,%edx
  802365:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802368:	83 e1 1f             	and    $0x1f,%ecx
  80236b:	29 d1                	sub    %edx,%ecx
  80236d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802371:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802375:	83 c0 01             	add    $0x1,%eax
  802378:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80237b:	83 c7 01             	add    $0x1,%edi
  80237e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802381:	75 c8                	jne    80234b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802383:	89 f8                	mov    %edi,%eax
  802385:	eb 05                	jmp    80238c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802387:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80238c:	83 c4 1c             	add    $0x1c,%esp
  80238f:	5b                   	pop    %ebx
  802390:	5e                   	pop    %esi
  802391:	5f                   	pop    %edi
  802392:	5d                   	pop    %ebp
  802393:	c3                   	ret    

00802394 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
  802397:	57                   	push   %edi
  802398:	56                   	push   %esi
  802399:	53                   	push   %ebx
  80239a:	83 ec 1c             	sub    $0x1c,%esp
  80239d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8023a0:	89 3c 24             	mov    %edi,(%esp)
  8023a3:	e8 08 f1 ff ff       	call   8014b0 <fd2data>
  8023a8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023aa:	be 00 00 00 00       	mov    $0x0,%esi
  8023af:	eb 3d                	jmp    8023ee <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8023b1:	85 f6                	test   %esi,%esi
  8023b3:	74 04                	je     8023b9 <devpipe_read+0x25>
				return i;
  8023b5:	89 f0                	mov    %esi,%eax
  8023b7:	eb 43                	jmp    8023fc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8023b9:	89 da                	mov    %ebx,%edx
  8023bb:	89 f8                	mov    %edi,%eax
  8023bd:	e8 f1 fe ff ff       	call   8022b3 <_pipeisclosed>
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	75 31                	jne    8023f7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8023c6:	e8 89 ec ff ff       	call   801054 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8023cb:	8b 03                	mov    (%ebx),%eax
  8023cd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023d0:	74 df                	je     8023b1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023d2:	99                   	cltd   
  8023d3:	c1 ea 1b             	shr    $0x1b,%edx
  8023d6:	01 d0                	add    %edx,%eax
  8023d8:	83 e0 1f             	and    $0x1f,%eax
  8023db:	29 d0                	sub    %edx,%eax
  8023dd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023e5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023e8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023eb:	83 c6 01             	add    $0x1,%esi
  8023ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023f1:	75 d8                	jne    8023cb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8023f3:	89 f0                	mov    %esi,%eax
  8023f5:	eb 05                	jmp    8023fc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8023f7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8023fc:	83 c4 1c             	add    $0x1c,%esp
  8023ff:	5b                   	pop    %ebx
  802400:	5e                   	pop    %esi
  802401:	5f                   	pop    %edi
  802402:	5d                   	pop    %ebp
  802403:	c3                   	ret    

00802404 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
  802407:	56                   	push   %esi
  802408:	53                   	push   %ebx
  802409:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80240c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80240f:	89 04 24             	mov    %eax,(%esp)
  802412:	e8 b0 f0 ff ff       	call   8014c7 <fd_alloc>
  802417:	89 c2                	mov    %eax,%edx
  802419:	85 d2                	test   %edx,%edx
  80241b:	0f 88 4d 01 00 00    	js     80256e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802421:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802428:	00 
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802430:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802437:	e8 37 ec ff ff       	call   801073 <sys_page_alloc>
  80243c:	89 c2                	mov    %eax,%edx
  80243e:	85 d2                	test   %edx,%edx
  802440:	0f 88 28 01 00 00    	js     80256e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802446:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802449:	89 04 24             	mov    %eax,(%esp)
  80244c:	e8 76 f0 ff ff       	call   8014c7 <fd_alloc>
  802451:	89 c3                	mov    %eax,%ebx
  802453:	85 c0                	test   %eax,%eax
  802455:	0f 88 fe 00 00 00    	js     802559 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80245b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802462:	00 
  802463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802466:	89 44 24 04          	mov    %eax,0x4(%esp)
  80246a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802471:	e8 fd eb ff ff       	call   801073 <sys_page_alloc>
  802476:	89 c3                	mov    %eax,%ebx
  802478:	85 c0                	test   %eax,%eax
  80247a:	0f 88 d9 00 00 00    	js     802559 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	89 04 24             	mov    %eax,(%esp)
  802486:	e8 25 f0 ff ff       	call   8014b0 <fd2data>
  80248b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80248d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802494:	00 
  802495:	89 44 24 04          	mov    %eax,0x4(%esp)
  802499:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a0:	e8 ce eb ff ff       	call   801073 <sys_page_alloc>
  8024a5:	89 c3                	mov    %eax,%ebx
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	0f 88 97 00 00 00    	js     802546 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b2:	89 04 24             	mov    %eax,(%esp)
  8024b5:	e8 f6 ef ff ff       	call   8014b0 <fd2data>
  8024ba:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8024c1:	00 
  8024c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024cd:	00 
  8024ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d9:	e8 e9 eb ff ff       	call   8010c7 <sys_page_map>
  8024de:	89 c3                	mov    %eax,%ebx
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	78 52                	js     802536 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8024e4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8024f9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8024ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802502:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802507:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	89 04 24             	mov    %eax,(%esp)
  802514:	e8 87 ef ff ff       	call   8014a0 <fd2num>
  802519:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80251c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80251e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802521:	89 04 24             	mov    %eax,(%esp)
  802524:	e8 77 ef ff ff       	call   8014a0 <fd2num>
  802529:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80252c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80252f:	b8 00 00 00 00       	mov    $0x0,%eax
  802534:	eb 38                	jmp    80256e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802536:	89 74 24 04          	mov    %esi,0x4(%esp)
  80253a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802541:	e8 d4 eb ff ff       	call   80111a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802549:	89 44 24 04          	mov    %eax,0x4(%esp)
  80254d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802554:	e8 c1 eb ff ff       	call   80111a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802560:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802567:	e8 ae eb ff ff       	call   80111a <sys_page_unmap>
  80256c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80256e:	83 c4 30             	add    $0x30,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5d                   	pop    %ebp
  802574:	c3                   	ret    

00802575 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
  802578:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80257b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80257e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802582:	8b 45 08             	mov    0x8(%ebp),%eax
  802585:	89 04 24             	mov    %eax,(%esp)
  802588:	e8 89 ef ff ff       	call   801516 <fd_lookup>
  80258d:	89 c2                	mov    %eax,%edx
  80258f:	85 d2                	test   %edx,%edx
  802591:	78 15                	js     8025a8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	89 04 24             	mov    %eax,(%esp)
  802599:	e8 12 ef ff ff       	call   8014b0 <fd2data>
	return _pipeisclosed(fd, p);
  80259e:	89 c2                	mov    %eax,%edx
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	e8 0b fd ff ff       	call   8022b3 <_pipeisclosed>
}
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    
  8025aa:	66 90                	xchg   %ax,%ax
  8025ac:	66 90                	xchg   %ax,%ax
  8025ae:	66 90                	xchg   %ax,%ax

008025b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b8:	5d                   	pop    %ebp
  8025b9:	c3                   	ret    

008025ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
  8025bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8025c0:	c7 44 24 04 53 31 80 	movl   $0x803153,0x4(%esp)
  8025c7:	00 
  8025c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025cb:	89 04 24             	mov    %eax,(%esp)
  8025ce:	e8 84 e6 ff ff       	call   800c57 <strcpy>
	return 0;
}
  8025d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	57                   	push   %edi
  8025de:	56                   	push   %esi
  8025df:	53                   	push   %ebx
  8025e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025e6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025eb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025f1:	eb 31                	jmp    802624 <devcons_write+0x4a>
		m = n - tot;
  8025f3:	8b 75 10             	mov    0x10(%ebp),%esi
  8025f6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8025f8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8025fb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802600:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802603:	89 74 24 08          	mov    %esi,0x8(%esp)
  802607:	03 45 0c             	add    0xc(%ebp),%eax
  80260a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80260e:	89 3c 24             	mov    %edi,(%esp)
  802611:	e8 de e7 ff ff       	call   800df4 <memmove>
		sys_cputs(buf, m);
  802616:	89 74 24 04          	mov    %esi,0x4(%esp)
  80261a:	89 3c 24             	mov    %edi,(%esp)
  80261d:	e8 84 e9 ff ff       	call   800fa6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802622:	01 f3                	add    %esi,%ebx
  802624:	89 d8                	mov    %ebx,%eax
  802626:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802629:	72 c8                	jb     8025f3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80262b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802631:	5b                   	pop    %ebx
  802632:	5e                   	pop    %esi
  802633:	5f                   	pop    %edi
  802634:	5d                   	pop    %ebp
  802635:	c3                   	ret    

00802636 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
  802639:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80263c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802641:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802645:	75 07                	jne    80264e <devcons_read+0x18>
  802647:	eb 2a                	jmp    802673 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802649:	e8 06 ea ff ff       	call   801054 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80264e:	66 90                	xchg   %ax,%ax
  802650:	e8 6f e9 ff ff       	call   800fc4 <sys_cgetc>
  802655:	85 c0                	test   %eax,%eax
  802657:	74 f0                	je     802649 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802659:	85 c0                	test   %eax,%eax
  80265b:	78 16                	js     802673 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80265d:	83 f8 04             	cmp    $0x4,%eax
  802660:	74 0c                	je     80266e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802662:	8b 55 0c             	mov    0xc(%ebp),%edx
  802665:	88 02                	mov    %al,(%edx)
	return 1;
  802667:	b8 01 00 00 00       	mov    $0x1,%eax
  80266c:	eb 05                	jmp    802673 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80266e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
  802678:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802681:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802688:	00 
  802689:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80268c:	89 04 24             	mov    %eax,(%esp)
  80268f:	e8 12 e9 ff ff       	call   800fa6 <sys_cputs>
}
  802694:	c9                   	leave  
  802695:	c3                   	ret    

00802696 <getchar>:

int
getchar(void)
{
  802696:	55                   	push   %ebp
  802697:	89 e5                	mov    %esp,%ebp
  802699:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80269c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8026a3:	00 
  8026a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b2:	e8 f3 f0 ff ff       	call   8017aa <read>
	if (r < 0)
  8026b7:	85 c0                	test   %eax,%eax
  8026b9:	78 0f                	js     8026ca <getchar+0x34>
		return r;
	if (r < 1)
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	7e 06                	jle    8026c5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8026bf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8026c3:	eb 05                	jmp    8026ca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8026c5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8026ca:	c9                   	leave  
  8026cb:	c3                   	ret    

008026cc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8026cc:	55                   	push   %ebp
  8026cd:	89 e5                	mov    %esp,%ebp
  8026cf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	89 04 24             	mov    %eax,(%esp)
  8026df:	e8 32 ee ff ff       	call   801516 <fd_lookup>
  8026e4:	85 c0                	test   %eax,%eax
  8026e6:	78 11                	js     8026f9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026f1:	39 10                	cmp    %edx,(%eax)
  8026f3:	0f 94 c0             	sete   %al
  8026f6:	0f b6 c0             	movzbl %al,%eax
}
  8026f9:	c9                   	leave  
  8026fa:	c3                   	ret    

008026fb <opencons>:

int
opencons(void)
{
  8026fb:	55                   	push   %ebp
  8026fc:	89 e5                	mov    %esp,%ebp
  8026fe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802701:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802704:	89 04 24             	mov    %eax,(%esp)
  802707:	e8 bb ed ff ff       	call   8014c7 <fd_alloc>
		return r;
  80270c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80270e:	85 c0                	test   %eax,%eax
  802710:	78 40                	js     802752 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802712:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802719:	00 
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802721:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802728:	e8 46 e9 ff ff       	call   801073 <sys_page_alloc>
		return r;
  80272d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80272f:	85 c0                	test   %eax,%eax
  802731:	78 1f                	js     802752 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802733:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802748:	89 04 24             	mov    %eax,(%esp)
  80274b:	e8 50 ed ff ff       	call   8014a0 <fd2num>
  802750:	89 c2                	mov    %eax,%edx
}
  802752:	89 d0                	mov    %edx,%eax
  802754:	c9                   	leave  
  802755:	c3                   	ret    

00802756 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	56                   	push   %esi
  80275a:	53                   	push   %ebx
  80275b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80275e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802761:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802767:	e8 c9 e8 ff ff       	call   801035 <sys_getenvid>
  80276c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802773:	8b 55 08             	mov    0x8(%ebp),%edx
  802776:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80277a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80277e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802782:	c7 04 24 60 31 80 00 	movl   $0x803160,(%esp)
  802789:	e8 a7 de ff ff       	call   800635 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80278e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802792:	8b 45 10             	mov    0x10(%ebp),%eax
  802795:	89 04 24             	mov    %eax,(%esp)
  802798:	e8 37 de ff ff       	call   8005d4 <vcprintf>
	cprintf("\n");
  80279d:	c7 04 24 4c 31 80 00 	movl   $0x80314c,(%esp)
  8027a4:	e8 8c de ff ff       	call   800635 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8027a9:	cc                   	int3   
  8027aa:	eb fd                	jmp    8027a9 <_panic+0x53>
  8027ac:	66 90                	xchg   %ax,%ax
  8027ae:	66 90                	xchg   %ax,%ax

008027b0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
  8027b3:	56                   	push   %esi
  8027b4:	53                   	push   %ebx
  8027b5:	83 ec 10             	sub    $0x10,%esp
  8027b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8027bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8027c1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  8027c3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8027c8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  8027cb:	89 04 24             	mov    %eax,(%esp)
  8027ce:	e8 b6 ea ff ff       	call   801289 <sys_ipc_recv>
  8027d3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  8027d5:	85 d2                	test   %edx,%edx
  8027d7:	75 24                	jne    8027fd <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  8027d9:	85 f6                	test   %esi,%esi
  8027db:	74 0a                	je     8027e7 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  8027dd:	a1 18 50 80 00       	mov    0x805018,%eax
  8027e2:	8b 40 74             	mov    0x74(%eax),%eax
  8027e5:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  8027e7:	85 db                	test   %ebx,%ebx
  8027e9:	74 0a                	je     8027f5 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  8027eb:	a1 18 50 80 00       	mov    0x805018,%eax
  8027f0:	8b 40 78             	mov    0x78(%eax),%eax
  8027f3:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8027f5:	a1 18 50 80 00       	mov    0x805018,%eax
  8027fa:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  8027fd:	83 c4 10             	add    $0x10,%esp
  802800:	5b                   	pop    %ebx
  802801:	5e                   	pop    %esi
  802802:	5d                   	pop    %ebp
  802803:	c3                   	ret    

00802804 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802804:	55                   	push   %ebp
  802805:	89 e5                	mov    %esp,%ebp
  802807:	57                   	push   %edi
  802808:	56                   	push   %esi
  802809:	53                   	push   %ebx
  80280a:	83 ec 1c             	sub    $0x1c,%esp
  80280d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802810:	8b 75 0c             	mov    0xc(%ebp),%esi
  802813:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802816:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802818:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80281d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802820:	8b 45 14             	mov    0x14(%ebp),%eax
  802823:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802827:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80282b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80282f:	89 3c 24             	mov    %edi,(%esp)
  802832:	e8 2f ea ff ff       	call   801266 <sys_ipc_try_send>

		if (ret == 0)
  802837:	85 c0                	test   %eax,%eax
  802839:	74 2c                	je     802867 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80283b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80283e:	74 20                	je     802860 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802840:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802844:	c7 44 24 08 84 31 80 	movl   $0x803184,0x8(%esp)
  80284b:	00 
  80284c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802853:	00 
  802854:	c7 04 24 b4 31 80 00 	movl   $0x8031b4,(%esp)
  80285b:	e8 f6 fe ff ff       	call   802756 <_panic>
		}

		sys_yield();
  802860:	e8 ef e7 ff ff       	call   801054 <sys_yield>
	}
  802865:	eb b9                	jmp    802820 <ipc_send+0x1c>
}
  802867:	83 c4 1c             	add    $0x1c,%esp
  80286a:	5b                   	pop    %ebx
  80286b:	5e                   	pop    %esi
  80286c:	5f                   	pop    %edi
  80286d:	5d                   	pop    %ebp
  80286e:	c3                   	ret    

0080286f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80286f:	55                   	push   %ebp
  802870:	89 e5                	mov    %esp,%ebp
  802872:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802875:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80287a:	89 c2                	mov    %eax,%edx
  80287c:	c1 e2 07             	shl    $0x7,%edx
  80287f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802886:	8b 52 50             	mov    0x50(%edx),%edx
  802889:	39 ca                	cmp    %ecx,%edx
  80288b:	75 11                	jne    80289e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80288d:	89 c2                	mov    %eax,%edx
  80288f:	c1 e2 07             	shl    $0x7,%edx
  802892:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802899:	8b 40 40             	mov    0x40(%eax),%eax
  80289c:	eb 0e                	jmp    8028ac <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80289e:	83 c0 01             	add    $0x1,%eax
  8028a1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028a6:	75 d2                	jne    80287a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8028a8:	66 b8 00 00          	mov    $0x0,%ax
}
  8028ac:	5d                   	pop    %ebp
  8028ad:	c3                   	ret    

008028ae <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028ae:	55                   	push   %ebp
  8028af:	89 e5                	mov    %esp,%ebp
  8028b1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028b4:	89 d0                	mov    %edx,%eax
  8028b6:	c1 e8 16             	shr    $0x16,%eax
  8028b9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028c0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028c5:	f6 c1 01             	test   $0x1,%cl
  8028c8:	74 1d                	je     8028e7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8028ca:	c1 ea 0c             	shr    $0xc,%edx
  8028cd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028d4:	f6 c2 01             	test   $0x1,%dl
  8028d7:	74 0e                	je     8028e7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028d9:	c1 ea 0c             	shr    $0xc,%edx
  8028dc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028e3:	ef 
  8028e4:	0f b7 c0             	movzwl %ax,%eax
}
  8028e7:	5d                   	pop    %ebp
  8028e8:	c3                   	ret    
  8028e9:	66 90                	xchg   %ax,%ax
  8028eb:	66 90                	xchg   %ax,%ax
  8028ed:	66 90                	xchg   %ax,%ax
  8028ef:	90                   	nop

008028f0 <__udivdi3>:
  8028f0:	55                   	push   %ebp
  8028f1:	57                   	push   %edi
  8028f2:	56                   	push   %esi
  8028f3:	83 ec 0c             	sub    $0xc,%esp
  8028f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8028fa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8028fe:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802902:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802906:	85 c0                	test   %eax,%eax
  802908:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80290c:	89 ea                	mov    %ebp,%edx
  80290e:	89 0c 24             	mov    %ecx,(%esp)
  802911:	75 2d                	jne    802940 <__udivdi3+0x50>
  802913:	39 e9                	cmp    %ebp,%ecx
  802915:	77 61                	ja     802978 <__udivdi3+0x88>
  802917:	85 c9                	test   %ecx,%ecx
  802919:	89 ce                	mov    %ecx,%esi
  80291b:	75 0b                	jne    802928 <__udivdi3+0x38>
  80291d:	b8 01 00 00 00       	mov    $0x1,%eax
  802922:	31 d2                	xor    %edx,%edx
  802924:	f7 f1                	div    %ecx
  802926:	89 c6                	mov    %eax,%esi
  802928:	31 d2                	xor    %edx,%edx
  80292a:	89 e8                	mov    %ebp,%eax
  80292c:	f7 f6                	div    %esi
  80292e:	89 c5                	mov    %eax,%ebp
  802930:	89 f8                	mov    %edi,%eax
  802932:	f7 f6                	div    %esi
  802934:	89 ea                	mov    %ebp,%edx
  802936:	83 c4 0c             	add    $0xc,%esp
  802939:	5e                   	pop    %esi
  80293a:	5f                   	pop    %edi
  80293b:	5d                   	pop    %ebp
  80293c:	c3                   	ret    
  80293d:	8d 76 00             	lea    0x0(%esi),%esi
  802940:	39 e8                	cmp    %ebp,%eax
  802942:	77 24                	ja     802968 <__udivdi3+0x78>
  802944:	0f bd e8             	bsr    %eax,%ebp
  802947:	83 f5 1f             	xor    $0x1f,%ebp
  80294a:	75 3c                	jne    802988 <__udivdi3+0x98>
  80294c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802950:	39 34 24             	cmp    %esi,(%esp)
  802953:	0f 86 9f 00 00 00    	jbe    8029f8 <__udivdi3+0x108>
  802959:	39 d0                	cmp    %edx,%eax
  80295b:	0f 82 97 00 00 00    	jb     8029f8 <__udivdi3+0x108>
  802961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802968:	31 d2                	xor    %edx,%edx
  80296a:	31 c0                	xor    %eax,%eax
  80296c:	83 c4 0c             	add    $0xc,%esp
  80296f:	5e                   	pop    %esi
  802970:	5f                   	pop    %edi
  802971:	5d                   	pop    %ebp
  802972:	c3                   	ret    
  802973:	90                   	nop
  802974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802978:	89 f8                	mov    %edi,%eax
  80297a:	f7 f1                	div    %ecx
  80297c:	31 d2                	xor    %edx,%edx
  80297e:	83 c4 0c             	add    $0xc,%esp
  802981:	5e                   	pop    %esi
  802982:	5f                   	pop    %edi
  802983:	5d                   	pop    %ebp
  802984:	c3                   	ret    
  802985:	8d 76 00             	lea    0x0(%esi),%esi
  802988:	89 e9                	mov    %ebp,%ecx
  80298a:	8b 3c 24             	mov    (%esp),%edi
  80298d:	d3 e0                	shl    %cl,%eax
  80298f:	89 c6                	mov    %eax,%esi
  802991:	b8 20 00 00 00       	mov    $0x20,%eax
  802996:	29 e8                	sub    %ebp,%eax
  802998:	89 c1                	mov    %eax,%ecx
  80299a:	d3 ef                	shr    %cl,%edi
  80299c:	89 e9                	mov    %ebp,%ecx
  80299e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8029a2:	8b 3c 24             	mov    (%esp),%edi
  8029a5:	09 74 24 08          	or     %esi,0x8(%esp)
  8029a9:	89 d6                	mov    %edx,%esi
  8029ab:	d3 e7                	shl    %cl,%edi
  8029ad:	89 c1                	mov    %eax,%ecx
  8029af:	89 3c 24             	mov    %edi,(%esp)
  8029b2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8029b6:	d3 ee                	shr    %cl,%esi
  8029b8:	89 e9                	mov    %ebp,%ecx
  8029ba:	d3 e2                	shl    %cl,%edx
  8029bc:	89 c1                	mov    %eax,%ecx
  8029be:	d3 ef                	shr    %cl,%edi
  8029c0:	09 d7                	or     %edx,%edi
  8029c2:	89 f2                	mov    %esi,%edx
  8029c4:	89 f8                	mov    %edi,%eax
  8029c6:	f7 74 24 08          	divl   0x8(%esp)
  8029ca:	89 d6                	mov    %edx,%esi
  8029cc:	89 c7                	mov    %eax,%edi
  8029ce:	f7 24 24             	mull   (%esp)
  8029d1:	39 d6                	cmp    %edx,%esi
  8029d3:	89 14 24             	mov    %edx,(%esp)
  8029d6:	72 30                	jb     802a08 <__udivdi3+0x118>
  8029d8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029dc:	89 e9                	mov    %ebp,%ecx
  8029de:	d3 e2                	shl    %cl,%edx
  8029e0:	39 c2                	cmp    %eax,%edx
  8029e2:	73 05                	jae    8029e9 <__udivdi3+0xf9>
  8029e4:	3b 34 24             	cmp    (%esp),%esi
  8029e7:	74 1f                	je     802a08 <__udivdi3+0x118>
  8029e9:	89 f8                	mov    %edi,%eax
  8029eb:	31 d2                	xor    %edx,%edx
  8029ed:	e9 7a ff ff ff       	jmp    80296c <__udivdi3+0x7c>
  8029f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029f8:	31 d2                	xor    %edx,%edx
  8029fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ff:	e9 68 ff ff ff       	jmp    80296c <__udivdi3+0x7c>
  802a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a08:	8d 47 ff             	lea    -0x1(%edi),%eax
  802a0b:	31 d2                	xor    %edx,%edx
  802a0d:	83 c4 0c             	add    $0xc,%esp
  802a10:	5e                   	pop    %esi
  802a11:	5f                   	pop    %edi
  802a12:	5d                   	pop    %ebp
  802a13:	c3                   	ret    
  802a14:	66 90                	xchg   %ax,%ax
  802a16:	66 90                	xchg   %ax,%ax
  802a18:	66 90                	xchg   %ax,%ax
  802a1a:	66 90                	xchg   %ax,%ax
  802a1c:	66 90                	xchg   %ax,%ax
  802a1e:	66 90                	xchg   %ax,%ax

00802a20 <__umoddi3>:
  802a20:	55                   	push   %ebp
  802a21:	57                   	push   %edi
  802a22:	56                   	push   %esi
  802a23:	83 ec 14             	sub    $0x14,%esp
  802a26:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a2a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a2e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802a32:	89 c7                	mov    %eax,%edi
  802a34:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a38:	8b 44 24 30          	mov    0x30(%esp),%eax
  802a3c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802a40:	89 34 24             	mov    %esi,(%esp)
  802a43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a47:	85 c0                	test   %eax,%eax
  802a49:	89 c2                	mov    %eax,%edx
  802a4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a4f:	75 17                	jne    802a68 <__umoddi3+0x48>
  802a51:	39 fe                	cmp    %edi,%esi
  802a53:	76 4b                	jbe    802aa0 <__umoddi3+0x80>
  802a55:	89 c8                	mov    %ecx,%eax
  802a57:	89 fa                	mov    %edi,%edx
  802a59:	f7 f6                	div    %esi
  802a5b:	89 d0                	mov    %edx,%eax
  802a5d:	31 d2                	xor    %edx,%edx
  802a5f:	83 c4 14             	add    $0x14,%esp
  802a62:	5e                   	pop    %esi
  802a63:	5f                   	pop    %edi
  802a64:	5d                   	pop    %ebp
  802a65:	c3                   	ret    
  802a66:	66 90                	xchg   %ax,%ax
  802a68:	39 f8                	cmp    %edi,%eax
  802a6a:	77 54                	ja     802ac0 <__umoddi3+0xa0>
  802a6c:	0f bd e8             	bsr    %eax,%ebp
  802a6f:	83 f5 1f             	xor    $0x1f,%ebp
  802a72:	75 5c                	jne    802ad0 <__umoddi3+0xb0>
  802a74:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802a78:	39 3c 24             	cmp    %edi,(%esp)
  802a7b:	0f 87 e7 00 00 00    	ja     802b68 <__umoddi3+0x148>
  802a81:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a85:	29 f1                	sub    %esi,%ecx
  802a87:	19 c7                	sbb    %eax,%edi
  802a89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a91:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a95:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802a99:	83 c4 14             	add    $0x14,%esp
  802a9c:	5e                   	pop    %esi
  802a9d:	5f                   	pop    %edi
  802a9e:	5d                   	pop    %ebp
  802a9f:	c3                   	ret    
  802aa0:	85 f6                	test   %esi,%esi
  802aa2:	89 f5                	mov    %esi,%ebp
  802aa4:	75 0b                	jne    802ab1 <__umoddi3+0x91>
  802aa6:	b8 01 00 00 00       	mov    $0x1,%eax
  802aab:	31 d2                	xor    %edx,%edx
  802aad:	f7 f6                	div    %esi
  802aaf:	89 c5                	mov    %eax,%ebp
  802ab1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802ab5:	31 d2                	xor    %edx,%edx
  802ab7:	f7 f5                	div    %ebp
  802ab9:	89 c8                	mov    %ecx,%eax
  802abb:	f7 f5                	div    %ebp
  802abd:	eb 9c                	jmp    802a5b <__umoddi3+0x3b>
  802abf:	90                   	nop
  802ac0:	89 c8                	mov    %ecx,%eax
  802ac2:	89 fa                	mov    %edi,%edx
  802ac4:	83 c4 14             	add    $0x14,%esp
  802ac7:	5e                   	pop    %esi
  802ac8:	5f                   	pop    %edi
  802ac9:	5d                   	pop    %ebp
  802aca:	c3                   	ret    
  802acb:	90                   	nop
  802acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ad0:	8b 04 24             	mov    (%esp),%eax
  802ad3:	be 20 00 00 00       	mov    $0x20,%esi
  802ad8:	89 e9                	mov    %ebp,%ecx
  802ada:	29 ee                	sub    %ebp,%esi
  802adc:	d3 e2                	shl    %cl,%edx
  802ade:	89 f1                	mov    %esi,%ecx
  802ae0:	d3 e8                	shr    %cl,%eax
  802ae2:	89 e9                	mov    %ebp,%ecx
  802ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ae8:	8b 04 24             	mov    (%esp),%eax
  802aeb:	09 54 24 04          	or     %edx,0x4(%esp)
  802aef:	89 fa                	mov    %edi,%edx
  802af1:	d3 e0                	shl    %cl,%eax
  802af3:	89 f1                	mov    %esi,%ecx
  802af5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802af9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802afd:	d3 ea                	shr    %cl,%edx
  802aff:	89 e9                	mov    %ebp,%ecx
  802b01:	d3 e7                	shl    %cl,%edi
  802b03:	89 f1                	mov    %esi,%ecx
  802b05:	d3 e8                	shr    %cl,%eax
  802b07:	89 e9                	mov    %ebp,%ecx
  802b09:	09 f8                	or     %edi,%eax
  802b0b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802b0f:	f7 74 24 04          	divl   0x4(%esp)
  802b13:	d3 e7                	shl    %cl,%edi
  802b15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b19:	89 d7                	mov    %edx,%edi
  802b1b:	f7 64 24 08          	mull   0x8(%esp)
  802b1f:	39 d7                	cmp    %edx,%edi
  802b21:	89 c1                	mov    %eax,%ecx
  802b23:	89 14 24             	mov    %edx,(%esp)
  802b26:	72 2c                	jb     802b54 <__umoddi3+0x134>
  802b28:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802b2c:	72 22                	jb     802b50 <__umoddi3+0x130>
  802b2e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802b32:	29 c8                	sub    %ecx,%eax
  802b34:	19 d7                	sbb    %edx,%edi
  802b36:	89 e9                	mov    %ebp,%ecx
  802b38:	89 fa                	mov    %edi,%edx
  802b3a:	d3 e8                	shr    %cl,%eax
  802b3c:	89 f1                	mov    %esi,%ecx
  802b3e:	d3 e2                	shl    %cl,%edx
  802b40:	89 e9                	mov    %ebp,%ecx
  802b42:	d3 ef                	shr    %cl,%edi
  802b44:	09 d0                	or     %edx,%eax
  802b46:	89 fa                	mov    %edi,%edx
  802b48:	83 c4 14             	add    $0x14,%esp
  802b4b:	5e                   	pop    %esi
  802b4c:	5f                   	pop    %edi
  802b4d:	5d                   	pop    %ebp
  802b4e:	c3                   	ret    
  802b4f:	90                   	nop
  802b50:	39 d7                	cmp    %edx,%edi
  802b52:	75 da                	jne    802b2e <__umoddi3+0x10e>
  802b54:	8b 14 24             	mov    (%esp),%edx
  802b57:	89 c1                	mov    %eax,%ecx
  802b59:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802b5d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802b61:	eb cb                	jmp    802b2e <__umoddi3+0x10e>
  802b63:	90                   	nop
  802b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b68:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802b6c:	0f 82 0f ff ff ff    	jb     802a81 <__umoddi3+0x61>
  802b72:	e9 1a ff ff ff       	jmp    802a91 <__umoddi3+0x71>
