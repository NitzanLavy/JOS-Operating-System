
obj/net/testoutput:     file format elf32-i386


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
  80002c:	e8 fb 02 00 00       	call   80032c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t ns_envid = sys_getenvid();
  80003b:	e8 55 0e 00 00       	call   800e95 <sys_getenvid>
  800040:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  800042:	c7 05 00 40 80 00 40 	movl   $0x802e40,0x804000
  800049:	2e 80 00 

	output_envid = fork();
  80004c:	e8 d9 13 00 00       	call   80142a <fork>
  800051:	a3 00 50 80 00       	mov    %eax,0x805000
	if (output_envid < 0)
  800056:	85 c0                	test   %eax,%eax
  800058:	79 1c                	jns    800076 <umain+0x43>
		panic("error forking");
  80005a:	c7 44 24 08 4b 2e 80 	movl   $0x802e4b,0x8(%esp)
  800061:	00 
  800062:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
  800069:	00 
  80006a:	c7 04 24 59 2e 80 00 	movl   $0x802e59,(%esp)
  800071:	e8 1b 03 00 00       	call   800391 <_panic>
	else if (output_envid == 0) {
  800076:	bb 00 00 00 00       	mov    $0x0,%ebx
  80007b:	85 c0                	test   %eax,%eax
  80007d:	75 0d                	jne    80008c <umain+0x59>
		output(ns_envid);
  80007f:	89 34 24             	mov    %esi,(%esp)
  800082:	e8 44 02 00 00       	call   8002cb <output>
		return;
  800087:	e9 c6 00 00 00       	jmp    800152 <umain+0x11f>
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
		if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  80008c:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800093:	00 
  800094:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  80009b:	0f 
  80009c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a3:	e8 2b 0e 00 00       	call   800ed3 <sys_page_alloc>
  8000a8:	85 c0                	test   %eax,%eax
  8000aa:	79 20                	jns    8000cc <umain+0x99>
			panic("sys_page_alloc: %e", r);
  8000ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b0:	c7 44 24 08 6a 2e 80 	movl   $0x802e6a,0x8(%esp)
  8000b7:	00 
  8000b8:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8000bf:	00 
  8000c0:	c7 04 24 59 2e 80 00 	movl   $0x802e59,(%esp)
  8000c7:	e8 c5 02 00 00       	call   800391 <_panic>
		pkt->jp_len = snprintf(pkt->jp_data,
  8000cc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000d0:	c7 44 24 08 7d 2e 80 	movl   $0x802e7d,0x8(%esp)
  8000d7:	00 
  8000d8:	c7 44 24 04 fc 0f 00 	movl   $0xffc,0x4(%esp)
  8000df:	00 
  8000e0:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  8000e7:	e8 5e 09 00 00       	call   800a4a <snprintf>
  8000ec:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  8000f1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000f5:	c7 04 24 89 2e 80 00 	movl   $0x802e89,(%esp)
  8000fc:	e8 89 03 00 00       	call   80048a <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  800101:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800108:	00 
  800109:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  800110:	0f 
  800111:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800118:	00 
  800119:	a1 00 50 80 00       	mov    0x805000,%eax
  80011e:	89 04 24             	mov    %eax,(%esp)
  800121:	e8 2e 16 00 00       	call   801754 <ipc_send>
		sys_page_unmap(0, pkt);
  800126:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  80012d:	0f 
  80012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800135:	e8 40 0e 00 00       	call   800f7a <sys_page_unmap>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  80013a:	83 c3 01             	add    $0x1,%ebx
  80013d:	83 fb 0a             	cmp    $0xa,%ebx
  800140:	0f 85 46 ff ff ff    	jne    80008c <umain+0x59>
  800146:	b3 14                	mov    $0x14,%bl
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
		sys_yield();
  800148:	e8 67 0d 00 00       	call   800eb4 <sys_yield>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  80014d:	83 eb 01             	sub    $0x1,%ebx
  800150:	75 f6                	jne    800148 <umain+0x115>
		sys_yield();
}
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5d                   	pop    %ebp
  800158:	c3                   	ret    
  800159:	66 90                	xchg   %ax,%ax
  80015b:	66 90                	xchg   %ax,%ax
  80015d:	66 90                	xchg   %ax,%ax
  80015f:	90                   	nop

00800160 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	57                   	push   %edi
  800164:	56                   	push   %esi
  800165:	53                   	push   %ebx
  800166:	83 ec 2c             	sub    $0x2c,%esp
  800169:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  80016c:	e8 ca 0f 00 00       	call   80113b <sys_time_msec>
  800171:	03 45 0c             	add    0xc(%ebp),%eax
  800174:	89 c6                	mov    %eax,%esi

	binaryname = "ns_timer";
  800176:	c7 05 00 40 80 00 a1 	movl   $0x802ea1,0x804000
  80017d:	2e 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800180:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800183:	eb 05                	jmp    80018a <timer+0x2a>

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
			sys_yield();
  800185:	e8 2a 0d 00 00       	call   800eb4 <sys_yield>
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  80018a:	e8 ac 0f 00 00       	call   80113b <sys_time_msec>
  80018f:	39 c6                	cmp    %eax,%esi
  800191:	76 06                	jbe    800199 <timer+0x39>
  800193:	85 c0                	test   %eax,%eax
  800195:	79 ee                	jns    800185 <timer+0x25>
  800197:	eb 09                	jmp    8001a2 <timer+0x42>
			sys_yield();
		}
		if (r < 0)
  800199:	85 c0                	test   %eax,%eax
  80019b:	90                   	nop
  80019c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8001a0:	79 20                	jns    8001c2 <timer+0x62>
			panic("sys_time_msec: %e", r);
  8001a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001a6:	c7 44 24 08 aa 2e 80 	movl   $0x802eaa,0x8(%esp)
  8001ad:	00 
  8001ae:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8001b5:	00 
  8001b6:	c7 04 24 bc 2e 80 00 	movl   $0x802ebc,(%esp)
  8001bd:	e8 cf 01 00 00       	call   800391 <_panic>

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8001c2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001c9:	00 
  8001ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001d1:	00 
  8001d2:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  8001d9:	00 
  8001da:	89 1c 24             	mov    %ebx,(%esp)
  8001dd:	e8 72 15 00 00       	call   801754 <ipc_send>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8001e2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001e9:	00 
  8001ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001f1:	00 
  8001f2:	89 3c 24             	mov    %edi,(%esp)
  8001f5:	e8 06 15 00 00       	call   801700 <ipc_recv>
  8001fa:	89 c6                	mov    %eax,%esi

			if (whom != ns_envid) {
  8001fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ff:	39 c3                	cmp    %eax,%ebx
  800201:	74 12                	je     800215 <timer+0xb5>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800203:	89 44 24 04          	mov    %eax,0x4(%esp)
  800207:	c7 04 24 c8 2e 80 00 	movl   $0x802ec8,(%esp)
  80020e:	e8 77 02 00 00       	call   80048a <cprintf>
  800213:	eb cd                	jmp    8001e2 <timer+0x82>
				continue;
			}

			stop = sys_time_msec() + to;
  800215:	e8 21 0f 00 00       	call   80113b <sys_time_msec>
  80021a:	01 c6                	add    %eax,%esi
  80021c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800220:	e9 65 ff ff ff       	jmp    80018a <timer+0x2a>
  800225:	66 90                	xchg   %ax,%ax
  800227:	66 90                	xchg   %ax,%ax
  800229:	66 90                	xchg   %ax,%ax
  80022b:	66 90                	xchg   %ax,%ax
  80022d:	66 90                	xchg   %ax,%ax
  80022f:	90                   	nop

00800230 <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	57                   	push   %edi
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	81 ec 2c 08 00 00    	sub    $0x82c,%esp
	binaryname = "ns_input";
  80023c:	c7 05 00 40 80 00 03 	movl   $0x802f03,0x804000
  800243:	2f 80 00 
	char buf[PKT_MAX_SIZE];
	int err;

	while(1)
	{
		err = sys_pkt_recv(buf, &len);
  800246:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800249:	8d b5 e4 f7 ff ff    	lea    -0x81c(%ebp),%esi
  80024f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800253:	89 34 24             	mov    %esi,(%esp)
  800256:	e8 a5 0f 00 00       	call   801200 <sys_pkt_recv>
		if(err != 0)
  80025b:	85 c0                	test   %eax,%eax
  80025d:	74 0e                	je     80026d <input+0x3d>
		{
			sys_sleep(ENV_CHANNEL_RX);
  80025f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800266:	e8 e8 0f 00 00       	call   801253 <sys_sleep>
			continue;
  80026b:	eb e2                	jmp    80024f <input+0x1f>
		}

		nsipcbuf.pkt.jp_len = len;
  80026d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800270:	a3 00 70 80 00       	mov    %eax,0x807000
		memcpy(nsipcbuf.pkt.jp_data, buf, len);
  800275:	89 44 24 08          	mov    %eax,0x8(%esp)
  800279:	89 74 24 04          	mov    %esi,0x4(%esp)
  80027d:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  800284:	e8 33 0a 00 00       	call   800cbc <memcpy>
		
		ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800289:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800290:	00 
  800291:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  800298:	00 
  800299:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8002a0:	00 
  8002a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a4:	89 04 24             	mov    %eax,(%esp)
  8002a7:	e8 a8 14 00 00       	call   801754 <ipc_send>

		// Waiting for some time
		unsigned wait = sys_time_msec() + 50;
  8002ac:	e8 8a 0e 00 00       	call   80113b <sys_time_msec>
  8002b1:	8d 58 32             	lea    0x32(%eax),%ebx
		while (sys_time_msec() < wait){
  8002b4:	eb 05                	jmp    8002bb <input+0x8b>
			sys_yield();
  8002b6:	e8 f9 0b 00 00       	call   800eb4 <sys_yield>
		
		ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U);

		// Waiting for some time
		unsigned wait = sys_time_msec() + 50;
		while (sys_time_msec() < wait){
  8002bb:	90                   	nop
  8002bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8002c0:	e8 76 0e 00 00       	call   80113b <sys_time_msec>
  8002c5:	39 c3                	cmp    %eax,%ebx
  8002c7:	77 ed                	ja     8002b6 <input+0x86>
  8002c9:	eb 84                	jmp    80024f <input+0x1f>

008002cb <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8002cb:	55                   	push   %ebp
  8002cc:	89 e5                	mov    %esp,%ebp
  8002ce:	56                   	push   %esi
  8002cf:	53                   	push   %ebx
  8002d0:	83 ec 20             	sub    $0x20,%esp
	binaryname = "ns_output";
  8002d3:	c7 05 00 40 80 00 0c 	movl   $0x802f0c,0x804000
  8002da:	2f 80 00 
	envid_t envid;
	int32_t res;
	int err;
	while(1)
	{		
		res = ipc_recv(&envid, &nsipcbuf, &p);
  8002dd:	8d 75 f4             	lea    -0xc(%ebp),%esi
  8002e0:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  8002e3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002e7:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8002ee:	00 
  8002ef:	89 1c 24             	mov    %ebx,(%esp)
  8002f2:	e8 09 14 00 00       	call   801700 <ipc_recv>
		if(res != NSREQ_OUTPUT)
  8002f7:	83 f8 0b             	cmp    $0xb,%eax
  8002fa:	75 e7                	jne    8002e3 <output+0x18>
			continue;

		if(!(p & PTE_P))
  8002fc:	f6 45 f4 01          	testb  $0x1,-0xc(%ebp)
  800300:	74 e1                	je     8002e3 <output+0x18>
			continue;
		
		while (1) {
			err = sys_pkt_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
  800302:	a1 00 70 80 00       	mov    0x807000,%eax
  800307:	89 44 24 04          	mov    %eax,0x4(%esp)
  80030b:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  800312:	e8 96 0e 00 00       	call   8011ad <sys_pkt_send>

			if(err == 0)
  800317:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  80031c:	74 c5                	je     8002e3 <output+0x18>
				break;

			if(err == E_PACKET_TOO_BIG)
				break;

			sys_sleep(ENV_CHANNEL_TX);
  80031e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800325:	e8 29 0f 00 00       	call   801253 <sys_sleep>
		}
  80032a:	eb d6                	jmp    800302 <output+0x37>

0080032c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	56                   	push   %esi
  800330:	53                   	push   %ebx
  800331:	83 ec 10             	sub    $0x10,%esp
  800334:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800337:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  80033a:	e8 56 0b 00 00       	call   800e95 <sys_getenvid>
  80033f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800344:	89 c2                	mov    %eax,%edx
  800346:	c1 e2 07             	shl    $0x7,%edx
  800349:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800350:	a3 0c 50 80 00       	mov    %eax,0x80500c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800355:	85 db                	test   %ebx,%ebx
  800357:	7e 07                	jle    800360 <libmain+0x34>
		binaryname = argv[0];
  800359:	8b 06                	mov    (%esi),%eax
  80035b:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800360:	89 74 24 04          	mov    %esi,0x4(%esp)
  800364:	89 1c 24             	mov    %ebx,(%esp)
  800367:	e8 c7 fc ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80036c:	e8 07 00 00 00       	call   800378 <exit>
}
  800371:	83 c4 10             	add    $0x10,%esp
  800374:	5b                   	pop    %ebx
  800375:	5e                   	pop    %esi
  800376:	5d                   	pop    %ebp
  800377:	c3                   	ret    

00800378 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80037e:	e8 57 16 00 00       	call   8019da <close_all>
	sys_env_destroy(0);
  800383:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80038a:	e8 b4 0a 00 00       	call   800e43 <sys_env_destroy>
}
  80038f:	c9                   	leave  
  800390:	c3                   	ret    

00800391 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
  800394:	56                   	push   %esi
  800395:	53                   	push   %ebx
  800396:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800399:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80039c:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8003a2:	e8 ee 0a 00 00       	call   800e95 <sys_getenvid>
  8003a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003aa:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003b5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003bd:	c7 04 24 20 2f 80 00 	movl   $0x802f20,(%esp)
  8003c4:	e8 c1 00 00 00       	call   80048a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003c9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d0:	89 04 24             	mov    %eax,(%esp)
  8003d3:	e8 51 00 00 00       	call   800429 <vcprintf>
	cprintf("\n");
  8003d8:	c7 04 24 9f 2e 80 00 	movl   $0x802e9f,(%esp)
  8003df:	e8 a6 00 00 00       	call   80048a <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003e4:	cc                   	int3   
  8003e5:	eb fd                	jmp    8003e4 <_panic+0x53>

008003e7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	53                   	push   %ebx
  8003eb:	83 ec 14             	sub    $0x14,%esp
  8003ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003f1:	8b 13                	mov    (%ebx),%edx
  8003f3:	8d 42 01             	lea    0x1(%edx),%eax
  8003f6:	89 03                	mov    %eax,(%ebx)
  8003f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003fb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800404:	75 19                	jne    80041f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800406:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80040d:	00 
  80040e:	8d 43 08             	lea    0x8(%ebx),%eax
  800411:	89 04 24             	mov    %eax,(%esp)
  800414:	e8 ed 09 00 00       	call   800e06 <sys_cputs>
		b->idx = 0;
  800419:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80041f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800423:	83 c4 14             	add    $0x14,%esp
  800426:	5b                   	pop    %ebx
  800427:	5d                   	pop    %ebp
  800428:	c3                   	ret    

00800429 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800429:	55                   	push   %ebp
  80042a:	89 e5                	mov    %esp,%ebp
  80042c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800432:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800439:	00 00 00 
	b.cnt = 0;
  80043c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800443:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800446:	8b 45 0c             	mov    0xc(%ebp),%eax
  800449:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	89 44 24 08          	mov    %eax,0x8(%esp)
  800454:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80045a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80045e:	c7 04 24 e7 03 80 00 	movl   $0x8003e7,(%esp)
  800465:	e8 b4 01 00 00       	call   80061e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80046a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800470:	89 44 24 04          	mov    %eax,0x4(%esp)
  800474:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80047a:	89 04 24             	mov    %eax,(%esp)
  80047d:	e8 84 09 00 00       	call   800e06 <sys_cputs>

	return b.cnt;
}
  800482:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800488:	c9                   	leave  
  800489:	c3                   	ret    

0080048a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80048a:	55                   	push   %ebp
  80048b:	89 e5                	mov    %esp,%ebp
  80048d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800490:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800493:	89 44 24 04          	mov    %eax,0x4(%esp)
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	89 04 24             	mov    %eax,(%esp)
  80049d:	e8 87 ff ff ff       	call   800429 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004a2:	c9                   	leave  
  8004a3:	c3                   	ret    
  8004a4:	66 90                	xchg   %ax,%ax
  8004a6:	66 90                	xchg   %ax,%ax
  8004a8:	66 90                	xchg   %ax,%ax
  8004aa:	66 90                	xchg   %ax,%ax
  8004ac:	66 90                	xchg   %ax,%ax
  8004ae:	66 90                	xchg   %ax,%ax

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
  80051f:	e8 7c 26 00 00       	call   802ba0 <__udivdi3>
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
  80057f:	e8 4c 27 00 00       	call   802cd0 <__umoddi3>
  800584:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800588:	0f be 80 43 2f 80 00 	movsbl 0x802f43(%eax),%eax
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
  8006a3:	ff 24 8d c0 30 80 00 	jmp    *0x8030c0(,%ecx,4)
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
  800740:	8b 14 85 20 32 80 00 	mov    0x803220(,%eax,4),%edx
  800747:	85 d2                	test   %edx,%edx
  800749:	75 20                	jne    80076b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80074b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80074f:	c7 44 24 08 5b 2f 80 	movl   $0x802f5b,0x8(%esp)
  800756:	00 
  800757:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	89 04 24             	mov    %eax,(%esp)
  800761:	e8 90 fe ff ff       	call   8005f6 <printfmt>
  800766:	e9 d8 fe ff ff       	jmp    800643 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80076b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80076f:	c7 44 24 08 8d 34 80 	movl   $0x80348d,0x8(%esp)
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
  8007a1:	b8 54 2f 80 00       	mov    $0x802f54,%eax
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
  800e71:	c7 44 24 08 8b 32 80 	movl   $0x80328b,0x8(%esp)
  800e78:	00 
  800e79:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e80:	00 
  800e81:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  800e88:	e8 04 f5 ff ff       	call   800391 <_panic>

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
  800f03:	c7 44 24 08 8b 32 80 	movl   $0x80328b,0x8(%esp)
  800f0a:	00 
  800f0b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f12:	00 
  800f13:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  800f1a:	e8 72 f4 ff ff       	call   800391 <_panic>

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
  800f56:	c7 44 24 08 8b 32 80 	movl   $0x80328b,0x8(%esp)
  800f5d:	00 
  800f5e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f65:	00 
  800f66:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  800f6d:	e8 1f f4 ff ff       	call   800391 <_panic>

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
  800fa9:	c7 44 24 08 8b 32 80 	movl   $0x80328b,0x8(%esp)
  800fb0:	00 
  800fb1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb8:	00 
  800fb9:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  800fc0:	e8 cc f3 ff ff       	call   800391 <_panic>

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
  800ffc:	c7 44 24 08 8b 32 80 	movl   $0x80328b,0x8(%esp)
  801003:	00 
  801004:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80100b:	00 
  80100c:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  801013:	e8 79 f3 ff ff       	call   800391 <_panic>

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
  80104f:	c7 44 24 08 8b 32 80 	movl   $0x80328b,0x8(%esp)
  801056:	00 
  801057:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80105e:	00 
  80105f:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  801066:	e8 26 f3 ff ff       	call   800391 <_panic>

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
  8010a2:	c7 44 24 08 8b 32 80 	movl   $0x80328b,0x8(%esp)
  8010a9:	00 
  8010aa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b1:	00 
  8010b2:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  8010b9:	e8 d3 f2 ff ff       	call   800391 <_panic>

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
  801117:	c7 44 24 08 8b 32 80 	movl   $0x80328b,0x8(%esp)
  80111e:	00 
  80111f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801126:	00 
  801127:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  80112e:	e8 5e f2 ff ff       	call   800391 <_panic>

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
  801189:	c7 44 24 08 8b 32 80 	movl   $0x80328b,0x8(%esp)
  801190:	00 
  801191:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801198:	00 
  801199:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  8011a0:	e8 ec f1 ff ff       	call   800391 <_panic>

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
  8011dc:	c7 44 24 08 8b 32 80 	movl   $0x80328b,0x8(%esp)
  8011e3:	00 
  8011e4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011eb:	00 
  8011ec:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  8011f3:	e8 99 f1 ff ff       	call   800391 <_panic>

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
  80122f:	c7 44 24 08 8b 32 80 	movl   $0x80328b,0x8(%esp)
  801236:	00 
  801237:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80123e:	00 
  80123f:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  801246:	e8 46 f1 ff ff       	call   800391 <_panic>

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
  801281:	c7 44 24 08 8b 32 80 	movl   $0x80328b,0x8(%esp)
  801288:	00 
  801289:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801290:	00 
  801291:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  801298:	e8 f4 f0 ff ff       	call   800391 <_panic>

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
  8012d4:	c7 44 24 08 8b 32 80 	movl   $0x80328b,0x8(%esp)
  8012db:	00 
  8012dc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012e3:	00 
  8012e4:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  8012eb:	e8 a1 f0 ff ff       	call   800391 <_panic>

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

008012f8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	53                   	push   %ebx
  8012fc:	83 ec 24             	sub    $0x24,%esp
  8012ff:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801302:	8b 02                	mov    (%edx),%eax
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(((err & FEC_WR) == 0) || ((uvpd[PDX(addr)] & PTE_P) == 0) || (((~uvpt[PGNUM(addr)])&(PTE_COW|PTE_P)) != 0)) {
  801304:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801308:	74 27                	je     801331 <pgfault+0x39>
  80130a:	89 c2                	mov    %eax,%edx
  80130c:	c1 ea 16             	shr    $0x16,%edx
  80130f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801316:	f6 c2 01             	test   $0x1,%dl
  801319:	74 16                	je     801331 <pgfault+0x39>
  80131b:	89 c2                	mov    %eax,%edx
  80131d:	c1 ea 0c             	shr    $0xc,%edx
  801320:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801327:	f7 d2                	not    %edx
  801329:	f7 c2 01 08 00 00    	test   $0x801,%edx
  80132f:	74 1c                	je     80134d <pgfault+0x55>
		panic("pgfault");
  801331:	c7 44 24 08 b6 32 80 	movl   $0x8032b6,0x8(%esp)
  801338:	00 
  801339:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  801340:	00 
  801341:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  801348:	e8 44 f0 ff ff       	call   800391 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	addr = (void*)ROUNDDOWN(addr,PGSIZE);
  80134d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801352:	89 c3                	mov    %eax,%ebx
	
	if(sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U) < 0) {
  801354:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80135b:	00 
  80135c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801363:	00 
  801364:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80136b:	e8 63 fb ff ff       	call   800ed3 <sys_page_alloc>
  801370:	85 c0                	test   %eax,%eax
  801372:	79 1c                	jns    801390 <pgfault+0x98>
		panic("pgfault(): sys_page_alloc");
  801374:	c7 44 24 08 c9 32 80 	movl   $0x8032c9,0x8(%esp)
  80137b:	00 
  80137c:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  801383:	00 
  801384:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  80138b:	e8 01 f0 ff ff       	call   800391 <_panic>
	}
	memcpy((void*)PFTEMP, addr, PGSIZE);
  801390:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801397:	00 
  801398:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80139c:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8013a3:	e8 14 f9 ff ff       	call   800cbc <memcpy>

	if(sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0) {
  8013a8:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8013af:	00 
  8013b0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013b4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013bb:	00 
  8013bc:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8013c3:	00 
  8013c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013cb:	e8 57 fb ff ff       	call   800f27 <sys_page_map>
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	79 1c                	jns    8013f0 <pgfault+0xf8>
		panic("pgfault(): sys_page_map");
  8013d4:	c7 44 24 08 e3 32 80 	movl   $0x8032e3,0x8(%esp)
  8013db:	00 
  8013dc:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8013e3:	00 
  8013e4:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  8013eb:	e8 a1 ef ff ff       	call   800391 <_panic>
	}

	if(sys_page_unmap(0, (void*)PFTEMP) < 0) {
  8013f0:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8013f7:	00 
  8013f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013ff:	e8 76 fb ff ff       	call   800f7a <sys_page_unmap>
  801404:	85 c0                	test   %eax,%eax
  801406:	79 1c                	jns    801424 <pgfault+0x12c>
		panic("pgfault(): sys_page_unmap");
  801408:	c7 44 24 08 fb 32 80 	movl   $0x8032fb,0x8(%esp)
  80140f:	00 
  801410:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801417:	00 
  801418:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  80141f:	e8 6d ef ff ff       	call   800391 <_panic>
	}
}
  801424:	83 c4 24             	add    $0x24,%esp
  801427:	5b                   	pop    %ebx
  801428:	5d                   	pop    %ebp
  801429:	c3                   	ret    

0080142a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	57                   	push   %edi
  80142e:	56                   	push   %esi
  80142f:	53                   	push   %ebx
  801430:	83 ec 2c             	sub    $0x2c,%esp
	set_pgfault_handler(pgfault);
  801433:	c7 04 24 f8 12 80 00 	movl   $0x8012f8,(%esp)
  80143a:	e8 77 16 00 00       	call   802ab6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80143f:	b8 07 00 00 00       	mov    $0x7,%eax
  801444:	cd 30                	int    $0x30
  801446:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	envid_t env_id = sys_exofork();
	if(env_id < 0){
  801449:	85 c0                	test   %eax,%eax
  80144b:	79 1c                	jns    801469 <fork+0x3f>
		panic("fork(): sys_exofork");
  80144d:	c7 44 24 08 15 33 80 	movl   $0x803315,0x8(%esp)
  801454:	00 
  801455:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  80145c:	00 
  80145d:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  801464:	e8 28 ef ff ff       	call   800391 <_panic>
  801469:	89 c7                	mov    %eax,%edi
	}
	else if(env_id == 0){
  80146b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80146f:	74 0a                	je     80147b <fork+0x51>
  801471:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801476:	e9 9d 01 00 00       	jmp    801618 <fork+0x1ee>
		thisenv = envs + ENVX(sys_getenvid());
  80147b:	e8 15 fa ff ff       	call   800e95 <sys_getenvid>
  801480:	25 ff 03 00 00       	and    $0x3ff,%eax
  801485:	89 c2                	mov    %eax,%edx
  801487:	c1 e2 07             	shl    $0x7,%edx
  80148a:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  801491:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return env_id;
  801496:	e9 2a 02 00 00       	jmp    8016c5 <fork+0x29b>
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
		if(addr == UXSTACKTOP - PGSIZE){
  80149b:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8014a1:	0f 84 6b 01 00 00    	je     801612 <fork+0x1e8>
			continue;
		}
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
  8014a7:	89 d8                	mov    %ebx,%eax
  8014a9:	c1 e8 16             	shr    $0x16,%eax
  8014ac:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014b3:	a8 01                	test   $0x1,%al
  8014b5:	0f 84 57 01 00 00    	je     801612 <fork+0x1e8>
  8014bb:	89 d8                	mov    %ebx,%eax
  8014bd:	c1 e8 0c             	shr    $0xc,%eax
  8014c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014c7:	f7 d0                	not    %eax
  8014c9:	a8 05                	test   $0x5,%al
  8014cb:	0f 85 41 01 00 00    	jne    801612 <fork+0x1e8>
			duppage(env_id,addr/PGSIZE);
  8014d1:	89 d8                	mov    %ebx,%eax
  8014d3:	c1 e8 0c             	shr    $0xc,%eax
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void* addr = (void*)(pn*PGSIZE);
  8014d6:	89 c6                	mov    %eax,%esi
  8014d8:	c1 e6 0c             	shl    $0xc,%esi

	if (uvpt[pn] & PTE_SHARE) {
  8014db:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014e2:	f6 c6 04             	test   $0x4,%dh
  8014e5:	74 4c                	je     801533 <fork+0x109>
		if (sys_page_map(0, addr, envid, addr, uvpt[pn]&PTE_SYSCALL) < 0)
  8014e7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014ee:	25 07 0e 00 00       	and    $0xe07,%eax
  8014f3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014f7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8014fb:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014ff:	89 74 24 04          	mov    %esi,0x4(%esp)
  801503:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80150a:	e8 18 fa ff ff       	call   800f27 <sys_page_map>
  80150f:	85 c0                	test   %eax,%eax
  801511:	0f 89 fb 00 00 00    	jns    801612 <fork+0x1e8>
			panic("duppage: sys_page_map");
  801517:	c7 44 24 08 29 33 80 	movl   $0x803329,0x8(%esp)
  80151e:	00 
  80151f:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  801526:	00 
  801527:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  80152e:	e8 5e ee ff ff       	call   800391 <_panic>
	} else if((uvpt[pn] & PTE_COW) || (uvpt[pn] & PTE_W)) {
  801533:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80153a:	f6 c6 08             	test   $0x8,%dh
  80153d:	75 0f                	jne    80154e <fork+0x124>
  80153f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801546:	a8 02                	test   $0x2,%al
  801548:	0f 84 84 00 00 00    	je     8015d2 <fork+0x1a8>
		if(sys_page_map(0, addr, envid, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80154e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801555:	00 
  801556:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80155a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80155e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801562:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801569:	e8 b9 f9 ff ff       	call   800f27 <sys_page_map>
  80156e:	85 c0                	test   %eax,%eax
  801570:	79 1c                	jns    80158e <fork+0x164>
			panic("duppage: sys_page_map");
  801572:	c7 44 24 08 29 33 80 	movl   $0x803329,0x8(%esp)
  801579:	00 
  80157a:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  801581:	00 
  801582:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  801589:	e8 03 ee ff ff       	call   800391 <_panic>
		}
		if(sys_page_map(0, addr, 0, addr, PTE_COW | PTE_U | PTE_P) < 0){
  80158e:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801595:	00 
  801596:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80159a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015a1:	00 
  8015a2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015ad:	e8 75 f9 ff ff       	call   800f27 <sys_page_map>
  8015b2:	85 c0                	test   %eax,%eax
  8015b4:	79 5c                	jns    801612 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8015b6:	c7 44 24 08 29 33 80 	movl   $0x803329,0x8(%esp)
  8015bd:	00 
  8015be:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  8015c5:	00 
  8015c6:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  8015cd:	e8 bf ed ff ff       	call   800391 <_panic>
		}
	} else {
		if(sys_page_map(0, addr, envid, addr, PTE_U | PTE_P) < 0){
  8015d2:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8015d9:	00 
  8015da:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8015de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8015e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015ed:	e8 35 f9 ff ff       	call   800f27 <sys_page_map>
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	79 1c                	jns    801612 <fork+0x1e8>
			panic("duppage: sys_page_map");
  8015f6:	c7 44 24 08 29 33 80 	movl   $0x803329,0x8(%esp)
  8015fd:	00 
  8015fe:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  801605:	00 
  801606:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  80160d:	e8 7f ed ff ff       	call   800391 <_panic>
		thisenv = envs + ENVX(sys_getenvid());
		return env_id;
	}

	uint32_t addr;
	for(addr = UTEXT; addr < UTOP; addr += PGSIZE){
  801612:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801618:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80161e:	0f 85 77 fe ff ff    	jne    80149b <fork+0x71>
		if(((uvpd[PDX(addr)]&PTE_P) != 0) && (((~uvpt[PGNUM(addr)])&(PTE_P|PTE_U)) == 0)) {
			duppage(env_id,addr/PGSIZE);
		}
	}

	if(sys_page_alloc(env_id, (void*)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) {
  801624:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80162b:	00 
  80162c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801633:	ee 
  801634:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801637:	89 04 24             	mov    %eax,(%esp)
  80163a:	e8 94 f8 ff ff       	call   800ed3 <sys_page_alloc>
  80163f:	85 c0                	test   %eax,%eax
  801641:	79 1c                	jns    80165f <fork+0x235>
		panic("fork(): sys_page_alloc");
  801643:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  80164a:	00 
  80164b:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801652:	00 
  801653:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  80165a:	e8 32 ed ff ff       	call   800391 <_panic>
	}

	extern void _pgfault_upcall(void);
	if(sys_env_set_pgfault_upcall(env_id, _pgfault_upcall) < 0) {
  80165f:	c7 44 24 04 3f 2b 80 	movl   $0x802b3f,0x4(%esp)
  801666:	00 
  801667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80166a:	89 04 24             	mov    %eax,(%esp)
  80166d:	e8 01 fa ff ff       	call   801073 <sys_env_set_pgfault_upcall>
  801672:	85 c0                	test   %eax,%eax
  801674:	79 1c                	jns    801692 <fork+0x268>
		panic("fork(): ys_env_set_pgfault_upcall");
  801676:	c7 44 24 08 88 33 80 	movl   $0x803388,0x8(%esp)
  80167d:	00 
  80167e:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  801685:	00 
  801686:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  80168d:	e8 ff ec ff ff       	call   800391 <_panic>
	}

	if(sys_env_set_status(env_id, ENV_RUNNABLE) < 0) {
  801692:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801699:	00 
  80169a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80169d:	89 04 24             	mov    %eax,(%esp)
  8016a0:	e8 28 f9 ff ff       	call   800fcd <sys_env_set_status>
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	79 1c                	jns    8016c5 <fork+0x29b>
		panic("fork(): sys_env_set_status");
  8016a9:	c7 44 24 08 56 33 80 	movl   $0x803356,0x8(%esp)
  8016b0:	00 
  8016b1:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
  8016b8:	00 
  8016b9:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  8016c0:	e8 cc ec ff ff       	call   800391 <_panic>
	}

	return env_id;
}
  8016c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016c8:	83 c4 2c             	add    $0x2c,%esp
  8016cb:	5b                   	pop    %ebx
  8016cc:	5e                   	pop    %esi
  8016cd:	5f                   	pop    %edi
  8016ce:	5d                   	pop    %ebp
  8016cf:	c3                   	ret    

008016d0 <sfork>:

// Challenge!
int
sfork(void)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8016d6:	c7 44 24 08 71 33 80 	movl   $0x803371,0x8(%esp)
  8016dd:	00 
  8016de:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  8016e5:	00 
  8016e6:	c7 04 24 be 32 80 00 	movl   $0x8032be,(%esp)
  8016ed:	e8 9f ec ff ff       	call   800391 <_panic>
  8016f2:	66 90                	xchg   %ax,%ax
  8016f4:	66 90                	xchg   %ax,%ax
  8016f6:	66 90                	xchg   %ax,%ax
  8016f8:	66 90                	xchg   %ax,%ax
  8016fa:	66 90                	xchg   %ax,%ax
  8016fc:	66 90                	xchg   %ax,%ax
  8016fe:	66 90                	xchg   %ax,%ax

00801700 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	56                   	push   %esi
  801704:	53                   	push   %ebx
  801705:	83 ec 10             	sub    $0x10,%esp
  801708:	8b 75 08             	mov    0x8(%ebp),%esi
  80170b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801711:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  801713:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801718:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80171b:	89 04 24             	mov    %eax,(%esp)
  80171e:	e8 c6 f9 ff ff       	call   8010e9 <sys_ipc_recv>
  801723:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  801725:	85 d2                	test   %edx,%edx
  801727:	75 24                	jne    80174d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  801729:	85 f6                	test   %esi,%esi
  80172b:	74 0a                	je     801737 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80172d:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801732:	8b 40 74             	mov    0x74(%eax),%eax
  801735:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  801737:	85 db                	test   %ebx,%ebx
  801739:	74 0a                	je     801745 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80173b:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801740:	8b 40 78             	mov    0x78(%eax),%eax
  801743:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  801745:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80174a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80174d:	83 c4 10             	add    $0x10,%esp
  801750:	5b                   	pop    %ebx
  801751:	5e                   	pop    %esi
  801752:	5d                   	pop    %ebp
  801753:	c3                   	ret    

00801754 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	57                   	push   %edi
  801758:	56                   	push   %esi
  801759:	53                   	push   %ebx
  80175a:	83 ec 1c             	sub    $0x1c,%esp
  80175d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801760:	8b 75 0c             	mov    0xc(%ebp),%esi
  801763:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  801766:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  801768:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80176d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801770:	8b 45 14             	mov    0x14(%ebp),%eax
  801773:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801777:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80177b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80177f:	89 3c 24             	mov    %edi,(%esp)
  801782:	e8 3f f9 ff ff       	call   8010c6 <sys_ipc_try_send>

		if (ret == 0)
  801787:	85 c0                	test   %eax,%eax
  801789:	74 2c                	je     8017b7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80178b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80178e:	74 20                	je     8017b0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  801790:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801794:	c7 44 24 08 ac 33 80 	movl   $0x8033ac,0x8(%esp)
  80179b:	00 
  80179c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8017a3:	00 
  8017a4:	c7 04 24 da 33 80 00 	movl   $0x8033da,(%esp)
  8017ab:	e8 e1 eb ff ff       	call   800391 <_panic>
		}

		sys_yield();
  8017b0:	e8 ff f6 ff ff       	call   800eb4 <sys_yield>
	}
  8017b5:	eb b9                	jmp    801770 <ipc_send+0x1c>
}
  8017b7:	83 c4 1c             	add    $0x1c,%esp
  8017ba:	5b                   	pop    %ebx
  8017bb:	5e                   	pop    %esi
  8017bc:	5f                   	pop    %edi
  8017bd:	5d                   	pop    %ebp
  8017be:	c3                   	ret    

008017bf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8017c5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8017ca:	89 c2                	mov    %eax,%edx
  8017cc:	c1 e2 07             	shl    $0x7,%edx
  8017cf:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  8017d6:	8b 52 50             	mov    0x50(%edx),%edx
  8017d9:	39 ca                	cmp    %ecx,%edx
  8017db:	75 11                	jne    8017ee <ipc_find_env+0x2f>
			return envs[i].env_id;
  8017dd:	89 c2                	mov    %eax,%edx
  8017df:	c1 e2 07             	shl    $0x7,%edx
  8017e2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  8017e9:	8b 40 40             	mov    0x40(%eax),%eax
  8017ec:	eb 0e                	jmp    8017fc <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8017ee:	83 c0 01             	add    $0x1,%eax
  8017f1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8017f6:	75 d2                	jne    8017ca <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8017f8:	66 b8 00 00          	mov    $0x0,%ax
}
  8017fc:	5d                   	pop    %ebp
  8017fd:	c3                   	ret    
  8017fe:	66 90                	xchg   %ax,%ax

00801800 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	05 00 00 00 30       	add    $0x30000000,%eax
  80180b:	c1 e8 0c             	shr    $0xc,%eax
}
  80180e:	5d                   	pop    %ebp
  80180f:	c3                   	ret    

00801810 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80181b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801820:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801825:	5d                   	pop    %ebp
  801826:	c3                   	ret    

00801827 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80182d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801832:	89 c2                	mov    %eax,%edx
  801834:	c1 ea 16             	shr    $0x16,%edx
  801837:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80183e:	f6 c2 01             	test   $0x1,%dl
  801841:	74 11                	je     801854 <fd_alloc+0x2d>
  801843:	89 c2                	mov    %eax,%edx
  801845:	c1 ea 0c             	shr    $0xc,%edx
  801848:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80184f:	f6 c2 01             	test   $0x1,%dl
  801852:	75 09                	jne    80185d <fd_alloc+0x36>
			*fd_store = fd;
  801854:	89 01                	mov    %eax,(%ecx)
			return 0;
  801856:	b8 00 00 00 00       	mov    $0x0,%eax
  80185b:	eb 17                	jmp    801874 <fd_alloc+0x4d>
  80185d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801862:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801867:	75 c9                	jne    801832 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801869:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80186f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801874:	5d                   	pop    %ebp
  801875:	c3                   	ret    

00801876 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80187c:	83 f8 1f             	cmp    $0x1f,%eax
  80187f:	77 36                	ja     8018b7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801881:	c1 e0 0c             	shl    $0xc,%eax
  801884:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801889:	89 c2                	mov    %eax,%edx
  80188b:	c1 ea 16             	shr    $0x16,%edx
  80188e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801895:	f6 c2 01             	test   $0x1,%dl
  801898:	74 24                	je     8018be <fd_lookup+0x48>
  80189a:	89 c2                	mov    %eax,%edx
  80189c:	c1 ea 0c             	shr    $0xc,%edx
  80189f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018a6:	f6 c2 01             	test   $0x1,%dl
  8018a9:	74 1a                	je     8018c5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ae:	89 02                	mov    %eax,(%edx)
	return 0;
  8018b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b5:	eb 13                	jmp    8018ca <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8018b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018bc:	eb 0c                	jmp    8018ca <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8018be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c3:	eb 05                	jmp    8018ca <fd_lookup+0x54>
  8018c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8018ca:	5d                   	pop    %ebp
  8018cb:	c3                   	ret    

008018cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	83 ec 18             	sub    $0x18,%esp
  8018d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8018d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018da:	eb 13                	jmp    8018ef <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8018dc:	39 08                	cmp    %ecx,(%eax)
  8018de:	75 0c                	jne    8018ec <dev_lookup+0x20>
			*dev = devtab[i];
  8018e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ea:	eb 38                	jmp    801924 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8018ec:	83 c2 01             	add    $0x1,%edx
  8018ef:	8b 04 95 60 34 80 00 	mov    0x803460(,%edx,4),%eax
  8018f6:	85 c0                	test   %eax,%eax
  8018f8:	75 e2                	jne    8018dc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018fa:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8018ff:	8b 40 48             	mov    0x48(%eax),%eax
  801902:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801906:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190a:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  801911:	e8 74 eb ff ff       	call   80048a <cprintf>
	*dev = 0;
  801916:	8b 45 0c             	mov    0xc(%ebp),%eax
  801919:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80191f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	56                   	push   %esi
  80192a:	53                   	push   %ebx
  80192b:	83 ec 20             	sub    $0x20,%esp
  80192e:	8b 75 08             	mov    0x8(%ebp),%esi
  801931:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801934:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801937:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80193b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801941:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801944:	89 04 24             	mov    %eax,(%esp)
  801947:	e8 2a ff ff ff       	call   801876 <fd_lookup>
  80194c:	85 c0                	test   %eax,%eax
  80194e:	78 05                	js     801955 <fd_close+0x2f>
	    || fd != fd2)
  801950:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801953:	74 0c                	je     801961 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801955:	84 db                	test   %bl,%bl
  801957:	ba 00 00 00 00       	mov    $0x0,%edx
  80195c:	0f 44 c2             	cmove  %edx,%eax
  80195f:	eb 3f                	jmp    8019a0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801961:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801964:	89 44 24 04          	mov    %eax,0x4(%esp)
  801968:	8b 06                	mov    (%esi),%eax
  80196a:	89 04 24             	mov    %eax,(%esp)
  80196d:	e8 5a ff ff ff       	call   8018cc <dev_lookup>
  801972:	89 c3                	mov    %eax,%ebx
  801974:	85 c0                	test   %eax,%eax
  801976:	78 16                	js     80198e <fd_close+0x68>
		if (dev->dev_close)
  801978:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80197e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801983:	85 c0                	test   %eax,%eax
  801985:	74 07                	je     80198e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801987:	89 34 24             	mov    %esi,(%esp)
  80198a:	ff d0                	call   *%eax
  80198c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80198e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801992:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801999:	e8 dc f5 ff ff       	call   800f7a <sys_page_unmap>
	return r;
  80199e:	89 d8                	mov    %ebx,%eax
}
  8019a0:	83 c4 20             	add    $0x20,%esp
  8019a3:	5b                   	pop    %ebx
  8019a4:	5e                   	pop    %esi
  8019a5:	5d                   	pop    %ebp
  8019a6:	c3                   	ret    

008019a7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	89 04 24             	mov    %eax,(%esp)
  8019ba:	e8 b7 fe ff ff       	call   801876 <fd_lookup>
  8019bf:	89 c2                	mov    %eax,%edx
  8019c1:	85 d2                	test   %edx,%edx
  8019c3:	78 13                	js     8019d8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8019c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8019cc:	00 
  8019cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d0:	89 04 24             	mov    %eax,(%esp)
  8019d3:	e8 4e ff ff ff       	call   801926 <fd_close>
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <close_all>:

void
close_all(void)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	53                   	push   %ebx
  8019de:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8019e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8019e6:	89 1c 24             	mov    %ebx,(%esp)
  8019e9:	e8 b9 ff ff ff       	call   8019a7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8019ee:	83 c3 01             	add    $0x1,%ebx
  8019f1:	83 fb 20             	cmp    $0x20,%ebx
  8019f4:	75 f0                	jne    8019e6 <close_all+0xc>
		close(i);
}
  8019f6:	83 c4 14             	add    $0x14,%esp
  8019f9:	5b                   	pop    %ebx
  8019fa:	5d                   	pop    %ebp
  8019fb:	c3                   	ret    

008019fc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	57                   	push   %edi
  801a00:	56                   	push   %esi
  801a01:	53                   	push   %ebx
  801a02:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a05:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	89 04 24             	mov    %eax,(%esp)
  801a12:	e8 5f fe ff ff       	call   801876 <fd_lookup>
  801a17:	89 c2                	mov    %eax,%edx
  801a19:	85 d2                	test   %edx,%edx
  801a1b:	0f 88 e1 00 00 00    	js     801b02 <dup+0x106>
		return r;
	close(newfdnum);
  801a21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a24:	89 04 24             	mov    %eax,(%esp)
  801a27:	e8 7b ff ff ff       	call   8019a7 <close>

	newfd = INDEX2FD(newfdnum);
  801a2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a2f:	c1 e3 0c             	shl    $0xc,%ebx
  801a32:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801a38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a3b:	89 04 24             	mov    %eax,(%esp)
  801a3e:	e8 cd fd ff ff       	call   801810 <fd2data>
  801a43:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801a45:	89 1c 24             	mov    %ebx,(%esp)
  801a48:	e8 c3 fd ff ff       	call   801810 <fd2data>
  801a4d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a4f:	89 f0                	mov    %esi,%eax
  801a51:	c1 e8 16             	shr    $0x16,%eax
  801a54:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a5b:	a8 01                	test   $0x1,%al
  801a5d:	74 43                	je     801aa2 <dup+0xa6>
  801a5f:	89 f0                	mov    %esi,%eax
  801a61:	c1 e8 0c             	shr    $0xc,%eax
  801a64:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a6b:	f6 c2 01             	test   $0x1,%dl
  801a6e:	74 32                	je     801aa2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a70:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a77:	25 07 0e 00 00       	and    $0xe07,%eax
  801a7c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a80:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a84:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a8b:	00 
  801a8c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a97:	e8 8b f4 ff ff       	call   800f27 <sys_page_map>
  801a9c:	89 c6                	mov    %eax,%esi
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	78 3e                	js     801ae0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801aa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aa5:	89 c2                	mov    %eax,%edx
  801aa7:	c1 ea 0c             	shr    $0xc,%edx
  801aaa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801ab1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801ab7:	89 54 24 10          	mov    %edx,0x10(%esp)
  801abb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801abf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ac6:	00 
  801ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801acb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ad2:	e8 50 f4 ff ff       	call   800f27 <sys_page_map>
  801ad7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801adc:	85 f6                	test   %esi,%esi
  801ade:	79 22                	jns    801b02 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801ae0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ae4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aeb:	e8 8a f4 ff ff       	call   800f7a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801af0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801af4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801afb:	e8 7a f4 ff ff       	call   800f7a <sys_page_unmap>
	return r;
  801b00:	89 f0                	mov    %esi,%eax
}
  801b02:	83 c4 3c             	add    $0x3c,%esp
  801b05:	5b                   	pop    %ebx
  801b06:	5e                   	pop    %esi
  801b07:	5f                   	pop    %edi
  801b08:	5d                   	pop    %ebp
  801b09:	c3                   	ret    

00801b0a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	53                   	push   %ebx
  801b0e:	83 ec 24             	sub    $0x24,%esp
  801b11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b14:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1b:	89 1c 24             	mov    %ebx,(%esp)
  801b1e:	e8 53 fd ff ff       	call   801876 <fd_lookup>
  801b23:	89 c2                	mov    %eax,%edx
  801b25:	85 d2                	test   %edx,%edx
  801b27:	78 6d                	js     801b96 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b33:	8b 00                	mov    (%eax),%eax
  801b35:	89 04 24             	mov    %eax,(%esp)
  801b38:	e8 8f fd ff ff       	call   8018cc <dev_lookup>
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	78 55                	js     801b96 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b44:	8b 50 08             	mov    0x8(%eax),%edx
  801b47:	83 e2 03             	and    $0x3,%edx
  801b4a:	83 fa 01             	cmp    $0x1,%edx
  801b4d:	75 23                	jne    801b72 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b4f:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801b54:	8b 40 48             	mov    0x48(%eax),%eax
  801b57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5f:	c7 04 24 25 34 80 00 	movl   $0x803425,(%esp)
  801b66:	e8 1f e9 ff ff       	call   80048a <cprintf>
		return -E_INVAL;
  801b6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b70:	eb 24                	jmp    801b96 <read+0x8c>
	}
	if (!dev->dev_read)
  801b72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b75:	8b 52 08             	mov    0x8(%edx),%edx
  801b78:	85 d2                	test   %edx,%edx
  801b7a:	74 15                	je     801b91 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b8a:	89 04 24             	mov    %eax,(%esp)
  801b8d:	ff d2                	call   *%edx
  801b8f:	eb 05                	jmp    801b96 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801b91:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801b96:	83 c4 24             	add    $0x24,%esp
  801b99:	5b                   	pop    %ebx
  801b9a:	5d                   	pop    %ebp
  801b9b:	c3                   	ret    

00801b9c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	57                   	push   %edi
  801ba0:	56                   	push   %esi
  801ba1:	53                   	push   %ebx
  801ba2:	83 ec 1c             	sub    $0x1c,%esp
  801ba5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ba8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bab:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bb0:	eb 23                	jmp    801bd5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bb2:	89 f0                	mov    %esi,%eax
  801bb4:	29 d8                	sub    %ebx,%eax
  801bb6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bba:	89 d8                	mov    %ebx,%eax
  801bbc:	03 45 0c             	add    0xc(%ebp),%eax
  801bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc3:	89 3c 24             	mov    %edi,(%esp)
  801bc6:	e8 3f ff ff ff       	call   801b0a <read>
		if (m < 0)
  801bcb:	85 c0                	test   %eax,%eax
  801bcd:	78 10                	js     801bdf <readn+0x43>
			return m;
		if (m == 0)
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	74 0a                	je     801bdd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bd3:	01 c3                	add    %eax,%ebx
  801bd5:	39 f3                	cmp    %esi,%ebx
  801bd7:	72 d9                	jb     801bb2 <readn+0x16>
  801bd9:	89 d8                	mov    %ebx,%eax
  801bdb:	eb 02                	jmp    801bdf <readn+0x43>
  801bdd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801bdf:	83 c4 1c             	add    $0x1c,%esp
  801be2:	5b                   	pop    %ebx
  801be3:	5e                   	pop    %esi
  801be4:	5f                   	pop    %edi
  801be5:	5d                   	pop    %ebp
  801be6:	c3                   	ret    

00801be7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	53                   	push   %ebx
  801beb:	83 ec 24             	sub    $0x24,%esp
  801bee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bf1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf8:	89 1c 24             	mov    %ebx,(%esp)
  801bfb:	e8 76 fc ff ff       	call   801876 <fd_lookup>
  801c00:	89 c2                	mov    %eax,%edx
  801c02:	85 d2                	test   %edx,%edx
  801c04:	78 68                	js     801c6e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c10:	8b 00                	mov    (%eax),%eax
  801c12:	89 04 24             	mov    %eax,(%esp)
  801c15:	e8 b2 fc ff ff       	call   8018cc <dev_lookup>
  801c1a:	85 c0                	test   %eax,%eax
  801c1c:	78 50                	js     801c6e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c21:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c25:	75 23                	jne    801c4a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c27:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801c2c:	8b 40 48             	mov    0x48(%eax),%eax
  801c2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c37:	c7 04 24 41 34 80 00 	movl   $0x803441,(%esp)
  801c3e:	e8 47 e8 ff ff       	call   80048a <cprintf>
		return -E_INVAL;
  801c43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c48:	eb 24                	jmp    801c6e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c4d:	8b 52 0c             	mov    0xc(%edx),%edx
  801c50:	85 d2                	test   %edx,%edx
  801c52:	74 15                	je     801c69 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c54:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c62:	89 04 24             	mov    %eax,(%esp)
  801c65:	ff d2                	call   *%edx
  801c67:	eb 05                	jmp    801c6e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801c69:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801c6e:	83 c4 24             	add    $0x24,%esp
  801c71:	5b                   	pop    %ebx
  801c72:	5d                   	pop    %ebp
  801c73:	c3                   	ret    

00801c74 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c7a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	89 04 24             	mov    %eax,(%esp)
  801c87:	e8 ea fb ff ff       	call   801876 <fd_lookup>
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	78 0e                	js     801c9e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801c90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c96:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	53                   	push   %ebx
  801ca4:	83 ec 24             	sub    $0x24,%esp
  801ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801caa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb1:	89 1c 24             	mov    %ebx,(%esp)
  801cb4:	e8 bd fb ff ff       	call   801876 <fd_lookup>
  801cb9:	89 c2                	mov    %eax,%edx
  801cbb:	85 d2                	test   %edx,%edx
  801cbd:	78 61                	js     801d20 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cbf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc9:	8b 00                	mov    (%eax),%eax
  801ccb:	89 04 24             	mov    %eax,(%esp)
  801cce:	e8 f9 fb ff ff       	call   8018cc <dev_lookup>
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	78 49                	js     801d20 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cda:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801cde:	75 23                	jne    801d03 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801ce0:	a1 0c 50 80 00       	mov    0x80500c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ce5:	8b 40 48             	mov    0x48(%eax),%eax
  801ce8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf0:	c7 04 24 04 34 80 00 	movl   $0x803404,(%esp)
  801cf7:	e8 8e e7 ff ff       	call   80048a <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801cfc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d01:	eb 1d                	jmp    801d20 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801d03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d06:	8b 52 18             	mov    0x18(%edx),%edx
  801d09:	85 d2                	test   %edx,%edx
  801d0b:	74 0e                	je     801d1b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d10:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d14:	89 04 24             	mov    %eax,(%esp)
  801d17:	ff d2                	call   *%edx
  801d19:	eb 05                	jmp    801d20 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801d1b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801d20:	83 c4 24             	add    $0x24,%esp
  801d23:	5b                   	pop    %ebx
  801d24:	5d                   	pop    %ebp
  801d25:	c3                   	ret    

00801d26 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	53                   	push   %ebx
  801d2a:	83 ec 24             	sub    $0x24,%esp
  801d2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d30:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	89 04 24             	mov    %eax,(%esp)
  801d3d:	e8 34 fb ff ff       	call   801876 <fd_lookup>
  801d42:	89 c2                	mov    %eax,%edx
  801d44:	85 d2                	test   %edx,%edx
  801d46:	78 52                	js     801d9a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d52:	8b 00                	mov    (%eax),%eax
  801d54:	89 04 24             	mov    %eax,(%esp)
  801d57:	e8 70 fb ff ff       	call   8018cc <dev_lookup>
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	78 3a                	js     801d9a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d63:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d67:	74 2c                	je     801d95 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d69:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d6c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d73:	00 00 00 
	stat->st_isdir = 0;
  801d76:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d7d:	00 00 00 
	stat->st_dev = dev;
  801d80:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d86:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d8d:	89 14 24             	mov    %edx,(%esp)
  801d90:	ff 50 14             	call   *0x14(%eax)
  801d93:	eb 05                	jmp    801d9a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801d95:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801d9a:	83 c4 24             	add    $0x24,%esp
  801d9d:	5b                   	pop    %ebx
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    

00801da0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	56                   	push   %esi
  801da4:	53                   	push   %ebx
  801da5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801da8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801daf:	00 
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	89 04 24             	mov    %eax,(%esp)
  801db6:	e8 1b 02 00 00       	call   801fd6 <open>
  801dbb:	89 c3                	mov    %eax,%ebx
  801dbd:	85 db                	test   %ebx,%ebx
  801dbf:	78 1b                	js     801ddc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc8:	89 1c 24             	mov    %ebx,(%esp)
  801dcb:	e8 56 ff ff ff       	call   801d26 <fstat>
  801dd0:	89 c6                	mov    %eax,%esi
	close(fd);
  801dd2:	89 1c 24             	mov    %ebx,(%esp)
  801dd5:	e8 cd fb ff ff       	call   8019a7 <close>
	return r;
  801dda:	89 f0                	mov    %esi,%eax
}
  801ddc:	83 c4 10             	add    $0x10,%esp
  801ddf:	5b                   	pop    %ebx
  801de0:	5e                   	pop    %esi
  801de1:	5d                   	pop    %ebp
  801de2:	c3                   	ret    

00801de3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	56                   	push   %esi
  801de7:	53                   	push   %ebx
  801de8:	83 ec 10             	sub    $0x10,%esp
  801deb:	89 c6                	mov    %eax,%esi
  801ded:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801def:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801df6:	75 11                	jne    801e09 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801df8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801dff:	e8 bb f9 ff ff       	call   8017bf <ipc_find_env>
  801e04:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e09:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e10:	00 
  801e11:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801e18:	00 
  801e19:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e1d:	a1 04 50 80 00       	mov    0x805004,%eax
  801e22:	89 04 24             	mov    %eax,(%esp)
  801e25:	e8 2a f9 ff ff       	call   801754 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e2a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e31:	00 
  801e32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e36:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e3d:	e8 be f8 ff ff       	call   801700 <ipc_recv>
}
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	5b                   	pop    %ebx
  801e46:	5e                   	pop    %esi
  801e47:	5d                   	pop    %ebp
  801e48:	c3                   	ret    

00801e49 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e52:	8b 40 0c             	mov    0xc(%eax),%eax
  801e55:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e62:	ba 00 00 00 00       	mov    $0x0,%edx
  801e67:	b8 02 00 00 00       	mov    $0x2,%eax
  801e6c:	e8 72 ff ff ff       	call   801de3 <fsipc>
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e84:	ba 00 00 00 00       	mov    $0x0,%edx
  801e89:	b8 06 00 00 00       	mov    $0x6,%eax
  801e8e:	e8 50 ff ff ff       	call   801de3 <fsipc>
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	53                   	push   %ebx
  801e99:	83 ec 14             	sub    $0x14,%esp
  801e9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801eaa:	ba 00 00 00 00       	mov    $0x0,%edx
  801eaf:	b8 05 00 00 00       	mov    $0x5,%eax
  801eb4:	e8 2a ff ff ff       	call   801de3 <fsipc>
  801eb9:	89 c2                	mov    %eax,%edx
  801ebb:	85 d2                	test   %edx,%edx
  801ebd:	78 2b                	js     801eea <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ebf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ec6:	00 
  801ec7:	89 1c 24             	mov    %ebx,(%esp)
  801eca:	e8 e8 eb ff ff       	call   800ab7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ecf:	a1 80 60 80 00       	mov    0x806080,%eax
  801ed4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801eda:	a1 84 60 80 00       	mov    0x806084,%eax
  801edf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ee5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eea:	83 c4 14             	add    $0x14,%esp
  801eed:	5b                   	pop    %ebx
  801eee:	5d                   	pop    %ebp
  801eef:	c3                   	ret    

00801ef0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	83 ec 18             	sub    $0x18,%esp
  801ef6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  801efc:	8b 52 0c             	mov    0xc(%edx),%edx
  801eff:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801f05:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801f0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f11:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f15:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801f1c:	e8 9b ed ff ff       	call   800cbc <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801f21:	ba 00 00 00 00       	mov    $0x0,%edx
  801f26:	b8 04 00 00 00       	mov    $0x4,%eax
  801f2b:	e8 b3 fe ff ff       	call   801de3 <fsipc>
		return r;
	}

	return r;
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	56                   	push   %esi
  801f36:	53                   	push   %ebx
  801f37:	83 ec 10             	sub    $0x10,%esp
  801f3a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f40:	8b 40 0c             	mov    0xc(%eax),%eax
  801f43:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f48:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f53:	b8 03 00 00 00       	mov    $0x3,%eax
  801f58:	e8 86 fe ff ff       	call   801de3 <fsipc>
  801f5d:	89 c3                	mov    %eax,%ebx
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	78 6a                	js     801fcd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801f63:	39 c6                	cmp    %eax,%esi
  801f65:	73 24                	jae    801f8b <devfile_read+0x59>
  801f67:	c7 44 24 0c 74 34 80 	movl   $0x803474,0xc(%esp)
  801f6e:	00 
  801f6f:	c7 44 24 08 7b 34 80 	movl   $0x80347b,0x8(%esp)
  801f76:	00 
  801f77:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801f7e:	00 
  801f7f:	c7 04 24 90 34 80 00 	movl   $0x803490,(%esp)
  801f86:	e8 06 e4 ff ff       	call   800391 <_panic>
	assert(r <= PGSIZE);
  801f8b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f90:	7e 24                	jle    801fb6 <devfile_read+0x84>
  801f92:	c7 44 24 0c 9b 34 80 	movl   $0x80349b,0xc(%esp)
  801f99:	00 
  801f9a:	c7 44 24 08 7b 34 80 	movl   $0x80347b,0x8(%esp)
  801fa1:	00 
  801fa2:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801fa9:	00 
  801faa:	c7 04 24 90 34 80 00 	movl   $0x803490,(%esp)
  801fb1:	e8 db e3 ff ff       	call   800391 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801fb6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fba:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801fc1:	00 
  801fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc5:	89 04 24             	mov    %eax,(%esp)
  801fc8:	e8 87 ec ff ff       	call   800c54 <memmove>
	return r;
}
  801fcd:	89 d8                	mov    %ebx,%eax
  801fcf:	83 c4 10             	add    $0x10,%esp
  801fd2:	5b                   	pop    %ebx
  801fd3:	5e                   	pop    %esi
  801fd4:	5d                   	pop    %ebp
  801fd5:	c3                   	ret    

00801fd6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	53                   	push   %ebx
  801fda:	83 ec 24             	sub    $0x24,%esp
  801fdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801fe0:	89 1c 24             	mov    %ebx,(%esp)
  801fe3:	e8 98 ea ff ff       	call   800a80 <strlen>
  801fe8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fed:	7f 60                	jg     80204f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801fef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff2:	89 04 24             	mov    %eax,(%esp)
  801ff5:	e8 2d f8 ff ff       	call   801827 <fd_alloc>
  801ffa:	89 c2                	mov    %eax,%edx
  801ffc:	85 d2                	test   %edx,%edx
  801ffe:	78 54                	js     802054 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  802000:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802004:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  80200b:	e8 a7 ea ff ff       	call   800ab7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802010:	8b 45 0c             	mov    0xc(%ebp),%eax
  802013:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802018:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201b:	b8 01 00 00 00       	mov    $0x1,%eax
  802020:	e8 be fd ff ff       	call   801de3 <fsipc>
  802025:	89 c3                	mov    %eax,%ebx
  802027:	85 c0                	test   %eax,%eax
  802029:	79 17                	jns    802042 <open+0x6c>
		fd_close(fd, 0);
  80202b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802032:	00 
  802033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802036:	89 04 24             	mov    %eax,(%esp)
  802039:	e8 e8 f8 ff ff       	call   801926 <fd_close>
		return r;
  80203e:	89 d8                	mov    %ebx,%eax
  802040:	eb 12                	jmp    802054 <open+0x7e>
	}

	return fd2num(fd);
  802042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802045:	89 04 24             	mov    %eax,(%esp)
  802048:	e8 b3 f7 ff ff       	call   801800 <fd2num>
  80204d:	eb 05                	jmp    802054 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80204f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  802054:	83 c4 24             	add    $0x24,%esp
  802057:	5b                   	pop    %ebx
  802058:	5d                   	pop    %ebp
  802059:	c3                   	ret    

0080205a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802060:	ba 00 00 00 00       	mov    $0x0,%edx
  802065:	b8 08 00 00 00       	mov    $0x8,%eax
  80206a:	e8 74 fd ff ff       	call   801de3 <fsipc>
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    
  802071:	66 90                	xchg   %ax,%ax
  802073:	66 90                	xchg   %ax,%ax
  802075:	66 90                	xchg   %ax,%ax
  802077:	66 90                	xchg   %ax,%ax
  802079:	66 90                	xchg   %ax,%ax
  80207b:	66 90                	xchg   %ax,%ax
  80207d:	66 90                	xchg   %ax,%ax
  80207f:	90                   	nop

00802080 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802086:	c7 44 24 04 a7 34 80 	movl   $0x8034a7,0x4(%esp)
  80208d:	00 
  80208e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802091:	89 04 24             	mov    %eax,(%esp)
  802094:	e8 1e ea ff ff       	call   800ab7 <strcpy>
	return 0;
}
  802099:	b8 00 00 00 00       	mov    $0x0,%eax
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	53                   	push   %ebx
  8020a4:	83 ec 14             	sub    $0x14,%esp
  8020a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8020aa:	89 1c 24             	mov    %ebx,(%esp)
  8020ad:	e8 b1 0a 00 00       	call   802b63 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8020b2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8020b7:	83 f8 01             	cmp    $0x1,%eax
  8020ba:	75 0d                	jne    8020c9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8020bc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8020bf:	89 04 24             	mov    %eax,(%esp)
  8020c2:	e8 29 03 00 00       	call   8023f0 <nsipc_close>
  8020c7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8020c9:	89 d0                	mov    %edx,%eax
  8020cb:	83 c4 14             	add    $0x14,%esp
  8020ce:	5b                   	pop    %ebx
  8020cf:	5d                   	pop    %ebp
  8020d0:	c3                   	ret    

008020d1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020d7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020de:	00 
  8020df:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f3:	89 04 24             	mov    %eax,(%esp)
  8020f6:	e8 f0 03 00 00       	call   8024eb <nsipc_send>
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802103:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80210a:	00 
  80210b:	8b 45 10             	mov    0x10(%ebp),%eax
  80210e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802112:	8b 45 0c             	mov    0xc(%ebp),%eax
  802115:	89 44 24 04          	mov    %eax,0x4(%esp)
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	8b 40 0c             	mov    0xc(%eax),%eax
  80211f:	89 04 24             	mov    %eax,(%esp)
  802122:	e8 44 03 00 00       	call   80246b <nsipc_recv>
}
  802127:	c9                   	leave  
  802128:	c3                   	ret    

00802129 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80212f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802132:	89 54 24 04          	mov    %edx,0x4(%esp)
  802136:	89 04 24             	mov    %eax,(%esp)
  802139:	e8 38 f7 ff ff       	call   801876 <fd_lookup>
  80213e:	85 c0                	test   %eax,%eax
  802140:	78 17                	js     802159 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802145:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80214b:	39 08                	cmp    %ecx,(%eax)
  80214d:	75 05                	jne    802154 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80214f:	8b 40 0c             	mov    0xc(%eax),%eax
  802152:	eb 05                	jmp    802159 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802154:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	56                   	push   %esi
  80215f:	53                   	push   %ebx
  802160:	83 ec 20             	sub    $0x20,%esp
  802163:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802165:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802168:	89 04 24             	mov    %eax,(%esp)
  80216b:	e8 b7 f6 ff ff       	call   801827 <fd_alloc>
  802170:	89 c3                	mov    %eax,%ebx
  802172:	85 c0                	test   %eax,%eax
  802174:	78 21                	js     802197 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802176:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80217d:	00 
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	89 44 24 04          	mov    %eax,0x4(%esp)
  802185:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80218c:	e8 42 ed ff ff       	call   800ed3 <sys_page_alloc>
  802191:	89 c3                	mov    %eax,%ebx
  802193:	85 c0                	test   %eax,%eax
  802195:	79 0c                	jns    8021a3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802197:	89 34 24             	mov    %esi,(%esp)
  80219a:	e8 51 02 00 00       	call   8023f0 <nsipc_close>
		return r;
  80219f:	89 d8                	mov    %ebx,%eax
  8021a1:	eb 20                	jmp    8021c3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8021a3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8021a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ac:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8021ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8021b8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8021bb:	89 14 24             	mov    %edx,(%esp)
  8021be:	e8 3d f6 ff ff       	call   801800 <fd2num>
}
  8021c3:	83 c4 20             	add    $0x20,%esp
  8021c6:	5b                   	pop    %ebx
  8021c7:	5e                   	pop    %esi
  8021c8:	5d                   	pop    %ebp
  8021c9:	c3                   	ret    

008021ca <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	e8 51 ff ff ff       	call   802129 <fd2sockid>
		return r;
  8021d8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	78 23                	js     802201 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021de:	8b 55 10             	mov    0x10(%ebp),%edx
  8021e1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021ec:	89 04 24             	mov    %eax,(%esp)
  8021ef:	e8 45 01 00 00       	call   802339 <nsipc_accept>
		return r;
  8021f4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	78 07                	js     802201 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8021fa:	e8 5c ff ff ff       	call   80215b <alloc_sockfd>
  8021ff:	89 c1                	mov    %eax,%ecx
}
  802201:	89 c8                	mov    %ecx,%eax
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	e8 16 ff ff ff       	call   802129 <fd2sockid>
  802213:	89 c2                	mov    %eax,%edx
  802215:	85 d2                	test   %edx,%edx
  802217:	78 16                	js     80222f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802219:	8b 45 10             	mov    0x10(%ebp),%eax
  80221c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802220:	8b 45 0c             	mov    0xc(%ebp),%eax
  802223:	89 44 24 04          	mov    %eax,0x4(%esp)
  802227:	89 14 24             	mov    %edx,(%esp)
  80222a:	e8 60 01 00 00       	call   80238f <nsipc_bind>
}
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <shutdown>:

int
shutdown(int s, int how)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
  802234:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	e8 ea fe ff ff       	call   802129 <fd2sockid>
  80223f:	89 c2                	mov    %eax,%edx
  802241:	85 d2                	test   %edx,%edx
  802243:	78 0f                	js     802254 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802245:	8b 45 0c             	mov    0xc(%ebp),%eax
  802248:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224c:	89 14 24             	mov    %edx,(%esp)
  80224f:	e8 7a 01 00 00       	call   8023ce <nsipc_shutdown>
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	e8 c5 fe ff ff       	call   802129 <fd2sockid>
  802264:	89 c2                	mov    %eax,%edx
  802266:	85 d2                	test   %edx,%edx
  802268:	78 16                	js     802280 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80226a:	8b 45 10             	mov    0x10(%ebp),%eax
  80226d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802271:	8b 45 0c             	mov    0xc(%ebp),%eax
  802274:	89 44 24 04          	mov    %eax,0x4(%esp)
  802278:	89 14 24             	mov    %edx,(%esp)
  80227b:	e8 8a 01 00 00       	call   80240a <nsipc_connect>
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <listen>:

int
listen(int s, int backlog)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	e8 99 fe ff ff       	call   802129 <fd2sockid>
  802290:	89 c2                	mov    %eax,%edx
  802292:	85 d2                	test   %edx,%edx
  802294:	78 0f                	js     8022a5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802296:	8b 45 0c             	mov    0xc(%ebp),%eax
  802299:	89 44 24 04          	mov    %eax,0x4(%esp)
  80229d:	89 14 24             	mov    %edx,(%esp)
  8022a0:	e8 a4 01 00 00       	call   802449 <nsipc_listen>
}
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    

008022a7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
  8022aa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8022ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	89 04 24             	mov    %eax,(%esp)
  8022c1:	e8 98 02 00 00       	call   80255e <nsipc_socket>
  8022c6:	89 c2                	mov    %eax,%edx
  8022c8:	85 d2                	test   %edx,%edx
  8022ca:	78 05                	js     8022d1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8022cc:	e8 8a fe ff ff       	call   80215b <alloc_sockfd>
}
  8022d1:	c9                   	leave  
  8022d2:	c3                   	ret    

008022d3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	53                   	push   %ebx
  8022d7:	83 ec 14             	sub    $0x14,%esp
  8022da:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8022dc:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  8022e3:	75 11                	jne    8022f6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022e5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8022ec:	e8 ce f4 ff ff       	call   8017bf <ipc_find_env>
  8022f1:	a3 08 50 80 00       	mov    %eax,0x805008
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022f6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8022fd:	00 
  8022fe:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802305:	00 
  802306:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80230a:	a1 08 50 80 00       	mov    0x805008,%eax
  80230f:	89 04 24             	mov    %eax,(%esp)
  802312:	e8 3d f4 ff ff       	call   801754 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802317:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80231e:	00 
  80231f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802326:	00 
  802327:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80232e:	e8 cd f3 ff ff       	call   801700 <ipc_recv>
}
  802333:	83 c4 14             	add    $0x14,%esp
  802336:	5b                   	pop    %ebx
  802337:	5d                   	pop    %ebp
  802338:	c3                   	ret    

00802339 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
  80233c:	56                   	push   %esi
  80233d:	53                   	push   %ebx
  80233e:	83 ec 10             	sub    $0x10,%esp
  802341:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80234c:	8b 06                	mov    (%esi),%eax
  80234e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802353:	b8 01 00 00 00       	mov    $0x1,%eax
  802358:	e8 76 ff ff ff       	call   8022d3 <nsipc>
  80235d:	89 c3                	mov    %eax,%ebx
  80235f:	85 c0                	test   %eax,%eax
  802361:	78 23                	js     802386 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802363:	a1 10 70 80 00       	mov    0x807010,%eax
  802368:	89 44 24 08          	mov    %eax,0x8(%esp)
  80236c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802373:	00 
  802374:	8b 45 0c             	mov    0xc(%ebp),%eax
  802377:	89 04 24             	mov    %eax,(%esp)
  80237a:	e8 d5 e8 ff ff       	call   800c54 <memmove>
		*addrlen = ret->ret_addrlen;
  80237f:	a1 10 70 80 00       	mov    0x807010,%eax
  802384:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802386:	89 d8                	mov    %ebx,%eax
  802388:	83 c4 10             	add    $0x10,%esp
  80238b:	5b                   	pop    %ebx
  80238c:	5e                   	pop    %esi
  80238d:	5d                   	pop    %ebp
  80238e:	c3                   	ret    

0080238f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	53                   	push   %ebx
  802393:	83 ec 14             	sub    $0x14,%esp
  802396:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8023a1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ac:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8023b3:	e8 9c e8 ff ff       	call   800c54 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8023b8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8023be:	b8 02 00 00 00       	mov    $0x2,%eax
  8023c3:	e8 0b ff ff ff       	call   8022d3 <nsipc>
}
  8023c8:	83 c4 14             	add    $0x14,%esp
  8023cb:	5b                   	pop    %ebx
  8023cc:	5d                   	pop    %ebp
  8023cd:	c3                   	ret    

008023ce <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
  8023d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8023d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8023dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023df:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8023e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8023e9:	e8 e5 fe ff ff       	call   8022d3 <nsipc>
}
  8023ee:	c9                   	leave  
  8023ef:	c3                   	ret    

008023f0 <nsipc_close>:

int
nsipc_close(int s)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
  8023f3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8023fe:	b8 04 00 00 00       	mov    $0x4,%eax
  802403:	e8 cb fe ff ff       	call   8022d3 <nsipc>
}
  802408:	c9                   	leave  
  802409:	c3                   	ret    

0080240a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
  80240d:	53                   	push   %ebx
  80240e:	83 ec 14             	sub    $0x14,%esp
  802411:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80241c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802420:	8b 45 0c             	mov    0xc(%ebp),%eax
  802423:	89 44 24 04          	mov    %eax,0x4(%esp)
  802427:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80242e:	e8 21 e8 ff ff       	call   800c54 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802433:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802439:	b8 05 00 00 00       	mov    $0x5,%eax
  80243e:	e8 90 fe ff ff       	call   8022d3 <nsipc>
}
  802443:	83 c4 14             	add    $0x14,%esp
  802446:	5b                   	pop    %ebx
  802447:	5d                   	pop    %ebp
  802448:	c3                   	ret    

00802449 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
  80244c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
  802452:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80245f:	b8 06 00 00 00       	mov    $0x6,%eax
  802464:	e8 6a fe ff ff       	call   8022d3 <nsipc>
}
  802469:	c9                   	leave  
  80246a:	c3                   	ret    

0080246b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
  80246e:	56                   	push   %esi
  80246f:	53                   	push   %ebx
  802470:	83 ec 10             	sub    $0x10,%esp
  802473:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80247e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802484:	8b 45 14             	mov    0x14(%ebp),%eax
  802487:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80248c:	b8 07 00 00 00       	mov    $0x7,%eax
  802491:	e8 3d fe ff ff       	call   8022d3 <nsipc>
  802496:	89 c3                	mov    %eax,%ebx
  802498:	85 c0                	test   %eax,%eax
  80249a:	78 46                	js     8024e2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80249c:	39 f0                	cmp    %esi,%eax
  80249e:	7f 07                	jg     8024a7 <nsipc_recv+0x3c>
  8024a0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8024a5:	7e 24                	jle    8024cb <nsipc_recv+0x60>
  8024a7:	c7 44 24 0c b3 34 80 	movl   $0x8034b3,0xc(%esp)
  8024ae:	00 
  8024af:	c7 44 24 08 7b 34 80 	movl   $0x80347b,0x8(%esp)
  8024b6:	00 
  8024b7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8024be:	00 
  8024bf:	c7 04 24 c8 34 80 00 	movl   $0x8034c8,(%esp)
  8024c6:	e8 c6 de ff ff       	call   800391 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8024cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024cf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8024d6:	00 
  8024d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024da:	89 04 24             	mov    %eax,(%esp)
  8024dd:	e8 72 e7 ff ff       	call   800c54 <memmove>
	}

	return r;
}
  8024e2:	89 d8                	mov    %ebx,%eax
  8024e4:	83 c4 10             	add    $0x10,%esp
  8024e7:	5b                   	pop    %ebx
  8024e8:	5e                   	pop    %esi
  8024e9:	5d                   	pop    %ebp
  8024ea:	c3                   	ret    

008024eb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	53                   	push   %ebx
  8024ef:	83 ec 14             	sub    $0x14,%esp
  8024f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8024f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8024fd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802503:	7e 24                	jle    802529 <nsipc_send+0x3e>
  802505:	c7 44 24 0c d4 34 80 	movl   $0x8034d4,0xc(%esp)
  80250c:	00 
  80250d:	c7 44 24 08 7b 34 80 	movl   $0x80347b,0x8(%esp)
  802514:	00 
  802515:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80251c:	00 
  80251d:	c7 04 24 c8 34 80 00 	movl   $0x8034c8,(%esp)
  802524:	e8 68 de ff ff       	call   800391 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802529:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80252d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802530:	89 44 24 04          	mov    %eax,0x4(%esp)
  802534:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80253b:	e8 14 e7 ff ff       	call   800c54 <memmove>
	nsipcbuf.send.req_size = size;
  802540:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802546:	8b 45 14             	mov    0x14(%ebp),%eax
  802549:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80254e:	b8 08 00 00 00       	mov    $0x8,%eax
  802553:	e8 7b fd ff ff       	call   8022d3 <nsipc>
}
  802558:	83 c4 14             	add    $0x14,%esp
  80255b:	5b                   	pop    %ebx
  80255c:	5d                   	pop    %ebp
  80255d:	c3                   	ret    

0080255e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80255e:	55                   	push   %ebp
  80255f:	89 e5                	mov    %esp,%ebp
  802561:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80256c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802574:	8b 45 10             	mov    0x10(%ebp),%eax
  802577:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80257c:	b8 09 00 00 00       	mov    $0x9,%eax
  802581:	e8 4d fd ff ff       	call   8022d3 <nsipc>
}
  802586:	c9                   	leave  
  802587:	c3                   	ret    

00802588 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802588:	55                   	push   %ebp
  802589:	89 e5                	mov    %esp,%ebp
  80258b:	56                   	push   %esi
  80258c:	53                   	push   %ebx
  80258d:	83 ec 10             	sub    $0x10,%esp
  802590:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	89 04 24             	mov    %eax,(%esp)
  802599:	e8 72 f2 ff ff       	call   801810 <fd2data>
  80259e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8025a0:	c7 44 24 04 e0 34 80 	movl   $0x8034e0,0x4(%esp)
  8025a7:	00 
  8025a8:	89 1c 24             	mov    %ebx,(%esp)
  8025ab:	e8 07 e5 ff ff       	call   800ab7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8025b0:	8b 46 04             	mov    0x4(%esi),%eax
  8025b3:	2b 06                	sub    (%esi),%eax
  8025b5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8025bb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8025c2:	00 00 00 
	stat->st_dev = &devpipe;
  8025c5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8025cc:	40 80 00 
	return 0;
}
  8025cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d4:	83 c4 10             	add    $0x10,%esp
  8025d7:	5b                   	pop    %ebx
  8025d8:	5e                   	pop    %esi
  8025d9:	5d                   	pop    %ebp
  8025da:	c3                   	ret    

008025db <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
  8025de:	53                   	push   %ebx
  8025df:	83 ec 14             	sub    $0x14,%esp
  8025e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8025e5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025f0:	e8 85 e9 ff ff       	call   800f7a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8025f5:	89 1c 24             	mov    %ebx,(%esp)
  8025f8:	e8 13 f2 ff ff       	call   801810 <fd2data>
  8025fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802601:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802608:	e8 6d e9 ff ff       	call   800f7a <sys_page_unmap>
}
  80260d:	83 c4 14             	add    $0x14,%esp
  802610:	5b                   	pop    %ebx
  802611:	5d                   	pop    %ebp
  802612:	c3                   	ret    

00802613 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
  802616:	57                   	push   %edi
  802617:	56                   	push   %esi
  802618:	53                   	push   %ebx
  802619:	83 ec 2c             	sub    $0x2c,%esp
  80261c:	89 c6                	mov    %eax,%esi
  80261e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802621:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802626:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802629:	89 34 24             	mov    %esi,(%esp)
  80262c:	e8 32 05 00 00       	call   802b63 <pageref>
  802631:	89 c7                	mov    %eax,%edi
  802633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802636:	89 04 24             	mov    %eax,(%esp)
  802639:	e8 25 05 00 00       	call   802b63 <pageref>
  80263e:	39 c7                	cmp    %eax,%edi
  802640:	0f 94 c2             	sete   %dl
  802643:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802646:	8b 0d 0c 50 80 00    	mov    0x80500c,%ecx
  80264c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80264f:	39 fb                	cmp    %edi,%ebx
  802651:	74 21                	je     802674 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802653:	84 d2                	test   %dl,%dl
  802655:	74 ca                	je     802621 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802657:	8b 51 58             	mov    0x58(%ecx),%edx
  80265a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80265e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802662:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802666:	c7 04 24 e7 34 80 00 	movl   $0x8034e7,(%esp)
  80266d:	e8 18 de ff ff       	call   80048a <cprintf>
  802672:	eb ad                	jmp    802621 <_pipeisclosed+0xe>
	}
}
  802674:	83 c4 2c             	add    $0x2c,%esp
  802677:	5b                   	pop    %ebx
  802678:	5e                   	pop    %esi
  802679:	5f                   	pop    %edi
  80267a:	5d                   	pop    %ebp
  80267b:	c3                   	ret    

0080267c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	57                   	push   %edi
  802680:	56                   	push   %esi
  802681:	53                   	push   %ebx
  802682:	83 ec 1c             	sub    $0x1c,%esp
  802685:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802688:	89 34 24             	mov    %esi,(%esp)
  80268b:	e8 80 f1 ff ff       	call   801810 <fd2data>
  802690:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802692:	bf 00 00 00 00       	mov    $0x0,%edi
  802697:	eb 45                	jmp    8026de <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802699:	89 da                	mov    %ebx,%edx
  80269b:	89 f0                	mov    %esi,%eax
  80269d:	e8 71 ff ff ff       	call   802613 <_pipeisclosed>
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	75 41                	jne    8026e7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8026a6:	e8 09 e8 ff ff       	call   800eb4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8026ab:	8b 43 04             	mov    0x4(%ebx),%eax
  8026ae:	8b 0b                	mov    (%ebx),%ecx
  8026b0:	8d 51 20             	lea    0x20(%ecx),%edx
  8026b3:	39 d0                	cmp    %edx,%eax
  8026b5:	73 e2                	jae    802699 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8026b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026ba:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8026be:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8026c1:	99                   	cltd   
  8026c2:	c1 ea 1b             	shr    $0x1b,%edx
  8026c5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8026c8:	83 e1 1f             	and    $0x1f,%ecx
  8026cb:	29 d1                	sub    %edx,%ecx
  8026cd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8026d1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8026d5:	83 c0 01             	add    $0x1,%eax
  8026d8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026db:	83 c7 01             	add    $0x1,%edi
  8026de:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8026e1:	75 c8                	jne    8026ab <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8026e3:	89 f8                	mov    %edi,%eax
  8026e5:	eb 05                	jmp    8026ec <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8026e7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8026ec:	83 c4 1c             	add    $0x1c,%esp
  8026ef:	5b                   	pop    %ebx
  8026f0:	5e                   	pop    %esi
  8026f1:	5f                   	pop    %edi
  8026f2:	5d                   	pop    %ebp
  8026f3:	c3                   	ret    

008026f4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026f4:	55                   	push   %ebp
  8026f5:	89 e5                	mov    %esp,%ebp
  8026f7:	57                   	push   %edi
  8026f8:	56                   	push   %esi
  8026f9:	53                   	push   %ebx
  8026fa:	83 ec 1c             	sub    $0x1c,%esp
  8026fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802700:	89 3c 24             	mov    %edi,(%esp)
  802703:	e8 08 f1 ff ff       	call   801810 <fd2data>
  802708:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80270a:	be 00 00 00 00       	mov    $0x0,%esi
  80270f:	eb 3d                	jmp    80274e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802711:	85 f6                	test   %esi,%esi
  802713:	74 04                	je     802719 <devpipe_read+0x25>
				return i;
  802715:	89 f0                	mov    %esi,%eax
  802717:	eb 43                	jmp    80275c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802719:	89 da                	mov    %ebx,%edx
  80271b:	89 f8                	mov    %edi,%eax
  80271d:	e8 f1 fe ff ff       	call   802613 <_pipeisclosed>
  802722:	85 c0                	test   %eax,%eax
  802724:	75 31                	jne    802757 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802726:	e8 89 e7 ff ff       	call   800eb4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80272b:	8b 03                	mov    (%ebx),%eax
  80272d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802730:	74 df                	je     802711 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802732:	99                   	cltd   
  802733:	c1 ea 1b             	shr    $0x1b,%edx
  802736:	01 d0                	add    %edx,%eax
  802738:	83 e0 1f             	and    $0x1f,%eax
  80273b:	29 d0                	sub    %edx,%eax
  80273d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802742:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802745:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802748:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80274b:	83 c6 01             	add    $0x1,%esi
  80274e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802751:	75 d8                	jne    80272b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802753:	89 f0                	mov    %esi,%eax
  802755:	eb 05                	jmp    80275c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802757:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80275c:	83 c4 1c             	add    $0x1c,%esp
  80275f:	5b                   	pop    %ebx
  802760:	5e                   	pop    %esi
  802761:	5f                   	pop    %edi
  802762:	5d                   	pop    %ebp
  802763:	c3                   	ret    

00802764 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802764:	55                   	push   %ebp
  802765:	89 e5                	mov    %esp,%ebp
  802767:	56                   	push   %esi
  802768:	53                   	push   %ebx
  802769:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80276c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80276f:	89 04 24             	mov    %eax,(%esp)
  802772:	e8 b0 f0 ff ff       	call   801827 <fd_alloc>
  802777:	89 c2                	mov    %eax,%edx
  802779:	85 d2                	test   %edx,%edx
  80277b:	0f 88 4d 01 00 00    	js     8028ce <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802781:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802788:	00 
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802790:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802797:	e8 37 e7 ff ff       	call   800ed3 <sys_page_alloc>
  80279c:	89 c2                	mov    %eax,%edx
  80279e:	85 d2                	test   %edx,%edx
  8027a0:	0f 88 28 01 00 00    	js     8028ce <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8027a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8027a9:	89 04 24             	mov    %eax,(%esp)
  8027ac:	e8 76 f0 ff ff       	call   801827 <fd_alloc>
  8027b1:	89 c3                	mov    %eax,%ebx
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	0f 88 fe 00 00 00    	js     8028b9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027bb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027c2:	00 
  8027c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d1:	e8 fd e6 ff ff       	call   800ed3 <sys_page_alloc>
  8027d6:	89 c3                	mov    %eax,%ebx
  8027d8:	85 c0                	test   %eax,%eax
  8027da:	0f 88 d9 00 00 00    	js     8028b9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	89 04 24             	mov    %eax,(%esp)
  8027e6:	e8 25 f0 ff ff       	call   801810 <fd2data>
  8027eb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027ed:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027f4:	00 
  8027f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802800:	e8 ce e6 ff ff       	call   800ed3 <sys_page_alloc>
  802805:	89 c3                	mov    %eax,%ebx
  802807:	85 c0                	test   %eax,%eax
  802809:	0f 88 97 00 00 00    	js     8028a6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80280f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802812:	89 04 24             	mov    %eax,(%esp)
  802815:	e8 f6 ef ff ff       	call   801810 <fd2data>
  80281a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802821:	00 
  802822:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802826:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80282d:	00 
  80282e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802832:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802839:	e8 e9 e6 ff ff       	call   800f27 <sys_page_map>
  80283e:	89 c3                	mov    %eax,%ebx
  802840:	85 c0                	test   %eax,%eax
  802842:	78 52                	js     802896 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802844:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802859:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80285f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802862:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802867:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	89 04 24             	mov    %eax,(%esp)
  802874:	e8 87 ef ff ff       	call   801800 <fd2num>
  802879:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80287c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80287e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802881:	89 04 24             	mov    %eax,(%esp)
  802884:	e8 77 ef ff ff       	call   801800 <fd2num>
  802889:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80288c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80288f:	b8 00 00 00 00       	mov    $0x0,%eax
  802894:	eb 38                	jmp    8028ce <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802896:	89 74 24 04          	mov    %esi,0x4(%esp)
  80289a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028a1:	e8 d4 e6 ff ff       	call   800f7a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8028a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028b4:	e8 c1 e6 ff ff       	call   800f7a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028c7:	e8 ae e6 ff ff       	call   800f7a <sys_page_unmap>
  8028cc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8028ce:	83 c4 30             	add    $0x30,%esp
  8028d1:	5b                   	pop    %ebx
  8028d2:	5e                   	pop    %esi
  8028d3:	5d                   	pop    %ebp
  8028d4:	c3                   	ret    

008028d5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8028d5:	55                   	push   %ebp
  8028d6:	89 e5                	mov    %esp,%ebp
  8028d8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e5:	89 04 24             	mov    %eax,(%esp)
  8028e8:	e8 89 ef ff ff       	call   801876 <fd_lookup>
  8028ed:	89 c2                	mov    %eax,%edx
  8028ef:	85 d2                	test   %edx,%edx
  8028f1:	78 15                	js     802908 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	89 04 24             	mov    %eax,(%esp)
  8028f9:	e8 12 ef ff ff       	call   801810 <fd2data>
	return _pipeisclosed(fd, p);
  8028fe:	89 c2                	mov    %eax,%edx
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	e8 0b fd ff ff       	call   802613 <_pipeisclosed>
}
  802908:	c9                   	leave  
  802909:	c3                   	ret    
  80290a:	66 90                	xchg   %ax,%ax
  80290c:	66 90                	xchg   %ax,%ax
  80290e:	66 90                	xchg   %ax,%ax

00802910 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802910:	55                   	push   %ebp
  802911:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802913:	b8 00 00 00 00       	mov    $0x0,%eax
  802918:	5d                   	pop    %ebp
  802919:	c3                   	ret    

0080291a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80291a:	55                   	push   %ebp
  80291b:	89 e5                	mov    %esp,%ebp
  80291d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802920:	c7 44 24 04 ff 34 80 	movl   $0x8034ff,0x4(%esp)
  802927:	00 
  802928:	8b 45 0c             	mov    0xc(%ebp),%eax
  80292b:	89 04 24             	mov    %eax,(%esp)
  80292e:	e8 84 e1 ff ff       	call   800ab7 <strcpy>
	return 0;
}
  802933:	b8 00 00 00 00       	mov    $0x0,%eax
  802938:	c9                   	leave  
  802939:	c3                   	ret    

0080293a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
  80293d:	57                   	push   %edi
  80293e:	56                   	push   %esi
  80293f:	53                   	push   %ebx
  802940:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802946:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80294b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802951:	eb 31                	jmp    802984 <devcons_write+0x4a>
		m = n - tot;
  802953:	8b 75 10             	mov    0x10(%ebp),%esi
  802956:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802958:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80295b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802960:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802963:	89 74 24 08          	mov    %esi,0x8(%esp)
  802967:	03 45 0c             	add    0xc(%ebp),%eax
  80296a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80296e:	89 3c 24             	mov    %edi,(%esp)
  802971:	e8 de e2 ff ff       	call   800c54 <memmove>
		sys_cputs(buf, m);
  802976:	89 74 24 04          	mov    %esi,0x4(%esp)
  80297a:	89 3c 24             	mov    %edi,(%esp)
  80297d:	e8 84 e4 ff ff       	call   800e06 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802982:	01 f3                	add    %esi,%ebx
  802984:	89 d8                	mov    %ebx,%eax
  802986:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802989:	72 c8                	jb     802953 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80298b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802991:	5b                   	pop    %ebx
  802992:	5e                   	pop    %esi
  802993:	5f                   	pop    %edi
  802994:	5d                   	pop    %ebp
  802995:	c3                   	ret    

00802996 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802996:	55                   	push   %ebp
  802997:	89 e5                	mov    %esp,%ebp
  802999:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80299c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8029a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029a5:	75 07                	jne    8029ae <devcons_read+0x18>
  8029a7:	eb 2a                	jmp    8029d3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8029a9:	e8 06 e5 ff ff       	call   800eb4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8029ae:	66 90                	xchg   %ax,%ax
  8029b0:	e8 6f e4 ff ff       	call   800e24 <sys_cgetc>
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	74 f0                	je     8029a9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	78 16                	js     8029d3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8029bd:	83 f8 04             	cmp    $0x4,%eax
  8029c0:	74 0c                	je     8029ce <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8029c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c5:	88 02                	mov    %al,(%edx)
	return 1;
  8029c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8029cc:	eb 05                	jmp    8029d3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8029ce:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8029d3:	c9                   	leave  
  8029d4:	c3                   	ret    

008029d5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8029d5:	55                   	push   %ebp
  8029d6:	89 e5                	mov    %esp,%ebp
  8029d8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8029db:	8b 45 08             	mov    0x8(%ebp),%eax
  8029de:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8029e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8029e8:	00 
  8029e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029ec:	89 04 24             	mov    %eax,(%esp)
  8029ef:	e8 12 e4 ff ff       	call   800e06 <sys_cputs>
}
  8029f4:	c9                   	leave  
  8029f5:	c3                   	ret    

008029f6 <getchar>:

int
getchar(void)
{
  8029f6:	55                   	push   %ebp
  8029f7:	89 e5                	mov    %esp,%ebp
  8029f9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8029fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802a03:	00 
  802a04:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a07:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a12:	e8 f3 f0 ff ff       	call   801b0a <read>
	if (r < 0)
  802a17:	85 c0                	test   %eax,%eax
  802a19:	78 0f                	js     802a2a <getchar+0x34>
		return r;
	if (r < 1)
  802a1b:	85 c0                	test   %eax,%eax
  802a1d:	7e 06                	jle    802a25 <getchar+0x2f>
		return -E_EOF;
	return c;
  802a1f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802a23:	eb 05                	jmp    802a2a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802a25:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802a2a:	c9                   	leave  
  802a2b:	c3                   	ret    

00802a2c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a2c:	55                   	push   %ebp
  802a2d:	89 e5                	mov    %esp,%ebp
  802a2f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a32:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a35:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	89 04 24             	mov    %eax,(%esp)
  802a3f:	e8 32 ee ff ff       	call   801876 <fd_lookup>
  802a44:	85 c0                	test   %eax,%eax
  802a46:	78 11                	js     802a59 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a51:	39 10                	cmp    %edx,(%eax)
  802a53:	0f 94 c0             	sete   %al
  802a56:	0f b6 c0             	movzbl %al,%eax
}
  802a59:	c9                   	leave  
  802a5a:	c3                   	ret    

00802a5b <opencons>:

int
opencons(void)
{
  802a5b:	55                   	push   %ebp
  802a5c:	89 e5                	mov    %esp,%ebp
  802a5e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a61:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a64:	89 04 24             	mov    %eax,(%esp)
  802a67:	e8 bb ed ff ff       	call   801827 <fd_alloc>
		return r;
  802a6c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a6e:	85 c0                	test   %eax,%eax
  802a70:	78 40                	js     802ab2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a72:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a79:	00 
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a88:	e8 46 e4 ff ff       	call   800ed3 <sys_page_alloc>
		return r;
  802a8d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a8f:	85 c0                	test   %eax,%eax
  802a91:	78 1f                	js     802ab2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a93:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802aa8:	89 04 24             	mov    %eax,(%esp)
  802aab:	e8 50 ed ff ff       	call   801800 <fd2num>
  802ab0:	89 c2                	mov    %eax,%edx
}
  802ab2:	89 d0                	mov    %edx,%eax
  802ab4:	c9                   	leave  
  802ab5:	c3                   	ret    

00802ab6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802ab6:	55                   	push   %ebp
  802ab7:	89 e5                	mov    %esp,%ebp
  802ab9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802abc:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802ac3:	75 70                	jne    802b35 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  802ac5:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  802acc:	00 
  802acd:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802ad4:	ee 
  802ad5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802adc:	e8 f2 e3 ff ff       	call   800ed3 <sys_page_alloc>
		if (error < 0)
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	79 1c                	jns    802b01 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  802ae5:	c7 44 24 08 0c 35 80 	movl   $0x80350c,0x8(%esp)
  802aec:	00 
  802aed:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802af4:	00 
  802af5:	c7 04 24 60 35 80 00 	movl   $0x803560,(%esp)
  802afc:	e8 90 d8 ff ff       	call   800391 <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802b01:	c7 44 24 04 3f 2b 80 	movl   $0x802b3f,0x4(%esp)
  802b08:	00 
  802b09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b10:	e8 5e e5 ff ff       	call   801073 <sys_env_set_pgfault_upcall>
		if (error < 0)
  802b15:	85 c0                	test   %eax,%eax
  802b17:	79 1c                	jns    802b35 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  802b19:	c7 44 24 08 34 35 80 	movl   $0x803534,0x8(%esp)
  802b20:	00 
  802b21:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802b28:	00 
  802b29:	c7 04 24 60 35 80 00 	movl   $0x803560,(%esp)
  802b30:	e8 5c d8 ff ff       	call   800391 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802b3d:	c9                   	leave  
  802b3e:	c3                   	ret    

00802b3f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802b3f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802b40:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802b45:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802b47:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  802b4a:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  802b4e:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802b53:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  802b57:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  802b59:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802b5c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802b5d:	83 c4 04             	add    $0x4,%esp
	popfl
  802b60:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802b61:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802b62:	c3                   	ret    

00802b63 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b63:	55                   	push   %ebp
  802b64:	89 e5                	mov    %esp,%ebp
  802b66:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b69:	89 d0                	mov    %edx,%eax
  802b6b:	c1 e8 16             	shr    $0x16,%eax
  802b6e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b75:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b7a:	f6 c1 01             	test   $0x1,%cl
  802b7d:	74 1d                	je     802b9c <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b7f:	c1 ea 0c             	shr    $0xc,%edx
  802b82:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b89:	f6 c2 01             	test   $0x1,%dl
  802b8c:	74 0e                	je     802b9c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b8e:	c1 ea 0c             	shr    $0xc,%edx
  802b91:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b98:	ef 
  802b99:	0f b7 c0             	movzwl %ax,%eax
}
  802b9c:	5d                   	pop    %ebp
  802b9d:	c3                   	ret    
  802b9e:	66 90                	xchg   %ax,%ax

00802ba0 <__udivdi3>:
  802ba0:	55                   	push   %ebp
  802ba1:	57                   	push   %edi
  802ba2:	56                   	push   %esi
  802ba3:	83 ec 0c             	sub    $0xc,%esp
  802ba6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802baa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802bae:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802bb2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802bbc:	89 ea                	mov    %ebp,%edx
  802bbe:	89 0c 24             	mov    %ecx,(%esp)
  802bc1:	75 2d                	jne    802bf0 <__udivdi3+0x50>
  802bc3:	39 e9                	cmp    %ebp,%ecx
  802bc5:	77 61                	ja     802c28 <__udivdi3+0x88>
  802bc7:	85 c9                	test   %ecx,%ecx
  802bc9:	89 ce                	mov    %ecx,%esi
  802bcb:	75 0b                	jne    802bd8 <__udivdi3+0x38>
  802bcd:	b8 01 00 00 00       	mov    $0x1,%eax
  802bd2:	31 d2                	xor    %edx,%edx
  802bd4:	f7 f1                	div    %ecx
  802bd6:	89 c6                	mov    %eax,%esi
  802bd8:	31 d2                	xor    %edx,%edx
  802bda:	89 e8                	mov    %ebp,%eax
  802bdc:	f7 f6                	div    %esi
  802bde:	89 c5                	mov    %eax,%ebp
  802be0:	89 f8                	mov    %edi,%eax
  802be2:	f7 f6                	div    %esi
  802be4:	89 ea                	mov    %ebp,%edx
  802be6:	83 c4 0c             	add    $0xc,%esp
  802be9:	5e                   	pop    %esi
  802bea:	5f                   	pop    %edi
  802beb:	5d                   	pop    %ebp
  802bec:	c3                   	ret    
  802bed:	8d 76 00             	lea    0x0(%esi),%esi
  802bf0:	39 e8                	cmp    %ebp,%eax
  802bf2:	77 24                	ja     802c18 <__udivdi3+0x78>
  802bf4:	0f bd e8             	bsr    %eax,%ebp
  802bf7:	83 f5 1f             	xor    $0x1f,%ebp
  802bfa:	75 3c                	jne    802c38 <__udivdi3+0x98>
  802bfc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802c00:	39 34 24             	cmp    %esi,(%esp)
  802c03:	0f 86 9f 00 00 00    	jbe    802ca8 <__udivdi3+0x108>
  802c09:	39 d0                	cmp    %edx,%eax
  802c0b:	0f 82 97 00 00 00    	jb     802ca8 <__udivdi3+0x108>
  802c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c18:	31 d2                	xor    %edx,%edx
  802c1a:	31 c0                	xor    %eax,%eax
  802c1c:	83 c4 0c             	add    $0xc,%esp
  802c1f:	5e                   	pop    %esi
  802c20:	5f                   	pop    %edi
  802c21:	5d                   	pop    %ebp
  802c22:	c3                   	ret    
  802c23:	90                   	nop
  802c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c28:	89 f8                	mov    %edi,%eax
  802c2a:	f7 f1                	div    %ecx
  802c2c:	31 d2                	xor    %edx,%edx
  802c2e:	83 c4 0c             	add    $0xc,%esp
  802c31:	5e                   	pop    %esi
  802c32:	5f                   	pop    %edi
  802c33:	5d                   	pop    %ebp
  802c34:	c3                   	ret    
  802c35:	8d 76 00             	lea    0x0(%esi),%esi
  802c38:	89 e9                	mov    %ebp,%ecx
  802c3a:	8b 3c 24             	mov    (%esp),%edi
  802c3d:	d3 e0                	shl    %cl,%eax
  802c3f:	89 c6                	mov    %eax,%esi
  802c41:	b8 20 00 00 00       	mov    $0x20,%eax
  802c46:	29 e8                	sub    %ebp,%eax
  802c48:	89 c1                	mov    %eax,%ecx
  802c4a:	d3 ef                	shr    %cl,%edi
  802c4c:	89 e9                	mov    %ebp,%ecx
  802c4e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c52:	8b 3c 24             	mov    (%esp),%edi
  802c55:	09 74 24 08          	or     %esi,0x8(%esp)
  802c59:	89 d6                	mov    %edx,%esi
  802c5b:	d3 e7                	shl    %cl,%edi
  802c5d:	89 c1                	mov    %eax,%ecx
  802c5f:	89 3c 24             	mov    %edi,(%esp)
  802c62:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c66:	d3 ee                	shr    %cl,%esi
  802c68:	89 e9                	mov    %ebp,%ecx
  802c6a:	d3 e2                	shl    %cl,%edx
  802c6c:	89 c1                	mov    %eax,%ecx
  802c6e:	d3 ef                	shr    %cl,%edi
  802c70:	09 d7                	or     %edx,%edi
  802c72:	89 f2                	mov    %esi,%edx
  802c74:	89 f8                	mov    %edi,%eax
  802c76:	f7 74 24 08          	divl   0x8(%esp)
  802c7a:	89 d6                	mov    %edx,%esi
  802c7c:	89 c7                	mov    %eax,%edi
  802c7e:	f7 24 24             	mull   (%esp)
  802c81:	39 d6                	cmp    %edx,%esi
  802c83:	89 14 24             	mov    %edx,(%esp)
  802c86:	72 30                	jb     802cb8 <__udivdi3+0x118>
  802c88:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c8c:	89 e9                	mov    %ebp,%ecx
  802c8e:	d3 e2                	shl    %cl,%edx
  802c90:	39 c2                	cmp    %eax,%edx
  802c92:	73 05                	jae    802c99 <__udivdi3+0xf9>
  802c94:	3b 34 24             	cmp    (%esp),%esi
  802c97:	74 1f                	je     802cb8 <__udivdi3+0x118>
  802c99:	89 f8                	mov    %edi,%eax
  802c9b:	31 d2                	xor    %edx,%edx
  802c9d:	e9 7a ff ff ff       	jmp    802c1c <__udivdi3+0x7c>
  802ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ca8:	31 d2                	xor    %edx,%edx
  802caa:	b8 01 00 00 00       	mov    $0x1,%eax
  802caf:	e9 68 ff ff ff       	jmp    802c1c <__udivdi3+0x7c>
  802cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cb8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802cbb:	31 d2                	xor    %edx,%edx
  802cbd:	83 c4 0c             	add    $0xc,%esp
  802cc0:	5e                   	pop    %esi
  802cc1:	5f                   	pop    %edi
  802cc2:	5d                   	pop    %ebp
  802cc3:	c3                   	ret    
  802cc4:	66 90                	xchg   %ax,%ax
  802cc6:	66 90                	xchg   %ax,%ax
  802cc8:	66 90                	xchg   %ax,%ax
  802cca:	66 90                	xchg   %ax,%ax
  802ccc:	66 90                	xchg   %ax,%ax
  802cce:	66 90                	xchg   %ax,%ax

00802cd0 <__umoddi3>:
  802cd0:	55                   	push   %ebp
  802cd1:	57                   	push   %edi
  802cd2:	56                   	push   %esi
  802cd3:	83 ec 14             	sub    $0x14,%esp
  802cd6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802cda:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802cde:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802ce2:	89 c7                	mov    %eax,%edi
  802ce4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ce8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802cec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802cf0:	89 34 24             	mov    %esi,(%esp)
  802cf3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802cf7:	85 c0                	test   %eax,%eax
  802cf9:	89 c2                	mov    %eax,%edx
  802cfb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cff:	75 17                	jne    802d18 <__umoddi3+0x48>
  802d01:	39 fe                	cmp    %edi,%esi
  802d03:	76 4b                	jbe    802d50 <__umoddi3+0x80>
  802d05:	89 c8                	mov    %ecx,%eax
  802d07:	89 fa                	mov    %edi,%edx
  802d09:	f7 f6                	div    %esi
  802d0b:	89 d0                	mov    %edx,%eax
  802d0d:	31 d2                	xor    %edx,%edx
  802d0f:	83 c4 14             	add    $0x14,%esp
  802d12:	5e                   	pop    %esi
  802d13:	5f                   	pop    %edi
  802d14:	5d                   	pop    %ebp
  802d15:	c3                   	ret    
  802d16:	66 90                	xchg   %ax,%ax
  802d18:	39 f8                	cmp    %edi,%eax
  802d1a:	77 54                	ja     802d70 <__umoddi3+0xa0>
  802d1c:	0f bd e8             	bsr    %eax,%ebp
  802d1f:	83 f5 1f             	xor    $0x1f,%ebp
  802d22:	75 5c                	jne    802d80 <__umoddi3+0xb0>
  802d24:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802d28:	39 3c 24             	cmp    %edi,(%esp)
  802d2b:	0f 87 e7 00 00 00    	ja     802e18 <__umoddi3+0x148>
  802d31:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d35:	29 f1                	sub    %esi,%ecx
  802d37:	19 c7                	sbb    %eax,%edi
  802d39:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d41:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d45:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802d49:	83 c4 14             	add    $0x14,%esp
  802d4c:	5e                   	pop    %esi
  802d4d:	5f                   	pop    %edi
  802d4e:	5d                   	pop    %ebp
  802d4f:	c3                   	ret    
  802d50:	85 f6                	test   %esi,%esi
  802d52:	89 f5                	mov    %esi,%ebp
  802d54:	75 0b                	jne    802d61 <__umoddi3+0x91>
  802d56:	b8 01 00 00 00       	mov    $0x1,%eax
  802d5b:	31 d2                	xor    %edx,%edx
  802d5d:	f7 f6                	div    %esi
  802d5f:	89 c5                	mov    %eax,%ebp
  802d61:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d65:	31 d2                	xor    %edx,%edx
  802d67:	f7 f5                	div    %ebp
  802d69:	89 c8                	mov    %ecx,%eax
  802d6b:	f7 f5                	div    %ebp
  802d6d:	eb 9c                	jmp    802d0b <__umoddi3+0x3b>
  802d6f:	90                   	nop
  802d70:	89 c8                	mov    %ecx,%eax
  802d72:	89 fa                	mov    %edi,%edx
  802d74:	83 c4 14             	add    $0x14,%esp
  802d77:	5e                   	pop    %esi
  802d78:	5f                   	pop    %edi
  802d79:	5d                   	pop    %ebp
  802d7a:	c3                   	ret    
  802d7b:	90                   	nop
  802d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d80:	8b 04 24             	mov    (%esp),%eax
  802d83:	be 20 00 00 00       	mov    $0x20,%esi
  802d88:	89 e9                	mov    %ebp,%ecx
  802d8a:	29 ee                	sub    %ebp,%esi
  802d8c:	d3 e2                	shl    %cl,%edx
  802d8e:	89 f1                	mov    %esi,%ecx
  802d90:	d3 e8                	shr    %cl,%eax
  802d92:	89 e9                	mov    %ebp,%ecx
  802d94:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d98:	8b 04 24             	mov    (%esp),%eax
  802d9b:	09 54 24 04          	or     %edx,0x4(%esp)
  802d9f:	89 fa                	mov    %edi,%edx
  802da1:	d3 e0                	shl    %cl,%eax
  802da3:	89 f1                	mov    %esi,%ecx
  802da5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802da9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802dad:	d3 ea                	shr    %cl,%edx
  802daf:	89 e9                	mov    %ebp,%ecx
  802db1:	d3 e7                	shl    %cl,%edi
  802db3:	89 f1                	mov    %esi,%ecx
  802db5:	d3 e8                	shr    %cl,%eax
  802db7:	89 e9                	mov    %ebp,%ecx
  802db9:	09 f8                	or     %edi,%eax
  802dbb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802dbf:	f7 74 24 04          	divl   0x4(%esp)
  802dc3:	d3 e7                	shl    %cl,%edi
  802dc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802dc9:	89 d7                	mov    %edx,%edi
  802dcb:	f7 64 24 08          	mull   0x8(%esp)
  802dcf:	39 d7                	cmp    %edx,%edi
  802dd1:	89 c1                	mov    %eax,%ecx
  802dd3:	89 14 24             	mov    %edx,(%esp)
  802dd6:	72 2c                	jb     802e04 <__umoddi3+0x134>
  802dd8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802ddc:	72 22                	jb     802e00 <__umoddi3+0x130>
  802dde:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802de2:	29 c8                	sub    %ecx,%eax
  802de4:	19 d7                	sbb    %edx,%edi
  802de6:	89 e9                	mov    %ebp,%ecx
  802de8:	89 fa                	mov    %edi,%edx
  802dea:	d3 e8                	shr    %cl,%eax
  802dec:	89 f1                	mov    %esi,%ecx
  802dee:	d3 e2                	shl    %cl,%edx
  802df0:	89 e9                	mov    %ebp,%ecx
  802df2:	d3 ef                	shr    %cl,%edi
  802df4:	09 d0                	or     %edx,%eax
  802df6:	89 fa                	mov    %edi,%edx
  802df8:	83 c4 14             	add    $0x14,%esp
  802dfb:	5e                   	pop    %esi
  802dfc:	5f                   	pop    %edi
  802dfd:	5d                   	pop    %ebp
  802dfe:	c3                   	ret    
  802dff:	90                   	nop
  802e00:	39 d7                	cmp    %edx,%edi
  802e02:	75 da                	jne    802dde <__umoddi3+0x10e>
  802e04:	8b 14 24             	mov    (%esp),%edx
  802e07:	89 c1                	mov    %eax,%ecx
  802e09:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802e0d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802e11:	eb cb                	jmp    802dde <__umoddi3+0x10e>
  802e13:	90                   	nop
  802e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e18:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802e1c:	0f 82 0f ff ff ff    	jb     802d31 <__umoddi3+0x61>
  802e22:	e9 1a ff ff ff       	jmp    802d41 <__umoddi3+0x71>
