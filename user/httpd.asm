
obj/user/httpd.debug:     file format elf32-i386


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
  80002c:	e8 9c 08 00 00       	call   8008cd <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <die>:
	{404, "Not Found"},
};

static void
die(char *m)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  800046:	89 44 24 04          	mov    %eax,0x4(%esp)
  80004a:	c7 04 24 e0 31 80 00 	movl   $0x8031e0,(%esp)
  800051:	e8 d5 09 00 00       	call   800a2b <cprintf>
	exit();
  800056:	e8 be 08 00 00       	call   800919 <exit>
}
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    

0080005d <send_error>:
	return 0;
}

static int
send_error(struct http_request *req, int code)
{
  80005d:	55                   	push   %ebp
  80005e:	89 e5                	mov    %esp,%ebp
  800060:	57                   	push   %edi
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	81 ec 2c 02 00 00    	sub    $0x22c,%esp
  800069:	89 c6                	mov    %eax,%esi
	char buf[512];
	int r;

	struct error_messages *e = errors;
  80006b:	b9 00 40 80 00       	mov    $0x804000,%ecx
	while (e->code != 0 && e->msg != 0) {
  800070:	eb 07                	jmp    800079 <send_error+0x1c>
		if (e->code == code)
  800072:	39 d3                	cmp    %edx,%ebx
  800074:	74 11                	je     800087 <send_error+0x2a>
			break;
		e++;
  800076:	83 c1 08             	add    $0x8,%ecx
{
	char buf[512];
	int r;

	struct error_messages *e = errors;
	while (e->code != 0 && e->msg != 0) {
  800079:	8b 19                	mov    (%ecx),%ebx
  80007b:	85 db                	test   %ebx,%ebx
  80007d:	74 5d                	je     8000dc <send_error+0x7f>
  80007f:	83 79 04 00          	cmpl   $0x0,0x4(%ecx)
  800083:	75 ed                	jne    800072 <send_error+0x15>
  800085:	eb 04                	jmp    80008b <send_error+0x2e>
		if (e->code == code)
			break;
		e++;
	}

	if (e->code == 0)
  800087:	85 db                	test   %ebx,%ebx
  800089:	74 58                	je     8000e3 <send_error+0x86>
		return -1;

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  80008b:	8b 41 04             	mov    0x4(%ecx),%eax
  80008e:	89 44 24 18          	mov    %eax,0x18(%esp)
  800092:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  800096:	89 44 24 10          	mov    %eax,0x10(%esp)
  80009a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009e:	c7 44 24 08 80 32 80 	movl   $0x803280,0x8(%esp)
  8000a5:	00 
  8000a6:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  8000ad:	00 
  8000ae:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
  8000b4:	89 3c 24             	mov    %edi,(%esp)
  8000b7:	e8 2e 0f 00 00       	call   800fea <snprintf>
  8000bc:	89 c3                	mov    %eax,%ebx
			       "Content-type: text/html\r\n"
			       "\r\n"
			       "<html><body><p>%d - %s</p></body></html>\r\n",
			       e->code, e->msg, e->code, e->msg);

	if (write(req->sock, buf, r) != r)
  8000be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8000c6:	8b 06                	mov    (%esi),%eax
  8000c8:	89 04 24             	mov    %eax,(%esp)
  8000cb:	e8 b7 1b 00 00       	call   801c87 <write>
  8000d0:	39 c3                	cmp    %eax,%ebx
  8000d2:	0f 95 c0             	setne  %al
  8000d5:	0f b6 c0             	movzbl %al,%eax
  8000d8:	f7 d8                	neg    %eax
  8000da:	eb 0c                	jmp    8000e8 <send_error+0x8b>
			break;
		e++;
	}

	if (e->code == 0)
		return -1;
  8000dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8000e1:	eb 05                	jmp    8000e8 <send_error+0x8b>
  8000e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

	if (write(req->sock, buf, r) != r)
		return -1;

	return 0;
}
  8000e8:	81 c4 2c 02 00 00    	add    $0x22c,%esp
  8000ee:	5b                   	pop    %ebx
  8000ef:	5e                   	pop    %esi
  8000f0:	5f                   	pop    %edi
  8000f1:	5d                   	pop    %ebp
  8000f2:	c3                   	ret    

008000f3 <handle_client>:
	return r;
}

static void
handle_client(int sock)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	57                   	push   %edi
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	81 ec 5c 03 00 00    	sub    $0x35c,%esp
  8000ff:	89 c6                	mov    %eax,%esi
	struct http_request *req = &con_d;

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800101:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800108:	00 
  800109:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  80010f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800113:	89 34 24             	mov    %esi,(%esp)
  800116:	e8 8f 1a 00 00       	call   801baa <read>
  80011b:	85 c0                	test   %eax,%eax
  80011d:	79 1c                	jns    80013b <handle_client+0x48>
			panic("failed to read");
  80011f:	c7 44 24 08 e4 31 80 	movl   $0x8031e4,0x8(%esp)
  800126:	00 
  800127:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
  80012e:	00 
  80012f:	c7 04 24 f3 31 80 00 	movl   $0x8031f3,(%esp)
  800136:	e8 f7 07 00 00       	call   800932 <_panic>

		memset(req, 0, sizeof(req));
  80013b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80014a:	00 
  80014b:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80014e:	89 04 24             	mov    %eax,(%esp)
  800151:	e8 51 10 00 00       	call   8011a7 <memset>

		req->sock = sock;
  800156:	89 75 dc             	mov    %esi,-0x24(%ebp)
	int url_len, version_len;

	if (!req)
		return -1;

	if (strncmp(request, "GET ", 4) != 0)
  800159:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800160:	00 
  800161:	c7 44 24 04 00 32 80 	movl   $0x803200,0x4(%esp)
  800168:	00 
  800169:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  80016f:	89 04 24             	mov    %eax,(%esp)
  800172:	e8 bb 0f 00 00       	call   801132 <strncmp>
  800177:	85 c0                	test   %eax,%eax
  800179:	0f 85 d2 02 00 00    	jne    800451 <handle_client+0x35e>
		return -E_BAD_REQ;

	// skip GET
	request += 4;
  80017f:	8d 9d e0 fd ff ff    	lea    -0x220(%ebp),%ebx
  800185:	eb 03                	jmp    80018a <handle_client+0x97>

	// get the url
	url = request;
	while (*request && *request != ' ')
		request++;
  800187:	83 c3 01             	add    $0x1,%ebx
	// skip GET
	request += 4;

	// get the url
	url = request;
	while (*request && *request != ' ')
  80018a:	f6 03 df             	testb  $0xdf,(%ebx)
  80018d:	75 f8                	jne    800187 <handle_client+0x94>
		request++;
	url_len = request - url;
  80018f:	89 df                	mov    %ebx,%edi
  800191:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  800197:	29 c7                	sub    %eax,%edi

	req->url = malloc(url_len + 1);
  800199:	8d 47 01             	lea    0x1(%edi),%eax
  80019c:	89 04 24             	mov    %eax,(%esp)
  80019f:	e8 5e 25 00 00       	call   802702 <malloc>
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  8001a7:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8001ab:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  8001b1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8001b5:	89 04 24             	mov    %eax,(%esp)
  8001b8:	e8 37 10 00 00       	call   8011f4 <memmove>
	req->url[url_len] = '\0';
  8001bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c0:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)

	// skip space
	request++;
  8001c4:	83 c3 01             	add    $0x1,%ebx
  8001c7:	89 d8                	mov    %ebx,%eax
  8001c9:	eb 03                	jmp    8001ce <handle_client+0xdb>

	version = request;
	while (*request && *request != '\n')
		request++;
  8001cb:	83 c0 01             	add    $0x1,%eax

	// skip space
	request++;

	version = request;
	while (*request && *request != '\n')
  8001ce:	0f b6 10             	movzbl (%eax),%edx
  8001d1:	80 fa 0a             	cmp    $0xa,%dl
  8001d4:	74 04                	je     8001da <handle_client+0xe7>
  8001d6:	84 d2                	test   %dl,%dl
  8001d8:	75 f1                	jne    8001cb <handle_client+0xd8>
		request++;
	version_len = request - version;
  8001da:	29 d8                	sub    %ebx,%eax
  8001dc:	89 c7                	mov    %eax,%edi

	req->version = malloc(version_len + 1);
  8001de:	8d 40 01             	lea    0x1(%eax),%eax
  8001e1:	89 04 24             	mov    %eax,(%esp)
  8001e4:	e8 19 25 00 00       	call   802702 <malloc>
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  8001ec:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8001f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001f4:	89 04 24             	mov    %eax,(%esp)
  8001f7:	e8 f8 0f 00 00       	call   8011f4 <memmove>
	req->version[version_len] = '\0';
  8001fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ff:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
	// if the file is a directory, send a 404 error using send_error
	// set file_size to the size of the file

	// LAB 6: Your code here.

	fd = open(req->url, O_RDONLY);
  800203:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80020a:	00 
  80020b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80020e:	89 04 24             	mov    %eax,(%esp)
  800211:	e8 60 1e 00 00       	call   802076 <open>
  800216:	89 c7                	mov    %eax,%edi
	if (fd < 0) {
  800218:	85 c0                	test   %eax,%eax
  80021a:	79 12                	jns    80022e <handle_client+0x13b>
		send_error(req, 404);
  80021c:	ba 94 01 00 00       	mov    $0x194,%edx
  800221:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800224:	e8 34 fe ff ff       	call   80005d <send_error>
  800229:	e9 03 02 00 00       	jmp    800431 <handle_client+0x33e>
		return fd;
	}

	struct Stat stat;
	r = fstat(fd, &stat);
  80022e:	8d 85 c4 fc ff ff    	lea    -0x33c(%ebp),%eax
  800234:	89 44 24 04          	mov    %eax,0x4(%esp)
  800238:	89 3c 24             	mov    %edi,(%esp)
  80023b:	e8 86 1b 00 00       	call   801dc6 <fstat>
	if (r < 0) 
  800240:	85 c0                	test   %eax,%eax
  800242:	0f 88 e1 01 00 00    	js     800429 <handle_client+0x336>
		goto end;

	if (stat.st_isdir) {
  800248:	83 bd 48 fd ff ff 00 	cmpl   $0x0,-0x2b8(%ebp)
  80024f:	74 12                	je     800263 <handle_client+0x170>
		send_error(req, 404);
  800251:	ba 94 01 00 00       	mov    $0x194,%edx
  800256:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800259:	e8 ff fd ff ff       	call   80005d <send_error>
  80025e:	e9 c6 01 00 00       	jmp    800429 <handle_client+0x336>
		goto end;
	}

	file_size = stat.st_size;
  800263:	8b 85 44 fd ff ff    	mov    -0x2bc(%ebp),%eax
  800269:	89 85 b4 fc ff ff    	mov    %eax,-0x34c(%ebp)
}

static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
  80026f:	bb 10 40 80 00       	mov    $0x804010,%ebx
  800274:	eb 0a                	jmp    800280 <handle_client+0x18d>
	while (h->code != 0 && h->header!= 0) {
		if (h->code == code)
  800276:	3d c8 00 00 00       	cmp    $0xc8,%eax
  80027b:	74 13                	je     800290 <handle_client+0x19d>
			break;
		h++;
  80027d:	83 c3 08             	add    $0x8,%ebx

static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
	while (h->code != 0 && h->header!= 0) {
  800280:	8b 03                	mov    (%ebx),%eax
  800282:	85 c0                	test   %eax,%eax
  800284:	0f 84 9f 01 00 00    	je     800429 <handle_client+0x336>
  80028a:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  80028e:	75 e6                	jne    800276 <handle_client+0x183>
	}

	if (h->code == 0)
		return -1;

	int len = strlen(h->header);
  800290:	8b 43 04             	mov    0x4(%ebx),%eax
  800293:	89 04 24             	mov    %eax,(%esp)
  800296:	e8 85 0d 00 00       	call   801020 <strlen>
	if (write(req->sock, h->header, len) != len) {
  80029b:	89 85 b0 fc ff ff    	mov    %eax,-0x350(%ebp)
  8002a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a5:	8b 43 04             	mov    0x4(%ebx),%eax
  8002a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002af:	89 04 24             	mov    %eax,(%esp)
  8002b2:	e8 d0 19 00 00       	call   801c87 <write>
  8002b7:	39 85 b0 fc ff ff    	cmp    %eax,-0x350(%ebp)
  8002bd:	0f 84 9d 01 00 00    	je     800460 <handle_client+0x36d>
		die("Failed to send bytes to client");
  8002c3:	b8 fc 32 80 00       	mov    $0x8032fc,%eax
  8002c8:	e8 73 fd ff ff       	call   800040 <die>
  8002cd:	e9 8e 01 00 00       	jmp    800460 <handle_client+0x36d>
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
	if (r > 63)
		panic("buffer too small!");
  8002d2:	c7 44 24 08 05 32 80 	movl   $0x803205,0x8(%esp)
  8002d9:	00 
  8002da:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  8002e1:	00 
  8002e2:	c7 04 24 f3 31 80 00 	movl   $0x8031f3,(%esp)
  8002e9:	e8 44 06 00 00       	call   800932 <_panic>

	if (write(req->sock, buf, r) != r)
  8002ee:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002f2:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  8002f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ff:	89 04 24             	mov    %eax,(%esp)
  800302:	e8 80 19 00 00       	call   801c87 <write>
	file_size = stat.st_size;

	if ((r = send_header(req, 200)) < 0)
		goto end;

	if ((r = send_size(req, file_size)) < 0)
  800307:	39 c3                	cmp    %eax,%ebx
  800309:	0f 85 1a 01 00 00    	jne    800429 <handle_client+0x336>

	type = mime_type(req->url);
	if (!type)
		return -1;

	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  80030f:	c7 44 24 0c 17 32 80 	movl   $0x803217,0xc(%esp)
  800316:	00 
  800317:	c7 44 24 08 21 32 80 	movl   $0x803221,0x8(%esp)
  80031e:	00 
  80031f:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  800326:	00 
  800327:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  80032d:	89 04 24             	mov    %eax,(%esp)
  800330:	e8 b5 0c 00 00       	call   800fea <snprintf>
  800335:	89 c3                	mov    %eax,%ebx
	if (r > 127)
  800337:	83 f8 7f             	cmp    $0x7f,%eax
  80033a:	7e 1c                	jle    800358 <handle_client+0x265>
		panic("buffer too small!");
  80033c:	c7 44 24 08 05 32 80 	movl   $0x803205,0x8(%esp)
  800343:	00 
  800344:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  80034b:	00 
  80034c:	c7 04 24 f3 31 80 00 	movl   $0x8031f3,(%esp)
  800353:	e8 da 05 00 00       	call   800932 <_panic>

	if (write(req->sock, buf, r) != r)
  800358:	89 44 24 08          	mov    %eax,0x8(%esp)
  80035c:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  800362:	89 44 24 04          	mov    %eax,0x4(%esp)
  800366:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800369:	89 04 24             	mov    %eax,(%esp)
  80036c:	e8 16 19 00 00       	call   801c87 <write>
		goto end;

	if ((r = send_size(req, file_size)) < 0)
		goto end;

	if ((r = send_content_type(req)) < 0)
  800371:	39 c3                	cmp    %eax,%ebx
  800373:	0f 85 b0 00 00 00    	jne    800429 <handle_client+0x336>

static int
send_header_fin(struct http_request *req)
{
	const char *fin = "\r\n";
	int fin_len = strlen(fin);
  800379:	c7 04 24 47 32 80 00 	movl   $0x803247,(%esp)
  800380:	e8 9b 0c 00 00       	call   801020 <strlen>
  800385:	89 c3                	mov    %eax,%ebx

	if (write(req->sock, fin, fin_len) != fin_len)
  800387:	89 44 24 08          	mov    %eax,0x8(%esp)
  80038b:	c7 44 24 04 47 32 80 	movl   $0x803247,0x4(%esp)
  800392:	00 
  800393:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800396:	89 04 24             	mov    %eax,(%esp)
  800399:	e8 e9 18 00 00       	call   801c87 <write>
		goto end;

	if ((r = send_content_type(req)) < 0)
		goto end;

	if ((r = send_header_fin(req)) < 0)
  80039e:	39 c3                	cmp    %eax,%ebx
  8003a0:	0f 85 83 00 00 00    	jne    800429 <handle_client+0x336>
{
	// LAB 6: Your code here.
	int r;

	struct Stat stat;
	r = fstat(fd, &stat);
  8003a6:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  8003ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b0:	89 3c 24             	mov    %edi,(%esp)
  8003b3:	e8 0e 1a 00 00       	call   801dc6 <fstat>
	if (r < 0) 
  8003b8:	85 c0                	test   %eax,%eax
  8003ba:	78 6d                	js     800429 <handle_client+0x336>
		return -1;

	void* buf = malloc(stat.st_size);
  8003bc:	8b 85 d0 fd ff ff    	mov    -0x230(%ebp),%eax
  8003c2:	89 04 24             	mov    %eax,(%esp)
  8003c5:	e8 38 23 00 00       	call   802702 <malloc>
  8003ca:	89 c3                	mov    %eax,%ebx

	r = read(fd, buf, stat.st_size);
  8003cc:	8b 85 d0 fd ff ff    	mov    -0x230(%ebp),%eax
  8003d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003da:	89 3c 24             	mov    %edi,(%esp)
  8003dd:	e8 c8 17 00 00       	call   801baa <read>
  8003e2:	89 85 b4 fc ff ff    	mov    %eax,-0x34c(%ebp)
	if (r < 0) 
  8003e8:	85 c0                	test   %eax,%eax
  8003ea:	79 0a                	jns    8003f6 <handle_client+0x303>
		die("Failed to read bytes from file");
  8003ec:	b8 1c 33 80 00       	mov    $0x80331c,%eax
  8003f1:	e8 4a fc ff ff       	call   800040 <die>

	if (write(req->sock, buf, r) != r)
  8003f6:	8b 85 b4 fc ff ff    	mov    -0x34c(%ebp),%eax
  8003fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800400:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800404:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800407:	89 04 24             	mov    %eax,(%esp)
  80040a:	e8 78 18 00 00       	call   801c87 <write>
  80040f:	39 85 b4 fc ff ff    	cmp    %eax,-0x34c(%ebp)
  800415:	74 0a                	je     800421 <handle_client+0x32e>
		die("Failed to send bytes to client");
  800417:	b8 fc 32 80 00       	mov    $0x8032fc,%eax
  80041c:	e8 1f fc ff ff       	call   800040 <die>

	free(buf);
  800421:	89 1c 24             	mov    %ebx,(%esp)
  800424:	e8 07 22 00 00       	call   802630 <free>
		goto end;

	r = send_data(req, fd);

end:
	close(fd);
  800429:	89 3c 24             	mov    %edi,(%esp)
  80042c:	e8 16 16 00 00       	call   801a47 <close>
}

static void
req_free(struct http_request *req)
{
	free(req->url);
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	89 04 24             	mov    %eax,(%esp)
  800437:	e8 f4 21 00 00       	call   802630 <free>
	free(req->version);
  80043c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80043f:	89 04 24             	mov    %eax,(%esp)
  800442:	e8 e9 21 00 00       	call   802630 <free>

		// no keep alive
		break;
	}

	close(sock);
  800447:	89 34 24             	mov    %esi,(%esp)
  80044a:	e8 f8 15 00 00       	call   801a47 <close>
  80044f:	eb 47                	jmp    800498 <handle_client+0x3a5>

		req->sock = sock;

		r = http_request_parse(req, buffer);
		if (r == -E_BAD_REQ)
			send_error(req, 400);
  800451:	ba 90 01 00 00       	mov    $0x190,%edx
  800456:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800459:	e8 ff fb ff ff       	call   80005d <send_error>
  80045e:	eb d1                	jmp    800431 <handle_client+0x33e>
send_size(struct http_request *req, off_t size)
{
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  800460:	8b 85 b4 fc ff ff    	mov    -0x34c(%ebp),%eax
  800466:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80046a:	c7 44 24 08 34 32 80 	movl   $0x803234,0x8(%esp)
  800471:	00 
  800472:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  800479:	00 
  80047a:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  800480:	89 04 24             	mov    %eax,(%esp)
  800483:	e8 62 0b 00 00       	call   800fea <snprintf>
  800488:	89 c3                	mov    %eax,%ebx
	if (r > 63)
  80048a:	83 f8 3f             	cmp    $0x3f,%eax
  80048d:	0f 8e 5b fe ff ff    	jle    8002ee <handle_client+0x1fb>
  800493:	e9 3a fe ff ff       	jmp    8002d2 <handle_client+0x1df>
		// no keep alive
		break;
	}

	close(sock);
}
  800498:	81 c4 5c 03 00 00    	add    $0x35c,%esp
  80049e:	5b                   	pop    %ebx
  80049f:	5e                   	pop    %esi
  8004a0:	5f                   	pop    %edi
  8004a1:	5d                   	pop    %ebp
  8004a2:	c3                   	ret    

008004a3 <umain>:

void
umain(int argc, char **argv)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	57                   	push   %edi
  8004a7:	56                   	push   %esi
  8004a8:	53                   	push   %ebx
  8004a9:	83 ec 4c             	sub    $0x4c,%esp
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  8004ac:	c7 05 20 40 80 00 4a 	movl   $0x80324a,0x804020
  8004b3:	32 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8004b6:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8004bd:	00 
  8004be:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8004c5:	00 
  8004c6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8004cd:	e8 75 1e 00 00       	call   802347 <socket>
  8004d2:	89 c6                	mov    %eax,%esi
  8004d4:	85 c0                	test   %eax,%eax
  8004d6:	79 0a                	jns    8004e2 <umain+0x3f>
		die("Failed to create socket");
  8004d8:	b8 51 32 80 00       	mov    $0x803251,%eax
  8004dd:	e8 5e fb ff ff       	call   800040 <die>

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  8004e2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  8004e9:	00 
  8004ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004f1:	00 
  8004f2:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8004f5:	89 1c 24             	mov    %ebx,(%esp)
  8004f8:	e8 aa 0c 00 00       	call   8011a7 <memset>
	server.sin_family = AF_INET;			// Internet/IP
  8004fd:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  800501:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800508:	e8 73 01 00 00       	call   800680 <htonl>
  80050d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	server.sin_port = htons(PORT);			// server port
  800510:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  800517:	e8 4a 01 00 00       	call   800666 <htons>
  80051c:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  800520:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800527:	00 
  800528:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80052c:	89 34 24             	mov    %esi,(%esp)
  80052f:	e8 71 1d 00 00       	call   8022a5 <bind>
  800534:	85 c0                	test   %eax,%eax
  800536:	79 0a                	jns    800542 <umain+0x9f>
		 sizeof(server)) < 0)
	{
		die("Failed to bind the server socket");
  800538:	b8 3c 33 80 00       	mov    $0x80333c,%eax
  80053d:	e8 fe fa ff ff       	call   800040 <die>
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800542:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  800549:	00 
  80054a:	89 34 24             	mov    %esi,(%esp)
  80054d:	e8 d0 1d 00 00       	call   802322 <listen>
  800552:	85 c0                	test   %eax,%eax
  800554:	79 0a                	jns    800560 <umain+0xbd>
		die("Failed to listen on server socket");
  800556:	b8 60 33 80 00       	mov    $0x803360,%eax
  80055b:	e8 e0 fa ff ff       	call   800040 <die>

	cprintf("Waiting for http connections...\n");
  800560:	c7 04 24 84 33 80 00 	movl   $0x803384,(%esp)
  800567:	e8 bf 04 00 00       	call   800a2b <cprintf>

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  80056c:	8d 7d c4             	lea    -0x3c(%ebp),%edi
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");

	while (1) {
		unsigned int clientlen = sizeof(client);
  80056f:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800576:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80057a:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80057d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800581:	89 34 24             	mov    %esi,(%esp)
  800584:	e8 e1 1c 00 00       	call   80226a <accept>
  800589:	89 c3                	mov    %eax,%ebx
  80058b:	85 c0                	test   %eax,%eax
  80058d:	79 0a                	jns    800599 <umain+0xf6>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  80058f:	b8 a8 33 80 00       	mov    $0x8033a8,%eax
  800594:	e8 a7 fa ff ff       	call   800040 <die>
		}
		handle_client(clientsock);
  800599:	89 d8                	mov    %ebx,%eax
  80059b:	e8 53 fb ff ff       	call   8000f3 <handle_client>
	}
  8005a0:	eb cd                	jmp    80056f <umain+0xcc>
  8005a2:	66 90                	xchg   %ax,%ax
  8005a4:	66 90                	xchg   %ax,%ax
  8005a6:	66 90                	xchg   %ax,%ax
  8005a8:	66 90                	xchg   %ax,%ax
  8005aa:	66 90                	xchg   %ax,%ax
  8005ac:	66 90                	xchg   %ax,%ax
  8005ae:	66 90                	xchg   %ax,%ax

008005b0 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8005b0:	55                   	push   %ebp
  8005b1:	89 e5                	mov    %esp,%ebp
  8005b3:	57                   	push   %edi
  8005b4:	56                   	push   %esi
  8005b5:	53                   	push   %ebx
  8005b6:	83 ec 19             	sub    $0x19,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8005b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8005bf:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  8005c3:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  8005c6:	c7 45 dc 00 50 80 00 	movl   $0x805000,-0x24(%ebp)
 */
char *
inet_ntoa(struct in_addr addr)
{
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8005cd:	be 00 00 00 00       	mov    $0x0,%esi
  8005d2:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  8005d5:	eb 02                	jmp    8005d9 <inet_ntoa+0x29>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  8005d7:	89 ce                	mov    %ecx,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  8005d9:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005dc:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  8005df:	0f b6 c2             	movzbl %dl,%eax
  8005e2:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  8005e5:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
  8005e8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005eb:	66 c1 e8 0b          	shr    $0xb,%ax
  8005ef:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  8005f1:	8d 4e 01             	lea    0x1(%esi),%ecx
  8005f4:	89 f3                	mov    %esi,%ebx
  8005f6:	0f b6 f3             	movzbl %bl,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  8005f9:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  8005fc:	01 ff                	add    %edi,%edi
  8005fe:	89 fb                	mov    %edi,%ebx
  800600:	29 da                	sub    %ebx,%edx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
  800602:	83 c2 30             	add    $0x30,%edx
  800605:	88 54 35 ed          	mov    %dl,-0x13(%ebp,%esi,1)
    } while(*ap);
  800609:	84 c0                	test   %al,%al
  80060b:	75 ca                	jne    8005d7 <inet_ntoa+0x27>
  80060d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800610:	89 c8                	mov    %ecx,%eax
  800612:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800615:	89 cf                	mov    %ecx,%edi
  800617:	eb 0d                	jmp    800626 <inet_ntoa+0x76>
    while(i--)
      *rp++ = inv[i];
  800619:	0f b6 f0             	movzbl %al,%esi
  80061c:	0f b6 4c 35 ed       	movzbl -0x13(%ebp,%esi,1),%ecx
  800621:	88 0a                	mov    %cl,(%edx)
  800623:	83 c2 01             	add    $0x1,%edx
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  800626:	83 e8 01             	sub    $0x1,%eax
  800629:	3c ff                	cmp    $0xff,%al
  80062b:	75 ec                	jne    800619 <inet_ntoa+0x69>
  80062d:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800630:	89 f9                	mov    %edi,%ecx
  800632:	0f b6 c9             	movzbl %cl,%ecx
  800635:	03 4d dc             	add    -0x24(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  800638:	8d 41 01             	lea    0x1(%ecx),%eax
  80063b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    ap++;
  80063e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  800642:	80 45 db 01          	addb   $0x1,-0x25(%ebp)
  800646:	80 7d db 03          	cmpb   $0x3,-0x25(%ebp)
  80064a:	77 0a                	ja     800656 <inet_ntoa+0xa6>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  80064c:	c6 01 2e             	movb   $0x2e,(%ecx)
  80064f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800654:	eb 81                	jmp    8005d7 <inet_ntoa+0x27>
    ap++;
  }
  *--rp = 0;
  800656:	c6 01 00             	movb   $0x0,(%ecx)
  return str;
}
  800659:	b8 00 50 80 00       	mov    $0x805000,%eax
  80065e:	83 c4 19             	add    $0x19,%esp
  800661:	5b                   	pop    %ebx
  800662:	5e                   	pop    %esi
  800663:	5f                   	pop    %edi
  800664:	5d                   	pop    %ebp
  800665:	c3                   	ret    

00800666 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800666:	55                   	push   %ebp
  800667:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800669:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80066d:	66 c1 c0 08          	rol    $0x8,%ax
}
  800671:	5d                   	pop    %ebp
  800672:	c3                   	ret    

00800673 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800673:	55                   	push   %ebp
  800674:	89 e5                	mov    %esp,%ebp
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800676:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80067a:	66 c1 c0 08          	rol    $0x8,%ax
 */
u16_t
ntohs(u16_t n)
{
  return htons(n);
}
  80067e:	5d                   	pop    %ebp
  80067f:	c3                   	ret    

00800680 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800680:	55                   	push   %ebp
  800681:	89 e5                	mov    %esp,%ebp
  800683:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  800686:	89 d1                	mov    %edx,%ecx
  800688:	c1 e9 18             	shr    $0x18,%ecx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80068b:	89 d0                	mov    %edx,%eax
  80068d:	c1 e0 18             	shl    $0x18,%eax
  800690:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800692:	89 d1                	mov    %edx,%ecx
  800694:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  80069a:	c1 e1 08             	shl    $0x8,%ecx
  80069d:	09 c8                	or     %ecx,%eax
    ((n & 0xff0000UL) >> 8) |
  80069f:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  8006a5:	c1 ea 08             	shr    $0x8,%edx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8006a8:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8006aa:	5d                   	pop    %ebp
  8006ab:	c3                   	ret    

008006ac <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  8006ac:	55                   	push   %ebp
  8006ad:	89 e5                	mov    %esp,%ebp
  8006af:	57                   	push   %edi
  8006b0:	56                   	push   %esi
  8006b1:	53                   	push   %ebx
  8006b2:	83 ec 20             	sub    $0x20,%esp
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  8006b8:	0f be 10             	movsbl (%eax),%edx
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  8006bb:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8006be:	89 75 d8             	mov    %esi,-0x28(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  8006c1:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8006c4:	80 f9 09             	cmp    $0x9,%cl
  8006c7:	0f 87 a6 01 00 00    	ja     800873 <inet_aton+0x1c7>
      return (0);
    val = 0;
    base = 10;
  8006cd:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
    if (c == '0') {
  8006d4:	83 fa 30             	cmp    $0x30,%edx
  8006d7:	75 2b                	jne    800704 <inet_aton+0x58>
      c = *++cp;
  8006d9:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8006dd:	89 d1                	mov    %edx,%ecx
  8006df:	83 e1 df             	and    $0xffffffdf,%ecx
  8006e2:	80 f9 58             	cmp    $0x58,%cl
  8006e5:	74 0f                	je     8006f6 <inet_aton+0x4a>
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
  8006e7:	83 c0 01             	add    $0x1,%eax
  8006ea:	0f be d2             	movsbl %dl,%edx
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
      } else
        base = 8;
  8006ed:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  8006f4:	eb 0e                	jmp    800704 <inet_aton+0x58>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  8006f6:	0f be 50 02          	movsbl 0x2(%eax),%edx
  8006fa:	8d 40 02             	lea    0x2(%eax),%eax
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  8006fd:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  800704:	83 c0 01             	add    $0x1,%eax
  800707:	bf 00 00 00 00       	mov    $0x0,%edi
  80070c:	eb 03                	jmp    800711 <inet_aton+0x65>
  80070e:	83 c0 01             	add    $0x1,%eax
  800711:	8d 70 ff             	lea    -0x1(%eax),%esi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  800714:	89 d3                	mov    %edx,%ebx
  800716:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800719:	80 f9 09             	cmp    $0x9,%cl
  80071c:	77 0d                	ja     80072b <inet_aton+0x7f>
        val = (val * base) + (int)(c - '0');
  80071e:	0f af 7d e0          	imul   -0x20(%ebp),%edi
  800722:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800726:	0f be 10             	movsbl (%eax),%edx
  800729:	eb e3                	jmp    80070e <inet_aton+0x62>
      } else if (base == 16 && isxdigit(c)) {
  80072b:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  80072f:	75 30                	jne    800761 <inet_aton+0xb5>
  800731:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  800734:	88 4d df             	mov    %cl,-0x21(%ebp)
  800737:	89 d1                	mov    %edx,%ecx
  800739:	83 e1 df             	and    $0xffffffdf,%ecx
  80073c:	83 e9 41             	sub    $0x41,%ecx
  80073f:	80 f9 05             	cmp    $0x5,%cl
  800742:	77 23                	ja     800767 <inet_aton+0xbb>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800744:	89 fb                	mov    %edi,%ebx
  800746:	c1 e3 04             	shl    $0x4,%ebx
  800749:	8d 7a 0a             	lea    0xa(%edx),%edi
  80074c:	80 7d df 1a          	cmpb   $0x1a,-0x21(%ebp)
  800750:	19 c9                	sbb    %ecx,%ecx
  800752:	83 e1 20             	and    $0x20,%ecx
  800755:	83 c1 41             	add    $0x41,%ecx
  800758:	29 cf                	sub    %ecx,%edi
  80075a:	09 df                	or     %ebx,%edi
        c = *++cp;
  80075c:	0f be 10             	movsbl (%eax),%edx
  80075f:	eb ad                	jmp    80070e <inet_aton+0x62>
  800761:	89 d0                	mov    %edx,%eax
  800763:	89 f9                	mov    %edi,%ecx
  800765:	eb 04                	jmp    80076b <inet_aton+0xbf>
  800767:	89 d0                	mov    %edx,%eax
  800769:	89 f9                	mov    %edi,%ecx
      } else
        break;
    }
    if (c == '.') {
  80076b:	83 f8 2e             	cmp    $0x2e,%eax
  80076e:	75 22                	jne    800792 <inet_aton+0xe6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  800770:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800773:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  800776:	0f 84 fe 00 00 00    	je     80087a <inet_aton+0x1ce>
        return (0);
      *pp++ = val;
  80077c:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  800780:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800783:	89 48 fc             	mov    %ecx,-0x4(%eax)
      c = *++cp;
  800786:	8d 46 01             	lea    0x1(%esi),%eax
  800789:	0f be 56 01          	movsbl 0x1(%esi),%edx
    } else
      break;
  }
  80078d:	e9 2f ff ff ff       	jmp    8006c1 <inet_aton+0x15>
  800792:	89 f9                	mov    %edi,%ecx
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800794:	85 d2                	test   %edx,%edx
  800796:	74 27                	je     8007bf <inet_aton+0x113>
    return (0);
  800798:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80079d:	80 fb 1f             	cmp    $0x1f,%bl
  8007a0:	0f 86 e7 00 00 00    	jbe    80088d <inet_aton+0x1e1>
  8007a6:	84 d2                	test   %dl,%dl
  8007a8:	0f 88 d3 00 00 00    	js     800881 <inet_aton+0x1d5>
  8007ae:	83 fa 20             	cmp    $0x20,%edx
  8007b1:	74 0c                	je     8007bf <inet_aton+0x113>
  8007b3:	83 ea 09             	sub    $0x9,%edx
  8007b6:	83 fa 04             	cmp    $0x4,%edx
  8007b9:	0f 87 ce 00 00 00    	ja     80088d <inet_aton+0x1e1>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  8007bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8007c2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007c5:	29 c2                	sub    %eax,%edx
  8007c7:	c1 fa 02             	sar    $0x2,%edx
  8007ca:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  8007cd:	83 fa 02             	cmp    $0x2,%edx
  8007d0:	74 22                	je     8007f4 <inet_aton+0x148>
  8007d2:	83 fa 02             	cmp    $0x2,%edx
  8007d5:	7f 0f                	jg     8007e6 <inet_aton+0x13a>

  case 0:
    return (0);       /* initial nondigit */
  8007d7:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  8007dc:	85 d2                	test   %edx,%edx
  8007de:	0f 84 a9 00 00 00    	je     80088d <inet_aton+0x1e1>
  8007e4:	eb 73                	jmp    800859 <inet_aton+0x1ad>
  8007e6:	83 fa 03             	cmp    $0x3,%edx
  8007e9:	74 26                	je     800811 <inet_aton+0x165>
  8007eb:	83 fa 04             	cmp    $0x4,%edx
  8007ee:	66 90                	xchg   %ax,%ax
  8007f0:	74 40                	je     800832 <inet_aton+0x186>
  8007f2:	eb 65                	jmp    800859 <inet_aton+0x1ad>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  8007f4:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8007f9:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  8007ff:	0f 87 88 00 00 00    	ja     80088d <inet_aton+0x1e1>
      return (0);
    val |= parts[0] << 24;
  800805:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800808:	c1 e0 18             	shl    $0x18,%eax
  80080b:	89 cf                	mov    %ecx,%edi
  80080d:	09 c7                	or     %eax,%edi
    break;
  80080f:	eb 48                	jmp    800859 <inet_aton+0x1ad>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  800811:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  800816:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  80081c:	77 6f                	ja     80088d <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  80081e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800821:	c1 e2 10             	shl    $0x10,%edx
  800824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800827:	c1 e0 18             	shl    $0x18,%eax
  80082a:	09 d0                	or     %edx,%eax
  80082c:	09 c8                	or     %ecx,%eax
  80082e:	89 c7                	mov    %eax,%edi
    break;
  800830:	eb 27                	jmp    800859 <inet_aton+0x1ad>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  800832:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  800837:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
  80083d:	77 4e                	ja     80088d <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80083f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800842:	c1 e2 10             	shl    $0x10,%edx
  800845:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800848:	c1 e0 18             	shl    $0x18,%eax
  80084b:	09 c2                	or     %eax,%edx
  80084d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800850:	c1 e0 08             	shl    $0x8,%eax
  800853:	09 d0                	or     %edx,%eax
  800855:	09 c8                	or     %ecx,%eax
  800857:	89 c7                	mov    %eax,%edi
    break;
  }
  if (addr)
  800859:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80085d:	74 29                	je     800888 <inet_aton+0x1dc>
    addr->s_addr = htonl(val);
  80085f:	89 3c 24             	mov    %edi,(%esp)
  800862:	e8 19 fe ff ff       	call   800680 <htonl>
  800867:	8b 75 0c             	mov    0xc(%ebp),%esi
  80086a:	89 06                	mov    %eax,(%esi)
  return (1);
  80086c:	b8 01 00 00 00       	mov    $0x1,%eax
  800871:	eb 1a                	jmp    80088d <inet_aton+0x1e1>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  800873:	b8 00 00 00 00       	mov    $0x0,%eax
  800878:	eb 13                	jmp    80088d <inet_aton+0x1e1>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  80087a:	b8 00 00 00 00       	mov    $0x0,%eax
  80087f:	eb 0c                	jmp    80088d <inet_aton+0x1e1>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  800881:	b8 00 00 00 00       	mov    $0x0,%eax
  800886:	eb 05                	jmp    80088d <inet_aton+0x1e1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  800888:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80088d:	83 c4 20             	add    $0x20,%esp
  800890:	5b                   	pop    %ebx
  800891:	5e                   	pop    %esi
  800892:	5f                   	pop    %edi
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  80089b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80089e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 04 24             	mov    %eax,(%esp)
  8008a8:	e8 ff fd ff ff       	call   8006ac <inet_aton>
  8008ad:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  8008af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8008b4:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	89 04 24             	mov    %eax,(%esp)
  8008c6:	e8 b5 fd ff ff       	call   800680 <htonl>
}
  8008cb:	c9                   	leave  
  8008cc:	c3                   	ret    

008008cd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	56                   	push   %esi
  8008d1:	53                   	push   %ebx
  8008d2:	83 ec 10             	sub    $0x10,%esp
  8008d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008d8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  8008db:	e8 55 0b 00 00       	call   801435 <sys_getenvid>
  8008e0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8008e5:	89 c2                	mov    %eax,%edx
  8008e7:	c1 e2 07             	shl    $0x7,%edx
  8008ea:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8008f1:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008f6:	85 db                	test   %ebx,%ebx
  8008f8:	7e 07                	jle    800901 <libmain+0x34>
		binaryname = argv[0];
  8008fa:	8b 06                	mov    (%esi),%eax
  8008fc:	a3 20 40 80 00       	mov    %eax,0x804020

	// call user main routine
	umain(argc, argv);
  800901:	89 74 24 04          	mov    %esi,0x4(%esp)
  800905:	89 1c 24             	mov    %ebx,(%esp)
  800908:	e8 96 fb ff ff       	call   8004a3 <umain>

	// exit gracefully
	exit();
  80090d:	e8 07 00 00 00       	call   800919 <exit>
}
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	5b                   	pop    %ebx
  800916:	5e                   	pop    %esi
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80091f:	e8 56 11 00 00       	call   801a7a <close_all>
	sys_env_destroy(0);
  800924:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80092b:	e8 b3 0a 00 00       	call   8013e3 <sys_env_destroy>
}
  800930:	c9                   	leave  
  800931:	c3                   	ret    

00800932 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	56                   	push   %esi
  800936:	53                   	push   %ebx
  800937:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80093a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80093d:	8b 35 20 40 80 00    	mov    0x804020,%esi
  800943:	e8 ed 0a 00 00       	call   801435 <sys_getenvid>
  800948:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094b:	89 54 24 10          	mov    %edx,0x10(%esp)
  80094f:	8b 55 08             	mov    0x8(%ebp),%edx
  800952:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800956:	89 74 24 08          	mov    %esi,0x8(%esp)
  80095a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80095e:	c7 04 24 fc 33 80 00 	movl   $0x8033fc,(%esp)
  800965:	e8 c1 00 00 00       	call   800a2b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80096a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80096e:	8b 45 10             	mov    0x10(%ebp),%eax
  800971:	89 04 24             	mov    %eax,(%esp)
  800974:	e8 51 00 00 00       	call   8009ca <vcprintf>
	cprintf("\n");
  800979:	c7 04 24 48 32 80 00 	movl   $0x803248,(%esp)
  800980:	e8 a6 00 00 00       	call   800a2b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800985:	cc                   	int3   
  800986:	eb fd                	jmp    800985 <_panic+0x53>

00800988 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	53                   	push   %ebx
  80098c:	83 ec 14             	sub    $0x14,%esp
  80098f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800992:	8b 13                	mov    (%ebx),%edx
  800994:	8d 42 01             	lea    0x1(%edx),%eax
  800997:	89 03                	mov    %eax,(%ebx)
  800999:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8009a0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009a5:	75 19                	jne    8009c0 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8009a7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8009ae:	00 
  8009af:	8d 43 08             	lea    0x8(%ebx),%eax
  8009b2:	89 04 24             	mov    %eax,(%esp)
  8009b5:	e8 ec 09 00 00       	call   8013a6 <sys_cputs>
		b->idx = 0;
  8009ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8009c0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8009c4:	83 c4 14             	add    $0x14,%esp
  8009c7:	5b                   	pop    %ebx
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8009d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009da:	00 00 00 
	b.cnt = 0;
  8009dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009e4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8009e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ff:	c7 04 24 88 09 80 00 	movl   $0x800988,(%esp)
  800a06:	e8 b3 01 00 00       	call   800bbe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800a0b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800a11:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a15:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800a1b:	89 04 24             	mov    %eax,(%esp)
  800a1e:	e8 83 09 00 00       	call   8013a6 <sys_cputs>

	return b.cnt;
}
  800a23:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a29:	c9                   	leave  
  800a2a:	c3                   	ret    

00800a2b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a31:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800a34:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	89 04 24             	mov    %eax,(%esp)
  800a3e:	e8 87 ff ff ff       	call   8009ca <vcprintf>
	va_end(ap);

	return cnt;
}
  800a43:	c9                   	leave  
  800a44:	c3                   	ret    
  800a45:	66 90                	xchg   %ax,%ax
  800a47:	66 90                	xchg   %ax,%ax
  800a49:	66 90                	xchg   %ax,%ax
  800a4b:	66 90                	xchg   %ax,%ax
  800a4d:	66 90                	xchg   %ax,%ax
  800a4f:	90                   	nop

00800a50 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	57                   	push   %edi
  800a54:	56                   	push   %esi
  800a55:	53                   	push   %ebx
  800a56:	83 ec 3c             	sub    $0x3c,%esp
  800a59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a5c:	89 d7                	mov    %edx,%edi
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a67:	89 c3                	mov    %eax,%ebx
  800a69:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800a6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a77:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a7a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a7d:	39 d9                	cmp    %ebx,%ecx
  800a7f:	72 05                	jb     800a86 <printnum+0x36>
  800a81:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a84:	77 69                	ja     800aef <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a86:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a89:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800a8d:	83 ee 01             	sub    $0x1,%esi
  800a90:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800a94:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a98:	8b 44 24 08          	mov    0x8(%esp),%eax
  800a9c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800aa0:	89 c3                	mov    %eax,%ebx
  800aa2:	89 d6                	mov    %edx,%esi
  800aa4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800aa7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800aaa:	89 54 24 08          	mov    %edx,0x8(%esp)
  800aae:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800ab2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab5:	89 04 24             	mov    %eax,(%esp)
  800ab8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800abb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800abf:	e8 7c 24 00 00       	call   802f40 <__udivdi3>
  800ac4:	89 d9                	mov    %ebx,%ecx
  800ac6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800aca:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800ace:	89 04 24             	mov    %eax,(%esp)
  800ad1:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ad5:	89 fa                	mov    %edi,%edx
  800ad7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ada:	e8 71 ff ff ff       	call   800a50 <printnum>
  800adf:	eb 1b                	jmp    800afc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ae1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ae5:	8b 45 18             	mov    0x18(%ebp),%eax
  800ae8:	89 04 24             	mov    %eax,(%esp)
  800aeb:	ff d3                	call   *%ebx
  800aed:	eb 03                	jmp    800af2 <printnum+0xa2>
  800aef:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800af2:	83 ee 01             	sub    $0x1,%esi
  800af5:	85 f6                	test   %esi,%esi
  800af7:	7f e8                	jg     800ae1 <printnum+0x91>
  800af9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800afc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b00:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b04:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b07:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800b0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b0e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b15:	89 04 24             	mov    %eax,(%esp)
  800b18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b1f:	e8 4c 25 00 00       	call   803070 <__umoddi3>
  800b24:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b28:	0f be 80 1f 34 80 00 	movsbl 0x80341f(%eax),%eax
  800b2f:	89 04 24             	mov    %eax,(%esp)
  800b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b35:	ff d0                	call   *%eax
}
  800b37:	83 c4 3c             	add    $0x3c,%esp
  800b3a:	5b                   	pop    %ebx
  800b3b:	5e                   	pop    %esi
  800b3c:	5f                   	pop    %edi
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b42:	83 fa 01             	cmp    $0x1,%edx
  800b45:	7e 0e                	jle    800b55 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800b47:	8b 10                	mov    (%eax),%edx
  800b49:	8d 4a 08             	lea    0x8(%edx),%ecx
  800b4c:	89 08                	mov    %ecx,(%eax)
  800b4e:	8b 02                	mov    (%edx),%eax
  800b50:	8b 52 04             	mov    0x4(%edx),%edx
  800b53:	eb 22                	jmp    800b77 <getuint+0x38>
	else if (lflag)
  800b55:	85 d2                	test   %edx,%edx
  800b57:	74 10                	je     800b69 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800b59:	8b 10                	mov    (%eax),%edx
  800b5b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800b5e:	89 08                	mov    %ecx,(%eax)
  800b60:	8b 02                	mov    (%edx),%eax
  800b62:	ba 00 00 00 00       	mov    $0x0,%edx
  800b67:	eb 0e                	jmp    800b77 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800b69:	8b 10                	mov    (%eax),%edx
  800b6b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800b6e:	89 08                	mov    %ecx,(%eax)
  800b70:	8b 02                	mov    (%edx),%eax
  800b72:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800b7f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800b83:	8b 10                	mov    (%eax),%edx
  800b85:	3b 50 04             	cmp    0x4(%eax),%edx
  800b88:	73 0a                	jae    800b94 <sprintputch+0x1b>
		*b->buf++ = ch;
  800b8a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b8d:	89 08                	mov    %ecx,(%eax)
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	88 02                	mov    %al,(%edx)
}
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b9c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800b9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba6:	89 44 24 08          	mov    %eax,0x8(%esp)
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	89 04 24             	mov    %eax,(%esp)
  800bb7:	e8 02 00 00 00       	call   800bbe <vprintfmt>
	va_end(ap);
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	57                   	push   %edi
  800bc2:	56                   	push   %esi
  800bc3:	53                   	push   %ebx
  800bc4:	83 ec 3c             	sub    $0x3c,%esp
  800bc7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800bca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bcd:	eb 14                	jmp    800be3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800bcf:	85 c0                	test   %eax,%eax
  800bd1:	0f 84 b3 03 00 00    	je     800f8a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800bd7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bdb:	89 04 24             	mov    %eax,(%esp)
  800bde:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be1:	89 f3                	mov    %esi,%ebx
  800be3:	8d 73 01             	lea    0x1(%ebx),%esi
  800be6:	0f b6 03             	movzbl (%ebx),%eax
  800be9:	83 f8 25             	cmp    $0x25,%eax
  800bec:	75 e1                	jne    800bcf <vprintfmt+0x11>
  800bee:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800bf2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800bf9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800c00:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800c07:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0c:	eb 1d                	jmp    800c2b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c0e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800c10:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800c14:	eb 15                	jmp    800c2b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c16:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c18:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800c1c:	eb 0d                	jmp    800c2b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800c1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c21:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800c24:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c2b:	8d 5e 01             	lea    0x1(%esi),%ebx
  800c2e:	0f b6 0e             	movzbl (%esi),%ecx
  800c31:	0f b6 c1             	movzbl %cl,%eax
  800c34:	83 e9 23             	sub    $0x23,%ecx
  800c37:	80 f9 55             	cmp    $0x55,%cl
  800c3a:	0f 87 2a 03 00 00    	ja     800f6a <vprintfmt+0x3ac>
  800c40:	0f b6 c9             	movzbl %cl,%ecx
  800c43:	ff 24 8d a0 35 80 00 	jmp    *0x8035a0(,%ecx,4)
  800c4a:	89 de                	mov    %ebx,%esi
  800c4c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800c51:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800c54:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800c58:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800c5b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800c5e:	83 fb 09             	cmp    $0x9,%ebx
  800c61:	77 36                	ja     800c99 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c63:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c66:	eb e9                	jmp    800c51 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c68:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6b:	8d 48 04             	lea    0x4(%eax),%ecx
  800c6e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c76:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800c78:	eb 22                	jmp    800c9c <vprintfmt+0xde>
  800c7a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800c7d:	85 c9                	test   %ecx,%ecx
  800c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c84:	0f 49 c1             	cmovns %ecx,%eax
  800c87:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c8a:	89 de                	mov    %ebx,%esi
  800c8c:	eb 9d                	jmp    800c2b <vprintfmt+0x6d>
  800c8e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800c90:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800c97:	eb 92                	jmp    800c2b <vprintfmt+0x6d>
  800c99:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  800c9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ca0:	79 89                	jns    800c2b <vprintfmt+0x6d>
  800ca2:	e9 77 ff ff ff       	jmp    800c1e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ca7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800caa:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800cac:	e9 7a ff ff ff       	jmp    800c2b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb4:	8d 50 04             	lea    0x4(%eax),%edx
  800cb7:	89 55 14             	mov    %edx,0x14(%ebp)
  800cba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cbe:	8b 00                	mov    (%eax),%eax
  800cc0:	89 04 24             	mov    %eax,(%esp)
  800cc3:	ff 55 08             	call   *0x8(%ebp)
			break;
  800cc6:	e9 18 ff ff ff       	jmp    800be3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ccb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cce:	8d 50 04             	lea    0x4(%eax),%edx
  800cd1:	89 55 14             	mov    %edx,0x14(%ebp)
  800cd4:	8b 00                	mov    (%eax),%eax
  800cd6:	99                   	cltd   
  800cd7:	31 d0                	xor    %edx,%eax
  800cd9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cdb:	83 f8 12             	cmp    $0x12,%eax
  800cde:	7f 0b                	jg     800ceb <vprintfmt+0x12d>
  800ce0:	8b 14 85 00 37 80 00 	mov    0x803700(,%eax,4),%edx
  800ce7:	85 d2                	test   %edx,%edx
  800ce9:	75 20                	jne    800d0b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  800ceb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cef:	c7 44 24 08 37 34 80 	movl   $0x803437,0x8(%esp)
  800cf6:	00 
  800cf7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	89 04 24             	mov    %eax,(%esp)
  800d01:	e8 90 fe ff ff       	call   800b96 <printfmt>
  800d06:	e9 d8 fe ff ff       	jmp    800be3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800d0b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800d0f:	c7 44 24 08 41 38 80 	movl   $0x803841,0x8(%esp)
  800d16:	00 
  800d17:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 04 24             	mov    %eax,(%esp)
  800d21:	e8 70 fe ff ff       	call   800b96 <printfmt>
  800d26:	e9 b8 fe ff ff       	jmp    800be3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d2b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800d2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d31:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d34:	8b 45 14             	mov    0x14(%ebp),%eax
  800d37:	8d 50 04             	lea    0x4(%eax),%edx
  800d3a:	89 55 14             	mov    %edx,0x14(%ebp)
  800d3d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800d3f:	85 f6                	test   %esi,%esi
  800d41:	b8 30 34 80 00       	mov    $0x803430,%eax
  800d46:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800d49:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800d4d:	0f 84 97 00 00 00    	je     800dea <vprintfmt+0x22c>
  800d53:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800d57:	0f 8e 9b 00 00 00    	jle    800df8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d5d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800d61:	89 34 24             	mov    %esi,(%esp)
  800d64:	e8 cf 02 00 00       	call   801038 <strnlen>
  800d69:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800d6c:	29 c2                	sub    %eax,%edx
  800d6e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800d71:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800d75:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d78:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800d7b:	8b 75 08             	mov    0x8(%ebp),%esi
  800d7e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d81:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d83:	eb 0f                	jmp    800d94 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800d85:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d8c:	89 04 24             	mov    %eax,(%esp)
  800d8f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d91:	83 eb 01             	sub    $0x1,%ebx
  800d94:	85 db                	test   %ebx,%ebx
  800d96:	7f ed                	jg     800d85 <vprintfmt+0x1c7>
  800d98:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800d9b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800d9e:	85 d2                	test   %edx,%edx
  800da0:	b8 00 00 00 00       	mov    $0x0,%eax
  800da5:	0f 49 c2             	cmovns %edx,%eax
  800da8:	29 c2                	sub    %eax,%edx
  800daa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800dad:	89 d7                	mov    %edx,%edi
  800daf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800db2:	eb 50                	jmp    800e04 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800db4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800db8:	74 1e                	je     800dd8 <vprintfmt+0x21a>
  800dba:	0f be d2             	movsbl %dl,%edx
  800dbd:	83 ea 20             	sub    $0x20,%edx
  800dc0:	83 fa 5e             	cmp    $0x5e,%edx
  800dc3:	76 13                	jbe    800dd8 <vprintfmt+0x21a>
					putch('?', putdat);
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dcc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800dd3:	ff 55 08             	call   *0x8(%ebp)
  800dd6:	eb 0d                	jmp    800de5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddb:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ddf:	89 04 24             	mov    %eax,(%esp)
  800de2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800de5:	83 ef 01             	sub    $0x1,%edi
  800de8:	eb 1a                	jmp    800e04 <vprintfmt+0x246>
  800dea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800ded:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800df0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800df3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800df6:	eb 0c                	jmp    800e04 <vprintfmt+0x246>
  800df8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800dfb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800dfe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e01:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800e04:	83 c6 01             	add    $0x1,%esi
  800e07:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800e0b:	0f be c2             	movsbl %dl,%eax
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	74 27                	je     800e39 <vprintfmt+0x27b>
  800e12:	85 db                	test   %ebx,%ebx
  800e14:	78 9e                	js     800db4 <vprintfmt+0x1f6>
  800e16:	83 eb 01             	sub    $0x1,%ebx
  800e19:	79 99                	jns    800db4 <vprintfmt+0x1f6>
  800e1b:	89 f8                	mov    %edi,%eax
  800e1d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e20:	8b 75 08             	mov    0x8(%ebp),%esi
  800e23:	89 c3                	mov    %eax,%ebx
  800e25:	eb 1a                	jmp    800e41 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800e27:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e2b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800e32:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e34:	83 eb 01             	sub    $0x1,%ebx
  800e37:	eb 08                	jmp    800e41 <vprintfmt+0x283>
  800e39:	89 fb                	mov    %edi,%ebx
  800e3b:	8b 75 08             	mov    0x8(%ebp),%esi
  800e3e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e41:	85 db                	test   %ebx,%ebx
  800e43:	7f e2                	jg     800e27 <vprintfmt+0x269>
  800e45:	89 75 08             	mov    %esi,0x8(%ebp)
  800e48:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e4b:	e9 93 fd ff ff       	jmp    800be3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800e50:	83 fa 01             	cmp    $0x1,%edx
  800e53:	7e 16                	jle    800e6b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800e55:	8b 45 14             	mov    0x14(%ebp),%eax
  800e58:	8d 50 08             	lea    0x8(%eax),%edx
  800e5b:	89 55 14             	mov    %edx,0x14(%ebp)
  800e5e:	8b 50 04             	mov    0x4(%eax),%edx
  800e61:	8b 00                	mov    (%eax),%eax
  800e63:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e66:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800e69:	eb 32                	jmp    800e9d <vprintfmt+0x2df>
	else if (lflag)
  800e6b:	85 d2                	test   %edx,%edx
  800e6d:	74 18                	je     800e87 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800e6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e72:	8d 50 04             	lea    0x4(%eax),%edx
  800e75:	89 55 14             	mov    %edx,0x14(%ebp)
  800e78:	8b 30                	mov    (%eax),%esi
  800e7a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800e7d:	89 f0                	mov    %esi,%eax
  800e7f:	c1 f8 1f             	sar    $0x1f,%eax
  800e82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e85:	eb 16                	jmp    800e9d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800e87:	8b 45 14             	mov    0x14(%ebp),%eax
  800e8a:	8d 50 04             	lea    0x4(%eax),%edx
  800e8d:	89 55 14             	mov    %edx,0x14(%ebp)
  800e90:	8b 30                	mov    (%eax),%esi
  800e92:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800e95:	89 f0                	mov    %esi,%eax
  800e97:	c1 f8 1f             	sar    $0x1f,%eax
  800e9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800ea3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800ea8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eac:	0f 89 80 00 00 00    	jns    800f32 <vprintfmt+0x374>
				putch('-', putdat);
  800eb2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800eb6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800ebd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ec6:	f7 d8                	neg    %eax
  800ec8:	83 d2 00             	adc    $0x0,%edx
  800ecb:	f7 da                	neg    %edx
			}
			base = 10;
  800ecd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed2:	eb 5e                	jmp    800f32 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ed4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed7:	e8 63 fc ff ff       	call   800b3f <getuint>
			base = 10;
  800edc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800ee1:	eb 4f                	jmp    800f32 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800ee3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ee6:	e8 54 fc ff ff       	call   800b3f <getuint>
			base = 8;
  800eeb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800ef0:	eb 40                	jmp    800f32 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800ef2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ef6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800efd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800f00:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f04:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800f0b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800f0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f11:	8d 50 04             	lea    0x4(%eax),%edx
  800f14:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f17:	8b 00                	mov    (%eax),%eax
  800f19:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800f1e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800f23:	eb 0d                	jmp    800f32 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f25:	8d 45 14             	lea    0x14(%ebp),%eax
  800f28:	e8 12 fc ff ff       	call   800b3f <getuint>
			base = 16;
  800f2d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f32:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800f36:	89 74 24 10          	mov    %esi,0x10(%esp)
  800f3a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800f3d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800f41:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f45:	89 04 24             	mov    %eax,(%esp)
  800f48:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f4c:	89 fa                	mov    %edi,%edx
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	e8 fa fa ff ff       	call   800a50 <printnum>
			break;
  800f56:	e9 88 fc ff ff       	jmp    800be3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f5b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f5f:	89 04 24             	mov    %eax,(%esp)
  800f62:	ff 55 08             	call   *0x8(%ebp)
			break;
  800f65:	e9 79 fc ff ff       	jmp    800be3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f6a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f6e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800f75:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f78:	89 f3                	mov    %esi,%ebx
  800f7a:	eb 03                	jmp    800f7f <vprintfmt+0x3c1>
  800f7c:	83 eb 01             	sub    $0x1,%ebx
  800f7f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800f83:	75 f7                	jne    800f7c <vprintfmt+0x3be>
  800f85:	e9 59 fc ff ff       	jmp    800be3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800f8a:	83 c4 3c             	add    $0x3c,%esp
  800f8d:	5b                   	pop    %ebx
  800f8e:	5e                   	pop    %esi
  800f8f:	5f                   	pop    %edi
  800f90:	5d                   	pop    %ebp
  800f91:	c3                   	ret    

00800f92 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	83 ec 28             	sub    $0x28,%esp
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fa1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800fa5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800fa8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800faf:	85 c0                	test   %eax,%eax
  800fb1:	74 30                	je     800fe3 <vsnprintf+0x51>
  800fb3:	85 d2                	test   %edx,%edx
  800fb5:	7e 2c                	jle    800fe3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fc5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fcc:	c7 04 24 79 0b 80 00 	movl   $0x800b79,(%esp)
  800fd3:	e8 e6 fb ff ff       	call   800bbe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800fd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fdb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe1:	eb 05                	jmp    800fe8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800fe3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ff0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ff3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801001:	89 44 24 04          	mov    %eax,0x4(%esp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	89 04 24             	mov    %eax,(%esp)
  80100b:	e8 82 ff ff ff       	call   800f92 <vsnprintf>
	va_end(ap);

	return rc;
}
  801010:	c9                   	leave  
  801011:	c3                   	ret    
  801012:	66 90                	xchg   %ax,%ax
  801014:	66 90                	xchg   %ax,%ax
  801016:	66 90                	xchg   %ax,%ax
  801018:	66 90                	xchg   %ax,%ax
  80101a:	66 90                	xchg   %ax,%ax
  80101c:	66 90                	xchg   %ax,%ax
  80101e:	66 90                	xchg   %ax,%ax

00801020 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
  80102b:	eb 03                	jmp    801030 <strlen+0x10>
		n++;
  80102d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801030:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801034:	75 f7                	jne    80102d <strlen+0xd>
		n++;
	return n;
}
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80103e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801041:	b8 00 00 00 00       	mov    $0x0,%eax
  801046:	eb 03                	jmp    80104b <strnlen+0x13>
		n++;
  801048:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104b:	39 d0                	cmp    %edx,%eax
  80104d:	74 06                	je     801055 <strnlen+0x1d>
  80104f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801053:	75 f3                	jne    801048 <strnlen+0x10>
		n++;
	return n;
}
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    

00801057 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	53                   	push   %ebx
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801061:	89 c2                	mov    %eax,%edx
  801063:	83 c2 01             	add    $0x1,%edx
  801066:	83 c1 01             	add    $0x1,%ecx
  801069:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80106d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801070:	84 db                	test   %bl,%bl
  801072:	75 ef                	jne    801063 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801074:	5b                   	pop    %ebx
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	53                   	push   %ebx
  80107b:	83 ec 08             	sub    $0x8,%esp
  80107e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801081:	89 1c 24             	mov    %ebx,(%esp)
  801084:	e8 97 ff ff ff       	call   801020 <strlen>
	strcpy(dst + len, src);
  801089:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801090:	01 d8                	add    %ebx,%eax
  801092:	89 04 24             	mov    %eax,(%esp)
  801095:	e8 bd ff ff ff       	call   801057 <strcpy>
	return dst;
}
  80109a:	89 d8                	mov    %ebx,%eax
  80109c:	83 c4 08             	add    $0x8,%esp
  80109f:	5b                   	pop    %ebx
  8010a0:	5d                   	pop    %ebp
  8010a1:	c3                   	ret    

008010a2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	56                   	push   %esi
  8010a6:	53                   	push   %ebx
  8010a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8010aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ad:	89 f3                	mov    %esi,%ebx
  8010af:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010b2:	89 f2                	mov    %esi,%edx
  8010b4:	eb 0f                	jmp    8010c5 <strncpy+0x23>
		*dst++ = *src;
  8010b6:	83 c2 01             	add    $0x1,%edx
  8010b9:	0f b6 01             	movzbl (%ecx),%eax
  8010bc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8010bf:	80 39 01             	cmpb   $0x1,(%ecx)
  8010c2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010c5:	39 da                	cmp    %ebx,%edx
  8010c7:	75 ed                	jne    8010b6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8010c9:	89 f0                	mov    %esi,%eax
  8010cb:	5b                   	pop    %ebx
  8010cc:	5e                   	pop    %esi
  8010cd:	5d                   	pop    %ebp
  8010ce:	c3                   	ret    

008010cf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	56                   	push   %esi
  8010d3:	53                   	push   %ebx
  8010d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8010d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010dd:	89 f0                	mov    %esi,%eax
  8010df:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8010e3:	85 c9                	test   %ecx,%ecx
  8010e5:	75 0b                	jne    8010f2 <strlcpy+0x23>
  8010e7:	eb 1d                	jmp    801106 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8010e9:	83 c0 01             	add    $0x1,%eax
  8010ec:	83 c2 01             	add    $0x1,%edx
  8010ef:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010f2:	39 d8                	cmp    %ebx,%eax
  8010f4:	74 0b                	je     801101 <strlcpy+0x32>
  8010f6:	0f b6 0a             	movzbl (%edx),%ecx
  8010f9:	84 c9                	test   %cl,%cl
  8010fb:	75 ec                	jne    8010e9 <strlcpy+0x1a>
  8010fd:	89 c2                	mov    %eax,%edx
  8010ff:	eb 02                	jmp    801103 <strlcpy+0x34>
  801101:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  801103:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  801106:	29 f0                	sub    %esi,%eax
}
  801108:	5b                   	pop    %ebx
  801109:	5e                   	pop    %esi
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    

0080110c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801112:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801115:	eb 06                	jmp    80111d <strcmp+0x11>
		p++, q++;
  801117:	83 c1 01             	add    $0x1,%ecx
  80111a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80111d:	0f b6 01             	movzbl (%ecx),%eax
  801120:	84 c0                	test   %al,%al
  801122:	74 04                	je     801128 <strcmp+0x1c>
  801124:	3a 02                	cmp    (%edx),%al
  801126:	74 ef                	je     801117 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801128:	0f b6 c0             	movzbl %al,%eax
  80112b:	0f b6 12             	movzbl (%edx),%edx
  80112e:	29 d0                	sub    %edx,%eax
}
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    

00801132 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	53                   	push   %ebx
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	8b 55 0c             	mov    0xc(%ebp),%edx
  80113c:	89 c3                	mov    %eax,%ebx
  80113e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801141:	eb 06                	jmp    801149 <strncmp+0x17>
		n--, p++, q++;
  801143:	83 c0 01             	add    $0x1,%eax
  801146:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801149:	39 d8                	cmp    %ebx,%eax
  80114b:	74 15                	je     801162 <strncmp+0x30>
  80114d:	0f b6 08             	movzbl (%eax),%ecx
  801150:	84 c9                	test   %cl,%cl
  801152:	74 04                	je     801158 <strncmp+0x26>
  801154:	3a 0a                	cmp    (%edx),%cl
  801156:	74 eb                	je     801143 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801158:	0f b6 00             	movzbl (%eax),%eax
  80115b:	0f b6 12             	movzbl (%edx),%edx
  80115e:	29 d0                	sub    %edx,%eax
  801160:	eb 05                	jmp    801167 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801162:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801167:	5b                   	pop    %ebx
  801168:	5d                   	pop    %ebp
  801169:	c3                   	ret    

0080116a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801174:	eb 07                	jmp    80117d <strchr+0x13>
		if (*s == c)
  801176:	38 ca                	cmp    %cl,%dl
  801178:	74 0f                	je     801189 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80117a:	83 c0 01             	add    $0x1,%eax
  80117d:	0f b6 10             	movzbl (%eax),%edx
  801180:	84 d2                	test   %dl,%dl
  801182:	75 f2                	jne    801176 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801184:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    

0080118b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801195:	eb 07                	jmp    80119e <strfind+0x13>
		if (*s == c)
  801197:	38 ca                	cmp    %cl,%dl
  801199:	74 0a                	je     8011a5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80119b:	83 c0 01             	add    $0x1,%eax
  80119e:	0f b6 10             	movzbl (%eax),%edx
  8011a1:	84 d2                	test   %dl,%dl
  8011a3:	75 f2                	jne    801197 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	57                   	push   %edi
  8011ab:	56                   	push   %esi
  8011ac:	53                   	push   %ebx
  8011ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8011b3:	85 c9                	test   %ecx,%ecx
  8011b5:	74 36                	je     8011ed <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8011b7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8011bd:	75 28                	jne    8011e7 <memset+0x40>
  8011bf:	f6 c1 03             	test   $0x3,%cl
  8011c2:	75 23                	jne    8011e7 <memset+0x40>
		c &= 0xFF;
  8011c4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011c8:	89 d3                	mov    %edx,%ebx
  8011ca:	c1 e3 08             	shl    $0x8,%ebx
  8011cd:	89 d6                	mov    %edx,%esi
  8011cf:	c1 e6 18             	shl    $0x18,%esi
  8011d2:	89 d0                	mov    %edx,%eax
  8011d4:	c1 e0 10             	shl    $0x10,%eax
  8011d7:	09 f0                	or     %esi,%eax
  8011d9:	09 c2                	or     %eax,%edx
  8011db:	89 d0                	mov    %edx,%eax
  8011dd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8011df:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011e2:	fc                   	cld    
  8011e3:	f3 ab                	rep stos %eax,%es:(%edi)
  8011e5:	eb 06                	jmp    8011ed <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ea:	fc                   	cld    
  8011eb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8011ed:	89 f8                	mov    %edi,%eax
  8011ef:	5b                   	pop    %ebx
  8011f0:	5e                   	pop    %esi
  8011f1:	5f                   	pop    %edi
  8011f2:	5d                   	pop    %ebp
  8011f3:	c3                   	ret    

008011f4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	57                   	push   %edi
  8011f8:	56                   	push   %esi
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801202:	39 c6                	cmp    %eax,%esi
  801204:	73 35                	jae    80123b <memmove+0x47>
  801206:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801209:	39 d0                	cmp    %edx,%eax
  80120b:	73 2e                	jae    80123b <memmove+0x47>
		s += n;
		d += n;
  80120d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801210:	89 d6                	mov    %edx,%esi
  801212:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801214:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80121a:	75 13                	jne    80122f <memmove+0x3b>
  80121c:	f6 c1 03             	test   $0x3,%cl
  80121f:	75 0e                	jne    80122f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801221:	83 ef 04             	sub    $0x4,%edi
  801224:	8d 72 fc             	lea    -0x4(%edx),%esi
  801227:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80122a:	fd                   	std    
  80122b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80122d:	eb 09                	jmp    801238 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80122f:	83 ef 01             	sub    $0x1,%edi
  801232:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801235:	fd                   	std    
  801236:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801238:	fc                   	cld    
  801239:	eb 1d                	jmp    801258 <memmove+0x64>
  80123b:	89 f2                	mov    %esi,%edx
  80123d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80123f:	f6 c2 03             	test   $0x3,%dl
  801242:	75 0f                	jne    801253 <memmove+0x5f>
  801244:	f6 c1 03             	test   $0x3,%cl
  801247:	75 0a                	jne    801253 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801249:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80124c:	89 c7                	mov    %eax,%edi
  80124e:	fc                   	cld    
  80124f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801251:	eb 05                	jmp    801258 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801253:	89 c7                	mov    %eax,%edi
  801255:	fc                   	cld    
  801256:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801258:	5e                   	pop    %esi
  801259:	5f                   	pop    %edi
  80125a:	5d                   	pop    %ebp
  80125b:	c3                   	ret    

0080125c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801262:	8b 45 10             	mov    0x10(%ebp),%eax
  801265:	89 44 24 08          	mov    %eax,0x8(%esp)
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	89 04 24             	mov    %eax,(%esp)
  801276:	e8 79 ff ff ff       	call   8011f4 <memmove>
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	56                   	push   %esi
  801281:	53                   	push   %ebx
  801282:	8b 55 08             	mov    0x8(%ebp),%edx
  801285:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801288:	89 d6                	mov    %edx,%esi
  80128a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80128d:	eb 1a                	jmp    8012a9 <memcmp+0x2c>
		if (*s1 != *s2)
  80128f:	0f b6 02             	movzbl (%edx),%eax
  801292:	0f b6 19             	movzbl (%ecx),%ebx
  801295:	38 d8                	cmp    %bl,%al
  801297:	74 0a                	je     8012a3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801299:	0f b6 c0             	movzbl %al,%eax
  80129c:	0f b6 db             	movzbl %bl,%ebx
  80129f:	29 d8                	sub    %ebx,%eax
  8012a1:	eb 0f                	jmp    8012b2 <memcmp+0x35>
		s1++, s2++;
  8012a3:	83 c2 01             	add    $0x1,%edx
  8012a6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012a9:	39 f2                	cmp    %esi,%edx
  8012ab:	75 e2                	jne    80128f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b2:	5b                   	pop    %ebx
  8012b3:	5e                   	pop    %esi
  8012b4:	5d                   	pop    %ebp
  8012b5:	c3                   	ret    

008012b6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8012c4:	eb 07                	jmp    8012cd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012c6:	38 08                	cmp    %cl,(%eax)
  8012c8:	74 07                	je     8012d1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8012ca:	83 c0 01             	add    $0x1,%eax
  8012cd:	39 d0                	cmp    %edx,%eax
  8012cf:	72 f5                	jb     8012c6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    

008012d3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	57                   	push   %edi
  8012d7:	56                   	push   %esi
  8012d8:	53                   	push   %ebx
  8012d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012dc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012df:	eb 03                	jmp    8012e4 <strtol+0x11>
		s++;
  8012e1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012e4:	0f b6 0a             	movzbl (%edx),%ecx
  8012e7:	80 f9 09             	cmp    $0x9,%cl
  8012ea:	74 f5                	je     8012e1 <strtol+0xe>
  8012ec:	80 f9 20             	cmp    $0x20,%cl
  8012ef:	74 f0                	je     8012e1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012f1:	80 f9 2b             	cmp    $0x2b,%cl
  8012f4:	75 0a                	jne    801300 <strtol+0x2d>
		s++;
  8012f6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8012f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8012fe:	eb 11                	jmp    801311 <strtol+0x3e>
  801300:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801305:	80 f9 2d             	cmp    $0x2d,%cl
  801308:	75 07                	jne    801311 <strtol+0x3e>
		s++, neg = 1;
  80130a:	8d 52 01             	lea    0x1(%edx),%edx
  80130d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801311:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801316:	75 15                	jne    80132d <strtol+0x5a>
  801318:	80 3a 30             	cmpb   $0x30,(%edx)
  80131b:	75 10                	jne    80132d <strtol+0x5a>
  80131d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801321:	75 0a                	jne    80132d <strtol+0x5a>
		s += 2, base = 16;
  801323:	83 c2 02             	add    $0x2,%edx
  801326:	b8 10 00 00 00       	mov    $0x10,%eax
  80132b:	eb 10                	jmp    80133d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80132d:	85 c0                	test   %eax,%eax
  80132f:	75 0c                	jne    80133d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801331:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801333:	80 3a 30             	cmpb   $0x30,(%edx)
  801336:	75 05                	jne    80133d <strtol+0x6a>
		s++, base = 8;
  801338:	83 c2 01             	add    $0x1,%edx
  80133b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80133d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801342:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801345:	0f b6 0a             	movzbl (%edx),%ecx
  801348:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80134b:	89 f0                	mov    %esi,%eax
  80134d:	3c 09                	cmp    $0x9,%al
  80134f:	77 08                	ja     801359 <strtol+0x86>
			dig = *s - '0';
  801351:	0f be c9             	movsbl %cl,%ecx
  801354:	83 e9 30             	sub    $0x30,%ecx
  801357:	eb 20                	jmp    801379 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801359:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80135c:	89 f0                	mov    %esi,%eax
  80135e:	3c 19                	cmp    $0x19,%al
  801360:	77 08                	ja     80136a <strtol+0x97>
			dig = *s - 'a' + 10;
  801362:	0f be c9             	movsbl %cl,%ecx
  801365:	83 e9 57             	sub    $0x57,%ecx
  801368:	eb 0f                	jmp    801379 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80136a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80136d:	89 f0                	mov    %esi,%eax
  80136f:	3c 19                	cmp    $0x19,%al
  801371:	77 16                	ja     801389 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801373:	0f be c9             	movsbl %cl,%ecx
  801376:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801379:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80137c:	7d 0f                	jge    80138d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80137e:	83 c2 01             	add    $0x1,%edx
  801381:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801385:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801387:	eb bc                	jmp    801345 <strtol+0x72>
  801389:	89 d8                	mov    %ebx,%eax
  80138b:	eb 02                	jmp    80138f <strtol+0xbc>
  80138d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80138f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801393:	74 05                	je     80139a <strtol+0xc7>
		*endptr = (char *) s;
  801395:	8b 75 0c             	mov    0xc(%ebp),%esi
  801398:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80139a:	f7 d8                	neg    %eax
  80139c:	85 ff                	test   %edi,%edi
  80139e:	0f 44 c3             	cmove  %ebx,%eax
}
  8013a1:	5b                   	pop    %ebx
  8013a2:	5e                   	pop    %esi
  8013a3:	5f                   	pop    %edi
  8013a4:	5d                   	pop    %ebp
  8013a5:	c3                   	ret    

008013a6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	57                   	push   %edi
  8013aa:	56                   	push   %esi
  8013ab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b7:	89 c3                	mov    %eax,%ebx
  8013b9:	89 c7                	mov    %eax,%edi
  8013bb:	89 c6                	mov    %eax,%esi
  8013bd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8013bf:	5b                   	pop    %ebx
  8013c0:	5e                   	pop    %esi
  8013c1:	5f                   	pop    %edi
  8013c2:	5d                   	pop    %ebp
  8013c3:	c3                   	ret    

008013c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	57                   	push   %edi
  8013c8:	56                   	push   %esi
  8013c9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8013cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8013d4:	89 d1                	mov    %edx,%ecx
  8013d6:	89 d3                	mov    %edx,%ebx
  8013d8:	89 d7                	mov    %edx,%edi
  8013da:	89 d6                	mov    %edx,%esi
  8013dc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8013de:	5b                   	pop    %ebx
  8013df:	5e                   	pop    %esi
  8013e0:	5f                   	pop    %edi
  8013e1:	5d                   	pop    %ebp
  8013e2:	c3                   	ret    

008013e3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	57                   	push   %edi
  8013e7:	56                   	push   %esi
  8013e8:	53                   	push   %ebx
  8013e9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013f1:	b8 03 00 00 00       	mov    $0x3,%eax
  8013f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f9:	89 cb                	mov    %ecx,%ebx
  8013fb:	89 cf                	mov    %ecx,%edi
  8013fd:	89 ce                	mov    %ecx,%esi
  8013ff:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801401:	85 c0                	test   %eax,%eax
  801403:	7e 28                	jle    80142d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801405:	89 44 24 10          	mov    %eax,0x10(%esp)
  801409:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801410:	00 
  801411:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  801418:	00 
  801419:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801420:	00 
  801421:	c7 04 24 88 37 80 00 	movl   $0x803788,(%esp)
  801428:	e8 05 f5 ff ff       	call   800932 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80142d:	83 c4 2c             	add    $0x2c,%esp
  801430:	5b                   	pop    %ebx
  801431:	5e                   	pop    %esi
  801432:	5f                   	pop    %edi
  801433:	5d                   	pop    %ebp
  801434:	c3                   	ret    

00801435 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	57                   	push   %edi
  801439:	56                   	push   %esi
  80143a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80143b:	ba 00 00 00 00       	mov    $0x0,%edx
  801440:	b8 02 00 00 00       	mov    $0x2,%eax
  801445:	89 d1                	mov    %edx,%ecx
  801447:	89 d3                	mov    %edx,%ebx
  801449:	89 d7                	mov    %edx,%edi
  80144b:	89 d6                	mov    %edx,%esi
  80144d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80144f:	5b                   	pop    %ebx
  801450:	5e                   	pop    %esi
  801451:	5f                   	pop    %edi
  801452:	5d                   	pop    %ebp
  801453:	c3                   	ret    

00801454 <sys_yield>:

void
sys_yield(void)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	57                   	push   %edi
  801458:	56                   	push   %esi
  801459:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80145a:	ba 00 00 00 00       	mov    $0x0,%edx
  80145f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801464:	89 d1                	mov    %edx,%ecx
  801466:	89 d3                	mov    %edx,%ebx
  801468:	89 d7                	mov    %edx,%edi
  80146a:	89 d6                	mov    %edx,%esi
  80146c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80146e:	5b                   	pop    %ebx
  80146f:	5e                   	pop    %esi
  801470:	5f                   	pop    %edi
  801471:	5d                   	pop    %ebp
  801472:	c3                   	ret    

00801473 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	57                   	push   %edi
  801477:	56                   	push   %esi
  801478:	53                   	push   %ebx
  801479:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80147c:	be 00 00 00 00       	mov    $0x0,%esi
  801481:	b8 04 00 00 00       	mov    $0x4,%eax
  801486:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801489:	8b 55 08             	mov    0x8(%ebp),%edx
  80148c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80148f:	89 f7                	mov    %esi,%edi
  801491:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801493:	85 c0                	test   %eax,%eax
  801495:	7e 28                	jle    8014bf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801497:	89 44 24 10          	mov    %eax,0x10(%esp)
  80149b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8014a2:	00 
  8014a3:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  8014aa:	00 
  8014ab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014b2:	00 
  8014b3:	c7 04 24 88 37 80 00 	movl   $0x803788,(%esp)
  8014ba:	e8 73 f4 ff ff       	call   800932 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8014bf:	83 c4 2c             	add    $0x2c,%esp
  8014c2:	5b                   	pop    %ebx
  8014c3:	5e                   	pop    %esi
  8014c4:	5f                   	pop    %edi
  8014c5:	5d                   	pop    %ebp
  8014c6:	c3                   	ret    

008014c7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	57                   	push   %edi
  8014cb:	56                   	push   %esi
  8014cc:	53                   	push   %ebx
  8014cd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014d0:	b8 05 00 00 00       	mov    $0x5,%eax
  8014d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014db:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014de:	8b 7d 14             	mov    0x14(%ebp),%edi
  8014e1:	8b 75 18             	mov    0x18(%ebp),%esi
  8014e4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	7e 28                	jle    801512 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014ee:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8014f5:	00 
  8014f6:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  8014fd:	00 
  8014fe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801505:	00 
  801506:	c7 04 24 88 37 80 00 	movl   $0x803788,(%esp)
  80150d:	e8 20 f4 ff ff       	call   800932 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801512:	83 c4 2c             	add    $0x2c,%esp
  801515:	5b                   	pop    %ebx
  801516:	5e                   	pop    %esi
  801517:	5f                   	pop    %edi
  801518:	5d                   	pop    %ebp
  801519:	c3                   	ret    

0080151a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	57                   	push   %edi
  80151e:	56                   	push   %esi
  80151f:	53                   	push   %ebx
  801520:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801523:	bb 00 00 00 00       	mov    $0x0,%ebx
  801528:	b8 06 00 00 00       	mov    $0x6,%eax
  80152d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801530:	8b 55 08             	mov    0x8(%ebp),%edx
  801533:	89 df                	mov    %ebx,%edi
  801535:	89 de                	mov    %ebx,%esi
  801537:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801539:	85 c0                	test   %eax,%eax
  80153b:	7e 28                	jle    801565 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80153d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801541:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801548:	00 
  801549:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  801550:	00 
  801551:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801558:	00 
  801559:	c7 04 24 88 37 80 00 	movl   $0x803788,(%esp)
  801560:	e8 cd f3 ff ff       	call   800932 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801565:	83 c4 2c             	add    $0x2c,%esp
  801568:	5b                   	pop    %ebx
  801569:	5e                   	pop    %esi
  80156a:	5f                   	pop    %edi
  80156b:	5d                   	pop    %ebp
  80156c:	c3                   	ret    

0080156d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	57                   	push   %edi
  801571:	56                   	push   %esi
  801572:	53                   	push   %ebx
  801573:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801576:	bb 00 00 00 00       	mov    $0x0,%ebx
  80157b:	b8 08 00 00 00       	mov    $0x8,%eax
  801580:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801583:	8b 55 08             	mov    0x8(%ebp),%edx
  801586:	89 df                	mov    %ebx,%edi
  801588:	89 de                	mov    %ebx,%esi
  80158a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80158c:	85 c0                	test   %eax,%eax
  80158e:	7e 28                	jle    8015b8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801590:	89 44 24 10          	mov    %eax,0x10(%esp)
  801594:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80159b:	00 
  80159c:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  8015a3:	00 
  8015a4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015ab:	00 
  8015ac:	c7 04 24 88 37 80 00 	movl   $0x803788,(%esp)
  8015b3:	e8 7a f3 ff ff       	call   800932 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8015b8:	83 c4 2c             	add    $0x2c,%esp
  8015bb:	5b                   	pop    %ebx
  8015bc:	5e                   	pop    %esi
  8015bd:	5f                   	pop    %edi
  8015be:	5d                   	pop    %ebp
  8015bf:	c3                   	ret    

008015c0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	57                   	push   %edi
  8015c4:	56                   	push   %esi
  8015c5:	53                   	push   %ebx
  8015c6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015ce:	b8 09 00 00 00       	mov    $0x9,%eax
  8015d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d9:	89 df                	mov    %ebx,%edi
  8015db:	89 de                	mov    %ebx,%esi
  8015dd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	7e 28                	jle    80160b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015e7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8015ee:	00 
  8015ef:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  8015f6:	00 
  8015f7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015fe:	00 
  8015ff:	c7 04 24 88 37 80 00 	movl   $0x803788,(%esp)
  801606:	e8 27 f3 ff ff       	call   800932 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80160b:	83 c4 2c             	add    $0x2c,%esp
  80160e:	5b                   	pop    %ebx
  80160f:	5e                   	pop    %esi
  801610:	5f                   	pop    %edi
  801611:	5d                   	pop    %ebp
  801612:	c3                   	ret    

00801613 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	57                   	push   %edi
  801617:	56                   	push   %esi
  801618:	53                   	push   %ebx
  801619:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80161c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801621:	b8 0a 00 00 00       	mov    $0xa,%eax
  801626:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801629:	8b 55 08             	mov    0x8(%ebp),%edx
  80162c:	89 df                	mov    %ebx,%edi
  80162e:	89 de                	mov    %ebx,%esi
  801630:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801632:	85 c0                	test   %eax,%eax
  801634:	7e 28                	jle    80165e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801636:	89 44 24 10          	mov    %eax,0x10(%esp)
  80163a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801641:	00 
  801642:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  801649:	00 
  80164a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801651:	00 
  801652:	c7 04 24 88 37 80 00 	movl   $0x803788,(%esp)
  801659:	e8 d4 f2 ff ff       	call   800932 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80165e:	83 c4 2c             	add    $0x2c,%esp
  801661:	5b                   	pop    %ebx
  801662:	5e                   	pop    %esi
  801663:	5f                   	pop    %edi
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    

00801666 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	57                   	push   %edi
  80166a:	56                   	push   %esi
  80166b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80166c:	be 00 00 00 00       	mov    $0x0,%esi
  801671:	b8 0c 00 00 00       	mov    $0xc,%eax
  801676:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801679:	8b 55 08             	mov    0x8(%ebp),%edx
  80167c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80167f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801682:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801684:	5b                   	pop    %ebx
  801685:	5e                   	pop    %esi
  801686:	5f                   	pop    %edi
  801687:	5d                   	pop    %ebp
  801688:	c3                   	ret    

00801689 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	57                   	push   %edi
  80168d:	56                   	push   %esi
  80168e:	53                   	push   %ebx
  80168f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801692:	b9 00 00 00 00       	mov    $0x0,%ecx
  801697:	b8 0d 00 00 00       	mov    $0xd,%eax
  80169c:	8b 55 08             	mov    0x8(%ebp),%edx
  80169f:	89 cb                	mov    %ecx,%ebx
  8016a1:	89 cf                	mov    %ecx,%edi
  8016a3:	89 ce                	mov    %ecx,%esi
  8016a5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	7e 28                	jle    8016d3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016ab:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016af:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8016b6:	00 
  8016b7:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  8016be:	00 
  8016bf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016c6:	00 
  8016c7:	c7 04 24 88 37 80 00 	movl   $0x803788,(%esp)
  8016ce:	e8 5f f2 ff ff       	call   800932 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8016d3:	83 c4 2c             	add    $0x2c,%esp
  8016d6:	5b                   	pop    %ebx
  8016d7:	5e                   	pop    %esi
  8016d8:	5f                   	pop    %edi
  8016d9:	5d                   	pop    %ebp
  8016da:	c3                   	ret    

008016db <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	57                   	push   %edi
  8016df:	56                   	push   %esi
  8016e0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8016eb:	89 d1                	mov    %edx,%ecx
  8016ed:	89 d3                	mov    %edx,%ebx
  8016ef:	89 d7                	mov    %edx,%edi
  8016f1:	89 d6                	mov    %edx,%esi
  8016f3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8016f5:	5b                   	pop    %ebx
  8016f6:	5e                   	pop    %esi
  8016f7:	5f                   	pop    %edi
  8016f8:	5d                   	pop    %ebp
  8016f9:	c3                   	ret    

008016fa <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	57                   	push   %edi
  8016fe:	56                   	push   %esi
  8016ff:	53                   	push   %ebx
  801700:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801703:	bb 00 00 00 00       	mov    $0x0,%ebx
  801708:	b8 0f 00 00 00       	mov    $0xf,%eax
  80170d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801710:	8b 55 08             	mov    0x8(%ebp),%edx
  801713:	89 df                	mov    %ebx,%edi
  801715:	89 de                	mov    %ebx,%esi
  801717:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801719:	85 c0                	test   %eax,%eax
  80171b:	7e 28                	jle    801745 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80171d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801721:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801728:	00 
  801729:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  801730:	00 
  801731:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801738:	00 
  801739:	c7 04 24 88 37 80 00 	movl   $0x803788,(%esp)
  801740:	e8 ed f1 ff ff       	call   800932 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  801745:	83 c4 2c             	add    $0x2c,%esp
  801748:	5b                   	pop    %ebx
  801749:	5e                   	pop    %esi
  80174a:	5f                   	pop    %edi
  80174b:	5d                   	pop    %ebp
  80174c:	c3                   	ret    

0080174d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	57                   	push   %edi
  801751:	56                   	push   %esi
  801752:	53                   	push   %ebx
  801753:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801756:	bb 00 00 00 00       	mov    $0x0,%ebx
  80175b:	b8 10 00 00 00       	mov    $0x10,%eax
  801760:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801763:	8b 55 08             	mov    0x8(%ebp),%edx
  801766:	89 df                	mov    %ebx,%edi
  801768:	89 de                	mov    %ebx,%esi
  80176a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80176c:	85 c0                	test   %eax,%eax
  80176e:	7e 28                	jle    801798 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801770:	89 44 24 10          	mov    %eax,0x10(%esp)
  801774:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80177b:	00 
  80177c:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  801783:	00 
  801784:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80178b:	00 
  80178c:	c7 04 24 88 37 80 00 	movl   $0x803788,(%esp)
  801793:	e8 9a f1 ff ff       	call   800932 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  801798:	83 c4 2c             	add    $0x2c,%esp
  80179b:	5b                   	pop    %ebx
  80179c:	5e                   	pop    %esi
  80179d:	5f                   	pop    %edi
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    

008017a0 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	57                   	push   %edi
  8017a4:	56                   	push   %esi
  8017a5:	53                   	push   %ebx
  8017a6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017ae:	b8 11 00 00 00       	mov    $0x11,%eax
  8017b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b9:	89 df                	mov    %ebx,%edi
  8017bb:	89 de                	mov    %ebx,%esi
  8017bd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017bf:	85 c0                	test   %eax,%eax
  8017c1:	7e 28                	jle    8017eb <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017c7:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  8017ce:	00 
  8017cf:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  8017d6:	00 
  8017d7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8017de:	00 
  8017df:	c7 04 24 88 37 80 00 	movl   $0x803788,(%esp)
  8017e6:	e8 47 f1 ff ff       	call   800932 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  8017eb:	83 c4 2c             	add    $0x2c,%esp
  8017ee:	5b                   	pop    %ebx
  8017ef:	5e                   	pop    %esi
  8017f0:	5f                   	pop    %edi
  8017f1:	5d                   	pop    %ebp
  8017f2:	c3                   	ret    

008017f3 <sys_sleep>:

int
sys_sleep(int channel)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	57                   	push   %edi
  8017f7:	56                   	push   %esi
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801801:	b8 12 00 00 00       	mov    $0x12,%eax
  801806:	8b 55 08             	mov    0x8(%ebp),%edx
  801809:	89 cb                	mov    %ecx,%ebx
  80180b:	89 cf                	mov    %ecx,%edi
  80180d:	89 ce                	mov    %ecx,%esi
  80180f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801811:	85 c0                	test   %eax,%eax
  801813:	7e 28                	jle    80183d <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801815:	89 44 24 10          	mov    %eax,0x10(%esp)
  801819:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801820:	00 
  801821:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  801828:	00 
  801829:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801830:	00 
  801831:	c7 04 24 88 37 80 00 	movl   $0x803788,(%esp)
  801838:	e8 f5 f0 ff ff       	call   800932 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80183d:	83 c4 2c             	add    $0x2c,%esp
  801840:	5b                   	pop    %ebx
  801841:	5e                   	pop    %esi
  801842:	5f                   	pop    %edi
  801843:	5d                   	pop    %ebp
  801844:	c3                   	ret    

00801845 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	57                   	push   %edi
  801849:	56                   	push   %esi
  80184a:	53                   	push   %ebx
  80184b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80184e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801853:	b8 13 00 00 00       	mov    $0x13,%eax
  801858:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80185b:	8b 55 08             	mov    0x8(%ebp),%edx
  80185e:	89 df                	mov    %ebx,%edi
  801860:	89 de                	mov    %ebx,%esi
  801862:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801864:	85 c0                	test   %eax,%eax
  801866:	7e 28                	jle    801890 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801868:	89 44 24 10          	mov    %eax,0x10(%esp)
  80186c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801873:	00 
  801874:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  80187b:	00 
  80187c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801883:	00 
  801884:	c7 04 24 88 37 80 00 	movl   $0x803788,(%esp)
  80188b:	e8 a2 f0 ff ff       	call   800932 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801890:	83 c4 2c             	add    $0x2c,%esp
  801893:	5b                   	pop    %ebx
  801894:	5e                   	pop    %esi
  801895:	5f                   	pop    %edi
  801896:	5d                   	pop    %ebp
  801897:	c3                   	ret    
  801898:	66 90                	xchg   %ax,%ax
  80189a:	66 90                	xchg   %ax,%ax
  80189c:	66 90                	xchg   %ax,%ax
  80189e:	66 90                	xchg   %ax,%ax

008018a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8018ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8018ae:	5d                   	pop    %ebp
  8018af:	c3                   	ret    

008018b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8018bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8018c5:	5d                   	pop    %ebp
  8018c6:	c3                   	ret    

008018c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8018d2:	89 c2                	mov    %eax,%edx
  8018d4:	c1 ea 16             	shr    $0x16,%edx
  8018d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8018de:	f6 c2 01             	test   $0x1,%dl
  8018e1:	74 11                	je     8018f4 <fd_alloc+0x2d>
  8018e3:	89 c2                	mov    %eax,%edx
  8018e5:	c1 ea 0c             	shr    $0xc,%edx
  8018e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018ef:	f6 c2 01             	test   $0x1,%dl
  8018f2:	75 09                	jne    8018fd <fd_alloc+0x36>
			*fd_store = fd;
  8018f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fb:	eb 17                	jmp    801914 <fd_alloc+0x4d>
  8018fd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801902:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801907:	75 c9                	jne    8018d2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801909:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80190f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801914:	5d                   	pop    %ebp
  801915:	c3                   	ret    

00801916 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80191c:	83 f8 1f             	cmp    $0x1f,%eax
  80191f:	77 36                	ja     801957 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801921:	c1 e0 0c             	shl    $0xc,%eax
  801924:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801929:	89 c2                	mov    %eax,%edx
  80192b:	c1 ea 16             	shr    $0x16,%edx
  80192e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801935:	f6 c2 01             	test   $0x1,%dl
  801938:	74 24                	je     80195e <fd_lookup+0x48>
  80193a:	89 c2                	mov    %eax,%edx
  80193c:	c1 ea 0c             	shr    $0xc,%edx
  80193f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801946:	f6 c2 01             	test   $0x1,%dl
  801949:	74 1a                	je     801965 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80194b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194e:	89 02                	mov    %eax,(%edx)
	return 0;
  801950:	b8 00 00 00 00       	mov    $0x0,%eax
  801955:	eb 13                	jmp    80196a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801957:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80195c:	eb 0c                	jmp    80196a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80195e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801963:	eb 05                	jmp    80196a <fd_lookup+0x54>
  801965:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    

0080196c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	83 ec 18             	sub    $0x18,%esp
  801972:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801975:	ba 00 00 00 00       	mov    $0x0,%edx
  80197a:	eb 13                	jmp    80198f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80197c:	39 08                	cmp    %ecx,(%eax)
  80197e:	75 0c                	jne    80198c <dev_lookup+0x20>
			*dev = devtab[i];
  801980:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801983:	89 01                	mov    %eax,(%ecx)
			return 0;
  801985:	b8 00 00 00 00       	mov    $0x0,%eax
  80198a:	eb 38                	jmp    8019c4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80198c:	83 c2 01             	add    $0x1,%edx
  80198f:	8b 04 95 14 38 80 00 	mov    0x803814(,%edx,4),%eax
  801996:	85 c0                	test   %eax,%eax
  801998:	75 e2                	jne    80197c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80199a:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80199f:	8b 40 48             	mov    0x48(%eax),%eax
  8019a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019aa:	c7 04 24 98 37 80 00 	movl   $0x803798,(%esp)
  8019b1:	e8 75 f0 ff ff       	call   800a2b <cprintf>
	*dev = 0;
  8019b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8019bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	56                   	push   %esi
  8019ca:	53                   	push   %ebx
  8019cb:	83 ec 20             	sub    $0x20,%esp
  8019ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8019d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8019d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8019e1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8019e4:	89 04 24             	mov    %eax,(%esp)
  8019e7:	e8 2a ff ff ff       	call   801916 <fd_lookup>
  8019ec:	85 c0                	test   %eax,%eax
  8019ee:	78 05                	js     8019f5 <fd_close+0x2f>
	    || fd != fd2)
  8019f0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8019f3:	74 0c                	je     801a01 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8019f5:	84 db                	test   %bl,%bl
  8019f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fc:	0f 44 c2             	cmove  %edx,%eax
  8019ff:	eb 3f                	jmp    801a40 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a01:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a08:	8b 06                	mov    (%esi),%eax
  801a0a:	89 04 24             	mov    %eax,(%esp)
  801a0d:	e8 5a ff ff ff       	call   80196c <dev_lookup>
  801a12:	89 c3                	mov    %eax,%ebx
  801a14:	85 c0                	test   %eax,%eax
  801a16:	78 16                	js     801a2e <fd_close+0x68>
		if (dev->dev_close)
  801a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801a1e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801a23:	85 c0                	test   %eax,%eax
  801a25:	74 07                	je     801a2e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801a27:	89 34 24             	mov    %esi,(%esp)
  801a2a:	ff d0                	call   *%eax
  801a2c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801a2e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a39:	e8 dc fa ff ff       	call   80151a <sys_page_unmap>
	return r;
  801a3e:	89 d8                	mov    %ebx,%eax
}
  801a40:	83 c4 20             	add    $0x20,%esp
  801a43:	5b                   	pop    %ebx
  801a44:	5e                   	pop    %esi
  801a45:	5d                   	pop    %ebp
  801a46:	c3                   	ret    

00801a47 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	89 04 24             	mov    %eax,(%esp)
  801a5a:	e8 b7 fe ff ff       	call   801916 <fd_lookup>
  801a5f:	89 c2                	mov    %eax,%edx
  801a61:	85 d2                	test   %edx,%edx
  801a63:	78 13                	js     801a78 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801a65:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801a6c:	00 
  801a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a70:	89 04 24             	mov    %eax,(%esp)
  801a73:	e8 4e ff ff ff       	call   8019c6 <fd_close>
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <close_all>:

void
close_all(void)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	53                   	push   %ebx
  801a7e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801a81:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a86:	89 1c 24             	mov    %ebx,(%esp)
  801a89:	e8 b9 ff ff ff       	call   801a47 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801a8e:	83 c3 01             	add    $0x1,%ebx
  801a91:	83 fb 20             	cmp    $0x20,%ebx
  801a94:	75 f0                	jne    801a86 <close_all+0xc>
		close(i);
}
  801a96:	83 c4 14             	add    $0x14,%esp
  801a99:	5b                   	pop    %ebx
  801a9a:	5d                   	pop    %ebp
  801a9b:	c3                   	ret    

00801a9c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	57                   	push   %edi
  801aa0:	56                   	push   %esi
  801aa1:	53                   	push   %ebx
  801aa2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801aa5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	89 04 24             	mov    %eax,(%esp)
  801ab2:	e8 5f fe ff ff       	call   801916 <fd_lookup>
  801ab7:	89 c2                	mov    %eax,%edx
  801ab9:	85 d2                	test   %edx,%edx
  801abb:	0f 88 e1 00 00 00    	js     801ba2 <dup+0x106>
		return r;
	close(newfdnum);
  801ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac4:	89 04 24             	mov    %eax,(%esp)
  801ac7:	e8 7b ff ff ff       	call   801a47 <close>

	newfd = INDEX2FD(newfdnum);
  801acc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801acf:	c1 e3 0c             	shl    $0xc,%ebx
  801ad2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801ad8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801adb:	89 04 24             	mov    %eax,(%esp)
  801ade:	e8 cd fd ff ff       	call   8018b0 <fd2data>
  801ae3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801ae5:	89 1c 24             	mov    %ebx,(%esp)
  801ae8:	e8 c3 fd ff ff       	call   8018b0 <fd2data>
  801aed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801aef:	89 f0                	mov    %esi,%eax
  801af1:	c1 e8 16             	shr    $0x16,%eax
  801af4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801afb:	a8 01                	test   $0x1,%al
  801afd:	74 43                	je     801b42 <dup+0xa6>
  801aff:	89 f0                	mov    %esi,%eax
  801b01:	c1 e8 0c             	shr    $0xc,%eax
  801b04:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b0b:	f6 c2 01             	test   $0x1,%dl
  801b0e:	74 32                	je     801b42 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801b10:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b17:	25 07 0e 00 00       	and    $0xe07,%eax
  801b1c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b20:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b24:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b2b:	00 
  801b2c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b37:	e8 8b f9 ff ff       	call   8014c7 <sys_page_map>
  801b3c:	89 c6                	mov    %eax,%esi
  801b3e:	85 c0                	test   %eax,%eax
  801b40:	78 3e                	js     801b80 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b45:	89 c2                	mov    %eax,%edx
  801b47:	c1 ea 0c             	shr    $0xc,%edx
  801b4a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b51:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801b57:	89 54 24 10          	mov    %edx,0x10(%esp)
  801b5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801b5f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b66:	00 
  801b67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b6b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b72:	e8 50 f9 ff ff       	call   8014c7 <sys_page_map>
  801b77:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801b79:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b7c:	85 f6                	test   %esi,%esi
  801b7e:	79 22                	jns    801ba2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801b80:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b8b:	e8 8a f9 ff ff       	call   80151a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b90:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b9b:	e8 7a f9 ff ff       	call   80151a <sys_page_unmap>
	return r;
  801ba0:	89 f0                	mov    %esi,%eax
}
  801ba2:	83 c4 3c             	add    $0x3c,%esp
  801ba5:	5b                   	pop    %ebx
  801ba6:	5e                   	pop    %esi
  801ba7:	5f                   	pop    %edi
  801ba8:	5d                   	pop    %ebp
  801ba9:	c3                   	ret    

00801baa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	53                   	push   %ebx
  801bae:	83 ec 24             	sub    $0x24,%esp
  801bb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bb4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbb:	89 1c 24             	mov    %ebx,(%esp)
  801bbe:	e8 53 fd ff ff       	call   801916 <fd_lookup>
  801bc3:	89 c2                	mov    %eax,%edx
  801bc5:	85 d2                	test   %edx,%edx
  801bc7:	78 6d                	js     801c36 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd3:	8b 00                	mov    (%eax),%eax
  801bd5:	89 04 24             	mov    %eax,(%esp)
  801bd8:	e8 8f fd ff ff       	call   80196c <dev_lookup>
  801bdd:	85 c0                	test   %eax,%eax
  801bdf:	78 55                	js     801c36 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be4:	8b 50 08             	mov    0x8(%eax),%edx
  801be7:	83 e2 03             	and    $0x3,%edx
  801bea:	83 fa 01             	cmp    $0x1,%edx
  801bed:	75 23                	jne    801c12 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801bef:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801bf4:	8b 40 48             	mov    0x48(%eax),%eax
  801bf7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bff:	c7 04 24 d9 37 80 00 	movl   $0x8037d9,(%esp)
  801c06:	e8 20 ee ff ff       	call   800a2b <cprintf>
		return -E_INVAL;
  801c0b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c10:	eb 24                	jmp    801c36 <read+0x8c>
	}
	if (!dev->dev_read)
  801c12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c15:	8b 52 08             	mov    0x8(%edx),%edx
  801c18:	85 d2                	test   %edx,%edx
  801c1a:	74 15                	je     801c31 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c1f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c2a:	89 04 24             	mov    %eax,(%esp)
  801c2d:	ff d2                	call   *%edx
  801c2f:	eb 05                	jmp    801c36 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801c31:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801c36:	83 c4 24             	add    $0x24,%esp
  801c39:	5b                   	pop    %ebx
  801c3a:	5d                   	pop    %ebp
  801c3b:	c3                   	ret    

00801c3c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	57                   	push   %edi
  801c40:	56                   	push   %esi
  801c41:	53                   	push   %ebx
  801c42:	83 ec 1c             	sub    $0x1c,%esp
  801c45:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c48:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c50:	eb 23                	jmp    801c75 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c52:	89 f0                	mov    %esi,%eax
  801c54:	29 d8                	sub    %ebx,%eax
  801c56:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c5a:	89 d8                	mov    %ebx,%eax
  801c5c:	03 45 0c             	add    0xc(%ebp),%eax
  801c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c63:	89 3c 24             	mov    %edi,(%esp)
  801c66:	e8 3f ff ff ff       	call   801baa <read>
		if (m < 0)
  801c6b:	85 c0                	test   %eax,%eax
  801c6d:	78 10                	js     801c7f <readn+0x43>
			return m;
		if (m == 0)
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	74 0a                	je     801c7d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c73:	01 c3                	add    %eax,%ebx
  801c75:	39 f3                	cmp    %esi,%ebx
  801c77:	72 d9                	jb     801c52 <readn+0x16>
  801c79:	89 d8                	mov    %ebx,%eax
  801c7b:	eb 02                	jmp    801c7f <readn+0x43>
  801c7d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801c7f:	83 c4 1c             	add    $0x1c,%esp
  801c82:	5b                   	pop    %ebx
  801c83:	5e                   	pop    %esi
  801c84:	5f                   	pop    %edi
  801c85:	5d                   	pop    %ebp
  801c86:	c3                   	ret    

00801c87 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	53                   	push   %ebx
  801c8b:	83 ec 24             	sub    $0x24,%esp
  801c8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c91:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c98:	89 1c 24             	mov    %ebx,(%esp)
  801c9b:	e8 76 fc ff ff       	call   801916 <fd_lookup>
  801ca0:	89 c2                	mov    %eax,%edx
  801ca2:	85 d2                	test   %edx,%edx
  801ca4:	78 68                	js     801d0e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ca6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb0:	8b 00                	mov    (%eax),%eax
  801cb2:	89 04 24             	mov    %eax,(%esp)
  801cb5:	e8 b2 fc ff ff       	call   80196c <dev_lookup>
  801cba:	85 c0                	test   %eax,%eax
  801cbc:	78 50                	js     801d0e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801cc5:	75 23                	jne    801cea <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801cc7:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801ccc:	8b 40 48             	mov    0x48(%eax),%eax
  801ccf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd7:	c7 04 24 f5 37 80 00 	movl   $0x8037f5,(%esp)
  801cde:	e8 48 ed ff ff       	call   800a2b <cprintf>
		return -E_INVAL;
  801ce3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ce8:	eb 24                	jmp    801d0e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801cea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ced:	8b 52 0c             	mov    0xc(%edx),%edx
  801cf0:	85 d2                	test   %edx,%edx
  801cf2:	74 15                	je     801d09 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801cf4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cfe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d02:	89 04 24             	mov    %eax,(%esp)
  801d05:	ff d2                	call   *%edx
  801d07:	eb 05                	jmp    801d0e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801d09:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801d0e:	83 c4 24             	add    $0x24,%esp
  801d11:	5b                   	pop    %ebx
  801d12:	5d                   	pop    %ebp
  801d13:	c3                   	ret    

00801d14 <seek>:

int
seek(int fdnum, off_t offset)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d1a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801d1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	89 04 24             	mov    %eax,(%esp)
  801d27:	e8 ea fb ff ff       	call   801916 <fd_lookup>
  801d2c:	85 c0                	test   %eax,%eax
  801d2e:	78 0e                	js     801d3e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801d30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d36:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	53                   	push   %ebx
  801d44:	83 ec 24             	sub    $0x24,%esp
  801d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d4a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d51:	89 1c 24             	mov    %ebx,(%esp)
  801d54:	e8 bd fb ff ff       	call   801916 <fd_lookup>
  801d59:	89 c2                	mov    %eax,%edx
  801d5b:	85 d2                	test   %edx,%edx
  801d5d:	78 61                	js     801dc0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d62:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d69:	8b 00                	mov    (%eax),%eax
  801d6b:	89 04 24             	mov    %eax,(%esp)
  801d6e:	e8 f9 fb ff ff       	call   80196c <dev_lookup>
  801d73:	85 c0                	test   %eax,%eax
  801d75:	78 49                	js     801dc0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d7e:	75 23                	jne    801da3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801d80:	a1 1c 50 80 00       	mov    0x80501c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d85:	8b 40 48             	mov    0x48(%eax),%eax
  801d88:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d90:	c7 04 24 b8 37 80 00 	movl   $0x8037b8,(%esp)
  801d97:	e8 8f ec ff ff       	call   800a2b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801d9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801da1:	eb 1d                	jmp    801dc0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801da3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da6:	8b 52 18             	mov    0x18(%edx),%edx
  801da9:	85 d2                	test   %edx,%edx
  801dab:	74 0e                	je     801dbb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801dad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801db4:	89 04 24             	mov    %eax,(%esp)
  801db7:	ff d2                	call   *%edx
  801db9:	eb 05                	jmp    801dc0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801dbb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801dc0:	83 c4 24             	add    $0x24,%esp
  801dc3:	5b                   	pop    %ebx
  801dc4:	5d                   	pop    %ebp
  801dc5:	c3                   	ret    

00801dc6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	53                   	push   %ebx
  801dca:	83 ec 24             	sub    $0x24,%esp
  801dcd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801dd0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dda:	89 04 24             	mov    %eax,(%esp)
  801ddd:	e8 34 fb ff ff       	call   801916 <fd_lookup>
  801de2:	89 c2                	mov    %eax,%edx
  801de4:	85 d2                	test   %edx,%edx
  801de6:	78 52                	js     801e3a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801de8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801deb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df2:	8b 00                	mov    (%eax),%eax
  801df4:	89 04 24             	mov    %eax,(%esp)
  801df7:	e8 70 fb ff ff       	call   80196c <dev_lookup>
  801dfc:	85 c0                	test   %eax,%eax
  801dfe:	78 3a                	js     801e3a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e03:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801e07:	74 2c                	je     801e35 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801e09:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801e0c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801e13:	00 00 00 
	stat->st_isdir = 0;
  801e16:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e1d:	00 00 00 
	stat->st_dev = dev;
  801e20:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e26:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e2d:	89 14 24             	mov    %edx,(%esp)
  801e30:	ff 50 14             	call   *0x14(%eax)
  801e33:	eb 05                	jmp    801e3a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801e35:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801e3a:	83 c4 24             	add    $0x24,%esp
  801e3d:	5b                   	pop    %ebx
  801e3e:	5d                   	pop    %ebp
  801e3f:	c3                   	ret    

00801e40 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	56                   	push   %esi
  801e44:	53                   	push   %ebx
  801e45:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e48:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e4f:	00 
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	89 04 24             	mov    %eax,(%esp)
  801e56:	e8 1b 02 00 00       	call   802076 <open>
  801e5b:	89 c3                	mov    %eax,%ebx
  801e5d:	85 db                	test   %ebx,%ebx
  801e5f:	78 1b                	js     801e7c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e68:	89 1c 24             	mov    %ebx,(%esp)
  801e6b:	e8 56 ff ff ff       	call   801dc6 <fstat>
  801e70:	89 c6                	mov    %eax,%esi
	close(fd);
  801e72:	89 1c 24             	mov    %ebx,(%esp)
  801e75:	e8 cd fb ff ff       	call   801a47 <close>
	return r;
  801e7a:	89 f0                	mov    %esi,%eax
}
  801e7c:	83 c4 10             	add    $0x10,%esp
  801e7f:	5b                   	pop    %ebx
  801e80:	5e                   	pop    %esi
  801e81:	5d                   	pop    %ebp
  801e82:	c3                   	ret    

00801e83 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	56                   	push   %esi
  801e87:	53                   	push   %ebx
  801e88:	83 ec 10             	sub    $0x10,%esp
  801e8b:	89 c6                	mov    %eax,%esi
  801e8d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801e8f:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801e96:	75 11                	jne    801ea9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801e9f:	e8 1b 10 00 00       	call   802ebf <ipc_find_env>
  801ea4:	a3 10 50 80 00       	mov    %eax,0x805010
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ea9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801eb0:	00 
  801eb1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801eb8:	00 
  801eb9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ebd:	a1 10 50 80 00       	mov    0x805010,%eax
  801ec2:	89 04 24             	mov    %eax,(%esp)
  801ec5:	e8 8a 0f 00 00       	call   802e54 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801eca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ed1:	00 
  801ed2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ed6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801edd:	e8 1e 0f 00 00       	call   802e00 <ipc_recv>
}
  801ee2:	83 c4 10             	add    $0x10,%esp
  801ee5:	5b                   	pop    %ebx
  801ee6:	5e                   	pop    %esi
  801ee7:	5d                   	pop    %ebp
  801ee8:	c3                   	ret    

00801ee9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801f02:	ba 00 00 00 00       	mov    $0x0,%edx
  801f07:	b8 02 00 00 00       	mov    $0x2,%eax
  801f0c:	e8 72 ff ff ff       	call   801e83 <fsipc>
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801f24:	ba 00 00 00 00       	mov    $0x0,%edx
  801f29:	b8 06 00 00 00       	mov    $0x6,%eax
  801f2e:	e8 50 ff ff ff       	call   801e83 <fsipc>
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	53                   	push   %ebx
  801f39:	83 ec 14             	sub    $0x14,%esp
  801f3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	8b 40 0c             	mov    0xc(%eax),%eax
  801f45:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4f:	b8 05 00 00 00       	mov    $0x5,%eax
  801f54:	e8 2a ff ff ff       	call   801e83 <fsipc>
  801f59:	89 c2                	mov    %eax,%edx
  801f5b:	85 d2                	test   %edx,%edx
  801f5d:	78 2b                	js     801f8a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f5f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f66:	00 
  801f67:	89 1c 24             	mov    %ebx,(%esp)
  801f6a:	e8 e8 f0 ff ff       	call   801057 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801f6f:	a1 80 60 80 00       	mov    0x806080,%eax
  801f74:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f7a:	a1 84 60 80 00       	mov    0x806084,%eax
  801f7f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801f85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8a:	83 c4 14             	add    $0x14,%esp
  801f8d:	5b                   	pop    %ebx
  801f8e:	5d                   	pop    %ebp
  801f8f:	c3                   	ret    

00801f90 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	83 ec 18             	sub    $0x18,%esp
  801f96:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f99:	8b 55 08             	mov    0x8(%ebp),%edx
  801f9c:	8b 52 0c             	mov    0xc(%edx),%edx
  801f9f:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801fa5:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801faa:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fb5:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801fbc:	e8 9b f2 ff ff       	call   80125c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801fc1:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc6:	b8 04 00 00 00       	mov    $0x4,%eax
  801fcb:	e8 b3 fe ff ff       	call   801e83 <fsipc>
		return r;
	}

	return r;
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	56                   	push   %esi
  801fd6:	53                   	push   %ebx
  801fd7:	83 ec 10             	sub    $0x10,%esp
  801fda:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801fe8:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801fee:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff3:	b8 03 00 00 00       	mov    $0x3,%eax
  801ff8:	e8 86 fe ff ff       	call   801e83 <fsipc>
  801ffd:	89 c3                	mov    %eax,%ebx
  801fff:	85 c0                	test   %eax,%eax
  802001:	78 6a                	js     80206d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  802003:	39 c6                	cmp    %eax,%esi
  802005:	73 24                	jae    80202b <devfile_read+0x59>
  802007:	c7 44 24 0c 28 38 80 	movl   $0x803828,0xc(%esp)
  80200e:	00 
  80200f:	c7 44 24 08 2f 38 80 	movl   $0x80382f,0x8(%esp)
  802016:	00 
  802017:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80201e:	00 
  80201f:	c7 04 24 44 38 80 00 	movl   $0x803844,(%esp)
  802026:	e8 07 e9 ff ff       	call   800932 <_panic>
	assert(r <= PGSIZE);
  80202b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802030:	7e 24                	jle    802056 <devfile_read+0x84>
  802032:	c7 44 24 0c 4f 38 80 	movl   $0x80384f,0xc(%esp)
  802039:	00 
  80203a:	c7 44 24 08 2f 38 80 	movl   $0x80382f,0x8(%esp)
  802041:	00 
  802042:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  802049:	00 
  80204a:	c7 04 24 44 38 80 00 	movl   $0x803844,(%esp)
  802051:	e8 dc e8 ff ff       	call   800932 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802056:	89 44 24 08          	mov    %eax,0x8(%esp)
  80205a:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802061:	00 
  802062:	8b 45 0c             	mov    0xc(%ebp),%eax
  802065:	89 04 24             	mov    %eax,(%esp)
  802068:	e8 87 f1 ff ff       	call   8011f4 <memmove>
	return r;
}
  80206d:	89 d8                	mov    %ebx,%eax
  80206f:	83 c4 10             	add    $0x10,%esp
  802072:	5b                   	pop    %ebx
  802073:	5e                   	pop    %esi
  802074:	5d                   	pop    %ebp
  802075:	c3                   	ret    

00802076 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	53                   	push   %ebx
  80207a:	83 ec 24             	sub    $0x24,%esp
  80207d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802080:	89 1c 24             	mov    %ebx,(%esp)
  802083:	e8 98 ef ff ff       	call   801020 <strlen>
  802088:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80208d:	7f 60                	jg     8020ef <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80208f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802092:	89 04 24             	mov    %eax,(%esp)
  802095:	e8 2d f8 ff ff       	call   8018c7 <fd_alloc>
  80209a:	89 c2                	mov    %eax,%edx
  80209c:	85 d2                	test   %edx,%edx
  80209e:	78 54                	js     8020f4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8020a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020a4:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  8020ab:	e8 a7 ef ff ff       	call   801057 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8020b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b3:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8020b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c0:	e8 be fd ff ff       	call   801e83 <fsipc>
  8020c5:	89 c3                	mov    %eax,%ebx
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	79 17                	jns    8020e2 <open+0x6c>
		fd_close(fd, 0);
  8020cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020d2:	00 
  8020d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d6:	89 04 24             	mov    %eax,(%esp)
  8020d9:	e8 e8 f8 ff ff       	call   8019c6 <fd_close>
		return r;
  8020de:	89 d8                	mov    %ebx,%eax
  8020e0:	eb 12                	jmp    8020f4 <open+0x7e>
	}

	return fd2num(fd);
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	89 04 24             	mov    %eax,(%esp)
  8020e8:	e8 b3 f7 ff ff       	call   8018a0 <fd2num>
  8020ed:	eb 05                	jmp    8020f4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8020ef:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8020f4:	83 c4 24             	add    $0x24,%esp
  8020f7:	5b                   	pop    %ebx
  8020f8:	5d                   	pop    %ebp
  8020f9:	c3                   	ret    

008020fa <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802100:	ba 00 00 00 00       	mov    $0x0,%edx
  802105:	b8 08 00 00 00       	mov    $0x8,%eax
  80210a:	e8 74 fd ff ff       	call   801e83 <fsipc>
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    
  802111:	66 90                	xchg   %ax,%ax
  802113:	66 90                	xchg   %ax,%ax
  802115:	66 90                	xchg   %ax,%ax
  802117:	66 90                	xchg   %ax,%ax
  802119:	66 90                	xchg   %ax,%ax
  80211b:	66 90                	xchg   %ax,%ax
  80211d:	66 90                	xchg   %ax,%ax
  80211f:	90                   	nop

00802120 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802126:	c7 44 24 04 5b 38 80 	movl   $0x80385b,0x4(%esp)
  80212d:	00 
  80212e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802131:	89 04 24             	mov    %eax,(%esp)
  802134:	e8 1e ef ff ff       	call   801057 <strcpy>
	return 0;
}
  802139:	b8 00 00 00 00       	mov    $0x0,%eax
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	53                   	push   %ebx
  802144:	83 ec 14             	sub    $0x14,%esp
  802147:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80214a:	89 1c 24             	mov    %ebx,(%esp)
  80214d:	e8 ac 0d 00 00       	call   802efe <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802152:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802157:	83 f8 01             	cmp    $0x1,%eax
  80215a:	75 0d                	jne    802169 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80215c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80215f:	89 04 24             	mov    %eax,(%esp)
  802162:	e8 29 03 00 00       	call   802490 <nsipc_close>
  802167:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802169:	89 d0                	mov    %edx,%eax
  80216b:	83 c4 14             	add    $0x14,%esp
  80216e:	5b                   	pop    %ebx
  80216f:	5d                   	pop    %ebp
  802170:	c3                   	ret    

00802171 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
  802174:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802177:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80217e:	00 
  80217f:	8b 45 10             	mov    0x10(%ebp),%eax
  802182:	89 44 24 08          	mov    %eax,0x8(%esp)
  802186:	8b 45 0c             	mov    0xc(%ebp),%eax
  802189:	89 44 24 04          	mov    %eax,0x4(%esp)
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	8b 40 0c             	mov    0xc(%eax),%eax
  802193:	89 04 24             	mov    %eax,(%esp)
  802196:	e8 f0 03 00 00       	call   80258b <nsipc_send>
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8021a3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8021aa:	00 
  8021ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8021bf:	89 04 24             	mov    %eax,(%esp)
  8021c2:	e8 44 03 00 00       	call   80250b <nsipc_recv>
}
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8021cf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021d2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021d6:	89 04 24             	mov    %eax,(%esp)
  8021d9:	e8 38 f7 ff ff       	call   801916 <fd_lookup>
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	78 17                	js     8021f9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8021e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e5:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  8021eb:	39 08                	cmp    %ecx,(%eax)
  8021ed:	75 05                	jne    8021f4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8021ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f2:	eb 05                	jmp    8021f9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8021f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	56                   	push   %esi
  8021ff:	53                   	push   %ebx
  802200:	83 ec 20             	sub    $0x20,%esp
  802203:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802205:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802208:	89 04 24             	mov    %eax,(%esp)
  80220b:	e8 b7 f6 ff ff       	call   8018c7 <fd_alloc>
  802210:	89 c3                	mov    %eax,%ebx
  802212:	85 c0                	test   %eax,%eax
  802214:	78 21                	js     802237 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802216:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80221d:	00 
  80221e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802221:	89 44 24 04          	mov    %eax,0x4(%esp)
  802225:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80222c:	e8 42 f2 ff ff       	call   801473 <sys_page_alloc>
  802231:	89 c3                	mov    %eax,%ebx
  802233:	85 c0                	test   %eax,%eax
  802235:	79 0c                	jns    802243 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802237:	89 34 24             	mov    %esi,(%esp)
  80223a:	e8 51 02 00 00       	call   802490 <nsipc_close>
		return r;
  80223f:	89 d8                	mov    %ebx,%eax
  802241:	eb 20                	jmp    802263 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802243:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80224e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802251:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802258:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80225b:	89 14 24             	mov    %edx,(%esp)
  80225e:	e8 3d f6 ff ff       	call   8018a0 <fd2num>
}
  802263:	83 c4 20             	add    $0x20,%esp
  802266:	5b                   	pop    %ebx
  802267:	5e                   	pop    %esi
  802268:	5d                   	pop    %ebp
  802269:	c3                   	ret    

0080226a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802270:	8b 45 08             	mov    0x8(%ebp),%eax
  802273:	e8 51 ff ff ff       	call   8021c9 <fd2sockid>
		return r;
  802278:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80227a:	85 c0                	test   %eax,%eax
  80227c:	78 23                	js     8022a1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80227e:	8b 55 10             	mov    0x10(%ebp),%edx
  802281:	89 54 24 08          	mov    %edx,0x8(%esp)
  802285:	8b 55 0c             	mov    0xc(%ebp),%edx
  802288:	89 54 24 04          	mov    %edx,0x4(%esp)
  80228c:	89 04 24             	mov    %eax,(%esp)
  80228f:	e8 45 01 00 00       	call   8023d9 <nsipc_accept>
		return r;
  802294:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802296:	85 c0                	test   %eax,%eax
  802298:	78 07                	js     8022a1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80229a:	e8 5c ff ff ff       	call   8021fb <alloc_sockfd>
  80229f:	89 c1                	mov    %eax,%ecx
}
  8022a1:	89 c8                	mov    %ecx,%eax
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	e8 16 ff ff ff       	call   8021c9 <fd2sockid>
  8022b3:	89 c2                	mov    %eax,%edx
  8022b5:	85 d2                	test   %edx,%edx
  8022b7:	78 16                	js     8022cf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8022b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8022bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c7:	89 14 24             	mov    %edx,(%esp)
  8022ca:	e8 60 01 00 00       	call   80242f <nsipc_bind>
}
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    

008022d1 <shutdown>:

int
shutdown(int s, int how)
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
  8022d4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	e8 ea fe ff ff       	call   8021c9 <fd2sockid>
  8022df:	89 c2                	mov    %eax,%edx
  8022e1:	85 d2                	test   %edx,%edx
  8022e3:	78 0f                	js     8022f4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8022e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ec:	89 14 24             	mov    %edx,(%esp)
  8022ef:	e8 7a 01 00 00       	call   80246e <nsipc_shutdown>
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	e8 c5 fe ff ff       	call   8021c9 <fd2sockid>
  802304:	89 c2                	mov    %eax,%edx
  802306:	85 d2                	test   %edx,%edx
  802308:	78 16                	js     802320 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80230a:	8b 45 10             	mov    0x10(%ebp),%eax
  80230d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802311:	8b 45 0c             	mov    0xc(%ebp),%eax
  802314:	89 44 24 04          	mov    %eax,0x4(%esp)
  802318:	89 14 24             	mov    %edx,(%esp)
  80231b:	e8 8a 01 00 00       	call   8024aa <nsipc_connect>
}
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <listen>:

int
listen(int s, int backlog)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	e8 99 fe ff ff       	call   8021c9 <fd2sockid>
  802330:	89 c2                	mov    %eax,%edx
  802332:	85 d2                	test   %edx,%edx
  802334:	78 0f                	js     802345 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802336:	8b 45 0c             	mov    0xc(%ebp),%eax
  802339:	89 44 24 04          	mov    %eax,0x4(%esp)
  80233d:	89 14 24             	mov    %edx,(%esp)
  802340:	e8 a4 01 00 00       	call   8024e9 <nsipc_listen>
}
  802345:	c9                   	leave  
  802346:	c3                   	ret    

00802347 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
  80234a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80234d:	8b 45 10             	mov    0x10(%ebp),%eax
  802350:	89 44 24 08          	mov    %eax,0x8(%esp)
  802354:	8b 45 0c             	mov    0xc(%ebp),%eax
  802357:	89 44 24 04          	mov    %eax,0x4(%esp)
  80235b:	8b 45 08             	mov    0x8(%ebp),%eax
  80235e:	89 04 24             	mov    %eax,(%esp)
  802361:	e8 98 02 00 00       	call   8025fe <nsipc_socket>
  802366:	89 c2                	mov    %eax,%edx
  802368:	85 d2                	test   %edx,%edx
  80236a:	78 05                	js     802371 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80236c:	e8 8a fe ff ff       	call   8021fb <alloc_sockfd>
}
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	53                   	push   %ebx
  802377:	83 ec 14             	sub    $0x14,%esp
  80237a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80237c:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  802383:	75 11                	jne    802396 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802385:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80238c:	e8 2e 0b 00 00       	call   802ebf <ipc_find_env>
  802391:	a3 14 50 80 00       	mov    %eax,0x805014
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802396:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80239d:	00 
  80239e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8023a5:	00 
  8023a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023aa:	a1 14 50 80 00       	mov    0x805014,%eax
  8023af:	89 04 24             	mov    %eax,(%esp)
  8023b2:	e8 9d 0a 00 00       	call   802e54 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8023b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023be:	00 
  8023bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023c6:	00 
  8023c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023ce:	e8 2d 0a 00 00       	call   802e00 <ipc_recv>
}
  8023d3:	83 c4 14             	add    $0x14,%esp
  8023d6:	5b                   	pop    %ebx
  8023d7:	5d                   	pop    %ebp
  8023d8:	c3                   	ret    

008023d9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
  8023dc:	56                   	push   %esi
  8023dd:	53                   	push   %ebx
  8023de:	83 ec 10             	sub    $0x10,%esp
  8023e1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8023ec:	8b 06                	mov    (%esi),%eax
  8023ee:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8023f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f8:	e8 76 ff ff ff       	call   802373 <nsipc>
  8023fd:	89 c3                	mov    %eax,%ebx
  8023ff:	85 c0                	test   %eax,%eax
  802401:	78 23                	js     802426 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802403:	a1 10 70 80 00       	mov    0x807010,%eax
  802408:	89 44 24 08          	mov    %eax,0x8(%esp)
  80240c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802413:	00 
  802414:	8b 45 0c             	mov    0xc(%ebp),%eax
  802417:	89 04 24             	mov    %eax,(%esp)
  80241a:	e8 d5 ed ff ff       	call   8011f4 <memmove>
		*addrlen = ret->ret_addrlen;
  80241f:	a1 10 70 80 00       	mov    0x807010,%eax
  802424:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802426:	89 d8                	mov    %ebx,%eax
  802428:	83 c4 10             	add    $0x10,%esp
  80242b:	5b                   	pop    %ebx
  80242c:	5e                   	pop    %esi
  80242d:	5d                   	pop    %ebp
  80242e:	c3                   	ret    

0080242f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
  802432:	53                   	push   %ebx
  802433:	83 ec 14             	sub    $0x14,%esp
  802436:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802441:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802445:	8b 45 0c             	mov    0xc(%ebp),%eax
  802448:	89 44 24 04          	mov    %eax,0x4(%esp)
  80244c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802453:	e8 9c ed ff ff       	call   8011f4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802458:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80245e:	b8 02 00 00 00       	mov    $0x2,%eax
  802463:	e8 0b ff ff ff       	call   802373 <nsipc>
}
  802468:	83 c4 14             	add    $0x14,%esp
  80246b:	5b                   	pop    %ebx
  80246c:	5d                   	pop    %ebp
  80246d:	c3                   	ret    

0080246e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80246e:	55                   	push   %ebp
  80246f:	89 e5                	mov    %esp,%ebp
  802471:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802474:	8b 45 08             	mov    0x8(%ebp),%eax
  802477:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80247c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802484:	b8 03 00 00 00       	mov    $0x3,%eax
  802489:	e8 e5 fe ff ff       	call   802373 <nsipc>
}
  80248e:	c9                   	leave  
  80248f:	c3                   	ret    

00802490 <nsipc_close>:

int
nsipc_close(int s)
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
  802493:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802496:	8b 45 08             	mov    0x8(%ebp),%eax
  802499:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80249e:	b8 04 00 00 00       	mov    $0x4,%eax
  8024a3:	e8 cb fe ff ff       	call   802373 <nsipc>
}
  8024a8:	c9                   	leave  
  8024a9:	c3                   	ret    

008024aa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	53                   	push   %ebx
  8024ae:	83 ec 14             	sub    $0x14,%esp
  8024b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8024b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8024bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8024ce:	e8 21 ed ff ff       	call   8011f4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8024d3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8024d9:	b8 05 00 00 00       	mov    $0x5,%eax
  8024de:	e8 90 fe ff ff       	call   802373 <nsipc>
}
  8024e3:	83 c4 14             	add    $0x14,%esp
  8024e6:	5b                   	pop    %ebx
  8024e7:	5d                   	pop    %ebp
  8024e8:	c3                   	ret    

008024e9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8024f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fa:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8024ff:	b8 06 00 00 00       	mov    $0x6,%eax
  802504:	e8 6a fe ff ff       	call   802373 <nsipc>
}
  802509:	c9                   	leave  
  80250a:	c3                   	ret    

0080250b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
  80250e:	56                   	push   %esi
  80250f:	53                   	push   %ebx
  802510:	83 ec 10             	sub    $0x10,%esp
  802513:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802516:	8b 45 08             	mov    0x8(%ebp),%eax
  802519:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80251e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802524:	8b 45 14             	mov    0x14(%ebp),%eax
  802527:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80252c:	b8 07 00 00 00       	mov    $0x7,%eax
  802531:	e8 3d fe ff ff       	call   802373 <nsipc>
  802536:	89 c3                	mov    %eax,%ebx
  802538:	85 c0                	test   %eax,%eax
  80253a:	78 46                	js     802582 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80253c:	39 f0                	cmp    %esi,%eax
  80253e:	7f 07                	jg     802547 <nsipc_recv+0x3c>
  802540:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802545:	7e 24                	jle    80256b <nsipc_recv+0x60>
  802547:	c7 44 24 0c 67 38 80 	movl   $0x803867,0xc(%esp)
  80254e:	00 
  80254f:	c7 44 24 08 2f 38 80 	movl   $0x80382f,0x8(%esp)
  802556:	00 
  802557:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80255e:	00 
  80255f:	c7 04 24 7c 38 80 00 	movl   $0x80387c,(%esp)
  802566:	e8 c7 e3 ff ff       	call   800932 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80256b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80256f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802576:	00 
  802577:	8b 45 0c             	mov    0xc(%ebp),%eax
  80257a:	89 04 24             	mov    %eax,(%esp)
  80257d:	e8 72 ec ff ff       	call   8011f4 <memmove>
	}

	return r;
}
  802582:	89 d8                	mov    %ebx,%eax
  802584:	83 c4 10             	add    $0x10,%esp
  802587:	5b                   	pop    %ebx
  802588:	5e                   	pop    %esi
  802589:	5d                   	pop    %ebp
  80258a:	c3                   	ret    

0080258b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80258b:	55                   	push   %ebp
  80258c:	89 e5                	mov    %esp,%ebp
  80258e:	53                   	push   %ebx
  80258f:	83 ec 14             	sub    $0x14,%esp
  802592:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80259d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8025a3:	7e 24                	jle    8025c9 <nsipc_send+0x3e>
  8025a5:	c7 44 24 0c 88 38 80 	movl   $0x803888,0xc(%esp)
  8025ac:	00 
  8025ad:	c7 44 24 08 2f 38 80 	movl   $0x80382f,0x8(%esp)
  8025b4:	00 
  8025b5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8025bc:	00 
  8025bd:	c7 04 24 7c 38 80 00 	movl   $0x80387c,(%esp)
  8025c4:	e8 69 e3 ff ff       	call   800932 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8025c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8025db:	e8 14 ec ff ff       	call   8011f4 <memmove>
	nsipcbuf.send.req_size = size;
  8025e0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8025e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8025e9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8025ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8025f3:	e8 7b fd ff ff       	call   802373 <nsipc>
}
  8025f8:	83 c4 14             	add    $0x14,%esp
  8025fb:	5b                   	pop    %ebx
  8025fc:	5d                   	pop    %ebp
  8025fd:	c3                   	ret    

008025fe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
  802601:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802604:	8b 45 08             	mov    0x8(%ebp),%eax
  802607:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80260c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80260f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802614:	8b 45 10             	mov    0x10(%ebp),%eax
  802617:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80261c:	b8 09 00 00 00       	mov    $0x9,%eax
  802621:	e8 4d fd ff ff       	call   802373 <nsipc>
}
  802626:	c9                   	leave  
  802627:	c3                   	ret    
  802628:	66 90                	xchg   %ax,%ax
  80262a:	66 90                	xchg   %ax,%ax
  80262c:	66 90                	xchg   %ax,%ax
  80262e:	66 90                	xchg   %ax,%ax

00802630 <free>:
	return v;
}

void
free(void *v)
{
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	53                   	push   %ebx
  802634:	83 ec 14             	sub    $0x14,%esp
  802637:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  80263a:	85 db                	test   %ebx,%ebx
  80263c:	0f 84 ba 00 00 00    	je     8026fc <free+0xcc>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  802642:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  802648:	76 08                	jbe    802652 <free+0x22>
  80264a:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  802650:	76 24                	jbe    802676 <free+0x46>
  802652:	c7 44 24 0c 94 38 80 	movl   $0x803894,0xc(%esp)
  802659:	00 
  80265a:	c7 44 24 08 2f 38 80 	movl   $0x80382f,0x8(%esp)
  802661:	00 
  802662:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  802669:	00 
  80266a:	c7 04 24 c2 38 80 00 	movl   $0x8038c2,(%esp)
  802671:	e8 bc e2 ff ff       	call   800932 <_panic>

	c = ROUNDDOWN(v, PGSIZE);
  802676:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  80267c:	eb 4a                	jmp    8026c8 <free+0x98>
		sys_page_unmap(0, c);
  80267e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802682:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802689:	e8 8c ee ff ff       	call   80151a <sys_page_unmap>
		c += PGSIZE;
  80268e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  802694:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  80269a:	76 08                	jbe    8026a4 <free+0x74>
  80269c:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  8026a2:	76 24                	jbe    8026c8 <free+0x98>
  8026a4:	c7 44 24 0c cf 38 80 	movl   $0x8038cf,0xc(%esp)
  8026ab:	00 
  8026ac:	c7 44 24 08 2f 38 80 	movl   $0x80382f,0x8(%esp)
  8026b3:	00 
  8026b4:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
  8026bb:	00 
  8026bc:	c7 04 24 c2 38 80 00 	movl   $0x8038c2,(%esp)
  8026c3:	e8 6a e2 ff ff       	call   800932 <_panic>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = ROUNDDOWN(v, PGSIZE);

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  8026c8:	89 d8                	mov    %ebx,%eax
  8026ca:	c1 e8 0c             	shr    $0xc,%eax
  8026cd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8026d4:	f6 c4 02             	test   $0x2,%ah
  8026d7:	75 a5                	jne    80267e <free+0x4e>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  8026d9:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  8026df:	83 e8 01             	sub    $0x1,%eax
  8026e2:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  8026e8:	85 c0                	test   %eax,%eax
  8026ea:	75 10                	jne    8026fc <free+0xcc>
		sys_page_unmap(0, c);
  8026ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026f7:	e8 1e ee ff ff       	call   80151a <sys_page_unmap>
}
  8026fc:	83 c4 14             	add    $0x14,%esp
  8026ff:	5b                   	pop    %ebx
  802700:	5d                   	pop    %ebp
  802701:	c3                   	ret    

00802702 <malloc>:
	return 1;
}

void*
malloc(size_t n)
{
  802702:	55                   	push   %ebp
  802703:	89 e5                	mov    %esp,%ebp
  802705:	57                   	push   %edi
  802706:	56                   	push   %esi
  802707:	53                   	push   %ebx
  802708:	83 ec 2c             	sub    $0x2c,%esp
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  80270b:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  802712:	75 0a                	jne    80271e <malloc+0x1c>
		mptr = mbegin;
  802714:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  80271b:	00 00 08 

	n = ROUNDUP(n, 4);
  80271e:	8b 45 08             	mov    0x8(%ebp),%eax
  802721:	83 c0 03             	add    $0x3,%eax
  802724:	83 e0 fc             	and    $0xfffffffc,%eax
  802727:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (n >= MAXMALLOC)
  80272a:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
  80272f:	0f 87 64 01 00 00    	ja     802899 <malloc+0x197>
		return 0;

	if ((uintptr_t) mptr % PGSIZE){
  802735:	a1 18 50 80 00       	mov    0x805018,%eax
  80273a:	a9 ff 0f 00 00       	test   $0xfff,%eax
  80273f:	75 15                	jne    802756 <malloc+0x54>
  802741:	8b 35 18 50 80 00    	mov    0x805018,%esi
	return 1;
}

void*
malloc(size_t n)
{
  802747:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
  80274e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802751:	8d 78 04             	lea    0x4(%eax),%edi
  802754:	eb 50                	jmp    8027a6 <malloc+0xa4>
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  802756:	89 c1                	mov    %eax,%ecx
  802758:	c1 e9 0c             	shr    $0xc,%ecx
  80275b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80275e:	8d 54 18 03          	lea    0x3(%eax,%ebx,1),%edx
  802762:	c1 ea 0c             	shr    $0xc,%edx
  802765:	39 d1                	cmp    %edx,%ecx
  802767:	75 1f                	jne    802788 <malloc+0x86>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  802769:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  80276f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
			(*ref)++;
  802775:	83 42 fc 01          	addl   $0x1,-0x4(%edx)
			v = mptr;
			mptr += n;
  802779:	89 da                	mov    %ebx,%edx
  80277b:	01 c2                	add    %eax,%edx
  80277d:	89 15 18 50 80 00    	mov    %edx,0x805018
			return v;
  802783:	e9 2f 01 00 00       	jmp    8028b7 <malloc+0x1b5>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  802788:	89 04 24             	mov    %eax,(%esp)
  80278b:	e8 a0 fe ff ff       	call   802630 <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  802790:	a1 18 50 80 00       	mov    0x805018,%eax
  802795:	05 00 10 00 00       	add    $0x1000,%eax
  80279a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80279f:	a3 18 50 80 00       	mov    %eax,0x805018
  8027a4:	eb 9b                	jmp    802741 <malloc+0x3f>
  8027a6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
  8027a9:	89 fb                	mov    %edi,%ebx
  8027ab:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8027ae:	89 f0                	mov    %esi,%eax
  8027b0:	eb 36                	jmp    8027e8 <malloc+0xe6>
		if (va >= (uintptr_t) mend
  8027b2:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  8027b7:	0f 87 e3 00 00 00    	ja     8028a0 <malloc+0x19e>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  8027bd:	89 c2                	mov    %eax,%edx
  8027bf:	c1 ea 16             	shr    $0x16,%edx
  8027c2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8027c9:	f6 c2 01             	test   $0x1,%dl
  8027cc:	74 15                	je     8027e3 <malloc+0xe1>
  8027ce:	89 c2                	mov    %eax,%edx
  8027d0:	c1 ea 0c             	shr    $0xc,%edx
  8027d3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8027da:	f6 c2 01             	test   $0x1,%dl
  8027dd:	0f 85 bd 00 00 00    	jne    8028a0 <malloc+0x19e>
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8027e3:	05 00 10 00 00       	add    $0x1000,%eax
  8027e8:	39 c1                	cmp    %eax,%ecx
  8027ea:	77 c6                	ja     8027b2 <malloc+0xb0>
  8027ec:	eb 7e                	jmp    80286c <malloc+0x16a>
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
			mptr = mbegin;
			if (++nwrap == 2)
  8027ee:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
  8027f2:	74 07                	je     8027fb <malloc+0xf9>
	while (1) {
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
			mptr = mbegin;
  8027f4:	be 00 00 00 08       	mov    $0x8000000,%esi
  8027f9:	eb ab                	jmp    8027a6 <malloc+0xa4>
  8027fb:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802802:	00 00 08 
			if (++nwrap == 2)
				return 0;	/* out of address space */
  802805:	b8 00 00 00 00       	mov    $0x0,%eax
  80280a:	e9 a8 00 00 00       	jmp    8028b7 <malloc+0x1b5>

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  80280f:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
  802815:	39 df                	cmp    %ebx,%edi
  802817:	19 c0                	sbb    %eax,%eax
  802819:	25 00 02 00 00       	and    $0x200,%eax
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  80281e:	83 c8 07             	or     $0x7,%eax
  802821:	89 44 24 08          	mov    %eax,0x8(%esp)
  802825:	03 15 18 50 80 00    	add    0x805018,%edx
  80282b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80282f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802836:	e8 38 ec ff ff       	call   801473 <sys_page_alloc>
  80283b:	85 c0                	test   %eax,%eax
  80283d:	78 22                	js     802861 <malloc+0x15f>
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  80283f:	89 fe                	mov    %edi,%esi
  802841:	eb 36                	jmp    802879 <malloc+0x177>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
				sys_page_unmap(0, mptr + i);
  802843:	89 f0                	mov    %esi,%eax
  802845:	03 05 18 50 80 00    	add    0x805018,%eax
  80284b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80284f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802856:	e8 bf ec ff ff       	call   80151a <sys_page_unmap>
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  80285b:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  802861:	85 f6                	test   %esi,%esi
  802863:	79 de                	jns    802843 <malloc+0x141>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
  802865:	b8 00 00 00 00       	mov    $0x0,%eax
  80286a:	eb 4b                	jmp    8028b7 <malloc+0x1b5>
  80286c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80286f:	a3 18 50 80 00       	mov    %eax,0x805018
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802874:	be 00 00 00 00       	mov    $0x0,%esi
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  802879:	89 f2                	mov    %esi,%edx
  80287b:	39 de                	cmp    %ebx,%esi
  80287d:	72 90                	jb     80280f <malloc+0x10d>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  80287f:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  802884:	c7 44 30 fc 02 00 00 	movl   $0x2,-0x4(%eax,%esi,1)
  80288b:	00 
	v = mptr;
	mptr += n;
  80288c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80288f:	01 c2                	add    %eax,%edx
  802891:	89 15 18 50 80 00    	mov    %edx,0x805018
	return v;
  802897:	eb 1e                	jmp    8028b7 <malloc+0x1b5>
		mptr = mbegin;

	n = ROUNDUP(n, 4);

	if (n >= MAXMALLOC)
		return 0;
  802899:	b8 00 00 00 00       	mov    $0x0,%eax
  80289e:	eb 17                	jmp    8028b7 <malloc+0x1b5>
  8028a0:	81 c6 00 10 00 00    	add    $0x1000,%esi
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
  8028a6:	81 fe 00 00 00 10    	cmp    $0x10000000,%esi
  8028ac:	0f 84 3c ff ff ff    	je     8027ee <malloc+0xec>
  8028b2:	e9 ef fe ff ff       	jmp    8027a6 <malloc+0xa4>
	ref = (uint32_t*) (mptr + i - 4);
	*ref = 2;	/* reference for mptr, reference for returned block */
	v = mptr;
	mptr += n;
	return v;
}
  8028b7:	83 c4 2c             	add    $0x2c,%esp
  8028ba:	5b                   	pop    %ebx
  8028bb:	5e                   	pop    %esi
  8028bc:	5f                   	pop    %edi
  8028bd:	5d                   	pop    %ebp
  8028be:	c3                   	ret    

008028bf <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8028bf:	55                   	push   %ebp
  8028c0:	89 e5                	mov    %esp,%ebp
  8028c2:	56                   	push   %esi
  8028c3:	53                   	push   %ebx
  8028c4:	83 ec 10             	sub    $0x10,%esp
  8028c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	89 04 24             	mov    %eax,(%esp)
  8028d0:	e8 db ef ff ff       	call   8018b0 <fd2data>
  8028d5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8028d7:	c7 44 24 04 e7 38 80 	movl   $0x8038e7,0x4(%esp)
  8028de:	00 
  8028df:	89 1c 24             	mov    %ebx,(%esp)
  8028e2:	e8 70 e7 ff ff       	call   801057 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8028e7:	8b 46 04             	mov    0x4(%esi),%eax
  8028ea:	2b 06                	sub    (%esi),%eax
  8028ec:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8028f2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8028f9:	00 00 00 
	stat->st_dev = &devpipe;
  8028fc:	c7 83 88 00 00 00 5c 	movl   $0x80405c,0x88(%ebx)
  802903:	40 80 00 
	return 0;
}
  802906:	b8 00 00 00 00       	mov    $0x0,%eax
  80290b:	83 c4 10             	add    $0x10,%esp
  80290e:	5b                   	pop    %ebx
  80290f:	5e                   	pop    %esi
  802910:	5d                   	pop    %ebp
  802911:	c3                   	ret    

00802912 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802912:	55                   	push   %ebp
  802913:	89 e5                	mov    %esp,%ebp
  802915:	53                   	push   %ebx
  802916:	83 ec 14             	sub    $0x14,%esp
  802919:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80291c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802920:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802927:	e8 ee eb ff ff       	call   80151a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80292c:	89 1c 24             	mov    %ebx,(%esp)
  80292f:	e8 7c ef ff ff       	call   8018b0 <fd2data>
  802934:	89 44 24 04          	mov    %eax,0x4(%esp)
  802938:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80293f:	e8 d6 eb ff ff       	call   80151a <sys_page_unmap>
}
  802944:	83 c4 14             	add    $0x14,%esp
  802947:	5b                   	pop    %ebx
  802948:	5d                   	pop    %ebp
  802949:	c3                   	ret    

0080294a <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80294a:	55                   	push   %ebp
  80294b:	89 e5                	mov    %esp,%ebp
  80294d:	57                   	push   %edi
  80294e:	56                   	push   %esi
  80294f:	53                   	push   %ebx
  802950:	83 ec 2c             	sub    $0x2c,%esp
  802953:	89 c6                	mov    %eax,%esi
  802955:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802958:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80295d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802960:	89 34 24             	mov    %esi,(%esp)
  802963:	e8 96 05 00 00       	call   802efe <pageref>
  802968:	89 c7                	mov    %eax,%edi
  80296a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80296d:	89 04 24             	mov    %eax,(%esp)
  802970:	e8 89 05 00 00       	call   802efe <pageref>
  802975:	39 c7                	cmp    %eax,%edi
  802977:	0f 94 c2             	sete   %dl
  80297a:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80297d:	8b 0d 1c 50 80 00    	mov    0x80501c,%ecx
  802983:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802986:	39 fb                	cmp    %edi,%ebx
  802988:	74 21                	je     8029ab <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80298a:	84 d2                	test   %dl,%dl
  80298c:	74 ca                	je     802958 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80298e:	8b 51 58             	mov    0x58(%ecx),%edx
  802991:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802995:	89 54 24 08          	mov    %edx,0x8(%esp)
  802999:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80299d:	c7 04 24 ee 38 80 00 	movl   $0x8038ee,(%esp)
  8029a4:	e8 82 e0 ff ff       	call   800a2b <cprintf>
  8029a9:	eb ad                	jmp    802958 <_pipeisclosed+0xe>
	}
}
  8029ab:	83 c4 2c             	add    $0x2c,%esp
  8029ae:	5b                   	pop    %ebx
  8029af:	5e                   	pop    %esi
  8029b0:	5f                   	pop    %edi
  8029b1:	5d                   	pop    %ebp
  8029b2:	c3                   	ret    

008029b3 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8029b3:	55                   	push   %ebp
  8029b4:	89 e5                	mov    %esp,%ebp
  8029b6:	57                   	push   %edi
  8029b7:	56                   	push   %esi
  8029b8:	53                   	push   %ebx
  8029b9:	83 ec 1c             	sub    $0x1c,%esp
  8029bc:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8029bf:	89 34 24             	mov    %esi,(%esp)
  8029c2:	e8 e9 ee ff ff       	call   8018b0 <fd2data>
  8029c7:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8029c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ce:	eb 45                	jmp    802a15 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8029d0:	89 da                	mov    %ebx,%edx
  8029d2:	89 f0                	mov    %esi,%eax
  8029d4:	e8 71 ff ff ff       	call   80294a <_pipeisclosed>
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	75 41                	jne    802a1e <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8029dd:	e8 72 ea ff ff       	call   801454 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8029e2:	8b 43 04             	mov    0x4(%ebx),%eax
  8029e5:	8b 0b                	mov    (%ebx),%ecx
  8029e7:	8d 51 20             	lea    0x20(%ecx),%edx
  8029ea:	39 d0                	cmp    %edx,%eax
  8029ec:	73 e2                	jae    8029d0 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8029ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029f1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8029f5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8029f8:	99                   	cltd   
  8029f9:	c1 ea 1b             	shr    $0x1b,%edx
  8029fc:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8029ff:	83 e1 1f             	and    $0x1f,%ecx
  802a02:	29 d1                	sub    %edx,%ecx
  802a04:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802a08:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802a0c:	83 c0 01             	add    $0x1,%eax
  802a0f:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a12:	83 c7 01             	add    $0x1,%edi
  802a15:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802a18:	75 c8                	jne    8029e2 <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802a1a:	89 f8                	mov    %edi,%eax
  802a1c:	eb 05                	jmp    802a23 <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802a1e:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802a23:	83 c4 1c             	add    $0x1c,%esp
  802a26:	5b                   	pop    %ebx
  802a27:	5e                   	pop    %esi
  802a28:	5f                   	pop    %edi
  802a29:	5d                   	pop    %ebp
  802a2a:	c3                   	ret    

00802a2b <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a2b:	55                   	push   %ebp
  802a2c:	89 e5                	mov    %esp,%ebp
  802a2e:	57                   	push   %edi
  802a2f:	56                   	push   %esi
  802a30:	53                   	push   %ebx
  802a31:	83 ec 1c             	sub    $0x1c,%esp
  802a34:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802a37:	89 3c 24             	mov    %edi,(%esp)
  802a3a:	e8 71 ee ff ff       	call   8018b0 <fd2data>
  802a3f:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a41:	be 00 00 00 00       	mov    $0x0,%esi
  802a46:	eb 3d                	jmp    802a85 <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802a48:	85 f6                	test   %esi,%esi
  802a4a:	74 04                	je     802a50 <devpipe_read+0x25>
				return i;
  802a4c:	89 f0                	mov    %esi,%eax
  802a4e:	eb 43                	jmp    802a93 <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802a50:	89 da                	mov    %ebx,%edx
  802a52:	89 f8                	mov    %edi,%eax
  802a54:	e8 f1 fe ff ff       	call   80294a <_pipeisclosed>
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	75 31                	jne    802a8e <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802a5d:	e8 f2 e9 ff ff       	call   801454 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802a62:	8b 03                	mov    (%ebx),%eax
  802a64:	3b 43 04             	cmp    0x4(%ebx),%eax
  802a67:	74 df                	je     802a48 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802a69:	99                   	cltd   
  802a6a:	c1 ea 1b             	shr    $0x1b,%edx
  802a6d:	01 d0                	add    %edx,%eax
  802a6f:	83 e0 1f             	and    $0x1f,%eax
  802a72:	29 d0                	sub    %edx,%eax
  802a74:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802a79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a7c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802a7f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a82:	83 c6 01             	add    $0x1,%esi
  802a85:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a88:	75 d8                	jne    802a62 <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802a8a:	89 f0                	mov    %esi,%eax
  802a8c:	eb 05                	jmp    802a93 <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802a8e:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802a93:	83 c4 1c             	add    $0x1c,%esp
  802a96:	5b                   	pop    %ebx
  802a97:	5e                   	pop    %esi
  802a98:	5f                   	pop    %edi
  802a99:	5d                   	pop    %ebp
  802a9a:	c3                   	ret    

00802a9b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802a9b:	55                   	push   %ebp
  802a9c:	89 e5                	mov    %esp,%ebp
  802a9e:	56                   	push   %esi
  802a9f:	53                   	push   %ebx
  802aa0:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802aa3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802aa6:	89 04 24             	mov    %eax,(%esp)
  802aa9:	e8 19 ee ff ff       	call   8018c7 <fd_alloc>
  802aae:	89 c2                	mov    %eax,%edx
  802ab0:	85 d2                	test   %edx,%edx
  802ab2:	0f 88 4d 01 00 00    	js     802c05 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ab8:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802abf:	00 
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ac7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ace:	e8 a0 e9 ff ff       	call   801473 <sys_page_alloc>
  802ad3:	89 c2                	mov    %eax,%edx
  802ad5:	85 d2                	test   %edx,%edx
  802ad7:	0f 88 28 01 00 00    	js     802c05 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802add:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802ae0:	89 04 24             	mov    %eax,(%esp)
  802ae3:	e8 df ed ff ff       	call   8018c7 <fd_alloc>
  802ae8:	89 c3                	mov    %eax,%ebx
  802aea:	85 c0                	test   %eax,%eax
  802aec:	0f 88 fe 00 00 00    	js     802bf0 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802af2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802af9:	00 
  802afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b01:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b08:	e8 66 e9 ff ff       	call   801473 <sys_page_alloc>
  802b0d:	89 c3                	mov    %eax,%ebx
  802b0f:	85 c0                	test   %eax,%eax
  802b11:	0f 88 d9 00 00 00    	js     802bf0 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	89 04 24             	mov    %eax,(%esp)
  802b1d:	e8 8e ed ff ff       	call   8018b0 <fd2data>
  802b22:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b24:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b2b:	00 
  802b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b37:	e8 37 e9 ff ff       	call   801473 <sys_page_alloc>
  802b3c:	89 c3                	mov    %eax,%ebx
  802b3e:	85 c0                	test   %eax,%eax
  802b40:	0f 88 97 00 00 00    	js     802bdd <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b49:	89 04 24             	mov    %eax,(%esp)
  802b4c:	e8 5f ed ff ff       	call   8018b0 <fd2data>
  802b51:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802b58:	00 
  802b59:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b5d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802b64:	00 
  802b65:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b70:	e8 52 e9 ff ff       	call   8014c7 <sys_page_map>
  802b75:	89 c3                	mov    %eax,%ebx
  802b77:	85 c0                	test   %eax,%eax
  802b79:	78 52                	js     802bcd <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802b7b:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b89:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802b90:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b99:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	89 04 24             	mov    %eax,(%esp)
  802bab:	e8 f0 ec ff ff       	call   8018a0 <fd2num>
  802bb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bb3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb8:	89 04 24             	mov    %eax,(%esp)
  802bbb:	e8 e0 ec ff ff       	call   8018a0 <fd2num>
  802bc0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bc3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  802bcb:	eb 38                	jmp    802c05 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802bcd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bd8:	e8 3d e9 ff ff       	call   80151a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802be4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802beb:	e8 2a e9 ff ff       	call   80151a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bf7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bfe:	e8 17 e9 ff ff       	call   80151a <sys_page_unmap>
  802c03:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802c05:	83 c4 30             	add    $0x30,%esp
  802c08:	5b                   	pop    %ebx
  802c09:	5e                   	pop    %esi
  802c0a:	5d                   	pop    %ebp
  802c0b:	c3                   	ret    

00802c0c <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802c0c:	55                   	push   %ebp
  802c0d:	89 e5                	mov    %esp,%ebp
  802c0f:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c12:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c15:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c19:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1c:	89 04 24             	mov    %eax,(%esp)
  802c1f:	e8 f2 ec ff ff       	call   801916 <fd_lookup>
  802c24:	89 c2                	mov    %eax,%edx
  802c26:	85 d2                	test   %edx,%edx
  802c28:	78 15                	js     802c3f <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	89 04 24             	mov    %eax,(%esp)
  802c30:	e8 7b ec ff ff       	call   8018b0 <fd2data>
	return _pipeisclosed(fd, p);
  802c35:	89 c2                	mov    %eax,%edx
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	e8 0b fd ff ff       	call   80294a <_pipeisclosed>
}
  802c3f:	c9                   	leave  
  802c40:	c3                   	ret    
  802c41:	66 90                	xchg   %ax,%ax
  802c43:	66 90                	xchg   %ax,%ax
  802c45:	66 90                	xchg   %ax,%ax
  802c47:	66 90                	xchg   %ax,%ax
  802c49:	66 90                	xchg   %ax,%ax
  802c4b:	66 90                	xchg   %ax,%ax
  802c4d:	66 90                	xchg   %ax,%ax
  802c4f:	90                   	nop

00802c50 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802c50:	55                   	push   %ebp
  802c51:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802c53:	b8 00 00 00 00       	mov    $0x0,%eax
  802c58:	5d                   	pop    %ebp
  802c59:	c3                   	ret    

00802c5a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802c5a:	55                   	push   %ebp
  802c5b:	89 e5                	mov    %esp,%ebp
  802c5d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802c60:	c7 44 24 04 06 39 80 	movl   $0x803906,0x4(%esp)
  802c67:	00 
  802c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c6b:	89 04 24             	mov    %eax,(%esp)
  802c6e:	e8 e4 e3 ff ff       	call   801057 <strcpy>
	return 0;
}
  802c73:	b8 00 00 00 00       	mov    $0x0,%eax
  802c78:	c9                   	leave  
  802c79:	c3                   	ret    

00802c7a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802c7a:	55                   	push   %ebp
  802c7b:	89 e5                	mov    %esp,%ebp
  802c7d:	57                   	push   %edi
  802c7e:	56                   	push   %esi
  802c7f:	53                   	push   %ebx
  802c80:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802c86:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802c8b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802c91:	eb 31                	jmp    802cc4 <devcons_write+0x4a>
		m = n - tot;
  802c93:	8b 75 10             	mov    0x10(%ebp),%esi
  802c96:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802c98:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802c9b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802ca0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802ca3:	89 74 24 08          	mov    %esi,0x8(%esp)
  802ca7:	03 45 0c             	add    0xc(%ebp),%eax
  802caa:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cae:	89 3c 24             	mov    %edi,(%esp)
  802cb1:	e8 3e e5 ff ff       	call   8011f4 <memmove>
		sys_cputs(buf, m);
  802cb6:	89 74 24 04          	mov    %esi,0x4(%esp)
  802cba:	89 3c 24             	mov    %edi,(%esp)
  802cbd:	e8 e4 e6 ff ff       	call   8013a6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802cc2:	01 f3                	add    %esi,%ebx
  802cc4:	89 d8                	mov    %ebx,%eax
  802cc6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802cc9:	72 c8                	jb     802c93 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802ccb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802cd1:	5b                   	pop    %ebx
  802cd2:	5e                   	pop    %esi
  802cd3:	5f                   	pop    %edi
  802cd4:	5d                   	pop    %ebp
  802cd5:	c3                   	ret    

00802cd6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802cd6:	55                   	push   %ebp
  802cd7:	89 e5                	mov    %esp,%ebp
  802cd9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802cdc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802ce1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802ce5:	75 07                	jne    802cee <devcons_read+0x18>
  802ce7:	eb 2a                	jmp    802d13 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802ce9:	e8 66 e7 ff ff       	call   801454 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802cee:	66 90                	xchg   %ax,%ax
  802cf0:	e8 cf e6 ff ff       	call   8013c4 <sys_cgetc>
  802cf5:	85 c0                	test   %eax,%eax
  802cf7:	74 f0                	je     802ce9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802cf9:	85 c0                	test   %eax,%eax
  802cfb:	78 16                	js     802d13 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802cfd:	83 f8 04             	cmp    $0x4,%eax
  802d00:	74 0c                	je     802d0e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802d02:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d05:	88 02                	mov    %al,(%edx)
	return 1;
  802d07:	b8 01 00 00 00       	mov    $0x1,%eax
  802d0c:	eb 05                	jmp    802d13 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802d0e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802d13:	c9                   	leave  
  802d14:	c3                   	ret    

00802d15 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802d15:	55                   	push   %ebp
  802d16:	89 e5                	mov    %esp,%ebp
  802d18:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802d21:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802d28:	00 
  802d29:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802d2c:	89 04 24             	mov    %eax,(%esp)
  802d2f:	e8 72 e6 ff ff       	call   8013a6 <sys_cputs>
}
  802d34:	c9                   	leave  
  802d35:	c3                   	ret    

00802d36 <getchar>:

int
getchar(void)
{
  802d36:	55                   	push   %ebp
  802d37:	89 e5                	mov    %esp,%ebp
  802d39:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802d3c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802d43:	00 
  802d44:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802d47:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d52:	e8 53 ee ff ff       	call   801baa <read>
	if (r < 0)
  802d57:	85 c0                	test   %eax,%eax
  802d59:	78 0f                	js     802d6a <getchar+0x34>
		return r;
	if (r < 1)
  802d5b:	85 c0                	test   %eax,%eax
  802d5d:	7e 06                	jle    802d65 <getchar+0x2f>
		return -E_EOF;
	return c;
  802d5f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802d63:	eb 05                	jmp    802d6a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802d65:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802d6a:	c9                   	leave  
  802d6b:	c3                   	ret    

00802d6c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802d6c:	55                   	push   %ebp
  802d6d:	89 e5                	mov    %esp,%ebp
  802d6f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d75:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	89 04 24             	mov    %eax,(%esp)
  802d7f:	e8 92 eb ff ff       	call   801916 <fd_lookup>
  802d84:	85 c0                	test   %eax,%eax
  802d86:	78 11                	js     802d99 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802d91:	39 10                	cmp    %edx,(%eax)
  802d93:	0f 94 c0             	sete   %al
  802d96:	0f b6 c0             	movzbl %al,%eax
}
  802d99:	c9                   	leave  
  802d9a:	c3                   	ret    

00802d9b <opencons>:

int
opencons(void)
{
  802d9b:	55                   	push   %ebp
  802d9c:	89 e5                	mov    %esp,%ebp
  802d9e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802da1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802da4:	89 04 24             	mov    %eax,(%esp)
  802da7:	e8 1b eb ff ff       	call   8018c7 <fd_alloc>
		return r;
  802dac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802dae:	85 c0                	test   %eax,%eax
  802db0:	78 40                	js     802df2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802db2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802db9:	00 
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dc1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dc8:	e8 a6 e6 ff ff       	call   801473 <sys_page_alloc>
		return r;
  802dcd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802dcf:	85 c0                	test   %eax,%eax
  802dd1:	78 1f                	js     802df2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802dd3:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802de8:	89 04 24             	mov    %eax,(%esp)
  802deb:	e8 b0 ea ff ff       	call   8018a0 <fd2num>
  802df0:	89 c2                	mov    %eax,%edx
}
  802df2:	89 d0                	mov    %edx,%eax
  802df4:	c9                   	leave  
  802df5:	c3                   	ret    
  802df6:	66 90                	xchg   %ax,%ax
  802df8:	66 90                	xchg   %ax,%ax
  802dfa:	66 90                	xchg   %ax,%ax
  802dfc:	66 90                	xchg   %ax,%ax
  802dfe:	66 90                	xchg   %ax,%ax

00802e00 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802e00:	55                   	push   %ebp
  802e01:	89 e5                	mov    %esp,%ebp
  802e03:	56                   	push   %esi
  802e04:	53                   	push   %ebx
  802e05:	83 ec 10             	sub    $0x10,%esp
  802e08:	8b 75 08             	mov    0x8(%ebp),%esi
  802e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802e11:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802e13:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802e18:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  802e1b:	89 04 24             	mov    %eax,(%esp)
  802e1e:	e8 66 e8 ff ff       	call   801689 <sys_ipc_recv>
  802e23:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802e25:	85 d2                	test   %edx,%edx
  802e27:	75 24                	jne    802e4d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802e29:	85 f6                	test   %esi,%esi
  802e2b:	74 0a                	je     802e37 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  802e2d:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802e32:	8b 40 74             	mov    0x74(%eax),%eax
  802e35:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802e37:	85 db                	test   %ebx,%ebx
  802e39:	74 0a                	je     802e45 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  802e3b:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802e40:	8b 40 78             	mov    0x78(%eax),%eax
  802e43:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802e45:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802e4a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  802e4d:	83 c4 10             	add    $0x10,%esp
  802e50:	5b                   	pop    %ebx
  802e51:	5e                   	pop    %esi
  802e52:	5d                   	pop    %ebp
  802e53:	c3                   	ret    

00802e54 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802e54:	55                   	push   %ebp
  802e55:	89 e5                	mov    %esp,%ebp
  802e57:	57                   	push   %edi
  802e58:	56                   	push   %esi
  802e59:	53                   	push   %ebx
  802e5a:	83 ec 1c             	sub    $0x1c,%esp
  802e5d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802e60:	8b 75 0c             	mov    0xc(%ebp),%esi
  802e63:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802e66:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802e68:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802e6d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802e70:	8b 45 14             	mov    0x14(%ebp),%eax
  802e73:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e7b:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e7f:	89 3c 24             	mov    %edi,(%esp)
  802e82:	e8 df e7 ff ff       	call   801666 <sys_ipc_try_send>

		if (ret == 0)
  802e87:	85 c0                	test   %eax,%eax
  802e89:	74 2c                	je     802eb7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  802e8b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802e8e:	74 20                	je     802eb0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802e90:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e94:	c7 44 24 08 14 39 80 	movl   $0x803914,0x8(%esp)
  802e9b:	00 
  802e9c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802ea3:	00 
  802ea4:	c7 04 24 44 39 80 00 	movl   $0x803944,(%esp)
  802eab:	e8 82 da ff ff       	call   800932 <_panic>
		}

		sys_yield();
  802eb0:	e8 9f e5 ff ff       	call   801454 <sys_yield>
	}
  802eb5:	eb b9                	jmp    802e70 <ipc_send+0x1c>
}
  802eb7:	83 c4 1c             	add    $0x1c,%esp
  802eba:	5b                   	pop    %ebx
  802ebb:	5e                   	pop    %esi
  802ebc:	5f                   	pop    %edi
  802ebd:	5d                   	pop    %ebp
  802ebe:	c3                   	ret    

00802ebf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802ebf:	55                   	push   %ebp
  802ec0:	89 e5                	mov    %esp,%ebp
  802ec2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802ec5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802eca:	89 c2                	mov    %eax,%edx
  802ecc:	c1 e2 07             	shl    $0x7,%edx
  802ecf:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802ed6:	8b 52 50             	mov    0x50(%edx),%edx
  802ed9:	39 ca                	cmp    %ecx,%edx
  802edb:	75 11                	jne    802eee <ipc_find_env+0x2f>
			return envs[i].env_id;
  802edd:	89 c2                	mov    %eax,%edx
  802edf:	c1 e2 07             	shl    $0x7,%edx
  802ee2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802ee9:	8b 40 40             	mov    0x40(%eax),%eax
  802eec:	eb 0e                	jmp    802efc <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802eee:	83 c0 01             	add    $0x1,%eax
  802ef1:	3d 00 04 00 00       	cmp    $0x400,%eax
  802ef6:	75 d2                	jne    802eca <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802ef8:	66 b8 00 00          	mov    $0x0,%ax
}
  802efc:	5d                   	pop    %ebp
  802efd:	c3                   	ret    

00802efe <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802efe:	55                   	push   %ebp
  802eff:	89 e5                	mov    %esp,%ebp
  802f01:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802f04:	89 d0                	mov    %edx,%eax
  802f06:	c1 e8 16             	shr    $0x16,%eax
  802f09:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802f10:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802f15:	f6 c1 01             	test   $0x1,%cl
  802f18:	74 1d                	je     802f37 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802f1a:	c1 ea 0c             	shr    $0xc,%edx
  802f1d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802f24:	f6 c2 01             	test   $0x1,%dl
  802f27:	74 0e                	je     802f37 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802f29:	c1 ea 0c             	shr    $0xc,%edx
  802f2c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802f33:	ef 
  802f34:	0f b7 c0             	movzwl %ax,%eax
}
  802f37:	5d                   	pop    %ebp
  802f38:	c3                   	ret    
  802f39:	66 90                	xchg   %ax,%ax
  802f3b:	66 90                	xchg   %ax,%ax
  802f3d:	66 90                	xchg   %ax,%ax
  802f3f:	90                   	nop

00802f40 <__udivdi3>:
  802f40:	55                   	push   %ebp
  802f41:	57                   	push   %edi
  802f42:	56                   	push   %esi
  802f43:	83 ec 0c             	sub    $0xc,%esp
  802f46:	8b 44 24 28          	mov    0x28(%esp),%eax
  802f4a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802f4e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802f52:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802f56:	85 c0                	test   %eax,%eax
  802f58:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802f5c:	89 ea                	mov    %ebp,%edx
  802f5e:	89 0c 24             	mov    %ecx,(%esp)
  802f61:	75 2d                	jne    802f90 <__udivdi3+0x50>
  802f63:	39 e9                	cmp    %ebp,%ecx
  802f65:	77 61                	ja     802fc8 <__udivdi3+0x88>
  802f67:	85 c9                	test   %ecx,%ecx
  802f69:	89 ce                	mov    %ecx,%esi
  802f6b:	75 0b                	jne    802f78 <__udivdi3+0x38>
  802f6d:	b8 01 00 00 00       	mov    $0x1,%eax
  802f72:	31 d2                	xor    %edx,%edx
  802f74:	f7 f1                	div    %ecx
  802f76:	89 c6                	mov    %eax,%esi
  802f78:	31 d2                	xor    %edx,%edx
  802f7a:	89 e8                	mov    %ebp,%eax
  802f7c:	f7 f6                	div    %esi
  802f7e:	89 c5                	mov    %eax,%ebp
  802f80:	89 f8                	mov    %edi,%eax
  802f82:	f7 f6                	div    %esi
  802f84:	89 ea                	mov    %ebp,%edx
  802f86:	83 c4 0c             	add    $0xc,%esp
  802f89:	5e                   	pop    %esi
  802f8a:	5f                   	pop    %edi
  802f8b:	5d                   	pop    %ebp
  802f8c:	c3                   	ret    
  802f8d:	8d 76 00             	lea    0x0(%esi),%esi
  802f90:	39 e8                	cmp    %ebp,%eax
  802f92:	77 24                	ja     802fb8 <__udivdi3+0x78>
  802f94:	0f bd e8             	bsr    %eax,%ebp
  802f97:	83 f5 1f             	xor    $0x1f,%ebp
  802f9a:	75 3c                	jne    802fd8 <__udivdi3+0x98>
  802f9c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802fa0:	39 34 24             	cmp    %esi,(%esp)
  802fa3:	0f 86 9f 00 00 00    	jbe    803048 <__udivdi3+0x108>
  802fa9:	39 d0                	cmp    %edx,%eax
  802fab:	0f 82 97 00 00 00    	jb     803048 <__udivdi3+0x108>
  802fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802fb8:	31 d2                	xor    %edx,%edx
  802fba:	31 c0                	xor    %eax,%eax
  802fbc:	83 c4 0c             	add    $0xc,%esp
  802fbf:	5e                   	pop    %esi
  802fc0:	5f                   	pop    %edi
  802fc1:	5d                   	pop    %ebp
  802fc2:	c3                   	ret    
  802fc3:	90                   	nop
  802fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802fc8:	89 f8                	mov    %edi,%eax
  802fca:	f7 f1                	div    %ecx
  802fcc:	31 d2                	xor    %edx,%edx
  802fce:	83 c4 0c             	add    $0xc,%esp
  802fd1:	5e                   	pop    %esi
  802fd2:	5f                   	pop    %edi
  802fd3:	5d                   	pop    %ebp
  802fd4:	c3                   	ret    
  802fd5:	8d 76 00             	lea    0x0(%esi),%esi
  802fd8:	89 e9                	mov    %ebp,%ecx
  802fda:	8b 3c 24             	mov    (%esp),%edi
  802fdd:	d3 e0                	shl    %cl,%eax
  802fdf:	89 c6                	mov    %eax,%esi
  802fe1:	b8 20 00 00 00       	mov    $0x20,%eax
  802fe6:	29 e8                	sub    %ebp,%eax
  802fe8:	89 c1                	mov    %eax,%ecx
  802fea:	d3 ef                	shr    %cl,%edi
  802fec:	89 e9                	mov    %ebp,%ecx
  802fee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802ff2:	8b 3c 24             	mov    (%esp),%edi
  802ff5:	09 74 24 08          	or     %esi,0x8(%esp)
  802ff9:	89 d6                	mov    %edx,%esi
  802ffb:	d3 e7                	shl    %cl,%edi
  802ffd:	89 c1                	mov    %eax,%ecx
  802fff:	89 3c 24             	mov    %edi,(%esp)
  803002:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803006:	d3 ee                	shr    %cl,%esi
  803008:	89 e9                	mov    %ebp,%ecx
  80300a:	d3 e2                	shl    %cl,%edx
  80300c:	89 c1                	mov    %eax,%ecx
  80300e:	d3 ef                	shr    %cl,%edi
  803010:	09 d7                	or     %edx,%edi
  803012:	89 f2                	mov    %esi,%edx
  803014:	89 f8                	mov    %edi,%eax
  803016:	f7 74 24 08          	divl   0x8(%esp)
  80301a:	89 d6                	mov    %edx,%esi
  80301c:	89 c7                	mov    %eax,%edi
  80301e:	f7 24 24             	mull   (%esp)
  803021:	39 d6                	cmp    %edx,%esi
  803023:	89 14 24             	mov    %edx,(%esp)
  803026:	72 30                	jb     803058 <__udivdi3+0x118>
  803028:	8b 54 24 04          	mov    0x4(%esp),%edx
  80302c:	89 e9                	mov    %ebp,%ecx
  80302e:	d3 e2                	shl    %cl,%edx
  803030:	39 c2                	cmp    %eax,%edx
  803032:	73 05                	jae    803039 <__udivdi3+0xf9>
  803034:	3b 34 24             	cmp    (%esp),%esi
  803037:	74 1f                	je     803058 <__udivdi3+0x118>
  803039:	89 f8                	mov    %edi,%eax
  80303b:	31 d2                	xor    %edx,%edx
  80303d:	e9 7a ff ff ff       	jmp    802fbc <__udivdi3+0x7c>
  803042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803048:	31 d2                	xor    %edx,%edx
  80304a:	b8 01 00 00 00       	mov    $0x1,%eax
  80304f:	e9 68 ff ff ff       	jmp    802fbc <__udivdi3+0x7c>
  803054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803058:	8d 47 ff             	lea    -0x1(%edi),%eax
  80305b:	31 d2                	xor    %edx,%edx
  80305d:	83 c4 0c             	add    $0xc,%esp
  803060:	5e                   	pop    %esi
  803061:	5f                   	pop    %edi
  803062:	5d                   	pop    %ebp
  803063:	c3                   	ret    
  803064:	66 90                	xchg   %ax,%ax
  803066:	66 90                	xchg   %ax,%ax
  803068:	66 90                	xchg   %ax,%ax
  80306a:	66 90                	xchg   %ax,%ax
  80306c:	66 90                	xchg   %ax,%ax
  80306e:	66 90                	xchg   %ax,%ax

00803070 <__umoddi3>:
  803070:	55                   	push   %ebp
  803071:	57                   	push   %edi
  803072:	56                   	push   %esi
  803073:	83 ec 14             	sub    $0x14,%esp
  803076:	8b 44 24 28          	mov    0x28(%esp),%eax
  80307a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80307e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803082:	89 c7                	mov    %eax,%edi
  803084:	89 44 24 04          	mov    %eax,0x4(%esp)
  803088:	8b 44 24 30          	mov    0x30(%esp),%eax
  80308c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803090:	89 34 24             	mov    %esi,(%esp)
  803093:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803097:	85 c0                	test   %eax,%eax
  803099:	89 c2                	mov    %eax,%edx
  80309b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80309f:	75 17                	jne    8030b8 <__umoddi3+0x48>
  8030a1:	39 fe                	cmp    %edi,%esi
  8030a3:	76 4b                	jbe    8030f0 <__umoddi3+0x80>
  8030a5:	89 c8                	mov    %ecx,%eax
  8030a7:	89 fa                	mov    %edi,%edx
  8030a9:	f7 f6                	div    %esi
  8030ab:	89 d0                	mov    %edx,%eax
  8030ad:	31 d2                	xor    %edx,%edx
  8030af:	83 c4 14             	add    $0x14,%esp
  8030b2:	5e                   	pop    %esi
  8030b3:	5f                   	pop    %edi
  8030b4:	5d                   	pop    %ebp
  8030b5:	c3                   	ret    
  8030b6:	66 90                	xchg   %ax,%ax
  8030b8:	39 f8                	cmp    %edi,%eax
  8030ba:	77 54                	ja     803110 <__umoddi3+0xa0>
  8030bc:	0f bd e8             	bsr    %eax,%ebp
  8030bf:	83 f5 1f             	xor    $0x1f,%ebp
  8030c2:	75 5c                	jne    803120 <__umoddi3+0xb0>
  8030c4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8030c8:	39 3c 24             	cmp    %edi,(%esp)
  8030cb:	0f 87 e7 00 00 00    	ja     8031b8 <__umoddi3+0x148>
  8030d1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8030d5:	29 f1                	sub    %esi,%ecx
  8030d7:	19 c7                	sbb    %eax,%edi
  8030d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030e1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030e5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8030e9:	83 c4 14             	add    $0x14,%esp
  8030ec:	5e                   	pop    %esi
  8030ed:	5f                   	pop    %edi
  8030ee:	5d                   	pop    %ebp
  8030ef:	c3                   	ret    
  8030f0:	85 f6                	test   %esi,%esi
  8030f2:	89 f5                	mov    %esi,%ebp
  8030f4:	75 0b                	jne    803101 <__umoddi3+0x91>
  8030f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8030fb:	31 d2                	xor    %edx,%edx
  8030fd:	f7 f6                	div    %esi
  8030ff:	89 c5                	mov    %eax,%ebp
  803101:	8b 44 24 04          	mov    0x4(%esp),%eax
  803105:	31 d2                	xor    %edx,%edx
  803107:	f7 f5                	div    %ebp
  803109:	89 c8                	mov    %ecx,%eax
  80310b:	f7 f5                	div    %ebp
  80310d:	eb 9c                	jmp    8030ab <__umoddi3+0x3b>
  80310f:	90                   	nop
  803110:	89 c8                	mov    %ecx,%eax
  803112:	89 fa                	mov    %edi,%edx
  803114:	83 c4 14             	add    $0x14,%esp
  803117:	5e                   	pop    %esi
  803118:	5f                   	pop    %edi
  803119:	5d                   	pop    %ebp
  80311a:	c3                   	ret    
  80311b:	90                   	nop
  80311c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803120:	8b 04 24             	mov    (%esp),%eax
  803123:	be 20 00 00 00       	mov    $0x20,%esi
  803128:	89 e9                	mov    %ebp,%ecx
  80312a:	29 ee                	sub    %ebp,%esi
  80312c:	d3 e2                	shl    %cl,%edx
  80312e:	89 f1                	mov    %esi,%ecx
  803130:	d3 e8                	shr    %cl,%eax
  803132:	89 e9                	mov    %ebp,%ecx
  803134:	89 44 24 04          	mov    %eax,0x4(%esp)
  803138:	8b 04 24             	mov    (%esp),%eax
  80313b:	09 54 24 04          	or     %edx,0x4(%esp)
  80313f:	89 fa                	mov    %edi,%edx
  803141:	d3 e0                	shl    %cl,%eax
  803143:	89 f1                	mov    %esi,%ecx
  803145:	89 44 24 08          	mov    %eax,0x8(%esp)
  803149:	8b 44 24 10          	mov    0x10(%esp),%eax
  80314d:	d3 ea                	shr    %cl,%edx
  80314f:	89 e9                	mov    %ebp,%ecx
  803151:	d3 e7                	shl    %cl,%edi
  803153:	89 f1                	mov    %esi,%ecx
  803155:	d3 e8                	shr    %cl,%eax
  803157:	89 e9                	mov    %ebp,%ecx
  803159:	09 f8                	or     %edi,%eax
  80315b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80315f:	f7 74 24 04          	divl   0x4(%esp)
  803163:	d3 e7                	shl    %cl,%edi
  803165:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803169:	89 d7                	mov    %edx,%edi
  80316b:	f7 64 24 08          	mull   0x8(%esp)
  80316f:	39 d7                	cmp    %edx,%edi
  803171:	89 c1                	mov    %eax,%ecx
  803173:	89 14 24             	mov    %edx,(%esp)
  803176:	72 2c                	jb     8031a4 <__umoddi3+0x134>
  803178:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80317c:	72 22                	jb     8031a0 <__umoddi3+0x130>
  80317e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803182:	29 c8                	sub    %ecx,%eax
  803184:	19 d7                	sbb    %edx,%edi
  803186:	89 e9                	mov    %ebp,%ecx
  803188:	89 fa                	mov    %edi,%edx
  80318a:	d3 e8                	shr    %cl,%eax
  80318c:	89 f1                	mov    %esi,%ecx
  80318e:	d3 e2                	shl    %cl,%edx
  803190:	89 e9                	mov    %ebp,%ecx
  803192:	d3 ef                	shr    %cl,%edi
  803194:	09 d0                	or     %edx,%eax
  803196:	89 fa                	mov    %edi,%edx
  803198:	83 c4 14             	add    $0x14,%esp
  80319b:	5e                   	pop    %esi
  80319c:	5f                   	pop    %edi
  80319d:	5d                   	pop    %ebp
  80319e:	c3                   	ret    
  80319f:	90                   	nop
  8031a0:	39 d7                	cmp    %edx,%edi
  8031a2:	75 da                	jne    80317e <__umoddi3+0x10e>
  8031a4:	8b 14 24             	mov    (%esp),%edx
  8031a7:	89 c1                	mov    %eax,%ecx
  8031a9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8031ad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8031b1:	eb cb                	jmp    80317e <__umoddi3+0x10e>
  8031b3:	90                   	nop
  8031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8031b8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8031bc:	0f 82 0f ff ff ff    	jb     8030d1 <__umoddi3+0x61>
  8031c2:	e9 1a ff ff ff       	jmp    8030e1 <__umoddi3+0x71>
