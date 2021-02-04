
obj/net/testinput:     file format elf32-i386


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
  80002c:	e8 0c 09 00 00       	call   80093d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	envid_t ns_envid = sys_getenvid();
  80004c:	e8 54 14 00 00       	call   8014a5 <sys_getenvid>
  800051:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800053:	c7 05 00 40 80 00 40 	movl   $0x803440,0x804000
  80005a:	34 80 00 

	output_envid = fork();
  80005d:	e8 d8 19 00 00       	call   801a3a <fork>
  800062:	a3 04 50 80 00       	mov    %eax,0x805004
	if (output_envid < 0)
  800067:	85 c0                	test   %eax,%eax
  800069:	79 1c                	jns    800087 <umain+0x47>
		panic("error forking");
  80006b:	c7 44 24 08 4a 34 80 	movl   $0x80344a,0x8(%esp)
  800072:	00 
  800073:	c7 44 24 04 4e 00 00 	movl   $0x4e,0x4(%esp)
  80007a:	00 
  80007b:	c7 04 24 58 34 80 00 	movl   $0x803458,(%esp)
  800082:	e8 1b 09 00 00       	call   8009a2 <_panic>
	else if (output_envid == 0) {
  800087:	85 c0                	test   %eax,%eax
  800089:	75 0d                	jne    800098 <umain+0x58>
		output(ns_envid);
  80008b:	89 1c 24             	mov    %ebx,(%esp)
  80008e:	e8 28 05 00 00       	call   8005bb <output>
		return;
  800093:	e9 a5 03 00 00       	jmp    80043d <umain+0x3fd>
	}

	input_envid = fork();
  800098:	e8 9d 19 00 00       	call   801a3a <fork>
  80009d:	a3 00 50 80 00       	mov    %eax,0x805000
	if (input_envid < 0)
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	79 1c                	jns    8000c2 <umain+0x82>
		panic("error forking");
  8000a6:	c7 44 24 08 4a 34 80 	movl   $0x80344a,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  8000b5:	00 
  8000b6:	c7 04 24 58 34 80 00 	movl   $0x803458,(%esp)
  8000bd:	e8 e0 08 00 00       	call   8009a2 <_panic>
	else if (input_envid == 0) {
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	75 0f                	jne    8000d5 <umain+0x95>
		input(ns_envid);
  8000c6:	89 1c 24             	mov    %ebx,(%esp)
  8000c9:	e8 52 04 00 00       	call   800520 <input>
		return;
  8000ce:	66 90                	xchg   %ax,%ax
  8000d0:	e9 68 03 00 00       	jmp    80043d <umain+0x3fd>
	}

	cprintf("Sending ARP announcement...\n");
  8000d5:	c7 04 24 68 34 80 00 	movl   $0x803468,(%esp)
  8000dc:	e8 ba 09 00 00       	call   800a9b <cprintf>
	// for this, but QEMU's ARP implementation is dumb and only
	// listens for very specific ARP requests, such as requests
	// for the gateway IP.

	//uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
	uint8_t mac[6] = {0x00, 0x11, 0x22, 0x33, 0x44, 0x00};
  8000e1:	c6 45 98 00          	movb   $0x0,-0x68(%ebp)
  8000e5:	c6 45 99 11          	movb   $0x11,-0x67(%ebp)
  8000e9:	c6 45 9a 22          	movb   $0x22,-0x66(%ebp)
  8000ed:	c6 45 9b 33          	movb   $0x33,-0x65(%ebp)
  8000f1:	c6 45 9c 44          	movb   $0x44,-0x64(%ebp)
  8000f5:	c6 45 9d 00          	movb   $0x0,-0x63(%ebp)
	uint32_t myip = inet_addr(IP);
  8000f9:	c7 04 24 85 34 80 00 	movl   $0x803485,(%esp)
  800100:	e8 00 08 00 00       	call   800905 <inet_addr>
  800105:	89 45 90             	mov    %eax,-0x70(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  800108:	c7 04 24 8f 34 80 00 	movl   $0x80348f,(%esp)
  80010f:	e8 f1 07 00 00       	call   800905 <inet_addr>
  800114:	89 45 94             	mov    %eax,-0x6c(%ebp)
	int r;

	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800117:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  800126:	0f 
  800127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80012e:	e8 b0 13 00 00       	call   8014e3 <sys_page_alloc>
  800133:	85 c0                	test   %eax,%eax
  800135:	79 20                	jns    800157 <umain+0x117>
		panic("sys_page_map: %e", r);
  800137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013b:	c7 44 24 08 98 34 80 	movl   $0x803498,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  80014a:	00 
  80014b:	c7 04 24 58 34 80 00 	movl   $0x803458,(%esp)
  800152:	e8 4b 08 00 00       	call   8009a2 <_panic>

	struct etharp_hdr *arp = (struct etharp_hdr*)pkt->jp_data;
	pkt->jp_len = sizeof(*arp);
  800157:	c7 05 00 b0 fe 0f 2a 	movl   $0x2a,0xffeb000
  80015e:	00 00 00 

	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  800161:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800168:	00 
  800169:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800170:	00 
  800171:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  800178:	e8 9a 10 00 00       	call   801217 <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  80017d:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800184:	00 
  800185:	8d 5d 98             	lea    -0x68(%ebp),%ebx
  800188:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80018c:	c7 04 24 0a b0 fe 0f 	movl   $0xffeb00a,(%esp)
  800193:	e8 34 11 00 00       	call   8012cc <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  800198:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  80019f:	e8 32 05 00 00       	call   8006d6 <htons>
  8001a4:	66 a3 10 b0 fe 0f    	mov    %ax,0xffeb010
	arp->hwtype = htons(1); // Ethernet
  8001aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001b1:	e8 20 05 00 00       	call   8006d6 <htons>
  8001b6:	66 a3 12 b0 fe 0f    	mov    %ax,0xffeb012
	arp->proto = htons(ETHTYPE_IP);
  8001bc:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  8001c3:	e8 0e 05 00 00       	call   8006d6 <htons>
  8001c8:	66 a3 14 b0 fe 0f    	mov    %ax,0xffeb014
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001ce:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  8001d5:	e8 fc 04 00 00       	call   8006d6 <htons>
  8001da:	66 a3 16 b0 fe 0f    	mov    %ax,0xffeb016
	arp->opcode = htons(ARP_REQUEST);
  8001e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001e7:	e8 ea 04 00 00       	call   8006d6 <htons>
  8001ec:	66 a3 18 b0 fe 0f    	mov    %ax,0xffeb018
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  8001f2:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8001f9:	00 
  8001fa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001fe:	c7 04 24 1a b0 fe 0f 	movl   $0xffeb01a,(%esp)
  800205:	e8 c2 10 00 00       	call   8012cc <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  80020a:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800211:	00 
  800212:	8d 45 90             	lea    -0x70(%ebp),%eax
  800215:	89 44 24 04          	mov    %eax,0x4(%esp)
  800219:	c7 04 24 20 b0 fe 0f 	movl   $0xffeb020,(%esp)
  800220:	e8 a7 10 00 00       	call   8012cc <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  800225:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  80022c:	00 
  80022d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800234:	00 
  800235:	c7 04 24 24 b0 fe 0f 	movl   $0xffeb024,(%esp)
  80023c:	e8 d6 0f 00 00       	call   801217 <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  800241:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800248:	00 
  800249:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80024c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800250:	c7 04 24 2a b0 fe 0f 	movl   $0xffeb02a,(%esp)
  800257:	e8 70 10 00 00       	call   8012cc <memcpy>

	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  80025c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800263:	00 
  800264:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  80026b:	0f 
  80026c:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800273:	00 
  800274:	a1 04 50 80 00       	mov    0x805004,%eax
  800279:	89 04 24             	mov    %eax,(%esp)
  80027c:	e8 e3 1a 00 00       	call   801d64 <ipc_send>
	sys_page_unmap(0, pkt);
  800281:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  800288:	0f 
  800289:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800290:	e8 f5 12 00 00       	call   80158a <sys_page_unmap>

void
umain(int argc, char **argv)
{
	envid_t ns_envid = sys_getenvid();
	int i, r, first = 1;
  800295:	c7 85 7c ff ff ff 01 	movl   $0x1,-0x84(%ebp)
  80029c:	00 00 00 

	while (1) {
		envid_t whom;
		int perm;

		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  80029f:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8002a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a6:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  8002ad:	0f 
  8002ae:	8d 45 90             	lea    -0x70(%ebp),%eax
  8002b1:	89 04 24             	mov    %eax,(%esp)
  8002b4:	e8 57 1a 00 00       	call   801d10 <ipc_recv>
		if (req < 0)
  8002b9:	85 c0                	test   %eax,%eax
  8002bb:	79 20                	jns    8002dd <umain+0x29d>
			panic("ipc_recv: %e", req);
  8002bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002c1:	c7 44 24 08 a9 34 80 	movl   $0x8034a9,0x8(%esp)
  8002c8:	00 
  8002c9:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
  8002d0:	00 
  8002d1:	c7 04 24 58 34 80 00 	movl   $0x803458,(%esp)
  8002d8:	e8 c5 06 00 00       	call   8009a2 <_panic>
		if (whom != input_envid)
  8002dd:	8b 55 90             	mov    -0x70(%ebp),%edx
  8002e0:	3b 15 00 50 80 00    	cmp    0x805000,%edx
  8002e6:	74 20                	je     800308 <umain+0x2c8>
			panic("IPC from unexpected environment %08x", whom);
  8002e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002ec:	c7 44 24 08 00 35 80 	movl   $0x803500,0x8(%esp)
  8002f3:	00 
  8002f4:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  8002fb:	00 
  8002fc:	c7 04 24 58 34 80 00 	movl   $0x803458,(%esp)
  800303:	e8 9a 06 00 00       	call   8009a2 <_panic>
		if (req != NSREQ_INPUT)
  800308:	83 f8 0a             	cmp    $0xa,%eax
  80030b:	74 20                	je     80032d <umain+0x2ed>
			panic("Unexpected IPC %d", req);
  80030d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800311:	c7 44 24 08 b6 34 80 	movl   $0x8034b6,0x8(%esp)
  800318:	00 
  800319:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
  800320:	00 
  800321:	c7 04 24 58 34 80 00 	movl   $0x803458,(%esp)
  800328:	e8 75 06 00 00       	call   8009a2 <_panic>

		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  80032d:	a1 00 b0 fe 0f       	mov    0xffeb000,%eax
  800332:	89 45 84             	mov    %eax,-0x7c(%ebp)
hexdump(const char *prefix, const void *data, int len)
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
  800335:	be 00 00 00 00       	mov    $0x0,%esi
	for (i = 0; i < len; i++) {
  80033a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (i % 16 == 0)
			out = buf + snprintf(buf, end - buf,
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
		if (i % 16 == 15 || i == len - 1)
  80033f:	83 e8 01             	sub    $0x1,%eax
  800342:	89 45 80             	mov    %eax,-0x80(%ebp)
  800345:	e9 ba 00 00 00       	jmp    800404 <umain+0x3c4>
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
		if (i % 16 == 0)
  80034a:	89 df                	mov    %ebx,%edi
  80034c:	f6 c3 0f             	test   $0xf,%bl
  80034f:	75 2d                	jne    80037e <umain+0x33e>
			out = buf + snprintf(buf, end - buf,
  800351:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800355:	c7 44 24 0c c8 34 80 	movl   $0x8034c8,0xc(%esp)
  80035c:	00 
  80035d:	c7 44 24 08 d0 34 80 	movl   $0x8034d0,0x8(%esp)
  800364:	00 
  800365:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  80036c:	00 
  80036d:	8d 45 98             	lea    -0x68(%ebp),%eax
  800370:	89 04 24             	mov    %eax,(%esp)
  800373:	e8 e2 0c 00 00       	call   80105a <snprintf>
  800378:	8d 4d 98             	lea    -0x68(%ebp),%ecx
  80037b:	8d 34 01             	lea    (%ecx,%eax,1),%esi
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  80037e:	b8 04 b0 fe 0f       	mov    $0xffeb004,%eax
  800383:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
  800387:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80038b:	c7 44 24 08 da 34 80 	movl   $0x8034da,0x8(%esp)
  800392:	00 
  800393:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800396:	29 f0                	sub    %esi,%eax
  800398:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039c:	89 34 24             	mov    %esi,(%esp)
  80039f:	e8 b6 0c 00 00       	call   80105a <snprintf>
  8003a4:	01 c6                	add    %eax,%esi
		if (i % 16 == 15 || i == len - 1)
  8003a6:	89 d8                	mov    %ebx,%eax
  8003a8:	c1 f8 1f             	sar    $0x1f,%eax
  8003ab:	c1 e8 1c             	shr    $0x1c,%eax
  8003ae:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
  8003b1:	83 e7 0f             	and    $0xf,%edi
  8003b4:	29 c7                	sub    %eax,%edi
  8003b6:	83 ff 0f             	cmp    $0xf,%edi
  8003b9:	74 05                	je     8003c0 <umain+0x380>
  8003bb:	3b 5d 80             	cmp    -0x80(%ebp),%ebx
  8003be:	75 1e                	jne    8003de <umain+0x39e>
			cprintf("%.*s\n", out - buf, buf);
  8003c0:	8d 45 98             	lea    -0x68(%ebp),%eax
  8003c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003c7:	89 f0                	mov    %esi,%eax
  8003c9:	8d 4d 98             	lea    -0x68(%ebp),%ecx
  8003cc:	29 c8                	sub    %ecx,%eax
  8003ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d2:	c7 04 24 df 34 80 00 	movl   $0x8034df,(%esp)
  8003d9:	e8 bd 06 00 00       	call   800a9b <cprintf>
		if (i % 2 == 1)
  8003de:	89 d8                	mov    %ebx,%eax
  8003e0:	c1 e8 1f             	shr    $0x1f,%eax
  8003e3:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8003e6:	83 e2 01             	and    $0x1,%edx
  8003e9:	29 c2                	sub    %eax,%edx
  8003eb:	83 fa 01             	cmp    $0x1,%edx
  8003ee:	75 06                	jne    8003f6 <umain+0x3b6>
			*(out++) = ' ';
  8003f0:	c6 06 20             	movb   $0x20,(%esi)
  8003f3:	8d 76 01             	lea    0x1(%esi),%esi
		if (i % 16 == 7)
  8003f6:	83 ff 07             	cmp    $0x7,%edi
  8003f9:	75 06                	jne    800401 <umain+0x3c1>
			*(out++) = ' ';
  8003fb:	c6 06 20             	movb   $0x20,(%esi)
  8003fe:	8d 76 01             	lea    0x1(%esi),%esi
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
  800401:	83 c3 01             	add    $0x1,%ebx
  800404:	39 5d 84             	cmp    %ebx,-0x7c(%ebp)
  800407:	0f 8f 3d ff ff ff    	jg     80034a <umain+0x30a>
			panic("IPC from unexpected environment %08x", whom);
		if (req != NSREQ_INPUT)
			panic("Unexpected IPC %d", req);

		hexdump("input: ", pkt->jp_data, pkt->jp_len);
		cprintf("\n");
  80040d:	c7 04 24 fb 34 80 00 	movl   $0x8034fb,(%esp)
  800414:	e8 82 06 00 00       	call   800a9b <cprintf>

		// Only indicate that we're waiting for packets once
		// we've received the ARP reply
		if (first)
  800419:	83 bd 7c ff ff ff 00 	cmpl   $0x0,-0x84(%ebp)
  800420:	74 0c                	je     80042e <umain+0x3ee>
			cprintf("Waiting for packets...\n");
  800422:	c7 04 24 e5 34 80 00 	movl   $0x8034e5,(%esp)
  800429:	e8 6d 06 00 00       	call   800a9b <cprintf>
		first = 0;
  80042e:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  800435:	00 00 00 
	}
  800438:	e9 62 fe ff ff       	jmp    80029f <umain+0x25f>
}
  80043d:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  800443:	5b                   	pop    %ebx
  800444:	5e                   	pop    %esi
  800445:	5f                   	pop    %edi
  800446:	5d                   	pop    %ebp
  800447:	c3                   	ret    
  800448:	66 90                	xchg   %ax,%ax
  80044a:	66 90                	xchg   %ax,%ax
  80044c:	66 90                	xchg   %ax,%ax
  80044e:	66 90                	xchg   %ax,%ax

00800450 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	57                   	push   %edi
  800454:	56                   	push   %esi
  800455:	53                   	push   %ebx
  800456:	83 ec 2c             	sub    $0x2c,%esp
  800459:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  80045c:	e8 ea 12 00 00       	call   80174b <sys_time_msec>
  800461:	03 45 0c             	add    0xc(%ebp),%eax
  800464:	89 c6                	mov    %eax,%esi

	binaryname = "ns_timer";
  800466:	c7 05 00 40 80 00 25 	movl   $0x803525,0x804000
  80046d:	35 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800470:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800473:	eb 05                	jmp    80047a <timer+0x2a>

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
			sys_yield();
  800475:	e8 4a 10 00 00       	call   8014c4 <sys_yield>
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  80047a:	e8 cc 12 00 00       	call   80174b <sys_time_msec>
  80047f:	39 c6                	cmp    %eax,%esi
  800481:	76 06                	jbe    800489 <timer+0x39>
  800483:	85 c0                	test   %eax,%eax
  800485:	79 ee                	jns    800475 <timer+0x25>
  800487:	eb 09                	jmp    800492 <timer+0x42>
			sys_yield();
		}
		if (r < 0)
  800489:	85 c0                	test   %eax,%eax
  80048b:	90                   	nop
  80048c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800490:	79 20                	jns    8004b2 <timer+0x62>
			panic("sys_time_msec: %e", r);
  800492:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800496:	c7 44 24 08 2e 35 80 	movl   $0x80352e,0x8(%esp)
  80049d:	00 
  80049e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8004a5:	00 
  8004a6:	c7 04 24 40 35 80 00 	movl   $0x803540,(%esp)
  8004ad:	e8 f0 04 00 00       	call   8009a2 <_panic>

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8004b2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004b9:	00 
  8004ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004c1:	00 
  8004c2:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  8004c9:	00 
  8004ca:	89 1c 24             	mov    %ebx,(%esp)
  8004cd:	e8 92 18 00 00       	call   801d64 <ipc_send>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8004d2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004d9:	00 
  8004da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004e1:	00 
  8004e2:	89 3c 24             	mov    %edi,(%esp)
  8004e5:	e8 26 18 00 00       	call   801d10 <ipc_recv>
  8004ea:	89 c6                	mov    %eax,%esi

			if (whom != ns_envid) {
  8004ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004ef:	39 c3                	cmp    %eax,%ebx
  8004f1:	74 12                	je     800505 <timer+0xb5>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8004f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f7:	c7 04 24 4c 35 80 00 	movl   $0x80354c,(%esp)
  8004fe:	e8 98 05 00 00       	call   800a9b <cprintf>
  800503:	eb cd                	jmp    8004d2 <timer+0x82>
				continue;
			}

			stop = sys_time_msec() + to;
  800505:	e8 41 12 00 00       	call   80174b <sys_time_msec>
  80050a:	01 c6                	add    %eax,%esi
  80050c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800510:	e9 65 ff ff ff       	jmp    80047a <timer+0x2a>
  800515:	66 90                	xchg   %ax,%ax
  800517:	66 90                	xchg   %ax,%ax
  800519:	66 90                	xchg   %ax,%ax
  80051b:	66 90                	xchg   %ax,%ax
  80051d:	66 90                	xchg   %ax,%ax
  80051f:	90                   	nop

00800520 <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  800520:	55                   	push   %ebp
  800521:	89 e5                	mov    %esp,%ebp
  800523:	57                   	push   %edi
  800524:	56                   	push   %esi
  800525:	53                   	push   %ebx
  800526:	81 ec 2c 08 00 00    	sub    $0x82c,%esp
	binaryname = "ns_input";
  80052c:	c7 05 00 40 80 00 87 	movl   $0x803587,0x804000
  800533:	35 80 00 
	char buf[PKT_MAX_SIZE];
	int err;

	while(1)
	{
		err = sys_pkt_recv(buf, &len);
  800536:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800539:	8d b5 e4 f7 ff ff    	lea    -0x81c(%ebp),%esi
  80053f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800543:	89 34 24             	mov    %esi,(%esp)
  800546:	e8 c5 12 00 00       	call   801810 <sys_pkt_recv>
		if(err != 0)
  80054b:	85 c0                	test   %eax,%eax
  80054d:	74 0e                	je     80055d <input+0x3d>
		{
			sys_sleep(ENV_CHANNEL_RX);
  80054f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800556:	e8 08 13 00 00       	call   801863 <sys_sleep>
			continue;
  80055b:	eb e2                	jmp    80053f <input+0x1f>
		}

		nsipcbuf.pkt.jp_len = len;
  80055d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800560:	a3 00 70 80 00       	mov    %eax,0x807000
		memcpy(nsipcbuf.pkt.jp_data, buf, len);
  800565:	89 44 24 08          	mov    %eax,0x8(%esp)
  800569:	89 74 24 04          	mov    %esi,0x4(%esp)
  80056d:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  800574:	e8 53 0d 00 00       	call   8012cc <memcpy>
		
		ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800579:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800580:	00 
  800581:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  800588:	00 
  800589:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800590:	00 
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	89 04 24             	mov    %eax,(%esp)
  800597:	e8 c8 17 00 00       	call   801d64 <ipc_send>

		// Waiting for some time
		unsigned wait = sys_time_msec() + 50;
  80059c:	e8 aa 11 00 00       	call   80174b <sys_time_msec>
  8005a1:	8d 58 32             	lea    0x32(%eax),%ebx
		while (sys_time_msec() < wait){
  8005a4:	eb 05                	jmp    8005ab <input+0x8b>
			sys_yield();
  8005a6:	e8 19 0f 00 00       	call   8014c4 <sys_yield>
		
		ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U);

		// Waiting for some time
		unsigned wait = sys_time_msec() + 50;
		while (sys_time_msec() < wait){
  8005ab:	90                   	nop
  8005ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8005b0:	e8 96 11 00 00       	call   80174b <sys_time_msec>
  8005b5:	39 c3                	cmp    %eax,%ebx
  8005b7:	77 ed                	ja     8005a6 <input+0x86>
  8005b9:	eb 84                	jmp    80053f <input+0x1f>

008005bb <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
  8005be:	56                   	push   %esi
  8005bf:	53                   	push   %ebx
  8005c0:	83 ec 20             	sub    $0x20,%esp
	binaryname = "ns_output";
  8005c3:	c7 05 00 40 80 00 90 	movl   $0x803590,0x804000
  8005ca:	35 80 00 
	envid_t envid;
	int32_t res;
	int err;
	while(1)
	{		
		res = ipc_recv(&envid, &nsipcbuf, &p);
  8005cd:	8d 75 f4             	lea    -0xc(%ebp),%esi
  8005d0:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  8005d3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8005d7:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8005de:	00 
  8005df:	89 1c 24             	mov    %ebx,(%esp)
  8005e2:	e8 29 17 00 00       	call   801d10 <ipc_recv>
		if(res != NSREQ_OUTPUT)
  8005e7:	83 f8 0b             	cmp    $0xb,%eax
  8005ea:	75 e7                	jne    8005d3 <output+0x18>
			continue;

		if(!(p & PTE_P))
  8005ec:	f6 45 f4 01          	testb  $0x1,-0xc(%ebp)
  8005f0:	74 e1                	je     8005d3 <output+0x18>
			continue;
		
		while (1) {
			err = sys_pkt_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
  8005f2:	a1 00 70 80 00       	mov    0x807000,%eax
  8005f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005fb:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  800602:	e8 b6 11 00 00       	call   8017bd <sys_pkt_send>

			if(err == 0)
  800607:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  80060c:	74 c5                	je     8005d3 <output+0x18>
				break;

			if(err == E_PACKET_TOO_BIG)
				break;

			sys_sleep(ENV_CHANNEL_TX);
  80060e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800615:	e8 49 12 00 00       	call   801863 <sys_sleep>
		}
  80061a:	eb d6                	jmp    8005f2 <output+0x37>
  80061c:	66 90                	xchg   %ax,%ax
  80061e:	66 90                	xchg   %ax,%ax

00800620 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800620:	55                   	push   %ebp
  800621:	89 e5                	mov    %esp,%ebp
  800623:	57                   	push   %edi
  800624:	56                   	push   %esi
  800625:	53                   	push   %ebx
  800626:	83 ec 19             	sub    $0x19,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800629:	8b 45 08             	mov    0x8(%ebp),%eax
  80062c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80062f:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800633:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  800636:	c7 45 dc 08 50 80 00 	movl   $0x805008,-0x24(%ebp)
 */
char *
inet_ntoa(struct in_addr addr)
{
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80063d:	be 00 00 00 00       	mov    $0x0,%esi
  800642:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800645:	eb 02                	jmp    800649 <inet_ntoa+0x29>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800647:	89 ce                	mov    %ecx,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800649:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80064c:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  80064f:	0f b6 c2             	movzbl %dl,%eax
  800652:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  800655:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
  800658:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80065b:	66 c1 e8 0b          	shr    $0xb,%ax
  80065f:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  800661:	8d 4e 01             	lea    0x1(%esi),%ecx
  800664:	89 f3                	mov    %esi,%ebx
  800666:	0f b6 f3             	movzbl %bl,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800669:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  80066c:	01 ff                	add    %edi,%edi
  80066e:	89 fb                	mov    %edi,%ebx
  800670:	29 da                	sub    %ebx,%edx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
  800672:	83 c2 30             	add    $0x30,%edx
  800675:	88 54 35 ed          	mov    %dl,-0x13(%ebp,%esi,1)
    } while(*ap);
  800679:	84 c0                	test   %al,%al
  80067b:	75 ca                	jne    800647 <inet_ntoa+0x27>
  80067d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800680:	89 c8                	mov    %ecx,%eax
  800682:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800685:	89 cf                	mov    %ecx,%edi
  800687:	eb 0d                	jmp    800696 <inet_ntoa+0x76>
    while(i--)
      *rp++ = inv[i];
  800689:	0f b6 f0             	movzbl %al,%esi
  80068c:	0f b6 4c 35 ed       	movzbl -0x13(%ebp,%esi,1),%ecx
  800691:	88 0a                	mov    %cl,(%edx)
  800693:	83 c2 01             	add    $0x1,%edx
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  800696:	83 e8 01             	sub    $0x1,%eax
  800699:	3c ff                	cmp    $0xff,%al
  80069b:	75 ec                	jne    800689 <inet_ntoa+0x69>
  80069d:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  8006a0:	89 f9                	mov    %edi,%ecx
  8006a2:	0f b6 c9             	movzbl %cl,%ecx
  8006a5:	03 4d dc             	add    -0x24(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  8006a8:	8d 41 01             	lea    0x1(%ecx),%eax
  8006ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
    ap++;
  8006ae:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8006b2:	80 45 db 01          	addb   $0x1,-0x25(%ebp)
  8006b6:	80 7d db 03          	cmpb   $0x3,-0x25(%ebp)
  8006ba:	77 0a                	ja     8006c6 <inet_ntoa+0xa6>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  8006bc:	c6 01 2e             	movb   $0x2e,(%ecx)
  8006bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c4:	eb 81                	jmp    800647 <inet_ntoa+0x27>
    ap++;
  }
  *--rp = 0;
  8006c6:	c6 01 00             	movb   $0x0,(%ecx)
  return str;
}
  8006c9:	b8 08 50 80 00       	mov    $0x805008,%eax
  8006ce:	83 c4 19             	add    $0x19,%esp
  8006d1:	5b                   	pop    %ebx
  8006d2:	5e                   	pop    %esi
  8006d3:	5f                   	pop    %edi
  8006d4:	5d                   	pop    %ebp
  8006d5:	c3                   	ret    

008006d6 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8006d6:	55                   	push   %ebp
  8006d7:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8006d9:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8006dd:	66 c1 c0 08          	rol    $0x8,%ax
}
  8006e1:	5d                   	pop    %ebp
  8006e2:	c3                   	ret    

008006e3 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8006e6:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8006ea:	66 c1 c0 08          	rol    $0x8,%ax
 */
u16_t
ntohs(u16_t n)
{
  return htons(n);
}
  8006ee:	5d                   	pop    %ebp
  8006ef:	c3                   	ret    

008006f0 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8006f6:	89 d1                	mov    %edx,%ecx
  8006f8:	c1 e9 18             	shr    $0x18,%ecx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8006fb:	89 d0                	mov    %edx,%eax
  8006fd:	c1 e0 18             	shl    $0x18,%eax
  800700:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800702:	89 d1                	mov    %edx,%ecx
  800704:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  80070a:	c1 e1 08             	shl    $0x8,%ecx
  80070d:	09 c8                	or     %ecx,%eax
    ((n & 0xff0000UL) >> 8) |
  80070f:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  800715:	c1 ea 08             	shr    $0x8,%edx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  800718:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80071a:	5d                   	pop    %ebp
  80071b:	c3                   	ret    

0080071c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80071c:	55                   	push   %ebp
  80071d:	89 e5                	mov    %esp,%ebp
  80071f:	57                   	push   %edi
  800720:	56                   	push   %esi
  800721:	53                   	push   %ebx
  800722:	83 ec 20             	sub    $0x20,%esp
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  800728:	0f be 10             	movsbl (%eax),%edx
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80072b:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80072e:	89 75 d8             	mov    %esi,-0x28(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800731:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800734:	80 f9 09             	cmp    $0x9,%cl
  800737:	0f 87 a6 01 00 00    	ja     8008e3 <inet_aton+0x1c7>
      return (0);
    val = 0;
    base = 10;
  80073d:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
    if (c == '0') {
  800744:	83 fa 30             	cmp    $0x30,%edx
  800747:	75 2b                	jne    800774 <inet_aton+0x58>
      c = *++cp;
  800749:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80074d:	89 d1                	mov    %edx,%ecx
  80074f:	83 e1 df             	and    $0xffffffdf,%ecx
  800752:	80 f9 58             	cmp    $0x58,%cl
  800755:	74 0f                	je     800766 <inet_aton+0x4a>
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
  800757:	83 c0 01             	add    $0x1,%eax
  80075a:	0f be d2             	movsbl %dl,%edx
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
      } else
        base = 8;
  80075d:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  800764:	eb 0e                	jmp    800774 <inet_aton+0x58>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  800766:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80076a:	8d 40 02             	lea    0x2(%eax),%eax
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  80076d:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  800774:	83 c0 01             	add    $0x1,%eax
  800777:	bf 00 00 00 00       	mov    $0x0,%edi
  80077c:	eb 03                	jmp    800781 <inet_aton+0x65>
  80077e:	83 c0 01             	add    $0x1,%eax
  800781:	8d 70 ff             	lea    -0x1(%eax),%esi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  800784:	89 d3                	mov    %edx,%ebx
  800786:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800789:	80 f9 09             	cmp    $0x9,%cl
  80078c:	77 0d                	ja     80079b <inet_aton+0x7f>
        val = (val * base) + (int)(c - '0');
  80078e:	0f af 7d e0          	imul   -0x20(%ebp),%edi
  800792:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800796:	0f be 10             	movsbl (%eax),%edx
  800799:	eb e3                	jmp    80077e <inet_aton+0x62>
      } else if (base == 16 && isxdigit(c)) {
  80079b:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  80079f:	75 30                	jne    8007d1 <inet_aton+0xb5>
  8007a1:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  8007a4:	88 4d df             	mov    %cl,-0x21(%ebp)
  8007a7:	89 d1                	mov    %edx,%ecx
  8007a9:	83 e1 df             	and    $0xffffffdf,%ecx
  8007ac:	83 e9 41             	sub    $0x41,%ecx
  8007af:	80 f9 05             	cmp    $0x5,%cl
  8007b2:	77 23                	ja     8007d7 <inet_aton+0xbb>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8007b4:	89 fb                	mov    %edi,%ebx
  8007b6:	c1 e3 04             	shl    $0x4,%ebx
  8007b9:	8d 7a 0a             	lea    0xa(%edx),%edi
  8007bc:	80 7d df 1a          	cmpb   $0x1a,-0x21(%ebp)
  8007c0:	19 c9                	sbb    %ecx,%ecx
  8007c2:	83 e1 20             	and    $0x20,%ecx
  8007c5:	83 c1 41             	add    $0x41,%ecx
  8007c8:	29 cf                	sub    %ecx,%edi
  8007ca:	09 df                	or     %ebx,%edi
        c = *++cp;
  8007cc:	0f be 10             	movsbl (%eax),%edx
  8007cf:	eb ad                	jmp    80077e <inet_aton+0x62>
  8007d1:	89 d0                	mov    %edx,%eax
  8007d3:	89 f9                	mov    %edi,%ecx
  8007d5:	eb 04                	jmp    8007db <inet_aton+0xbf>
  8007d7:	89 d0                	mov    %edx,%eax
  8007d9:	89 f9                	mov    %edi,%ecx
      } else
        break;
    }
    if (c == '.') {
  8007db:	83 f8 2e             	cmp    $0x2e,%eax
  8007de:	75 22                	jne    800802 <inet_aton+0xe6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8007e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007e3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8007e6:	0f 84 fe 00 00 00    	je     8008ea <inet_aton+0x1ce>
        return (0);
      *pp++ = val;
  8007ec:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  8007f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007f3:	89 48 fc             	mov    %ecx,-0x4(%eax)
      c = *++cp;
  8007f6:	8d 46 01             	lea    0x1(%esi),%eax
  8007f9:	0f be 56 01          	movsbl 0x1(%esi),%edx
    } else
      break;
  }
  8007fd:	e9 2f ff ff ff       	jmp    800731 <inet_aton+0x15>
  800802:	89 f9                	mov    %edi,%ecx
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800804:	85 d2                	test   %edx,%edx
  800806:	74 27                	je     80082f <inet_aton+0x113>
    return (0);
  800808:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80080d:	80 fb 1f             	cmp    $0x1f,%bl
  800810:	0f 86 e7 00 00 00    	jbe    8008fd <inet_aton+0x1e1>
  800816:	84 d2                	test   %dl,%dl
  800818:	0f 88 d3 00 00 00    	js     8008f1 <inet_aton+0x1d5>
  80081e:	83 fa 20             	cmp    $0x20,%edx
  800821:	74 0c                	je     80082f <inet_aton+0x113>
  800823:	83 ea 09             	sub    $0x9,%edx
  800826:	83 fa 04             	cmp    $0x4,%edx
  800829:	0f 87 ce 00 00 00    	ja     8008fd <inet_aton+0x1e1>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80082f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800832:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800835:	29 c2                	sub    %eax,%edx
  800837:	c1 fa 02             	sar    $0x2,%edx
  80083a:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80083d:	83 fa 02             	cmp    $0x2,%edx
  800840:	74 22                	je     800864 <inet_aton+0x148>
  800842:	83 fa 02             	cmp    $0x2,%edx
  800845:	7f 0f                	jg     800856 <inet_aton+0x13a>

  case 0:
    return (0);       /* initial nondigit */
  800847:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  80084c:	85 d2                	test   %edx,%edx
  80084e:	0f 84 a9 00 00 00    	je     8008fd <inet_aton+0x1e1>
  800854:	eb 73                	jmp    8008c9 <inet_aton+0x1ad>
  800856:	83 fa 03             	cmp    $0x3,%edx
  800859:	74 26                	je     800881 <inet_aton+0x165>
  80085b:	83 fa 04             	cmp    $0x4,%edx
  80085e:	66 90                	xchg   %ax,%ax
  800860:	74 40                	je     8008a2 <inet_aton+0x186>
  800862:	eb 65                	jmp    8008c9 <inet_aton+0x1ad>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  800864:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  800869:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  80086f:	0f 87 88 00 00 00    	ja     8008fd <inet_aton+0x1e1>
      return (0);
    val |= parts[0] << 24;
  800875:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800878:	c1 e0 18             	shl    $0x18,%eax
  80087b:	89 cf                	mov    %ecx,%edi
  80087d:	09 c7                	or     %eax,%edi
    break;
  80087f:	eb 48                	jmp    8008c9 <inet_aton+0x1ad>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  800881:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  800886:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  80088c:	77 6f                	ja     8008fd <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  80088e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800891:	c1 e2 10             	shl    $0x10,%edx
  800894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800897:	c1 e0 18             	shl    $0x18,%eax
  80089a:	09 d0                	or     %edx,%eax
  80089c:	09 c8                	or     %ecx,%eax
  80089e:	89 c7                	mov    %eax,%edi
    break;
  8008a0:	eb 27                	jmp    8008c9 <inet_aton+0x1ad>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  8008a2:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8008a7:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
  8008ad:	77 4e                	ja     8008fd <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8008af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008b2:	c1 e2 10             	shl    $0x10,%edx
  8008b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008b8:	c1 e0 18             	shl    $0x18,%eax
  8008bb:	09 c2                	or     %eax,%edx
  8008bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c0:	c1 e0 08             	shl    $0x8,%eax
  8008c3:	09 d0                	or     %edx,%eax
  8008c5:	09 c8                	or     %ecx,%eax
  8008c7:	89 c7                	mov    %eax,%edi
    break;
  }
  if (addr)
  8008c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008cd:	74 29                	je     8008f8 <inet_aton+0x1dc>
    addr->s_addr = htonl(val);
  8008cf:	89 3c 24             	mov    %edi,(%esp)
  8008d2:	e8 19 fe ff ff       	call   8006f0 <htonl>
  8008d7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008da:	89 06                	mov    %eax,(%esi)
  return (1);
  8008dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8008e1:	eb 1a                	jmp    8008fd <inet_aton+0x1e1>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  8008e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e8:	eb 13                	jmp    8008fd <inet_aton+0x1e1>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  8008ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ef:	eb 0c                	jmp    8008fd <inet_aton+0x1e1>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  8008f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f6:	eb 05                	jmp    8008fd <inet_aton+0x1e1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  8008f8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8008fd:	83 c4 20             	add    $0x20,%esp
  800900:	5b                   	pop    %ebx
  800901:	5e                   	pop    %esi
  800902:	5f                   	pop    %edi
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  80090b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80090e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	89 04 24             	mov    %eax,(%esp)
  800918:	e8 ff fd ff ff       	call   80071c <inet_aton>
  80091d:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80091f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800924:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	89 04 24             	mov    %eax,(%esp)
  800936:	e8 b5 fd ff ff       	call   8006f0 <htonl>
}
  80093b:	c9                   	leave  
  80093c:	c3                   	ret    

0080093d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
  800940:	56                   	push   %esi
  800941:	53                   	push   %ebx
  800942:	83 ec 10             	sub    $0x10,%esp
  800945:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800948:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  80094b:	e8 55 0b 00 00       	call   8014a5 <sys_getenvid>
  800950:	25 ff 03 00 00       	and    $0x3ff,%eax
  800955:	89 c2                	mov    %eax,%edx
  800957:	c1 e2 07             	shl    $0x7,%edx
  80095a:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800961:	a3 20 50 80 00       	mov    %eax,0x805020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800966:	85 db                	test   %ebx,%ebx
  800968:	7e 07                	jle    800971 <libmain+0x34>
		binaryname = argv[0];
  80096a:	8b 06                	mov    (%esi),%eax
  80096c:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800971:	89 74 24 04          	mov    %esi,0x4(%esp)
  800975:	89 1c 24             	mov    %ebx,(%esp)
  800978:	e8 c3 f6 ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  80097d:	e8 07 00 00 00       	call   800989 <exit>
}
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	5b                   	pop    %ebx
  800986:	5e                   	pop    %esi
  800987:	5d                   	pop    %ebp
  800988:	c3                   	ret    

00800989 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80098f:	e8 56 16 00 00       	call   801fea <close_all>
	sys_env_destroy(0);
  800994:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80099b:	e8 b3 0a 00 00       	call   801453 <sys_env_destroy>
}
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	56                   	push   %esi
  8009a6:	53                   	push   %ebx
  8009a7:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8009aa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8009ad:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8009b3:	e8 ed 0a 00 00       	call   8014a5 <sys_getenvid>
  8009b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bb:	89 54 24 10          	mov    %edx,0x10(%esp)
  8009bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009c6:	89 74 24 08          	mov    %esi,0x8(%esp)
  8009ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ce:	c7 04 24 a4 35 80 00 	movl   $0x8035a4,(%esp)
  8009d5:	e8 c1 00 00 00       	call   800a9b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8009da:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8009de:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e1:	89 04 24             	mov    %eax,(%esp)
  8009e4:	e8 51 00 00 00       	call   800a3a <vcprintf>
	cprintf("\n");
  8009e9:	c7 04 24 fb 34 80 00 	movl   $0x8034fb,(%esp)
  8009f0:	e8 a6 00 00 00       	call   800a9b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8009f5:	cc                   	int3   
  8009f6:	eb fd                	jmp    8009f5 <_panic+0x53>

008009f8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	53                   	push   %ebx
  8009fc:	83 ec 14             	sub    $0x14,%esp
  8009ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800a02:	8b 13                	mov    (%ebx),%edx
  800a04:	8d 42 01             	lea    0x1(%edx),%eax
  800a07:	89 03                	mov    %eax,(%ebx)
  800a09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800a10:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a15:	75 19                	jne    800a30 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800a17:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800a1e:	00 
  800a1f:	8d 43 08             	lea    0x8(%ebx),%eax
  800a22:	89 04 24             	mov    %eax,(%esp)
  800a25:	e8 ec 09 00 00       	call   801416 <sys_cputs>
		b->idx = 0;
  800a2a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800a30:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800a34:	83 c4 14             	add    $0x14,%esp
  800a37:	5b                   	pop    %ebx
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800a43:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a4a:	00 00 00 
	b.cnt = 0;
  800a4d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a54:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800a57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a65:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a6f:	c7 04 24 f8 09 80 00 	movl   $0x8009f8,(%esp)
  800a76:	e8 b3 01 00 00       	call   800c2e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800a7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800a81:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a85:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800a8b:	89 04 24             	mov    %eax,(%esp)
  800a8e:	e8 83 09 00 00       	call   801416 <sys_cputs>

	return b.cnt;
}
  800a93:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a99:	c9                   	leave  
  800a9a:	c3                   	ret    

00800a9b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800aa1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	89 04 24             	mov    %eax,(%esp)
  800aae:	e8 87 ff ff ff       	call   800a3a <vcprintf>
	va_end(ap);

	return cnt;
}
  800ab3:	c9                   	leave  
  800ab4:	c3                   	ret    
  800ab5:	66 90                	xchg   %ax,%ax
  800ab7:	66 90                	xchg   %ax,%ax
  800ab9:	66 90                	xchg   %ax,%ax
  800abb:	66 90                	xchg   %ax,%ax
  800abd:	66 90                	xchg   %ax,%ax
  800abf:	90                   	nop

00800ac0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	57                   	push   %edi
  800ac4:	56                   	push   %esi
  800ac5:	53                   	push   %ebx
  800ac6:	83 ec 3c             	sub    $0x3c,%esp
  800ac9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800acc:	89 d7                	mov    %edx,%edi
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad7:	89 c3                	mov    %eax,%ebx
  800ad9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800adc:	8b 45 10             	mov    0x10(%ebp),%eax
  800adf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ae2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ae7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aea:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800aed:	39 d9                	cmp    %ebx,%ecx
  800aef:	72 05                	jb     800af6 <printnum+0x36>
  800af1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800af4:	77 69                	ja     800b5f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800af6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800af9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800afd:	83 ee 01             	sub    $0x1,%esi
  800b00:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b04:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b08:	8b 44 24 08          	mov    0x8(%esp),%eax
  800b0c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800b10:	89 c3                	mov    %eax,%ebx
  800b12:	89 d6                	mov    %edx,%esi
  800b14:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b17:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800b1a:	89 54 24 08          	mov    %edx,0x8(%esp)
  800b1e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800b22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b25:	89 04 24             	mov    %eax,(%esp)
  800b28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b2f:	e8 7c 26 00 00       	call   8031b0 <__udivdi3>
  800b34:	89 d9                	mov    %ebx,%ecx
  800b36:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800b3a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b3e:	89 04 24             	mov    %eax,(%esp)
  800b41:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b45:	89 fa                	mov    %edi,%edx
  800b47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b4a:	e8 71 ff ff ff       	call   800ac0 <printnum>
  800b4f:	eb 1b                	jmp    800b6c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b51:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b55:	8b 45 18             	mov    0x18(%ebp),%eax
  800b58:	89 04 24             	mov    %eax,(%esp)
  800b5b:	ff d3                	call   *%ebx
  800b5d:	eb 03                	jmp    800b62 <printnum+0xa2>
  800b5f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b62:	83 ee 01             	sub    $0x1,%esi
  800b65:	85 f6                	test   %esi,%esi
  800b67:	7f e8                	jg     800b51 <printnum+0x91>
  800b69:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b6c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b70:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b74:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b77:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800b7a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b7e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b85:	89 04 24             	mov    %eax,(%esp)
  800b88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b8f:	e8 4c 27 00 00       	call   8032e0 <__umoddi3>
  800b94:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b98:	0f be 80 c7 35 80 00 	movsbl 0x8035c7(%eax),%eax
  800b9f:	89 04 24             	mov    %eax,(%esp)
  800ba2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
}
  800ba7:	83 c4 3c             	add    $0x3c,%esp
  800baa:	5b                   	pop    %ebx
  800bab:	5e                   	pop    %esi
  800bac:	5f                   	pop    %edi
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bb2:	83 fa 01             	cmp    $0x1,%edx
  800bb5:	7e 0e                	jle    800bc5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800bb7:	8b 10                	mov    (%eax),%edx
  800bb9:	8d 4a 08             	lea    0x8(%edx),%ecx
  800bbc:	89 08                	mov    %ecx,(%eax)
  800bbe:	8b 02                	mov    (%edx),%eax
  800bc0:	8b 52 04             	mov    0x4(%edx),%edx
  800bc3:	eb 22                	jmp    800be7 <getuint+0x38>
	else if (lflag)
  800bc5:	85 d2                	test   %edx,%edx
  800bc7:	74 10                	je     800bd9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800bc9:	8b 10                	mov    (%eax),%edx
  800bcb:	8d 4a 04             	lea    0x4(%edx),%ecx
  800bce:	89 08                	mov    %ecx,(%eax)
  800bd0:	8b 02                	mov    (%edx),%eax
  800bd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd7:	eb 0e                	jmp    800be7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800bd9:	8b 10                	mov    (%eax),%edx
  800bdb:	8d 4a 04             	lea    0x4(%edx),%ecx
  800bde:	89 08                	mov    %ecx,(%eax)
  800be0:	8b 02                	mov    (%edx),%eax
  800be2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800bef:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800bf3:	8b 10                	mov    (%eax),%edx
  800bf5:	3b 50 04             	cmp    0x4(%eax),%edx
  800bf8:	73 0a                	jae    800c04 <sprintputch+0x1b>
		*b->buf++ = ch;
  800bfa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bfd:	89 08                	mov    %ecx,(%eax)
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	88 02                	mov    %al,(%edx)
}
  800c04:	5d                   	pop    %ebp
  800c05:	c3                   	ret    

00800c06 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c0c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c13:	8b 45 10             	mov    0x10(%ebp),%eax
  800c16:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	89 04 24             	mov    %eax,(%esp)
  800c27:	e8 02 00 00 00       	call   800c2e <vprintfmt>
	va_end(ap);
}
  800c2c:	c9                   	leave  
  800c2d:	c3                   	ret    

00800c2e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	57                   	push   %edi
  800c32:	56                   	push   %esi
  800c33:	53                   	push   %ebx
  800c34:	83 ec 3c             	sub    $0x3c,%esp
  800c37:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c3d:	eb 14                	jmp    800c53 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800c3f:	85 c0                	test   %eax,%eax
  800c41:	0f 84 b3 03 00 00    	je     800ffa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800c47:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c4b:	89 04 24             	mov    %eax,(%esp)
  800c4e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c51:	89 f3                	mov    %esi,%ebx
  800c53:	8d 73 01             	lea    0x1(%ebx),%esi
  800c56:	0f b6 03             	movzbl (%ebx),%eax
  800c59:	83 f8 25             	cmp    $0x25,%eax
  800c5c:	75 e1                	jne    800c3f <vprintfmt+0x11>
  800c5e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800c62:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c69:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800c70:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800c77:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7c:	eb 1d                	jmp    800c9b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c7e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800c80:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800c84:	eb 15                	jmp    800c9b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c86:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c88:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800c8c:	eb 0d                	jmp    800c9b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800c8e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c91:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800c94:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c9b:	8d 5e 01             	lea    0x1(%esi),%ebx
  800c9e:	0f b6 0e             	movzbl (%esi),%ecx
  800ca1:	0f b6 c1             	movzbl %cl,%eax
  800ca4:	83 e9 23             	sub    $0x23,%ecx
  800ca7:	80 f9 55             	cmp    $0x55,%cl
  800caa:	0f 87 2a 03 00 00    	ja     800fda <vprintfmt+0x3ac>
  800cb0:	0f b6 c9             	movzbl %cl,%ecx
  800cb3:	ff 24 8d 40 37 80 00 	jmp    *0x803740(,%ecx,4)
  800cba:	89 de                	mov    %ebx,%esi
  800cbc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800cc1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800cc4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800cc8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800ccb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800cce:	83 fb 09             	cmp    $0x9,%ebx
  800cd1:	77 36                	ja     800d09 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cd3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cd6:	eb e9                	jmp    800cc1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cd8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdb:	8d 48 04             	lea    0x4(%eax),%ecx
  800cde:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800ce1:	8b 00                	mov    (%eax),%eax
  800ce3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ce6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800ce8:	eb 22                	jmp    800d0c <vprintfmt+0xde>
  800cea:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800ced:	85 c9                	test   %ecx,%ecx
  800cef:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf4:	0f 49 c1             	cmovns %ecx,%eax
  800cf7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cfa:	89 de                	mov    %ebx,%esi
  800cfc:	eb 9d                	jmp    800c9b <vprintfmt+0x6d>
  800cfe:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800d00:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800d07:	eb 92                	jmp    800c9b <vprintfmt+0x6d>
  800d09:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  800d0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d10:	79 89                	jns    800c9b <vprintfmt+0x6d>
  800d12:	e9 77 ff ff ff       	jmp    800c8e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d17:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d1a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800d1c:	e9 7a ff ff ff       	jmp    800c9b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d21:	8b 45 14             	mov    0x14(%ebp),%eax
  800d24:	8d 50 04             	lea    0x4(%eax),%edx
  800d27:	89 55 14             	mov    %edx,0x14(%ebp)
  800d2a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d2e:	8b 00                	mov    (%eax),%eax
  800d30:	89 04 24             	mov    %eax,(%esp)
  800d33:	ff 55 08             	call   *0x8(%ebp)
			break;
  800d36:	e9 18 ff ff ff       	jmp    800c53 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3e:	8d 50 04             	lea    0x4(%eax),%edx
  800d41:	89 55 14             	mov    %edx,0x14(%ebp)
  800d44:	8b 00                	mov    (%eax),%eax
  800d46:	99                   	cltd   
  800d47:	31 d0                	xor    %edx,%eax
  800d49:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d4b:	83 f8 12             	cmp    $0x12,%eax
  800d4e:	7f 0b                	jg     800d5b <vprintfmt+0x12d>
  800d50:	8b 14 85 a0 38 80 00 	mov    0x8038a0(,%eax,4),%edx
  800d57:	85 d2                	test   %edx,%edx
  800d59:	75 20                	jne    800d7b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  800d5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d5f:	c7 44 24 08 df 35 80 	movl   $0x8035df,0x8(%esp)
  800d66:	00 
  800d67:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	89 04 24             	mov    %eax,(%esp)
  800d71:	e8 90 fe ff ff       	call   800c06 <printfmt>
  800d76:	e9 d8 fe ff ff       	jmp    800c53 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800d7b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800d7f:	c7 44 24 08 0d 3b 80 	movl   $0x803b0d,0x8(%esp)
  800d86:	00 
  800d87:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	89 04 24             	mov    %eax,(%esp)
  800d91:	e8 70 fe ff ff       	call   800c06 <printfmt>
  800d96:	e9 b8 fe ff ff       	jmp    800c53 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d9b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800d9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800da1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800da4:	8b 45 14             	mov    0x14(%ebp),%eax
  800da7:	8d 50 04             	lea    0x4(%eax),%edx
  800daa:	89 55 14             	mov    %edx,0x14(%ebp)
  800dad:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800daf:	85 f6                	test   %esi,%esi
  800db1:	b8 d8 35 80 00       	mov    $0x8035d8,%eax
  800db6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800db9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800dbd:	0f 84 97 00 00 00    	je     800e5a <vprintfmt+0x22c>
  800dc3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800dc7:	0f 8e 9b 00 00 00    	jle    800e68 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dcd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800dd1:	89 34 24             	mov    %esi,(%esp)
  800dd4:	e8 cf 02 00 00       	call   8010a8 <strnlen>
  800dd9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800ddc:	29 c2                	sub    %eax,%edx
  800dde:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800de1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800de5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800de8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800deb:	8b 75 08             	mov    0x8(%ebp),%esi
  800dee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800df1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800df3:	eb 0f                	jmp    800e04 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800df5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800df9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800dfc:	89 04 24             	mov    %eax,(%esp)
  800dff:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e01:	83 eb 01             	sub    $0x1,%ebx
  800e04:	85 db                	test   %ebx,%ebx
  800e06:	7f ed                	jg     800df5 <vprintfmt+0x1c7>
  800e08:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800e0b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800e0e:	85 d2                	test   %edx,%edx
  800e10:	b8 00 00 00 00       	mov    $0x0,%eax
  800e15:	0f 49 c2             	cmovns %edx,%eax
  800e18:	29 c2                	sub    %eax,%edx
  800e1a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800e1d:	89 d7                	mov    %edx,%edi
  800e1f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800e22:	eb 50                	jmp    800e74 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800e24:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e28:	74 1e                	je     800e48 <vprintfmt+0x21a>
  800e2a:	0f be d2             	movsbl %dl,%edx
  800e2d:	83 ea 20             	sub    $0x20,%edx
  800e30:	83 fa 5e             	cmp    $0x5e,%edx
  800e33:	76 13                	jbe    800e48 <vprintfmt+0x21a>
					putch('?', putdat);
  800e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e38:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e3c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800e43:	ff 55 08             	call   *0x8(%ebp)
  800e46:	eb 0d                	jmp    800e55 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800e48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e4f:	89 04 24             	mov    %eax,(%esp)
  800e52:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e55:	83 ef 01             	sub    $0x1,%edi
  800e58:	eb 1a                	jmp    800e74 <vprintfmt+0x246>
  800e5a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800e5d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800e60:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e63:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800e66:	eb 0c                	jmp    800e74 <vprintfmt+0x246>
  800e68:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800e6b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800e6e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e71:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800e74:	83 c6 01             	add    $0x1,%esi
  800e77:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800e7b:	0f be c2             	movsbl %dl,%eax
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	74 27                	je     800ea9 <vprintfmt+0x27b>
  800e82:	85 db                	test   %ebx,%ebx
  800e84:	78 9e                	js     800e24 <vprintfmt+0x1f6>
  800e86:	83 eb 01             	sub    $0x1,%ebx
  800e89:	79 99                	jns    800e24 <vprintfmt+0x1f6>
  800e8b:	89 f8                	mov    %edi,%eax
  800e8d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e90:	8b 75 08             	mov    0x8(%ebp),%esi
  800e93:	89 c3                	mov    %eax,%ebx
  800e95:	eb 1a                	jmp    800eb1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800e97:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e9b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800ea2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ea4:	83 eb 01             	sub    $0x1,%ebx
  800ea7:	eb 08                	jmp    800eb1 <vprintfmt+0x283>
  800ea9:	89 fb                	mov    %edi,%ebx
  800eab:	8b 75 08             	mov    0x8(%ebp),%esi
  800eae:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800eb1:	85 db                	test   %ebx,%ebx
  800eb3:	7f e2                	jg     800e97 <vprintfmt+0x269>
  800eb5:	89 75 08             	mov    %esi,0x8(%ebp)
  800eb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebb:	e9 93 fd ff ff       	jmp    800c53 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800ec0:	83 fa 01             	cmp    $0x1,%edx
  800ec3:	7e 16                	jle    800edb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800ec5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec8:	8d 50 08             	lea    0x8(%eax),%edx
  800ecb:	89 55 14             	mov    %edx,0x14(%ebp)
  800ece:	8b 50 04             	mov    0x4(%eax),%edx
  800ed1:	8b 00                	mov    (%eax),%eax
  800ed3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ed6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800ed9:	eb 32                	jmp    800f0d <vprintfmt+0x2df>
	else if (lflag)
  800edb:	85 d2                	test   %edx,%edx
  800edd:	74 18                	je     800ef7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800edf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee2:	8d 50 04             	lea    0x4(%eax),%edx
  800ee5:	89 55 14             	mov    %edx,0x14(%ebp)
  800ee8:	8b 30                	mov    (%eax),%esi
  800eea:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800eed:	89 f0                	mov    %esi,%eax
  800eef:	c1 f8 1f             	sar    $0x1f,%eax
  800ef2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ef5:	eb 16                	jmp    800f0d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800ef7:	8b 45 14             	mov    0x14(%ebp),%eax
  800efa:	8d 50 04             	lea    0x4(%eax),%edx
  800efd:	89 55 14             	mov    %edx,0x14(%ebp)
  800f00:	8b 30                	mov    (%eax),%esi
  800f02:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800f05:	89 f0                	mov    %esi,%eax
  800f07:	c1 f8 1f             	sar    $0x1f,%eax
  800f0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800f13:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800f18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1c:	0f 89 80 00 00 00    	jns    800fa2 <vprintfmt+0x374>
				putch('-', putdat);
  800f22:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f26:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800f2d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800f30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f36:	f7 d8                	neg    %eax
  800f38:	83 d2 00             	adc    $0x0,%edx
  800f3b:	f7 da                	neg    %edx
			}
			base = 10;
  800f3d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f42:	eb 5e                	jmp    800fa2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f44:	8d 45 14             	lea    0x14(%ebp),%eax
  800f47:	e8 63 fc ff ff       	call   800baf <getuint>
			base = 10;
  800f4c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800f51:	eb 4f                	jmp    800fa2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800f53:	8d 45 14             	lea    0x14(%ebp),%eax
  800f56:	e8 54 fc ff ff       	call   800baf <getuint>
			base = 8;
  800f5b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800f60:	eb 40                	jmp    800fa2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800f62:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f66:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800f6d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800f70:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f74:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800f7b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800f7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f81:	8d 50 04             	lea    0x4(%eax),%edx
  800f84:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f87:	8b 00                	mov    (%eax),%eax
  800f89:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800f8e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800f93:	eb 0d                	jmp    800fa2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f95:	8d 45 14             	lea    0x14(%ebp),%eax
  800f98:	e8 12 fc ff ff       	call   800baf <getuint>
			base = 16;
  800f9d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fa2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800fa6:	89 74 24 10          	mov    %esi,0x10(%esp)
  800faa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800fad:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800fb1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fb5:	89 04 24             	mov    %eax,(%esp)
  800fb8:	89 54 24 04          	mov    %edx,0x4(%esp)
  800fbc:	89 fa                	mov    %edi,%edx
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	e8 fa fa ff ff       	call   800ac0 <printnum>
			break;
  800fc6:	e9 88 fc ff ff       	jmp    800c53 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fcb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fcf:	89 04 24             	mov    %eax,(%esp)
  800fd2:	ff 55 08             	call   *0x8(%ebp)
			break;
  800fd5:	e9 79 fc ff ff       	jmp    800c53 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fda:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fde:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800fe5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fe8:	89 f3                	mov    %esi,%ebx
  800fea:	eb 03                	jmp    800fef <vprintfmt+0x3c1>
  800fec:	83 eb 01             	sub    $0x1,%ebx
  800fef:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800ff3:	75 f7                	jne    800fec <vprintfmt+0x3be>
  800ff5:	e9 59 fc ff ff       	jmp    800c53 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800ffa:	83 c4 3c             	add    $0x3c,%esp
  800ffd:	5b                   	pop    %ebx
  800ffe:	5e                   	pop    %esi
  800fff:	5f                   	pop    %edi
  801000:	5d                   	pop    %ebp
  801001:	c3                   	ret    

00801002 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	83 ec 28             	sub    $0x28,%esp
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80100e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801011:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801015:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801018:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80101f:	85 c0                	test   %eax,%eax
  801021:	74 30                	je     801053 <vsnprintf+0x51>
  801023:	85 d2                	test   %edx,%edx
  801025:	7e 2c                	jle    801053 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801027:	8b 45 14             	mov    0x14(%ebp),%eax
  80102a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80102e:	8b 45 10             	mov    0x10(%ebp),%eax
  801031:	89 44 24 08          	mov    %eax,0x8(%esp)
  801035:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801038:	89 44 24 04          	mov    %eax,0x4(%esp)
  80103c:	c7 04 24 e9 0b 80 00 	movl   $0x800be9,(%esp)
  801043:	e8 e6 fb ff ff       	call   800c2e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801048:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80104b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80104e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801051:	eb 05                	jmp    801058 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801053:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801060:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801067:	8b 45 10             	mov    0x10(%ebp),%eax
  80106a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	89 44 24 04          	mov    %eax,0x4(%esp)
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	89 04 24             	mov    %eax,(%esp)
  80107b:	e8 82 ff ff ff       	call   801002 <vsnprintf>
	va_end(ap);

	return rc;
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    
  801082:	66 90                	xchg   %ax,%ax
  801084:	66 90                	xchg   %ax,%ax
  801086:	66 90                	xchg   %ax,%ax
  801088:	66 90                	xchg   %ax,%ax
  80108a:	66 90                	xchg   %ax,%ax
  80108c:	66 90                	xchg   %ax,%ax
  80108e:	66 90                	xchg   %ax,%ax

00801090 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
  80109b:	eb 03                	jmp    8010a0 <strlen+0x10>
		n++;
  80109d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8010a4:	75 f7                	jne    80109d <strlen+0xd>
		n++;
	return n;
}
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    

008010a8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b6:	eb 03                	jmp    8010bb <strnlen+0x13>
		n++;
  8010b8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010bb:	39 d0                	cmp    %edx,%eax
  8010bd:	74 06                	je     8010c5 <strnlen+0x1d>
  8010bf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8010c3:	75 f3                	jne    8010b8 <strnlen+0x10>
		n++;
	return n;
}
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    

008010c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	53                   	push   %ebx
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8010d1:	89 c2                	mov    %eax,%edx
  8010d3:	83 c2 01             	add    $0x1,%edx
  8010d6:	83 c1 01             	add    $0x1,%ecx
  8010d9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8010dd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8010e0:	84 db                	test   %bl,%bl
  8010e2:	75 ef                	jne    8010d3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8010e4:	5b                   	pop    %ebx
  8010e5:	5d                   	pop    %ebp
  8010e6:	c3                   	ret    

008010e7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	53                   	push   %ebx
  8010eb:	83 ec 08             	sub    $0x8,%esp
  8010ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8010f1:	89 1c 24             	mov    %ebx,(%esp)
  8010f4:	e8 97 ff ff ff       	call   801090 <strlen>
	strcpy(dst + len, src);
  8010f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  801100:	01 d8                	add    %ebx,%eax
  801102:	89 04 24             	mov    %eax,(%esp)
  801105:	e8 bd ff ff ff       	call   8010c7 <strcpy>
	return dst;
}
  80110a:	89 d8                	mov    %ebx,%eax
  80110c:	83 c4 08             	add    $0x8,%esp
  80110f:	5b                   	pop    %ebx
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    

00801112 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	56                   	push   %esi
  801116:	53                   	push   %ebx
  801117:	8b 75 08             	mov    0x8(%ebp),%esi
  80111a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111d:	89 f3                	mov    %esi,%ebx
  80111f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801122:	89 f2                	mov    %esi,%edx
  801124:	eb 0f                	jmp    801135 <strncpy+0x23>
		*dst++ = *src;
  801126:	83 c2 01             	add    $0x1,%edx
  801129:	0f b6 01             	movzbl (%ecx),%eax
  80112c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80112f:	80 39 01             	cmpb   $0x1,(%ecx)
  801132:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801135:	39 da                	cmp    %ebx,%edx
  801137:	75 ed                	jne    801126 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801139:	89 f0                	mov    %esi,%eax
  80113b:	5b                   	pop    %ebx
  80113c:	5e                   	pop    %esi
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    

0080113f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	56                   	push   %esi
  801143:	53                   	push   %ebx
  801144:	8b 75 08             	mov    0x8(%ebp),%esi
  801147:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80114d:	89 f0                	mov    %esi,%eax
  80114f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801153:	85 c9                	test   %ecx,%ecx
  801155:	75 0b                	jne    801162 <strlcpy+0x23>
  801157:	eb 1d                	jmp    801176 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801159:	83 c0 01             	add    $0x1,%eax
  80115c:	83 c2 01             	add    $0x1,%edx
  80115f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801162:	39 d8                	cmp    %ebx,%eax
  801164:	74 0b                	je     801171 <strlcpy+0x32>
  801166:	0f b6 0a             	movzbl (%edx),%ecx
  801169:	84 c9                	test   %cl,%cl
  80116b:	75 ec                	jne    801159 <strlcpy+0x1a>
  80116d:	89 c2                	mov    %eax,%edx
  80116f:	eb 02                	jmp    801173 <strlcpy+0x34>
  801171:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  801173:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  801176:	29 f0                	sub    %esi,%eax
}
  801178:	5b                   	pop    %ebx
  801179:	5e                   	pop    %esi
  80117a:	5d                   	pop    %ebp
  80117b:	c3                   	ret    

0080117c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801182:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801185:	eb 06                	jmp    80118d <strcmp+0x11>
		p++, q++;
  801187:	83 c1 01             	add    $0x1,%ecx
  80118a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80118d:	0f b6 01             	movzbl (%ecx),%eax
  801190:	84 c0                	test   %al,%al
  801192:	74 04                	je     801198 <strcmp+0x1c>
  801194:	3a 02                	cmp    (%edx),%al
  801196:	74 ef                	je     801187 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801198:	0f b6 c0             	movzbl %al,%eax
  80119b:	0f b6 12             	movzbl (%edx),%edx
  80119e:	29 d0                	sub    %edx,%eax
}
  8011a0:	5d                   	pop    %ebp
  8011a1:	c3                   	ret    

008011a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	53                   	push   %ebx
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ac:	89 c3                	mov    %eax,%ebx
  8011ae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8011b1:	eb 06                	jmp    8011b9 <strncmp+0x17>
		n--, p++, q++;
  8011b3:	83 c0 01             	add    $0x1,%eax
  8011b6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011b9:	39 d8                	cmp    %ebx,%eax
  8011bb:	74 15                	je     8011d2 <strncmp+0x30>
  8011bd:	0f b6 08             	movzbl (%eax),%ecx
  8011c0:	84 c9                	test   %cl,%cl
  8011c2:	74 04                	je     8011c8 <strncmp+0x26>
  8011c4:	3a 0a                	cmp    (%edx),%cl
  8011c6:	74 eb                	je     8011b3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011c8:	0f b6 00             	movzbl (%eax),%eax
  8011cb:	0f b6 12             	movzbl (%edx),%edx
  8011ce:	29 d0                	sub    %edx,%eax
  8011d0:	eb 05                	jmp    8011d7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8011d2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8011d7:	5b                   	pop    %ebx
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    

008011da <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8011e4:	eb 07                	jmp    8011ed <strchr+0x13>
		if (*s == c)
  8011e6:	38 ca                	cmp    %cl,%dl
  8011e8:	74 0f                	je     8011f9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011ea:	83 c0 01             	add    $0x1,%eax
  8011ed:	0f b6 10             	movzbl (%eax),%edx
  8011f0:	84 d2                	test   %dl,%dl
  8011f2:	75 f2                	jne    8011e6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8011f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f9:	5d                   	pop    %ebp
  8011fa:	c3                   	ret    

008011fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801205:	eb 07                	jmp    80120e <strfind+0x13>
		if (*s == c)
  801207:	38 ca                	cmp    %cl,%dl
  801209:	74 0a                	je     801215 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80120b:	83 c0 01             	add    $0x1,%eax
  80120e:	0f b6 10             	movzbl (%eax),%edx
  801211:	84 d2                	test   %dl,%dl
  801213:	75 f2                	jne    801207 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  801215:	5d                   	pop    %ebp
  801216:	c3                   	ret    

00801217 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	57                   	push   %edi
  80121b:	56                   	push   %esi
  80121c:	53                   	push   %ebx
  80121d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801220:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801223:	85 c9                	test   %ecx,%ecx
  801225:	74 36                	je     80125d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801227:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80122d:	75 28                	jne    801257 <memset+0x40>
  80122f:	f6 c1 03             	test   $0x3,%cl
  801232:	75 23                	jne    801257 <memset+0x40>
		c &= 0xFF;
  801234:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801238:	89 d3                	mov    %edx,%ebx
  80123a:	c1 e3 08             	shl    $0x8,%ebx
  80123d:	89 d6                	mov    %edx,%esi
  80123f:	c1 e6 18             	shl    $0x18,%esi
  801242:	89 d0                	mov    %edx,%eax
  801244:	c1 e0 10             	shl    $0x10,%eax
  801247:	09 f0                	or     %esi,%eax
  801249:	09 c2                	or     %eax,%edx
  80124b:	89 d0                	mov    %edx,%eax
  80124d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80124f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801252:	fc                   	cld    
  801253:	f3 ab                	rep stos %eax,%es:(%edi)
  801255:	eb 06                	jmp    80125d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	fc                   	cld    
  80125b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80125d:	89 f8                	mov    %edi,%eax
  80125f:	5b                   	pop    %ebx
  801260:	5e                   	pop    %esi
  801261:	5f                   	pop    %edi
  801262:	5d                   	pop    %ebp
  801263:	c3                   	ret    

00801264 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	57                   	push   %edi
  801268:	56                   	push   %esi
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80126f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801272:	39 c6                	cmp    %eax,%esi
  801274:	73 35                	jae    8012ab <memmove+0x47>
  801276:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801279:	39 d0                	cmp    %edx,%eax
  80127b:	73 2e                	jae    8012ab <memmove+0x47>
		s += n;
		d += n;
  80127d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801280:	89 d6                	mov    %edx,%esi
  801282:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801284:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80128a:	75 13                	jne    80129f <memmove+0x3b>
  80128c:	f6 c1 03             	test   $0x3,%cl
  80128f:	75 0e                	jne    80129f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801291:	83 ef 04             	sub    $0x4,%edi
  801294:	8d 72 fc             	lea    -0x4(%edx),%esi
  801297:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80129a:	fd                   	std    
  80129b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80129d:	eb 09                	jmp    8012a8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80129f:	83 ef 01             	sub    $0x1,%edi
  8012a2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012a5:	fd                   	std    
  8012a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012a8:	fc                   	cld    
  8012a9:	eb 1d                	jmp    8012c8 <memmove+0x64>
  8012ab:	89 f2                	mov    %esi,%edx
  8012ad:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8012af:	f6 c2 03             	test   $0x3,%dl
  8012b2:	75 0f                	jne    8012c3 <memmove+0x5f>
  8012b4:	f6 c1 03             	test   $0x3,%cl
  8012b7:	75 0a                	jne    8012c3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012b9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012bc:	89 c7                	mov    %eax,%edi
  8012be:	fc                   	cld    
  8012bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8012c1:	eb 05                	jmp    8012c8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012c3:	89 c7                	mov    %eax,%edi
  8012c5:	fc                   	cld    
  8012c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8012c8:	5e                   	pop    %esi
  8012c9:	5f                   	pop    %edi
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    

008012cc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8012d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	89 04 24             	mov    %eax,(%esp)
  8012e6:	e8 79 ff ff ff       	call   801264 <memmove>
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	56                   	push   %esi
  8012f1:	53                   	push   %ebx
  8012f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f8:	89 d6                	mov    %edx,%esi
  8012fa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012fd:	eb 1a                	jmp    801319 <memcmp+0x2c>
		if (*s1 != *s2)
  8012ff:	0f b6 02             	movzbl (%edx),%eax
  801302:	0f b6 19             	movzbl (%ecx),%ebx
  801305:	38 d8                	cmp    %bl,%al
  801307:	74 0a                	je     801313 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801309:	0f b6 c0             	movzbl %al,%eax
  80130c:	0f b6 db             	movzbl %bl,%ebx
  80130f:	29 d8                	sub    %ebx,%eax
  801311:	eb 0f                	jmp    801322 <memcmp+0x35>
		s1++, s2++;
  801313:	83 c2 01             	add    $0x1,%edx
  801316:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801319:	39 f2                	cmp    %esi,%edx
  80131b:	75 e2                	jne    8012ff <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80131d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801322:	5b                   	pop    %ebx
  801323:	5e                   	pop    %esi
  801324:	5d                   	pop    %ebp
  801325:	c3                   	ret    

00801326 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80132f:	89 c2                	mov    %eax,%edx
  801331:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801334:	eb 07                	jmp    80133d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  801336:	38 08                	cmp    %cl,(%eax)
  801338:	74 07                	je     801341 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80133a:	83 c0 01             	add    $0x1,%eax
  80133d:	39 d0                	cmp    %edx,%eax
  80133f:	72 f5                	jb     801336 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801341:	5d                   	pop    %ebp
  801342:	c3                   	ret    

00801343 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	57                   	push   %edi
  801347:	56                   	push   %esi
  801348:	53                   	push   %ebx
  801349:	8b 55 08             	mov    0x8(%ebp),%edx
  80134c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80134f:	eb 03                	jmp    801354 <strtol+0x11>
		s++;
  801351:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801354:	0f b6 0a             	movzbl (%edx),%ecx
  801357:	80 f9 09             	cmp    $0x9,%cl
  80135a:	74 f5                	je     801351 <strtol+0xe>
  80135c:	80 f9 20             	cmp    $0x20,%cl
  80135f:	74 f0                	je     801351 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  801361:	80 f9 2b             	cmp    $0x2b,%cl
  801364:	75 0a                	jne    801370 <strtol+0x2d>
		s++;
  801366:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801369:	bf 00 00 00 00       	mov    $0x0,%edi
  80136e:	eb 11                	jmp    801381 <strtol+0x3e>
  801370:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801375:	80 f9 2d             	cmp    $0x2d,%cl
  801378:	75 07                	jne    801381 <strtol+0x3e>
		s++, neg = 1;
  80137a:	8d 52 01             	lea    0x1(%edx),%edx
  80137d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801381:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801386:	75 15                	jne    80139d <strtol+0x5a>
  801388:	80 3a 30             	cmpb   $0x30,(%edx)
  80138b:	75 10                	jne    80139d <strtol+0x5a>
  80138d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801391:	75 0a                	jne    80139d <strtol+0x5a>
		s += 2, base = 16;
  801393:	83 c2 02             	add    $0x2,%edx
  801396:	b8 10 00 00 00       	mov    $0x10,%eax
  80139b:	eb 10                	jmp    8013ad <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80139d:	85 c0                	test   %eax,%eax
  80139f:	75 0c                	jne    8013ad <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8013a1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8013a3:	80 3a 30             	cmpb   $0x30,(%edx)
  8013a6:	75 05                	jne    8013ad <strtol+0x6a>
		s++, base = 8;
  8013a8:	83 c2 01             	add    $0x1,%edx
  8013ab:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8013ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013b5:	0f b6 0a             	movzbl (%edx),%ecx
  8013b8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8013bb:	89 f0                	mov    %esi,%eax
  8013bd:	3c 09                	cmp    $0x9,%al
  8013bf:	77 08                	ja     8013c9 <strtol+0x86>
			dig = *s - '0';
  8013c1:	0f be c9             	movsbl %cl,%ecx
  8013c4:	83 e9 30             	sub    $0x30,%ecx
  8013c7:	eb 20                	jmp    8013e9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  8013c9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8013cc:	89 f0                	mov    %esi,%eax
  8013ce:	3c 19                	cmp    $0x19,%al
  8013d0:	77 08                	ja     8013da <strtol+0x97>
			dig = *s - 'a' + 10;
  8013d2:	0f be c9             	movsbl %cl,%ecx
  8013d5:	83 e9 57             	sub    $0x57,%ecx
  8013d8:	eb 0f                	jmp    8013e9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8013da:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8013dd:	89 f0                	mov    %esi,%eax
  8013df:	3c 19                	cmp    $0x19,%al
  8013e1:	77 16                	ja     8013f9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  8013e3:	0f be c9             	movsbl %cl,%ecx
  8013e6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8013e9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8013ec:	7d 0f                	jge    8013fd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  8013ee:	83 c2 01             	add    $0x1,%edx
  8013f1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8013f5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8013f7:	eb bc                	jmp    8013b5 <strtol+0x72>
  8013f9:	89 d8                	mov    %ebx,%eax
  8013fb:	eb 02                	jmp    8013ff <strtol+0xbc>
  8013fd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8013ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801403:	74 05                	je     80140a <strtol+0xc7>
		*endptr = (char *) s;
  801405:	8b 75 0c             	mov    0xc(%ebp),%esi
  801408:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80140a:	f7 d8                	neg    %eax
  80140c:	85 ff                	test   %edi,%edi
  80140e:	0f 44 c3             	cmove  %ebx,%eax
}
  801411:	5b                   	pop    %ebx
  801412:	5e                   	pop    %esi
  801413:	5f                   	pop    %edi
  801414:	5d                   	pop    %ebp
  801415:	c3                   	ret    

00801416 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	57                   	push   %edi
  80141a:	56                   	push   %esi
  80141b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80141c:	b8 00 00 00 00       	mov    $0x0,%eax
  801421:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801424:	8b 55 08             	mov    0x8(%ebp),%edx
  801427:	89 c3                	mov    %eax,%ebx
  801429:	89 c7                	mov    %eax,%edi
  80142b:	89 c6                	mov    %eax,%esi
  80142d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80142f:	5b                   	pop    %ebx
  801430:	5e                   	pop    %esi
  801431:	5f                   	pop    %edi
  801432:	5d                   	pop    %ebp
  801433:	c3                   	ret    

00801434 <sys_cgetc>:

int
sys_cgetc(void)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	57                   	push   %edi
  801438:	56                   	push   %esi
  801439:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80143a:	ba 00 00 00 00       	mov    $0x0,%edx
  80143f:	b8 01 00 00 00       	mov    $0x1,%eax
  801444:	89 d1                	mov    %edx,%ecx
  801446:	89 d3                	mov    %edx,%ebx
  801448:	89 d7                	mov    %edx,%edi
  80144a:	89 d6                	mov    %edx,%esi
  80144c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80144e:	5b                   	pop    %ebx
  80144f:	5e                   	pop    %esi
  801450:	5f                   	pop    %edi
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    

00801453 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	57                   	push   %edi
  801457:	56                   	push   %esi
  801458:	53                   	push   %ebx
  801459:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80145c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801461:	b8 03 00 00 00       	mov    $0x3,%eax
  801466:	8b 55 08             	mov    0x8(%ebp),%edx
  801469:	89 cb                	mov    %ecx,%ebx
  80146b:	89 cf                	mov    %ecx,%edi
  80146d:	89 ce                	mov    %ecx,%esi
  80146f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801471:	85 c0                	test   %eax,%eax
  801473:	7e 28                	jle    80149d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801475:	89 44 24 10          	mov    %eax,0x10(%esp)
  801479:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801480:	00 
  801481:	c7 44 24 08 0b 39 80 	movl   $0x80390b,0x8(%esp)
  801488:	00 
  801489:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801490:	00 
  801491:	c7 04 24 28 39 80 00 	movl   $0x803928,(%esp)
  801498:	e8 05 f5 ff ff       	call   8009a2 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80149d:	83 c4 2c             	add    $0x2c,%esp
  8014a0:	5b                   	pop    %ebx
  8014a1:	5e                   	pop    %esi
  8014a2:	5f                   	pop    %edi
  8014a3:	5d                   	pop    %ebp
  8014a4:	c3                   	ret    

008014a5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	57                   	push   %edi
  8014a9:	56                   	push   %esi
  8014aa:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b0:	b8 02 00 00 00       	mov    $0x2,%eax
  8014b5:	89 d1                	mov    %edx,%ecx
  8014b7:	89 d3                	mov    %edx,%ebx
  8014b9:	89 d7                	mov    %edx,%edi
  8014bb:	89 d6                	mov    %edx,%esi
  8014bd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8014bf:	5b                   	pop    %ebx
  8014c0:	5e                   	pop    %esi
  8014c1:	5f                   	pop    %edi
  8014c2:	5d                   	pop    %ebp
  8014c3:	c3                   	ret    

008014c4 <sys_yield>:

void
sys_yield(void)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	57                   	push   %edi
  8014c8:	56                   	push   %esi
  8014c9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8014cf:	b8 0b 00 00 00       	mov    $0xb,%eax
  8014d4:	89 d1                	mov    %edx,%ecx
  8014d6:	89 d3                	mov    %edx,%ebx
  8014d8:	89 d7                	mov    %edx,%edi
  8014da:	89 d6                	mov    %edx,%esi
  8014dc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8014de:	5b                   	pop    %ebx
  8014df:	5e                   	pop    %esi
  8014e0:	5f                   	pop    %edi
  8014e1:	5d                   	pop    %ebp
  8014e2:	c3                   	ret    

008014e3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	57                   	push   %edi
  8014e7:	56                   	push   %esi
  8014e8:	53                   	push   %ebx
  8014e9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ec:	be 00 00 00 00       	mov    $0x0,%esi
  8014f1:	b8 04 00 00 00       	mov    $0x4,%eax
  8014f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014ff:	89 f7                	mov    %esi,%edi
  801501:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801503:	85 c0                	test   %eax,%eax
  801505:	7e 28                	jle    80152f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801507:	89 44 24 10          	mov    %eax,0x10(%esp)
  80150b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801512:	00 
  801513:	c7 44 24 08 0b 39 80 	movl   $0x80390b,0x8(%esp)
  80151a:	00 
  80151b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801522:	00 
  801523:	c7 04 24 28 39 80 00 	movl   $0x803928,(%esp)
  80152a:	e8 73 f4 ff ff       	call   8009a2 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80152f:	83 c4 2c             	add    $0x2c,%esp
  801532:	5b                   	pop    %ebx
  801533:	5e                   	pop    %esi
  801534:	5f                   	pop    %edi
  801535:	5d                   	pop    %ebp
  801536:	c3                   	ret    

00801537 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	57                   	push   %edi
  80153b:	56                   	push   %esi
  80153c:	53                   	push   %ebx
  80153d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801540:	b8 05 00 00 00       	mov    $0x5,%eax
  801545:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801548:	8b 55 08             	mov    0x8(%ebp),%edx
  80154b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80154e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801551:	8b 75 18             	mov    0x18(%ebp),%esi
  801554:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801556:	85 c0                	test   %eax,%eax
  801558:	7e 28                	jle    801582 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80155a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80155e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801565:	00 
  801566:	c7 44 24 08 0b 39 80 	movl   $0x80390b,0x8(%esp)
  80156d:	00 
  80156e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801575:	00 
  801576:	c7 04 24 28 39 80 00 	movl   $0x803928,(%esp)
  80157d:	e8 20 f4 ff ff       	call   8009a2 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801582:	83 c4 2c             	add    $0x2c,%esp
  801585:	5b                   	pop    %ebx
  801586:	5e                   	pop    %esi
  801587:	5f                   	pop    %edi
  801588:	5d                   	pop    %ebp
  801589:	c3                   	ret    

0080158a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	57                   	push   %edi
  80158e:	56                   	push   %esi
  80158f:	53                   	push   %ebx
  801590:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801593:	bb 00 00 00 00       	mov    $0x0,%ebx
  801598:	b8 06 00 00 00       	mov    $0x6,%eax
  80159d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a3:	89 df                	mov    %ebx,%edi
  8015a5:	89 de                	mov    %ebx,%esi
  8015a7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	7e 28                	jle    8015d5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015ad:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015b1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8015b8:	00 
  8015b9:	c7 44 24 08 0b 39 80 	movl   $0x80390b,0x8(%esp)
  8015c0:	00 
  8015c1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015c8:	00 
  8015c9:	c7 04 24 28 39 80 00 	movl   $0x803928,(%esp)
  8015d0:	e8 cd f3 ff ff       	call   8009a2 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8015d5:	83 c4 2c             	add    $0x2c,%esp
  8015d8:	5b                   	pop    %ebx
  8015d9:	5e                   	pop    %esi
  8015da:	5f                   	pop    %edi
  8015db:	5d                   	pop    %ebp
  8015dc:	c3                   	ret    

008015dd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	57                   	push   %edi
  8015e1:	56                   	push   %esi
  8015e2:	53                   	push   %ebx
  8015e3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8015f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f6:	89 df                	mov    %ebx,%edi
  8015f8:	89 de                	mov    %ebx,%esi
  8015fa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	7e 28                	jle    801628 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801600:	89 44 24 10          	mov    %eax,0x10(%esp)
  801604:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80160b:	00 
  80160c:	c7 44 24 08 0b 39 80 	movl   $0x80390b,0x8(%esp)
  801613:	00 
  801614:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80161b:	00 
  80161c:	c7 04 24 28 39 80 00 	movl   $0x803928,(%esp)
  801623:	e8 7a f3 ff ff       	call   8009a2 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801628:	83 c4 2c             	add    $0x2c,%esp
  80162b:	5b                   	pop    %ebx
  80162c:	5e                   	pop    %esi
  80162d:	5f                   	pop    %edi
  80162e:	5d                   	pop    %ebp
  80162f:	c3                   	ret    

00801630 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	57                   	push   %edi
  801634:	56                   	push   %esi
  801635:	53                   	push   %ebx
  801636:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801639:	bb 00 00 00 00       	mov    $0x0,%ebx
  80163e:	b8 09 00 00 00       	mov    $0x9,%eax
  801643:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801646:	8b 55 08             	mov    0x8(%ebp),%edx
  801649:	89 df                	mov    %ebx,%edi
  80164b:	89 de                	mov    %ebx,%esi
  80164d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80164f:	85 c0                	test   %eax,%eax
  801651:	7e 28                	jle    80167b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801653:	89 44 24 10          	mov    %eax,0x10(%esp)
  801657:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80165e:	00 
  80165f:	c7 44 24 08 0b 39 80 	movl   $0x80390b,0x8(%esp)
  801666:	00 
  801667:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80166e:	00 
  80166f:	c7 04 24 28 39 80 00 	movl   $0x803928,(%esp)
  801676:	e8 27 f3 ff ff       	call   8009a2 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80167b:	83 c4 2c             	add    $0x2c,%esp
  80167e:	5b                   	pop    %ebx
  80167f:	5e                   	pop    %esi
  801680:	5f                   	pop    %edi
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    

00801683 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	57                   	push   %edi
  801687:	56                   	push   %esi
  801688:	53                   	push   %ebx
  801689:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80168c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801691:	b8 0a 00 00 00       	mov    $0xa,%eax
  801696:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801699:	8b 55 08             	mov    0x8(%ebp),%edx
  80169c:	89 df                	mov    %ebx,%edi
  80169e:	89 de                	mov    %ebx,%esi
  8016a0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	7e 28                	jle    8016ce <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016a6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016aa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8016b1:	00 
  8016b2:	c7 44 24 08 0b 39 80 	movl   $0x80390b,0x8(%esp)
  8016b9:	00 
  8016ba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016c1:	00 
  8016c2:	c7 04 24 28 39 80 00 	movl   $0x803928,(%esp)
  8016c9:	e8 d4 f2 ff ff       	call   8009a2 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8016ce:	83 c4 2c             	add    $0x2c,%esp
  8016d1:	5b                   	pop    %ebx
  8016d2:	5e                   	pop    %esi
  8016d3:	5f                   	pop    %edi
  8016d4:	5d                   	pop    %ebp
  8016d5:	c3                   	ret    

008016d6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	57                   	push   %edi
  8016da:	56                   	push   %esi
  8016db:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016dc:	be 00 00 00 00       	mov    $0x0,%esi
  8016e1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8016e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016ef:	8b 7d 14             	mov    0x14(%ebp),%edi
  8016f2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8016f4:	5b                   	pop    %ebx
  8016f5:	5e                   	pop    %esi
  8016f6:	5f                   	pop    %edi
  8016f7:	5d                   	pop    %ebp
  8016f8:	c3                   	ret    

008016f9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	57                   	push   %edi
  8016fd:	56                   	push   %esi
  8016fe:	53                   	push   %ebx
  8016ff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801702:	b9 00 00 00 00       	mov    $0x0,%ecx
  801707:	b8 0d 00 00 00       	mov    $0xd,%eax
  80170c:	8b 55 08             	mov    0x8(%ebp),%edx
  80170f:	89 cb                	mov    %ecx,%ebx
  801711:	89 cf                	mov    %ecx,%edi
  801713:	89 ce                	mov    %ecx,%esi
  801715:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801717:	85 c0                	test   %eax,%eax
  801719:	7e 28                	jle    801743 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80171b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80171f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801726:	00 
  801727:	c7 44 24 08 0b 39 80 	movl   $0x80390b,0x8(%esp)
  80172e:	00 
  80172f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801736:	00 
  801737:	c7 04 24 28 39 80 00 	movl   $0x803928,(%esp)
  80173e:	e8 5f f2 ff ff       	call   8009a2 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801743:	83 c4 2c             	add    $0x2c,%esp
  801746:	5b                   	pop    %ebx
  801747:	5e                   	pop    %esi
  801748:	5f                   	pop    %edi
  801749:	5d                   	pop    %ebp
  80174a:	c3                   	ret    

0080174b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	57                   	push   %edi
  80174f:	56                   	push   %esi
  801750:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801751:	ba 00 00 00 00       	mov    $0x0,%edx
  801756:	b8 0e 00 00 00       	mov    $0xe,%eax
  80175b:	89 d1                	mov    %edx,%ecx
  80175d:	89 d3                	mov    %edx,%ebx
  80175f:	89 d7                	mov    %edx,%edi
  801761:	89 d6                	mov    %edx,%esi
  801763:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801765:	5b                   	pop    %ebx
  801766:	5e                   	pop    %esi
  801767:	5f                   	pop    %edi
  801768:	5d                   	pop    %ebp
  801769:	c3                   	ret    

0080176a <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	57                   	push   %edi
  80176e:	56                   	push   %esi
  80176f:	53                   	push   %ebx
  801770:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801773:	bb 00 00 00 00       	mov    $0x0,%ebx
  801778:	b8 0f 00 00 00       	mov    $0xf,%eax
  80177d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801780:	8b 55 08             	mov    0x8(%ebp),%edx
  801783:	89 df                	mov    %ebx,%edi
  801785:	89 de                	mov    %ebx,%esi
  801787:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801789:	85 c0                	test   %eax,%eax
  80178b:	7e 28                	jle    8017b5 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80178d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801791:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801798:	00 
  801799:	c7 44 24 08 0b 39 80 	movl   $0x80390b,0x8(%esp)
  8017a0:	00 
  8017a1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8017a8:	00 
  8017a9:	c7 04 24 28 39 80 00 	movl   $0x803928,(%esp)
  8017b0:	e8 ed f1 ff ff       	call   8009a2 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  8017b5:	83 c4 2c             	add    $0x2c,%esp
  8017b8:	5b                   	pop    %ebx
  8017b9:	5e                   	pop    %esi
  8017ba:	5f                   	pop    %edi
  8017bb:	5d                   	pop    %ebp
  8017bc:	c3                   	ret    

008017bd <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	57                   	push   %edi
  8017c1:	56                   	push   %esi
  8017c2:	53                   	push   %ebx
  8017c3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017cb:	b8 10 00 00 00       	mov    $0x10,%eax
  8017d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d6:	89 df                	mov    %ebx,%edi
  8017d8:	89 de                	mov    %ebx,%esi
  8017da:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	7e 28                	jle    801808 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017e4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8017eb:	00 
  8017ec:	c7 44 24 08 0b 39 80 	movl   $0x80390b,0x8(%esp)
  8017f3:	00 
  8017f4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8017fb:	00 
  8017fc:	c7 04 24 28 39 80 00 	movl   $0x803928,(%esp)
  801803:	e8 9a f1 ff ff       	call   8009a2 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  801808:	83 c4 2c             	add    $0x2c,%esp
  80180b:	5b                   	pop    %ebx
  80180c:	5e                   	pop    %esi
  80180d:	5f                   	pop    %edi
  80180e:	5d                   	pop    %ebp
  80180f:	c3                   	ret    

00801810 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	57                   	push   %edi
  801814:	56                   	push   %esi
  801815:	53                   	push   %ebx
  801816:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801819:	bb 00 00 00 00       	mov    $0x0,%ebx
  80181e:	b8 11 00 00 00       	mov    $0x11,%eax
  801823:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801826:	8b 55 08             	mov    0x8(%ebp),%edx
  801829:	89 df                	mov    %ebx,%edi
  80182b:	89 de                	mov    %ebx,%esi
  80182d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80182f:	85 c0                	test   %eax,%eax
  801831:	7e 28                	jle    80185b <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801833:	89 44 24 10          	mov    %eax,0x10(%esp)
  801837:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  80183e:	00 
  80183f:	c7 44 24 08 0b 39 80 	movl   $0x80390b,0x8(%esp)
  801846:	00 
  801847:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80184e:	00 
  80184f:	c7 04 24 28 39 80 00 	movl   $0x803928,(%esp)
  801856:	e8 47 f1 ff ff       	call   8009a2 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80185b:	83 c4 2c             	add    $0x2c,%esp
  80185e:	5b                   	pop    %ebx
  80185f:	5e                   	pop    %esi
  801860:	5f                   	pop    %edi
  801861:	5d                   	pop    %ebp
  801862:	c3                   	ret    

00801863 <sys_sleep>:

int
sys_sleep(int channel)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	57                   	push   %edi
  801867:	56                   	push   %esi
  801868:	53                   	push   %ebx
  801869:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80186c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801871:	b8 12 00 00 00       	mov    $0x12,%eax
  801876:	8b 55 08             	mov    0x8(%ebp),%edx
  801879:	89 cb                	mov    %ecx,%ebx
  80187b:	89 cf                	mov    %ecx,%edi
  80187d:	89 ce                	mov    %ecx,%esi
  80187f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801881:	85 c0                	test   %eax,%eax
  801883:	7e 28                	jle    8018ad <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801885:	89 44 24 10          	mov    %eax,0x10(%esp)
  801889:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801890:	00 
  801891:	c7 44 24 08 0b 39 80 	movl   $0x80390b,0x8(%esp)
  801898:	00 
  801899:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8018a0:	00 
  8018a1:	c7 04 24 28 39 80 00 	movl   $0x803928,(%esp)
  8018a8:	e8 f5 f0 ff ff       	call   8009a2 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  8018ad:	83 c4 2c             	add    $0x2c,%esp
  8018b0:	5b                   	pop    %ebx
  8018b1:	5e                   	pop    %esi
  8018b2:	5f                   	pop    %edi
  8018b3:	5d                   	pop    %ebp
  8018b4:	c3                   	ret    

008018b5 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	57                   	push   %edi
  8018b9:	56                   	push   %esi
  8018ba:	53                   	push   %ebx
  8018bb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018c3:	b8 13 00 00 00       	mov    $0x13,%eax
  8018c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ce:	89 df                	mov    %ebx,%edi
  8018d0:	89 de                	mov    %ebx,%esi
  8018d2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	7e 28                	jle    801900 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018dc:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  8018e3:	00 
  8018e4:	c7 44 24 08 0b 39 80 	movl   $0x80390b,0x8(%esp)
  8018eb:	00 
  8018ec:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8018f3:	00 
  8018f4:	c7 04 24 28 39 80 00 	movl   $0x803928,(%esp)
  8018fb:	e8 a2 f0 ff ff       	call   8009a2 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801900:	83 c4 2c             	add    $0x2c,%esp
  801903:	5b                   	pop    %ebx
  801904:	5e                   	pop    %esi
  801905:	5f                   	pop    %edi
  801906:	5d                   	pop    %ebp
  801907:	c3                   	ret    

00801908 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	53                   	push   %ebx
  80190c:	83 ec 24             	sub    $0x24,%esp
  80190f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801912:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(((err & FEC_WR) == 0) || ((uvpd[PDX(addr)] & PTE_P) == 0) || (((~uvpt[PGNUM(addr)])&(PTE_COW|PTE_P)) != 0)) {
  801914:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801918:	74 27                	je     801941 <pgfault+0x39>
  80191a:	89 c2                	mov    %eax,%edx
  80191c:	c1 ea 16             	shr    $0x16,%edx
  80191f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801926:	f6 c2 01             	test   $0x1,%dl
  801929:	74 16                	je     801941 <pgfault+0x39>
  80192b:	89 c2                	mov    %eax,%edx
  80192d:	c1 ea 0c             	shr    $0xc,%edx
  801930:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801937:	f7 d2                	not    %edx
  801939:	f7 c2 01 08 00 00    	test   $0x801,%edx
  80193f:	74 1c                	je     80195d <pgfault+0x55>
		panic("pgfault");
  801941:	c7 44 24 08 36 39 80 	movl   $0x803936,0x8(%esp)
  801948:	00 
  801949:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  801950:	00 
  801951:	c7 04 24 3e 39 80 00 	movl   $0x80393e,(%esp)
  801958:	e8 45 f0 ff ff       	call   8009a2 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	addr = (void*)ROUNDDOWN(addr,PGSIZE);
  80195d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801962:	89 c3                	mov    %eax,%ebx
	
	if(sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U) < 0) {
  801964:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80196b:	00 
  80196c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801973:	00 
  801974:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80197b:	e8 63 fb ff ff       	call   8014e3 <sys_page_alloc>
  801980:	85 c0                	test   %eax,%eax
  801982:	79 1c                	jns    8019a0 <pgfault+0x98>
		panic("pgfault(): sys_page_alloc");
  801984:	c7 44 24 08 49 39 80 	movl   $0x803949,0x8(%esp)
  80198b:	00 
  80198c:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801993:	00 
  801994:	c7 04 24 3e 39 80 00 	movl   $0x80393e,(%esp)
  80199b:	e8 02 f0 ff ff       	call   8009a2 <_panic>
	}
	memcpy((void*)PFTEMP, addr, PGSIZE);
  8019a0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8019a7:	00 
  8019a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019ac:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8019b3:	e8 14 f9 ff ff       	call   8012cc <memcpy>

	if(sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0) {
  8019b8:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8019bf:	00 
  8019c0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8019c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019cb:	00 
  8019cc:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8019d3:	00 
  8019d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019db:	e8 57 fb ff ff       	call   801537 <sys_page_map>
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	79 1c                	jns    801a00 <pgfault+0xf8>
		panic("pgfault(): sys_page_map");
  8019e4:	c7 44 24 08 63 39 80 	movl   $0x803963,0x8(%esp)
  8019eb:	00 
  8019ec:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8019f3:	00 
  8019f4:	c7 04 24 3e 39 80 00 	movl   $0x80393e,(%esp)
  8019fb:	e8 a2 ef ff ff       	call   8009a2 <_panic>
	}

	if(sys_page_unmap(0, (void*)PFTEMP) < 0) {
  801a00:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801a07:	00 
  801a08:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a0f:	e8 76 fb ff ff       	call   80158a <sys_page_unmap>
  801a14:	85 c0                	test   %eax,%eax
  801a16:	79 1c                	jns    801a34 <pgfault+0x12c>
		panic("pgfault(): sys_page_unmap");
  801a18:	c7 44 24 08 7b 39 80 	movl   $0x80397b,0x8(%esp)
  801a1f:	00 
  801a20:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801a27:	00 
  801a28:	c7 04 24 3e 39 80 00 	movl   $0x80393e,(%esp)
  801a2f:	e8 6e ef ff ff       	call   8009a2 <_panic>
	}
}
  801a34:	83 c4 24             	add    $0x24,%esp
  801a37:	5b                   	pop    %ebx
  801a38:	5d                   	pop    %ebp
  801a39:	c3                   	ret    

00801a3a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	57                   	push   %edi
  801a3e:	56                   	push   %esi
  801a3f:	53                   	push   %ebx
  801a40:	83 ec 2c             	sub    $0x2c,%esp
	set_pgfault_handler(pgfault);
  801a43:	c7 04 24 08 19 80 00 	movl   $0x801908,(%esp)
  801a4a:	e8 77 16 00 00       	call   8030c6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801a4f:	b8 07 00 00 00       	mov    $0x7,%eax
  801a54:	cd 30                	int    $0x30
  801a56:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t env_id = sys_exofork();
	if(env_id < 0){
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	79 1c                	jns    801a79 <fork+0x3f>
		panic("fork(): sys_exofork");
  801a5d:	c7 44 24 08 95 39 80 	movl   $0x803995,0x8(%esp)
  801a64:	00 
  801a65:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  801a6c:	00 
  801a6d:	c7 04 24 3e 39 80 00 	movl   $0x80393e,(%esp)
  801a74:	e8 29 ef ff ff       	call   8009a2 <_panic>
  801a79:	89 c7                	mov    %eax,%edi
	}
	else if(env_id == 0){
  801a7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a7f:	74 0a                	je     801a8b <fork+0x51>
  801a81:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801a86:	e9 9d 01 00 00       	jmp    801c28 <fork+0x1ee>
		thisenv = envs + ENVX(sys_getenvid());
  801a8b:	e8 15 fa ff ff       	call   8014a5 <sys_getenvid>
  801a90:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a95:	89 c2                	mov    %eax,%edx
  801a97:	c1 e2 07             	shl    $0x7,%edx
  801a9a:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  801aa1:	a3 20 50 80 00       	mov    %eax,0x805020
		return env_id;
  801aa6:	e9 2a 02 00 00       	jmp    801cd5 <fork+0x29b>
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
		if(addr == UXSTACKTOP - PGSIZE){
  801aab:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801ab1:	0f 84 6b 01 00 00    	je     801c22 <fork+0x1e8>
			continue;
		}
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
  801ab7:	89 d8                	mov    %ebx,%eax
  801ab9:	c1 e8 16             	shr    $0x16,%eax
  801abc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ac3:	a8 01                	test   $0x1,%al
  801ac5:	0f 84 57 01 00 00    	je     801c22 <fork+0x1e8>
  801acb:	89 d8                	mov    %ebx,%eax
  801acd:	c1 e8 0c             	shr    $0xc,%eax
  801ad0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ad7:	f7 d0                	not    %eax
  801ad9:	a8 05                	test   $0x5,%al
  801adb:	0f 85 41 01 00 00    	jne    801c22 <fork+0x1e8>
			duppage(env_id,addr/PGSIZE);
  801ae1:	89 d8                	mov    %ebx,%eax
  801ae3:	c1 e8 0c             	shr    $0xc,%eax
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void* addr = (void*)(pn*PGSIZE);
  801ae6:	89 c6                	mov    %eax,%esi
  801ae8:	c1 e6 0c             	shl    $0xc,%esi

	if (uvpt[pn] & PTE_SHARE) {
  801aeb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801af2:	f6 c6 04             	test   $0x4,%dh
  801af5:	74 4c                	je     801b43 <fork+0x109>
		if (sys_page_map(0, addr, envid, addr, uvpt[pn]&PTE_SYSCALL) < 0)
  801af7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801afe:	25 07 0e 00 00       	and    $0xe07,%eax
  801b03:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b07:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801b0b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801b0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b13:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b1a:	e8 18 fa ff ff       	call   801537 <sys_page_map>
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	0f 89 fb 00 00 00    	jns    801c22 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801b27:	c7 44 24 08 a9 39 80 	movl   $0x8039a9,0x8(%esp)
  801b2e:	00 
  801b2f:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801b36:	00 
  801b37:	c7 04 24 3e 39 80 00 	movl   $0x80393e,(%esp)
  801b3e:	e8 5f ee ff ff       	call   8009a2 <_panic>
	} else if((uvpt[pn] & PTE_COW) || (uvpt[pn] & PTE_W)) {
  801b43:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b4a:	f6 c6 08             	test   $0x8,%dh
  801b4d:	75 0f                	jne    801b5e <fork+0x124>
  801b4f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b56:	a8 02                	test   $0x2,%al
  801b58:	0f 84 84 00 00 00    	je     801be2 <fork+0x1a8>
		if(sys_page_map(0, addr, envid, addr, PTE_COW | PTE_U | PTE_P) < 0){
  801b5e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801b65:	00 
  801b66:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801b6a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801b6e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b79:	e8 b9 f9 ff ff       	call   801537 <sys_page_map>
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	79 1c                	jns    801b9e <fork+0x164>
			panic("duppage: sys_page_map");
  801b82:	c7 44 24 08 a9 39 80 	movl   $0x8039a9,0x8(%esp)
  801b89:	00 
  801b8a:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  801b91:	00 
  801b92:	c7 04 24 3e 39 80 00 	movl   $0x80393e,(%esp)
  801b99:	e8 04 ee ff ff       	call   8009a2 <_panic>
		}
		if(sys_page_map(0, addr, 0, addr, PTE_COW | PTE_U | PTE_P) < 0){
  801b9e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801ba5:	00 
  801ba6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801baa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bb1:	00 
  801bb2:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bb6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bbd:	e8 75 f9 ff ff       	call   801537 <sys_page_map>
  801bc2:	85 c0                	test   %eax,%eax
  801bc4:	79 5c                	jns    801c22 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801bc6:	c7 44 24 08 a9 39 80 	movl   $0x8039a9,0x8(%esp)
  801bcd:	00 
  801bce:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  801bd5:	00 
  801bd6:	c7 04 24 3e 39 80 00 	movl   $0x80393e,(%esp)
  801bdd:	e8 c0 ed ff ff       	call   8009a2 <_panic>
		}
	} else {
		if(sys_page_map(0, addr, envid, addr, PTE_U | PTE_P) < 0){
  801be2:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801be9:	00 
  801bea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801bee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801bf2:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bf6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bfd:	e8 35 f9 ff ff       	call   801537 <sys_page_map>
  801c02:	85 c0                	test   %eax,%eax
  801c04:	79 1c                	jns    801c22 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801c06:	c7 44 24 08 a9 39 80 	movl   $0x8039a9,0x8(%esp)
  801c0d:	00 
  801c0e:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  801c15:	00 
  801c16:	c7 04 24 3e 39 80 00 	movl   $0x80393e,(%esp)
  801c1d:	e8 80 ed ff ff       	call   8009a2 <_panic>
		thisenv = envs + ENVX(sys_getenvid());
		return env_id;
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
  801c22:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c28:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801c2e:	0f 85 77 fe ff ff    	jne    801aab <fork+0x71>
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
			duppage(env_id,addr/PGSIZE);
		}
	}

	if(sys_page_alloc(env_id, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) {
  801c34:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c3b:	00 
  801c3c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801c43:	ee 
  801c44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c47:	89 04 24             	mov    %eax,(%esp)
  801c4a:	e8 94 f8 ff ff       	call   8014e3 <sys_page_alloc>
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	79 1c                	jns    801c6f <fork+0x235>
		panic("fork(): sys_page_alloc");
  801c53:	c7 44 24 08 bf 39 80 	movl   $0x8039bf,0x8(%esp)
  801c5a:	00 
  801c5b:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801c62:	00 
  801c63:	c7 04 24 3e 39 80 00 	movl   $0x80393e,(%esp)
  801c6a:	e8 33 ed ff ff       	call   8009a2 <_panic>
	}

	extern void _pgfault_upcall(void);
	if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0) {
  801c6f:	c7 44 24 04 4f 31 80 	movl   $0x80314f,0x4(%esp)
  801c76:	00 
  801c77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c7a:	89 04 24             	mov    %eax,(%esp)
  801c7d:	e8 01 fa ff ff       	call   801683 <sys_env_set_pgfault_upcall>
  801c82:	85 c0                	test   %eax,%eax
  801c84:	79 1c                	jns    801ca2 <fork+0x268>
		panic("fork(): ys_env_set_pgfault_upcall");
  801c86:	c7 44 24 08 08 3a 80 	movl   $0x803a08,0x8(%esp)
  801c8d:	00 
  801c8e:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  801c95:	00 
  801c96:	c7 04 24 3e 39 80 00 	movl   $0x80393e,(%esp)
  801c9d:	e8 00 ed ff ff       	call   8009a2 <_panic>
	}

	if(sys_env_set_status(env_id, ENV_RUNNABLE) < 0) {
  801ca2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801ca9:	00 
  801caa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cad:	89 04 24             	mov    %eax,(%esp)
  801cb0:	e8 28 f9 ff ff       	call   8015dd <sys_env_set_status>
  801cb5:	85 c0                	test   %eax,%eax
  801cb7:	79 1c                	jns    801cd5 <fork+0x29b>
		panic("fork(): sys_env_set_status");
  801cb9:	c7 44 24 08 d6 39 80 	movl   $0x8039d6,0x8(%esp)
  801cc0:	00 
  801cc1:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  801cc8:	00 
  801cc9:	c7 04 24 3e 39 80 00 	movl   $0x80393e,(%esp)
  801cd0:	e8 cd ec ff ff       	call   8009a2 <_panic>
	}

	return env_id;
}
  801cd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cd8:	83 c4 2c             	add    $0x2c,%esp
  801cdb:	5b                   	pop    %ebx
  801cdc:	5e                   	pop    %esi
  801cdd:	5f                   	pop    %edi
  801cde:	5d                   	pop    %ebp
  801cdf:	c3                   	ret    

00801ce0 <sfork>:

// Challenge!
int
sfork(void)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801ce6:	c7 44 24 08 f1 39 80 	movl   $0x8039f1,0x8(%esp)
  801ced:	00 
  801cee:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  801cf5:	00 
  801cf6:	c7 04 24 3e 39 80 00 	movl   $0x80393e,(%esp)
  801cfd:	e8 a0 ec ff ff       	call   8009a2 <_panic>
  801d02:	66 90                	xchg   %ax,%ax
  801d04:	66 90                	xchg   %ax,%ax
  801d06:	66 90                	xchg   %ax,%ax
  801d08:	66 90                	xchg   %ax,%ax
  801d0a:	66 90                	xchg   %ax,%ax
  801d0c:	66 90                	xchg   %ax,%ax
  801d0e:	66 90                	xchg   %ax,%ax

00801d10 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	56                   	push   %esi
  801d14:	53                   	push   %ebx
  801d15:	83 ec 10             	sub    $0x10,%esp
  801d18:	8b 75 08             	mov    0x8(%ebp),%esi
  801d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801d21:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  801d23:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d28:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  801d2b:	89 04 24             	mov    %eax,(%esp)
  801d2e:	e8 c6 f9 ff ff       	call   8016f9 <sys_ipc_recv>
  801d33:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  801d35:	85 d2                	test   %edx,%edx
  801d37:	75 24                	jne    801d5d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  801d39:	85 f6                	test   %esi,%esi
  801d3b:	74 0a                	je     801d47 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  801d3d:	a1 20 50 80 00       	mov    0x805020,%eax
  801d42:	8b 40 74             	mov    0x74(%eax),%eax
  801d45:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  801d47:	85 db                	test   %ebx,%ebx
  801d49:	74 0a                	je     801d55 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  801d4b:	a1 20 50 80 00       	mov    0x805020,%eax
  801d50:	8b 40 78             	mov    0x78(%eax),%eax
  801d53:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  801d55:	a1 20 50 80 00       	mov    0x805020,%eax
  801d5a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  801d5d:	83 c4 10             	add    $0x10,%esp
  801d60:	5b                   	pop    %ebx
  801d61:	5e                   	pop    %esi
  801d62:	5d                   	pop    %ebp
  801d63:	c3                   	ret    

00801d64 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	57                   	push   %edi
  801d68:	56                   	push   %esi
  801d69:	53                   	push   %ebx
  801d6a:	83 ec 1c             	sub    $0x1c,%esp
  801d6d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d70:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d73:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  801d76:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  801d78:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801d7d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801d80:	8b 45 14             	mov    0x14(%ebp),%eax
  801d83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d8b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d8f:	89 3c 24             	mov    %edi,(%esp)
  801d92:	e8 3f f9 ff ff       	call   8016d6 <sys_ipc_try_send>

		if (ret == 0)
  801d97:	85 c0                	test   %eax,%eax
  801d99:	74 2c                	je     801dc7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  801d9b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d9e:	74 20                	je     801dc0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  801da0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801da4:	c7 44 24 08 2c 3a 80 	movl   $0x803a2c,0x8(%esp)
  801dab:	00 
  801dac:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  801db3:	00 
  801db4:	c7 04 24 5a 3a 80 00 	movl   $0x803a5a,(%esp)
  801dbb:	e8 e2 eb ff ff       	call   8009a2 <_panic>
		}

		sys_yield();
  801dc0:	e8 ff f6 ff ff       	call   8014c4 <sys_yield>
	}
  801dc5:	eb b9                	jmp    801d80 <ipc_send+0x1c>
}
  801dc7:	83 c4 1c             	add    $0x1c,%esp
  801dca:	5b                   	pop    %ebx
  801dcb:	5e                   	pop    %esi
  801dcc:	5f                   	pop    %edi
  801dcd:	5d                   	pop    %ebp
  801dce:	c3                   	ret    

00801dcf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801dda:	89 c2                	mov    %eax,%edx
  801ddc:	c1 e2 07             	shl    $0x7,%edx
  801ddf:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  801de6:	8b 52 50             	mov    0x50(%edx),%edx
  801de9:	39 ca                	cmp    %ecx,%edx
  801deb:	75 11                	jne    801dfe <ipc_find_env+0x2f>
			return envs[i].env_id;
  801ded:	89 c2                	mov    %eax,%edx
  801def:	c1 e2 07             	shl    $0x7,%edx
  801df2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  801df9:	8b 40 40             	mov    0x40(%eax),%eax
  801dfc:	eb 0e                	jmp    801e0c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801dfe:	83 c0 01             	add    $0x1,%eax
  801e01:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e06:	75 d2                	jne    801dda <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801e08:	66 b8 00 00          	mov    $0x0,%ax
}
  801e0c:	5d                   	pop    %ebp
  801e0d:	c3                   	ret    
  801e0e:	66 90                	xchg   %ax,%ax

00801e10 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	05 00 00 00 30       	add    $0x30000000,%eax
  801e1b:	c1 e8 0c             	shr    $0xc,%eax
}
  801e1e:	5d                   	pop    %ebp
  801e1f:	c3                   	ret    

00801e20 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  801e2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e30:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801e35:	5d                   	pop    %ebp
  801e36:	c3                   	ret    

00801e37 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e3d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e42:	89 c2                	mov    %eax,%edx
  801e44:	c1 ea 16             	shr    $0x16,%edx
  801e47:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801e4e:	f6 c2 01             	test   $0x1,%dl
  801e51:	74 11                	je     801e64 <fd_alloc+0x2d>
  801e53:	89 c2                	mov    %eax,%edx
  801e55:	c1 ea 0c             	shr    $0xc,%edx
  801e58:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e5f:	f6 c2 01             	test   $0x1,%dl
  801e62:	75 09                	jne    801e6d <fd_alloc+0x36>
			*fd_store = fd;
  801e64:	89 01                	mov    %eax,(%ecx)
			return 0;
  801e66:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6b:	eb 17                	jmp    801e84 <fd_alloc+0x4d>
  801e6d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e72:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801e77:	75 c9                	jne    801e42 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e79:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801e7f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801e84:	5d                   	pop    %ebp
  801e85:	c3                   	ret    

00801e86 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e8c:	83 f8 1f             	cmp    $0x1f,%eax
  801e8f:	77 36                	ja     801ec7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801e91:	c1 e0 0c             	shl    $0xc,%eax
  801e94:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e99:	89 c2                	mov    %eax,%edx
  801e9b:	c1 ea 16             	shr    $0x16,%edx
  801e9e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801ea5:	f6 c2 01             	test   $0x1,%dl
  801ea8:	74 24                	je     801ece <fd_lookup+0x48>
  801eaa:	89 c2                	mov    %eax,%edx
  801eac:	c1 ea 0c             	shr    $0xc,%edx
  801eaf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801eb6:	f6 c2 01             	test   $0x1,%dl
  801eb9:	74 1a                	je     801ed5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801ebb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebe:	89 02                	mov    %eax,(%edx)
	return 0;
  801ec0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec5:	eb 13                	jmp    801eda <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ec7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ecc:	eb 0c                	jmp    801eda <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ece:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ed3:	eb 05                	jmp    801eda <fd_lookup+0x54>
  801ed5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801eda:	5d                   	pop    %ebp
  801edb:	c3                   	ret    

00801edc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	83 ec 18             	sub    $0x18,%esp
  801ee2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801ee5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eea:	eb 13                	jmp    801eff <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  801eec:	39 08                	cmp    %ecx,(%eax)
  801eee:	75 0c                	jne    801efc <dev_lookup+0x20>
			*dev = devtab[i];
  801ef0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ef3:	89 01                	mov    %eax,(%ecx)
			return 0;
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  801efa:	eb 38                	jmp    801f34 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801efc:	83 c2 01             	add    $0x1,%edx
  801eff:	8b 04 95 e0 3a 80 00 	mov    0x803ae0(,%edx,4),%eax
  801f06:	85 c0                	test   %eax,%eax
  801f08:	75 e2                	jne    801eec <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f0a:	a1 20 50 80 00       	mov    0x805020,%eax
  801f0f:	8b 40 48             	mov    0x48(%eax),%eax
  801f12:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f16:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f1a:	c7 04 24 64 3a 80 00 	movl   $0x803a64,(%esp)
  801f21:	e8 75 eb ff ff       	call   800a9b <cprintf>
	*dev = 0;
  801f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801f2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	56                   	push   %esi
  801f3a:	53                   	push   %ebx
  801f3b:	83 ec 20             	sub    $0x20,%esp
  801f3e:	8b 75 08             	mov    0x8(%ebp),%esi
  801f41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f47:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f4b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801f51:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f54:	89 04 24             	mov    %eax,(%esp)
  801f57:	e8 2a ff ff ff       	call   801e86 <fd_lookup>
  801f5c:	85 c0                	test   %eax,%eax
  801f5e:	78 05                	js     801f65 <fd_close+0x2f>
	    || fd != fd2)
  801f60:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801f63:	74 0c                	je     801f71 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801f65:	84 db                	test   %bl,%bl
  801f67:	ba 00 00 00 00       	mov    $0x0,%edx
  801f6c:	0f 44 c2             	cmove  %edx,%eax
  801f6f:	eb 3f                	jmp    801fb0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f71:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f78:	8b 06                	mov    (%esi),%eax
  801f7a:	89 04 24             	mov    %eax,(%esp)
  801f7d:	e8 5a ff ff ff       	call   801edc <dev_lookup>
  801f82:	89 c3                	mov    %eax,%ebx
  801f84:	85 c0                	test   %eax,%eax
  801f86:	78 16                	js     801f9e <fd_close+0x68>
		if (dev->dev_close)
  801f88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801f8e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801f93:	85 c0                	test   %eax,%eax
  801f95:	74 07                	je     801f9e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801f97:	89 34 24             	mov    %esi,(%esp)
  801f9a:	ff d0                	call   *%eax
  801f9c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f9e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fa2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fa9:	e8 dc f5 ff ff       	call   80158a <sys_page_unmap>
	return r;
  801fae:	89 d8                	mov    %ebx,%eax
}
  801fb0:	83 c4 20             	add    $0x20,%esp
  801fb3:	5b                   	pop    %ebx
  801fb4:	5e                   	pop    %esi
  801fb5:	5d                   	pop    %ebp
  801fb6:	c3                   	ret    

00801fb7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fbd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	89 04 24             	mov    %eax,(%esp)
  801fca:	e8 b7 fe ff ff       	call   801e86 <fd_lookup>
  801fcf:	89 c2                	mov    %eax,%edx
  801fd1:	85 d2                	test   %edx,%edx
  801fd3:	78 13                	js     801fe8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801fd5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801fdc:	00 
  801fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe0:	89 04 24             	mov    %eax,(%esp)
  801fe3:	e8 4e ff ff ff       	call   801f36 <fd_close>
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <close_all>:

void
close_all(void)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	53                   	push   %ebx
  801fee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801ff1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801ff6:	89 1c 24             	mov    %ebx,(%esp)
  801ff9:	e8 b9 ff ff ff       	call   801fb7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801ffe:	83 c3 01             	add    $0x1,%ebx
  802001:	83 fb 20             	cmp    $0x20,%ebx
  802004:	75 f0                	jne    801ff6 <close_all+0xc>
		close(i);
}
  802006:	83 c4 14             	add    $0x14,%esp
  802009:	5b                   	pop    %ebx
  80200a:	5d                   	pop    %ebp
  80200b:	c3                   	ret    

0080200c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	57                   	push   %edi
  802010:	56                   	push   %esi
  802011:	53                   	push   %ebx
  802012:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802015:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802018:	89 44 24 04          	mov    %eax,0x4(%esp)
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	89 04 24             	mov    %eax,(%esp)
  802022:	e8 5f fe ff ff       	call   801e86 <fd_lookup>
  802027:	89 c2                	mov    %eax,%edx
  802029:	85 d2                	test   %edx,%edx
  80202b:	0f 88 e1 00 00 00    	js     802112 <dup+0x106>
		return r;
	close(newfdnum);
  802031:	8b 45 0c             	mov    0xc(%ebp),%eax
  802034:	89 04 24             	mov    %eax,(%esp)
  802037:	e8 7b ff ff ff       	call   801fb7 <close>

	newfd = INDEX2FD(newfdnum);
  80203c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80203f:	c1 e3 0c             	shl    $0xc,%ebx
  802042:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  802048:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80204b:	89 04 24             	mov    %eax,(%esp)
  80204e:	e8 cd fd ff ff       	call   801e20 <fd2data>
  802053:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  802055:	89 1c 24             	mov    %ebx,(%esp)
  802058:	e8 c3 fd ff ff       	call   801e20 <fd2data>
  80205d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80205f:	89 f0                	mov    %esi,%eax
  802061:	c1 e8 16             	shr    $0x16,%eax
  802064:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80206b:	a8 01                	test   $0x1,%al
  80206d:	74 43                	je     8020b2 <dup+0xa6>
  80206f:	89 f0                	mov    %esi,%eax
  802071:	c1 e8 0c             	shr    $0xc,%eax
  802074:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80207b:	f6 c2 01             	test   $0x1,%dl
  80207e:	74 32                	je     8020b2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802080:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802087:	25 07 0e 00 00       	and    $0xe07,%eax
  80208c:	89 44 24 10          	mov    %eax,0x10(%esp)
  802090:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802094:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80209b:	00 
  80209c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a7:	e8 8b f4 ff ff       	call   801537 <sys_page_map>
  8020ac:	89 c6                	mov    %eax,%esi
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	78 3e                	js     8020f0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8020b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020b5:	89 c2                	mov    %eax,%edx
  8020b7:	c1 ea 0c             	shr    $0xc,%edx
  8020ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8020c1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8020c7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8020cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020d6:	00 
  8020d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020e2:	e8 50 f4 ff ff       	call   801537 <sys_page_map>
  8020e7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8020e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8020ec:	85 f6                	test   %esi,%esi
  8020ee:	79 22                	jns    802112 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8020f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020fb:	e8 8a f4 ff ff       	call   80158a <sys_page_unmap>
	sys_page_unmap(0, nva);
  802100:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802104:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80210b:	e8 7a f4 ff ff       	call   80158a <sys_page_unmap>
	return r;
  802110:	89 f0                	mov    %esi,%eax
}
  802112:	83 c4 3c             	add    $0x3c,%esp
  802115:	5b                   	pop    %ebx
  802116:	5e                   	pop    %esi
  802117:	5f                   	pop    %edi
  802118:	5d                   	pop    %ebp
  802119:	c3                   	ret    

0080211a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	53                   	push   %ebx
  80211e:	83 ec 24             	sub    $0x24,%esp
  802121:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802124:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802127:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212b:	89 1c 24             	mov    %ebx,(%esp)
  80212e:	e8 53 fd ff ff       	call   801e86 <fd_lookup>
  802133:	89 c2                	mov    %eax,%edx
  802135:	85 d2                	test   %edx,%edx
  802137:	78 6d                	js     8021a6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802139:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802143:	8b 00                	mov    (%eax),%eax
  802145:	89 04 24             	mov    %eax,(%esp)
  802148:	e8 8f fd ff ff       	call   801edc <dev_lookup>
  80214d:	85 c0                	test   %eax,%eax
  80214f:	78 55                	js     8021a6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802154:	8b 50 08             	mov    0x8(%eax),%edx
  802157:	83 e2 03             	and    $0x3,%edx
  80215a:	83 fa 01             	cmp    $0x1,%edx
  80215d:	75 23                	jne    802182 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80215f:	a1 20 50 80 00       	mov    0x805020,%eax
  802164:	8b 40 48             	mov    0x48(%eax),%eax
  802167:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80216b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216f:	c7 04 24 a5 3a 80 00 	movl   $0x803aa5,(%esp)
  802176:	e8 20 e9 ff ff       	call   800a9b <cprintf>
		return -E_INVAL;
  80217b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802180:	eb 24                	jmp    8021a6 <read+0x8c>
	}
	if (!dev->dev_read)
  802182:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802185:	8b 52 08             	mov    0x8(%edx),%edx
  802188:	85 d2                	test   %edx,%edx
  80218a:	74 15                	je     8021a1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80218c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80218f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802193:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802196:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80219a:	89 04 24             	mov    %eax,(%esp)
  80219d:	ff d2                	call   *%edx
  80219f:	eb 05                	jmp    8021a6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8021a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8021a6:	83 c4 24             	add    $0x24,%esp
  8021a9:	5b                   	pop    %ebx
  8021aa:	5d                   	pop    %ebp
  8021ab:	c3                   	ret    

008021ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	57                   	push   %edi
  8021b0:	56                   	push   %esi
  8021b1:	53                   	push   %ebx
  8021b2:	83 ec 1c             	sub    $0x1c,%esp
  8021b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8021bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021c0:	eb 23                	jmp    8021e5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8021c2:	89 f0                	mov    %esi,%eax
  8021c4:	29 d8                	sub    %ebx,%eax
  8021c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021ca:	89 d8                	mov    %ebx,%eax
  8021cc:	03 45 0c             	add    0xc(%ebp),%eax
  8021cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d3:	89 3c 24             	mov    %edi,(%esp)
  8021d6:	e8 3f ff ff ff       	call   80211a <read>
		if (m < 0)
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	78 10                	js     8021ef <readn+0x43>
			return m;
		if (m == 0)
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	74 0a                	je     8021ed <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8021e3:	01 c3                	add    %eax,%ebx
  8021e5:	39 f3                	cmp    %esi,%ebx
  8021e7:	72 d9                	jb     8021c2 <readn+0x16>
  8021e9:	89 d8                	mov    %ebx,%eax
  8021eb:	eb 02                	jmp    8021ef <readn+0x43>
  8021ed:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8021ef:	83 c4 1c             	add    $0x1c,%esp
  8021f2:	5b                   	pop    %ebx
  8021f3:	5e                   	pop    %esi
  8021f4:	5f                   	pop    %edi
  8021f5:	5d                   	pop    %ebp
  8021f6:	c3                   	ret    

008021f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	53                   	push   %ebx
  8021fb:	83 ec 24             	sub    $0x24,%esp
  8021fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802201:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802204:	89 44 24 04          	mov    %eax,0x4(%esp)
  802208:	89 1c 24             	mov    %ebx,(%esp)
  80220b:	e8 76 fc ff ff       	call   801e86 <fd_lookup>
  802210:	89 c2                	mov    %eax,%edx
  802212:	85 d2                	test   %edx,%edx
  802214:	78 68                	js     80227e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802216:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802219:	89 44 24 04          	mov    %eax,0x4(%esp)
  80221d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802220:	8b 00                	mov    (%eax),%eax
  802222:	89 04 24             	mov    %eax,(%esp)
  802225:	e8 b2 fc ff ff       	call   801edc <dev_lookup>
  80222a:	85 c0                	test   %eax,%eax
  80222c:	78 50                	js     80227e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80222e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802231:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802235:	75 23                	jne    80225a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802237:	a1 20 50 80 00       	mov    0x805020,%eax
  80223c:	8b 40 48             	mov    0x48(%eax),%eax
  80223f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802243:	89 44 24 04          	mov    %eax,0x4(%esp)
  802247:	c7 04 24 c1 3a 80 00 	movl   $0x803ac1,(%esp)
  80224e:	e8 48 e8 ff ff       	call   800a9b <cprintf>
		return -E_INVAL;
  802253:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802258:	eb 24                	jmp    80227e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80225a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225d:	8b 52 0c             	mov    0xc(%edx),%edx
  802260:	85 d2                	test   %edx,%edx
  802262:	74 15                	je     802279 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802264:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802267:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80226b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80226e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802272:	89 04 24             	mov    %eax,(%esp)
  802275:	ff d2                	call   *%edx
  802277:	eb 05                	jmp    80227e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  802279:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80227e:	83 c4 24             	add    $0x24,%esp
  802281:	5b                   	pop    %ebx
  802282:	5d                   	pop    %ebp
  802283:	c3                   	ret    

00802284 <seek>:

int
seek(int fdnum, off_t offset)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
  802287:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80228a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80228d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	89 04 24             	mov    %eax,(%esp)
  802297:	e8 ea fb ff ff       	call   801e86 <fd_lookup>
  80229c:	85 c0                	test   %eax,%eax
  80229e:	78 0e                	js     8022ae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8022a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8022a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	53                   	push   %ebx
  8022b4:	83 ec 24             	sub    $0x24,%esp
  8022b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c1:	89 1c 24             	mov    %ebx,(%esp)
  8022c4:	e8 bd fb ff ff       	call   801e86 <fd_lookup>
  8022c9:	89 c2                	mov    %eax,%edx
  8022cb:	85 d2                	test   %edx,%edx
  8022cd:	78 61                	js     802330 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d9:	8b 00                	mov    (%eax),%eax
  8022db:	89 04 24             	mov    %eax,(%esp)
  8022de:	e8 f9 fb ff ff       	call   801edc <dev_lookup>
  8022e3:	85 c0                	test   %eax,%eax
  8022e5:	78 49                	js     802330 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8022ee:	75 23                	jne    802313 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8022f0:	a1 20 50 80 00       	mov    0x805020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8022f5:	8b 40 48             	mov    0x48(%eax),%eax
  8022f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802300:	c7 04 24 84 3a 80 00 	movl   $0x803a84,(%esp)
  802307:	e8 8f e7 ff ff       	call   800a9b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80230c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802311:	eb 1d                	jmp    802330 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  802313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802316:	8b 52 18             	mov    0x18(%edx),%edx
  802319:	85 d2                	test   %edx,%edx
  80231b:	74 0e                	je     80232b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80231d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802320:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802324:	89 04 24             	mov    %eax,(%esp)
  802327:	ff d2                	call   *%edx
  802329:	eb 05                	jmp    802330 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80232b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  802330:	83 c4 24             	add    $0x24,%esp
  802333:	5b                   	pop    %ebx
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    

00802336 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	53                   	push   %ebx
  80233a:	83 ec 24             	sub    $0x24,%esp
  80233d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802340:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802343:	89 44 24 04          	mov    %eax,0x4(%esp)
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	89 04 24             	mov    %eax,(%esp)
  80234d:	e8 34 fb ff ff       	call   801e86 <fd_lookup>
  802352:	89 c2                	mov    %eax,%edx
  802354:	85 d2                	test   %edx,%edx
  802356:	78 52                	js     8023aa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802358:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80235b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80235f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802362:	8b 00                	mov    (%eax),%eax
  802364:	89 04 24             	mov    %eax,(%esp)
  802367:	e8 70 fb ff ff       	call   801edc <dev_lookup>
  80236c:	85 c0                	test   %eax,%eax
  80236e:	78 3a                	js     8023aa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802377:	74 2c                	je     8023a5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802379:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80237c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802383:	00 00 00 
	stat->st_isdir = 0;
  802386:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80238d:	00 00 00 
	stat->st_dev = dev;
  802390:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802396:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80239a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80239d:	89 14 24             	mov    %edx,(%esp)
  8023a0:	ff 50 14             	call   *0x14(%eax)
  8023a3:	eb 05                	jmp    8023aa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8023a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8023aa:	83 c4 24             	add    $0x24,%esp
  8023ad:	5b                   	pop    %ebx
  8023ae:	5d                   	pop    %ebp
  8023af:	c3                   	ret    

008023b0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	56                   	push   %esi
  8023b4:	53                   	push   %ebx
  8023b5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8023b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023bf:	00 
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	89 04 24             	mov    %eax,(%esp)
  8023c6:	e8 1b 02 00 00       	call   8025e6 <open>
  8023cb:	89 c3                	mov    %eax,%ebx
  8023cd:	85 db                	test   %ebx,%ebx
  8023cf:	78 1b                	js     8023ec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8023d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d8:	89 1c 24             	mov    %ebx,(%esp)
  8023db:	e8 56 ff ff ff       	call   802336 <fstat>
  8023e0:	89 c6                	mov    %eax,%esi
	close(fd);
  8023e2:	89 1c 24             	mov    %ebx,(%esp)
  8023e5:	e8 cd fb ff ff       	call   801fb7 <close>
	return r;
  8023ea:	89 f0                	mov    %esi,%eax
}
  8023ec:	83 c4 10             	add    $0x10,%esp
  8023ef:	5b                   	pop    %ebx
  8023f0:	5e                   	pop    %esi
  8023f1:	5d                   	pop    %ebp
  8023f2:	c3                   	ret    

008023f3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
  8023f6:	56                   	push   %esi
  8023f7:	53                   	push   %ebx
  8023f8:	83 ec 10             	sub    $0x10,%esp
  8023fb:	89 c6                	mov    %eax,%esi
  8023fd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8023ff:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  802406:	75 11                	jne    802419 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802408:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80240f:	e8 bb f9 ff ff       	call   801dcf <ipc_find_env>
  802414:	a3 18 50 80 00       	mov    %eax,0x805018
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802419:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802420:	00 
  802421:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  802428:	00 
  802429:	89 74 24 04          	mov    %esi,0x4(%esp)
  80242d:	a1 18 50 80 00       	mov    0x805018,%eax
  802432:	89 04 24             	mov    %eax,(%esp)
  802435:	e8 2a f9 ff ff       	call   801d64 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80243a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802441:	00 
  802442:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802446:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80244d:	e8 be f8 ff ff       	call   801d10 <ipc_recv>
}
  802452:	83 c4 10             	add    $0x10,%esp
  802455:	5b                   	pop    %ebx
  802456:	5e                   	pop    %esi
  802457:	5d                   	pop    %ebp
  802458:	c3                   	ret    

00802459 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	8b 40 0c             	mov    0xc(%eax),%eax
  802465:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80246a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80246d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802472:	ba 00 00 00 00       	mov    $0x0,%edx
  802477:	b8 02 00 00 00       	mov    $0x2,%eax
  80247c:	e8 72 ff ff ff       	call   8023f3 <fsipc>
}
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
  802486:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	8b 40 0c             	mov    0xc(%eax),%eax
  80248f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  802494:	ba 00 00 00 00       	mov    $0x0,%edx
  802499:	b8 06 00 00 00       	mov    $0x6,%eax
  80249e:	e8 50 ff ff ff       	call   8023f3 <fsipc>
}
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
  8024a8:	53                   	push   %ebx
  8024a9:	83 ec 14             	sub    $0x14,%esp
  8024ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8024af:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8024ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8024bf:	b8 05 00 00 00       	mov    $0x5,%eax
  8024c4:	e8 2a ff ff ff       	call   8023f3 <fsipc>
  8024c9:	89 c2                	mov    %eax,%edx
  8024cb:	85 d2                	test   %edx,%edx
  8024cd:	78 2b                	js     8024fa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8024cf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8024d6:	00 
  8024d7:	89 1c 24             	mov    %ebx,(%esp)
  8024da:	e8 e8 eb ff ff       	call   8010c7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8024df:	a1 80 60 80 00       	mov    0x806080,%eax
  8024e4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8024ea:	a1 84 60 80 00       	mov    0x806084,%eax
  8024ef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8024f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024fa:	83 c4 14             	add    $0x14,%esp
  8024fd:	5b                   	pop    %ebx
  8024fe:	5d                   	pop    %ebp
  8024ff:	c3                   	ret    

00802500 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	83 ec 18             	sub    $0x18,%esp
  802506:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802509:	8b 55 08             	mov    0x8(%ebp),%edx
  80250c:	8b 52 0c             	mov    0xc(%edx),%edx
  80250f:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  802515:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80251a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80251e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802521:	89 44 24 04          	mov    %eax,0x4(%esp)
  802525:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  80252c:	e8 9b ed ff ff       	call   8012cc <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  802531:	ba 00 00 00 00       	mov    $0x0,%edx
  802536:	b8 04 00 00 00       	mov    $0x4,%eax
  80253b:	e8 b3 fe ff ff       	call   8023f3 <fsipc>
		return r;
	}

	return r;
}
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
  802545:	56                   	push   %esi
  802546:	53                   	push   %ebx
  802547:	83 ec 10             	sub    $0x10,%esp
  80254a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	8b 40 0c             	mov    0xc(%eax),%eax
  802553:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802558:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80255e:	ba 00 00 00 00       	mov    $0x0,%edx
  802563:	b8 03 00 00 00       	mov    $0x3,%eax
  802568:	e8 86 fe ff ff       	call   8023f3 <fsipc>
  80256d:	89 c3                	mov    %eax,%ebx
  80256f:	85 c0                	test   %eax,%eax
  802571:	78 6a                	js     8025dd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  802573:	39 c6                	cmp    %eax,%esi
  802575:	73 24                	jae    80259b <devfile_read+0x59>
  802577:	c7 44 24 0c f4 3a 80 	movl   $0x803af4,0xc(%esp)
  80257e:	00 
  80257f:	c7 44 24 08 fb 3a 80 	movl   $0x803afb,0x8(%esp)
  802586:	00 
  802587:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80258e:	00 
  80258f:	c7 04 24 10 3b 80 00 	movl   $0x803b10,(%esp)
  802596:	e8 07 e4 ff ff       	call   8009a2 <_panic>
	assert(r <= PGSIZE);
  80259b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8025a0:	7e 24                	jle    8025c6 <devfile_read+0x84>
  8025a2:	c7 44 24 0c 1b 3b 80 	movl   $0x803b1b,0xc(%esp)
  8025a9:	00 
  8025aa:	c7 44 24 08 fb 3a 80 	movl   $0x803afb,0x8(%esp)
  8025b1:	00 
  8025b2:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8025b9:	00 
  8025ba:	c7 04 24 10 3b 80 00 	movl   $0x803b10,(%esp)
  8025c1:	e8 dc e3 ff ff       	call   8009a2 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8025c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025ca:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8025d1:	00 
  8025d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d5:	89 04 24             	mov    %eax,(%esp)
  8025d8:	e8 87 ec ff ff       	call   801264 <memmove>
	return r;
}
  8025dd:	89 d8                	mov    %ebx,%eax
  8025df:	83 c4 10             	add    $0x10,%esp
  8025e2:	5b                   	pop    %ebx
  8025e3:	5e                   	pop    %esi
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    

008025e6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8025e6:	55                   	push   %ebp
  8025e7:	89 e5                	mov    %esp,%ebp
  8025e9:	53                   	push   %ebx
  8025ea:	83 ec 24             	sub    $0x24,%esp
  8025ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8025f0:	89 1c 24             	mov    %ebx,(%esp)
  8025f3:	e8 98 ea ff ff       	call   801090 <strlen>
  8025f8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8025fd:	7f 60                	jg     80265f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8025ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802602:	89 04 24             	mov    %eax,(%esp)
  802605:	e8 2d f8 ff ff       	call   801e37 <fd_alloc>
  80260a:	89 c2                	mov    %eax,%edx
  80260c:	85 d2                	test   %edx,%edx
  80260e:	78 54                	js     802664 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  802610:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802614:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  80261b:	e8 a7 ea ff ff       	call   8010c7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802620:	8b 45 0c             	mov    0xc(%ebp),%eax
  802623:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802628:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262b:	b8 01 00 00 00       	mov    $0x1,%eax
  802630:	e8 be fd ff ff       	call   8023f3 <fsipc>
  802635:	89 c3                	mov    %eax,%ebx
  802637:	85 c0                	test   %eax,%eax
  802639:	79 17                	jns    802652 <open+0x6c>
		fd_close(fd, 0);
  80263b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802642:	00 
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	89 04 24             	mov    %eax,(%esp)
  802649:	e8 e8 f8 ff ff       	call   801f36 <fd_close>
		return r;
  80264e:	89 d8                	mov    %ebx,%eax
  802650:	eb 12                	jmp    802664 <open+0x7e>
	}

	return fd2num(fd);
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	89 04 24             	mov    %eax,(%esp)
  802658:	e8 b3 f7 ff ff       	call   801e10 <fd2num>
  80265d:	eb 05                	jmp    802664 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80265f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  802664:	83 c4 24             	add    $0x24,%esp
  802667:	5b                   	pop    %ebx
  802668:	5d                   	pop    %ebp
  802669:	c3                   	ret    

0080266a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
  80266d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802670:	ba 00 00 00 00       	mov    $0x0,%edx
  802675:	b8 08 00 00 00       	mov    $0x8,%eax
  80267a:	e8 74 fd ff ff       	call   8023f3 <fsipc>
}
  80267f:	c9                   	leave  
  802680:	c3                   	ret    
  802681:	66 90                	xchg   %ax,%ax
  802683:	66 90                	xchg   %ax,%ax
  802685:	66 90                	xchg   %ax,%ax
  802687:	66 90                	xchg   %ax,%ax
  802689:	66 90                	xchg   %ax,%ax
  80268b:	66 90                	xchg   %ax,%ax
  80268d:	66 90                	xchg   %ax,%ax
  80268f:	90                   	nop

00802690 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802696:	c7 44 24 04 27 3b 80 	movl   $0x803b27,0x4(%esp)
  80269d:	00 
  80269e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a1:	89 04 24             	mov    %eax,(%esp)
  8026a4:	e8 1e ea ff ff       	call   8010c7 <strcpy>
	return 0;
}
  8026a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ae:	c9                   	leave  
  8026af:	c3                   	ret    

008026b0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
  8026b3:	53                   	push   %ebx
  8026b4:	83 ec 14             	sub    $0x14,%esp
  8026b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8026ba:	89 1c 24             	mov    %ebx,(%esp)
  8026bd:	e8 b1 0a 00 00       	call   803173 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8026c2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8026c7:	83 f8 01             	cmp    $0x1,%eax
  8026ca:	75 0d                	jne    8026d9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8026cc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8026cf:	89 04 24             	mov    %eax,(%esp)
  8026d2:	e8 29 03 00 00       	call   802a00 <nsipc_close>
  8026d7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8026d9:	89 d0                	mov    %edx,%eax
  8026db:	83 c4 14             	add    $0x14,%esp
  8026de:	5b                   	pop    %ebx
  8026df:	5d                   	pop    %ebp
  8026e0:	c3                   	ret    

008026e1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
  8026e4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8026e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8026ee:	00 
  8026ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8026f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802700:	8b 40 0c             	mov    0xc(%eax),%eax
  802703:	89 04 24             	mov    %eax,(%esp)
  802706:	e8 f0 03 00 00       	call   802afb <nsipc_send>
}
  80270b:	c9                   	leave  
  80270c:	c3                   	ret    

0080270d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80270d:	55                   	push   %ebp
  80270e:	89 e5                	mov    %esp,%ebp
  802710:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802713:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80271a:	00 
  80271b:	8b 45 10             	mov    0x10(%ebp),%eax
  80271e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802722:	8b 45 0c             	mov    0xc(%ebp),%eax
  802725:	89 44 24 04          	mov    %eax,0x4(%esp)
  802729:	8b 45 08             	mov    0x8(%ebp),%eax
  80272c:	8b 40 0c             	mov    0xc(%eax),%eax
  80272f:	89 04 24             	mov    %eax,(%esp)
  802732:	e8 44 03 00 00       	call   802a7b <nsipc_recv>
}
  802737:	c9                   	leave  
  802738:	c3                   	ret    

00802739 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802739:	55                   	push   %ebp
  80273a:	89 e5                	mov    %esp,%ebp
  80273c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80273f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802742:	89 54 24 04          	mov    %edx,0x4(%esp)
  802746:	89 04 24             	mov    %eax,(%esp)
  802749:	e8 38 f7 ff ff       	call   801e86 <fd_lookup>
  80274e:	85 c0                	test   %eax,%eax
  802750:	78 17                	js     802769 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80275b:	39 08                	cmp    %ecx,(%eax)
  80275d:	75 05                	jne    802764 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80275f:	8b 40 0c             	mov    0xc(%eax),%eax
  802762:	eb 05                	jmp    802769 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802764:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802769:	c9                   	leave  
  80276a:	c3                   	ret    

0080276b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80276b:	55                   	push   %ebp
  80276c:	89 e5                	mov    %esp,%ebp
  80276e:	56                   	push   %esi
  80276f:	53                   	push   %ebx
  802770:	83 ec 20             	sub    $0x20,%esp
  802773:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802775:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802778:	89 04 24             	mov    %eax,(%esp)
  80277b:	e8 b7 f6 ff ff       	call   801e37 <fd_alloc>
  802780:	89 c3                	mov    %eax,%ebx
  802782:	85 c0                	test   %eax,%eax
  802784:	78 21                	js     8027a7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802786:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80278d:	00 
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	89 44 24 04          	mov    %eax,0x4(%esp)
  802795:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80279c:	e8 42 ed ff ff       	call   8014e3 <sys_page_alloc>
  8027a1:	89 c3                	mov    %eax,%ebx
  8027a3:	85 c0                	test   %eax,%eax
  8027a5:	79 0c                	jns    8027b3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8027a7:	89 34 24             	mov    %esi,(%esp)
  8027aa:	e8 51 02 00 00       	call   802a00 <nsipc_close>
		return r;
  8027af:	89 d8                	mov    %ebx,%eax
  8027b1:	eb 20                	jmp    8027d3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8027b3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8027be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8027c8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8027cb:	89 14 24             	mov    %edx,(%esp)
  8027ce:	e8 3d f6 ff ff       	call   801e10 <fd2num>
}
  8027d3:	83 c4 20             	add    $0x20,%esp
  8027d6:	5b                   	pop    %ebx
  8027d7:	5e                   	pop    %esi
  8027d8:	5d                   	pop    %ebp
  8027d9:	c3                   	ret    

008027da <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
  8027dd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8027e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e3:	e8 51 ff ff ff       	call   802739 <fd2sockid>
		return r;
  8027e8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8027ea:	85 c0                	test   %eax,%eax
  8027ec:	78 23                	js     802811 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8027ee:	8b 55 10             	mov    0x10(%ebp),%edx
  8027f1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027fc:	89 04 24             	mov    %eax,(%esp)
  8027ff:	e8 45 01 00 00       	call   802949 <nsipc_accept>
		return r;
  802804:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802806:	85 c0                	test   %eax,%eax
  802808:	78 07                	js     802811 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80280a:	e8 5c ff ff ff       	call   80276b <alloc_sockfd>
  80280f:	89 c1                	mov    %eax,%ecx
}
  802811:	89 c8                	mov    %ecx,%eax
  802813:	c9                   	leave  
  802814:	c3                   	ret    

00802815 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802815:	55                   	push   %ebp
  802816:	89 e5                	mov    %esp,%ebp
  802818:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80281b:	8b 45 08             	mov    0x8(%ebp),%eax
  80281e:	e8 16 ff ff ff       	call   802739 <fd2sockid>
  802823:	89 c2                	mov    %eax,%edx
  802825:	85 d2                	test   %edx,%edx
  802827:	78 16                	js     80283f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802829:	8b 45 10             	mov    0x10(%ebp),%eax
  80282c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802830:	8b 45 0c             	mov    0xc(%ebp),%eax
  802833:	89 44 24 04          	mov    %eax,0x4(%esp)
  802837:	89 14 24             	mov    %edx,(%esp)
  80283a:	e8 60 01 00 00       	call   80299f <nsipc_bind>
}
  80283f:	c9                   	leave  
  802840:	c3                   	ret    

00802841 <shutdown>:

int
shutdown(int s, int how)
{
  802841:	55                   	push   %ebp
  802842:	89 e5                	mov    %esp,%ebp
  802844:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802847:	8b 45 08             	mov    0x8(%ebp),%eax
  80284a:	e8 ea fe ff ff       	call   802739 <fd2sockid>
  80284f:	89 c2                	mov    %eax,%edx
  802851:	85 d2                	test   %edx,%edx
  802853:	78 0f                	js     802864 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802855:	8b 45 0c             	mov    0xc(%ebp),%eax
  802858:	89 44 24 04          	mov    %eax,0x4(%esp)
  80285c:	89 14 24             	mov    %edx,(%esp)
  80285f:	e8 7a 01 00 00       	call   8029de <nsipc_shutdown>
}
  802864:	c9                   	leave  
  802865:	c3                   	ret    

00802866 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
  802869:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80286c:	8b 45 08             	mov    0x8(%ebp),%eax
  80286f:	e8 c5 fe ff ff       	call   802739 <fd2sockid>
  802874:	89 c2                	mov    %eax,%edx
  802876:	85 d2                	test   %edx,%edx
  802878:	78 16                	js     802890 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80287a:	8b 45 10             	mov    0x10(%ebp),%eax
  80287d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802881:	8b 45 0c             	mov    0xc(%ebp),%eax
  802884:	89 44 24 04          	mov    %eax,0x4(%esp)
  802888:	89 14 24             	mov    %edx,(%esp)
  80288b:	e8 8a 01 00 00       	call   802a1a <nsipc_connect>
}
  802890:	c9                   	leave  
  802891:	c3                   	ret    

00802892 <listen>:

int
listen(int s, int backlog)
{
  802892:	55                   	push   %ebp
  802893:	89 e5                	mov    %esp,%ebp
  802895:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	e8 99 fe ff ff       	call   802739 <fd2sockid>
  8028a0:	89 c2                	mov    %eax,%edx
  8028a2:	85 d2                	test   %edx,%edx
  8028a4:	78 0f                	js     8028b5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8028a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ad:	89 14 24             	mov    %edx,(%esp)
  8028b0:	e8 a4 01 00 00       	call   802a59 <nsipc_listen>
}
  8028b5:	c9                   	leave  
  8028b6:	c3                   	ret    

008028b7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8028b7:	55                   	push   %ebp
  8028b8:	89 e5                	mov    %esp,%ebp
  8028ba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8028bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ce:	89 04 24             	mov    %eax,(%esp)
  8028d1:	e8 98 02 00 00       	call   802b6e <nsipc_socket>
  8028d6:	89 c2                	mov    %eax,%edx
  8028d8:	85 d2                	test   %edx,%edx
  8028da:	78 05                	js     8028e1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8028dc:	e8 8a fe ff ff       	call   80276b <alloc_sockfd>
}
  8028e1:	c9                   	leave  
  8028e2:	c3                   	ret    

008028e3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	53                   	push   %ebx
  8028e7:	83 ec 14             	sub    $0x14,%esp
  8028ea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8028ec:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  8028f3:	75 11                	jne    802906 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8028f5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8028fc:	e8 ce f4 ff ff       	call   801dcf <ipc_find_env>
  802901:	a3 1c 50 80 00       	mov    %eax,0x80501c
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802906:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80290d:	00 
  80290e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802915:	00 
  802916:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80291a:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80291f:	89 04 24             	mov    %eax,(%esp)
  802922:	e8 3d f4 ff ff       	call   801d64 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802927:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80292e:	00 
  80292f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802936:	00 
  802937:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80293e:	e8 cd f3 ff ff       	call   801d10 <ipc_recv>
}
  802943:	83 c4 14             	add    $0x14,%esp
  802946:	5b                   	pop    %ebx
  802947:	5d                   	pop    %ebp
  802948:	c3                   	ret    

00802949 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802949:	55                   	push   %ebp
  80294a:	89 e5                	mov    %esp,%ebp
  80294c:	56                   	push   %esi
  80294d:	53                   	push   %ebx
  80294e:	83 ec 10             	sub    $0x10,%esp
  802951:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80295c:	8b 06                	mov    (%esi),%eax
  80295e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802963:	b8 01 00 00 00       	mov    $0x1,%eax
  802968:	e8 76 ff ff ff       	call   8028e3 <nsipc>
  80296d:	89 c3                	mov    %eax,%ebx
  80296f:	85 c0                	test   %eax,%eax
  802971:	78 23                	js     802996 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802973:	a1 10 70 80 00       	mov    0x807010,%eax
  802978:	89 44 24 08          	mov    %eax,0x8(%esp)
  80297c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802983:	00 
  802984:	8b 45 0c             	mov    0xc(%ebp),%eax
  802987:	89 04 24             	mov    %eax,(%esp)
  80298a:	e8 d5 e8 ff ff       	call   801264 <memmove>
		*addrlen = ret->ret_addrlen;
  80298f:	a1 10 70 80 00       	mov    0x807010,%eax
  802994:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802996:	89 d8                	mov    %ebx,%eax
  802998:	83 c4 10             	add    $0x10,%esp
  80299b:	5b                   	pop    %ebx
  80299c:	5e                   	pop    %esi
  80299d:	5d                   	pop    %ebp
  80299e:	c3                   	ret    

0080299f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80299f:	55                   	push   %ebp
  8029a0:	89 e5                	mov    %esp,%ebp
  8029a2:	53                   	push   %ebx
  8029a3:	83 ec 14             	sub    $0x14,%esp
  8029a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8029b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029bc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8029c3:	e8 9c e8 ff ff       	call   801264 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8029c8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8029ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8029d3:	e8 0b ff ff ff       	call   8028e3 <nsipc>
}
  8029d8:	83 c4 14             	add    $0x14,%esp
  8029db:	5b                   	pop    %ebx
  8029dc:	5d                   	pop    %ebp
  8029dd:	c3                   	ret    

008029de <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8029de:	55                   	push   %ebp
  8029df:	89 e5                	mov    %esp,%ebp
  8029e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8029ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029ef:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8029f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8029f9:	e8 e5 fe ff ff       	call   8028e3 <nsipc>
}
  8029fe:	c9                   	leave  
  8029ff:	c3                   	ret    

00802a00 <nsipc_close>:

int
nsipc_close(int s)
{
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
  802a03:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802a0e:	b8 04 00 00 00       	mov    $0x4,%eax
  802a13:	e8 cb fe ff ff       	call   8028e3 <nsipc>
}
  802a18:	c9                   	leave  
  802a19:	c3                   	ret    

00802a1a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802a1a:	55                   	push   %ebp
  802a1b:	89 e5                	mov    %esp,%ebp
  802a1d:	53                   	push   %ebx
  802a1e:	83 ec 14             	sub    $0x14,%esp
  802a21:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802a2c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a37:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802a3e:	e8 21 e8 ff ff       	call   801264 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802a43:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802a49:	b8 05 00 00 00       	mov    $0x5,%eax
  802a4e:	e8 90 fe ff ff       	call   8028e3 <nsipc>
}
  802a53:	83 c4 14             	add    $0x14,%esp
  802a56:	5b                   	pop    %ebx
  802a57:	5d                   	pop    %ebp
  802a58:	c3                   	ret    

00802a59 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802a59:	55                   	push   %ebp
  802a5a:	89 e5                	mov    %esp,%ebp
  802a5c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a62:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a6a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802a6f:	b8 06 00 00 00       	mov    $0x6,%eax
  802a74:	e8 6a fe ff ff       	call   8028e3 <nsipc>
}
  802a79:	c9                   	leave  
  802a7a:	c3                   	ret    

00802a7b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802a7b:	55                   	push   %ebp
  802a7c:	89 e5                	mov    %esp,%ebp
  802a7e:	56                   	push   %esi
  802a7f:	53                   	push   %ebx
  802a80:	83 ec 10             	sub    $0x10,%esp
  802a83:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802a86:	8b 45 08             	mov    0x8(%ebp),%eax
  802a89:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802a8e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802a94:	8b 45 14             	mov    0x14(%ebp),%eax
  802a97:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802a9c:	b8 07 00 00 00       	mov    $0x7,%eax
  802aa1:	e8 3d fe ff ff       	call   8028e3 <nsipc>
  802aa6:	89 c3                	mov    %eax,%ebx
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	78 46                	js     802af2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802aac:	39 f0                	cmp    %esi,%eax
  802aae:	7f 07                	jg     802ab7 <nsipc_recv+0x3c>
  802ab0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802ab5:	7e 24                	jle    802adb <nsipc_recv+0x60>
  802ab7:	c7 44 24 0c 33 3b 80 	movl   $0x803b33,0xc(%esp)
  802abe:	00 
  802abf:	c7 44 24 08 fb 3a 80 	movl   $0x803afb,0x8(%esp)
  802ac6:	00 
  802ac7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  802ace:	00 
  802acf:	c7 04 24 48 3b 80 00 	movl   $0x803b48,(%esp)
  802ad6:	e8 c7 de ff ff       	call   8009a2 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802adb:	89 44 24 08          	mov    %eax,0x8(%esp)
  802adf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802ae6:	00 
  802ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aea:	89 04 24             	mov    %eax,(%esp)
  802aed:	e8 72 e7 ff ff       	call   801264 <memmove>
	}

	return r;
}
  802af2:	89 d8                	mov    %ebx,%eax
  802af4:	83 c4 10             	add    $0x10,%esp
  802af7:	5b                   	pop    %ebx
  802af8:	5e                   	pop    %esi
  802af9:	5d                   	pop    %ebp
  802afa:	c3                   	ret    

00802afb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802afb:	55                   	push   %ebp
  802afc:	89 e5                	mov    %esp,%ebp
  802afe:	53                   	push   %ebx
  802aff:	83 ec 14             	sub    $0x14,%esp
  802b02:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802b0d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802b13:	7e 24                	jle    802b39 <nsipc_send+0x3e>
  802b15:	c7 44 24 0c 54 3b 80 	movl   $0x803b54,0xc(%esp)
  802b1c:	00 
  802b1d:	c7 44 24 08 fb 3a 80 	movl   $0x803afb,0x8(%esp)
  802b24:	00 
  802b25:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  802b2c:	00 
  802b2d:	c7 04 24 48 3b 80 00 	movl   $0x803b48,(%esp)
  802b34:	e8 69 de ff ff       	call   8009a2 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802b39:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b44:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  802b4b:	e8 14 e7 ff ff       	call   801264 <memmove>
	nsipcbuf.send.req_size = size;
  802b50:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802b56:	8b 45 14             	mov    0x14(%ebp),%eax
  802b59:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802b5e:	b8 08 00 00 00       	mov    $0x8,%eax
  802b63:	e8 7b fd ff ff       	call   8028e3 <nsipc>
}
  802b68:	83 c4 14             	add    $0x14,%esp
  802b6b:	5b                   	pop    %ebx
  802b6c:	5d                   	pop    %ebp
  802b6d:	c3                   	ret    

00802b6e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802b6e:	55                   	push   %ebp
  802b6f:	89 e5                	mov    %esp,%ebp
  802b71:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b7f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802b84:	8b 45 10             	mov    0x10(%ebp),%eax
  802b87:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802b8c:	b8 09 00 00 00       	mov    $0x9,%eax
  802b91:	e8 4d fd ff ff       	call   8028e3 <nsipc>
}
  802b96:	c9                   	leave  
  802b97:	c3                   	ret    

00802b98 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802b98:	55                   	push   %ebp
  802b99:	89 e5                	mov    %esp,%ebp
  802b9b:	56                   	push   %esi
  802b9c:	53                   	push   %ebx
  802b9d:	83 ec 10             	sub    $0x10,%esp
  802ba0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	89 04 24             	mov    %eax,(%esp)
  802ba9:	e8 72 f2 ff ff       	call   801e20 <fd2data>
  802bae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802bb0:	c7 44 24 04 60 3b 80 	movl   $0x803b60,0x4(%esp)
  802bb7:	00 
  802bb8:	89 1c 24             	mov    %ebx,(%esp)
  802bbb:	e8 07 e5 ff ff       	call   8010c7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802bc0:	8b 46 04             	mov    0x4(%esi),%eax
  802bc3:	2b 06                	sub    (%esi),%eax
  802bc5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802bcb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802bd2:	00 00 00 
	stat->st_dev = &devpipe;
  802bd5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802bdc:	40 80 00 
	return 0;
}
  802bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  802be4:	83 c4 10             	add    $0x10,%esp
  802be7:	5b                   	pop    %ebx
  802be8:	5e                   	pop    %esi
  802be9:	5d                   	pop    %ebp
  802bea:	c3                   	ret    

00802beb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802beb:	55                   	push   %ebp
  802bec:	89 e5                	mov    %esp,%ebp
  802bee:	53                   	push   %ebx
  802bef:	83 ec 14             	sub    $0x14,%esp
  802bf2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802bf5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802bf9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c00:	e8 85 e9 ff ff       	call   80158a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802c05:	89 1c 24             	mov    %ebx,(%esp)
  802c08:	e8 13 f2 ff ff       	call   801e20 <fd2data>
  802c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c18:	e8 6d e9 ff ff       	call   80158a <sys_page_unmap>
}
  802c1d:	83 c4 14             	add    $0x14,%esp
  802c20:	5b                   	pop    %ebx
  802c21:	5d                   	pop    %ebp
  802c22:	c3                   	ret    

00802c23 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802c23:	55                   	push   %ebp
  802c24:	89 e5                	mov    %esp,%ebp
  802c26:	57                   	push   %edi
  802c27:	56                   	push   %esi
  802c28:	53                   	push   %ebx
  802c29:	83 ec 2c             	sub    $0x2c,%esp
  802c2c:	89 c6                	mov    %eax,%esi
  802c2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802c31:	a1 20 50 80 00       	mov    0x805020,%eax
  802c36:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802c39:	89 34 24             	mov    %esi,(%esp)
  802c3c:	e8 32 05 00 00       	call   803173 <pageref>
  802c41:	89 c7                	mov    %eax,%edi
  802c43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c46:	89 04 24             	mov    %eax,(%esp)
  802c49:	e8 25 05 00 00       	call   803173 <pageref>
  802c4e:	39 c7                	cmp    %eax,%edi
  802c50:	0f 94 c2             	sete   %dl
  802c53:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802c56:	8b 0d 20 50 80 00    	mov    0x805020,%ecx
  802c5c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802c5f:	39 fb                	cmp    %edi,%ebx
  802c61:	74 21                	je     802c84 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802c63:	84 d2                	test   %dl,%dl
  802c65:	74 ca                	je     802c31 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802c67:	8b 51 58             	mov    0x58(%ecx),%edx
  802c6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c6e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c72:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802c76:	c7 04 24 67 3b 80 00 	movl   $0x803b67,(%esp)
  802c7d:	e8 19 de ff ff       	call   800a9b <cprintf>
  802c82:	eb ad                	jmp    802c31 <_pipeisclosed+0xe>
	}
}
  802c84:	83 c4 2c             	add    $0x2c,%esp
  802c87:	5b                   	pop    %ebx
  802c88:	5e                   	pop    %esi
  802c89:	5f                   	pop    %edi
  802c8a:	5d                   	pop    %ebp
  802c8b:	c3                   	ret    

00802c8c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802c8c:	55                   	push   %ebp
  802c8d:	89 e5                	mov    %esp,%ebp
  802c8f:	57                   	push   %edi
  802c90:	56                   	push   %esi
  802c91:	53                   	push   %ebx
  802c92:	83 ec 1c             	sub    $0x1c,%esp
  802c95:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802c98:	89 34 24             	mov    %esi,(%esp)
  802c9b:	e8 80 f1 ff ff       	call   801e20 <fd2data>
  802ca0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ca2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ca7:	eb 45                	jmp    802cee <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802ca9:	89 da                	mov    %ebx,%edx
  802cab:	89 f0                	mov    %esi,%eax
  802cad:	e8 71 ff ff ff       	call   802c23 <_pipeisclosed>
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	75 41                	jne    802cf7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802cb6:	e8 09 e8 ff ff       	call   8014c4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802cbb:	8b 43 04             	mov    0x4(%ebx),%eax
  802cbe:	8b 0b                	mov    (%ebx),%ecx
  802cc0:	8d 51 20             	lea    0x20(%ecx),%edx
  802cc3:	39 d0                	cmp    %edx,%eax
  802cc5:	73 e2                	jae    802ca9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802cc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802cca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802cce:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802cd1:	99                   	cltd   
  802cd2:	c1 ea 1b             	shr    $0x1b,%edx
  802cd5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802cd8:	83 e1 1f             	and    $0x1f,%ecx
  802cdb:	29 d1                	sub    %edx,%ecx
  802cdd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802ce1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802ce5:	83 c0 01             	add    $0x1,%eax
  802ce8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ceb:	83 c7 01             	add    $0x1,%edi
  802cee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802cf1:	75 c8                	jne    802cbb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802cf3:	89 f8                	mov    %edi,%eax
  802cf5:	eb 05                	jmp    802cfc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802cf7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802cfc:	83 c4 1c             	add    $0x1c,%esp
  802cff:	5b                   	pop    %ebx
  802d00:	5e                   	pop    %esi
  802d01:	5f                   	pop    %edi
  802d02:	5d                   	pop    %ebp
  802d03:	c3                   	ret    

00802d04 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802d04:	55                   	push   %ebp
  802d05:	89 e5                	mov    %esp,%ebp
  802d07:	57                   	push   %edi
  802d08:	56                   	push   %esi
  802d09:	53                   	push   %ebx
  802d0a:	83 ec 1c             	sub    $0x1c,%esp
  802d0d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802d10:	89 3c 24             	mov    %edi,(%esp)
  802d13:	e8 08 f1 ff ff       	call   801e20 <fd2data>
  802d18:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802d1a:	be 00 00 00 00       	mov    $0x0,%esi
  802d1f:	eb 3d                	jmp    802d5e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802d21:	85 f6                	test   %esi,%esi
  802d23:	74 04                	je     802d29 <devpipe_read+0x25>
				return i;
  802d25:	89 f0                	mov    %esi,%eax
  802d27:	eb 43                	jmp    802d6c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802d29:	89 da                	mov    %ebx,%edx
  802d2b:	89 f8                	mov    %edi,%eax
  802d2d:	e8 f1 fe ff ff       	call   802c23 <_pipeisclosed>
  802d32:	85 c0                	test   %eax,%eax
  802d34:	75 31                	jne    802d67 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802d36:	e8 89 e7 ff ff       	call   8014c4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802d3b:	8b 03                	mov    (%ebx),%eax
  802d3d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802d40:	74 df                	je     802d21 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802d42:	99                   	cltd   
  802d43:	c1 ea 1b             	shr    $0x1b,%edx
  802d46:	01 d0                	add    %edx,%eax
  802d48:	83 e0 1f             	and    $0x1f,%eax
  802d4b:	29 d0                	sub    %edx,%eax
  802d4d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802d52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d55:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802d58:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802d5b:	83 c6 01             	add    $0x1,%esi
  802d5e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d61:	75 d8                	jne    802d3b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802d63:	89 f0                	mov    %esi,%eax
  802d65:	eb 05                	jmp    802d6c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802d67:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802d6c:	83 c4 1c             	add    $0x1c,%esp
  802d6f:	5b                   	pop    %ebx
  802d70:	5e                   	pop    %esi
  802d71:	5f                   	pop    %edi
  802d72:	5d                   	pop    %ebp
  802d73:	c3                   	ret    

00802d74 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802d74:	55                   	push   %ebp
  802d75:	89 e5                	mov    %esp,%ebp
  802d77:	56                   	push   %esi
  802d78:	53                   	push   %ebx
  802d79:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802d7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d7f:	89 04 24             	mov    %eax,(%esp)
  802d82:	e8 b0 f0 ff ff       	call   801e37 <fd_alloc>
  802d87:	89 c2                	mov    %eax,%edx
  802d89:	85 d2                	test   %edx,%edx
  802d8b:	0f 88 4d 01 00 00    	js     802ede <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d91:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802d98:	00 
  802d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802da0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802da7:	e8 37 e7 ff ff       	call   8014e3 <sys_page_alloc>
  802dac:	89 c2                	mov    %eax,%edx
  802dae:	85 d2                	test   %edx,%edx
  802db0:	0f 88 28 01 00 00    	js     802ede <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802db6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802db9:	89 04 24             	mov    %eax,(%esp)
  802dbc:	e8 76 f0 ff ff       	call   801e37 <fd_alloc>
  802dc1:	89 c3                	mov    %eax,%ebx
  802dc3:	85 c0                	test   %eax,%eax
  802dc5:	0f 88 fe 00 00 00    	js     802ec9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802dcb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802dd2:	00 
  802dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802de1:	e8 fd e6 ff ff       	call   8014e3 <sys_page_alloc>
  802de6:	89 c3                	mov    %eax,%ebx
  802de8:	85 c0                	test   %eax,%eax
  802dea:	0f 88 d9 00 00 00    	js     802ec9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	89 04 24             	mov    %eax,(%esp)
  802df6:	e8 25 f0 ff ff       	call   801e20 <fd2data>
  802dfb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802dfd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802e04:	00 
  802e05:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e10:	e8 ce e6 ff ff       	call   8014e3 <sys_page_alloc>
  802e15:	89 c3                	mov    %eax,%ebx
  802e17:	85 c0                	test   %eax,%eax
  802e19:	0f 88 97 00 00 00    	js     802eb6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e22:	89 04 24             	mov    %eax,(%esp)
  802e25:	e8 f6 ef ff ff       	call   801e20 <fd2data>
  802e2a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802e31:	00 
  802e32:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e36:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802e3d:	00 
  802e3e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e49:	e8 e9 e6 ff ff       	call   801537 <sys_page_map>
  802e4e:	89 c3                	mov    %eax,%ebx
  802e50:	85 c0                	test   %eax,%eax
  802e52:	78 52                	js     802ea6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802e54:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802e69:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e72:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e77:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	89 04 24             	mov    %eax,(%esp)
  802e84:	e8 87 ef ff ff       	call   801e10 <fd2num>
  802e89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e8c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e91:	89 04 24             	mov    %eax,(%esp)
  802e94:	e8 77 ef ff ff       	call   801e10 <fd2num>
  802e99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e9c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea4:	eb 38                	jmp    802ede <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802ea6:	89 74 24 04          	mov    %esi,0x4(%esp)
  802eaa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802eb1:	e8 d4 e6 ff ff       	call   80158a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ebd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ec4:	e8 c1 e6 ff ff       	call   80158a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ed0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ed7:	e8 ae e6 ff ff       	call   80158a <sys_page_unmap>
  802edc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802ede:	83 c4 30             	add    $0x30,%esp
  802ee1:	5b                   	pop    %ebx
  802ee2:	5e                   	pop    %esi
  802ee3:	5d                   	pop    %ebp
  802ee4:	c3                   	ret    

00802ee5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802ee5:	55                   	push   %ebp
  802ee6:	89 e5                	mov    %esp,%ebp
  802ee8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802eeb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802eee:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	89 04 24             	mov    %eax,(%esp)
  802ef8:	e8 89 ef ff ff       	call   801e86 <fd_lookup>
  802efd:	89 c2                	mov    %eax,%edx
  802eff:	85 d2                	test   %edx,%edx
  802f01:	78 15                	js     802f18 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	89 04 24             	mov    %eax,(%esp)
  802f09:	e8 12 ef ff ff       	call   801e20 <fd2data>
	return _pipeisclosed(fd, p);
  802f0e:	89 c2                	mov    %eax,%edx
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	e8 0b fd ff ff       	call   802c23 <_pipeisclosed>
}
  802f18:	c9                   	leave  
  802f19:	c3                   	ret    
  802f1a:	66 90                	xchg   %ax,%ax
  802f1c:	66 90                	xchg   %ax,%ax
  802f1e:	66 90                	xchg   %ax,%ax

00802f20 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802f20:	55                   	push   %ebp
  802f21:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802f23:	b8 00 00 00 00       	mov    $0x0,%eax
  802f28:	5d                   	pop    %ebp
  802f29:	c3                   	ret    

00802f2a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802f2a:	55                   	push   %ebp
  802f2b:	89 e5                	mov    %esp,%ebp
  802f2d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802f30:	c7 44 24 04 7f 3b 80 	movl   $0x803b7f,0x4(%esp)
  802f37:	00 
  802f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3b:	89 04 24             	mov    %eax,(%esp)
  802f3e:	e8 84 e1 ff ff       	call   8010c7 <strcpy>
	return 0;
}
  802f43:	b8 00 00 00 00       	mov    $0x0,%eax
  802f48:	c9                   	leave  
  802f49:	c3                   	ret    

00802f4a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802f4a:	55                   	push   %ebp
  802f4b:	89 e5                	mov    %esp,%ebp
  802f4d:	57                   	push   %edi
  802f4e:	56                   	push   %esi
  802f4f:	53                   	push   %ebx
  802f50:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802f56:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802f5b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802f61:	eb 31                	jmp    802f94 <devcons_write+0x4a>
		m = n - tot;
  802f63:	8b 75 10             	mov    0x10(%ebp),%esi
  802f66:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802f68:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802f6b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802f70:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802f73:	89 74 24 08          	mov    %esi,0x8(%esp)
  802f77:	03 45 0c             	add    0xc(%ebp),%eax
  802f7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f7e:	89 3c 24             	mov    %edi,(%esp)
  802f81:	e8 de e2 ff ff       	call   801264 <memmove>
		sys_cputs(buf, m);
  802f86:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f8a:	89 3c 24             	mov    %edi,(%esp)
  802f8d:	e8 84 e4 ff ff       	call   801416 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802f92:	01 f3                	add    %esi,%ebx
  802f94:	89 d8                	mov    %ebx,%eax
  802f96:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802f99:	72 c8                	jb     802f63 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802f9b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802fa1:	5b                   	pop    %ebx
  802fa2:	5e                   	pop    %esi
  802fa3:	5f                   	pop    %edi
  802fa4:	5d                   	pop    %ebp
  802fa5:	c3                   	ret    

00802fa6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802fa6:	55                   	push   %ebp
  802fa7:	89 e5                	mov    %esp,%ebp
  802fa9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802fac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802fb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802fb5:	75 07                	jne    802fbe <devcons_read+0x18>
  802fb7:	eb 2a                	jmp    802fe3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802fb9:	e8 06 e5 ff ff       	call   8014c4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802fbe:	66 90                	xchg   %ax,%ax
  802fc0:	e8 6f e4 ff ff       	call   801434 <sys_cgetc>
  802fc5:	85 c0                	test   %eax,%eax
  802fc7:	74 f0                	je     802fb9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802fc9:	85 c0                	test   %eax,%eax
  802fcb:	78 16                	js     802fe3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802fcd:	83 f8 04             	cmp    $0x4,%eax
  802fd0:	74 0c                	je     802fde <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd5:	88 02                	mov    %al,(%edx)
	return 1;
  802fd7:	b8 01 00 00 00       	mov    $0x1,%eax
  802fdc:	eb 05                	jmp    802fe3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802fde:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802fe3:	c9                   	leave  
  802fe4:	c3                   	ret    

00802fe5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802fe5:	55                   	push   %ebp
  802fe6:	89 e5                	mov    %esp,%ebp
  802fe8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802ff1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802ff8:	00 
  802ff9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802ffc:	89 04 24             	mov    %eax,(%esp)
  802fff:	e8 12 e4 ff ff       	call   801416 <sys_cputs>
}
  803004:	c9                   	leave  
  803005:	c3                   	ret    

00803006 <getchar>:

int
getchar(void)
{
  803006:	55                   	push   %ebp
  803007:	89 e5                	mov    %esp,%ebp
  803009:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80300c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803013:	00 
  803014:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803017:	89 44 24 04          	mov    %eax,0x4(%esp)
  80301b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803022:	e8 f3 f0 ff ff       	call   80211a <read>
	if (r < 0)
  803027:	85 c0                	test   %eax,%eax
  803029:	78 0f                	js     80303a <getchar+0x34>
		return r;
	if (r < 1)
  80302b:	85 c0                	test   %eax,%eax
  80302d:	7e 06                	jle    803035 <getchar+0x2f>
		return -E_EOF;
	return c;
  80302f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803033:	eb 05                	jmp    80303a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803035:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80303a:	c9                   	leave  
  80303b:	c3                   	ret    

0080303c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80303c:	55                   	push   %ebp
  80303d:	89 e5                	mov    %esp,%ebp
  80303f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803042:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803045:	89 44 24 04          	mov    %eax,0x4(%esp)
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	89 04 24             	mov    %eax,(%esp)
  80304f:	e8 32 ee ff ff       	call   801e86 <fd_lookup>
  803054:	85 c0                	test   %eax,%eax
  803056:	78 11                	js     803069 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  803061:	39 10                	cmp    %edx,(%eax)
  803063:	0f 94 c0             	sete   %al
  803066:	0f b6 c0             	movzbl %al,%eax
}
  803069:	c9                   	leave  
  80306a:	c3                   	ret    

0080306b <opencons>:

int
opencons(void)
{
  80306b:	55                   	push   %ebp
  80306c:	89 e5                	mov    %esp,%ebp
  80306e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803071:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803074:	89 04 24             	mov    %eax,(%esp)
  803077:	e8 bb ed ff ff       	call   801e37 <fd_alloc>
		return r;
  80307c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80307e:	85 c0                	test   %eax,%eax
  803080:	78 40                	js     8030c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803082:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803089:	00 
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803091:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803098:	e8 46 e4 ff ff       	call   8014e3 <sys_page_alloc>
		return r;
  80309d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80309f:	85 c0                	test   %eax,%eax
  8030a1:	78 1f                	js     8030c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8030a3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8030ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8030b8:	89 04 24             	mov    %eax,(%esp)
  8030bb:	e8 50 ed ff ff       	call   801e10 <fd2num>
  8030c0:	89 c2                	mov    %eax,%edx
}
  8030c2:	89 d0                	mov    %edx,%eax
  8030c4:	c9                   	leave  
  8030c5:	c3                   	ret    

008030c6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8030c6:	55                   	push   %ebp
  8030c7:	89 e5                	mov    %esp,%ebp
  8030c9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8030cc:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8030d3:	75 70                	jne    803145 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  8030d5:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  8030dc:	00 
  8030dd:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8030e4:	ee 
  8030e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030ec:	e8 f2 e3 ff ff       	call   8014e3 <sys_page_alloc>
		if (error < 0)
  8030f1:	85 c0                	test   %eax,%eax
  8030f3:	79 1c                	jns    803111 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  8030f5:	c7 44 24 08 8c 3b 80 	movl   $0x803b8c,0x8(%esp)
  8030fc:	00 
  8030fd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  803104:	00 
  803105:	c7 04 24 e0 3b 80 00 	movl   $0x803be0,(%esp)
  80310c:	e8 91 d8 ff ff       	call   8009a2 <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803111:	c7 44 24 04 4f 31 80 	movl   $0x80314f,0x4(%esp)
  803118:	00 
  803119:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803120:	e8 5e e5 ff ff       	call   801683 <sys_env_set_pgfault_upcall>
		if (error < 0)
  803125:	85 c0                	test   %eax,%eax
  803127:	79 1c                	jns    803145 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  803129:	c7 44 24 08 b4 3b 80 	movl   $0x803bb4,0x8(%esp)
  803130:	00 
  803131:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  803138:	00 
  803139:	c7 04 24 e0 3b 80 00 	movl   $0x803be0,(%esp)
  803140:	e8 5d d8 ff ff       	call   8009a2 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803145:	8b 45 08             	mov    0x8(%ebp),%eax
  803148:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80314d:	c9                   	leave  
  80314e:	c3                   	ret    

0080314f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80314f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803150:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  803155:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803157:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  80315a:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  80315e:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  803163:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  803167:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  803169:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80316c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80316d:	83 c4 04             	add    $0x4,%esp
	popfl
  803170:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803171:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803172:	c3                   	ret    

00803173 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803173:	55                   	push   %ebp
  803174:	89 e5                	mov    %esp,%ebp
  803176:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803179:	89 d0                	mov    %edx,%eax
  80317b:	c1 e8 16             	shr    $0x16,%eax
  80317e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803185:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80318a:	f6 c1 01             	test   $0x1,%cl
  80318d:	74 1d                	je     8031ac <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80318f:	c1 ea 0c             	shr    $0xc,%edx
  803192:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803199:	f6 c2 01             	test   $0x1,%dl
  80319c:	74 0e                	je     8031ac <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80319e:	c1 ea 0c             	shr    $0xc,%edx
  8031a1:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8031a8:	ef 
  8031a9:	0f b7 c0             	movzwl %ax,%eax
}
  8031ac:	5d                   	pop    %ebp
  8031ad:	c3                   	ret    
  8031ae:	66 90                	xchg   %ax,%ax

008031b0 <__udivdi3>:
  8031b0:	55                   	push   %ebp
  8031b1:	57                   	push   %edi
  8031b2:	56                   	push   %esi
  8031b3:	83 ec 0c             	sub    $0xc,%esp
  8031b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8031ba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8031be:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8031c2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8031c6:	85 c0                	test   %eax,%eax
  8031c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8031cc:	89 ea                	mov    %ebp,%edx
  8031ce:	89 0c 24             	mov    %ecx,(%esp)
  8031d1:	75 2d                	jne    803200 <__udivdi3+0x50>
  8031d3:	39 e9                	cmp    %ebp,%ecx
  8031d5:	77 61                	ja     803238 <__udivdi3+0x88>
  8031d7:	85 c9                	test   %ecx,%ecx
  8031d9:	89 ce                	mov    %ecx,%esi
  8031db:	75 0b                	jne    8031e8 <__udivdi3+0x38>
  8031dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8031e2:	31 d2                	xor    %edx,%edx
  8031e4:	f7 f1                	div    %ecx
  8031e6:	89 c6                	mov    %eax,%esi
  8031e8:	31 d2                	xor    %edx,%edx
  8031ea:	89 e8                	mov    %ebp,%eax
  8031ec:	f7 f6                	div    %esi
  8031ee:	89 c5                	mov    %eax,%ebp
  8031f0:	89 f8                	mov    %edi,%eax
  8031f2:	f7 f6                	div    %esi
  8031f4:	89 ea                	mov    %ebp,%edx
  8031f6:	83 c4 0c             	add    $0xc,%esp
  8031f9:	5e                   	pop    %esi
  8031fa:	5f                   	pop    %edi
  8031fb:	5d                   	pop    %ebp
  8031fc:	c3                   	ret    
  8031fd:	8d 76 00             	lea    0x0(%esi),%esi
  803200:	39 e8                	cmp    %ebp,%eax
  803202:	77 24                	ja     803228 <__udivdi3+0x78>
  803204:	0f bd e8             	bsr    %eax,%ebp
  803207:	83 f5 1f             	xor    $0x1f,%ebp
  80320a:	75 3c                	jne    803248 <__udivdi3+0x98>
  80320c:	8b 74 24 04          	mov    0x4(%esp),%esi
  803210:	39 34 24             	cmp    %esi,(%esp)
  803213:	0f 86 9f 00 00 00    	jbe    8032b8 <__udivdi3+0x108>
  803219:	39 d0                	cmp    %edx,%eax
  80321b:	0f 82 97 00 00 00    	jb     8032b8 <__udivdi3+0x108>
  803221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803228:	31 d2                	xor    %edx,%edx
  80322a:	31 c0                	xor    %eax,%eax
  80322c:	83 c4 0c             	add    $0xc,%esp
  80322f:	5e                   	pop    %esi
  803230:	5f                   	pop    %edi
  803231:	5d                   	pop    %ebp
  803232:	c3                   	ret    
  803233:	90                   	nop
  803234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803238:	89 f8                	mov    %edi,%eax
  80323a:	f7 f1                	div    %ecx
  80323c:	31 d2                	xor    %edx,%edx
  80323e:	83 c4 0c             	add    $0xc,%esp
  803241:	5e                   	pop    %esi
  803242:	5f                   	pop    %edi
  803243:	5d                   	pop    %ebp
  803244:	c3                   	ret    
  803245:	8d 76 00             	lea    0x0(%esi),%esi
  803248:	89 e9                	mov    %ebp,%ecx
  80324a:	8b 3c 24             	mov    (%esp),%edi
  80324d:	d3 e0                	shl    %cl,%eax
  80324f:	89 c6                	mov    %eax,%esi
  803251:	b8 20 00 00 00       	mov    $0x20,%eax
  803256:	29 e8                	sub    %ebp,%eax
  803258:	89 c1                	mov    %eax,%ecx
  80325a:	d3 ef                	shr    %cl,%edi
  80325c:	89 e9                	mov    %ebp,%ecx
  80325e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803262:	8b 3c 24             	mov    (%esp),%edi
  803265:	09 74 24 08          	or     %esi,0x8(%esp)
  803269:	89 d6                	mov    %edx,%esi
  80326b:	d3 e7                	shl    %cl,%edi
  80326d:	89 c1                	mov    %eax,%ecx
  80326f:	89 3c 24             	mov    %edi,(%esp)
  803272:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803276:	d3 ee                	shr    %cl,%esi
  803278:	89 e9                	mov    %ebp,%ecx
  80327a:	d3 e2                	shl    %cl,%edx
  80327c:	89 c1                	mov    %eax,%ecx
  80327e:	d3 ef                	shr    %cl,%edi
  803280:	09 d7                	or     %edx,%edi
  803282:	89 f2                	mov    %esi,%edx
  803284:	89 f8                	mov    %edi,%eax
  803286:	f7 74 24 08          	divl   0x8(%esp)
  80328a:	89 d6                	mov    %edx,%esi
  80328c:	89 c7                	mov    %eax,%edi
  80328e:	f7 24 24             	mull   (%esp)
  803291:	39 d6                	cmp    %edx,%esi
  803293:	89 14 24             	mov    %edx,(%esp)
  803296:	72 30                	jb     8032c8 <__udivdi3+0x118>
  803298:	8b 54 24 04          	mov    0x4(%esp),%edx
  80329c:	89 e9                	mov    %ebp,%ecx
  80329e:	d3 e2                	shl    %cl,%edx
  8032a0:	39 c2                	cmp    %eax,%edx
  8032a2:	73 05                	jae    8032a9 <__udivdi3+0xf9>
  8032a4:	3b 34 24             	cmp    (%esp),%esi
  8032a7:	74 1f                	je     8032c8 <__udivdi3+0x118>
  8032a9:	89 f8                	mov    %edi,%eax
  8032ab:	31 d2                	xor    %edx,%edx
  8032ad:	e9 7a ff ff ff       	jmp    80322c <__udivdi3+0x7c>
  8032b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8032b8:	31 d2                	xor    %edx,%edx
  8032ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8032bf:	e9 68 ff ff ff       	jmp    80322c <__udivdi3+0x7c>
  8032c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8032c8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8032cb:	31 d2                	xor    %edx,%edx
  8032cd:	83 c4 0c             	add    $0xc,%esp
  8032d0:	5e                   	pop    %esi
  8032d1:	5f                   	pop    %edi
  8032d2:	5d                   	pop    %ebp
  8032d3:	c3                   	ret    
  8032d4:	66 90                	xchg   %ax,%ax
  8032d6:	66 90                	xchg   %ax,%ax
  8032d8:	66 90                	xchg   %ax,%ax
  8032da:	66 90                	xchg   %ax,%ax
  8032dc:	66 90                	xchg   %ax,%ax
  8032de:	66 90                	xchg   %ax,%ax

008032e0 <__umoddi3>:
  8032e0:	55                   	push   %ebp
  8032e1:	57                   	push   %edi
  8032e2:	56                   	push   %esi
  8032e3:	83 ec 14             	sub    $0x14,%esp
  8032e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8032ea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8032ee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8032f2:	89 c7                	mov    %eax,%edi
  8032f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032f8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8032fc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803300:	89 34 24             	mov    %esi,(%esp)
  803303:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803307:	85 c0                	test   %eax,%eax
  803309:	89 c2                	mov    %eax,%edx
  80330b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80330f:	75 17                	jne    803328 <__umoddi3+0x48>
  803311:	39 fe                	cmp    %edi,%esi
  803313:	76 4b                	jbe    803360 <__umoddi3+0x80>
  803315:	89 c8                	mov    %ecx,%eax
  803317:	89 fa                	mov    %edi,%edx
  803319:	f7 f6                	div    %esi
  80331b:	89 d0                	mov    %edx,%eax
  80331d:	31 d2                	xor    %edx,%edx
  80331f:	83 c4 14             	add    $0x14,%esp
  803322:	5e                   	pop    %esi
  803323:	5f                   	pop    %edi
  803324:	5d                   	pop    %ebp
  803325:	c3                   	ret    
  803326:	66 90                	xchg   %ax,%ax
  803328:	39 f8                	cmp    %edi,%eax
  80332a:	77 54                	ja     803380 <__umoddi3+0xa0>
  80332c:	0f bd e8             	bsr    %eax,%ebp
  80332f:	83 f5 1f             	xor    $0x1f,%ebp
  803332:	75 5c                	jne    803390 <__umoddi3+0xb0>
  803334:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803338:	39 3c 24             	cmp    %edi,(%esp)
  80333b:	0f 87 e7 00 00 00    	ja     803428 <__umoddi3+0x148>
  803341:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803345:	29 f1                	sub    %esi,%ecx
  803347:	19 c7                	sbb    %eax,%edi
  803349:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80334d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803351:	8b 44 24 08          	mov    0x8(%esp),%eax
  803355:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803359:	83 c4 14             	add    $0x14,%esp
  80335c:	5e                   	pop    %esi
  80335d:	5f                   	pop    %edi
  80335e:	5d                   	pop    %ebp
  80335f:	c3                   	ret    
  803360:	85 f6                	test   %esi,%esi
  803362:	89 f5                	mov    %esi,%ebp
  803364:	75 0b                	jne    803371 <__umoddi3+0x91>
  803366:	b8 01 00 00 00       	mov    $0x1,%eax
  80336b:	31 d2                	xor    %edx,%edx
  80336d:	f7 f6                	div    %esi
  80336f:	89 c5                	mov    %eax,%ebp
  803371:	8b 44 24 04          	mov    0x4(%esp),%eax
  803375:	31 d2                	xor    %edx,%edx
  803377:	f7 f5                	div    %ebp
  803379:	89 c8                	mov    %ecx,%eax
  80337b:	f7 f5                	div    %ebp
  80337d:	eb 9c                	jmp    80331b <__umoddi3+0x3b>
  80337f:	90                   	nop
  803380:	89 c8                	mov    %ecx,%eax
  803382:	89 fa                	mov    %edi,%edx
  803384:	83 c4 14             	add    $0x14,%esp
  803387:	5e                   	pop    %esi
  803388:	5f                   	pop    %edi
  803389:	5d                   	pop    %ebp
  80338a:	c3                   	ret    
  80338b:	90                   	nop
  80338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803390:	8b 04 24             	mov    (%esp),%eax
  803393:	be 20 00 00 00       	mov    $0x20,%esi
  803398:	89 e9                	mov    %ebp,%ecx
  80339a:	29 ee                	sub    %ebp,%esi
  80339c:	d3 e2                	shl    %cl,%edx
  80339e:	89 f1                	mov    %esi,%ecx
  8033a0:	d3 e8                	shr    %cl,%eax
  8033a2:	89 e9                	mov    %ebp,%ecx
  8033a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033a8:	8b 04 24             	mov    (%esp),%eax
  8033ab:	09 54 24 04          	or     %edx,0x4(%esp)
  8033af:	89 fa                	mov    %edi,%edx
  8033b1:	d3 e0                	shl    %cl,%eax
  8033b3:	89 f1                	mov    %esi,%ecx
  8033b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8033b9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8033bd:	d3 ea                	shr    %cl,%edx
  8033bf:	89 e9                	mov    %ebp,%ecx
  8033c1:	d3 e7                	shl    %cl,%edi
  8033c3:	89 f1                	mov    %esi,%ecx
  8033c5:	d3 e8                	shr    %cl,%eax
  8033c7:	89 e9                	mov    %ebp,%ecx
  8033c9:	09 f8                	or     %edi,%eax
  8033cb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8033cf:	f7 74 24 04          	divl   0x4(%esp)
  8033d3:	d3 e7                	shl    %cl,%edi
  8033d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033d9:	89 d7                	mov    %edx,%edi
  8033db:	f7 64 24 08          	mull   0x8(%esp)
  8033df:	39 d7                	cmp    %edx,%edi
  8033e1:	89 c1                	mov    %eax,%ecx
  8033e3:	89 14 24             	mov    %edx,(%esp)
  8033e6:	72 2c                	jb     803414 <__umoddi3+0x134>
  8033e8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8033ec:	72 22                	jb     803410 <__umoddi3+0x130>
  8033ee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8033f2:	29 c8                	sub    %ecx,%eax
  8033f4:	19 d7                	sbb    %edx,%edi
  8033f6:	89 e9                	mov    %ebp,%ecx
  8033f8:	89 fa                	mov    %edi,%edx
  8033fa:	d3 e8                	shr    %cl,%eax
  8033fc:	89 f1                	mov    %esi,%ecx
  8033fe:	d3 e2                	shl    %cl,%edx
  803400:	89 e9                	mov    %ebp,%ecx
  803402:	d3 ef                	shr    %cl,%edi
  803404:	09 d0                	or     %edx,%eax
  803406:	89 fa                	mov    %edi,%edx
  803408:	83 c4 14             	add    $0x14,%esp
  80340b:	5e                   	pop    %esi
  80340c:	5f                   	pop    %edi
  80340d:	5d                   	pop    %ebp
  80340e:	c3                   	ret    
  80340f:	90                   	nop
  803410:	39 d7                	cmp    %edx,%edi
  803412:	75 da                	jne    8033ee <__umoddi3+0x10e>
  803414:	8b 14 24             	mov    (%esp),%edx
  803417:	89 c1                	mov    %eax,%ecx
  803419:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80341d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803421:	eb cb                	jmp    8033ee <__umoddi3+0x10e>
  803423:	90                   	nop
  803424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803428:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80342c:	0f 82 0f ff ff ff    	jb     803341 <__umoddi3+0x61>
  803432:	e9 1a ff ff ff       	jmp    803351 <__umoddi3+0x71>
