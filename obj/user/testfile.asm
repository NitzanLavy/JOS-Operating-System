
obj/user/testfile.debug:     file format elf32-i386


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
  80002c:	e8 52 07 00 00       	call   800783 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800040:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  800047:	e8 bb 0e 00 00       	call   800f07 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80004c:	89 1d 00 64 80 00    	mov    %ebx,0x806400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800052:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800059:	e8 b1 17 00 00       	call   80180f <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80005e:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800065:	00 
  800066:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80006d:	00 
  80006e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800075:	00 
  800076:	89 04 24             	mov    %eax,(%esp)
  800079:	e8 26 17 00 00       	call   8017a4 <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  80007e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800085:	00 
  800086:	c7 44 24 04 00 c0 cc 	movl   $0xccccc000,0x4(%esp)
  80008d:	cc 
  80008e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800095:	e8 b6 16 00 00       	call   801750 <ipc_recv>
}
  80009a:	83 c4 14             	add    $0x14,%esp
  80009d:	5b                   	pop    %ebx
  80009e:	5d                   	pop    %ebp
  80009f:	c3                   	ret    

008000a0 <umain>:

void
umain(int argc, char **argv)
{
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	57                   	push   %edi
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	81 ec cc 02 00 00    	sub    $0x2cc,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b1:	b8 e0 2d 80 00       	mov    $0x802de0,%eax
  8000b6:	e8 78 ff ff ff       	call   800033 <xopen>
  8000bb:	85 c0                	test   %eax,%eax
  8000bd:	79 25                	jns    8000e4 <umain+0x44>
  8000bf:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8000c2:	74 3c                	je     800100 <umain+0x60>
		panic("serve_open /not-found: %e", r);
  8000c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000c8:	c7 44 24 08 eb 2d 80 	movl   $0x802deb,0x8(%esp)
  8000cf:	00 
  8000d0:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  8000d7:	00 
  8000d8:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  8000df:	e8 04 07 00 00       	call   8007e8 <_panic>
	else if (r >= 0)
		panic("serve_open /not-found succeeded!");
  8000e4:	c7 44 24 08 a0 2f 80 	movl   $0x802fa0,0x8(%esp)
  8000eb:	00 
  8000ec:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8000f3:	00 
  8000f4:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  8000fb:	e8 e8 06 00 00       	call   8007e8 <_panic>

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800100:	ba 00 00 00 00       	mov    $0x0,%edx
  800105:	b8 15 2e 80 00       	mov    $0x802e15,%eax
  80010a:	e8 24 ff ff ff       	call   800033 <xopen>
  80010f:	85 c0                	test   %eax,%eax
  800111:	79 20                	jns    800133 <umain+0x93>
		panic("serve_open /newmotd: %e", r);
  800113:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800117:	c7 44 24 08 1e 2e 80 	movl   $0x802e1e,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800126:	00 
  800127:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  80012e:	e8 b5 06 00 00       	call   8007e8 <_panic>
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  800133:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  80013a:	75 12                	jne    80014e <umain+0xae>
  80013c:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  800143:	75 09                	jne    80014e <umain+0xae>
  800145:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  80014c:	74 1c                	je     80016a <umain+0xca>
		panic("serve_open did not fill struct Fd correctly\n");
  80014e:	c7 44 24 08 c4 2f 80 	movl   $0x802fc4,0x8(%esp)
  800155:	00 
  800156:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  80015d:	00 
  80015e:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  800165:	e8 7e 06 00 00       	call   8007e8 <_panic>
	cprintf("serve_open is good\n");
  80016a:	c7 04 24 36 2e 80 00 	movl   $0x802e36,(%esp)
  800171:	e8 6b 07 00 00       	call   8008e1 <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800176:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80017c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800180:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800187:	ff 15 1c 40 80 00    	call   *0x80401c
  80018d:	85 c0                	test   %eax,%eax
  80018f:	79 20                	jns    8001b1 <umain+0x111>
		panic("file_stat: %e", r);
  800191:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800195:	c7 44 24 08 4a 2e 80 	movl   $0x802e4a,0x8(%esp)
  80019c:	00 
  80019d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8001a4:	00 
  8001a5:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  8001ac:	e8 37 06 00 00       	call   8007e8 <_panic>
	if (strlen(msg) != st.st_size)
  8001b1:	a1 00 40 80 00       	mov    0x804000,%eax
  8001b6:	89 04 24             	mov    %eax,(%esp)
  8001b9:	e8 12 0d 00 00       	call   800ed0 <strlen>
  8001be:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c1:	74 34                	je     8001f7 <umain+0x157>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8001c3:	a1 00 40 80 00       	mov    0x804000,%eax
  8001c8:	89 04 24             	mov    %eax,(%esp)
  8001cb:	e8 00 0d 00 00       	call   800ed0 <strlen>
  8001d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001db:	c7 44 24 08 f4 2f 80 	movl   $0x802ff4,0x8(%esp)
  8001e2:	00 
  8001e3:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  8001ea:	00 
  8001eb:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  8001f2:	e8 f1 05 00 00       	call   8007e8 <_panic>
	cprintf("file_stat is good\n");
  8001f7:	c7 04 24 58 2e 80 00 	movl   $0x802e58,(%esp)
  8001fe:	e8 de 06 00 00       	call   8008e1 <cprintf>

	memset(buf, 0, sizeof buf);
  800203:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80020a:	00 
  80020b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800212:	00 
  800213:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800219:	89 1c 24             	mov    %ebx,(%esp)
  80021c:	e8 36 0e 00 00       	call   801057 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800221:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800228:	00 
  800229:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80022d:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800234:	ff 15 10 40 80 00    	call   *0x804010
  80023a:	85 c0                	test   %eax,%eax
  80023c:	79 20                	jns    80025e <umain+0x1be>
		panic("file_read: %e", r);
  80023e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800242:	c7 44 24 08 6b 2e 80 	movl   $0x802e6b,0x8(%esp)
  800249:	00 
  80024a:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  800251:	00 
  800252:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  800259:	e8 8a 05 00 00       	call   8007e8 <_panic>
	if (strcmp(buf, msg) != 0)
  80025e:	a1 00 40 80 00       	mov    0x804000,%eax
  800263:	89 44 24 04          	mov    %eax,0x4(%esp)
  800267:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  80026d:	89 04 24             	mov    %eax,(%esp)
  800270:	e8 47 0d 00 00       	call   800fbc <strcmp>
  800275:	85 c0                	test   %eax,%eax
  800277:	74 1c                	je     800295 <umain+0x1f5>
		panic("file_read returned wrong data");
  800279:	c7 44 24 08 79 2e 80 	movl   $0x802e79,0x8(%esp)
  800280:	00 
  800281:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  800288:	00 
  800289:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  800290:	e8 53 05 00 00       	call   8007e8 <_panic>
	cprintf("file_read is good\n");
  800295:	c7 04 24 97 2e 80 00 	movl   $0x802e97,(%esp)
  80029c:	e8 40 06 00 00       	call   8008e1 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8002a1:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8002a8:	ff 15 18 40 80 00    	call   *0x804018
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	79 20                	jns    8002d2 <umain+0x232>
		panic("file_close: %e", r);
  8002b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b6:	c7 44 24 08 aa 2e 80 	movl   $0x802eaa,0x8(%esp)
  8002bd:	00 
  8002be:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8002c5:	00 
  8002c6:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  8002cd:	e8 16 05 00 00       	call   8007e8 <_panic>
	cprintf("file_close is good\n");
  8002d2:	c7 04 24 b9 2e 80 00 	movl   $0x802eb9,(%esp)
  8002d9:	e8 03 06 00 00       	call   8008e1 <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8002de:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8002e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e6:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  8002eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002ee:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  8002f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f6:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  8002fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8002fe:	c7 44 24 04 00 c0 cc 	movl   $0xccccc000,0x4(%esp)
  800305:	cc 
  800306:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80030d:	e8 b8 10 00 00       	call   8013ca <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  800312:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800319:	00 
  80031a:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800320:	89 44 24 04          	mov    %eax,0x4(%esp)
  800324:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800327:	89 04 24             	mov    %eax,(%esp)
  80032a:	ff 15 10 40 80 00    	call   *0x804010
  800330:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800333:	74 20                	je     800355 <umain+0x2b5>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  800335:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800339:	c7 44 24 08 1c 30 80 	movl   $0x80301c,0x8(%esp)
  800340:	00 
  800341:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  800348:	00 
  800349:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  800350:	e8 93 04 00 00       	call   8007e8 <_panic>
	cprintf("stale fileid is good\n");
  800355:	c7 04 24 cd 2e 80 00 	movl   $0x802ecd,(%esp)
  80035c:	e8 80 05 00 00       	call   8008e1 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800361:	ba 02 01 00 00       	mov    $0x102,%edx
  800366:	b8 e3 2e 80 00       	mov    $0x802ee3,%eax
  80036b:	e8 c3 fc ff ff       	call   800033 <xopen>
  800370:	85 c0                	test   %eax,%eax
  800372:	79 20                	jns    800394 <umain+0x2f4>
		panic("serve_open /new-file: %e", r);
  800374:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800378:	c7 44 24 08 ed 2e 80 	movl   $0x802eed,0x8(%esp)
  80037f:	00 
  800380:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  800387:	00 
  800388:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  80038f:	e8 54 04 00 00       	call   8007e8 <_panic>

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800394:	8b 1d 14 40 80 00    	mov    0x804014,%ebx
  80039a:	a1 00 40 80 00       	mov    0x804000,%eax
  80039f:	89 04 24             	mov    %eax,(%esp)
  8003a2:	e8 29 0b 00 00       	call   800ed0 <strlen>
  8003a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ab:	a1 00 40 80 00       	mov    0x804000,%eax
  8003b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b4:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8003bb:	ff d3                	call   *%ebx
  8003bd:	89 c3                	mov    %eax,%ebx
  8003bf:	a1 00 40 80 00       	mov    0x804000,%eax
  8003c4:	89 04 24             	mov    %eax,(%esp)
  8003c7:	e8 04 0b 00 00       	call   800ed0 <strlen>
  8003cc:	39 c3                	cmp    %eax,%ebx
  8003ce:	74 20                	je     8003f0 <umain+0x350>
		panic("file_write: %e", r);
  8003d0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003d4:	c7 44 24 08 06 2f 80 	movl   $0x802f06,0x8(%esp)
  8003db:	00 
  8003dc:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
  8003e3:	00 
  8003e4:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  8003eb:	e8 f8 03 00 00       	call   8007e8 <_panic>
	cprintf("file_write is good\n");
  8003f0:	c7 04 24 15 2f 80 00 	movl   $0x802f15,(%esp)
  8003f7:	e8 e5 04 00 00       	call   8008e1 <cprintf>

	FVA->fd_offset = 0;
  8003fc:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800403:	00 00 00 
	memset(buf, 0, sizeof buf);
  800406:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80040d:	00 
  80040e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800415:	00 
  800416:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  80041c:	89 1c 24             	mov    %ebx,(%esp)
  80041f:	e8 33 0c 00 00       	call   801057 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800424:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80042b:	00 
  80042c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800430:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800437:	ff 15 10 40 80 00    	call   *0x804010
  80043d:	89 c3                	mov    %eax,%ebx
  80043f:	85 c0                	test   %eax,%eax
  800441:	79 20                	jns    800463 <umain+0x3c3>
		panic("file_read after file_write: %e", r);
  800443:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800447:	c7 44 24 08 54 30 80 	movl   $0x803054,0x8(%esp)
  80044e:	00 
  80044f:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
  800456:	00 
  800457:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  80045e:	e8 85 03 00 00       	call   8007e8 <_panic>
	if (r != strlen(msg))
  800463:	a1 00 40 80 00       	mov    0x804000,%eax
  800468:	89 04 24             	mov    %eax,(%esp)
  80046b:	e8 60 0a 00 00       	call   800ed0 <strlen>
  800470:	39 d8                	cmp    %ebx,%eax
  800472:	74 20                	je     800494 <umain+0x3f4>
		panic("file_read after file_write returned wrong length: %d", r);
  800474:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800478:	c7 44 24 08 74 30 80 	movl   $0x803074,0x8(%esp)
  80047f:	00 
  800480:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  800487:	00 
  800488:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  80048f:	e8 54 03 00 00       	call   8007e8 <_panic>
	if (strcmp(buf, msg) != 0)
  800494:	a1 00 40 80 00       	mov    0x804000,%eax
  800499:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049d:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8004a3:	89 04 24             	mov    %eax,(%esp)
  8004a6:	e8 11 0b 00 00       	call   800fbc <strcmp>
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	74 1c                	je     8004cb <umain+0x42b>
		panic("file_read after file_write returned wrong data");
  8004af:	c7 44 24 08 ac 30 80 	movl   $0x8030ac,0x8(%esp)
  8004b6:	00 
  8004b7:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  8004be:	00 
  8004bf:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  8004c6:	e8 1d 03 00 00       	call   8007e8 <_panic>
	cprintf("file_read after file_write is good\n");
  8004cb:	c7 04 24 dc 30 80 00 	movl   $0x8030dc,(%esp)
  8004d2:	e8 0a 04 00 00       	call   8008e1 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8004d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004de:	00 
  8004df:	c7 04 24 e0 2d 80 00 	movl   $0x802de0,(%esp)
  8004e6:	e8 3b 1b 00 00       	call   802026 <open>
  8004eb:	85 c0                	test   %eax,%eax
  8004ed:	79 25                	jns    800514 <umain+0x474>
  8004ef:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8004f2:	74 3c                	je     800530 <umain+0x490>
		panic("open /not-found: %e", r);
  8004f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004f8:	c7 44 24 08 f1 2d 80 	movl   $0x802df1,0x8(%esp)
  8004ff:	00 
  800500:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  800507:	00 
  800508:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  80050f:	e8 d4 02 00 00       	call   8007e8 <_panic>
	else if (r >= 0)
		panic("open /not-found succeeded!");
  800514:	c7 44 24 08 29 2f 80 	movl   $0x802f29,0x8(%esp)
  80051b:	00 
  80051c:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800523:	00 
  800524:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  80052b:	e8 b8 02 00 00       	call   8007e8 <_panic>

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  800530:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800537:	00 
  800538:	c7 04 24 15 2e 80 00 	movl   $0x802e15,(%esp)
  80053f:	e8 e2 1a 00 00       	call   802026 <open>
  800544:	85 c0                	test   %eax,%eax
  800546:	79 20                	jns    800568 <umain+0x4c8>
		panic("open /newmotd: %e", r);
  800548:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80054c:	c7 44 24 08 24 2e 80 	movl   $0x802e24,0x8(%esp)
  800553:	00 
  800554:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80055b:	00 
  80055c:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  800563:	e8 80 02 00 00       	call   8007e8 <_panic>
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800568:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80056b:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800572:	75 12                	jne    800586 <umain+0x4e6>
  800574:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  80057b:	75 09                	jne    800586 <umain+0x4e6>
  80057d:	83 b8 08 00 00 d0 00 	cmpl   $0x0,-0x2ffffff8(%eax)
  800584:	74 1c                	je     8005a2 <umain+0x502>
		panic("open did not fill struct Fd correctly\n");
  800586:	c7 44 24 08 00 31 80 	movl   $0x803100,0x8(%esp)
  80058d:	00 
  80058e:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  800595:	00 
  800596:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  80059d:	e8 46 02 00 00       	call   8007e8 <_panic>
	cprintf("open is good\n");
  8005a2:	c7 04 24 3c 2e 80 00 	movl   $0x802e3c,(%esp)
  8005a9:	e8 33 03 00 00       	call   8008e1 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  8005ae:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  8005b5:	00 
  8005b6:	c7 04 24 44 2f 80 00 	movl   $0x802f44,(%esp)
  8005bd:	e8 64 1a 00 00       	call   802026 <open>
  8005c2:	89 c6                	mov    %eax,%esi
  8005c4:	85 c0                	test   %eax,%eax
  8005c6:	79 20                	jns    8005e8 <umain+0x548>
		panic("creat /big: %e", f);
  8005c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005cc:	c7 44 24 08 49 2f 80 	movl   $0x802f49,0x8(%esp)
  8005d3:	00 
  8005d4:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  8005db:	00 
  8005dc:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  8005e3:	e8 00 02 00 00       	call   8007e8 <_panic>
	memset(buf, 0, sizeof(buf));
  8005e8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8005ef:	00 
  8005f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8005f7:	00 
  8005f8:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8005fe:	89 04 24             	mov    %eax,(%esp)
  800601:	e8 51 0a 00 00       	call   801057 <memset>
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800606:	bb 00 00 00 00       	mov    $0x0,%ebx
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
  80060b:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  800611:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800617:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80061e:	00 
  80061f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800623:	89 34 24             	mov    %esi,(%esp)
  800626:	e8 0c 16 00 00       	call   801c37 <write>
  80062b:	85 c0                	test   %eax,%eax
  80062d:	79 24                	jns    800653 <umain+0x5b3>
			panic("write /big@%d: %e", i, r);
  80062f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800633:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800637:	c7 44 24 08 58 2f 80 	movl   $0x802f58,0x8(%esp)
  80063e:	00 
  80063f:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  800646:	00 
  800647:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  80064e:	e8 95 01 00 00       	call   8007e8 <_panic>
  800653:	8d 83 00 02 00 00    	lea    0x200(%ebx),%eax
  800659:	89 c3                	mov    %eax,%ebx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  80065b:	3d 00 e0 01 00       	cmp    $0x1e000,%eax
  800660:	75 af                	jne    800611 <umain+0x571>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800662:	89 34 24             	mov    %esi,(%esp)
  800665:	e8 8d 13 00 00       	call   8019f7 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  80066a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800671:	00 
  800672:	c7 04 24 44 2f 80 00 	movl   $0x802f44,(%esp)
  800679:	e8 a8 19 00 00       	call   802026 <open>
  80067e:	89 c6                	mov    %eax,%esi
  800680:	85 c0                	test   %eax,%eax
  800682:	79 20                	jns    8006a4 <umain+0x604>
		panic("open /big: %e", f);
  800684:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800688:	c7 44 24 08 6a 2f 80 	movl   $0x802f6a,0x8(%esp)
  80068f:	00 
  800690:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  800697:	00 
  800698:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  80069f:	e8 44 01 00 00       	call   8007e8 <_panic>
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
  8006a4:	bb 00 00 00 00       	mov    $0x0,%ebx
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  8006a9:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  8006af:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  8006b5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8006bc:	00 
  8006bd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c1:	89 34 24             	mov    %esi,(%esp)
  8006c4:	e8 23 15 00 00       	call   801bec <readn>
  8006c9:	85 c0                	test   %eax,%eax
  8006cb:	79 24                	jns    8006f1 <umain+0x651>
			panic("read /big@%d: %e", i, r);
  8006cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006d5:	c7 44 24 08 78 2f 80 	movl   $0x802f78,0x8(%esp)
  8006dc:	00 
  8006dd:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  8006e4:	00 
  8006e5:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  8006ec:	e8 f7 00 00 00       	call   8007e8 <_panic>
		if (r != sizeof(buf))
  8006f1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8006f6:	74 2c                	je     800724 <umain+0x684>
			panic("read /big from %d returned %d < %d bytes",
  8006f8:	c7 44 24 14 00 02 00 	movl   $0x200,0x14(%esp)
  8006ff:	00 
  800700:	89 44 24 10          	mov    %eax,0x10(%esp)
  800704:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800708:	c7 44 24 08 28 31 80 	movl   $0x803128,0x8(%esp)
  80070f:	00 
  800710:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  800717:	00 
  800718:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  80071f:	e8 c4 00 00 00       	call   8007e8 <_panic>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800724:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  80072a:	39 d8                	cmp    %ebx,%eax
  80072c:	74 24                	je     800752 <umain+0x6b2>
			panic("read /big from %d returned bad data %d",
  80072e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800732:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800736:	c7 44 24 08 54 31 80 	movl   $0x803154,0x8(%esp)
  80073d:	00 
  80073e:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  800745:	00 
  800746:	c7 04 24 05 2e 80 00 	movl   $0x802e05,(%esp)
  80074d:	e8 96 00 00 00       	call   8007e8 <_panic>
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800752:	8d 98 00 02 00 00    	lea    0x200(%eax),%ebx
  800758:	81 fb ff df 01 00    	cmp    $0x1dfff,%ebx
  80075e:	0f 8e 4b ff ff ff    	jle    8006af <umain+0x60f>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800764:	89 34 24             	mov    %esi,(%esp)
  800767:	e8 8b 12 00 00       	call   8019f7 <close>
	cprintf("large file is good\n");
  80076c:	c7 04 24 89 2f 80 00 	movl   $0x802f89,(%esp)
  800773:	e8 69 01 00 00       	call   8008e1 <cprintf>
}
  800778:	81 c4 cc 02 00 00    	add    $0x2cc,%esp
  80077e:	5b                   	pop    %ebx
  80077f:	5e                   	pop    %esi
  800780:	5f                   	pop    %edi
  800781:	5d                   	pop    %ebp
  800782:	c3                   	ret    

00800783 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	56                   	push   %esi
  800787:	53                   	push   %ebx
  800788:	83 ec 10             	sub    $0x10,%esp
  80078b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80078e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800791:	e8 4f 0b 00 00       	call   8012e5 <sys_getenvid>
  800796:	25 ff 03 00 00       	and    $0x3ff,%eax
  80079b:	89 c2                	mov    %eax,%edx
  80079d:	c1 e2 07             	shl    $0x7,%edx
  8007a0:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8007a7:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007ac:	85 db                	test   %ebx,%ebx
  8007ae:	7e 07                	jle    8007b7 <libmain+0x34>
		binaryname = argv[0];
  8007b0:	8b 06                	mov    (%esi),%eax
  8007b2:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  8007b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007bb:	89 1c 24             	mov    %ebx,(%esp)
  8007be:	e8 dd f8 ff ff       	call   8000a0 <umain>

	// exit gracefully
	exit();
  8007c3:	e8 07 00 00 00       	call   8007cf <exit>
}
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	5b                   	pop    %ebx
  8007cc:	5e                   	pop    %esi
  8007cd:	5d                   	pop    %ebp
  8007ce:	c3                   	ret    

008007cf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
  8007d2:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8007d5:	e8 50 12 00 00       	call   801a2a <close_all>
	sys_env_destroy(0);
  8007da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007e1:	e8 ad 0a 00 00       	call   801293 <sys_env_destroy>
}
  8007e6:	c9                   	leave  
  8007e7:	c3                   	ret    

008007e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	56                   	push   %esi
  8007ec:	53                   	push   %ebx
  8007ed:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8007f0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007f3:	8b 35 04 40 80 00    	mov    0x804004,%esi
  8007f9:	e8 e7 0a 00 00       	call   8012e5 <sys_getenvid>
  8007fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800801:	89 54 24 10          	mov    %edx,0x10(%esp)
  800805:	8b 55 08             	mov    0x8(%ebp),%edx
  800808:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80080c:	89 74 24 08          	mov    %esi,0x8(%esp)
  800810:	89 44 24 04          	mov    %eax,0x4(%esp)
  800814:	c7 04 24 ac 31 80 00 	movl   $0x8031ac,(%esp)
  80081b:	e8 c1 00 00 00       	call   8008e1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800820:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800824:	8b 45 10             	mov    0x10(%ebp),%eax
  800827:	89 04 24             	mov    %eax,(%esp)
  80082a:	e8 51 00 00 00       	call   800880 <vcprintf>
	cprintf("\n");
  80082f:	c7 04 24 88 36 80 00 	movl   $0x803688,(%esp)
  800836:	e8 a6 00 00 00       	call   8008e1 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80083b:	cc                   	int3   
  80083c:	eb fd                	jmp    80083b <_panic+0x53>

0080083e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80083e:	55                   	push   %ebp
  80083f:	89 e5                	mov    %esp,%ebp
  800841:	53                   	push   %ebx
  800842:	83 ec 14             	sub    $0x14,%esp
  800845:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800848:	8b 13                	mov    (%ebx),%edx
  80084a:	8d 42 01             	lea    0x1(%edx),%eax
  80084d:	89 03                	mov    %eax,(%ebx)
  80084f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800852:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800856:	3d ff 00 00 00       	cmp    $0xff,%eax
  80085b:	75 19                	jne    800876 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80085d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800864:	00 
  800865:	8d 43 08             	lea    0x8(%ebx),%eax
  800868:	89 04 24             	mov    %eax,(%esp)
  80086b:	e8 e6 09 00 00       	call   801256 <sys_cputs>
		b->idx = 0;
  800870:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800876:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80087a:	83 c4 14             	add    $0x14,%esp
  80087d:	5b                   	pop    %ebx
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    

00800880 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800889:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800890:	00 00 00 
	b.cnt = 0;
  800893:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80089a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80089d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ab:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b5:	c7 04 24 3e 08 80 00 	movl   $0x80083e,(%esp)
  8008bc:	e8 ad 01 00 00       	call   800a6e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8008c1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008cb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8008d1:	89 04 24             	mov    %eax,(%esp)
  8008d4:	e8 7d 09 00 00       	call   801256 <sys_cputs>

	return b.cnt;
}
  8008d9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8008df:	c9                   	leave  
  8008e0:	c3                   	ret    

008008e1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8008e7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8008ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	89 04 24             	mov    %eax,(%esp)
  8008f4:	e8 87 ff ff ff       	call   800880 <vcprintf>
	va_end(ap);

	return cnt;
}
  8008f9:	c9                   	leave  
  8008fa:	c3                   	ret    
  8008fb:	66 90                	xchg   %ax,%ax
  8008fd:	66 90                	xchg   %ax,%ax
  8008ff:	90                   	nop

00800900 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	57                   	push   %edi
  800904:	56                   	push   %esi
  800905:	53                   	push   %ebx
  800906:	83 ec 3c             	sub    $0x3c,%esp
  800909:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80090c:	89 d7                	mov    %edx,%edi
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800914:	8b 45 0c             	mov    0xc(%ebp),%eax
  800917:	89 c3                	mov    %eax,%ebx
  800919:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80091c:	8b 45 10             	mov    0x10(%ebp),%eax
  80091f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800922:	b9 00 00 00 00       	mov    $0x0,%ecx
  800927:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80092d:	39 d9                	cmp    %ebx,%ecx
  80092f:	72 05                	jb     800936 <printnum+0x36>
  800931:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800934:	77 69                	ja     80099f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800936:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800939:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80093d:	83 ee 01             	sub    $0x1,%esi
  800940:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800944:	89 44 24 08          	mov    %eax,0x8(%esp)
  800948:	8b 44 24 08          	mov    0x8(%esp),%eax
  80094c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800950:	89 c3                	mov    %eax,%ebx
  800952:	89 d6                	mov    %edx,%esi
  800954:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800957:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80095a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80095e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800962:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800965:	89 04 24             	mov    %eax,(%esp)
  800968:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80096b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80096f:	e8 dc 21 00 00       	call   802b50 <__udivdi3>
  800974:	89 d9                	mov    %ebx,%ecx
  800976:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80097a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80097e:	89 04 24             	mov    %eax,(%esp)
  800981:	89 54 24 04          	mov    %edx,0x4(%esp)
  800985:	89 fa                	mov    %edi,%edx
  800987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80098a:	e8 71 ff ff ff       	call   800900 <printnum>
  80098f:	eb 1b                	jmp    8009ac <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800991:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800995:	8b 45 18             	mov    0x18(%ebp),%eax
  800998:	89 04 24             	mov    %eax,(%esp)
  80099b:	ff d3                	call   *%ebx
  80099d:	eb 03                	jmp    8009a2 <printnum+0xa2>
  80099f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009a2:	83 ee 01             	sub    $0x1,%esi
  8009a5:	85 f6                	test   %esi,%esi
  8009a7:	7f e8                	jg     800991 <printnum+0x91>
  8009a9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009b0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8009b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8009ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009be:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c5:	89 04 24             	mov    %eax,(%esp)
  8009c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009cf:	e8 ac 22 00 00       	call   802c80 <__umoddi3>
  8009d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009d8:	0f be 80 cf 31 80 00 	movsbl 0x8031cf(%eax),%eax
  8009df:	89 04 24             	mov    %eax,(%esp)
  8009e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
}
  8009e7:	83 c4 3c             	add    $0x3c,%esp
  8009ea:	5b                   	pop    %ebx
  8009eb:	5e                   	pop    %esi
  8009ec:	5f                   	pop    %edi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009f2:	83 fa 01             	cmp    $0x1,%edx
  8009f5:	7e 0e                	jle    800a05 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8009f7:	8b 10                	mov    (%eax),%edx
  8009f9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8009fc:	89 08                	mov    %ecx,(%eax)
  8009fe:	8b 02                	mov    (%edx),%eax
  800a00:	8b 52 04             	mov    0x4(%edx),%edx
  800a03:	eb 22                	jmp    800a27 <getuint+0x38>
	else if (lflag)
  800a05:	85 d2                	test   %edx,%edx
  800a07:	74 10                	je     800a19 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800a09:	8b 10                	mov    (%eax),%edx
  800a0b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800a0e:	89 08                	mov    %ecx,(%eax)
  800a10:	8b 02                	mov    (%edx),%eax
  800a12:	ba 00 00 00 00       	mov    $0x0,%edx
  800a17:	eb 0e                	jmp    800a27 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800a19:	8b 10                	mov    (%eax),%edx
  800a1b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800a1e:	89 08                	mov    %ecx,(%eax)
  800a20:	8b 02                	mov    (%edx),%eax
  800a22:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800a2f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800a33:	8b 10                	mov    (%eax),%edx
  800a35:	3b 50 04             	cmp    0x4(%eax),%edx
  800a38:	73 0a                	jae    800a44 <sprintputch+0x1b>
		*b->buf++ = ch;
  800a3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a3d:	89 08                	mov    %ecx,(%eax)
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	88 02                	mov    %al,(%edx)
}
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a4c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800a4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a53:	8b 45 10             	mov    0x10(%ebp),%eax
  800a56:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	89 04 24             	mov    %eax,(%esp)
  800a67:	e8 02 00 00 00       	call   800a6e <vprintfmt>
	va_end(ap);
}
  800a6c:	c9                   	leave  
  800a6d:	c3                   	ret    

00800a6e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	57                   	push   %edi
  800a72:	56                   	push   %esi
  800a73:	53                   	push   %ebx
  800a74:	83 ec 3c             	sub    $0x3c,%esp
  800a77:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800a7d:	eb 14                	jmp    800a93 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800a7f:	85 c0                	test   %eax,%eax
  800a81:	0f 84 b3 03 00 00    	je     800e3a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800a87:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a8b:	89 04 24             	mov    %eax,(%esp)
  800a8e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a91:	89 f3                	mov    %esi,%ebx
  800a93:	8d 73 01             	lea    0x1(%ebx),%esi
  800a96:	0f b6 03             	movzbl (%ebx),%eax
  800a99:	83 f8 25             	cmp    $0x25,%eax
  800a9c:	75 e1                	jne    800a7f <vprintfmt+0x11>
  800a9e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800aa2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800aa9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800ab0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800ab7:	ba 00 00 00 00       	mov    $0x0,%edx
  800abc:	eb 1d                	jmp    800adb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800abe:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800ac0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800ac4:	eb 15                	jmp    800adb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ac6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ac8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800acc:	eb 0d                	jmp    800adb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800ace:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ad1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800ad4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800adb:	8d 5e 01             	lea    0x1(%esi),%ebx
  800ade:	0f b6 0e             	movzbl (%esi),%ecx
  800ae1:	0f b6 c1             	movzbl %cl,%eax
  800ae4:	83 e9 23             	sub    $0x23,%ecx
  800ae7:	80 f9 55             	cmp    $0x55,%cl
  800aea:	0f 87 2a 03 00 00    	ja     800e1a <vprintfmt+0x3ac>
  800af0:	0f b6 c9             	movzbl %cl,%ecx
  800af3:	ff 24 8d 40 33 80 00 	jmp    *0x803340(,%ecx,4)
  800afa:	89 de                	mov    %ebx,%esi
  800afc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800b01:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800b04:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800b08:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800b0b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800b0e:	83 fb 09             	cmp    $0x9,%ebx
  800b11:	77 36                	ja     800b49 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b13:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b16:	eb e9                	jmp    800b01 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	8d 48 04             	lea    0x4(%eax),%ecx
  800b1e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b26:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800b28:	eb 22                	jmp    800b4c <vprintfmt+0xde>
  800b2a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800b2d:	85 c9                	test   %ecx,%ecx
  800b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b34:	0f 49 c1             	cmovns %ecx,%eax
  800b37:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b3a:	89 de                	mov    %ebx,%esi
  800b3c:	eb 9d                	jmp    800adb <vprintfmt+0x6d>
  800b3e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800b40:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800b47:	eb 92                	jmp    800adb <vprintfmt+0x6d>
  800b49:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  800b4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b50:	79 89                	jns    800adb <vprintfmt+0x6d>
  800b52:	e9 77 ff ff ff       	jmp    800ace <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b57:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b5a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800b5c:	e9 7a ff ff ff       	jmp    800adb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b61:	8b 45 14             	mov    0x14(%ebp),%eax
  800b64:	8d 50 04             	lea    0x4(%eax),%edx
  800b67:	89 55 14             	mov    %edx,0x14(%ebp)
  800b6a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	89 04 24             	mov    %eax,(%esp)
  800b73:	ff 55 08             	call   *0x8(%ebp)
			break;
  800b76:	e9 18 ff ff ff       	jmp    800a93 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7e:	8d 50 04             	lea    0x4(%eax),%edx
  800b81:	89 55 14             	mov    %edx,0x14(%ebp)
  800b84:	8b 00                	mov    (%eax),%eax
  800b86:	99                   	cltd   
  800b87:	31 d0                	xor    %edx,%eax
  800b89:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b8b:	83 f8 12             	cmp    $0x12,%eax
  800b8e:	7f 0b                	jg     800b9b <vprintfmt+0x12d>
  800b90:	8b 14 85 a0 34 80 00 	mov    0x8034a0(,%eax,4),%edx
  800b97:	85 d2                	test   %edx,%edx
  800b99:	75 20                	jne    800bbb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  800b9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b9f:	c7 44 24 08 e7 31 80 	movl   $0x8031e7,0x8(%esp)
  800ba6:	00 
  800ba7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	89 04 24             	mov    %eax,(%esp)
  800bb1:	e8 90 fe ff ff       	call   800a46 <printfmt>
  800bb6:	e9 d8 fe ff ff       	jmp    800a93 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800bbb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800bbf:	c7 44 24 08 1d 36 80 	movl   $0x80361d,0x8(%esp)
  800bc6:	00 
  800bc7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	89 04 24             	mov    %eax,(%esp)
  800bd1:	e8 70 fe ff ff       	call   800a46 <printfmt>
  800bd6:	e9 b8 fe ff ff       	jmp    800a93 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bdb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800bde:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800be1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800be4:	8b 45 14             	mov    0x14(%ebp),%eax
  800be7:	8d 50 04             	lea    0x4(%eax),%edx
  800bea:	89 55 14             	mov    %edx,0x14(%ebp)
  800bed:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800bef:	85 f6                	test   %esi,%esi
  800bf1:	b8 e0 31 80 00       	mov    $0x8031e0,%eax
  800bf6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800bf9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800bfd:	0f 84 97 00 00 00    	je     800c9a <vprintfmt+0x22c>
  800c03:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800c07:	0f 8e 9b 00 00 00    	jle    800ca8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c0d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800c11:	89 34 24             	mov    %esi,(%esp)
  800c14:	e8 cf 02 00 00       	call   800ee8 <strnlen>
  800c19:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800c1c:	29 c2                	sub    %eax,%edx
  800c1e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800c21:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800c25:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800c28:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800c2b:	8b 75 08             	mov    0x8(%ebp),%esi
  800c2e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c31:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c33:	eb 0f                	jmp    800c44 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800c35:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c3c:	89 04 24             	mov    %eax,(%esp)
  800c3f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c41:	83 eb 01             	sub    $0x1,%ebx
  800c44:	85 db                	test   %ebx,%ebx
  800c46:	7f ed                	jg     800c35 <vprintfmt+0x1c7>
  800c48:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800c4b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800c4e:	85 d2                	test   %edx,%edx
  800c50:	b8 00 00 00 00       	mov    $0x0,%eax
  800c55:	0f 49 c2             	cmovns %edx,%eax
  800c58:	29 c2                	sub    %eax,%edx
  800c5a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800c5d:	89 d7                	mov    %edx,%edi
  800c5f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800c62:	eb 50                	jmp    800cb4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800c64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c68:	74 1e                	je     800c88 <vprintfmt+0x21a>
  800c6a:	0f be d2             	movsbl %dl,%edx
  800c6d:	83 ea 20             	sub    $0x20,%edx
  800c70:	83 fa 5e             	cmp    $0x5e,%edx
  800c73:	76 13                	jbe    800c88 <vprintfmt+0x21a>
					putch('?', putdat);
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c7c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800c83:	ff 55 08             	call   *0x8(%ebp)
  800c86:	eb 0d                	jmp    800c95 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c8f:	89 04 24             	mov    %eax,(%esp)
  800c92:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c95:	83 ef 01             	sub    $0x1,%edi
  800c98:	eb 1a                	jmp    800cb4 <vprintfmt+0x246>
  800c9a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800c9d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800ca0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ca3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ca6:	eb 0c                	jmp    800cb4 <vprintfmt+0x246>
  800ca8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800cab:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800cae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cb1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800cb4:	83 c6 01             	add    $0x1,%esi
  800cb7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800cbb:	0f be c2             	movsbl %dl,%eax
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	74 27                	je     800ce9 <vprintfmt+0x27b>
  800cc2:	85 db                	test   %ebx,%ebx
  800cc4:	78 9e                	js     800c64 <vprintfmt+0x1f6>
  800cc6:	83 eb 01             	sub    $0x1,%ebx
  800cc9:	79 99                	jns    800c64 <vprintfmt+0x1f6>
  800ccb:	89 f8                	mov    %edi,%eax
  800ccd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800cd0:	8b 75 08             	mov    0x8(%ebp),%esi
  800cd3:	89 c3                	mov    %eax,%ebx
  800cd5:	eb 1a                	jmp    800cf1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800cd7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cdb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800ce2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ce4:	83 eb 01             	sub    $0x1,%ebx
  800ce7:	eb 08                	jmp    800cf1 <vprintfmt+0x283>
  800ce9:	89 fb                	mov    %edi,%ebx
  800ceb:	8b 75 08             	mov    0x8(%ebp),%esi
  800cee:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800cf1:	85 db                	test   %ebx,%ebx
  800cf3:	7f e2                	jg     800cd7 <vprintfmt+0x269>
  800cf5:	89 75 08             	mov    %esi,0x8(%ebp)
  800cf8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfb:	e9 93 fd ff ff       	jmp    800a93 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800d00:	83 fa 01             	cmp    $0x1,%edx
  800d03:	7e 16                	jle    800d1b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800d05:	8b 45 14             	mov    0x14(%ebp),%eax
  800d08:	8d 50 08             	lea    0x8(%eax),%edx
  800d0b:	89 55 14             	mov    %edx,0x14(%ebp)
  800d0e:	8b 50 04             	mov    0x4(%eax),%edx
  800d11:	8b 00                	mov    (%eax),%eax
  800d13:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d16:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800d19:	eb 32                	jmp    800d4d <vprintfmt+0x2df>
	else if (lflag)
  800d1b:	85 d2                	test   %edx,%edx
  800d1d:	74 18                	je     800d37 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800d1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d22:	8d 50 04             	lea    0x4(%eax),%edx
  800d25:	89 55 14             	mov    %edx,0x14(%ebp)
  800d28:	8b 30                	mov    (%eax),%esi
  800d2a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800d2d:	89 f0                	mov    %esi,%eax
  800d2f:	c1 f8 1f             	sar    $0x1f,%eax
  800d32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d35:	eb 16                	jmp    800d4d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800d37:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3a:	8d 50 04             	lea    0x4(%eax),%edx
  800d3d:	89 55 14             	mov    %edx,0x14(%ebp)
  800d40:	8b 30                	mov    (%eax),%esi
  800d42:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800d45:	89 f0                	mov    %esi,%eax
  800d47:	c1 f8 1f             	sar    $0x1f,%eax
  800d4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800d53:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800d58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d5c:	0f 89 80 00 00 00    	jns    800de2 <vprintfmt+0x374>
				putch('-', putdat);
  800d62:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d66:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800d6d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800d70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d76:	f7 d8                	neg    %eax
  800d78:	83 d2 00             	adc    $0x0,%edx
  800d7b:	f7 da                	neg    %edx
			}
			base = 10;
  800d7d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800d82:	eb 5e                	jmp    800de2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d84:	8d 45 14             	lea    0x14(%ebp),%eax
  800d87:	e8 63 fc ff ff       	call   8009ef <getuint>
			base = 10;
  800d8c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800d91:	eb 4f                	jmp    800de2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800d93:	8d 45 14             	lea    0x14(%ebp),%eax
  800d96:	e8 54 fc ff ff       	call   8009ef <getuint>
			base = 8;
  800d9b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800da0:	eb 40                	jmp    800de2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800da2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800da6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800dad:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800db0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800db4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800dbb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc1:	8d 50 04             	lea    0x4(%eax),%edx
  800dc4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dc7:	8b 00                	mov    (%eax),%eax
  800dc9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800dce:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800dd3:	eb 0d                	jmp    800de2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800dd5:	8d 45 14             	lea    0x14(%ebp),%eax
  800dd8:	e8 12 fc ff ff       	call   8009ef <getuint>
			base = 16;
  800ddd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800de2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800de6:	89 74 24 10          	mov    %esi,0x10(%esp)
  800dea:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800ded:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800df1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800df5:	89 04 24             	mov    %eax,(%esp)
  800df8:	89 54 24 04          	mov    %edx,0x4(%esp)
  800dfc:	89 fa                	mov    %edi,%edx
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	e8 fa fa ff ff       	call   800900 <printnum>
			break;
  800e06:	e9 88 fc ff ff       	jmp    800a93 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e0b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e0f:	89 04 24             	mov    %eax,(%esp)
  800e12:	ff 55 08             	call   *0x8(%ebp)
			break;
  800e15:	e9 79 fc ff ff       	jmp    800a93 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e1a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e1e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800e25:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e28:	89 f3                	mov    %esi,%ebx
  800e2a:	eb 03                	jmp    800e2f <vprintfmt+0x3c1>
  800e2c:	83 eb 01             	sub    $0x1,%ebx
  800e2f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800e33:	75 f7                	jne    800e2c <vprintfmt+0x3be>
  800e35:	e9 59 fc ff ff       	jmp    800a93 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800e3a:	83 c4 3c             	add    $0x3c,%esp
  800e3d:	5b                   	pop    %ebx
  800e3e:	5e                   	pop    %esi
  800e3f:	5f                   	pop    %edi
  800e40:	5d                   	pop    %ebp
  800e41:	c3                   	ret    

00800e42 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 28             	sub    $0x28,%esp
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e51:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e55:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	74 30                	je     800e93 <vsnprintf+0x51>
  800e63:	85 d2                	test   %edx,%edx
  800e65:	7e 2c                	jle    800e93 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e71:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e75:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e78:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e7c:	c7 04 24 29 0a 80 00 	movl   $0x800a29,(%esp)
  800e83:	e8 e6 fb ff ff       	call   800a6e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e8b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e91:	eb 05                	jmp    800e98 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800e93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800e98:	c9                   	leave  
  800e99:	c3                   	ret    

00800e9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ea0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ea3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ea7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaa:	89 44 24 08          	mov    %eax,0x8(%esp)
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	89 04 24             	mov    %eax,(%esp)
  800ebb:	e8 82 ff ff ff       	call   800e42 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    
  800ec2:	66 90                	xchg   %ax,%ax
  800ec4:	66 90                	xchg   %ax,%ax
  800ec6:	66 90                	xchg   %ax,%ax
  800ec8:	66 90                	xchg   %ax,%ax
  800eca:	66 90                	xchg   %ax,%ax
  800ecc:	66 90                	xchg   %ax,%ax
  800ece:	66 90                	xchg   %ax,%ax

00800ed0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  800edb:	eb 03                	jmp    800ee0 <strlen+0x10>
		n++;
  800edd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ee0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ee4:	75 f7                	jne    800edd <strlen+0xd>
		n++;
	return n;
}
  800ee6:	5d                   	pop    %ebp
  800ee7:	c3                   	ret    

00800ee8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eee:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef6:	eb 03                	jmp    800efb <strnlen+0x13>
		n++;
  800ef8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800efb:	39 d0                	cmp    %edx,%eax
  800efd:	74 06                	je     800f05 <strnlen+0x1d>
  800eff:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800f03:	75 f3                	jne    800ef8 <strnlen+0x10>
		n++;
	return n;
}
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    

00800f07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	53                   	push   %ebx
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800f11:	89 c2                	mov    %eax,%edx
  800f13:	83 c2 01             	add    $0x1,%edx
  800f16:	83 c1 01             	add    $0x1,%ecx
  800f19:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800f1d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800f20:	84 db                	test   %bl,%bl
  800f22:	75 ef                	jne    800f13 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800f24:	5b                   	pop    %ebx
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    

00800f27 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	53                   	push   %ebx
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800f31:	89 1c 24             	mov    %ebx,(%esp)
  800f34:	e8 97 ff ff ff       	call   800ed0 <strlen>
	strcpy(dst + len, src);
  800f39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f40:	01 d8                	add    %ebx,%eax
  800f42:	89 04 24             	mov    %eax,(%esp)
  800f45:	e8 bd ff ff ff       	call   800f07 <strcpy>
	return dst;
}
  800f4a:	89 d8                	mov    %ebx,%eax
  800f4c:	83 c4 08             	add    $0x8,%esp
  800f4f:	5b                   	pop    %ebx
  800f50:	5d                   	pop    %ebp
  800f51:	c3                   	ret    

00800f52 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	56                   	push   %esi
  800f56:	53                   	push   %ebx
  800f57:	8b 75 08             	mov    0x8(%ebp),%esi
  800f5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5d:	89 f3                	mov    %esi,%ebx
  800f5f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f62:	89 f2                	mov    %esi,%edx
  800f64:	eb 0f                	jmp    800f75 <strncpy+0x23>
		*dst++ = *src;
  800f66:	83 c2 01             	add    $0x1,%edx
  800f69:	0f b6 01             	movzbl (%ecx),%eax
  800f6c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800f6f:	80 39 01             	cmpb   $0x1,(%ecx)
  800f72:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f75:	39 da                	cmp    %ebx,%edx
  800f77:	75 ed                	jne    800f66 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800f79:	89 f0                	mov    %esi,%eax
  800f7b:	5b                   	pop    %ebx
  800f7c:	5e                   	pop    %esi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    

00800f7f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	56                   	push   %esi
  800f83:	53                   	push   %ebx
  800f84:	8b 75 08             	mov    0x8(%ebp),%esi
  800f87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800f8d:	89 f0                	mov    %esi,%eax
  800f8f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f93:	85 c9                	test   %ecx,%ecx
  800f95:	75 0b                	jne    800fa2 <strlcpy+0x23>
  800f97:	eb 1d                	jmp    800fb6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800f99:	83 c0 01             	add    $0x1,%eax
  800f9c:	83 c2 01             	add    $0x1,%edx
  800f9f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fa2:	39 d8                	cmp    %ebx,%eax
  800fa4:	74 0b                	je     800fb1 <strlcpy+0x32>
  800fa6:	0f b6 0a             	movzbl (%edx),%ecx
  800fa9:	84 c9                	test   %cl,%cl
  800fab:	75 ec                	jne    800f99 <strlcpy+0x1a>
  800fad:	89 c2                	mov    %eax,%edx
  800faf:	eb 02                	jmp    800fb3 <strlcpy+0x34>
  800fb1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800fb3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800fb6:	29 f0                	sub    %esi,%eax
}
  800fb8:	5b                   	pop    %ebx
  800fb9:	5e                   	pop    %esi
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    

00800fbc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fc2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800fc5:	eb 06                	jmp    800fcd <strcmp+0x11>
		p++, q++;
  800fc7:	83 c1 01             	add    $0x1,%ecx
  800fca:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fcd:	0f b6 01             	movzbl (%ecx),%eax
  800fd0:	84 c0                	test   %al,%al
  800fd2:	74 04                	je     800fd8 <strcmp+0x1c>
  800fd4:	3a 02                	cmp    (%edx),%al
  800fd6:	74 ef                	je     800fc7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fd8:	0f b6 c0             	movzbl %al,%eax
  800fdb:	0f b6 12             	movzbl (%edx),%edx
  800fde:	29 d0                	sub    %edx,%eax
}
  800fe0:	5d                   	pop    %ebp
  800fe1:	c3                   	ret    

00800fe2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	53                   	push   %ebx
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fec:	89 c3                	mov    %eax,%ebx
  800fee:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ff1:	eb 06                	jmp    800ff9 <strncmp+0x17>
		n--, p++, q++;
  800ff3:	83 c0 01             	add    $0x1,%eax
  800ff6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ff9:	39 d8                	cmp    %ebx,%eax
  800ffb:	74 15                	je     801012 <strncmp+0x30>
  800ffd:	0f b6 08             	movzbl (%eax),%ecx
  801000:	84 c9                	test   %cl,%cl
  801002:	74 04                	je     801008 <strncmp+0x26>
  801004:	3a 0a                	cmp    (%edx),%cl
  801006:	74 eb                	je     800ff3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801008:	0f b6 00             	movzbl (%eax),%eax
  80100b:	0f b6 12             	movzbl (%edx),%edx
  80100e:	29 d0                	sub    %edx,%eax
  801010:	eb 05                	jmp    801017 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801012:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801017:	5b                   	pop    %ebx
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801024:	eb 07                	jmp    80102d <strchr+0x13>
		if (*s == c)
  801026:	38 ca                	cmp    %cl,%dl
  801028:	74 0f                	je     801039 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80102a:	83 c0 01             	add    $0x1,%eax
  80102d:	0f b6 10             	movzbl (%eax),%edx
  801030:	84 d2                	test   %dl,%dl
  801032:	75 f2                	jne    801026 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801034:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    

0080103b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801045:	eb 07                	jmp    80104e <strfind+0x13>
		if (*s == c)
  801047:	38 ca                	cmp    %cl,%dl
  801049:	74 0a                	je     801055 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80104b:	83 c0 01             	add    $0x1,%eax
  80104e:	0f b6 10             	movzbl (%eax),%edx
  801051:	84 d2                	test   %dl,%dl
  801053:	75 f2                	jne    801047 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    

00801057 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	57                   	push   %edi
  80105b:	56                   	push   %esi
  80105c:	53                   	push   %ebx
  80105d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801060:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801063:	85 c9                	test   %ecx,%ecx
  801065:	74 36                	je     80109d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801067:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80106d:	75 28                	jne    801097 <memset+0x40>
  80106f:	f6 c1 03             	test   $0x3,%cl
  801072:	75 23                	jne    801097 <memset+0x40>
		c &= 0xFF;
  801074:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801078:	89 d3                	mov    %edx,%ebx
  80107a:	c1 e3 08             	shl    $0x8,%ebx
  80107d:	89 d6                	mov    %edx,%esi
  80107f:	c1 e6 18             	shl    $0x18,%esi
  801082:	89 d0                	mov    %edx,%eax
  801084:	c1 e0 10             	shl    $0x10,%eax
  801087:	09 f0                	or     %esi,%eax
  801089:	09 c2                	or     %eax,%edx
  80108b:	89 d0                	mov    %edx,%eax
  80108d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80108f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801092:	fc                   	cld    
  801093:	f3 ab                	rep stos %eax,%es:(%edi)
  801095:	eb 06                	jmp    80109d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109a:	fc                   	cld    
  80109b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80109d:	89 f8                	mov    %edi,%eax
  80109f:	5b                   	pop    %ebx
  8010a0:	5e                   	pop    %esi
  8010a1:	5f                   	pop    %edi
  8010a2:	5d                   	pop    %ebp
  8010a3:	c3                   	ret    

008010a4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	57                   	push   %edi
  8010a8:	56                   	push   %esi
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010af:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b2:	39 c6                	cmp    %eax,%esi
  8010b4:	73 35                	jae    8010eb <memmove+0x47>
  8010b6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8010b9:	39 d0                	cmp    %edx,%eax
  8010bb:	73 2e                	jae    8010eb <memmove+0x47>
		s += n;
		d += n;
  8010bd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8010c0:	89 d6                	mov    %edx,%esi
  8010c2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010c4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8010ca:	75 13                	jne    8010df <memmove+0x3b>
  8010cc:	f6 c1 03             	test   $0x3,%cl
  8010cf:	75 0e                	jne    8010df <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8010d1:	83 ef 04             	sub    $0x4,%edi
  8010d4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8010d7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8010da:	fd                   	std    
  8010db:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8010dd:	eb 09                	jmp    8010e8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8010df:	83 ef 01             	sub    $0x1,%edi
  8010e2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8010e5:	fd                   	std    
  8010e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8010e8:	fc                   	cld    
  8010e9:	eb 1d                	jmp    801108 <memmove+0x64>
  8010eb:	89 f2                	mov    %esi,%edx
  8010ed:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010ef:	f6 c2 03             	test   $0x3,%dl
  8010f2:	75 0f                	jne    801103 <memmove+0x5f>
  8010f4:	f6 c1 03             	test   $0x3,%cl
  8010f7:	75 0a                	jne    801103 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8010f9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8010fc:	89 c7                	mov    %eax,%edi
  8010fe:	fc                   	cld    
  8010ff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801101:	eb 05                	jmp    801108 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801103:	89 c7                	mov    %eax,%edi
  801105:	fc                   	cld    
  801106:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801108:	5e                   	pop    %esi
  801109:	5f                   	pop    %edi
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    

0080110c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801112:	8b 45 10             	mov    0x10(%ebp),%eax
  801115:	89 44 24 08          	mov    %eax,0x8(%esp)
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	89 04 24             	mov    %eax,(%esp)
  801126:	e8 79 ff ff ff       	call   8010a4 <memmove>
}
  80112b:	c9                   	leave  
  80112c:	c3                   	ret    

0080112d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	56                   	push   %esi
  801131:	53                   	push   %ebx
  801132:	8b 55 08             	mov    0x8(%ebp),%edx
  801135:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801138:	89 d6                	mov    %edx,%esi
  80113a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80113d:	eb 1a                	jmp    801159 <memcmp+0x2c>
		if (*s1 != *s2)
  80113f:	0f b6 02             	movzbl (%edx),%eax
  801142:	0f b6 19             	movzbl (%ecx),%ebx
  801145:	38 d8                	cmp    %bl,%al
  801147:	74 0a                	je     801153 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801149:	0f b6 c0             	movzbl %al,%eax
  80114c:	0f b6 db             	movzbl %bl,%ebx
  80114f:	29 d8                	sub    %ebx,%eax
  801151:	eb 0f                	jmp    801162 <memcmp+0x35>
		s1++, s2++;
  801153:	83 c2 01             	add    $0x1,%edx
  801156:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801159:	39 f2                	cmp    %esi,%edx
  80115b:	75 e2                	jne    80113f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80115d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801162:	5b                   	pop    %ebx
  801163:	5e                   	pop    %esi
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    

00801166 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80116f:	89 c2                	mov    %eax,%edx
  801171:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801174:	eb 07                	jmp    80117d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  801176:	38 08                	cmp    %cl,(%eax)
  801178:	74 07                	je     801181 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80117a:	83 c0 01             	add    $0x1,%eax
  80117d:	39 d0                	cmp    %edx,%eax
  80117f:	72 f5                	jb     801176 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801181:	5d                   	pop    %ebp
  801182:	c3                   	ret    

00801183 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	57                   	push   %edi
  801187:	56                   	push   %esi
  801188:	53                   	push   %ebx
  801189:	8b 55 08             	mov    0x8(%ebp),%edx
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80118f:	eb 03                	jmp    801194 <strtol+0x11>
		s++;
  801191:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801194:	0f b6 0a             	movzbl (%edx),%ecx
  801197:	80 f9 09             	cmp    $0x9,%cl
  80119a:	74 f5                	je     801191 <strtol+0xe>
  80119c:	80 f9 20             	cmp    $0x20,%cl
  80119f:	74 f0                	je     801191 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011a1:	80 f9 2b             	cmp    $0x2b,%cl
  8011a4:	75 0a                	jne    8011b0 <strtol+0x2d>
		s++;
  8011a6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8011a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8011ae:	eb 11                	jmp    8011c1 <strtol+0x3e>
  8011b0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8011b5:	80 f9 2d             	cmp    $0x2d,%cl
  8011b8:	75 07                	jne    8011c1 <strtol+0x3e>
		s++, neg = 1;
  8011ba:	8d 52 01             	lea    0x1(%edx),%edx
  8011bd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011c1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8011c6:	75 15                	jne    8011dd <strtol+0x5a>
  8011c8:	80 3a 30             	cmpb   $0x30,(%edx)
  8011cb:	75 10                	jne    8011dd <strtol+0x5a>
  8011cd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8011d1:	75 0a                	jne    8011dd <strtol+0x5a>
		s += 2, base = 16;
  8011d3:	83 c2 02             	add    $0x2,%edx
  8011d6:	b8 10 00 00 00       	mov    $0x10,%eax
  8011db:	eb 10                	jmp    8011ed <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	75 0c                	jne    8011ed <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8011e1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8011e3:	80 3a 30             	cmpb   $0x30,(%edx)
  8011e6:	75 05                	jne    8011ed <strtol+0x6a>
		s++, base = 8;
  8011e8:	83 c2 01             	add    $0x1,%edx
  8011eb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8011ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011f5:	0f b6 0a             	movzbl (%edx),%ecx
  8011f8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8011fb:	89 f0                	mov    %esi,%eax
  8011fd:	3c 09                	cmp    $0x9,%al
  8011ff:	77 08                	ja     801209 <strtol+0x86>
			dig = *s - '0';
  801201:	0f be c9             	movsbl %cl,%ecx
  801204:	83 e9 30             	sub    $0x30,%ecx
  801207:	eb 20                	jmp    801229 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801209:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80120c:	89 f0                	mov    %esi,%eax
  80120e:	3c 19                	cmp    $0x19,%al
  801210:	77 08                	ja     80121a <strtol+0x97>
			dig = *s - 'a' + 10;
  801212:	0f be c9             	movsbl %cl,%ecx
  801215:	83 e9 57             	sub    $0x57,%ecx
  801218:	eb 0f                	jmp    801229 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80121a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80121d:	89 f0                	mov    %esi,%eax
  80121f:	3c 19                	cmp    $0x19,%al
  801221:	77 16                	ja     801239 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801223:	0f be c9             	movsbl %cl,%ecx
  801226:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801229:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80122c:	7d 0f                	jge    80123d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80122e:	83 c2 01             	add    $0x1,%edx
  801231:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801235:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801237:	eb bc                	jmp    8011f5 <strtol+0x72>
  801239:	89 d8                	mov    %ebx,%eax
  80123b:	eb 02                	jmp    80123f <strtol+0xbc>
  80123d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80123f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801243:	74 05                	je     80124a <strtol+0xc7>
		*endptr = (char *) s;
  801245:	8b 75 0c             	mov    0xc(%ebp),%esi
  801248:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80124a:	f7 d8                	neg    %eax
  80124c:	85 ff                	test   %edi,%edi
  80124e:	0f 44 c3             	cmove  %ebx,%eax
}
  801251:	5b                   	pop    %ebx
  801252:	5e                   	pop    %esi
  801253:	5f                   	pop    %edi
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	57                   	push   %edi
  80125a:	56                   	push   %esi
  80125b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80125c:	b8 00 00 00 00       	mov    $0x0,%eax
  801261:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801264:	8b 55 08             	mov    0x8(%ebp),%edx
  801267:	89 c3                	mov    %eax,%ebx
  801269:	89 c7                	mov    %eax,%edi
  80126b:	89 c6                	mov    %eax,%esi
  80126d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80126f:	5b                   	pop    %ebx
  801270:	5e                   	pop    %esi
  801271:	5f                   	pop    %edi
  801272:	5d                   	pop    %ebp
  801273:	c3                   	ret    

00801274 <sys_cgetc>:

int
sys_cgetc(void)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	57                   	push   %edi
  801278:	56                   	push   %esi
  801279:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80127a:	ba 00 00 00 00       	mov    $0x0,%edx
  80127f:	b8 01 00 00 00       	mov    $0x1,%eax
  801284:	89 d1                	mov    %edx,%ecx
  801286:	89 d3                	mov    %edx,%ebx
  801288:	89 d7                	mov    %edx,%edi
  80128a:	89 d6                	mov    %edx,%esi
  80128c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80128e:	5b                   	pop    %ebx
  80128f:	5e                   	pop    %esi
  801290:	5f                   	pop    %edi
  801291:	5d                   	pop    %ebp
  801292:	c3                   	ret    

00801293 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	57                   	push   %edi
  801297:	56                   	push   %esi
  801298:	53                   	push   %ebx
  801299:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80129c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012a1:	b8 03 00 00 00       	mov    $0x3,%eax
  8012a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a9:	89 cb                	mov    %ecx,%ebx
  8012ab:	89 cf                	mov    %ecx,%edi
  8012ad:	89 ce                	mov    %ecx,%esi
  8012af:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012b1:	85 c0                	test   %eax,%eax
  8012b3:	7e 28                	jle    8012dd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012b9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8012c0:	00 
  8012c1:	c7 44 24 08 0b 35 80 	movl   $0x80350b,0x8(%esp)
  8012c8:	00 
  8012c9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012d0:	00 
  8012d1:	c7 04 24 28 35 80 00 	movl   $0x803528,(%esp)
  8012d8:	e8 0b f5 ff ff       	call   8007e8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8012dd:	83 c4 2c             	add    $0x2c,%esp
  8012e0:	5b                   	pop    %ebx
  8012e1:	5e                   	pop    %esi
  8012e2:	5f                   	pop    %edi
  8012e3:	5d                   	pop    %ebp
  8012e4:	c3                   	ret    

008012e5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	57                   	push   %edi
  8012e9:	56                   	push   %esi
  8012ea:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8012f0:	b8 02 00 00 00       	mov    $0x2,%eax
  8012f5:	89 d1                	mov    %edx,%ecx
  8012f7:	89 d3                	mov    %edx,%ebx
  8012f9:	89 d7                	mov    %edx,%edi
  8012fb:	89 d6                	mov    %edx,%esi
  8012fd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8012ff:	5b                   	pop    %ebx
  801300:	5e                   	pop    %esi
  801301:	5f                   	pop    %edi
  801302:	5d                   	pop    %ebp
  801303:	c3                   	ret    

00801304 <sys_yield>:

void
sys_yield(void)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
  801307:	57                   	push   %edi
  801308:	56                   	push   %esi
  801309:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80130a:	ba 00 00 00 00       	mov    $0x0,%edx
  80130f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801314:	89 d1                	mov    %edx,%ecx
  801316:	89 d3                	mov    %edx,%ebx
  801318:	89 d7                	mov    %edx,%edi
  80131a:	89 d6                	mov    %edx,%esi
  80131c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80131e:	5b                   	pop    %ebx
  80131f:	5e                   	pop    %esi
  801320:	5f                   	pop    %edi
  801321:	5d                   	pop    %ebp
  801322:	c3                   	ret    

00801323 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  80132c:	be 00 00 00 00       	mov    $0x0,%esi
  801331:	b8 04 00 00 00       	mov    $0x4,%eax
  801336:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801339:	8b 55 08             	mov    0x8(%ebp),%edx
  80133c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80133f:	89 f7                	mov    %esi,%edi
  801341:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801343:	85 c0                	test   %eax,%eax
  801345:	7e 28                	jle    80136f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801347:	89 44 24 10          	mov    %eax,0x10(%esp)
  80134b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801352:	00 
  801353:	c7 44 24 08 0b 35 80 	movl   $0x80350b,0x8(%esp)
  80135a:	00 
  80135b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801362:	00 
  801363:	c7 04 24 28 35 80 00 	movl   $0x803528,(%esp)
  80136a:	e8 79 f4 ff ff       	call   8007e8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80136f:	83 c4 2c             	add    $0x2c,%esp
  801372:	5b                   	pop    %ebx
  801373:	5e                   	pop    %esi
  801374:	5f                   	pop    %edi
  801375:	5d                   	pop    %ebp
  801376:	c3                   	ret    

00801377 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	57                   	push   %edi
  80137b:	56                   	push   %esi
  80137c:	53                   	push   %ebx
  80137d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801380:	b8 05 00 00 00       	mov    $0x5,%eax
  801385:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801388:	8b 55 08             	mov    0x8(%ebp),%edx
  80138b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80138e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801391:	8b 75 18             	mov    0x18(%ebp),%esi
  801394:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801396:	85 c0                	test   %eax,%eax
  801398:	7e 28                	jle    8013c2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80139a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80139e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8013a5:	00 
  8013a6:	c7 44 24 08 0b 35 80 	movl   $0x80350b,0x8(%esp)
  8013ad:	00 
  8013ae:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013b5:	00 
  8013b6:	c7 04 24 28 35 80 00 	movl   $0x803528,(%esp)
  8013bd:	e8 26 f4 ff ff       	call   8007e8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8013c2:	83 c4 2c             	add    $0x2c,%esp
  8013c5:	5b                   	pop    %ebx
  8013c6:	5e                   	pop    %esi
  8013c7:	5f                   	pop    %edi
  8013c8:	5d                   	pop    %ebp
  8013c9:	c3                   	ret    

008013ca <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	57                   	push   %edi
  8013ce:	56                   	push   %esi
  8013cf:	53                   	push   %ebx
  8013d0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d8:	b8 06 00 00 00       	mov    $0x6,%eax
  8013dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e3:	89 df                	mov    %ebx,%edi
  8013e5:	89 de                	mov    %ebx,%esi
  8013e7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	7e 28                	jle    801415 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013f1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8013f8:	00 
  8013f9:	c7 44 24 08 0b 35 80 	movl   $0x80350b,0x8(%esp)
  801400:	00 
  801401:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801408:	00 
  801409:	c7 04 24 28 35 80 00 	movl   $0x803528,(%esp)
  801410:	e8 d3 f3 ff ff       	call   8007e8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801415:	83 c4 2c             	add    $0x2c,%esp
  801418:	5b                   	pop    %ebx
  801419:	5e                   	pop    %esi
  80141a:	5f                   	pop    %edi
  80141b:	5d                   	pop    %ebp
  80141c:	c3                   	ret    

0080141d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	57                   	push   %edi
  801421:	56                   	push   %esi
  801422:	53                   	push   %ebx
  801423:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142b:	b8 08 00 00 00       	mov    $0x8,%eax
  801430:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801433:	8b 55 08             	mov    0x8(%ebp),%edx
  801436:	89 df                	mov    %ebx,%edi
  801438:	89 de                	mov    %ebx,%esi
  80143a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80143c:	85 c0                	test   %eax,%eax
  80143e:	7e 28                	jle    801468 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801440:	89 44 24 10          	mov    %eax,0x10(%esp)
  801444:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80144b:	00 
  80144c:	c7 44 24 08 0b 35 80 	movl   $0x80350b,0x8(%esp)
  801453:	00 
  801454:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80145b:	00 
  80145c:	c7 04 24 28 35 80 00 	movl   $0x803528,(%esp)
  801463:	e8 80 f3 ff ff       	call   8007e8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801468:	83 c4 2c             	add    $0x2c,%esp
  80146b:	5b                   	pop    %ebx
  80146c:	5e                   	pop    %esi
  80146d:	5f                   	pop    %edi
  80146e:	5d                   	pop    %ebp
  80146f:	c3                   	ret    

00801470 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	57                   	push   %edi
  801474:	56                   	push   %esi
  801475:	53                   	push   %ebx
  801476:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801479:	bb 00 00 00 00       	mov    $0x0,%ebx
  80147e:	b8 09 00 00 00       	mov    $0x9,%eax
  801483:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801486:	8b 55 08             	mov    0x8(%ebp),%edx
  801489:	89 df                	mov    %ebx,%edi
  80148b:	89 de                	mov    %ebx,%esi
  80148d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80148f:	85 c0                	test   %eax,%eax
  801491:	7e 28                	jle    8014bb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801493:	89 44 24 10          	mov    %eax,0x10(%esp)
  801497:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80149e:	00 
  80149f:	c7 44 24 08 0b 35 80 	movl   $0x80350b,0x8(%esp)
  8014a6:	00 
  8014a7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014ae:	00 
  8014af:	c7 04 24 28 35 80 00 	movl   $0x803528,(%esp)
  8014b6:	e8 2d f3 ff ff       	call   8007e8 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8014bb:	83 c4 2c             	add    $0x2c,%esp
  8014be:	5b                   	pop    %ebx
  8014bf:	5e                   	pop    %esi
  8014c0:	5f                   	pop    %edi
  8014c1:	5d                   	pop    %ebp
  8014c2:	c3                   	ret    

008014c3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	57                   	push   %edi
  8014c7:	56                   	push   %esi
  8014c8:	53                   	push   %ebx
  8014c9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8014d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014dc:	89 df                	mov    %ebx,%edi
  8014de:	89 de                	mov    %ebx,%esi
  8014e0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	7e 28                	jle    80150e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014e6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014ea:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8014f1:	00 
  8014f2:	c7 44 24 08 0b 35 80 	movl   $0x80350b,0x8(%esp)
  8014f9:	00 
  8014fa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801501:	00 
  801502:	c7 04 24 28 35 80 00 	movl   $0x803528,(%esp)
  801509:	e8 da f2 ff ff       	call   8007e8 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80150e:	83 c4 2c             	add    $0x2c,%esp
  801511:	5b                   	pop    %ebx
  801512:	5e                   	pop    %esi
  801513:	5f                   	pop    %edi
  801514:	5d                   	pop    %ebp
  801515:	c3                   	ret    

00801516 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	57                   	push   %edi
  80151a:	56                   	push   %esi
  80151b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80151c:	be 00 00 00 00       	mov    $0x0,%esi
  801521:	b8 0c 00 00 00       	mov    $0xc,%eax
  801526:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801529:	8b 55 08             	mov    0x8(%ebp),%edx
  80152c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80152f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801532:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801534:	5b                   	pop    %ebx
  801535:	5e                   	pop    %esi
  801536:	5f                   	pop    %edi
  801537:	5d                   	pop    %ebp
  801538:	c3                   	ret    

00801539 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	57                   	push   %edi
  80153d:	56                   	push   %esi
  80153e:	53                   	push   %ebx
  80153f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801542:	b9 00 00 00 00       	mov    $0x0,%ecx
  801547:	b8 0d 00 00 00       	mov    $0xd,%eax
  80154c:	8b 55 08             	mov    0x8(%ebp),%edx
  80154f:	89 cb                	mov    %ecx,%ebx
  801551:	89 cf                	mov    %ecx,%edi
  801553:	89 ce                	mov    %ecx,%esi
  801555:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801557:	85 c0                	test   %eax,%eax
  801559:	7e 28                	jle    801583 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80155b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80155f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801566:	00 
  801567:	c7 44 24 08 0b 35 80 	movl   $0x80350b,0x8(%esp)
  80156e:	00 
  80156f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801576:	00 
  801577:	c7 04 24 28 35 80 00 	movl   $0x803528,(%esp)
  80157e:	e8 65 f2 ff ff       	call   8007e8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801583:	83 c4 2c             	add    $0x2c,%esp
  801586:	5b                   	pop    %ebx
  801587:	5e                   	pop    %esi
  801588:	5f                   	pop    %edi
  801589:	5d                   	pop    %ebp
  80158a:	c3                   	ret    

0080158b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	57                   	push   %edi
  80158f:	56                   	push   %esi
  801590:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801591:	ba 00 00 00 00       	mov    $0x0,%edx
  801596:	b8 0e 00 00 00       	mov    $0xe,%eax
  80159b:	89 d1                	mov    %edx,%ecx
  80159d:	89 d3                	mov    %edx,%ebx
  80159f:	89 d7                	mov    %edx,%edi
  8015a1:	89 d6                	mov    %edx,%esi
  8015a3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8015a5:	5b                   	pop    %ebx
  8015a6:	5e                   	pop    %esi
  8015a7:	5f                   	pop    %edi
  8015a8:	5d                   	pop    %ebp
  8015a9:	c3                   	ret    

008015aa <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	57                   	push   %edi
  8015ae:	56                   	push   %esi
  8015af:	53                   	push   %ebx
  8015b0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8015bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c3:	89 df                	mov    %ebx,%edi
  8015c5:	89 de                	mov    %ebx,%esi
  8015c7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015c9:	85 c0                	test   %eax,%eax
  8015cb:	7e 28                	jle    8015f5 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015d1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8015d8:	00 
  8015d9:	c7 44 24 08 0b 35 80 	movl   $0x80350b,0x8(%esp)
  8015e0:	00 
  8015e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015e8:	00 
  8015e9:	c7 04 24 28 35 80 00 	movl   $0x803528,(%esp)
  8015f0:	e8 f3 f1 ff ff       	call   8007e8 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  8015f5:	83 c4 2c             	add    $0x2c,%esp
  8015f8:	5b                   	pop    %ebx
  8015f9:	5e                   	pop    %esi
  8015fa:	5f                   	pop    %edi
  8015fb:	5d                   	pop    %ebp
  8015fc:	c3                   	ret    

008015fd <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	57                   	push   %edi
  801601:	56                   	push   %esi
  801602:	53                   	push   %ebx
  801603:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801606:	bb 00 00 00 00       	mov    $0x0,%ebx
  80160b:	b8 10 00 00 00       	mov    $0x10,%eax
  801610:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801613:	8b 55 08             	mov    0x8(%ebp),%edx
  801616:	89 df                	mov    %ebx,%edi
  801618:	89 de                	mov    %ebx,%esi
  80161a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80161c:	85 c0                	test   %eax,%eax
  80161e:	7e 28                	jle    801648 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801620:	89 44 24 10          	mov    %eax,0x10(%esp)
  801624:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80162b:	00 
  80162c:	c7 44 24 08 0b 35 80 	movl   $0x80350b,0x8(%esp)
  801633:	00 
  801634:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80163b:	00 
  80163c:	c7 04 24 28 35 80 00 	movl   $0x803528,(%esp)
  801643:	e8 a0 f1 ff ff       	call   8007e8 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  801648:	83 c4 2c             	add    $0x2c,%esp
  80164b:	5b                   	pop    %ebx
  80164c:	5e                   	pop    %esi
  80164d:	5f                   	pop    %edi
  80164e:	5d                   	pop    %ebp
  80164f:	c3                   	ret    

00801650 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	57                   	push   %edi
  801654:	56                   	push   %esi
  801655:	53                   	push   %ebx
  801656:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801659:	bb 00 00 00 00       	mov    $0x0,%ebx
  80165e:	b8 11 00 00 00       	mov    $0x11,%eax
  801663:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801666:	8b 55 08             	mov    0x8(%ebp),%edx
  801669:	89 df                	mov    %ebx,%edi
  80166b:	89 de                	mov    %ebx,%esi
  80166d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80166f:	85 c0                	test   %eax,%eax
  801671:	7e 28                	jle    80169b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801673:	89 44 24 10          	mov    %eax,0x10(%esp)
  801677:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  80167e:	00 
  80167f:	c7 44 24 08 0b 35 80 	movl   $0x80350b,0x8(%esp)
  801686:	00 
  801687:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80168e:	00 
  80168f:	c7 04 24 28 35 80 00 	movl   $0x803528,(%esp)
  801696:	e8 4d f1 ff ff       	call   8007e8 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80169b:	83 c4 2c             	add    $0x2c,%esp
  80169e:	5b                   	pop    %ebx
  80169f:	5e                   	pop    %esi
  8016a0:	5f                   	pop    %edi
  8016a1:	5d                   	pop    %ebp
  8016a2:	c3                   	ret    

008016a3 <sys_sleep>:

int
sys_sleep(int channel)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	57                   	push   %edi
  8016a7:	56                   	push   %esi
  8016a8:	53                   	push   %ebx
  8016a9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b1:	b8 12 00 00 00       	mov    $0x12,%eax
  8016b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b9:	89 cb                	mov    %ecx,%ebx
  8016bb:	89 cf                	mov    %ecx,%edi
  8016bd:	89 ce                	mov    %ecx,%esi
  8016bf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	7e 28                	jle    8016ed <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016c5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016c9:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8016d0:	00 
  8016d1:	c7 44 24 08 0b 35 80 	movl   $0x80350b,0x8(%esp)
  8016d8:	00 
  8016d9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016e0:	00 
  8016e1:	c7 04 24 28 35 80 00 	movl   $0x803528,(%esp)
  8016e8:	e8 fb f0 ff ff       	call   8007e8 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  8016ed:	83 c4 2c             	add    $0x2c,%esp
  8016f0:	5b                   	pop    %ebx
  8016f1:	5e                   	pop    %esi
  8016f2:	5f                   	pop    %edi
  8016f3:	5d                   	pop    %ebp
  8016f4:	c3                   	ret    

008016f5 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	57                   	push   %edi
  8016f9:	56                   	push   %esi
  8016fa:	53                   	push   %ebx
  8016fb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801703:	b8 13 00 00 00       	mov    $0x13,%eax
  801708:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80170b:	8b 55 08             	mov    0x8(%ebp),%edx
  80170e:	89 df                	mov    %ebx,%edi
  801710:	89 de                	mov    %ebx,%esi
  801712:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801714:	85 c0                	test   %eax,%eax
  801716:	7e 28                	jle    801740 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801718:	89 44 24 10          	mov    %eax,0x10(%esp)
  80171c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801723:	00 
  801724:	c7 44 24 08 0b 35 80 	movl   $0x80350b,0x8(%esp)
  80172b:	00 
  80172c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801733:	00 
  801734:	c7 04 24 28 35 80 00 	movl   $0x803528,(%esp)
  80173b:	e8 a8 f0 ff ff       	call   8007e8 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801740:	83 c4 2c             	add    $0x2c,%esp
  801743:	5b                   	pop    %ebx
  801744:	5e                   	pop    %esi
  801745:	5f                   	pop    %edi
  801746:	5d                   	pop    %ebp
  801747:	c3                   	ret    
  801748:	66 90                	xchg   %ax,%ax
  80174a:	66 90                	xchg   %ax,%ax
  80174c:	66 90                	xchg   %ax,%ax
  80174e:	66 90                	xchg   %ax,%ax

00801750 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	56                   	push   %esi
  801754:	53                   	push   %ebx
  801755:	83 ec 10             	sub    $0x10,%esp
  801758:	8b 75 08             	mov    0x8(%ebp),%esi
  80175b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801761:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  801763:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801768:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80176b:	89 04 24             	mov    %eax,(%esp)
  80176e:	e8 c6 fd ff ff       	call   801539 <sys_ipc_recv>
  801773:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  801775:	85 d2                	test   %edx,%edx
  801777:	75 24                	jne    80179d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  801779:	85 f6                	test   %esi,%esi
  80177b:	74 0a                	je     801787 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80177d:	a1 08 50 80 00       	mov    0x805008,%eax
  801782:	8b 40 74             	mov    0x74(%eax),%eax
  801785:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  801787:	85 db                	test   %ebx,%ebx
  801789:	74 0a                	je     801795 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80178b:	a1 08 50 80 00       	mov    0x805008,%eax
  801790:	8b 40 78             	mov    0x78(%eax),%eax
  801793:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  801795:	a1 08 50 80 00       	mov    0x805008,%eax
  80179a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	5b                   	pop    %ebx
  8017a1:	5e                   	pop    %esi
  8017a2:	5d                   	pop    %ebp
  8017a3:	c3                   	ret    

008017a4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	57                   	push   %edi
  8017a8:	56                   	push   %esi
  8017a9:	53                   	push   %ebx
  8017aa:	83 ec 1c             	sub    $0x1c,%esp
  8017ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  8017b6:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  8017b8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8017bd:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8017c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017cf:	89 3c 24             	mov    %edi,(%esp)
  8017d2:	e8 3f fd ff ff       	call   801516 <sys_ipc_try_send>

		if (ret == 0)
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	74 2c                	je     801807 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  8017db:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8017de:	74 20                	je     801800 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  8017e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017e4:	c7 44 24 08 38 35 80 	movl   $0x803538,0x8(%esp)
  8017eb:	00 
  8017ec:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8017f3:	00 
  8017f4:	c7 04 24 66 35 80 00 	movl   $0x803566,(%esp)
  8017fb:	e8 e8 ef ff ff       	call   8007e8 <_panic>
		}

		sys_yield();
  801800:	e8 ff fa ff ff       	call   801304 <sys_yield>
	}
  801805:	eb b9                	jmp    8017c0 <ipc_send+0x1c>
}
  801807:	83 c4 1c             	add    $0x1c,%esp
  80180a:	5b                   	pop    %ebx
  80180b:	5e                   	pop    %esi
  80180c:	5f                   	pop    %edi
  80180d:	5d                   	pop    %ebp
  80180e:	c3                   	ret    

0080180f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801815:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80181a:	89 c2                	mov    %eax,%edx
  80181c:	c1 e2 07             	shl    $0x7,%edx
  80181f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  801826:	8b 52 50             	mov    0x50(%edx),%edx
  801829:	39 ca                	cmp    %ecx,%edx
  80182b:	75 11                	jne    80183e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80182d:	89 c2                	mov    %eax,%edx
  80182f:	c1 e2 07             	shl    $0x7,%edx
  801832:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  801839:	8b 40 40             	mov    0x40(%eax),%eax
  80183c:	eb 0e                	jmp    80184c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80183e:	83 c0 01             	add    $0x1,%eax
  801841:	3d 00 04 00 00       	cmp    $0x400,%eax
  801846:	75 d2                	jne    80181a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801848:	66 b8 00 00          	mov    $0x0,%ax
}
  80184c:	5d                   	pop    %ebp
  80184d:	c3                   	ret    
  80184e:	66 90                	xchg   %ax,%ax

00801850 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	05 00 00 00 30       	add    $0x30000000,%eax
  80185b:	c1 e8 0c             	shr    $0xc,%eax
}
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    

00801860 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80186b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801870:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801875:	5d                   	pop    %ebp
  801876:	c3                   	ret    

00801877 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80187d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801882:	89 c2                	mov    %eax,%edx
  801884:	c1 ea 16             	shr    $0x16,%edx
  801887:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80188e:	f6 c2 01             	test   $0x1,%dl
  801891:	74 11                	je     8018a4 <fd_alloc+0x2d>
  801893:	89 c2                	mov    %eax,%edx
  801895:	c1 ea 0c             	shr    $0xc,%edx
  801898:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80189f:	f6 c2 01             	test   $0x1,%dl
  8018a2:	75 09                	jne    8018ad <fd_alloc+0x36>
			*fd_store = fd;
  8018a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ab:	eb 17                	jmp    8018c4 <fd_alloc+0x4d>
  8018ad:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8018b2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8018b7:	75 c9                	jne    801882 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8018b9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8018bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8018c4:	5d                   	pop    %ebp
  8018c5:	c3                   	ret    

008018c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8018cc:	83 f8 1f             	cmp    $0x1f,%eax
  8018cf:	77 36                	ja     801907 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8018d1:	c1 e0 0c             	shl    $0xc,%eax
  8018d4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018d9:	89 c2                	mov    %eax,%edx
  8018db:	c1 ea 16             	shr    $0x16,%edx
  8018de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8018e5:	f6 c2 01             	test   $0x1,%dl
  8018e8:	74 24                	je     80190e <fd_lookup+0x48>
  8018ea:	89 c2                	mov    %eax,%edx
  8018ec:	c1 ea 0c             	shr    $0xc,%edx
  8018ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018f6:	f6 c2 01             	test   $0x1,%dl
  8018f9:	74 1a                	je     801915 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fe:	89 02                	mov    %eax,(%edx)
	return 0;
  801900:	b8 00 00 00 00       	mov    $0x0,%eax
  801905:	eb 13                	jmp    80191a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801907:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80190c:	eb 0c                	jmp    80191a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80190e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801913:	eb 05                	jmp    80191a <fd_lookup+0x54>
  801915:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    

0080191c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 18             	sub    $0x18,%esp
  801922:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801925:	ba 00 00 00 00       	mov    $0x0,%edx
  80192a:	eb 13                	jmp    80193f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80192c:	39 08                	cmp    %ecx,(%eax)
  80192e:	75 0c                	jne    80193c <dev_lookup+0x20>
			*dev = devtab[i];
  801930:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801933:	89 01                	mov    %eax,(%ecx)
			return 0;
  801935:	b8 00 00 00 00       	mov    $0x0,%eax
  80193a:	eb 38                	jmp    801974 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80193c:	83 c2 01             	add    $0x1,%edx
  80193f:	8b 04 95 f0 35 80 00 	mov    0x8035f0(,%edx,4),%eax
  801946:	85 c0                	test   %eax,%eax
  801948:	75 e2                	jne    80192c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80194a:	a1 08 50 80 00       	mov    0x805008,%eax
  80194f:	8b 40 48             	mov    0x48(%eax),%eax
  801952:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801956:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195a:	c7 04 24 70 35 80 00 	movl   $0x803570,(%esp)
  801961:	e8 7b ef ff ff       	call   8008e1 <cprintf>
	*dev = 0;
  801966:	8b 45 0c             	mov    0xc(%ebp),%eax
  801969:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80196f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	56                   	push   %esi
  80197a:	53                   	push   %ebx
  80197b:	83 ec 20             	sub    $0x20,%esp
  80197e:	8b 75 08             	mov    0x8(%ebp),%esi
  801981:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801984:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801987:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80198b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801991:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801994:	89 04 24             	mov    %eax,(%esp)
  801997:	e8 2a ff ff ff       	call   8018c6 <fd_lookup>
  80199c:	85 c0                	test   %eax,%eax
  80199e:	78 05                	js     8019a5 <fd_close+0x2f>
	    || fd != fd2)
  8019a0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8019a3:	74 0c                	je     8019b1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8019a5:	84 db                	test   %bl,%bl
  8019a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ac:	0f 44 c2             	cmove  %edx,%eax
  8019af:	eb 3f                	jmp    8019f0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b8:	8b 06                	mov    (%esi),%eax
  8019ba:	89 04 24             	mov    %eax,(%esp)
  8019bd:	e8 5a ff ff ff       	call   80191c <dev_lookup>
  8019c2:	89 c3                	mov    %eax,%ebx
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	78 16                	js     8019de <fd_close+0x68>
		if (dev->dev_close)
  8019c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8019ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8019d3:	85 c0                	test   %eax,%eax
  8019d5:	74 07                	je     8019de <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8019d7:	89 34 24             	mov    %esi,(%esp)
  8019da:	ff d0                	call   *%eax
  8019dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8019de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019e9:	e8 dc f9 ff ff       	call   8013ca <sys_page_unmap>
	return r;
  8019ee:	89 d8                	mov    %ebx,%eax
}
  8019f0:	83 c4 20             	add    $0x20,%esp
  8019f3:	5b                   	pop    %ebx
  8019f4:	5e                   	pop    %esi
  8019f5:	5d                   	pop    %ebp
  8019f6:	c3                   	ret    

008019f7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	89 04 24             	mov    %eax,(%esp)
  801a0a:	e8 b7 fe ff ff       	call   8018c6 <fd_lookup>
  801a0f:	89 c2                	mov    %eax,%edx
  801a11:	85 d2                	test   %edx,%edx
  801a13:	78 13                	js     801a28 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801a15:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801a1c:	00 
  801a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a20:	89 04 24             	mov    %eax,(%esp)
  801a23:	e8 4e ff ff ff       	call   801976 <fd_close>
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <close_all>:

void
close_all(void)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	53                   	push   %ebx
  801a2e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801a31:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a36:	89 1c 24             	mov    %ebx,(%esp)
  801a39:	e8 b9 ff ff ff       	call   8019f7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801a3e:	83 c3 01             	add    $0x1,%ebx
  801a41:	83 fb 20             	cmp    $0x20,%ebx
  801a44:	75 f0                	jne    801a36 <close_all+0xc>
		close(i);
}
  801a46:	83 c4 14             	add    $0x14,%esp
  801a49:	5b                   	pop    %ebx
  801a4a:	5d                   	pop    %ebp
  801a4b:	c3                   	ret    

00801a4c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	57                   	push   %edi
  801a50:	56                   	push   %esi
  801a51:	53                   	push   %ebx
  801a52:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a55:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	89 04 24             	mov    %eax,(%esp)
  801a62:	e8 5f fe ff ff       	call   8018c6 <fd_lookup>
  801a67:	89 c2                	mov    %eax,%edx
  801a69:	85 d2                	test   %edx,%edx
  801a6b:	0f 88 e1 00 00 00    	js     801b52 <dup+0x106>
		return r;
	close(newfdnum);
  801a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a74:	89 04 24             	mov    %eax,(%esp)
  801a77:	e8 7b ff ff ff       	call   8019f7 <close>

	newfd = INDEX2FD(newfdnum);
  801a7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a7f:	c1 e3 0c             	shl    $0xc,%ebx
  801a82:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801a88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a8b:	89 04 24             	mov    %eax,(%esp)
  801a8e:	e8 cd fd ff ff       	call   801860 <fd2data>
  801a93:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801a95:	89 1c 24             	mov    %ebx,(%esp)
  801a98:	e8 c3 fd ff ff       	call   801860 <fd2data>
  801a9d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a9f:	89 f0                	mov    %esi,%eax
  801aa1:	c1 e8 16             	shr    $0x16,%eax
  801aa4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801aab:	a8 01                	test   $0x1,%al
  801aad:	74 43                	je     801af2 <dup+0xa6>
  801aaf:	89 f0                	mov    %esi,%eax
  801ab1:	c1 e8 0c             	shr    $0xc,%eax
  801ab4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801abb:	f6 c2 01             	test   $0x1,%dl
  801abe:	74 32                	je     801af2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801ac0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ac7:	25 07 0e 00 00       	and    $0xe07,%eax
  801acc:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ad0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ad4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801adb:	00 
  801adc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ae0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ae7:	e8 8b f8 ff ff       	call   801377 <sys_page_map>
  801aec:	89 c6                	mov    %eax,%esi
  801aee:	85 c0                	test   %eax,%eax
  801af0:	78 3e                	js     801b30 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801af2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801af5:	89 c2                	mov    %eax,%edx
  801af7:	c1 ea 0c             	shr    $0xc,%edx
  801afa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b01:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801b07:	89 54 24 10          	mov    %edx,0x10(%esp)
  801b0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801b0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b16:	00 
  801b17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b22:	e8 50 f8 ff ff       	call   801377 <sys_page_map>
  801b27:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801b29:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b2c:	85 f6                	test   %esi,%esi
  801b2e:	79 22                	jns    801b52 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801b30:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b3b:	e8 8a f8 ff ff       	call   8013ca <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b40:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b44:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b4b:	e8 7a f8 ff ff       	call   8013ca <sys_page_unmap>
	return r;
  801b50:	89 f0                	mov    %esi,%eax
}
  801b52:	83 c4 3c             	add    $0x3c,%esp
  801b55:	5b                   	pop    %ebx
  801b56:	5e                   	pop    %esi
  801b57:	5f                   	pop    %edi
  801b58:	5d                   	pop    %ebp
  801b59:	c3                   	ret    

00801b5a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	53                   	push   %ebx
  801b5e:	83 ec 24             	sub    $0x24,%esp
  801b61:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b64:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b6b:	89 1c 24             	mov    %ebx,(%esp)
  801b6e:	e8 53 fd ff ff       	call   8018c6 <fd_lookup>
  801b73:	89 c2                	mov    %eax,%edx
  801b75:	85 d2                	test   %edx,%edx
  801b77:	78 6d                	js     801be6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b79:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b83:	8b 00                	mov    (%eax),%eax
  801b85:	89 04 24             	mov    %eax,(%esp)
  801b88:	e8 8f fd ff ff       	call   80191c <dev_lookup>
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	78 55                	js     801be6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b94:	8b 50 08             	mov    0x8(%eax),%edx
  801b97:	83 e2 03             	and    $0x3,%edx
  801b9a:	83 fa 01             	cmp    $0x1,%edx
  801b9d:	75 23                	jne    801bc2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b9f:	a1 08 50 80 00       	mov    0x805008,%eax
  801ba4:	8b 40 48             	mov    0x48(%eax),%eax
  801ba7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801baf:	c7 04 24 b4 35 80 00 	movl   $0x8035b4,(%esp)
  801bb6:	e8 26 ed ff ff       	call   8008e1 <cprintf>
		return -E_INVAL;
  801bbb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bc0:	eb 24                	jmp    801be6 <read+0x8c>
	}
	if (!dev->dev_read)
  801bc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc5:	8b 52 08             	mov    0x8(%edx),%edx
  801bc8:	85 d2                	test   %edx,%edx
  801bca:	74 15                	je     801be1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801bcc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bcf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bd6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bda:	89 04 24             	mov    %eax,(%esp)
  801bdd:	ff d2                	call   *%edx
  801bdf:	eb 05                	jmp    801be6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801be1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801be6:	83 c4 24             	add    $0x24,%esp
  801be9:	5b                   	pop    %ebx
  801bea:	5d                   	pop    %ebp
  801beb:	c3                   	ret    

00801bec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	57                   	push   %edi
  801bf0:	56                   	push   %esi
  801bf1:	53                   	push   %ebx
  801bf2:	83 ec 1c             	sub    $0x1c,%esp
  801bf5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bf8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bfb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c00:	eb 23                	jmp    801c25 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c02:	89 f0                	mov    %esi,%eax
  801c04:	29 d8                	sub    %ebx,%eax
  801c06:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c0a:	89 d8                	mov    %ebx,%eax
  801c0c:	03 45 0c             	add    0xc(%ebp),%eax
  801c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c13:	89 3c 24             	mov    %edi,(%esp)
  801c16:	e8 3f ff ff ff       	call   801b5a <read>
		if (m < 0)
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	78 10                	js     801c2f <readn+0x43>
			return m;
		if (m == 0)
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	74 0a                	je     801c2d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c23:	01 c3                	add    %eax,%ebx
  801c25:	39 f3                	cmp    %esi,%ebx
  801c27:	72 d9                	jb     801c02 <readn+0x16>
  801c29:	89 d8                	mov    %ebx,%eax
  801c2b:	eb 02                	jmp    801c2f <readn+0x43>
  801c2d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801c2f:	83 c4 1c             	add    $0x1c,%esp
  801c32:	5b                   	pop    %ebx
  801c33:	5e                   	pop    %esi
  801c34:	5f                   	pop    %edi
  801c35:	5d                   	pop    %ebp
  801c36:	c3                   	ret    

00801c37 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	53                   	push   %ebx
  801c3b:	83 ec 24             	sub    $0x24,%esp
  801c3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c41:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c48:	89 1c 24             	mov    %ebx,(%esp)
  801c4b:	e8 76 fc ff ff       	call   8018c6 <fd_lookup>
  801c50:	89 c2                	mov    %eax,%edx
  801c52:	85 d2                	test   %edx,%edx
  801c54:	78 68                	js     801cbe <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c60:	8b 00                	mov    (%eax),%eax
  801c62:	89 04 24             	mov    %eax,(%esp)
  801c65:	e8 b2 fc ff ff       	call   80191c <dev_lookup>
  801c6a:	85 c0                	test   %eax,%eax
  801c6c:	78 50                	js     801cbe <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c71:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c75:	75 23                	jne    801c9a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c77:	a1 08 50 80 00       	mov    0x805008,%eax
  801c7c:	8b 40 48             	mov    0x48(%eax),%eax
  801c7f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c87:	c7 04 24 d0 35 80 00 	movl   $0x8035d0,(%esp)
  801c8e:	e8 4e ec ff ff       	call   8008e1 <cprintf>
		return -E_INVAL;
  801c93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c98:	eb 24                	jmp    801cbe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c9d:	8b 52 0c             	mov    0xc(%edx),%edx
  801ca0:	85 d2                	test   %edx,%edx
  801ca2:	74 15                	je     801cb9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ca4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ca7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cb2:	89 04 24             	mov    %eax,(%esp)
  801cb5:	ff d2                	call   *%edx
  801cb7:	eb 05                	jmp    801cbe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801cb9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801cbe:	83 c4 24             	add    $0x24,%esp
  801cc1:	5b                   	pop    %ebx
  801cc2:	5d                   	pop    %ebp
  801cc3:	c3                   	ret    

00801cc4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cca:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801ccd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	89 04 24             	mov    %eax,(%esp)
  801cd7:	e8 ea fb ff ff       	call   8018c6 <fd_lookup>
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	78 0e                	js     801cee <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801ce0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ce9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	53                   	push   %ebx
  801cf4:	83 ec 24             	sub    $0x24,%esp
  801cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cfa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d01:	89 1c 24             	mov    %ebx,(%esp)
  801d04:	e8 bd fb ff ff       	call   8018c6 <fd_lookup>
  801d09:	89 c2                	mov    %eax,%edx
  801d0b:	85 d2                	test   %edx,%edx
  801d0d:	78 61                	js     801d70 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d19:	8b 00                	mov    (%eax),%eax
  801d1b:	89 04 24             	mov    %eax,(%esp)
  801d1e:	e8 f9 fb ff ff       	call   80191c <dev_lookup>
  801d23:	85 c0                	test   %eax,%eax
  801d25:	78 49                	js     801d70 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d2e:	75 23                	jne    801d53 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801d30:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d35:	8b 40 48             	mov    0x48(%eax),%eax
  801d38:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d40:	c7 04 24 90 35 80 00 	movl   $0x803590,(%esp)
  801d47:	e8 95 eb ff ff       	call   8008e1 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801d4c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d51:	eb 1d                	jmp    801d70 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801d53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d56:	8b 52 18             	mov    0x18(%edx),%edx
  801d59:	85 d2                	test   %edx,%edx
  801d5b:	74 0e                	je     801d6b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d60:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d64:	89 04 24             	mov    %eax,(%esp)
  801d67:	ff d2                	call   *%edx
  801d69:	eb 05                	jmp    801d70 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801d6b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801d70:	83 c4 24             	add    $0x24,%esp
  801d73:	5b                   	pop    %ebx
  801d74:	5d                   	pop    %ebp
  801d75:	c3                   	ret    

00801d76 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	53                   	push   %ebx
  801d7a:	83 ec 24             	sub    $0x24,%esp
  801d7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d80:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d87:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8a:	89 04 24             	mov    %eax,(%esp)
  801d8d:	e8 34 fb ff ff       	call   8018c6 <fd_lookup>
  801d92:	89 c2                	mov    %eax,%edx
  801d94:	85 d2                	test   %edx,%edx
  801d96:	78 52                	js     801dea <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da2:	8b 00                	mov    (%eax),%eax
  801da4:	89 04 24             	mov    %eax,(%esp)
  801da7:	e8 70 fb ff ff       	call   80191c <dev_lookup>
  801dac:	85 c0                	test   %eax,%eax
  801dae:	78 3a                	js     801dea <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801db7:	74 2c                	je     801de5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801db9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801dbc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801dc3:	00 00 00 
	stat->st_isdir = 0;
  801dc6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dcd:	00 00 00 
	stat->st_dev = dev;
  801dd0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801dd6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ddd:	89 14 24             	mov    %edx,(%esp)
  801de0:	ff 50 14             	call   *0x14(%eax)
  801de3:	eb 05                	jmp    801dea <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801de5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801dea:	83 c4 24             	add    $0x24,%esp
  801ded:	5b                   	pop    %ebx
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    

00801df0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	56                   	push   %esi
  801df4:	53                   	push   %ebx
  801df5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801df8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801dff:	00 
  801e00:	8b 45 08             	mov    0x8(%ebp),%eax
  801e03:	89 04 24             	mov    %eax,(%esp)
  801e06:	e8 1b 02 00 00       	call   802026 <open>
  801e0b:	89 c3                	mov    %eax,%ebx
  801e0d:	85 db                	test   %ebx,%ebx
  801e0f:	78 1b                	js     801e2c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e18:	89 1c 24             	mov    %ebx,(%esp)
  801e1b:	e8 56 ff ff ff       	call   801d76 <fstat>
  801e20:	89 c6                	mov    %eax,%esi
	close(fd);
  801e22:	89 1c 24             	mov    %ebx,(%esp)
  801e25:	e8 cd fb ff ff       	call   8019f7 <close>
	return r;
  801e2a:	89 f0                	mov    %esi,%eax
}
  801e2c:	83 c4 10             	add    $0x10,%esp
  801e2f:	5b                   	pop    %ebx
  801e30:	5e                   	pop    %esi
  801e31:	5d                   	pop    %ebp
  801e32:	c3                   	ret    

00801e33 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	56                   	push   %esi
  801e37:	53                   	push   %ebx
  801e38:	83 ec 10             	sub    $0x10,%esp
  801e3b:	89 c6                	mov    %eax,%esi
  801e3d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801e3f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801e46:	75 11                	jne    801e59 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801e4f:	e8 bb f9 ff ff       	call   80180f <ipc_find_env>
  801e54:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e59:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e60:	00 
  801e61:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801e68:	00 
  801e69:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e6d:	a1 00 50 80 00       	mov    0x805000,%eax
  801e72:	89 04 24             	mov    %eax,(%esp)
  801e75:	e8 2a f9 ff ff       	call   8017a4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e7a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e81:	00 
  801e82:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e8d:	e8 be f8 ff ff       	call   801750 <ipc_recv>
}
  801e92:	83 c4 10             	add    $0x10,%esp
  801e95:	5b                   	pop    %ebx
  801e96:	5e                   	pop    %esi
  801e97:	5d                   	pop    %ebp
  801e98:	c3                   	ret    

00801e99 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ead:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801eb2:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb7:	b8 02 00 00 00       	mov    $0x2,%eax
  801ebc:	e8 72 ff ff ff       	call   801e33 <fsipc>
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecc:	8b 40 0c             	mov    0xc(%eax),%eax
  801ecf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ed4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed9:	b8 06 00 00 00       	mov    $0x6,%eax
  801ede:	e8 50 ff ff ff       	call   801e33 <fsipc>
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	53                   	push   %ebx
  801ee9:	83 ec 14             	sub    $0x14,%esp
  801eec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801efa:	ba 00 00 00 00       	mov    $0x0,%edx
  801eff:	b8 05 00 00 00       	mov    $0x5,%eax
  801f04:	e8 2a ff ff ff       	call   801e33 <fsipc>
  801f09:	89 c2                	mov    %eax,%edx
  801f0b:	85 d2                	test   %edx,%edx
  801f0d:	78 2b                	js     801f3a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f0f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f16:	00 
  801f17:	89 1c 24             	mov    %ebx,(%esp)
  801f1a:	e8 e8 ef ff ff       	call   800f07 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801f1f:	a1 80 60 80 00       	mov    0x806080,%eax
  801f24:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f2a:	a1 84 60 80 00       	mov    0x806084,%eax
  801f2f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801f35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3a:	83 c4 14             	add    $0x14,%esp
  801f3d:	5b                   	pop    %ebx
  801f3e:	5d                   	pop    %ebp
  801f3f:	c3                   	ret    

00801f40 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 18             	sub    $0x18,%esp
  801f46:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f49:	8b 55 08             	mov    0x8(%ebp),%edx
  801f4c:	8b 52 0c             	mov    0xc(%edx),%edx
  801f4f:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801f55:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801f5a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f61:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f65:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801f6c:	e8 9b f1 ff ff       	call   80110c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801f71:	ba 00 00 00 00       	mov    $0x0,%edx
  801f76:	b8 04 00 00 00       	mov    $0x4,%eax
  801f7b:	e8 b3 fe ff ff       	call   801e33 <fsipc>
		return r;
	}

	return r;
}
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	56                   	push   %esi
  801f86:	53                   	push   %ebx
  801f87:	83 ec 10             	sub    $0x10,%esp
  801f8a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	8b 40 0c             	mov    0xc(%eax),%eax
  801f93:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f98:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa3:	b8 03 00 00 00       	mov    $0x3,%eax
  801fa8:	e8 86 fe ff ff       	call   801e33 <fsipc>
  801fad:	89 c3                	mov    %eax,%ebx
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	78 6a                	js     80201d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801fb3:	39 c6                	cmp    %eax,%esi
  801fb5:	73 24                	jae    801fdb <devfile_read+0x59>
  801fb7:	c7 44 24 0c 04 36 80 	movl   $0x803604,0xc(%esp)
  801fbe:	00 
  801fbf:	c7 44 24 08 0b 36 80 	movl   $0x80360b,0x8(%esp)
  801fc6:	00 
  801fc7:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801fce:	00 
  801fcf:	c7 04 24 20 36 80 00 	movl   $0x803620,(%esp)
  801fd6:	e8 0d e8 ff ff       	call   8007e8 <_panic>
	assert(r <= PGSIZE);
  801fdb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801fe0:	7e 24                	jle    802006 <devfile_read+0x84>
  801fe2:	c7 44 24 0c 2b 36 80 	movl   $0x80362b,0xc(%esp)
  801fe9:	00 
  801fea:	c7 44 24 08 0b 36 80 	movl   $0x80360b,0x8(%esp)
  801ff1:	00 
  801ff2:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801ff9:	00 
  801ffa:	c7 04 24 20 36 80 00 	movl   $0x803620,(%esp)
  802001:	e8 e2 e7 ff ff       	call   8007e8 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802006:	89 44 24 08          	mov    %eax,0x8(%esp)
  80200a:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802011:	00 
  802012:	8b 45 0c             	mov    0xc(%ebp),%eax
  802015:	89 04 24             	mov    %eax,(%esp)
  802018:	e8 87 f0 ff ff       	call   8010a4 <memmove>
	return r;
}
  80201d:	89 d8                	mov    %ebx,%eax
  80201f:	83 c4 10             	add    $0x10,%esp
  802022:	5b                   	pop    %ebx
  802023:	5e                   	pop    %esi
  802024:	5d                   	pop    %ebp
  802025:	c3                   	ret    

00802026 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	53                   	push   %ebx
  80202a:	83 ec 24             	sub    $0x24,%esp
  80202d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802030:	89 1c 24             	mov    %ebx,(%esp)
  802033:	e8 98 ee ff ff       	call   800ed0 <strlen>
  802038:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80203d:	7f 60                	jg     80209f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80203f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802042:	89 04 24             	mov    %eax,(%esp)
  802045:	e8 2d f8 ff ff       	call   801877 <fd_alloc>
  80204a:	89 c2                	mov    %eax,%edx
  80204c:	85 d2                	test   %edx,%edx
  80204e:	78 54                	js     8020a4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  802050:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802054:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  80205b:	e8 a7 ee ff ff       	call   800f07 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802060:	8b 45 0c             	mov    0xc(%ebp),%eax
  802063:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802068:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206b:	b8 01 00 00 00       	mov    $0x1,%eax
  802070:	e8 be fd ff ff       	call   801e33 <fsipc>
  802075:	89 c3                	mov    %eax,%ebx
  802077:	85 c0                	test   %eax,%eax
  802079:	79 17                	jns    802092 <open+0x6c>
		fd_close(fd, 0);
  80207b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802082:	00 
  802083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802086:	89 04 24             	mov    %eax,(%esp)
  802089:	e8 e8 f8 ff ff       	call   801976 <fd_close>
		return r;
  80208e:	89 d8                	mov    %ebx,%eax
  802090:	eb 12                	jmp    8020a4 <open+0x7e>
	}

	return fd2num(fd);
  802092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802095:	89 04 24             	mov    %eax,(%esp)
  802098:	e8 b3 f7 ff ff       	call   801850 <fd2num>
  80209d:	eb 05                	jmp    8020a4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80209f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8020a4:	83 c4 24             	add    $0x24,%esp
  8020a7:	5b                   	pop    %ebx
  8020a8:	5d                   	pop    %ebp
  8020a9:	c3                   	ret    

008020aa <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8020b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8020b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8020ba:	e8 74 fd ff ff       	call   801e33 <fsipc>
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    
  8020c1:	66 90                	xchg   %ax,%ax
  8020c3:	66 90                	xchg   %ax,%ax
  8020c5:	66 90                	xchg   %ax,%ax
  8020c7:	66 90                	xchg   %ax,%ax
  8020c9:	66 90                	xchg   %ax,%ax
  8020cb:	66 90                	xchg   %ax,%ax
  8020cd:	66 90                	xchg   %ax,%ax
  8020cf:	90                   	nop

008020d0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8020d6:	c7 44 24 04 37 36 80 	movl   $0x803637,0x4(%esp)
  8020dd:	00 
  8020de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e1:	89 04 24             	mov    %eax,(%esp)
  8020e4:	e8 1e ee ff ff       	call   800f07 <strcpy>
	return 0;
}
  8020e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	53                   	push   %ebx
  8020f4:	83 ec 14             	sub    $0x14,%esp
  8020f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8020fa:	89 1c 24             	mov    %ebx,(%esp)
  8020fd:	e8 04 0a 00 00       	call   802b06 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802102:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802107:	83 f8 01             	cmp    $0x1,%eax
  80210a:	75 0d                	jne    802119 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80210c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80210f:	89 04 24             	mov    %eax,(%esp)
  802112:	e8 29 03 00 00       	call   802440 <nsipc_close>
  802117:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802119:	89 d0                	mov    %edx,%eax
  80211b:	83 c4 14             	add    $0x14,%esp
  80211e:	5b                   	pop    %ebx
  80211f:	5d                   	pop    %ebp
  802120:	c3                   	ret    

00802121 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802127:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80212e:	00 
  80212f:	8b 45 10             	mov    0x10(%ebp),%eax
  802132:	89 44 24 08          	mov    %eax,0x8(%esp)
  802136:	8b 45 0c             	mov    0xc(%ebp),%eax
  802139:	89 44 24 04          	mov    %eax,0x4(%esp)
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	8b 40 0c             	mov    0xc(%eax),%eax
  802143:	89 04 24             	mov    %eax,(%esp)
  802146:	e8 f0 03 00 00       	call   80253b <nsipc_send>
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802153:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80215a:	00 
  80215b:	8b 45 10             	mov    0x10(%ebp),%eax
  80215e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802162:	8b 45 0c             	mov    0xc(%ebp),%eax
  802165:	89 44 24 04          	mov    %eax,0x4(%esp)
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	8b 40 0c             	mov    0xc(%eax),%eax
  80216f:	89 04 24             	mov    %eax,(%esp)
  802172:	e8 44 03 00 00       	call   8024bb <nsipc_recv>
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
  80217c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80217f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802182:	89 54 24 04          	mov    %edx,0x4(%esp)
  802186:	89 04 24             	mov    %eax,(%esp)
  802189:	e8 38 f7 ff ff       	call   8018c6 <fd_lookup>
  80218e:	85 c0                	test   %eax,%eax
  802190:	78 17                	js     8021a9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802195:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  80219b:	39 08                	cmp    %ecx,(%eax)
  80219d:	75 05                	jne    8021a4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80219f:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a2:	eb 05                	jmp    8021a9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8021a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	56                   	push   %esi
  8021af:	53                   	push   %ebx
  8021b0:	83 ec 20             	sub    $0x20,%esp
  8021b3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8021b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b8:	89 04 24             	mov    %eax,(%esp)
  8021bb:	e8 b7 f6 ff ff       	call   801877 <fd_alloc>
  8021c0:	89 c3                	mov    %eax,%ebx
  8021c2:	85 c0                	test   %eax,%eax
  8021c4:	78 21                	js     8021e7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8021c6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021cd:	00 
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021dc:	e8 42 f1 ff ff       	call   801323 <sys_page_alloc>
  8021e1:	89 c3                	mov    %eax,%ebx
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	79 0c                	jns    8021f3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8021e7:	89 34 24             	mov    %esi,(%esp)
  8021ea:	e8 51 02 00 00       	call   802440 <nsipc_close>
		return r;
  8021ef:	89 d8                	mov    %ebx,%eax
  8021f1:	eb 20                	jmp    802213 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8021f3:	8b 15 24 40 80 00    	mov    0x804024,%edx
  8021f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8021fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802201:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802208:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80220b:	89 14 24             	mov    %edx,(%esp)
  80220e:	e8 3d f6 ff ff       	call   801850 <fd2num>
}
  802213:	83 c4 20             	add    $0x20,%esp
  802216:	5b                   	pop    %ebx
  802217:	5e                   	pop    %esi
  802218:	5d                   	pop    %ebp
  802219:	c3                   	ret    

0080221a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	e8 51 ff ff ff       	call   802179 <fd2sockid>
		return r;
  802228:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80222a:	85 c0                	test   %eax,%eax
  80222c:	78 23                	js     802251 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80222e:	8b 55 10             	mov    0x10(%ebp),%edx
  802231:	89 54 24 08          	mov    %edx,0x8(%esp)
  802235:	8b 55 0c             	mov    0xc(%ebp),%edx
  802238:	89 54 24 04          	mov    %edx,0x4(%esp)
  80223c:	89 04 24             	mov    %eax,(%esp)
  80223f:	e8 45 01 00 00       	call   802389 <nsipc_accept>
		return r;
  802244:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802246:	85 c0                	test   %eax,%eax
  802248:	78 07                	js     802251 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80224a:	e8 5c ff ff ff       	call   8021ab <alloc_sockfd>
  80224f:	89 c1                	mov    %eax,%ecx
}
  802251:	89 c8                	mov    %ecx,%eax
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	e8 16 ff ff ff       	call   802179 <fd2sockid>
  802263:	89 c2                	mov    %eax,%edx
  802265:	85 d2                	test   %edx,%edx
  802267:	78 16                	js     80227f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802269:	8b 45 10             	mov    0x10(%ebp),%eax
  80226c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802270:	8b 45 0c             	mov    0xc(%ebp),%eax
  802273:	89 44 24 04          	mov    %eax,0x4(%esp)
  802277:	89 14 24             	mov    %edx,(%esp)
  80227a:	e8 60 01 00 00       	call   8023df <nsipc_bind>
}
  80227f:	c9                   	leave  
  802280:	c3                   	ret    

00802281 <shutdown>:

int
shutdown(int s, int how)
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
  802284:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	e8 ea fe ff ff       	call   802179 <fd2sockid>
  80228f:	89 c2                	mov    %eax,%edx
  802291:	85 d2                	test   %edx,%edx
  802293:	78 0f                	js     8022a4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802295:	8b 45 0c             	mov    0xc(%ebp),%eax
  802298:	89 44 24 04          	mov    %eax,0x4(%esp)
  80229c:	89 14 24             	mov    %edx,(%esp)
  80229f:	e8 7a 01 00 00       	call   80241e <nsipc_shutdown>
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	e8 c5 fe ff ff       	call   802179 <fd2sockid>
  8022b4:	89 c2                	mov    %eax,%edx
  8022b6:	85 d2                	test   %edx,%edx
  8022b8:	78 16                	js     8022d0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8022ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8022bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c8:	89 14 24             	mov    %edx,(%esp)
  8022cb:	e8 8a 01 00 00       	call   80245a <nsipc_connect>
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <listen>:

int
listen(int s, int backlog)
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	e8 99 fe ff ff       	call   802179 <fd2sockid>
  8022e0:	89 c2                	mov    %eax,%edx
  8022e2:	85 d2                	test   %edx,%edx
  8022e4:	78 0f                	js     8022f5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8022e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ed:	89 14 24             	mov    %edx,(%esp)
  8022f0:	e8 a4 01 00 00       	call   802499 <nsipc_listen>
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
  8022fa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8022fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802300:	89 44 24 08          	mov    %eax,0x8(%esp)
  802304:	8b 45 0c             	mov    0xc(%ebp),%eax
  802307:	89 44 24 04          	mov    %eax,0x4(%esp)
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	89 04 24             	mov    %eax,(%esp)
  802311:	e8 98 02 00 00       	call   8025ae <nsipc_socket>
  802316:	89 c2                	mov    %eax,%edx
  802318:	85 d2                	test   %edx,%edx
  80231a:	78 05                	js     802321 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80231c:	e8 8a fe ff ff       	call   8021ab <alloc_sockfd>
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
  802326:	53                   	push   %ebx
  802327:	83 ec 14             	sub    $0x14,%esp
  80232a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80232c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802333:	75 11                	jne    802346 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802335:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80233c:	e8 ce f4 ff ff       	call   80180f <ipc_find_env>
  802341:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802346:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80234d:	00 
  80234e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802355:	00 
  802356:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80235a:	a1 04 50 80 00       	mov    0x805004,%eax
  80235f:	89 04 24             	mov    %eax,(%esp)
  802362:	e8 3d f4 ff ff       	call   8017a4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802367:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80236e:	00 
  80236f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802376:	00 
  802377:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80237e:	e8 cd f3 ff ff       	call   801750 <ipc_recv>
}
  802383:	83 c4 14             	add    $0x14,%esp
  802386:	5b                   	pop    %ebx
  802387:	5d                   	pop    %ebp
  802388:	c3                   	ret    

00802389 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
  80238c:	56                   	push   %esi
  80238d:	53                   	push   %ebx
  80238e:	83 ec 10             	sub    $0x10,%esp
  802391:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80239c:	8b 06                	mov    (%esi),%eax
  80239e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8023a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a8:	e8 76 ff ff ff       	call   802323 <nsipc>
  8023ad:	89 c3                	mov    %eax,%ebx
  8023af:	85 c0                	test   %eax,%eax
  8023b1:	78 23                	js     8023d6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8023b3:	a1 10 70 80 00       	mov    0x807010,%eax
  8023b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023bc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8023c3:	00 
  8023c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c7:	89 04 24             	mov    %eax,(%esp)
  8023ca:	e8 d5 ec ff ff       	call   8010a4 <memmove>
		*addrlen = ret->ret_addrlen;
  8023cf:	a1 10 70 80 00       	mov    0x807010,%eax
  8023d4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8023d6:	89 d8                	mov    %ebx,%eax
  8023d8:	83 c4 10             	add    $0x10,%esp
  8023db:	5b                   	pop    %ebx
  8023dc:	5e                   	pop    %esi
  8023dd:	5d                   	pop    %ebp
  8023de:	c3                   	ret    

008023df <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
  8023e2:	53                   	push   %ebx
  8023e3:	83 ec 14             	sub    $0x14,%esp
  8023e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8023e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ec:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8023f1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023fc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802403:	e8 9c ec ff ff       	call   8010a4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802408:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80240e:	b8 02 00 00 00       	mov    $0x2,%eax
  802413:	e8 0b ff ff ff       	call   802323 <nsipc>
}
  802418:	83 c4 14             	add    $0x14,%esp
  80241b:	5b                   	pop    %ebx
  80241c:	5d                   	pop    %ebp
  80241d:	c3                   	ret    

0080241e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80242c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802434:	b8 03 00 00 00       	mov    $0x3,%eax
  802439:	e8 e5 fe ff ff       	call   802323 <nsipc>
}
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <nsipc_close>:

int
nsipc_close(int s)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
  802443:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80244e:	b8 04 00 00 00       	mov    $0x4,%eax
  802453:	e8 cb fe ff ff       	call   802323 <nsipc>
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	53                   	push   %ebx
  80245e:	83 ec 14             	sub    $0x14,%esp
  802461:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802464:	8b 45 08             	mov    0x8(%ebp),%eax
  802467:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80246c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802470:	8b 45 0c             	mov    0xc(%ebp),%eax
  802473:	89 44 24 04          	mov    %eax,0x4(%esp)
  802477:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80247e:	e8 21 ec ff ff       	call   8010a4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802483:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802489:	b8 05 00 00 00       	mov    $0x5,%eax
  80248e:	e8 90 fe ff ff       	call   802323 <nsipc>
}
  802493:	83 c4 14             	add    $0x14,%esp
  802496:	5b                   	pop    %ebx
  802497:	5d                   	pop    %ebp
  802498:	c3                   	ret    

00802499 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802499:	55                   	push   %ebp
  80249a:	89 e5                	mov    %esp,%ebp
  80249c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8024a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024aa:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8024af:	b8 06 00 00 00       	mov    $0x6,%eax
  8024b4:	e8 6a fe ff ff       	call   802323 <nsipc>
}
  8024b9:	c9                   	leave  
  8024ba:	c3                   	ret    

008024bb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
  8024be:	56                   	push   %esi
  8024bf:	53                   	push   %ebx
  8024c0:	83 ec 10             	sub    $0x10,%esp
  8024c3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8024ce:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8024d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8024d7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8024dc:	b8 07 00 00 00       	mov    $0x7,%eax
  8024e1:	e8 3d fe ff ff       	call   802323 <nsipc>
  8024e6:	89 c3                	mov    %eax,%ebx
  8024e8:	85 c0                	test   %eax,%eax
  8024ea:	78 46                	js     802532 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8024ec:	39 f0                	cmp    %esi,%eax
  8024ee:	7f 07                	jg     8024f7 <nsipc_recv+0x3c>
  8024f0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8024f5:	7e 24                	jle    80251b <nsipc_recv+0x60>
  8024f7:	c7 44 24 0c 43 36 80 	movl   $0x803643,0xc(%esp)
  8024fe:	00 
  8024ff:	c7 44 24 08 0b 36 80 	movl   $0x80360b,0x8(%esp)
  802506:	00 
  802507:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80250e:	00 
  80250f:	c7 04 24 58 36 80 00 	movl   $0x803658,(%esp)
  802516:	e8 cd e2 ff ff       	call   8007e8 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80251b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80251f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802526:	00 
  802527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80252a:	89 04 24             	mov    %eax,(%esp)
  80252d:	e8 72 eb ff ff       	call   8010a4 <memmove>
	}

	return r;
}
  802532:	89 d8                	mov    %ebx,%eax
  802534:	83 c4 10             	add    $0x10,%esp
  802537:	5b                   	pop    %ebx
  802538:	5e                   	pop    %esi
  802539:	5d                   	pop    %ebp
  80253a:	c3                   	ret    

0080253b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
  80253e:	53                   	push   %ebx
  80253f:	83 ec 14             	sub    $0x14,%esp
  802542:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802545:	8b 45 08             	mov    0x8(%ebp),%eax
  802548:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80254d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802553:	7e 24                	jle    802579 <nsipc_send+0x3e>
  802555:	c7 44 24 0c 64 36 80 	movl   $0x803664,0xc(%esp)
  80255c:	00 
  80255d:	c7 44 24 08 0b 36 80 	movl   $0x80360b,0x8(%esp)
  802564:	00 
  802565:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80256c:	00 
  80256d:	c7 04 24 58 36 80 00 	movl   $0x803658,(%esp)
  802574:	e8 6f e2 ff ff       	call   8007e8 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802579:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80257d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802580:	89 44 24 04          	mov    %eax,0x4(%esp)
  802584:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80258b:	e8 14 eb ff ff       	call   8010a4 <memmove>
	nsipcbuf.send.req_size = size;
  802590:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802596:	8b 45 14             	mov    0x14(%ebp),%eax
  802599:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80259e:	b8 08 00 00 00       	mov    $0x8,%eax
  8025a3:	e8 7b fd ff ff       	call   802323 <nsipc>
}
  8025a8:	83 c4 14             	add    $0x14,%esp
  8025ab:	5b                   	pop    %ebx
  8025ac:	5d                   	pop    %ebp
  8025ad:	c3                   	ret    

008025ae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
  8025b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8025b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8025bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025bf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8025c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8025c7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8025cc:	b8 09 00 00 00       	mov    $0x9,%eax
  8025d1:	e8 4d fd ff ff       	call   802323 <nsipc>
}
  8025d6:	c9                   	leave  
  8025d7:	c3                   	ret    

008025d8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8025d8:	55                   	push   %ebp
  8025d9:	89 e5                	mov    %esp,%ebp
  8025db:	56                   	push   %esi
  8025dc:	53                   	push   %ebx
  8025dd:	83 ec 10             	sub    $0x10,%esp
  8025e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8025e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e6:	89 04 24             	mov    %eax,(%esp)
  8025e9:	e8 72 f2 ff ff       	call   801860 <fd2data>
  8025ee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8025f0:	c7 44 24 04 70 36 80 	movl   $0x803670,0x4(%esp)
  8025f7:	00 
  8025f8:	89 1c 24             	mov    %ebx,(%esp)
  8025fb:	e8 07 e9 ff ff       	call   800f07 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802600:	8b 46 04             	mov    0x4(%esi),%eax
  802603:	2b 06                	sub    (%esi),%eax
  802605:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80260b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802612:	00 00 00 
	stat->st_dev = &devpipe;
  802615:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  80261c:	40 80 00 
	return 0;
}
  80261f:	b8 00 00 00 00       	mov    $0x0,%eax
  802624:	83 c4 10             	add    $0x10,%esp
  802627:	5b                   	pop    %ebx
  802628:	5e                   	pop    %esi
  802629:	5d                   	pop    %ebp
  80262a:	c3                   	ret    

0080262b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
  80262e:	53                   	push   %ebx
  80262f:	83 ec 14             	sub    $0x14,%esp
  802632:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802635:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802639:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802640:	e8 85 ed ff ff       	call   8013ca <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802645:	89 1c 24             	mov    %ebx,(%esp)
  802648:	e8 13 f2 ff ff       	call   801860 <fd2data>
  80264d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802651:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802658:	e8 6d ed ff ff       	call   8013ca <sys_page_unmap>
}
  80265d:	83 c4 14             	add    $0x14,%esp
  802660:	5b                   	pop    %ebx
  802661:	5d                   	pop    %ebp
  802662:	c3                   	ret    

00802663 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
  802666:	57                   	push   %edi
  802667:	56                   	push   %esi
  802668:	53                   	push   %ebx
  802669:	83 ec 2c             	sub    $0x2c,%esp
  80266c:	89 c6                	mov    %eax,%esi
  80266e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802671:	a1 08 50 80 00       	mov    0x805008,%eax
  802676:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802679:	89 34 24             	mov    %esi,(%esp)
  80267c:	e8 85 04 00 00       	call   802b06 <pageref>
  802681:	89 c7                	mov    %eax,%edi
  802683:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802686:	89 04 24             	mov    %eax,(%esp)
  802689:	e8 78 04 00 00       	call   802b06 <pageref>
  80268e:	39 c7                	cmp    %eax,%edi
  802690:	0f 94 c2             	sete   %dl
  802693:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802696:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80269c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80269f:	39 fb                	cmp    %edi,%ebx
  8026a1:	74 21                	je     8026c4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8026a3:	84 d2                	test   %dl,%dl
  8026a5:	74 ca                	je     802671 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8026a7:	8b 51 58             	mov    0x58(%ecx),%edx
  8026aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026b6:	c7 04 24 77 36 80 00 	movl   $0x803677,(%esp)
  8026bd:	e8 1f e2 ff ff       	call   8008e1 <cprintf>
  8026c2:	eb ad                	jmp    802671 <_pipeisclosed+0xe>
	}
}
  8026c4:	83 c4 2c             	add    $0x2c,%esp
  8026c7:	5b                   	pop    %ebx
  8026c8:	5e                   	pop    %esi
  8026c9:	5f                   	pop    %edi
  8026ca:	5d                   	pop    %ebp
  8026cb:	c3                   	ret    

008026cc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026cc:	55                   	push   %ebp
  8026cd:	89 e5                	mov    %esp,%ebp
  8026cf:	57                   	push   %edi
  8026d0:	56                   	push   %esi
  8026d1:	53                   	push   %ebx
  8026d2:	83 ec 1c             	sub    $0x1c,%esp
  8026d5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8026d8:	89 34 24             	mov    %esi,(%esp)
  8026db:	e8 80 f1 ff ff       	call   801860 <fd2data>
  8026e0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026e7:	eb 45                	jmp    80272e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8026e9:	89 da                	mov    %ebx,%edx
  8026eb:	89 f0                	mov    %esi,%eax
  8026ed:	e8 71 ff ff ff       	call   802663 <_pipeisclosed>
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	75 41                	jne    802737 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8026f6:	e8 09 ec ff ff       	call   801304 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8026fb:	8b 43 04             	mov    0x4(%ebx),%eax
  8026fe:	8b 0b                	mov    (%ebx),%ecx
  802700:	8d 51 20             	lea    0x20(%ecx),%edx
  802703:	39 d0                	cmp    %edx,%eax
  802705:	73 e2                	jae    8026e9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802707:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80270a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80270e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802711:	99                   	cltd   
  802712:	c1 ea 1b             	shr    $0x1b,%edx
  802715:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802718:	83 e1 1f             	and    $0x1f,%ecx
  80271b:	29 d1                	sub    %edx,%ecx
  80271d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802721:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802725:	83 c0 01             	add    $0x1,%eax
  802728:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80272b:	83 c7 01             	add    $0x1,%edi
  80272e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802731:	75 c8                	jne    8026fb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802733:	89 f8                	mov    %edi,%eax
  802735:	eb 05                	jmp    80273c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802737:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80273c:	83 c4 1c             	add    $0x1c,%esp
  80273f:	5b                   	pop    %ebx
  802740:	5e                   	pop    %esi
  802741:	5f                   	pop    %edi
  802742:	5d                   	pop    %ebp
  802743:	c3                   	ret    

00802744 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802744:	55                   	push   %ebp
  802745:	89 e5                	mov    %esp,%ebp
  802747:	57                   	push   %edi
  802748:	56                   	push   %esi
  802749:	53                   	push   %ebx
  80274a:	83 ec 1c             	sub    $0x1c,%esp
  80274d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802750:	89 3c 24             	mov    %edi,(%esp)
  802753:	e8 08 f1 ff ff       	call   801860 <fd2data>
  802758:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80275a:	be 00 00 00 00       	mov    $0x0,%esi
  80275f:	eb 3d                	jmp    80279e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802761:	85 f6                	test   %esi,%esi
  802763:	74 04                	je     802769 <devpipe_read+0x25>
				return i;
  802765:	89 f0                	mov    %esi,%eax
  802767:	eb 43                	jmp    8027ac <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802769:	89 da                	mov    %ebx,%edx
  80276b:	89 f8                	mov    %edi,%eax
  80276d:	e8 f1 fe ff ff       	call   802663 <_pipeisclosed>
  802772:	85 c0                	test   %eax,%eax
  802774:	75 31                	jne    8027a7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802776:	e8 89 eb ff ff       	call   801304 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80277b:	8b 03                	mov    (%ebx),%eax
  80277d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802780:	74 df                	je     802761 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802782:	99                   	cltd   
  802783:	c1 ea 1b             	shr    $0x1b,%edx
  802786:	01 d0                	add    %edx,%eax
  802788:	83 e0 1f             	and    $0x1f,%eax
  80278b:	29 d0                	sub    %edx,%eax
  80278d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802792:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802795:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802798:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80279b:	83 c6 01             	add    $0x1,%esi
  80279e:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027a1:	75 d8                	jne    80277b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8027a3:	89 f0                	mov    %esi,%eax
  8027a5:	eb 05                	jmp    8027ac <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8027a7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8027ac:	83 c4 1c             	add    $0x1c,%esp
  8027af:	5b                   	pop    %ebx
  8027b0:	5e                   	pop    %esi
  8027b1:	5f                   	pop    %edi
  8027b2:	5d                   	pop    %ebp
  8027b3:	c3                   	ret    

008027b4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8027b4:	55                   	push   %ebp
  8027b5:	89 e5                	mov    %esp,%ebp
  8027b7:	56                   	push   %esi
  8027b8:	53                   	push   %ebx
  8027b9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8027bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027bf:	89 04 24             	mov    %eax,(%esp)
  8027c2:	e8 b0 f0 ff ff       	call   801877 <fd_alloc>
  8027c7:	89 c2                	mov    %eax,%edx
  8027c9:	85 d2                	test   %edx,%edx
  8027cb:	0f 88 4d 01 00 00    	js     80291e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027d1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027d8:	00 
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027e7:	e8 37 eb ff ff       	call   801323 <sys_page_alloc>
  8027ec:	89 c2                	mov    %eax,%edx
  8027ee:	85 d2                	test   %edx,%edx
  8027f0:	0f 88 28 01 00 00    	js     80291e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8027f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8027f9:	89 04 24             	mov    %eax,(%esp)
  8027fc:	e8 76 f0 ff ff       	call   801877 <fd_alloc>
  802801:	89 c3                	mov    %eax,%ebx
  802803:	85 c0                	test   %eax,%eax
  802805:	0f 88 fe 00 00 00    	js     802909 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80280b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802812:	00 
  802813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802816:	89 44 24 04          	mov    %eax,0x4(%esp)
  80281a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802821:	e8 fd ea ff ff       	call   801323 <sys_page_alloc>
  802826:	89 c3                	mov    %eax,%ebx
  802828:	85 c0                	test   %eax,%eax
  80282a:	0f 88 d9 00 00 00    	js     802909 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	89 04 24             	mov    %eax,(%esp)
  802836:	e8 25 f0 ff ff       	call   801860 <fd2data>
  80283b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80283d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802844:	00 
  802845:	89 44 24 04          	mov    %eax,0x4(%esp)
  802849:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802850:	e8 ce ea ff ff       	call   801323 <sys_page_alloc>
  802855:	89 c3                	mov    %eax,%ebx
  802857:	85 c0                	test   %eax,%eax
  802859:	0f 88 97 00 00 00    	js     8028f6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80285f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802862:	89 04 24             	mov    %eax,(%esp)
  802865:	e8 f6 ef ff ff       	call   801860 <fd2data>
  80286a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802871:	00 
  802872:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802876:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80287d:	00 
  80287e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802882:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802889:	e8 e9 ea ff ff       	call   801377 <sys_page_map>
  80288e:	89 c3                	mov    %eax,%ebx
  802890:	85 c0                	test   %eax,%eax
  802892:	78 52                	js     8028e6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802894:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8028a9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8028af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8028b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	89 04 24             	mov    %eax,(%esp)
  8028c4:	e8 87 ef ff ff       	call   801850 <fd2num>
  8028c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028cc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8028ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d1:	89 04 24             	mov    %eax,(%esp)
  8028d4:	e8 77 ef ff ff       	call   801850 <fd2num>
  8028d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028dc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8028df:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e4:	eb 38                	jmp    80291e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8028e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028f1:	e8 d4 ea ff ff       	call   8013ca <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8028f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802904:	e8 c1 ea ff ff       	call   8013ca <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802910:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802917:	e8 ae ea ff ff       	call   8013ca <sys_page_unmap>
  80291c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80291e:	83 c4 30             	add    $0x30,%esp
  802921:	5b                   	pop    %ebx
  802922:	5e                   	pop    %esi
  802923:	5d                   	pop    %ebp
  802924:	c3                   	ret    

00802925 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802925:	55                   	push   %ebp
  802926:	89 e5                	mov    %esp,%ebp
  802928:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80292b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80292e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802932:	8b 45 08             	mov    0x8(%ebp),%eax
  802935:	89 04 24             	mov    %eax,(%esp)
  802938:	e8 89 ef ff ff       	call   8018c6 <fd_lookup>
  80293d:	89 c2                	mov    %eax,%edx
  80293f:	85 d2                	test   %edx,%edx
  802941:	78 15                	js     802958 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	89 04 24             	mov    %eax,(%esp)
  802949:	e8 12 ef ff ff       	call   801860 <fd2data>
	return _pipeisclosed(fd, p);
  80294e:	89 c2                	mov    %eax,%edx
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	e8 0b fd ff ff       	call   802663 <_pipeisclosed>
}
  802958:	c9                   	leave  
  802959:	c3                   	ret    
  80295a:	66 90                	xchg   %ax,%ax
  80295c:	66 90                	xchg   %ax,%ax
  80295e:	66 90                	xchg   %ax,%ax

00802960 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802960:	55                   	push   %ebp
  802961:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802963:	b8 00 00 00 00       	mov    $0x0,%eax
  802968:	5d                   	pop    %ebp
  802969:	c3                   	ret    

0080296a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80296a:	55                   	push   %ebp
  80296b:	89 e5                	mov    %esp,%ebp
  80296d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802970:	c7 44 24 04 8f 36 80 	movl   $0x80368f,0x4(%esp)
  802977:	00 
  802978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80297b:	89 04 24             	mov    %eax,(%esp)
  80297e:	e8 84 e5 ff ff       	call   800f07 <strcpy>
	return 0;
}
  802983:	b8 00 00 00 00       	mov    $0x0,%eax
  802988:	c9                   	leave  
  802989:	c3                   	ret    

0080298a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80298a:	55                   	push   %ebp
  80298b:	89 e5                	mov    %esp,%ebp
  80298d:	57                   	push   %edi
  80298e:	56                   	push   %esi
  80298f:	53                   	push   %ebx
  802990:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802996:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80299b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8029a1:	eb 31                	jmp    8029d4 <devcons_write+0x4a>
		m = n - tot;
  8029a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8029a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8029a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8029ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8029b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8029b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8029b7:	03 45 0c             	add    0xc(%ebp),%eax
  8029ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029be:	89 3c 24             	mov    %edi,(%esp)
  8029c1:	e8 de e6 ff ff       	call   8010a4 <memmove>
		sys_cputs(buf, m);
  8029c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029ca:	89 3c 24             	mov    %edi,(%esp)
  8029cd:	e8 84 e8 ff ff       	call   801256 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8029d2:	01 f3                	add    %esi,%ebx
  8029d4:	89 d8                	mov    %ebx,%eax
  8029d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8029d9:	72 c8                	jb     8029a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8029db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8029e1:	5b                   	pop    %ebx
  8029e2:	5e                   	pop    %esi
  8029e3:	5f                   	pop    %edi
  8029e4:	5d                   	pop    %ebp
  8029e5:	c3                   	ret    

008029e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8029e6:	55                   	push   %ebp
  8029e7:	89 e5                	mov    %esp,%ebp
  8029e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8029ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8029f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029f5:	75 07                	jne    8029fe <devcons_read+0x18>
  8029f7:	eb 2a                	jmp    802a23 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8029f9:	e8 06 e9 ff ff       	call   801304 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8029fe:	66 90                	xchg   %ax,%ax
  802a00:	e8 6f e8 ff ff       	call   801274 <sys_cgetc>
  802a05:	85 c0                	test   %eax,%eax
  802a07:	74 f0                	je     8029f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	78 16                	js     802a23 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802a0d:	83 f8 04             	cmp    $0x4,%eax
  802a10:	74 0c                	je     802a1e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a15:	88 02                	mov    %al,(%edx)
	return 1;
  802a17:	b8 01 00 00 00       	mov    $0x1,%eax
  802a1c:	eb 05                	jmp    802a23 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802a1e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802a23:	c9                   	leave  
  802a24:	c3                   	ret    

00802a25 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802a25:	55                   	push   %ebp
  802a26:	89 e5                	mov    %esp,%ebp
  802a28:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802a31:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802a38:	00 
  802a39:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a3c:	89 04 24             	mov    %eax,(%esp)
  802a3f:	e8 12 e8 ff ff       	call   801256 <sys_cputs>
}
  802a44:	c9                   	leave  
  802a45:	c3                   	ret    

00802a46 <getchar>:

int
getchar(void)
{
  802a46:	55                   	push   %ebp
  802a47:	89 e5                	mov    %esp,%ebp
  802a49:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802a4c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802a53:	00 
  802a54:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a57:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a62:	e8 f3 f0 ff ff       	call   801b5a <read>
	if (r < 0)
  802a67:	85 c0                	test   %eax,%eax
  802a69:	78 0f                	js     802a7a <getchar+0x34>
		return r;
	if (r < 1)
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	7e 06                	jle    802a75 <getchar+0x2f>
		return -E_EOF;
	return c;
  802a6f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802a73:	eb 05                	jmp    802a7a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802a75:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802a7a:	c9                   	leave  
  802a7b:	c3                   	ret    

00802a7c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a7c:	55                   	push   %ebp
  802a7d:	89 e5                	mov    %esp,%ebp
  802a7f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a85:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	89 04 24             	mov    %eax,(%esp)
  802a8f:	e8 32 ee ff ff       	call   8018c6 <fd_lookup>
  802a94:	85 c0                	test   %eax,%eax
  802a96:	78 11                	js     802aa9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802aa1:	39 10                	cmp    %edx,(%eax)
  802aa3:	0f 94 c0             	sete   %al
  802aa6:	0f b6 c0             	movzbl %al,%eax
}
  802aa9:	c9                   	leave  
  802aaa:	c3                   	ret    

00802aab <opencons>:

int
opencons(void)
{
  802aab:	55                   	push   %ebp
  802aac:	89 e5                	mov    %esp,%ebp
  802aae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802ab1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ab4:	89 04 24             	mov    %eax,(%esp)
  802ab7:	e8 bb ed ff ff       	call   801877 <fd_alloc>
		return r;
  802abc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	78 40                	js     802b02 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802ac2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802ac9:	00 
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ad1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ad8:	e8 46 e8 ff ff       	call   801323 <sys_page_alloc>
		return r;
  802add:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	78 1f                	js     802b02 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802ae3:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802af8:	89 04 24             	mov    %eax,(%esp)
  802afb:	e8 50 ed ff ff       	call   801850 <fd2num>
  802b00:	89 c2                	mov    %eax,%edx
}
  802b02:	89 d0                	mov    %edx,%eax
  802b04:	c9                   	leave  
  802b05:	c3                   	ret    

00802b06 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b06:	55                   	push   %ebp
  802b07:	89 e5                	mov    %esp,%ebp
  802b09:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b0c:	89 d0                	mov    %edx,%eax
  802b0e:	c1 e8 16             	shr    $0x16,%eax
  802b11:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b18:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b1d:	f6 c1 01             	test   $0x1,%cl
  802b20:	74 1d                	je     802b3f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b22:	c1 ea 0c             	shr    $0xc,%edx
  802b25:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b2c:	f6 c2 01             	test   $0x1,%dl
  802b2f:	74 0e                	je     802b3f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b31:	c1 ea 0c             	shr    $0xc,%edx
  802b34:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b3b:	ef 
  802b3c:	0f b7 c0             	movzwl %ax,%eax
}
  802b3f:	5d                   	pop    %ebp
  802b40:	c3                   	ret    
  802b41:	66 90                	xchg   %ax,%ax
  802b43:	66 90                	xchg   %ax,%ax
  802b45:	66 90                	xchg   %ax,%ax
  802b47:	66 90                	xchg   %ax,%ax
  802b49:	66 90                	xchg   %ax,%ax
  802b4b:	66 90                	xchg   %ax,%ax
  802b4d:	66 90                	xchg   %ax,%ax
  802b4f:	90                   	nop

00802b50 <__udivdi3>:
  802b50:	55                   	push   %ebp
  802b51:	57                   	push   %edi
  802b52:	56                   	push   %esi
  802b53:	83 ec 0c             	sub    $0xc,%esp
  802b56:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b5a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802b5e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802b62:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b66:	85 c0                	test   %eax,%eax
  802b68:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802b6c:	89 ea                	mov    %ebp,%edx
  802b6e:	89 0c 24             	mov    %ecx,(%esp)
  802b71:	75 2d                	jne    802ba0 <__udivdi3+0x50>
  802b73:	39 e9                	cmp    %ebp,%ecx
  802b75:	77 61                	ja     802bd8 <__udivdi3+0x88>
  802b77:	85 c9                	test   %ecx,%ecx
  802b79:	89 ce                	mov    %ecx,%esi
  802b7b:	75 0b                	jne    802b88 <__udivdi3+0x38>
  802b7d:	b8 01 00 00 00       	mov    $0x1,%eax
  802b82:	31 d2                	xor    %edx,%edx
  802b84:	f7 f1                	div    %ecx
  802b86:	89 c6                	mov    %eax,%esi
  802b88:	31 d2                	xor    %edx,%edx
  802b8a:	89 e8                	mov    %ebp,%eax
  802b8c:	f7 f6                	div    %esi
  802b8e:	89 c5                	mov    %eax,%ebp
  802b90:	89 f8                	mov    %edi,%eax
  802b92:	f7 f6                	div    %esi
  802b94:	89 ea                	mov    %ebp,%edx
  802b96:	83 c4 0c             	add    $0xc,%esp
  802b99:	5e                   	pop    %esi
  802b9a:	5f                   	pop    %edi
  802b9b:	5d                   	pop    %ebp
  802b9c:	c3                   	ret    
  802b9d:	8d 76 00             	lea    0x0(%esi),%esi
  802ba0:	39 e8                	cmp    %ebp,%eax
  802ba2:	77 24                	ja     802bc8 <__udivdi3+0x78>
  802ba4:	0f bd e8             	bsr    %eax,%ebp
  802ba7:	83 f5 1f             	xor    $0x1f,%ebp
  802baa:	75 3c                	jne    802be8 <__udivdi3+0x98>
  802bac:	8b 74 24 04          	mov    0x4(%esp),%esi
  802bb0:	39 34 24             	cmp    %esi,(%esp)
  802bb3:	0f 86 9f 00 00 00    	jbe    802c58 <__udivdi3+0x108>
  802bb9:	39 d0                	cmp    %edx,%eax
  802bbb:	0f 82 97 00 00 00    	jb     802c58 <__udivdi3+0x108>
  802bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bc8:	31 d2                	xor    %edx,%edx
  802bca:	31 c0                	xor    %eax,%eax
  802bcc:	83 c4 0c             	add    $0xc,%esp
  802bcf:	5e                   	pop    %esi
  802bd0:	5f                   	pop    %edi
  802bd1:	5d                   	pop    %ebp
  802bd2:	c3                   	ret    
  802bd3:	90                   	nop
  802bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bd8:	89 f8                	mov    %edi,%eax
  802bda:	f7 f1                	div    %ecx
  802bdc:	31 d2                	xor    %edx,%edx
  802bde:	83 c4 0c             	add    $0xc,%esp
  802be1:	5e                   	pop    %esi
  802be2:	5f                   	pop    %edi
  802be3:	5d                   	pop    %ebp
  802be4:	c3                   	ret    
  802be5:	8d 76 00             	lea    0x0(%esi),%esi
  802be8:	89 e9                	mov    %ebp,%ecx
  802bea:	8b 3c 24             	mov    (%esp),%edi
  802bed:	d3 e0                	shl    %cl,%eax
  802bef:	89 c6                	mov    %eax,%esi
  802bf1:	b8 20 00 00 00       	mov    $0x20,%eax
  802bf6:	29 e8                	sub    %ebp,%eax
  802bf8:	89 c1                	mov    %eax,%ecx
  802bfa:	d3 ef                	shr    %cl,%edi
  802bfc:	89 e9                	mov    %ebp,%ecx
  802bfe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c02:	8b 3c 24             	mov    (%esp),%edi
  802c05:	09 74 24 08          	or     %esi,0x8(%esp)
  802c09:	89 d6                	mov    %edx,%esi
  802c0b:	d3 e7                	shl    %cl,%edi
  802c0d:	89 c1                	mov    %eax,%ecx
  802c0f:	89 3c 24             	mov    %edi,(%esp)
  802c12:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c16:	d3 ee                	shr    %cl,%esi
  802c18:	89 e9                	mov    %ebp,%ecx
  802c1a:	d3 e2                	shl    %cl,%edx
  802c1c:	89 c1                	mov    %eax,%ecx
  802c1e:	d3 ef                	shr    %cl,%edi
  802c20:	09 d7                	or     %edx,%edi
  802c22:	89 f2                	mov    %esi,%edx
  802c24:	89 f8                	mov    %edi,%eax
  802c26:	f7 74 24 08          	divl   0x8(%esp)
  802c2a:	89 d6                	mov    %edx,%esi
  802c2c:	89 c7                	mov    %eax,%edi
  802c2e:	f7 24 24             	mull   (%esp)
  802c31:	39 d6                	cmp    %edx,%esi
  802c33:	89 14 24             	mov    %edx,(%esp)
  802c36:	72 30                	jb     802c68 <__udivdi3+0x118>
  802c38:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c3c:	89 e9                	mov    %ebp,%ecx
  802c3e:	d3 e2                	shl    %cl,%edx
  802c40:	39 c2                	cmp    %eax,%edx
  802c42:	73 05                	jae    802c49 <__udivdi3+0xf9>
  802c44:	3b 34 24             	cmp    (%esp),%esi
  802c47:	74 1f                	je     802c68 <__udivdi3+0x118>
  802c49:	89 f8                	mov    %edi,%eax
  802c4b:	31 d2                	xor    %edx,%edx
  802c4d:	e9 7a ff ff ff       	jmp    802bcc <__udivdi3+0x7c>
  802c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c58:	31 d2                	xor    %edx,%edx
  802c5a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c5f:	e9 68 ff ff ff       	jmp    802bcc <__udivdi3+0x7c>
  802c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c68:	8d 47 ff             	lea    -0x1(%edi),%eax
  802c6b:	31 d2                	xor    %edx,%edx
  802c6d:	83 c4 0c             	add    $0xc,%esp
  802c70:	5e                   	pop    %esi
  802c71:	5f                   	pop    %edi
  802c72:	5d                   	pop    %ebp
  802c73:	c3                   	ret    
  802c74:	66 90                	xchg   %ax,%ax
  802c76:	66 90                	xchg   %ax,%ax
  802c78:	66 90                	xchg   %ax,%ax
  802c7a:	66 90                	xchg   %ax,%ax
  802c7c:	66 90                	xchg   %ax,%ax
  802c7e:	66 90                	xchg   %ax,%ax

00802c80 <__umoddi3>:
  802c80:	55                   	push   %ebp
  802c81:	57                   	push   %edi
  802c82:	56                   	push   %esi
  802c83:	83 ec 14             	sub    $0x14,%esp
  802c86:	8b 44 24 28          	mov    0x28(%esp),%eax
  802c8a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802c8e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802c92:	89 c7                	mov    %eax,%edi
  802c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c98:	8b 44 24 30          	mov    0x30(%esp),%eax
  802c9c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ca0:	89 34 24             	mov    %esi,(%esp)
  802ca3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ca7:	85 c0                	test   %eax,%eax
  802ca9:	89 c2                	mov    %eax,%edx
  802cab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802caf:	75 17                	jne    802cc8 <__umoddi3+0x48>
  802cb1:	39 fe                	cmp    %edi,%esi
  802cb3:	76 4b                	jbe    802d00 <__umoddi3+0x80>
  802cb5:	89 c8                	mov    %ecx,%eax
  802cb7:	89 fa                	mov    %edi,%edx
  802cb9:	f7 f6                	div    %esi
  802cbb:	89 d0                	mov    %edx,%eax
  802cbd:	31 d2                	xor    %edx,%edx
  802cbf:	83 c4 14             	add    $0x14,%esp
  802cc2:	5e                   	pop    %esi
  802cc3:	5f                   	pop    %edi
  802cc4:	5d                   	pop    %ebp
  802cc5:	c3                   	ret    
  802cc6:	66 90                	xchg   %ax,%ax
  802cc8:	39 f8                	cmp    %edi,%eax
  802cca:	77 54                	ja     802d20 <__umoddi3+0xa0>
  802ccc:	0f bd e8             	bsr    %eax,%ebp
  802ccf:	83 f5 1f             	xor    $0x1f,%ebp
  802cd2:	75 5c                	jne    802d30 <__umoddi3+0xb0>
  802cd4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802cd8:	39 3c 24             	cmp    %edi,(%esp)
  802cdb:	0f 87 e7 00 00 00    	ja     802dc8 <__umoddi3+0x148>
  802ce1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ce5:	29 f1                	sub    %esi,%ecx
  802ce7:	19 c7                	sbb    %eax,%edi
  802ce9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ced:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cf1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802cf5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802cf9:	83 c4 14             	add    $0x14,%esp
  802cfc:	5e                   	pop    %esi
  802cfd:	5f                   	pop    %edi
  802cfe:	5d                   	pop    %ebp
  802cff:	c3                   	ret    
  802d00:	85 f6                	test   %esi,%esi
  802d02:	89 f5                	mov    %esi,%ebp
  802d04:	75 0b                	jne    802d11 <__umoddi3+0x91>
  802d06:	b8 01 00 00 00       	mov    $0x1,%eax
  802d0b:	31 d2                	xor    %edx,%edx
  802d0d:	f7 f6                	div    %esi
  802d0f:	89 c5                	mov    %eax,%ebp
  802d11:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d15:	31 d2                	xor    %edx,%edx
  802d17:	f7 f5                	div    %ebp
  802d19:	89 c8                	mov    %ecx,%eax
  802d1b:	f7 f5                	div    %ebp
  802d1d:	eb 9c                	jmp    802cbb <__umoddi3+0x3b>
  802d1f:	90                   	nop
  802d20:	89 c8                	mov    %ecx,%eax
  802d22:	89 fa                	mov    %edi,%edx
  802d24:	83 c4 14             	add    $0x14,%esp
  802d27:	5e                   	pop    %esi
  802d28:	5f                   	pop    %edi
  802d29:	5d                   	pop    %ebp
  802d2a:	c3                   	ret    
  802d2b:	90                   	nop
  802d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d30:	8b 04 24             	mov    (%esp),%eax
  802d33:	be 20 00 00 00       	mov    $0x20,%esi
  802d38:	89 e9                	mov    %ebp,%ecx
  802d3a:	29 ee                	sub    %ebp,%esi
  802d3c:	d3 e2                	shl    %cl,%edx
  802d3e:	89 f1                	mov    %esi,%ecx
  802d40:	d3 e8                	shr    %cl,%eax
  802d42:	89 e9                	mov    %ebp,%ecx
  802d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d48:	8b 04 24             	mov    (%esp),%eax
  802d4b:	09 54 24 04          	or     %edx,0x4(%esp)
  802d4f:	89 fa                	mov    %edi,%edx
  802d51:	d3 e0                	shl    %cl,%eax
  802d53:	89 f1                	mov    %esi,%ecx
  802d55:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d59:	8b 44 24 10          	mov    0x10(%esp),%eax
  802d5d:	d3 ea                	shr    %cl,%edx
  802d5f:	89 e9                	mov    %ebp,%ecx
  802d61:	d3 e7                	shl    %cl,%edi
  802d63:	89 f1                	mov    %esi,%ecx
  802d65:	d3 e8                	shr    %cl,%eax
  802d67:	89 e9                	mov    %ebp,%ecx
  802d69:	09 f8                	or     %edi,%eax
  802d6b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802d6f:	f7 74 24 04          	divl   0x4(%esp)
  802d73:	d3 e7                	shl    %cl,%edi
  802d75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d79:	89 d7                	mov    %edx,%edi
  802d7b:	f7 64 24 08          	mull   0x8(%esp)
  802d7f:	39 d7                	cmp    %edx,%edi
  802d81:	89 c1                	mov    %eax,%ecx
  802d83:	89 14 24             	mov    %edx,(%esp)
  802d86:	72 2c                	jb     802db4 <__umoddi3+0x134>
  802d88:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802d8c:	72 22                	jb     802db0 <__umoddi3+0x130>
  802d8e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802d92:	29 c8                	sub    %ecx,%eax
  802d94:	19 d7                	sbb    %edx,%edi
  802d96:	89 e9                	mov    %ebp,%ecx
  802d98:	89 fa                	mov    %edi,%edx
  802d9a:	d3 e8                	shr    %cl,%eax
  802d9c:	89 f1                	mov    %esi,%ecx
  802d9e:	d3 e2                	shl    %cl,%edx
  802da0:	89 e9                	mov    %ebp,%ecx
  802da2:	d3 ef                	shr    %cl,%edi
  802da4:	09 d0                	or     %edx,%eax
  802da6:	89 fa                	mov    %edi,%edx
  802da8:	83 c4 14             	add    $0x14,%esp
  802dab:	5e                   	pop    %esi
  802dac:	5f                   	pop    %edi
  802dad:	5d                   	pop    %ebp
  802dae:	c3                   	ret    
  802daf:	90                   	nop
  802db0:	39 d7                	cmp    %edx,%edi
  802db2:	75 da                	jne    802d8e <__umoddi3+0x10e>
  802db4:	8b 14 24             	mov    (%esp),%edx
  802db7:	89 c1                	mov    %eax,%ecx
  802db9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802dbd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802dc1:	eb cb                	jmp    802d8e <__umoddi3+0x10e>
  802dc3:	90                   	nop
  802dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802dc8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802dcc:	0f 82 0f ff ff ff    	jb     802ce1 <__umoddi3+0x61>
  802dd2:	e9 1a ff ff ff       	jmp    802cf1 <__umoddi3+0x71>
