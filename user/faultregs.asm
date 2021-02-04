
obj/user/faultregs.debug:     file format elf32-i386


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
  80002c:	e8 64 05 00 00       	call   800595 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	8b 45 08             	mov    0x8(%ebp),%eax
  800043:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800047:	89 54 24 08          	mov    %edx,0x8(%esp)
  80004b:	c7 44 24 04 d1 2c 80 	movl   $0x802cd1,0x4(%esp)
  800052:	00 
  800053:	c7 04 24 a0 2c 80 00 	movl   $0x802ca0,(%esp)
  80005a:	e8 94 06 00 00       	call   8006f3 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  80005f:	8b 03                	mov    (%ebx),%eax
  800061:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800065:	8b 06                	mov    (%esi),%eax
  800067:	89 44 24 08          	mov    %eax,0x8(%esp)
  80006b:	c7 44 24 04 b0 2c 80 	movl   $0x802cb0,0x4(%esp)
  800072:	00 
  800073:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  80007a:	e8 74 06 00 00       	call   8006f3 <cprintf>
  80007f:	8b 03                	mov    (%ebx),%eax
  800081:	39 06                	cmp    %eax,(%esi)
  800083:	75 13                	jne    800098 <check_regs+0x65>
  800085:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  80008c:	e8 62 06 00 00       	call   8006f3 <cprintf>

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
	int mismatch = 0;
  800091:	bf 00 00 00 00       	mov    $0x0,%edi
  800096:	eb 11                	jmp    8000a9 <check_regs+0x76>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800098:	c7 04 24 c8 2c 80 00 	movl   $0x802cc8,(%esp)
  80009f:	e8 4f 06 00 00       	call   8006f3 <cprintf>
  8000a4:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  8000a9:	8b 43 04             	mov    0x4(%ebx),%eax
  8000ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b0:	8b 46 04             	mov    0x4(%esi),%eax
  8000b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000b7:	c7 44 24 04 d2 2c 80 	movl   $0x802cd2,0x4(%esp)
  8000be:	00 
  8000bf:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  8000c6:	e8 28 06 00 00       	call   8006f3 <cprintf>
  8000cb:	8b 43 04             	mov    0x4(%ebx),%eax
  8000ce:	39 46 04             	cmp    %eax,0x4(%esi)
  8000d1:	75 0e                	jne    8000e1 <check_regs+0xae>
  8000d3:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  8000da:	e8 14 06 00 00       	call   8006f3 <cprintf>
  8000df:	eb 11                	jmp    8000f2 <check_regs+0xbf>
  8000e1:	c7 04 24 c8 2c 80 00 	movl   $0x802cc8,(%esp)
  8000e8:	e8 06 06 00 00       	call   8006f3 <cprintf>
  8000ed:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000f2:	8b 43 08             	mov    0x8(%ebx),%eax
  8000f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f9:	8b 46 08             	mov    0x8(%esi),%eax
  8000fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800100:	c7 44 24 04 d6 2c 80 	movl   $0x802cd6,0x4(%esp)
  800107:	00 
  800108:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  80010f:	e8 df 05 00 00       	call   8006f3 <cprintf>
  800114:	8b 43 08             	mov    0x8(%ebx),%eax
  800117:	39 46 08             	cmp    %eax,0x8(%esi)
  80011a:	75 0e                	jne    80012a <check_regs+0xf7>
  80011c:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  800123:	e8 cb 05 00 00       	call   8006f3 <cprintf>
  800128:	eb 11                	jmp    80013b <check_regs+0x108>
  80012a:	c7 04 24 c8 2c 80 00 	movl   $0x802cc8,(%esp)
  800131:	e8 bd 05 00 00       	call   8006f3 <cprintf>
  800136:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  80013b:	8b 43 10             	mov    0x10(%ebx),%eax
  80013e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800142:	8b 46 10             	mov    0x10(%esi),%eax
  800145:	89 44 24 08          	mov    %eax,0x8(%esp)
  800149:	c7 44 24 04 da 2c 80 	movl   $0x802cda,0x4(%esp)
  800150:	00 
  800151:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  800158:	e8 96 05 00 00       	call   8006f3 <cprintf>
  80015d:	8b 43 10             	mov    0x10(%ebx),%eax
  800160:	39 46 10             	cmp    %eax,0x10(%esi)
  800163:	75 0e                	jne    800173 <check_regs+0x140>
  800165:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  80016c:	e8 82 05 00 00       	call   8006f3 <cprintf>
  800171:	eb 11                	jmp    800184 <check_regs+0x151>
  800173:	c7 04 24 c8 2c 80 00 	movl   $0x802cc8,(%esp)
  80017a:	e8 74 05 00 00       	call   8006f3 <cprintf>
  80017f:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800184:	8b 43 14             	mov    0x14(%ebx),%eax
  800187:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80018b:	8b 46 14             	mov    0x14(%esi),%eax
  80018e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800192:	c7 44 24 04 de 2c 80 	movl   $0x802cde,0x4(%esp)
  800199:	00 
  80019a:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  8001a1:	e8 4d 05 00 00       	call   8006f3 <cprintf>
  8001a6:	8b 43 14             	mov    0x14(%ebx),%eax
  8001a9:	39 46 14             	cmp    %eax,0x14(%esi)
  8001ac:	75 0e                	jne    8001bc <check_regs+0x189>
  8001ae:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  8001b5:	e8 39 05 00 00       	call   8006f3 <cprintf>
  8001ba:	eb 11                	jmp    8001cd <check_regs+0x19a>
  8001bc:	c7 04 24 c8 2c 80 00 	movl   $0x802cc8,(%esp)
  8001c3:	e8 2b 05 00 00       	call   8006f3 <cprintf>
  8001c8:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  8001cd:	8b 43 18             	mov    0x18(%ebx),%eax
  8001d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d4:	8b 46 18             	mov    0x18(%esi),%eax
  8001d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001db:	c7 44 24 04 e2 2c 80 	movl   $0x802ce2,0x4(%esp)
  8001e2:	00 
  8001e3:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  8001ea:	e8 04 05 00 00       	call   8006f3 <cprintf>
  8001ef:	8b 43 18             	mov    0x18(%ebx),%eax
  8001f2:	39 46 18             	cmp    %eax,0x18(%esi)
  8001f5:	75 0e                	jne    800205 <check_regs+0x1d2>
  8001f7:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  8001fe:	e8 f0 04 00 00       	call   8006f3 <cprintf>
  800203:	eb 11                	jmp    800216 <check_regs+0x1e3>
  800205:	c7 04 24 c8 2c 80 00 	movl   $0x802cc8,(%esp)
  80020c:	e8 e2 04 00 00       	call   8006f3 <cprintf>
  800211:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  800216:	8b 43 1c             	mov    0x1c(%ebx),%eax
  800219:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80021d:	8b 46 1c             	mov    0x1c(%esi),%eax
  800220:	89 44 24 08          	mov    %eax,0x8(%esp)
  800224:	c7 44 24 04 e6 2c 80 	movl   $0x802ce6,0x4(%esp)
  80022b:	00 
  80022c:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  800233:	e8 bb 04 00 00       	call   8006f3 <cprintf>
  800238:	8b 43 1c             	mov    0x1c(%ebx),%eax
  80023b:	39 46 1c             	cmp    %eax,0x1c(%esi)
  80023e:	75 0e                	jne    80024e <check_regs+0x21b>
  800240:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  800247:	e8 a7 04 00 00       	call   8006f3 <cprintf>
  80024c:	eb 11                	jmp    80025f <check_regs+0x22c>
  80024e:	c7 04 24 c8 2c 80 00 	movl   $0x802cc8,(%esp)
  800255:	e8 99 04 00 00       	call   8006f3 <cprintf>
  80025a:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  80025f:	8b 43 20             	mov    0x20(%ebx),%eax
  800262:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800266:	8b 46 20             	mov    0x20(%esi),%eax
  800269:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026d:	c7 44 24 04 ea 2c 80 	movl   $0x802cea,0x4(%esp)
  800274:	00 
  800275:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  80027c:	e8 72 04 00 00       	call   8006f3 <cprintf>
  800281:	8b 43 20             	mov    0x20(%ebx),%eax
  800284:	39 46 20             	cmp    %eax,0x20(%esi)
  800287:	75 0e                	jne    800297 <check_regs+0x264>
  800289:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  800290:	e8 5e 04 00 00       	call   8006f3 <cprintf>
  800295:	eb 11                	jmp    8002a8 <check_regs+0x275>
  800297:	c7 04 24 c8 2c 80 00 	movl   $0x802cc8,(%esp)
  80029e:	e8 50 04 00 00       	call   8006f3 <cprintf>
  8002a3:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  8002a8:	8b 43 24             	mov    0x24(%ebx),%eax
  8002ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002af:	8b 46 24             	mov    0x24(%esi),%eax
  8002b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b6:	c7 44 24 04 ee 2c 80 	movl   $0x802cee,0x4(%esp)
  8002bd:	00 
  8002be:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  8002c5:	e8 29 04 00 00       	call   8006f3 <cprintf>
  8002ca:	8b 43 24             	mov    0x24(%ebx),%eax
  8002cd:	39 46 24             	cmp    %eax,0x24(%esi)
  8002d0:	75 0e                	jne    8002e0 <check_regs+0x2ad>
  8002d2:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  8002d9:	e8 15 04 00 00       	call   8006f3 <cprintf>
  8002de:	eb 11                	jmp    8002f1 <check_regs+0x2be>
  8002e0:	c7 04 24 c8 2c 80 00 	movl   $0x802cc8,(%esp)
  8002e7:	e8 07 04 00 00       	call   8006f3 <cprintf>
  8002ec:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esp, esp);
  8002f1:	8b 43 28             	mov    0x28(%ebx),%eax
  8002f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002f8:	8b 46 28             	mov    0x28(%esi),%eax
  8002fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ff:	c7 44 24 04 f5 2c 80 	movl   $0x802cf5,0x4(%esp)
  800306:	00 
  800307:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  80030e:	e8 e0 03 00 00       	call   8006f3 <cprintf>
  800313:	8b 43 28             	mov    0x28(%ebx),%eax
  800316:	39 46 28             	cmp    %eax,0x28(%esi)
  800319:	75 25                	jne    800340 <check_regs+0x30d>
  80031b:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  800322:	e8 cc 03 00 00       	call   8006f3 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032e:	c7 04 24 f9 2c 80 00 	movl   $0x802cf9,(%esp)
  800335:	e8 b9 03 00 00       	call   8006f3 <cprintf>
	if (!mismatch)
  80033a:	85 ff                	test   %edi,%edi
  80033c:	74 23                	je     800361 <check_regs+0x32e>
  80033e:	eb 2f                	jmp    80036f <check_regs+0x33c>
	CHECK(edx, regs.reg_edx);
	CHECK(ecx, regs.reg_ecx);
	CHECK(eax, regs.reg_eax);
	CHECK(eip, eip);
	CHECK(eflags, eflags);
	CHECK(esp, esp);
  800340:	c7 04 24 c8 2c 80 00 	movl   $0x802cc8,(%esp)
  800347:	e8 a7 03 00 00       	call   8006f3 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800353:	c7 04 24 f9 2c 80 00 	movl   $0x802cf9,(%esp)
  80035a:	e8 94 03 00 00       	call   8006f3 <cprintf>
  80035f:	eb 0e                	jmp    80036f <check_regs+0x33c>
	if (!mismatch)
		cprintf("OK\n");
  800361:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  800368:	e8 86 03 00 00       	call   8006f3 <cprintf>
  80036d:	eb 0c                	jmp    80037b <check_regs+0x348>
	else
		cprintf("MISMATCH\n");
  80036f:	c7 04 24 c8 2c 80 00 	movl   $0x802cc8,(%esp)
  800376:	e8 78 03 00 00       	call   8006f3 <cprintf>
}
  80037b:	83 c4 1c             	add    $0x1c,%esp
  80037e:	5b                   	pop    %ebx
  80037f:	5e                   	pop    %esi
  800380:	5f                   	pop    %edi
  800381:	5d                   	pop    %ebp
  800382:	c3                   	ret    

00800383 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	83 ec 28             	sub    $0x28,%esp
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  80038c:	8b 10                	mov    (%eax),%edx
  80038e:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  800394:	74 27                	je     8003bd <pgfault+0x3a>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  800396:	8b 40 28             	mov    0x28(%eax),%eax
  800399:	89 44 24 10          	mov    %eax,0x10(%esp)
  80039d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a1:	c7 44 24 08 60 2d 80 	movl   $0x802d60,0x8(%esp)
  8003a8:	00 
  8003a9:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
  8003b0:	00 
  8003b1:	c7 04 24 07 2d 80 00 	movl   $0x802d07,(%esp)
  8003b8:	e8 3d 02 00 00       	call   8005fa <_panic>
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003bd:	8b 50 08             	mov    0x8(%eax),%edx
  8003c0:	89 15 40 50 80 00    	mov    %edx,0x805040
  8003c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8003c9:	89 15 44 50 80 00    	mov    %edx,0x805044
  8003cf:	8b 50 10             	mov    0x10(%eax),%edx
  8003d2:	89 15 48 50 80 00    	mov    %edx,0x805048
  8003d8:	8b 50 14             	mov    0x14(%eax),%edx
  8003db:	89 15 4c 50 80 00    	mov    %edx,0x80504c
  8003e1:	8b 50 18             	mov    0x18(%eax),%edx
  8003e4:	89 15 50 50 80 00    	mov    %edx,0x805050
  8003ea:	8b 50 1c             	mov    0x1c(%eax),%edx
  8003ed:	89 15 54 50 80 00    	mov    %edx,0x805054
  8003f3:	8b 50 20             	mov    0x20(%eax),%edx
  8003f6:	89 15 58 50 80 00    	mov    %edx,0x805058
  8003fc:	8b 50 24             	mov    0x24(%eax),%edx
  8003ff:	89 15 5c 50 80 00    	mov    %edx,0x80505c
	during.eip = utf->utf_eip;
  800405:	8b 50 28             	mov    0x28(%eax),%edx
  800408:	89 15 60 50 80 00    	mov    %edx,0x805060
	during.eflags = utf->utf_eflags;
  80040e:	8b 50 2c             	mov    0x2c(%eax),%edx
  800411:	89 15 64 50 80 00    	mov    %edx,0x805064
	during.esp = utf->utf_esp;
  800417:	8b 40 30             	mov    0x30(%eax),%eax
  80041a:	a3 68 50 80 00       	mov    %eax,0x805068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  80041f:	c7 44 24 04 1f 2d 80 	movl   $0x802d1f,0x4(%esp)
  800426:	00 
  800427:	c7 04 24 2d 2d 80 00 	movl   $0x802d2d,(%esp)
  80042e:	b9 40 50 80 00       	mov    $0x805040,%ecx
  800433:	ba 18 2d 80 00       	mov    $0x802d18,%edx
  800438:	b8 80 50 80 00       	mov    $0x805080,%eax
  80043d:	e8 f1 fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800442:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800449:	00 
  80044a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  800451:	00 
  800452:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800459:	e8 d5 0c 00 00       	call   801133 <sys_page_alloc>
  80045e:	85 c0                	test   %eax,%eax
  800460:	79 20                	jns    800482 <pgfault+0xff>
		panic("sys_page_alloc: %e", r);
  800462:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800466:	c7 44 24 08 34 2d 80 	movl   $0x802d34,0x8(%esp)
  80046d:	00 
  80046e:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800475:	00 
  800476:	c7 04 24 07 2d 80 00 	movl   $0x802d07,(%esp)
  80047d:	e8 78 01 00 00       	call   8005fa <_panic>
}
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <umain>:

void
umain(int argc, char **argv)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(pgfault);
  80048a:	c7 04 24 83 03 80 00 	movl   $0x800383,(%esp)
  800491:	e8 c2 10 00 00       	call   801558 <set_pgfault_handler>

	__asm __volatile(
  800496:	50                   	push   %eax
  800497:	9c                   	pushf  
  800498:	58                   	pop    %eax
  800499:	0d d5 08 00 00       	or     $0x8d5,%eax
  80049e:	50                   	push   %eax
  80049f:	9d                   	popf   
  8004a0:	a3 a4 50 80 00       	mov    %eax,0x8050a4
  8004a5:	8d 05 e0 04 80 00    	lea    0x8004e0,%eax
  8004ab:	a3 a0 50 80 00       	mov    %eax,0x8050a0
  8004b0:	58                   	pop    %eax
  8004b1:	89 3d 80 50 80 00    	mov    %edi,0x805080
  8004b7:	89 35 84 50 80 00    	mov    %esi,0x805084
  8004bd:	89 2d 88 50 80 00    	mov    %ebp,0x805088
  8004c3:	89 1d 90 50 80 00    	mov    %ebx,0x805090
  8004c9:	89 15 94 50 80 00    	mov    %edx,0x805094
  8004cf:	89 0d 98 50 80 00    	mov    %ecx,0x805098
  8004d5:	a3 9c 50 80 00       	mov    %eax,0x80509c
  8004da:	89 25 a8 50 80 00    	mov    %esp,0x8050a8
  8004e0:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  8004e7:	00 00 00 
  8004ea:	89 3d 00 50 80 00    	mov    %edi,0x805000
  8004f0:	89 35 04 50 80 00    	mov    %esi,0x805004
  8004f6:	89 2d 08 50 80 00    	mov    %ebp,0x805008
  8004fc:	89 1d 10 50 80 00    	mov    %ebx,0x805010
  800502:	89 15 14 50 80 00    	mov    %edx,0x805014
  800508:	89 0d 18 50 80 00    	mov    %ecx,0x805018
  80050e:	a3 1c 50 80 00       	mov    %eax,0x80501c
  800513:	89 25 28 50 80 00    	mov    %esp,0x805028
  800519:	8b 3d 80 50 80 00    	mov    0x805080,%edi
  80051f:	8b 35 84 50 80 00    	mov    0x805084,%esi
  800525:	8b 2d 88 50 80 00    	mov    0x805088,%ebp
  80052b:	8b 1d 90 50 80 00    	mov    0x805090,%ebx
  800531:	8b 15 94 50 80 00    	mov    0x805094,%edx
  800537:	8b 0d 98 50 80 00    	mov    0x805098,%ecx
  80053d:	a1 9c 50 80 00       	mov    0x80509c,%eax
  800542:	8b 25 a8 50 80 00    	mov    0x8050a8,%esp
  800548:	50                   	push   %eax
  800549:	9c                   	pushf  
  80054a:	58                   	pop    %eax
  80054b:	a3 24 50 80 00       	mov    %eax,0x805024
  800550:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800551:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  800558:	74 0c                	je     800566 <umain+0xe2>
		cprintf("EIP after page-fault MISMATCH\n");
  80055a:	c7 04 24 94 2d 80 00 	movl   $0x802d94,(%esp)
  800561:	e8 8d 01 00 00       	call   8006f3 <cprintf>
	after.eip = before.eip;
  800566:	a1 a0 50 80 00       	mov    0x8050a0,%eax
  80056b:	a3 20 50 80 00       	mov    %eax,0x805020

	check_regs(&before, "before", &after, "after", "after page-fault");
  800570:	c7 44 24 04 47 2d 80 	movl   $0x802d47,0x4(%esp)
  800577:	00 
  800578:	c7 04 24 58 2d 80 00 	movl   $0x802d58,(%esp)
  80057f:	b9 00 50 80 00       	mov    $0x805000,%ecx
  800584:	ba 18 2d 80 00       	mov    $0x802d18,%edx
  800589:	b8 80 50 80 00       	mov    $0x805080,%eax
  80058e:	e8 a0 fa ff ff       	call   800033 <check_regs>
}
  800593:	c9                   	leave  
  800594:	c3                   	ret    

00800595 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800595:	55                   	push   %ebp
  800596:	89 e5                	mov    %esp,%ebp
  800598:	56                   	push   %esi
  800599:	53                   	push   %ebx
  80059a:	83 ec 10             	sub    $0x10,%esp
  80059d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005a0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  8005a3:	e8 4d 0b 00 00       	call   8010f5 <sys_getenvid>
  8005a8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005ad:	89 c2                	mov    %eax,%edx
  8005af:	c1 e2 07             	shl    $0x7,%edx
  8005b2:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  8005b9:	a3 b4 50 80 00       	mov    %eax,0x8050b4

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005be:	85 db                	test   %ebx,%ebx
  8005c0:	7e 07                	jle    8005c9 <libmain+0x34>
		binaryname = argv[0];
  8005c2:	8b 06                	mov    (%esi),%eax
  8005c4:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8005c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005cd:	89 1c 24             	mov    %ebx,(%esp)
  8005d0:	e8 af fe ff ff       	call   800484 <umain>

	// exit gracefully
	exit();
  8005d5:	e8 07 00 00 00       	call   8005e1 <exit>
}
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	5b                   	pop    %ebx
  8005de:	5e                   	pop    %esi
  8005df:	5d                   	pop    %ebp
  8005e0:	c3                   	ret    

008005e1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8005e7:	e8 fe 11 00 00       	call   8017ea <close_all>
	sys_env_destroy(0);
  8005ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005f3:	e8 ab 0a 00 00       	call   8010a3 <sys_env_destroy>
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	56                   	push   %esi
  8005fe:	53                   	push   %ebx
  8005ff:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800602:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800605:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80060b:	e8 e5 0a 00 00       	call   8010f5 <sys_getenvid>
  800610:	8b 55 0c             	mov    0xc(%ebp),%edx
  800613:	89 54 24 10          	mov    %edx,0x10(%esp)
  800617:	8b 55 08             	mov    0x8(%ebp),%edx
  80061a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80061e:	89 74 24 08          	mov    %esi,0x8(%esp)
  800622:	89 44 24 04          	mov    %eax,0x4(%esp)
  800626:	c7 04 24 c0 2d 80 00 	movl   $0x802dc0,(%esp)
  80062d:	e8 c1 00 00 00       	call   8006f3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800632:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800636:	8b 45 10             	mov    0x10(%ebp),%eax
  800639:	89 04 24             	mov    %eax,(%esp)
  80063c:	e8 51 00 00 00       	call   800692 <vcprintf>
	cprintf("\n");
  800641:	c7 04 24 d0 2c 80 00 	movl   $0x802cd0,(%esp)
  800648:	e8 a6 00 00 00       	call   8006f3 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80064d:	cc                   	int3   
  80064e:	eb fd                	jmp    80064d <_panic+0x53>

00800650 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800650:	55                   	push   %ebp
  800651:	89 e5                	mov    %esp,%ebp
  800653:	53                   	push   %ebx
  800654:	83 ec 14             	sub    $0x14,%esp
  800657:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80065a:	8b 13                	mov    (%ebx),%edx
  80065c:	8d 42 01             	lea    0x1(%edx),%eax
  80065f:	89 03                	mov    %eax,(%ebx)
  800661:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800664:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800668:	3d ff 00 00 00       	cmp    $0xff,%eax
  80066d:	75 19                	jne    800688 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80066f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800676:	00 
  800677:	8d 43 08             	lea    0x8(%ebx),%eax
  80067a:	89 04 24             	mov    %eax,(%esp)
  80067d:	e8 e4 09 00 00       	call   801066 <sys_cputs>
		b->idx = 0;
  800682:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800688:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80068c:	83 c4 14             	add    $0x14,%esp
  80068f:	5b                   	pop    %ebx
  800690:	5d                   	pop    %ebp
  800691:	c3                   	ret    

00800692 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800692:	55                   	push   %ebp
  800693:	89 e5                	mov    %esp,%ebp
  800695:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80069b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006a2:	00 00 00 
	b.cnt = 0;
  8006a5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ac:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006bd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006c7:	c7 04 24 50 06 80 00 	movl   $0x800650,(%esp)
  8006ce:	e8 ab 01 00 00       	call   80087e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006d3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8006d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006dd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006e3:	89 04 24             	mov    %eax,(%esp)
  8006e6:	e8 7b 09 00 00       	call   801066 <sys_cputs>

	return b.cnt;
}
  8006eb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006f1:	c9                   	leave  
  8006f2:	c3                   	ret    

008006f3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006f3:	55                   	push   %ebp
  8006f4:	89 e5                	mov    %esp,%ebp
  8006f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006f9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8006fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	89 04 24             	mov    %eax,(%esp)
  800706:	e8 87 ff ff ff       	call   800692 <vcprintf>
	va_end(ap);

	return cnt;
}
  80070b:	c9                   	leave  
  80070c:	c3                   	ret    
  80070d:	66 90                	xchg   %ax,%ax
  80070f:	90                   	nop

00800710 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	57                   	push   %edi
  800714:	56                   	push   %esi
  800715:	53                   	push   %ebx
  800716:	83 ec 3c             	sub    $0x3c,%esp
  800719:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80071c:	89 d7                	mov    %edx,%edi
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800724:	8b 45 0c             	mov    0xc(%ebp),%eax
  800727:	89 c3                	mov    %eax,%ebx
  800729:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80072c:	8b 45 10             	mov    0x10(%ebp),%eax
  80072f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800732:	b9 00 00 00 00       	mov    $0x0,%ecx
  800737:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80073d:	39 d9                	cmp    %ebx,%ecx
  80073f:	72 05                	jb     800746 <printnum+0x36>
  800741:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800744:	77 69                	ja     8007af <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800746:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800749:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80074d:	83 ee 01             	sub    $0x1,%esi
  800750:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800754:	89 44 24 08          	mov    %eax,0x8(%esp)
  800758:	8b 44 24 08          	mov    0x8(%esp),%eax
  80075c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800760:	89 c3                	mov    %eax,%ebx
  800762:	89 d6                	mov    %edx,%esi
  800764:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800767:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80076a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80076e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800772:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800775:	89 04 24             	mov    %eax,(%esp)
  800778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80077b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077f:	e8 8c 22 00 00       	call   802a10 <__udivdi3>
  800784:	89 d9                	mov    %ebx,%ecx
  800786:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80078a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80078e:	89 04 24             	mov    %eax,(%esp)
  800791:	89 54 24 04          	mov    %edx,0x4(%esp)
  800795:	89 fa                	mov    %edi,%edx
  800797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80079a:	e8 71 ff ff ff       	call   800710 <printnum>
  80079f:	eb 1b                	jmp    8007bc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007a1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8007a8:	89 04 24             	mov    %eax,(%esp)
  8007ab:	ff d3                	call   *%ebx
  8007ad:	eb 03                	jmp    8007b2 <printnum+0xa2>
  8007af:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b2:	83 ee 01             	sub    $0x1,%esi
  8007b5:	85 f6                	test   %esi,%esi
  8007b7:	7f e8                	jg     8007a1 <printnum+0x91>
  8007b9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8007c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ce:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007d5:	89 04 24             	mov    %eax,(%esp)
  8007d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007df:	e8 5c 23 00 00       	call   802b40 <__umoddi3>
  8007e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e8:	0f be 80 e3 2d 80 00 	movsbl 0x802de3(%eax),%eax
  8007ef:	89 04 24             	mov    %eax,(%esp)
  8007f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007f5:	ff d0                	call   *%eax
}
  8007f7:	83 c4 3c             	add    $0x3c,%esp
  8007fa:	5b                   	pop    %ebx
  8007fb:	5e                   	pop    %esi
  8007fc:	5f                   	pop    %edi
  8007fd:	5d                   	pop    %ebp
  8007fe:	c3                   	ret    

008007ff <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800802:	83 fa 01             	cmp    $0x1,%edx
  800805:	7e 0e                	jle    800815 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800807:	8b 10                	mov    (%eax),%edx
  800809:	8d 4a 08             	lea    0x8(%edx),%ecx
  80080c:	89 08                	mov    %ecx,(%eax)
  80080e:	8b 02                	mov    (%edx),%eax
  800810:	8b 52 04             	mov    0x4(%edx),%edx
  800813:	eb 22                	jmp    800837 <getuint+0x38>
	else if (lflag)
  800815:	85 d2                	test   %edx,%edx
  800817:	74 10                	je     800829 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800819:	8b 10                	mov    (%eax),%edx
  80081b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80081e:	89 08                	mov    %ecx,(%eax)
  800820:	8b 02                	mov    (%edx),%eax
  800822:	ba 00 00 00 00       	mov    $0x0,%edx
  800827:	eb 0e                	jmp    800837 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800829:	8b 10                	mov    (%eax),%edx
  80082b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80082e:	89 08                	mov    %ecx,(%eax)
  800830:	8b 02                	mov    (%edx),%eax
  800832:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800837:	5d                   	pop    %ebp
  800838:	c3                   	ret    

00800839 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80083f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800843:	8b 10                	mov    (%eax),%edx
  800845:	3b 50 04             	cmp    0x4(%eax),%edx
  800848:	73 0a                	jae    800854 <sprintputch+0x1b>
		*b->buf++ = ch;
  80084a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80084d:	89 08                	mov    %ecx,(%eax)
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	88 02                	mov    %al,(%edx)
}
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    

00800856 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80085c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80085f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800863:	8b 45 10             	mov    0x10(%ebp),%eax
  800866:	89 44 24 08          	mov    %eax,0x8(%esp)
  80086a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	89 04 24             	mov    %eax,(%esp)
  800877:	e8 02 00 00 00       	call   80087e <vprintfmt>
	va_end(ap);
}
  80087c:	c9                   	leave  
  80087d:	c3                   	ret    

0080087e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	57                   	push   %edi
  800882:	56                   	push   %esi
  800883:	53                   	push   %ebx
  800884:	83 ec 3c             	sub    $0x3c,%esp
  800887:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80088a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80088d:	eb 14                	jmp    8008a3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80088f:	85 c0                	test   %eax,%eax
  800891:	0f 84 b3 03 00 00    	je     800c4a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800897:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80089b:	89 04 24             	mov    %eax,(%esp)
  80089e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a1:	89 f3                	mov    %esi,%ebx
  8008a3:	8d 73 01             	lea    0x1(%ebx),%esi
  8008a6:	0f b6 03             	movzbl (%ebx),%eax
  8008a9:	83 f8 25             	cmp    $0x25,%eax
  8008ac:	75 e1                	jne    80088f <vprintfmt+0x11>
  8008ae:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8008b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008b9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8008c0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8008c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cc:	eb 1d                	jmp    8008eb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ce:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8008d0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8008d4:	eb 15                	jmp    8008eb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008d8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8008dc:	eb 0d                	jmp    8008eb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8008de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008e4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008eb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8008ee:	0f b6 0e             	movzbl (%esi),%ecx
  8008f1:	0f b6 c1             	movzbl %cl,%eax
  8008f4:	83 e9 23             	sub    $0x23,%ecx
  8008f7:	80 f9 55             	cmp    $0x55,%cl
  8008fa:	0f 87 2a 03 00 00    	ja     800c2a <vprintfmt+0x3ac>
  800900:	0f b6 c9             	movzbl %cl,%ecx
  800903:	ff 24 8d 60 2f 80 00 	jmp    *0x802f60(,%ecx,4)
  80090a:	89 de                	mov    %ebx,%esi
  80090c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800911:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800914:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800918:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80091b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80091e:	83 fb 09             	cmp    $0x9,%ebx
  800921:	77 36                	ja     800959 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800923:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800926:	eb e9                	jmp    800911 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	8d 48 04             	lea    0x4(%eax),%ecx
  80092e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800931:	8b 00                	mov    (%eax),%eax
  800933:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800936:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800938:	eb 22                	jmp    80095c <vprintfmt+0xde>
  80093a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80093d:	85 c9                	test   %ecx,%ecx
  80093f:	b8 00 00 00 00       	mov    $0x0,%eax
  800944:	0f 49 c1             	cmovns %ecx,%eax
  800947:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80094a:	89 de                	mov    %ebx,%esi
  80094c:	eb 9d                	jmp    8008eb <vprintfmt+0x6d>
  80094e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800950:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800957:	eb 92                	jmp    8008eb <vprintfmt+0x6d>
  800959:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800960:	79 89                	jns    8008eb <vprintfmt+0x6d>
  800962:	e9 77 ff ff ff       	jmp    8008de <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800967:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80096c:	e9 7a ff ff ff       	jmp    8008eb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	8d 50 04             	lea    0x4(%eax),%edx
  800977:	89 55 14             	mov    %edx,0x14(%ebp)
  80097a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80097e:	8b 00                	mov    (%eax),%eax
  800980:	89 04 24             	mov    %eax,(%esp)
  800983:	ff 55 08             	call   *0x8(%ebp)
			break;
  800986:	e9 18 ff ff ff       	jmp    8008a3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80098b:	8b 45 14             	mov    0x14(%ebp),%eax
  80098e:	8d 50 04             	lea    0x4(%eax),%edx
  800991:	89 55 14             	mov    %edx,0x14(%ebp)
  800994:	8b 00                	mov    (%eax),%eax
  800996:	99                   	cltd   
  800997:	31 d0                	xor    %edx,%eax
  800999:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80099b:	83 f8 12             	cmp    $0x12,%eax
  80099e:	7f 0b                	jg     8009ab <vprintfmt+0x12d>
  8009a0:	8b 14 85 c0 30 80 00 	mov    0x8030c0(,%eax,4),%edx
  8009a7:	85 d2                	test   %edx,%edx
  8009a9:	75 20                	jne    8009cb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8009ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009af:	c7 44 24 08 fb 2d 80 	movl   $0x802dfb,0x8(%esp)
  8009b6:	00 
  8009b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	89 04 24             	mov    %eax,(%esp)
  8009c1:	e8 90 fe ff ff       	call   800856 <printfmt>
  8009c6:	e9 d8 fe ff ff       	jmp    8008a3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8009cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009cf:	c7 44 24 08 65 32 80 	movl   $0x803265,0x8(%esp)
  8009d6:	00 
  8009d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	89 04 24             	mov    %eax,(%esp)
  8009e1:	e8 70 fe ff ff       	call   800856 <printfmt>
  8009e6:	e9 b8 fe ff ff       	jmp    8008a3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009eb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8009ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f7:	8d 50 04             	lea    0x4(%eax),%edx
  8009fa:	89 55 14             	mov    %edx,0x14(%ebp)
  8009fd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8009ff:	85 f6                	test   %esi,%esi
  800a01:	b8 f4 2d 80 00       	mov    $0x802df4,%eax
  800a06:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800a09:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800a0d:	0f 84 97 00 00 00    	je     800aaa <vprintfmt+0x22c>
  800a13:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800a17:	0f 8e 9b 00 00 00    	jle    800ab8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a1d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a21:	89 34 24             	mov    %esi,(%esp)
  800a24:	e8 cf 02 00 00       	call   800cf8 <strnlen>
  800a29:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800a2c:	29 c2                	sub    %eax,%edx
  800a2e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800a31:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800a35:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a38:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800a3b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a3e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a41:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a43:	eb 0f                	jmp    800a54 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800a45:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a4c:	89 04 24             	mov    %eax,(%esp)
  800a4f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a51:	83 eb 01             	sub    $0x1,%ebx
  800a54:	85 db                	test   %ebx,%ebx
  800a56:	7f ed                	jg     800a45 <vprintfmt+0x1c7>
  800a58:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800a5b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800a5e:	85 d2                	test   %edx,%edx
  800a60:	b8 00 00 00 00       	mov    $0x0,%eax
  800a65:	0f 49 c2             	cmovns %edx,%eax
  800a68:	29 c2                	sub    %eax,%edx
  800a6a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800a6d:	89 d7                	mov    %edx,%edi
  800a6f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a72:	eb 50                	jmp    800ac4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a74:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a78:	74 1e                	je     800a98 <vprintfmt+0x21a>
  800a7a:	0f be d2             	movsbl %dl,%edx
  800a7d:	83 ea 20             	sub    $0x20,%edx
  800a80:	83 fa 5e             	cmp    $0x5e,%edx
  800a83:	76 13                	jbe    800a98 <vprintfmt+0x21a>
					putch('?', putdat);
  800a85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a88:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a8c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800a93:	ff 55 08             	call   *0x8(%ebp)
  800a96:	eb 0d                	jmp    800aa5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a9f:	89 04 24             	mov    %eax,(%esp)
  800aa2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa5:	83 ef 01             	sub    $0x1,%edi
  800aa8:	eb 1a                	jmp    800ac4 <vprintfmt+0x246>
  800aaa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800aad:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800ab0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ab3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ab6:	eb 0c                	jmp    800ac4 <vprintfmt+0x246>
  800ab8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800abb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800abe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ac1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ac4:	83 c6 01             	add    $0x1,%esi
  800ac7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800acb:	0f be c2             	movsbl %dl,%eax
  800ace:	85 c0                	test   %eax,%eax
  800ad0:	74 27                	je     800af9 <vprintfmt+0x27b>
  800ad2:	85 db                	test   %ebx,%ebx
  800ad4:	78 9e                	js     800a74 <vprintfmt+0x1f6>
  800ad6:	83 eb 01             	sub    $0x1,%ebx
  800ad9:	79 99                	jns    800a74 <vprintfmt+0x1f6>
  800adb:	89 f8                	mov    %edi,%eax
  800add:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800ae0:	8b 75 08             	mov    0x8(%ebp),%esi
  800ae3:	89 c3                	mov    %eax,%ebx
  800ae5:	eb 1a                	jmp    800b01 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800ae7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aeb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800af2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800af4:	83 eb 01             	sub    $0x1,%ebx
  800af7:	eb 08                	jmp    800b01 <vprintfmt+0x283>
  800af9:	89 fb                	mov    %edi,%ebx
  800afb:	8b 75 08             	mov    0x8(%ebp),%esi
  800afe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800b01:	85 db                	test   %ebx,%ebx
  800b03:	7f e2                	jg     800ae7 <vprintfmt+0x269>
  800b05:	89 75 08             	mov    %esi,0x8(%ebp)
  800b08:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b0b:	e9 93 fd ff ff       	jmp    8008a3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b10:	83 fa 01             	cmp    $0x1,%edx
  800b13:	7e 16                	jle    800b2b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	8d 50 08             	lea    0x8(%eax),%edx
  800b1b:	89 55 14             	mov    %edx,0x14(%ebp)
  800b1e:	8b 50 04             	mov    0x4(%eax),%edx
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b26:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b29:	eb 32                	jmp    800b5d <vprintfmt+0x2df>
	else if (lflag)
  800b2b:	85 d2                	test   %edx,%edx
  800b2d:	74 18                	je     800b47 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b32:	8d 50 04             	lea    0x4(%eax),%edx
  800b35:	89 55 14             	mov    %edx,0x14(%ebp)
  800b38:	8b 30                	mov    (%eax),%esi
  800b3a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800b3d:	89 f0                	mov    %esi,%eax
  800b3f:	c1 f8 1f             	sar    $0x1f,%eax
  800b42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b45:	eb 16                	jmp    800b5d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	8d 50 04             	lea    0x4(%eax),%edx
  800b4d:	89 55 14             	mov    %edx,0x14(%ebp)
  800b50:	8b 30                	mov    (%eax),%esi
  800b52:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800b55:	89 f0                	mov    %esi,%eax
  800b57:	c1 f8 1f             	sar    $0x1f,%eax
  800b5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800b63:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800b68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6c:	0f 89 80 00 00 00    	jns    800bf2 <vprintfmt+0x374>
				putch('-', putdat);
  800b72:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b76:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b7d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800b80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b86:	f7 d8                	neg    %eax
  800b88:	83 d2 00             	adc    $0x0,%edx
  800b8b:	f7 da                	neg    %edx
			}
			base = 10;
  800b8d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800b92:	eb 5e                	jmp    800bf2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b94:	8d 45 14             	lea    0x14(%ebp),%eax
  800b97:	e8 63 fc ff ff       	call   8007ff <getuint>
			base = 10;
  800b9c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800ba1:	eb 4f                	jmp    800bf2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800ba3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba6:	e8 54 fc ff ff       	call   8007ff <getuint>
			base = 8;
  800bab:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800bb0:	eb 40                	jmp    800bf2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800bb2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bb6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800bbd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800bc0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bc4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800bcb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800bce:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd1:	8d 50 04             	lea    0x4(%eax),%edx
  800bd4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800bde:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800be3:	eb 0d                	jmp    800bf2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800be5:	8d 45 14             	lea    0x14(%ebp),%eax
  800be8:	e8 12 fc ff ff       	call   8007ff <getuint>
			base = 16;
  800bed:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800bf6:	89 74 24 10          	mov    %esi,0x10(%esp)
  800bfa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800bfd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800c01:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800c05:	89 04 24             	mov    %eax,(%esp)
  800c08:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c0c:	89 fa                	mov    %edi,%edx
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	e8 fa fa ff ff       	call   800710 <printnum>
			break;
  800c16:	e9 88 fc ff ff       	jmp    8008a3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c1b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c1f:	89 04 24             	mov    %eax,(%esp)
  800c22:	ff 55 08             	call   *0x8(%ebp)
			break;
  800c25:	e9 79 fc ff ff       	jmp    8008a3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c2a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c2e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800c35:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c38:	89 f3                	mov    %esi,%ebx
  800c3a:	eb 03                	jmp    800c3f <vprintfmt+0x3c1>
  800c3c:	83 eb 01             	sub    $0x1,%ebx
  800c3f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800c43:	75 f7                	jne    800c3c <vprintfmt+0x3be>
  800c45:	e9 59 fc ff ff       	jmp    8008a3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800c4a:	83 c4 3c             	add    $0x3c,%esp
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5f                   	pop    %edi
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    

00800c52 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	83 ec 28             	sub    $0x28,%esp
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c61:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c65:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c6f:	85 c0                	test   %eax,%eax
  800c71:	74 30                	je     800ca3 <vsnprintf+0x51>
  800c73:	85 d2                	test   %edx,%edx
  800c75:	7e 2c                	jle    800ca3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c77:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c85:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c8c:	c7 04 24 39 08 80 00 	movl   $0x800839,(%esp)
  800c93:	e8 e6 fb ff ff       	call   80087e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ca1:	eb 05                	jmp    800ca8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800ca3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cb0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cba:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	89 04 24             	mov    %eax,(%esp)
  800ccb:	e8 82 ff ff ff       	call   800c52 <vsnprintf>
	va_end(ap);

	return rc;
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    
  800cd2:	66 90                	xchg   %ax,%ax
  800cd4:	66 90                	xchg   %ax,%ax
  800cd6:	66 90                	xchg   %ax,%ax
  800cd8:	66 90                	xchg   %ax,%ax
  800cda:	66 90                	xchg   %ax,%ax
  800cdc:	66 90                	xchg   %ax,%ax
  800cde:	66 90                	xchg   %ax,%ax

00800ce0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ceb:	eb 03                	jmp    800cf0 <strlen+0x10>
		n++;
  800ced:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800cf4:	75 f7                	jne    800ced <strlen+0xd>
		n++;
	return n;
}
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    

00800cf8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cfe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d01:	b8 00 00 00 00       	mov    $0x0,%eax
  800d06:	eb 03                	jmp    800d0b <strnlen+0x13>
		n++;
  800d08:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d0b:	39 d0                	cmp    %edx,%eax
  800d0d:	74 06                	je     800d15 <strnlen+0x1d>
  800d0f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d13:	75 f3                	jne    800d08 <strnlen+0x10>
		n++;
	return n;
}
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	53                   	push   %ebx
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d21:	89 c2                	mov    %eax,%edx
  800d23:	83 c2 01             	add    $0x1,%edx
  800d26:	83 c1 01             	add    $0x1,%ecx
  800d29:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800d2d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d30:	84 db                	test   %bl,%bl
  800d32:	75 ef                	jne    800d23 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800d34:	5b                   	pop    %ebx
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	53                   	push   %ebx
  800d3b:	83 ec 08             	sub    $0x8,%esp
  800d3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d41:	89 1c 24             	mov    %ebx,(%esp)
  800d44:	e8 97 ff ff ff       	call   800ce0 <strlen>
	strcpy(dst + len, src);
  800d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d50:	01 d8                	add    %ebx,%eax
  800d52:	89 04 24             	mov    %eax,(%esp)
  800d55:	e8 bd ff ff ff       	call   800d17 <strcpy>
	return dst;
}
  800d5a:	89 d8                	mov    %ebx,%eax
  800d5c:	83 c4 08             	add    $0x8,%esp
  800d5f:	5b                   	pop    %ebx
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	56                   	push   %esi
  800d66:	53                   	push   %ebx
  800d67:	8b 75 08             	mov    0x8(%ebp),%esi
  800d6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6d:	89 f3                	mov    %esi,%ebx
  800d6f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d72:	89 f2                	mov    %esi,%edx
  800d74:	eb 0f                	jmp    800d85 <strncpy+0x23>
		*dst++ = *src;
  800d76:	83 c2 01             	add    $0x1,%edx
  800d79:	0f b6 01             	movzbl (%ecx),%eax
  800d7c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d7f:	80 39 01             	cmpb   $0x1,(%ecx)
  800d82:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d85:	39 da                	cmp    %ebx,%edx
  800d87:	75 ed                	jne    800d76 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d89:	89 f0                	mov    %esi,%eax
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	8b 75 08             	mov    0x8(%ebp),%esi
  800d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d9d:	89 f0                	mov    %esi,%eax
  800d9f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800da3:	85 c9                	test   %ecx,%ecx
  800da5:	75 0b                	jne    800db2 <strlcpy+0x23>
  800da7:	eb 1d                	jmp    800dc6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800da9:	83 c0 01             	add    $0x1,%eax
  800dac:	83 c2 01             	add    $0x1,%edx
  800daf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800db2:	39 d8                	cmp    %ebx,%eax
  800db4:	74 0b                	je     800dc1 <strlcpy+0x32>
  800db6:	0f b6 0a             	movzbl (%edx),%ecx
  800db9:	84 c9                	test   %cl,%cl
  800dbb:	75 ec                	jne    800da9 <strlcpy+0x1a>
  800dbd:	89 c2                	mov    %eax,%edx
  800dbf:	eb 02                	jmp    800dc3 <strlcpy+0x34>
  800dc1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800dc3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800dc6:	29 f0                	sub    %esi,%eax
}
  800dc8:	5b                   	pop    %ebx
  800dc9:	5e                   	pop    %esi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    

00800dcc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800dd5:	eb 06                	jmp    800ddd <strcmp+0x11>
		p++, q++;
  800dd7:	83 c1 01             	add    $0x1,%ecx
  800dda:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ddd:	0f b6 01             	movzbl (%ecx),%eax
  800de0:	84 c0                	test   %al,%al
  800de2:	74 04                	je     800de8 <strcmp+0x1c>
  800de4:	3a 02                	cmp    (%edx),%al
  800de6:	74 ef                	je     800dd7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de8:	0f b6 c0             	movzbl %al,%eax
  800deb:	0f b6 12             	movzbl (%edx),%edx
  800dee:	29 d0                	sub    %edx,%eax
}
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    

00800df2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	53                   	push   %ebx
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfc:	89 c3                	mov    %eax,%ebx
  800dfe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e01:	eb 06                	jmp    800e09 <strncmp+0x17>
		n--, p++, q++;
  800e03:	83 c0 01             	add    $0x1,%eax
  800e06:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800e09:	39 d8                	cmp    %ebx,%eax
  800e0b:	74 15                	je     800e22 <strncmp+0x30>
  800e0d:	0f b6 08             	movzbl (%eax),%ecx
  800e10:	84 c9                	test   %cl,%cl
  800e12:	74 04                	je     800e18 <strncmp+0x26>
  800e14:	3a 0a                	cmp    (%edx),%cl
  800e16:	74 eb                	je     800e03 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e18:	0f b6 00             	movzbl (%eax),%eax
  800e1b:	0f b6 12             	movzbl (%edx),%edx
  800e1e:	29 d0                	sub    %edx,%eax
  800e20:	eb 05                	jmp    800e27 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800e22:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800e27:	5b                   	pop    %ebx
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e34:	eb 07                	jmp    800e3d <strchr+0x13>
		if (*s == c)
  800e36:	38 ca                	cmp    %cl,%dl
  800e38:	74 0f                	je     800e49 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e3a:	83 c0 01             	add    $0x1,%eax
  800e3d:	0f b6 10             	movzbl (%eax),%edx
  800e40:	84 d2                	test   %dl,%dl
  800e42:	75 f2                	jne    800e36 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800e44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e55:	eb 07                	jmp    800e5e <strfind+0x13>
		if (*s == c)
  800e57:	38 ca                	cmp    %cl,%dl
  800e59:	74 0a                	je     800e65 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e5b:	83 c0 01             	add    $0x1,%eax
  800e5e:	0f b6 10             	movzbl (%eax),%edx
  800e61:	84 d2                	test   %dl,%dl
  800e63:	75 f2                	jne    800e57 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	57                   	push   %edi
  800e6b:	56                   	push   %esi
  800e6c:	53                   	push   %ebx
  800e6d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e70:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e73:	85 c9                	test   %ecx,%ecx
  800e75:	74 36                	je     800ead <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e77:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e7d:	75 28                	jne    800ea7 <memset+0x40>
  800e7f:	f6 c1 03             	test   $0x3,%cl
  800e82:	75 23                	jne    800ea7 <memset+0x40>
		c &= 0xFF;
  800e84:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e88:	89 d3                	mov    %edx,%ebx
  800e8a:	c1 e3 08             	shl    $0x8,%ebx
  800e8d:	89 d6                	mov    %edx,%esi
  800e8f:	c1 e6 18             	shl    $0x18,%esi
  800e92:	89 d0                	mov    %edx,%eax
  800e94:	c1 e0 10             	shl    $0x10,%eax
  800e97:	09 f0                	or     %esi,%eax
  800e99:	09 c2                	or     %eax,%edx
  800e9b:	89 d0                	mov    %edx,%eax
  800e9d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e9f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ea2:	fc                   	cld    
  800ea3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ea5:	eb 06                	jmp    800ead <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	fc                   	cld    
  800eab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ead:	89 f8                	mov    %edi,%eax
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5f                   	pop    %edi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    

00800eb4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	57                   	push   %edi
  800eb8:	56                   	push   %esi
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ebf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ec2:	39 c6                	cmp    %eax,%esi
  800ec4:	73 35                	jae    800efb <memmove+0x47>
  800ec6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ec9:	39 d0                	cmp    %edx,%eax
  800ecb:	73 2e                	jae    800efb <memmove+0x47>
		s += n;
		d += n;
  800ecd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ed0:	89 d6                	mov    %edx,%esi
  800ed2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ed4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800eda:	75 13                	jne    800eef <memmove+0x3b>
  800edc:	f6 c1 03             	test   $0x3,%cl
  800edf:	75 0e                	jne    800eef <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ee1:	83 ef 04             	sub    $0x4,%edi
  800ee4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ee7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800eea:	fd                   	std    
  800eeb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800eed:	eb 09                	jmp    800ef8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800eef:	83 ef 01             	sub    $0x1,%edi
  800ef2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ef5:	fd                   	std    
  800ef6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ef8:	fc                   	cld    
  800ef9:	eb 1d                	jmp    800f18 <memmove+0x64>
  800efb:	89 f2                	mov    %esi,%edx
  800efd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eff:	f6 c2 03             	test   $0x3,%dl
  800f02:	75 0f                	jne    800f13 <memmove+0x5f>
  800f04:	f6 c1 03             	test   $0x3,%cl
  800f07:	75 0a                	jne    800f13 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f09:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800f0c:	89 c7                	mov    %eax,%edi
  800f0e:	fc                   	cld    
  800f0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f11:	eb 05                	jmp    800f18 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f13:	89 c7                	mov    %eax,%edi
  800f15:	fc                   	cld    
  800f16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    

00800f1c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f22:	8b 45 10             	mov    0x10(%ebp),%eax
  800f25:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	89 04 24             	mov    %eax,(%esp)
  800f36:	e8 79 ff ff ff       	call   800eb4 <memmove>
}
  800f3b:	c9                   	leave  
  800f3c:	c3                   	ret    

00800f3d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	56                   	push   %esi
  800f41:	53                   	push   %ebx
  800f42:	8b 55 08             	mov    0x8(%ebp),%edx
  800f45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f48:	89 d6                	mov    %edx,%esi
  800f4a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f4d:	eb 1a                	jmp    800f69 <memcmp+0x2c>
		if (*s1 != *s2)
  800f4f:	0f b6 02             	movzbl (%edx),%eax
  800f52:	0f b6 19             	movzbl (%ecx),%ebx
  800f55:	38 d8                	cmp    %bl,%al
  800f57:	74 0a                	je     800f63 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800f59:	0f b6 c0             	movzbl %al,%eax
  800f5c:	0f b6 db             	movzbl %bl,%ebx
  800f5f:	29 d8                	sub    %ebx,%eax
  800f61:	eb 0f                	jmp    800f72 <memcmp+0x35>
		s1++, s2++;
  800f63:	83 c2 01             	add    $0x1,%edx
  800f66:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f69:	39 f2                	cmp    %esi,%edx
  800f6b:	75 e2                	jne    800f4f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f7f:	89 c2                	mov    %eax,%edx
  800f81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f84:	eb 07                	jmp    800f8d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f86:	38 08                	cmp    %cl,(%eax)
  800f88:	74 07                	je     800f91 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f8a:	83 c0 01             	add    $0x1,%eax
  800f8d:	39 d0                	cmp    %edx,%eax
  800f8f:	72 f5                	jb     800f86 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800f91:	5d                   	pop    %ebp
  800f92:	c3                   	ret    

00800f93 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	57                   	push   %edi
  800f97:	56                   	push   %esi
  800f98:	53                   	push   %ebx
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f9f:	eb 03                	jmp    800fa4 <strtol+0x11>
		s++;
  800fa1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fa4:	0f b6 0a             	movzbl (%edx),%ecx
  800fa7:	80 f9 09             	cmp    $0x9,%cl
  800faa:	74 f5                	je     800fa1 <strtol+0xe>
  800fac:	80 f9 20             	cmp    $0x20,%cl
  800faf:	74 f0                	je     800fa1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fb1:	80 f9 2b             	cmp    $0x2b,%cl
  800fb4:	75 0a                	jne    800fc0 <strtol+0x2d>
		s++;
  800fb6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800fb9:	bf 00 00 00 00       	mov    $0x0,%edi
  800fbe:	eb 11                	jmp    800fd1 <strtol+0x3e>
  800fc0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800fc5:	80 f9 2d             	cmp    $0x2d,%cl
  800fc8:	75 07                	jne    800fd1 <strtol+0x3e>
		s++, neg = 1;
  800fca:	8d 52 01             	lea    0x1(%edx),%edx
  800fcd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fd1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800fd6:	75 15                	jne    800fed <strtol+0x5a>
  800fd8:	80 3a 30             	cmpb   $0x30,(%edx)
  800fdb:	75 10                	jne    800fed <strtol+0x5a>
  800fdd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800fe1:	75 0a                	jne    800fed <strtol+0x5a>
		s += 2, base = 16;
  800fe3:	83 c2 02             	add    $0x2,%edx
  800fe6:	b8 10 00 00 00       	mov    $0x10,%eax
  800feb:	eb 10                	jmp    800ffd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800fed:	85 c0                	test   %eax,%eax
  800fef:	75 0c                	jne    800ffd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ff1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ff3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ff6:	75 05                	jne    800ffd <strtol+0x6a>
		s++, base = 8;
  800ff8:	83 c2 01             	add    $0x1,%edx
  800ffb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800ffd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801002:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801005:	0f b6 0a             	movzbl (%edx),%ecx
  801008:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80100b:	89 f0                	mov    %esi,%eax
  80100d:	3c 09                	cmp    $0x9,%al
  80100f:	77 08                	ja     801019 <strtol+0x86>
			dig = *s - '0';
  801011:	0f be c9             	movsbl %cl,%ecx
  801014:	83 e9 30             	sub    $0x30,%ecx
  801017:	eb 20                	jmp    801039 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801019:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80101c:	89 f0                	mov    %esi,%eax
  80101e:	3c 19                	cmp    $0x19,%al
  801020:	77 08                	ja     80102a <strtol+0x97>
			dig = *s - 'a' + 10;
  801022:	0f be c9             	movsbl %cl,%ecx
  801025:	83 e9 57             	sub    $0x57,%ecx
  801028:	eb 0f                	jmp    801039 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80102a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80102d:	89 f0                	mov    %esi,%eax
  80102f:	3c 19                	cmp    $0x19,%al
  801031:	77 16                	ja     801049 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801033:	0f be c9             	movsbl %cl,%ecx
  801036:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801039:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80103c:	7d 0f                	jge    80104d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80103e:	83 c2 01             	add    $0x1,%edx
  801041:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801045:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801047:	eb bc                	jmp    801005 <strtol+0x72>
  801049:	89 d8                	mov    %ebx,%eax
  80104b:	eb 02                	jmp    80104f <strtol+0xbc>
  80104d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80104f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801053:	74 05                	je     80105a <strtol+0xc7>
		*endptr = (char *) s;
  801055:	8b 75 0c             	mov    0xc(%ebp),%esi
  801058:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80105a:	f7 d8                	neg    %eax
  80105c:	85 ff                	test   %edi,%edi
  80105e:	0f 44 c3             	cmove  %ebx,%eax
}
  801061:	5b                   	pop    %ebx
  801062:	5e                   	pop    %esi
  801063:	5f                   	pop    %edi
  801064:	5d                   	pop    %ebp
  801065:	c3                   	ret    

00801066 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	57                   	push   %edi
  80106a:	56                   	push   %esi
  80106b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106c:	b8 00 00 00 00       	mov    $0x0,%eax
  801071:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801074:	8b 55 08             	mov    0x8(%ebp),%edx
  801077:	89 c3                	mov    %eax,%ebx
  801079:	89 c7                	mov    %eax,%edi
  80107b:	89 c6                	mov    %eax,%esi
  80107d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80107f:	5b                   	pop    %ebx
  801080:	5e                   	pop    %esi
  801081:	5f                   	pop    %edi
  801082:	5d                   	pop    %ebp
  801083:	c3                   	ret    

00801084 <sys_cgetc>:

int
sys_cgetc(void)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	57                   	push   %edi
  801088:	56                   	push   %esi
  801089:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108a:	ba 00 00 00 00       	mov    $0x0,%edx
  80108f:	b8 01 00 00 00       	mov    $0x1,%eax
  801094:	89 d1                	mov    %edx,%ecx
  801096:	89 d3                	mov    %edx,%ebx
  801098:	89 d7                	mov    %edx,%edi
  80109a:	89 d6                	mov    %edx,%esi
  80109c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80109e:	5b                   	pop    %ebx
  80109f:	5e                   	pop    %esi
  8010a0:	5f                   	pop    %edi
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    

008010a3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	57                   	push   %edi
  8010a7:	56                   	push   %esi
  8010a8:	53                   	push   %ebx
  8010a9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8010b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b9:	89 cb                	mov    %ecx,%ebx
  8010bb:	89 cf                	mov    %ecx,%edi
  8010bd:	89 ce                	mov    %ecx,%esi
  8010bf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	7e 28                	jle    8010ed <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8010d0:	00 
  8010d1:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  8010d8:	00 
  8010d9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e0:	00 
  8010e1:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  8010e8:	e8 0d f5 ff ff       	call   8005fa <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010ed:	83 c4 2c             	add    $0x2c,%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5f                   	pop    %edi
  8010f3:	5d                   	pop    %ebp
  8010f4:	c3                   	ret    

008010f5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	57                   	push   %edi
  8010f9:	56                   	push   %esi
  8010fa:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801100:	b8 02 00 00 00       	mov    $0x2,%eax
  801105:	89 d1                	mov    %edx,%ecx
  801107:	89 d3                	mov    %edx,%ebx
  801109:	89 d7                	mov    %edx,%edi
  80110b:	89 d6                	mov    %edx,%esi
  80110d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80110f:	5b                   	pop    %ebx
  801110:	5e                   	pop    %esi
  801111:	5f                   	pop    %edi
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <sys_yield>:

void
sys_yield(void)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	57                   	push   %edi
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80111a:	ba 00 00 00 00       	mov    $0x0,%edx
  80111f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801124:	89 d1                	mov    %edx,%ecx
  801126:	89 d3                	mov    %edx,%ebx
  801128:	89 d7                	mov    %edx,%edi
  80112a:	89 d6                	mov    %edx,%esi
  80112c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80112e:	5b                   	pop    %ebx
  80112f:	5e                   	pop    %esi
  801130:	5f                   	pop    %edi
  801131:	5d                   	pop    %ebp
  801132:	c3                   	ret    

00801133 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	57                   	push   %edi
  801137:	56                   	push   %esi
  801138:	53                   	push   %ebx
  801139:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80113c:	be 00 00 00 00       	mov    $0x0,%esi
  801141:	b8 04 00 00 00       	mov    $0x4,%eax
  801146:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801149:	8b 55 08             	mov    0x8(%ebp),%edx
  80114c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80114f:	89 f7                	mov    %esi,%edi
  801151:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801153:	85 c0                	test   %eax,%eax
  801155:	7e 28                	jle    80117f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801157:	89 44 24 10          	mov    %eax,0x10(%esp)
  80115b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801162:	00 
  801163:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  80116a:	00 
  80116b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801172:	00 
  801173:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  80117a:	e8 7b f4 ff ff       	call   8005fa <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80117f:	83 c4 2c             	add    $0x2c,%esp
  801182:	5b                   	pop    %ebx
  801183:	5e                   	pop    %esi
  801184:	5f                   	pop    %edi
  801185:	5d                   	pop    %ebp
  801186:	c3                   	ret    

00801187 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	57                   	push   %edi
  80118b:	56                   	push   %esi
  80118c:	53                   	push   %ebx
  80118d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801190:	b8 05 00 00 00       	mov    $0x5,%eax
  801195:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801198:	8b 55 08             	mov    0x8(%ebp),%edx
  80119b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80119e:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011a1:	8b 75 18             	mov    0x18(%ebp),%esi
  8011a4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	7e 28                	jle    8011d2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011aa:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011ae:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8011b5:	00 
  8011b6:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  8011bd:	00 
  8011be:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011c5:	00 
  8011c6:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  8011cd:	e8 28 f4 ff ff       	call   8005fa <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011d2:	83 c4 2c             	add    $0x2c,%esp
  8011d5:	5b                   	pop    %ebx
  8011d6:	5e                   	pop    %esi
  8011d7:	5f                   	pop    %edi
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    

008011da <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	57                   	push   %edi
  8011de:	56                   	push   %esi
  8011df:	53                   	push   %ebx
  8011e0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e8:	b8 06 00 00 00       	mov    $0x6,%eax
  8011ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f3:	89 df                	mov    %ebx,%edi
  8011f5:	89 de                	mov    %ebx,%esi
  8011f7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	7e 28                	jle    801225 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011fd:	89 44 24 10          	mov    %eax,0x10(%esp)
  801201:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801208:	00 
  801209:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  801210:	00 
  801211:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801218:	00 
  801219:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  801220:	e8 d5 f3 ff ff       	call   8005fa <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801225:	83 c4 2c             	add    $0x2c,%esp
  801228:	5b                   	pop    %ebx
  801229:	5e                   	pop    %esi
  80122a:	5f                   	pop    %edi
  80122b:	5d                   	pop    %ebp
  80122c:	c3                   	ret    

0080122d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	57                   	push   %edi
  801231:	56                   	push   %esi
  801232:	53                   	push   %ebx
  801233:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801236:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123b:	b8 08 00 00 00       	mov    $0x8,%eax
  801240:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801243:	8b 55 08             	mov    0x8(%ebp),%edx
  801246:	89 df                	mov    %ebx,%edi
  801248:	89 de                	mov    %ebx,%esi
  80124a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80124c:	85 c0                	test   %eax,%eax
  80124e:	7e 28                	jle    801278 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801250:	89 44 24 10          	mov    %eax,0x10(%esp)
  801254:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80125b:	00 
  80125c:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  801263:	00 
  801264:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80126b:	00 
  80126c:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  801273:	e8 82 f3 ff ff       	call   8005fa <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801278:	83 c4 2c             	add    $0x2c,%esp
  80127b:	5b                   	pop    %ebx
  80127c:	5e                   	pop    %esi
  80127d:	5f                   	pop    %edi
  80127e:	5d                   	pop    %ebp
  80127f:	c3                   	ret    

00801280 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	57                   	push   %edi
  801284:	56                   	push   %esi
  801285:	53                   	push   %ebx
  801286:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801289:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128e:	b8 09 00 00 00       	mov    $0x9,%eax
  801293:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801296:	8b 55 08             	mov    0x8(%ebp),%edx
  801299:	89 df                	mov    %ebx,%edi
  80129b:	89 de                	mov    %ebx,%esi
  80129d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80129f:	85 c0                	test   %eax,%eax
  8012a1:	7e 28                	jle    8012cb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012a7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8012ae:	00 
  8012af:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  8012b6:	00 
  8012b7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012be:	00 
  8012bf:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  8012c6:	e8 2f f3 ff ff       	call   8005fa <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012cb:	83 c4 2c             	add    $0x2c,%esp
  8012ce:	5b                   	pop    %ebx
  8012cf:	5e                   	pop    %esi
  8012d0:	5f                   	pop    %edi
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    

008012d3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	57                   	push   %edi
  8012d7:	56                   	push   %esi
  8012d8:	53                   	push   %ebx
  8012d9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ec:	89 df                	mov    %ebx,%edi
  8012ee:	89 de                	mov    %ebx,%esi
  8012f0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	7e 28                	jle    80131e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012f6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012fa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801301:	00 
  801302:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  801309:	00 
  80130a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801311:	00 
  801312:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  801319:	e8 dc f2 ff ff       	call   8005fa <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80131e:	83 c4 2c             	add    $0x2c,%esp
  801321:	5b                   	pop    %ebx
  801322:	5e                   	pop    %esi
  801323:	5f                   	pop    %edi
  801324:	5d                   	pop    %ebp
  801325:	c3                   	ret    

00801326 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	57                   	push   %edi
  80132a:	56                   	push   %esi
  80132b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80132c:	be 00 00 00 00       	mov    $0x0,%esi
  801331:	b8 0c 00 00 00       	mov    $0xc,%eax
  801336:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801339:	8b 55 08             	mov    0x8(%ebp),%edx
  80133c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80133f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801342:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801344:	5b                   	pop    %ebx
  801345:	5e                   	pop    %esi
  801346:	5f                   	pop    %edi
  801347:	5d                   	pop    %ebp
  801348:	c3                   	ret    

00801349 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	57                   	push   %edi
  80134d:	56                   	push   %esi
  80134e:	53                   	push   %ebx
  80134f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801352:	b9 00 00 00 00       	mov    $0x0,%ecx
  801357:	b8 0d 00 00 00       	mov    $0xd,%eax
  80135c:	8b 55 08             	mov    0x8(%ebp),%edx
  80135f:	89 cb                	mov    %ecx,%ebx
  801361:	89 cf                	mov    %ecx,%edi
  801363:	89 ce                	mov    %ecx,%esi
  801365:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801367:	85 c0                	test   %eax,%eax
  801369:	7e 28                	jle    801393 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80136b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80136f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801376:	00 
  801377:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  80137e:	00 
  80137f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801386:	00 
  801387:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  80138e:	e8 67 f2 ff ff       	call   8005fa <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801393:	83 c4 2c             	add    $0x2c,%esp
  801396:	5b                   	pop    %ebx
  801397:	5e                   	pop    %esi
  801398:	5f                   	pop    %edi
  801399:	5d                   	pop    %ebp
  80139a:	c3                   	ret    

0080139b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	57                   	push   %edi
  80139f:	56                   	push   %esi
  8013a0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8013ab:	89 d1                	mov    %edx,%ecx
  8013ad:	89 d3                	mov    %edx,%ebx
  8013af:	89 d7                	mov    %edx,%edi
  8013b1:	89 d6                	mov    %edx,%esi
  8013b3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8013b5:	5b                   	pop    %ebx
  8013b6:	5e                   	pop    %esi
  8013b7:	5f                   	pop    %edi
  8013b8:	5d                   	pop    %ebp
  8013b9:	c3                   	ret    

008013ba <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	57                   	push   %edi
  8013be:	56                   	push   %esi
  8013bf:	53                   	push   %ebx
  8013c0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8013cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d3:	89 df                	mov    %ebx,%edi
  8013d5:	89 de                	mov    %ebx,%esi
  8013d7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	7e 28                	jle    801405 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013e1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8013e8:	00 
  8013e9:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  8013f0:	00 
  8013f1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013f8:	00 
  8013f9:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  801400:	e8 f5 f1 ff ff       	call   8005fa <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  801405:	83 c4 2c             	add    $0x2c,%esp
  801408:	5b                   	pop    %ebx
  801409:	5e                   	pop    %esi
  80140a:	5f                   	pop    %edi
  80140b:	5d                   	pop    %ebp
  80140c:	c3                   	ret    

0080140d <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	57                   	push   %edi
  801411:	56                   	push   %esi
  801412:	53                   	push   %ebx
  801413:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801416:	bb 00 00 00 00       	mov    $0x0,%ebx
  80141b:	b8 10 00 00 00       	mov    $0x10,%eax
  801420:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801423:	8b 55 08             	mov    0x8(%ebp),%edx
  801426:	89 df                	mov    %ebx,%edi
  801428:	89 de                	mov    %ebx,%esi
  80142a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80142c:	85 c0                	test   %eax,%eax
  80142e:	7e 28                	jle    801458 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801430:	89 44 24 10          	mov    %eax,0x10(%esp)
  801434:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80143b:	00 
  80143c:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  801443:	00 
  801444:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80144b:	00 
  80144c:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  801453:	e8 a2 f1 ff ff       	call   8005fa <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  801458:	83 c4 2c             	add    $0x2c,%esp
  80145b:	5b                   	pop    %ebx
  80145c:	5e                   	pop    %esi
  80145d:	5f                   	pop    %edi
  80145e:	5d                   	pop    %ebp
  80145f:	c3                   	ret    

00801460 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	57                   	push   %edi
  801464:	56                   	push   %esi
  801465:	53                   	push   %ebx
  801466:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801469:	bb 00 00 00 00       	mov    $0x0,%ebx
  80146e:	b8 11 00 00 00       	mov    $0x11,%eax
  801473:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801476:	8b 55 08             	mov    0x8(%ebp),%edx
  801479:	89 df                	mov    %ebx,%edi
  80147b:	89 de                	mov    %ebx,%esi
  80147d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80147f:	85 c0                	test   %eax,%eax
  801481:	7e 28                	jle    8014ab <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801483:	89 44 24 10          	mov    %eax,0x10(%esp)
  801487:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  80148e:	00 
  80148f:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  801496:	00 
  801497:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80149e:	00 
  80149f:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  8014a6:	e8 4f f1 ff ff       	call   8005fa <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  8014ab:	83 c4 2c             	add    $0x2c,%esp
  8014ae:	5b                   	pop    %ebx
  8014af:	5e                   	pop    %esi
  8014b0:	5f                   	pop    %edi
  8014b1:	5d                   	pop    %ebp
  8014b2:	c3                   	ret    

008014b3 <sys_sleep>:

int
sys_sleep(int channel)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	57                   	push   %edi
  8014b7:	56                   	push   %esi
  8014b8:	53                   	push   %ebx
  8014b9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014c1:	b8 12 00 00 00       	mov    $0x12,%eax
  8014c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c9:	89 cb                	mov    %ecx,%ebx
  8014cb:	89 cf                	mov    %ecx,%edi
  8014cd:	89 ce                	mov    %ecx,%esi
  8014cf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	7e 28                	jle    8014fd <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014d9:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8014e0:	00 
  8014e1:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  8014e8:	00 
  8014e9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014f0:	00 
  8014f1:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  8014f8:	e8 fd f0 ff ff       	call   8005fa <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  8014fd:	83 c4 2c             	add    $0x2c,%esp
  801500:	5b                   	pop    %ebx
  801501:	5e                   	pop    %esi
  801502:	5f                   	pop    %edi
  801503:	5d                   	pop    %ebp
  801504:	c3                   	ret    

00801505 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	57                   	push   %edi
  801509:	56                   	push   %esi
  80150a:	53                   	push   %ebx
  80150b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80150e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801513:	b8 13 00 00 00       	mov    $0x13,%eax
  801518:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80151b:	8b 55 08             	mov    0x8(%ebp),%edx
  80151e:	89 df                	mov    %ebx,%edi
  801520:	89 de                	mov    %ebx,%esi
  801522:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801524:	85 c0                	test   %eax,%eax
  801526:	7e 28                	jle    801550 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801528:	89 44 24 10          	mov    %eax,0x10(%esp)
  80152c:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  801533:	00 
  801534:	c7 44 24 08 2b 31 80 	movl   $0x80312b,0x8(%esp)
  80153b:	00 
  80153c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801543:	00 
  801544:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  80154b:	e8 aa f0 ff ff       	call   8005fa <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  801550:	83 c4 2c             	add    $0x2c,%esp
  801553:	5b                   	pop    %ebx
  801554:	5e                   	pop    %esi
  801555:	5f                   	pop    %edi
  801556:	5d                   	pop    %ebp
  801557:	c3                   	ret    

00801558 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80155e:	83 3d b8 50 80 00 00 	cmpl   $0x0,0x8050b8
  801565:	75 70                	jne    8015d7 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  801567:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  80156e:	00 
  80156f:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801576:	ee 
  801577:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80157e:	e8 b0 fb ff ff       	call   801133 <sys_page_alloc>
		if (error < 0)
  801583:	85 c0                	test   %eax,%eax
  801585:	79 1c                	jns    8015a3 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  801587:	c7 44 24 08 58 31 80 	movl   $0x803158,0x8(%esp)
  80158e:	00 
  80158f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801596:	00 
  801597:	c7 04 24 ab 31 80 00 	movl   $0x8031ab,(%esp)
  80159e:	e8 57 f0 ff ff       	call   8005fa <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8015a3:	c7 44 24 04 e1 15 80 	movl   $0x8015e1,0x4(%esp)
  8015aa:	00 
  8015ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015b2:	e8 1c fd ff ff       	call   8012d3 <sys_env_set_pgfault_upcall>
		if (error < 0)
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	79 1c                	jns    8015d7 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  8015bb:	c7 44 24 08 80 31 80 	movl   $0x803180,0x8(%esp)
  8015c2:	00 
  8015c3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8015ca:	00 
  8015cb:	c7 04 24 ab 31 80 00 	movl   $0x8031ab,(%esp)
  8015d2:	e8 23 f0 ff ff       	call   8005fa <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	a3 b8 50 80 00       	mov    %eax,0x8050b8
}
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8015e1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8015e2:	a1 b8 50 80 00       	mov    0x8050b8,%eax
	call *%eax
  8015e7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8015e9:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  8015ec:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  8015f0:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  8015f5:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  8015f9:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  8015fb:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8015fe:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8015ff:	83 c4 04             	add    $0x4,%esp
	popfl
  801602:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801603:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801604:	c3                   	ret    
  801605:	66 90                	xchg   %ax,%ax
  801607:	66 90                	xchg   %ax,%ax
  801609:	66 90                	xchg   %ax,%ax
  80160b:	66 90                	xchg   %ax,%ax
  80160d:	66 90                	xchg   %ax,%ax
  80160f:	90                   	nop

00801610 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	05 00 00 00 30       	add    $0x30000000,%eax
  80161b:	c1 e8 0c             	shr    $0xc,%eax
}
  80161e:	5d                   	pop    %ebp
  80161f:	c3                   	ret    

00801620 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80162b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801630:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801635:	5d                   	pop    %ebp
  801636:	c3                   	ret    

00801637 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80163d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801642:	89 c2                	mov    %eax,%edx
  801644:	c1 ea 16             	shr    $0x16,%edx
  801647:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80164e:	f6 c2 01             	test   $0x1,%dl
  801651:	74 11                	je     801664 <fd_alloc+0x2d>
  801653:	89 c2                	mov    %eax,%edx
  801655:	c1 ea 0c             	shr    $0xc,%edx
  801658:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80165f:	f6 c2 01             	test   $0x1,%dl
  801662:	75 09                	jne    80166d <fd_alloc+0x36>
			*fd_store = fd;
  801664:	89 01                	mov    %eax,(%ecx)
			return 0;
  801666:	b8 00 00 00 00       	mov    $0x0,%eax
  80166b:	eb 17                	jmp    801684 <fd_alloc+0x4d>
  80166d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801672:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801677:	75 c9                	jne    801642 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801679:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80167f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801684:	5d                   	pop    %ebp
  801685:	c3                   	ret    

00801686 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80168c:	83 f8 1f             	cmp    $0x1f,%eax
  80168f:	77 36                	ja     8016c7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801691:	c1 e0 0c             	shl    $0xc,%eax
  801694:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801699:	89 c2                	mov    %eax,%edx
  80169b:	c1 ea 16             	shr    $0x16,%edx
  80169e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016a5:	f6 c2 01             	test   $0x1,%dl
  8016a8:	74 24                	je     8016ce <fd_lookup+0x48>
  8016aa:	89 c2                	mov    %eax,%edx
  8016ac:	c1 ea 0c             	shr    $0xc,%edx
  8016af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016b6:	f6 c2 01             	test   $0x1,%dl
  8016b9:	74 1a                	je     8016d5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016be:	89 02                	mov    %eax,(%edx)
	return 0;
  8016c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c5:	eb 13                	jmp    8016da <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016cc:	eb 0c                	jmp    8016da <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d3:	eb 05                	jmp    8016da <fd_lookup+0x54>
  8016d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8016da:	5d                   	pop    %ebp
  8016db:	c3                   	ret    

008016dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	83 ec 18             	sub    $0x18,%esp
  8016e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ea:	eb 13                	jmp    8016ff <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8016ec:	39 08                	cmp    %ecx,(%eax)
  8016ee:	75 0c                	jne    8016fc <dev_lookup+0x20>
			*dev = devtab[i];
  8016f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fa:	eb 38                	jmp    801734 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8016fc:	83 c2 01             	add    $0x1,%edx
  8016ff:	8b 04 95 38 32 80 00 	mov    0x803238(,%edx,4),%eax
  801706:	85 c0                	test   %eax,%eax
  801708:	75 e2                	jne    8016ec <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80170a:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80170f:	8b 40 48             	mov    0x48(%eax),%eax
  801712:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801716:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171a:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  801721:	e8 cd ef ff ff       	call   8006f3 <cprintf>
	*dev = 0;
  801726:	8b 45 0c             	mov    0xc(%ebp),%eax
  801729:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80172f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	56                   	push   %esi
  80173a:	53                   	push   %ebx
  80173b:	83 ec 20             	sub    $0x20,%esp
  80173e:	8b 75 08             	mov    0x8(%ebp),%esi
  801741:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801744:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801747:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80174b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801751:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801754:	89 04 24             	mov    %eax,(%esp)
  801757:	e8 2a ff ff ff       	call   801686 <fd_lookup>
  80175c:	85 c0                	test   %eax,%eax
  80175e:	78 05                	js     801765 <fd_close+0x2f>
	    || fd != fd2)
  801760:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801763:	74 0c                	je     801771 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801765:	84 db                	test   %bl,%bl
  801767:	ba 00 00 00 00       	mov    $0x0,%edx
  80176c:	0f 44 c2             	cmove  %edx,%eax
  80176f:	eb 3f                	jmp    8017b0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801771:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801774:	89 44 24 04          	mov    %eax,0x4(%esp)
  801778:	8b 06                	mov    (%esi),%eax
  80177a:	89 04 24             	mov    %eax,(%esp)
  80177d:	e8 5a ff ff ff       	call   8016dc <dev_lookup>
  801782:	89 c3                	mov    %eax,%ebx
  801784:	85 c0                	test   %eax,%eax
  801786:	78 16                	js     80179e <fd_close+0x68>
		if (dev->dev_close)
  801788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80178e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801793:	85 c0                	test   %eax,%eax
  801795:	74 07                	je     80179e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801797:	89 34 24             	mov    %esi,(%esp)
  80179a:	ff d0                	call   *%eax
  80179c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80179e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a9:	e8 2c fa ff ff       	call   8011da <sys_page_unmap>
	return r;
  8017ae:	89 d8                	mov    %ebx,%eax
}
  8017b0:	83 c4 20             	add    $0x20,%esp
  8017b3:	5b                   	pop    %ebx
  8017b4:	5e                   	pop    %esi
  8017b5:	5d                   	pop    %ebp
  8017b6:	c3                   	ret    

008017b7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	89 04 24             	mov    %eax,(%esp)
  8017ca:	e8 b7 fe ff ff       	call   801686 <fd_lookup>
  8017cf:	89 c2                	mov    %eax,%edx
  8017d1:	85 d2                	test   %edx,%edx
  8017d3:	78 13                	js     8017e8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8017d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017dc:	00 
  8017dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e0:	89 04 24             	mov    %eax,(%esp)
  8017e3:	e8 4e ff ff ff       	call   801736 <fd_close>
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <close_all>:

void
close_all(void)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	53                   	push   %ebx
  8017ee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017f6:	89 1c 24             	mov    %ebx,(%esp)
  8017f9:	e8 b9 ff ff ff       	call   8017b7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8017fe:	83 c3 01             	add    $0x1,%ebx
  801801:	83 fb 20             	cmp    $0x20,%ebx
  801804:	75 f0                	jne    8017f6 <close_all+0xc>
		close(i);
}
  801806:	83 c4 14             	add    $0x14,%esp
  801809:	5b                   	pop    %ebx
  80180a:	5d                   	pop    %ebp
  80180b:	c3                   	ret    

0080180c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	57                   	push   %edi
  801810:	56                   	push   %esi
  801811:	53                   	push   %ebx
  801812:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801815:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801818:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	89 04 24             	mov    %eax,(%esp)
  801822:	e8 5f fe ff ff       	call   801686 <fd_lookup>
  801827:	89 c2                	mov    %eax,%edx
  801829:	85 d2                	test   %edx,%edx
  80182b:	0f 88 e1 00 00 00    	js     801912 <dup+0x106>
		return r;
	close(newfdnum);
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	89 04 24             	mov    %eax,(%esp)
  801837:	e8 7b ff ff ff       	call   8017b7 <close>

	newfd = INDEX2FD(newfdnum);
  80183c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80183f:	c1 e3 0c             	shl    $0xc,%ebx
  801842:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801848:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80184b:	89 04 24             	mov    %eax,(%esp)
  80184e:	e8 cd fd ff ff       	call   801620 <fd2data>
  801853:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801855:	89 1c 24             	mov    %ebx,(%esp)
  801858:	e8 c3 fd ff ff       	call   801620 <fd2data>
  80185d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80185f:	89 f0                	mov    %esi,%eax
  801861:	c1 e8 16             	shr    $0x16,%eax
  801864:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80186b:	a8 01                	test   $0x1,%al
  80186d:	74 43                	je     8018b2 <dup+0xa6>
  80186f:	89 f0                	mov    %esi,%eax
  801871:	c1 e8 0c             	shr    $0xc,%eax
  801874:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80187b:	f6 c2 01             	test   $0x1,%dl
  80187e:	74 32                	je     8018b2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801880:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801887:	25 07 0e 00 00       	and    $0xe07,%eax
  80188c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801890:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801894:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80189b:	00 
  80189c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018a7:	e8 db f8 ff ff       	call   801187 <sys_page_map>
  8018ac:	89 c6                	mov    %eax,%esi
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	78 3e                	js     8018f0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018b5:	89 c2                	mov    %eax,%edx
  8018b7:	c1 ea 0c             	shr    $0xc,%edx
  8018ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018c1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8018c7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8018cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8018cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018d6:	00 
  8018d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018e2:	e8 a0 f8 ff ff       	call   801187 <sys_page_map>
  8018e7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8018e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018ec:	85 f6                	test   %esi,%esi
  8018ee:	79 22                	jns    801912 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8018f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018fb:	e8 da f8 ff ff       	call   8011da <sys_page_unmap>
	sys_page_unmap(0, nva);
  801900:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801904:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80190b:	e8 ca f8 ff ff       	call   8011da <sys_page_unmap>
	return r;
  801910:	89 f0                	mov    %esi,%eax
}
  801912:	83 c4 3c             	add    $0x3c,%esp
  801915:	5b                   	pop    %ebx
  801916:	5e                   	pop    %esi
  801917:	5f                   	pop    %edi
  801918:	5d                   	pop    %ebp
  801919:	c3                   	ret    

0080191a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	53                   	push   %ebx
  80191e:	83 ec 24             	sub    $0x24,%esp
  801921:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801924:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801927:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192b:	89 1c 24             	mov    %ebx,(%esp)
  80192e:	e8 53 fd ff ff       	call   801686 <fd_lookup>
  801933:	89 c2                	mov    %eax,%edx
  801935:	85 d2                	test   %edx,%edx
  801937:	78 6d                	js     8019a6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801939:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801943:	8b 00                	mov    (%eax),%eax
  801945:	89 04 24             	mov    %eax,(%esp)
  801948:	e8 8f fd ff ff       	call   8016dc <dev_lookup>
  80194d:	85 c0                	test   %eax,%eax
  80194f:	78 55                	js     8019a6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801954:	8b 50 08             	mov    0x8(%eax),%edx
  801957:	83 e2 03             	and    $0x3,%edx
  80195a:	83 fa 01             	cmp    $0x1,%edx
  80195d:	75 23                	jne    801982 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80195f:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801964:	8b 40 48             	mov    0x48(%eax),%eax
  801967:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80196b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196f:	c7 04 24 fd 31 80 00 	movl   $0x8031fd,(%esp)
  801976:	e8 78 ed ff ff       	call   8006f3 <cprintf>
		return -E_INVAL;
  80197b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801980:	eb 24                	jmp    8019a6 <read+0x8c>
	}
	if (!dev->dev_read)
  801982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801985:	8b 52 08             	mov    0x8(%edx),%edx
  801988:	85 d2                	test   %edx,%edx
  80198a:	74 15                	je     8019a1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80198c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801993:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801996:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80199a:	89 04 24             	mov    %eax,(%esp)
  80199d:	ff d2                	call   *%edx
  80199f:	eb 05                	jmp    8019a6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8019a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8019a6:	83 c4 24             	add    $0x24,%esp
  8019a9:	5b                   	pop    %ebx
  8019aa:	5d                   	pop    %ebp
  8019ab:	c3                   	ret    

008019ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	57                   	push   %edi
  8019b0:	56                   	push   %esi
  8019b1:	53                   	push   %ebx
  8019b2:	83 ec 1c             	sub    $0x1c,%esp
  8019b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019c0:	eb 23                	jmp    8019e5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019c2:	89 f0                	mov    %esi,%eax
  8019c4:	29 d8                	sub    %ebx,%eax
  8019c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019ca:	89 d8                	mov    %ebx,%eax
  8019cc:	03 45 0c             	add    0xc(%ebp),%eax
  8019cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d3:	89 3c 24             	mov    %edi,(%esp)
  8019d6:	e8 3f ff ff ff       	call   80191a <read>
		if (m < 0)
  8019db:	85 c0                	test   %eax,%eax
  8019dd:	78 10                	js     8019ef <readn+0x43>
			return m;
		if (m == 0)
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	74 0a                	je     8019ed <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019e3:	01 c3                	add    %eax,%ebx
  8019e5:	39 f3                	cmp    %esi,%ebx
  8019e7:	72 d9                	jb     8019c2 <readn+0x16>
  8019e9:	89 d8                	mov    %ebx,%eax
  8019eb:	eb 02                	jmp    8019ef <readn+0x43>
  8019ed:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8019ef:	83 c4 1c             	add    $0x1c,%esp
  8019f2:	5b                   	pop    %ebx
  8019f3:	5e                   	pop    %esi
  8019f4:	5f                   	pop    %edi
  8019f5:	5d                   	pop    %ebp
  8019f6:	c3                   	ret    

008019f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	53                   	push   %ebx
  8019fb:	83 ec 24             	sub    $0x24,%esp
  8019fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a01:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a08:	89 1c 24             	mov    %ebx,(%esp)
  801a0b:	e8 76 fc ff ff       	call   801686 <fd_lookup>
  801a10:	89 c2                	mov    %eax,%edx
  801a12:	85 d2                	test   %edx,%edx
  801a14:	78 68                	js     801a7e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a20:	8b 00                	mov    (%eax),%eax
  801a22:	89 04 24             	mov    %eax,(%esp)
  801a25:	e8 b2 fc ff ff       	call   8016dc <dev_lookup>
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 50                	js     801a7e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a31:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a35:	75 23                	jne    801a5a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a37:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801a3c:	8b 40 48             	mov    0x48(%eax),%eax
  801a3f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a47:	c7 04 24 19 32 80 00 	movl   $0x803219,(%esp)
  801a4e:	e8 a0 ec ff ff       	call   8006f3 <cprintf>
		return -E_INVAL;
  801a53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a58:	eb 24                	jmp    801a7e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a5d:	8b 52 0c             	mov    0xc(%edx),%edx
  801a60:	85 d2                	test   %edx,%edx
  801a62:	74 15                	je     801a79 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a72:	89 04 24             	mov    %eax,(%esp)
  801a75:	ff d2                	call   *%edx
  801a77:	eb 05                	jmp    801a7e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a79:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a7e:	83 c4 24             	add    $0x24,%esp
  801a81:	5b                   	pop    %ebx
  801a82:	5d                   	pop    %ebp
  801a83:	c3                   	ret    

00801a84 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a8a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	89 04 24             	mov    %eax,(%esp)
  801a97:	e8 ea fb ff ff       	call   801686 <fd_lookup>
  801a9c:	85 c0                	test   %eax,%eax
  801a9e:	78 0e                	js     801aae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	53                   	push   %ebx
  801ab4:	83 ec 24             	sub    $0x24,%esp
  801ab7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac1:	89 1c 24             	mov    %ebx,(%esp)
  801ac4:	e8 bd fb ff ff       	call   801686 <fd_lookup>
  801ac9:	89 c2                	mov    %eax,%edx
  801acb:	85 d2                	test   %edx,%edx
  801acd:	78 61                	js     801b30 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801acf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad9:	8b 00                	mov    (%eax),%eax
  801adb:	89 04 24             	mov    %eax,(%esp)
  801ade:	e8 f9 fb ff ff       	call   8016dc <dev_lookup>
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	78 49                	js     801b30 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801aee:	75 23                	jne    801b13 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801af0:	a1 b4 50 80 00       	mov    0x8050b4,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801af5:	8b 40 48             	mov    0x48(%eax),%eax
  801af8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b00:	c7 04 24 dc 31 80 00 	movl   $0x8031dc,(%esp)
  801b07:	e8 e7 eb ff ff       	call   8006f3 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801b0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b11:	eb 1d                	jmp    801b30 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b16:	8b 52 18             	mov    0x18(%edx),%edx
  801b19:	85 d2                	test   %edx,%edx
  801b1b:	74 0e                	je     801b2b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b20:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b24:	89 04 24             	mov    %eax,(%esp)
  801b27:	ff d2                	call   *%edx
  801b29:	eb 05                	jmp    801b30 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801b2b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801b30:	83 c4 24             	add    $0x24,%esp
  801b33:	5b                   	pop    %ebx
  801b34:	5d                   	pop    %ebp
  801b35:	c3                   	ret    

00801b36 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	53                   	push   %ebx
  801b3a:	83 ec 24             	sub    $0x24,%esp
  801b3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b40:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	89 04 24             	mov    %eax,(%esp)
  801b4d:	e8 34 fb ff ff       	call   801686 <fd_lookup>
  801b52:	89 c2                	mov    %eax,%edx
  801b54:	85 d2                	test   %edx,%edx
  801b56:	78 52                	js     801baa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b62:	8b 00                	mov    (%eax),%eax
  801b64:	89 04 24             	mov    %eax,(%esp)
  801b67:	e8 70 fb ff ff       	call   8016dc <dev_lookup>
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	78 3a                	js     801baa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b73:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b77:	74 2c                	je     801ba5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b79:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b7c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b83:	00 00 00 
	stat->st_isdir = 0;
  801b86:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b8d:	00 00 00 
	stat->st_dev = dev;
  801b90:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b9d:	89 14 24             	mov    %edx,(%esp)
  801ba0:	ff 50 14             	call   *0x14(%eax)
  801ba3:	eb 05                	jmp    801baa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801ba5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801baa:	83 c4 24             	add    $0x24,%esp
  801bad:	5b                   	pop    %ebx
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    

00801bb0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	56                   	push   %esi
  801bb4:	53                   	push   %ebx
  801bb5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bbf:	00 
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	89 04 24             	mov    %eax,(%esp)
  801bc6:	e8 1b 02 00 00       	call   801de6 <open>
  801bcb:	89 c3                	mov    %eax,%ebx
  801bcd:	85 db                	test   %ebx,%ebx
  801bcf:	78 1b                	js     801bec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd8:	89 1c 24             	mov    %ebx,(%esp)
  801bdb:	e8 56 ff ff ff       	call   801b36 <fstat>
  801be0:	89 c6                	mov    %eax,%esi
	close(fd);
  801be2:	89 1c 24             	mov    %ebx,(%esp)
  801be5:	e8 cd fb ff ff       	call   8017b7 <close>
	return r;
  801bea:	89 f0                	mov    %esi,%eax
}
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5d                   	pop    %ebp
  801bf2:	c3                   	ret    

00801bf3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	56                   	push   %esi
  801bf7:	53                   	push   %ebx
  801bf8:	83 ec 10             	sub    $0x10,%esp
  801bfb:	89 c6                	mov    %eax,%esi
  801bfd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bff:	83 3d ac 50 80 00 00 	cmpl   $0x0,0x8050ac
  801c06:	75 11                	jne    801c19 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c0f:	e8 7b 0d 00 00       	call   80298f <ipc_find_env>
  801c14:	a3 ac 50 80 00       	mov    %eax,0x8050ac
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c19:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c20:	00 
  801c21:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c28:	00 
  801c29:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c2d:	a1 ac 50 80 00       	mov    0x8050ac,%eax
  801c32:	89 04 24             	mov    %eax,(%esp)
  801c35:	e8 ea 0c 00 00       	call   802924 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c41:	00 
  801c42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c4d:	e8 7e 0c 00 00       	call   8028d0 <ipc_recv>
}
  801c52:	83 c4 10             	add    $0x10,%esp
  801c55:	5b                   	pop    %ebx
  801c56:	5e                   	pop    %esi
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    

00801c59 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	8b 40 0c             	mov    0xc(%eax),%eax
  801c65:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c72:	ba 00 00 00 00       	mov    $0x0,%edx
  801c77:	b8 02 00 00 00       	mov    $0x2,%eax
  801c7c:	e8 72 ff ff ff       	call   801bf3 <fsipc>
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c8f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c94:	ba 00 00 00 00       	mov    $0x0,%edx
  801c99:	b8 06 00 00 00       	mov    $0x6,%eax
  801c9e:	e8 50 ff ff ff       	call   801bf3 <fsipc>
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	53                   	push   %ebx
  801ca9:	83 ec 14             	sub    $0x14,%esp
  801cac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cba:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbf:	b8 05 00 00 00       	mov    $0x5,%eax
  801cc4:	e8 2a ff ff ff       	call   801bf3 <fsipc>
  801cc9:	89 c2                	mov    %eax,%edx
  801ccb:	85 d2                	test   %edx,%edx
  801ccd:	78 2b                	js     801cfa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ccf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cd6:	00 
  801cd7:	89 1c 24             	mov    %ebx,(%esp)
  801cda:	e8 38 f0 ff ff       	call   800d17 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cdf:	a1 80 60 80 00       	mov    0x806080,%eax
  801ce4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cea:	a1 84 60 80 00       	mov    0x806084,%eax
  801cef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801cf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cfa:	83 c4 14             	add    $0x14,%esp
  801cfd:	5b                   	pop    %ebx
  801cfe:	5d                   	pop    %ebp
  801cff:	c3                   	ret    

00801d00 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	83 ec 18             	sub    $0x18,%esp
  801d06:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d09:	8b 55 08             	mov    0x8(%ebp),%edx
  801d0c:	8b 52 0c             	mov    0xc(%edx),%edx
  801d0f:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  801d15:	a3 04 60 80 00       	mov    %eax,0x806004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d1a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d25:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801d2c:	e8 eb f1 ff ff       	call   800f1c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  801d31:	ba 00 00 00 00       	mov    $0x0,%edx
  801d36:	b8 04 00 00 00       	mov    $0x4,%eax
  801d3b:	e8 b3 fe ff ff       	call   801bf3 <fsipc>
		return r;
	}

	return r;
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	56                   	push   %esi
  801d46:	53                   	push   %ebx
  801d47:	83 ec 10             	sub    $0x10,%esp
  801d4a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	8b 40 0c             	mov    0xc(%eax),%eax
  801d53:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d58:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d63:	b8 03 00 00 00       	mov    $0x3,%eax
  801d68:	e8 86 fe ff ff       	call   801bf3 <fsipc>
  801d6d:	89 c3                	mov    %eax,%ebx
  801d6f:	85 c0                	test   %eax,%eax
  801d71:	78 6a                	js     801ddd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801d73:	39 c6                	cmp    %eax,%esi
  801d75:	73 24                	jae    801d9b <devfile_read+0x59>
  801d77:	c7 44 24 0c 4c 32 80 	movl   $0x80324c,0xc(%esp)
  801d7e:	00 
  801d7f:	c7 44 24 08 53 32 80 	movl   $0x803253,0x8(%esp)
  801d86:	00 
  801d87:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801d8e:	00 
  801d8f:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  801d96:	e8 5f e8 ff ff       	call   8005fa <_panic>
	assert(r <= PGSIZE);
  801d9b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801da0:	7e 24                	jle    801dc6 <devfile_read+0x84>
  801da2:	c7 44 24 0c 73 32 80 	movl   $0x803273,0xc(%esp)
  801da9:	00 
  801daa:	c7 44 24 08 53 32 80 	movl   $0x803253,0x8(%esp)
  801db1:	00 
  801db2:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801db9:	00 
  801dba:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  801dc1:	e8 34 e8 ff ff       	call   8005fa <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801dc6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dca:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801dd1:	00 
  801dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd5:	89 04 24             	mov    %eax,(%esp)
  801dd8:	e8 d7 f0 ff ff       	call   800eb4 <memmove>
	return r;
}
  801ddd:	89 d8                	mov    %ebx,%eax
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5e                   	pop    %esi
  801de4:	5d                   	pop    %ebp
  801de5:	c3                   	ret    

00801de6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	53                   	push   %ebx
  801dea:	83 ec 24             	sub    $0x24,%esp
  801ded:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801df0:	89 1c 24             	mov    %ebx,(%esp)
  801df3:	e8 e8 ee ff ff       	call   800ce0 <strlen>
  801df8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dfd:	7f 60                	jg     801e5f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801dff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e02:	89 04 24             	mov    %eax,(%esp)
  801e05:	e8 2d f8 ff ff       	call   801637 <fd_alloc>
  801e0a:	89 c2                	mov    %eax,%edx
  801e0c:	85 d2                	test   %edx,%edx
  801e0e:	78 54                	js     801e64 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801e10:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e14:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801e1b:	e8 f7 ee ff ff       	call   800d17 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e23:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e30:	e8 be fd ff ff       	call   801bf3 <fsipc>
  801e35:	89 c3                	mov    %eax,%ebx
  801e37:	85 c0                	test   %eax,%eax
  801e39:	79 17                	jns    801e52 <open+0x6c>
		fd_close(fd, 0);
  801e3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e42:	00 
  801e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e46:	89 04 24             	mov    %eax,(%esp)
  801e49:	e8 e8 f8 ff ff       	call   801736 <fd_close>
		return r;
  801e4e:	89 d8                	mov    %ebx,%eax
  801e50:	eb 12                	jmp    801e64 <open+0x7e>
	}

	return fd2num(fd);
  801e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e55:	89 04 24             	mov    %eax,(%esp)
  801e58:	e8 b3 f7 ff ff       	call   801610 <fd2num>
  801e5d:	eb 05                	jmp    801e64 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801e5f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801e64:	83 c4 24             	add    $0x24,%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5d                   	pop    %ebp
  801e69:	c3                   	ret    

00801e6a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e70:	ba 00 00 00 00       	mov    $0x0,%edx
  801e75:	b8 08 00 00 00       	mov    $0x8,%eax
  801e7a:	e8 74 fd ff ff       	call   801bf3 <fsipc>
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    
  801e81:	66 90                	xchg   %ax,%ax
  801e83:	66 90                	xchg   %ax,%ax
  801e85:	66 90                	xchg   %ax,%ax
  801e87:	66 90                	xchg   %ax,%ax
  801e89:	66 90                	xchg   %ax,%ax
  801e8b:	66 90                	xchg   %ax,%ax
  801e8d:	66 90                	xchg   %ax,%ax
  801e8f:	90                   	nop

00801e90 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e96:	c7 44 24 04 7f 32 80 	movl   $0x80327f,0x4(%esp)
  801e9d:	00 
  801e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea1:	89 04 24             	mov    %eax,(%esp)
  801ea4:	e8 6e ee ff ff       	call   800d17 <strcpy>
	return 0;
}
  801ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	53                   	push   %ebx
  801eb4:	83 ec 14             	sub    $0x14,%esp
  801eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801eba:	89 1c 24             	mov    %ebx,(%esp)
  801ebd:	e8 0c 0b 00 00       	call   8029ce <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801ec2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801ec7:	83 f8 01             	cmp    $0x1,%eax
  801eca:	75 0d                	jne    801ed9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801ecc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801ecf:	89 04 24             	mov    %eax,(%esp)
  801ed2:	e8 29 03 00 00       	call   802200 <nsipc_close>
  801ed7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801ed9:	89 d0                	mov    %edx,%eax
  801edb:	83 c4 14             	add    $0x14,%esp
  801ede:	5b                   	pop    %ebx
  801edf:	5d                   	pop    %ebp
  801ee0:	c3                   	ret    

00801ee1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ee7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801eee:	00 
  801eef:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801efd:	8b 45 08             	mov    0x8(%ebp),%eax
  801f00:	8b 40 0c             	mov    0xc(%eax),%eax
  801f03:	89 04 24             	mov    %eax,(%esp)
  801f06:	e8 f0 03 00 00       	call   8022fb <nsipc_send>
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f13:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f1a:	00 
  801f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f2f:	89 04 24             	mov    %eax,(%esp)
  801f32:	e8 44 03 00 00       	call   80227b <nsipc_recv>
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f3f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f42:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f46:	89 04 24             	mov    %eax,(%esp)
  801f49:	e8 38 f7 ff ff       	call   801686 <fd_lookup>
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	78 17                	js     801f69 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f5b:	39 08                	cmp    %ecx,(%eax)
  801f5d:	75 05                	jne    801f64 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801f5f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f62:	eb 05                	jmp    801f69 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801f64:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	56                   	push   %esi
  801f6f:	53                   	push   %ebx
  801f70:	83 ec 20             	sub    $0x20,%esp
  801f73:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f78:	89 04 24             	mov    %eax,(%esp)
  801f7b:	e8 b7 f6 ff ff       	call   801637 <fd_alloc>
  801f80:	89 c3                	mov    %eax,%ebx
  801f82:	85 c0                	test   %eax,%eax
  801f84:	78 21                	js     801fa7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f86:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f8d:	00 
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f9c:	e8 92 f1 ff ff       	call   801133 <sys_page_alloc>
  801fa1:	89 c3                	mov    %eax,%ebx
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	79 0c                	jns    801fb3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801fa7:	89 34 24             	mov    %esi,(%esp)
  801faa:	e8 51 02 00 00       	call   802200 <nsipc_close>
		return r;
  801faf:	89 d8                	mov    %ebx,%eax
  801fb1:	eb 20                	jmp    801fd3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801fb3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801fc8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801fcb:	89 14 24             	mov    %edx,(%esp)
  801fce:	e8 3d f6 ff ff       	call   801610 <fd2num>
}
  801fd3:	83 c4 20             	add    $0x20,%esp
  801fd6:	5b                   	pop    %ebx
  801fd7:	5e                   	pop    %esi
  801fd8:	5d                   	pop    %ebp
  801fd9:	c3                   	ret    

00801fda <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	e8 51 ff ff ff       	call   801f39 <fd2sockid>
		return r;
  801fe8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fea:	85 c0                	test   %eax,%eax
  801fec:	78 23                	js     802011 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fee:	8b 55 10             	mov    0x10(%ebp),%edx
  801ff1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ff5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ffc:	89 04 24             	mov    %eax,(%esp)
  801fff:	e8 45 01 00 00       	call   802149 <nsipc_accept>
		return r;
  802004:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802006:	85 c0                	test   %eax,%eax
  802008:	78 07                	js     802011 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80200a:	e8 5c ff ff ff       	call   801f6b <alloc_sockfd>
  80200f:	89 c1                	mov    %eax,%ecx
}
  802011:	89 c8                	mov    %ecx,%eax
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	e8 16 ff ff ff       	call   801f39 <fd2sockid>
  802023:	89 c2                	mov    %eax,%edx
  802025:	85 d2                	test   %edx,%edx
  802027:	78 16                	js     80203f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802029:	8b 45 10             	mov    0x10(%ebp),%eax
  80202c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802030:	8b 45 0c             	mov    0xc(%ebp),%eax
  802033:	89 44 24 04          	mov    %eax,0x4(%esp)
  802037:	89 14 24             	mov    %edx,(%esp)
  80203a:	e8 60 01 00 00       	call   80219f <nsipc_bind>
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <shutdown>:

int
shutdown(int s, int how)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	e8 ea fe ff ff       	call   801f39 <fd2sockid>
  80204f:	89 c2                	mov    %eax,%edx
  802051:	85 d2                	test   %edx,%edx
  802053:	78 0f                	js     802064 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802055:	8b 45 0c             	mov    0xc(%ebp),%eax
  802058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205c:	89 14 24             	mov    %edx,(%esp)
  80205f:	e8 7a 01 00 00       	call   8021de <nsipc_shutdown>
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	e8 c5 fe ff ff       	call   801f39 <fd2sockid>
  802074:	89 c2                	mov    %eax,%edx
  802076:	85 d2                	test   %edx,%edx
  802078:	78 16                	js     802090 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80207a:	8b 45 10             	mov    0x10(%ebp),%eax
  80207d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802081:	8b 45 0c             	mov    0xc(%ebp),%eax
  802084:	89 44 24 04          	mov    %eax,0x4(%esp)
  802088:	89 14 24             	mov    %edx,(%esp)
  80208b:	e8 8a 01 00 00       	call   80221a <nsipc_connect>
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <listen>:

int
listen(int s, int backlog)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	e8 99 fe ff ff       	call   801f39 <fd2sockid>
  8020a0:	89 c2                	mov    %eax,%edx
  8020a2:	85 d2                	test   %edx,%edx
  8020a4:	78 0f                	js     8020b5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8020a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ad:	89 14 24             	mov    %edx,(%esp)
  8020b0:	e8 a4 01 00 00       	call   802259 <nsipc_listen>
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	89 04 24             	mov    %eax,(%esp)
  8020d1:	e8 98 02 00 00       	call   80236e <nsipc_socket>
  8020d6:	89 c2                	mov    %eax,%edx
  8020d8:	85 d2                	test   %edx,%edx
  8020da:	78 05                	js     8020e1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8020dc:	e8 8a fe ff ff       	call   801f6b <alloc_sockfd>
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	53                   	push   %ebx
  8020e7:	83 ec 14             	sub    $0x14,%esp
  8020ea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020ec:	83 3d b0 50 80 00 00 	cmpl   $0x0,0x8050b0
  8020f3:	75 11                	jne    802106 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020f5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8020fc:	e8 8e 08 00 00       	call   80298f <ipc_find_env>
  802101:	a3 b0 50 80 00       	mov    %eax,0x8050b0
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802106:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80210d:	00 
  80210e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802115:	00 
  802116:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80211a:	a1 b0 50 80 00       	mov    0x8050b0,%eax
  80211f:	89 04 24             	mov    %eax,(%esp)
  802122:	e8 fd 07 00 00       	call   802924 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802127:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80212e:	00 
  80212f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802136:	00 
  802137:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80213e:	e8 8d 07 00 00       	call   8028d0 <ipc_recv>
}
  802143:	83 c4 14             	add    $0x14,%esp
  802146:	5b                   	pop    %ebx
  802147:	5d                   	pop    %ebp
  802148:	c3                   	ret    

00802149 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	56                   	push   %esi
  80214d:	53                   	push   %ebx
  80214e:	83 ec 10             	sub    $0x10,%esp
  802151:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80215c:	8b 06                	mov    (%esi),%eax
  80215e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802163:	b8 01 00 00 00       	mov    $0x1,%eax
  802168:	e8 76 ff ff ff       	call   8020e3 <nsipc>
  80216d:	89 c3                	mov    %eax,%ebx
  80216f:	85 c0                	test   %eax,%eax
  802171:	78 23                	js     802196 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802173:	a1 10 70 80 00       	mov    0x807010,%eax
  802178:	89 44 24 08          	mov    %eax,0x8(%esp)
  80217c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802183:	00 
  802184:	8b 45 0c             	mov    0xc(%ebp),%eax
  802187:	89 04 24             	mov    %eax,(%esp)
  80218a:	e8 25 ed ff ff       	call   800eb4 <memmove>
		*addrlen = ret->ret_addrlen;
  80218f:	a1 10 70 80 00       	mov    0x807010,%eax
  802194:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802196:	89 d8                	mov    %ebx,%eax
  802198:	83 c4 10             	add    $0x10,%esp
  80219b:	5b                   	pop    %ebx
  80219c:	5e                   	pop    %esi
  80219d:	5d                   	pop    %ebp
  80219e:	c3                   	ret    

0080219f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
  8021a2:	53                   	push   %ebx
  8021a3:	83 ec 14             	sub    $0x14,%esp
  8021a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021bc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8021c3:	e8 ec ec ff ff       	call   800eb4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021c8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8021d3:	e8 0b ff ff ff       	call   8020e3 <nsipc>
}
  8021d8:	83 c4 14             	add    $0x14,%esp
  8021db:	5b                   	pop    %ebx
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    

008021de <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ef:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8021f9:	e8 e5 fe ff ff       	call   8020e3 <nsipc>
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <nsipc_close>:

int
nsipc_close(int s)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80220e:	b8 04 00 00 00       	mov    $0x4,%eax
  802213:	e8 cb fe ff ff       	call   8020e3 <nsipc>
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	53                   	push   %ebx
  80221e:	83 ec 14             	sub    $0x14,%esp
  802221:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80222c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802230:	8b 45 0c             	mov    0xc(%ebp),%eax
  802233:	89 44 24 04          	mov    %eax,0x4(%esp)
  802237:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80223e:	e8 71 ec ff ff       	call   800eb4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802243:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802249:	b8 05 00 00 00       	mov    $0x5,%eax
  80224e:	e8 90 fe ff ff       	call   8020e3 <nsipc>
}
  802253:	83 c4 14             	add    $0x14,%esp
  802256:	5b                   	pop    %ebx
  802257:	5d                   	pop    %ebp
  802258:	c3                   	ret    

00802259 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
  80225c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80226f:	b8 06 00 00 00       	mov    $0x6,%eax
  802274:	e8 6a fe ff ff       	call   8020e3 <nsipc>
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	56                   	push   %esi
  80227f:	53                   	push   %ebx
  802280:	83 ec 10             	sub    $0x10,%esp
  802283:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80228e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802294:	8b 45 14             	mov    0x14(%ebp),%eax
  802297:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80229c:	b8 07 00 00 00       	mov    $0x7,%eax
  8022a1:	e8 3d fe ff ff       	call   8020e3 <nsipc>
  8022a6:	89 c3                	mov    %eax,%ebx
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	78 46                	js     8022f2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8022ac:	39 f0                	cmp    %esi,%eax
  8022ae:	7f 07                	jg     8022b7 <nsipc_recv+0x3c>
  8022b0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022b5:	7e 24                	jle    8022db <nsipc_recv+0x60>
  8022b7:	c7 44 24 0c 8b 32 80 	movl   $0x80328b,0xc(%esp)
  8022be:	00 
  8022bf:	c7 44 24 08 53 32 80 	movl   $0x803253,0x8(%esp)
  8022c6:	00 
  8022c7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8022ce:	00 
  8022cf:	c7 04 24 a0 32 80 00 	movl   $0x8032a0,(%esp)
  8022d6:	e8 1f e3 ff ff       	call   8005fa <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022df:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8022e6:	00 
  8022e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ea:	89 04 24             	mov    %eax,(%esp)
  8022ed:	e8 c2 eb ff ff       	call   800eb4 <memmove>
	}

	return r;
}
  8022f2:	89 d8                	mov    %ebx,%eax
  8022f4:	83 c4 10             	add    $0x10,%esp
  8022f7:	5b                   	pop    %ebx
  8022f8:	5e                   	pop    %esi
  8022f9:	5d                   	pop    %ebp
  8022fa:	c3                   	ret    

008022fb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	53                   	push   %ebx
  8022ff:	83 ec 14             	sub    $0x14,%esp
  802302:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80230d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802313:	7e 24                	jle    802339 <nsipc_send+0x3e>
  802315:	c7 44 24 0c ac 32 80 	movl   $0x8032ac,0xc(%esp)
  80231c:	00 
  80231d:	c7 44 24 08 53 32 80 	movl   $0x803253,0x8(%esp)
  802324:	00 
  802325:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80232c:	00 
  80232d:	c7 04 24 a0 32 80 00 	movl   $0x8032a0,(%esp)
  802334:	e8 c1 e2 ff ff       	call   8005fa <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802339:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80233d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802340:	89 44 24 04          	mov    %eax,0x4(%esp)
  802344:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80234b:	e8 64 eb ff ff       	call   800eb4 <memmove>
	nsipcbuf.send.req_size = size;
  802350:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802356:	8b 45 14             	mov    0x14(%ebp),%eax
  802359:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80235e:	b8 08 00 00 00       	mov    $0x8,%eax
  802363:	e8 7b fd ff ff       	call   8020e3 <nsipc>
}
  802368:	83 c4 14             	add    $0x14,%esp
  80236b:	5b                   	pop    %ebx
  80236c:	5d                   	pop    %ebp
  80236d:	c3                   	ret    

0080236e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80237c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802384:	8b 45 10             	mov    0x10(%ebp),%eax
  802387:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80238c:	b8 09 00 00 00       	mov    $0x9,%eax
  802391:	e8 4d fd ff ff       	call   8020e3 <nsipc>
}
  802396:	c9                   	leave  
  802397:	c3                   	ret    

00802398 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802398:	55                   	push   %ebp
  802399:	89 e5                	mov    %esp,%ebp
  80239b:	56                   	push   %esi
  80239c:	53                   	push   %ebx
  80239d:	83 ec 10             	sub    $0x10,%esp
  8023a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	89 04 24             	mov    %eax,(%esp)
  8023a9:	e8 72 f2 ff ff       	call   801620 <fd2data>
  8023ae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023b0:	c7 44 24 04 b8 32 80 	movl   $0x8032b8,0x4(%esp)
  8023b7:	00 
  8023b8:	89 1c 24             	mov    %ebx,(%esp)
  8023bb:	e8 57 e9 ff ff       	call   800d17 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023c0:	8b 46 04             	mov    0x4(%esi),%eax
  8023c3:	2b 06                	sub    (%esi),%eax
  8023c5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023d2:	00 00 00 
	stat->st_dev = &devpipe;
  8023d5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023dc:	40 80 00 
	return 0;
}
  8023df:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e4:	83 c4 10             	add    $0x10,%esp
  8023e7:	5b                   	pop    %ebx
  8023e8:	5e                   	pop    %esi
  8023e9:	5d                   	pop    %ebp
  8023ea:	c3                   	ret    

008023eb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	53                   	push   %ebx
  8023ef:	83 ec 14             	sub    $0x14,%esp
  8023f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802400:	e8 d5 ed ff ff       	call   8011da <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802405:	89 1c 24             	mov    %ebx,(%esp)
  802408:	e8 13 f2 ff ff       	call   801620 <fd2data>
  80240d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802411:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802418:	e8 bd ed ff ff       	call   8011da <sys_page_unmap>
}
  80241d:	83 c4 14             	add    $0x14,%esp
  802420:	5b                   	pop    %ebx
  802421:	5d                   	pop    %ebp
  802422:	c3                   	ret    

00802423 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
  802426:	57                   	push   %edi
  802427:	56                   	push   %esi
  802428:	53                   	push   %ebx
  802429:	83 ec 2c             	sub    $0x2c,%esp
  80242c:	89 c6                	mov    %eax,%esi
  80242e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802431:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802436:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802439:	89 34 24             	mov    %esi,(%esp)
  80243c:	e8 8d 05 00 00       	call   8029ce <pageref>
  802441:	89 c7                	mov    %eax,%edi
  802443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802446:	89 04 24             	mov    %eax,(%esp)
  802449:	e8 80 05 00 00       	call   8029ce <pageref>
  80244e:	39 c7                	cmp    %eax,%edi
  802450:	0f 94 c2             	sete   %dl
  802453:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802456:	8b 0d b4 50 80 00    	mov    0x8050b4,%ecx
  80245c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80245f:	39 fb                	cmp    %edi,%ebx
  802461:	74 21                	je     802484 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802463:	84 d2                	test   %dl,%dl
  802465:	74 ca                	je     802431 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802467:	8b 51 58             	mov    0x58(%ecx),%edx
  80246a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80246e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802472:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802476:	c7 04 24 bf 32 80 00 	movl   $0x8032bf,(%esp)
  80247d:	e8 71 e2 ff ff       	call   8006f3 <cprintf>
  802482:	eb ad                	jmp    802431 <_pipeisclosed+0xe>
	}
}
  802484:	83 c4 2c             	add    $0x2c,%esp
  802487:	5b                   	pop    %ebx
  802488:	5e                   	pop    %esi
  802489:	5f                   	pop    %edi
  80248a:	5d                   	pop    %ebp
  80248b:	c3                   	ret    

0080248c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	57                   	push   %edi
  802490:	56                   	push   %esi
  802491:	53                   	push   %ebx
  802492:	83 ec 1c             	sub    $0x1c,%esp
  802495:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802498:	89 34 24             	mov    %esi,(%esp)
  80249b:	e8 80 f1 ff ff       	call   801620 <fd2data>
  8024a0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024a7:	eb 45                	jmp    8024ee <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8024a9:	89 da                	mov    %ebx,%edx
  8024ab:	89 f0                	mov    %esi,%eax
  8024ad:	e8 71 ff ff ff       	call   802423 <_pipeisclosed>
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	75 41                	jne    8024f7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8024b6:	e8 59 ec ff ff       	call   801114 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024bb:	8b 43 04             	mov    0x4(%ebx),%eax
  8024be:	8b 0b                	mov    (%ebx),%ecx
  8024c0:	8d 51 20             	lea    0x20(%ecx),%edx
  8024c3:	39 d0                	cmp    %edx,%eax
  8024c5:	73 e2                	jae    8024a9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024ca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024ce:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024d1:	99                   	cltd   
  8024d2:	c1 ea 1b             	shr    $0x1b,%edx
  8024d5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8024d8:	83 e1 1f             	and    $0x1f,%ecx
  8024db:	29 d1                	sub    %edx,%ecx
  8024dd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8024e1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8024e5:	83 c0 01             	add    $0x1,%eax
  8024e8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024eb:	83 c7 01             	add    $0x1,%edi
  8024ee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024f1:	75 c8                	jne    8024bb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8024f3:	89 f8                	mov    %edi,%eax
  8024f5:	eb 05                	jmp    8024fc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024f7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8024fc:	83 c4 1c             	add    $0x1c,%esp
  8024ff:	5b                   	pop    %ebx
  802500:	5e                   	pop    %esi
  802501:	5f                   	pop    %edi
  802502:	5d                   	pop    %ebp
  802503:	c3                   	ret    

00802504 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
  802507:	57                   	push   %edi
  802508:	56                   	push   %esi
  802509:	53                   	push   %ebx
  80250a:	83 ec 1c             	sub    $0x1c,%esp
  80250d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802510:	89 3c 24             	mov    %edi,(%esp)
  802513:	e8 08 f1 ff ff       	call   801620 <fd2data>
  802518:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80251a:	be 00 00 00 00       	mov    $0x0,%esi
  80251f:	eb 3d                	jmp    80255e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802521:	85 f6                	test   %esi,%esi
  802523:	74 04                	je     802529 <devpipe_read+0x25>
				return i;
  802525:	89 f0                	mov    %esi,%eax
  802527:	eb 43                	jmp    80256c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802529:	89 da                	mov    %ebx,%edx
  80252b:	89 f8                	mov    %edi,%eax
  80252d:	e8 f1 fe ff ff       	call   802423 <_pipeisclosed>
  802532:	85 c0                	test   %eax,%eax
  802534:	75 31                	jne    802567 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802536:	e8 d9 eb ff ff       	call   801114 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80253b:	8b 03                	mov    (%ebx),%eax
  80253d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802540:	74 df                	je     802521 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802542:	99                   	cltd   
  802543:	c1 ea 1b             	shr    $0x1b,%edx
  802546:	01 d0                	add    %edx,%eax
  802548:	83 e0 1f             	and    $0x1f,%eax
  80254b:	29 d0                	sub    %edx,%eax
  80254d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802552:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802555:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802558:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80255b:	83 c6 01             	add    $0x1,%esi
  80255e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802561:	75 d8                	jne    80253b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802563:	89 f0                	mov    %esi,%eax
  802565:	eb 05                	jmp    80256c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802567:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80256c:	83 c4 1c             	add    $0x1c,%esp
  80256f:	5b                   	pop    %ebx
  802570:	5e                   	pop    %esi
  802571:	5f                   	pop    %edi
  802572:	5d                   	pop    %ebp
  802573:	c3                   	ret    

00802574 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
  802577:	56                   	push   %esi
  802578:	53                   	push   %ebx
  802579:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80257c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80257f:	89 04 24             	mov    %eax,(%esp)
  802582:	e8 b0 f0 ff ff       	call   801637 <fd_alloc>
  802587:	89 c2                	mov    %eax,%edx
  802589:	85 d2                	test   %edx,%edx
  80258b:	0f 88 4d 01 00 00    	js     8026de <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802591:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802598:	00 
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a7:	e8 87 eb ff ff       	call   801133 <sys_page_alloc>
  8025ac:	89 c2                	mov    %eax,%edx
  8025ae:	85 d2                	test   %edx,%edx
  8025b0:	0f 88 28 01 00 00    	js     8026de <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8025b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025b9:	89 04 24             	mov    %eax,(%esp)
  8025bc:	e8 76 f0 ff ff       	call   801637 <fd_alloc>
  8025c1:	89 c3                	mov    %eax,%ebx
  8025c3:	85 c0                	test   %eax,%eax
  8025c5:	0f 88 fe 00 00 00    	js     8026c9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025cb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025d2:	00 
  8025d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025e1:	e8 4d eb ff ff       	call   801133 <sys_page_alloc>
  8025e6:	89 c3                	mov    %eax,%ebx
  8025e8:	85 c0                	test   %eax,%eax
  8025ea:	0f 88 d9 00 00 00    	js     8026c9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	89 04 24             	mov    %eax,(%esp)
  8025f6:	e8 25 f0 ff ff       	call   801620 <fd2data>
  8025fb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025fd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802604:	00 
  802605:	89 44 24 04          	mov    %eax,0x4(%esp)
  802609:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802610:	e8 1e eb ff ff       	call   801133 <sys_page_alloc>
  802615:	89 c3                	mov    %eax,%ebx
  802617:	85 c0                	test   %eax,%eax
  802619:	0f 88 97 00 00 00    	js     8026b6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80261f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802622:	89 04 24             	mov    %eax,(%esp)
  802625:	e8 f6 ef ff ff       	call   801620 <fd2data>
  80262a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802631:	00 
  802632:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802636:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80263d:	00 
  80263e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802642:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802649:	e8 39 eb ff ff       	call   801187 <sys_page_map>
  80264e:	89 c3                	mov    %eax,%ebx
  802650:	85 c0                	test   %eax,%eax
  802652:	78 52                	js     8026a6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802654:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802669:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80266f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802672:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802677:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	89 04 24             	mov    %eax,(%esp)
  802684:	e8 87 ef ff ff       	call   801610 <fd2num>
  802689:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80268c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80268e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802691:	89 04 24             	mov    %eax,(%esp)
  802694:	e8 77 ef ff ff       	call   801610 <fd2num>
  802699:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80269c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80269f:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a4:	eb 38                	jmp    8026de <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8026a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b1:	e8 24 eb ff ff       	call   8011da <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8026b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c4:	e8 11 eb ff ff       	call   8011da <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026d7:	e8 fe ea ff ff       	call   8011da <sys_page_unmap>
  8026dc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8026de:	83 c4 30             	add    $0x30,%esp
  8026e1:	5b                   	pop    %ebx
  8026e2:	5e                   	pop    %esi
  8026e3:	5d                   	pop    %ebp
  8026e4:	c3                   	ret    

008026e5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
  8026e8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	89 04 24             	mov    %eax,(%esp)
  8026f8:	e8 89 ef ff ff       	call   801686 <fd_lookup>
  8026fd:	89 c2                	mov    %eax,%edx
  8026ff:	85 d2                	test   %edx,%edx
  802701:	78 15                	js     802718 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	89 04 24             	mov    %eax,(%esp)
  802709:	e8 12 ef ff ff       	call   801620 <fd2data>
	return _pipeisclosed(fd, p);
  80270e:	89 c2                	mov    %eax,%edx
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	e8 0b fd ff ff       	call   802423 <_pipeisclosed>
}
  802718:	c9                   	leave  
  802719:	c3                   	ret    
  80271a:	66 90                	xchg   %ax,%ax
  80271c:	66 90                	xchg   %ax,%ax
  80271e:	66 90                	xchg   %ax,%ax

00802720 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802723:	b8 00 00 00 00       	mov    $0x0,%eax
  802728:	5d                   	pop    %ebp
  802729:	c3                   	ret    

0080272a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802730:	c7 44 24 04 d7 32 80 	movl   $0x8032d7,0x4(%esp)
  802737:	00 
  802738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273b:	89 04 24             	mov    %eax,(%esp)
  80273e:	e8 d4 e5 ff ff       	call   800d17 <strcpy>
	return 0;
}
  802743:	b8 00 00 00 00       	mov    $0x0,%eax
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
  80274d:	57                   	push   %edi
  80274e:	56                   	push   %esi
  80274f:	53                   	push   %ebx
  802750:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802756:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80275b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802761:	eb 31                	jmp    802794 <devcons_write+0x4a>
		m = n - tot;
  802763:	8b 75 10             	mov    0x10(%ebp),%esi
  802766:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802768:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80276b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802770:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802773:	89 74 24 08          	mov    %esi,0x8(%esp)
  802777:	03 45 0c             	add    0xc(%ebp),%eax
  80277a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80277e:	89 3c 24             	mov    %edi,(%esp)
  802781:	e8 2e e7 ff ff       	call   800eb4 <memmove>
		sys_cputs(buf, m);
  802786:	89 74 24 04          	mov    %esi,0x4(%esp)
  80278a:	89 3c 24             	mov    %edi,(%esp)
  80278d:	e8 d4 e8 ff ff       	call   801066 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802792:	01 f3                	add    %esi,%ebx
  802794:	89 d8                	mov    %ebx,%eax
  802796:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802799:	72 c8                	jb     802763 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80279b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8027a1:	5b                   	pop    %ebx
  8027a2:	5e                   	pop    %esi
  8027a3:	5f                   	pop    %edi
  8027a4:	5d                   	pop    %ebp
  8027a5:	c3                   	ret    

008027a6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027a6:	55                   	push   %ebp
  8027a7:	89 e5                	mov    %esp,%ebp
  8027a9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8027ac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8027b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027b5:	75 07                	jne    8027be <devcons_read+0x18>
  8027b7:	eb 2a                	jmp    8027e3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8027b9:	e8 56 e9 ff ff       	call   801114 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8027be:	66 90                	xchg   %ax,%ax
  8027c0:	e8 bf e8 ff ff       	call   801084 <sys_cgetc>
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	74 f0                	je     8027b9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	78 16                	js     8027e3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8027cd:	83 f8 04             	cmp    $0x4,%eax
  8027d0:	74 0c                	je     8027de <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8027d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d5:	88 02                	mov    %al,(%edx)
	return 1;
  8027d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8027dc:	eb 05                	jmp    8027e3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8027de:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8027e3:	c9                   	leave  
  8027e4:	c3                   	ret    

008027e5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8027eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8027f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8027f8:	00 
  8027f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027fc:	89 04 24             	mov    %eax,(%esp)
  8027ff:	e8 62 e8 ff ff       	call   801066 <sys_cputs>
}
  802804:	c9                   	leave  
  802805:	c3                   	ret    

00802806 <getchar>:

int
getchar(void)
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
  802809:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80280c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802813:	00 
  802814:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802817:	89 44 24 04          	mov    %eax,0x4(%esp)
  80281b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802822:	e8 f3 f0 ff ff       	call   80191a <read>
	if (r < 0)
  802827:	85 c0                	test   %eax,%eax
  802829:	78 0f                	js     80283a <getchar+0x34>
		return r;
	if (r < 1)
  80282b:	85 c0                	test   %eax,%eax
  80282d:	7e 06                	jle    802835 <getchar+0x2f>
		return -E_EOF;
	return c;
  80282f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802833:	eb 05                	jmp    80283a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802835:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80283a:	c9                   	leave  
  80283b:	c3                   	ret    

0080283c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
  80283f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802842:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802845:	89 44 24 04          	mov    %eax,0x4(%esp)
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	89 04 24             	mov    %eax,(%esp)
  80284f:	e8 32 ee ff ff       	call   801686 <fd_lookup>
  802854:	85 c0                	test   %eax,%eax
  802856:	78 11                	js     802869 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802861:	39 10                	cmp    %edx,(%eax)
  802863:	0f 94 c0             	sete   %al
  802866:	0f b6 c0             	movzbl %al,%eax
}
  802869:	c9                   	leave  
  80286a:	c3                   	ret    

0080286b <opencons>:

int
opencons(void)
{
  80286b:	55                   	push   %ebp
  80286c:	89 e5                	mov    %esp,%ebp
  80286e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802871:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802874:	89 04 24             	mov    %eax,(%esp)
  802877:	e8 bb ed ff ff       	call   801637 <fd_alloc>
		return r;
  80287c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80287e:	85 c0                	test   %eax,%eax
  802880:	78 40                	js     8028c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802882:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802889:	00 
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802891:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802898:	e8 96 e8 ff ff       	call   801133 <sys_page_alloc>
		return r;
  80289d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80289f:	85 c0                	test   %eax,%eax
  8028a1:	78 1f                	js     8028c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8028a3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028b8:	89 04 24             	mov    %eax,(%esp)
  8028bb:	e8 50 ed ff ff       	call   801610 <fd2num>
  8028c0:	89 c2                	mov    %eax,%edx
}
  8028c2:	89 d0                	mov    %edx,%eax
  8028c4:	c9                   	leave  
  8028c5:	c3                   	ret    
  8028c6:	66 90                	xchg   %ax,%ax
  8028c8:	66 90                	xchg   %ax,%ax
  8028ca:	66 90                	xchg   %ax,%ax
  8028cc:	66 90                	xchg   %ax,%ax
  8028ce:	66 90                	xchg   %ax,%ax

008028d0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028d0:	55                   	push   %ebp
  8028d1:	89 e5                	mov    %esp,%ebp
  8028d3:	56                   	push   %esi
  8028d4:	53                   	push   %ebx
  8028d5:	83 ec 10             	sub    $0x10,%esp
  8028d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8028db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8028e1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  8028e3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8028e8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  8028eb:	89 04 24             	mov    %eax,(%esp)
  8028ee:	e8 56 ea ff ff       	call   801349 <sys_ipc_recv>
  8028f3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  8028f5:	85 d2                	test   %edx,%edx
  8028f7:	75 24                	jne    80291d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  8028f9:	85 f6                	test   %esi,%esi
  8028fb:	74 0a                	je     802907 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  8028fd:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802902:	8b 40 74             	mov    0x74(%eax),%eax
  802905:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802907:	85 db                	test   %ebx,%ebx
  802909:	74 0a                	je     802915 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80290b:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802910:	8b 40 78             	mov    0x78(%eax),%eax
  802913:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802915:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80291a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80291d:	83 c4 10             	add    $0x10,%esp
  802920:	5b                   	pop    %ebx
  802921:	5e                   	pop    %esi
  802922:	5d                   	pop    %ebp
  802923:	c3                   	ret    

00802924 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802924:	55                   	push   %ebp
  802925:	89 e5                	mov    %esp,%ebp
  802927:	57                   	push   %edi
  802928:	56                   	push   %esi
  802929:	53                   	push   %ebx
  80292a:	83 ec 1c             	sub    $0x1c,%esp
  80292d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802930:	8b 75 0c             	mov    0xc(%ebp),%esi
  802933:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802936:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802938:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80293d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802940:	8b 45 14             	mov    0x14(%ebp),%eax
  802943:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802947:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80294b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80294f:	89 3c 24             	mov    %edi,(%esp)
  802952:	e8 cf e9 ff ff       	call   801326 <sys_ipc_try_send>

		if (ret == 0)
  802957:	85 c0                	test   %eax,%eax
  802959:	74 2c                	je     802987 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80295b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80295e:	74 20                	je     802980 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802960:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802964:	c7 44 24 08 e4 32 80 	movl   $0x8032e4,0x8(%esp)
  80296b:	00 
  80296c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802973:	00 
  802974:	c7 04 24 14 33 80 00 	movl   $0x803314,(%esp)
  80297b:	e8 7a dc ff ff       	call   8005fa <_panic>
		}

		sys_yield();
  802980:	e8 8f e7 ff ff       	call   801114 <sys_yield>
	}
  802985:	eb b9                	jmp    802940 <ipc_send+0x1c>
}
  802987:	83 c4 1c             	add    $0x1c,%esp
  80298a:	5b                   	pop    %ebx
  80298b:	5e                   	pop    %esi
  80298c:	5f                   	pop    %edi
  80298d:	5d                   	pop    %ebp
  80298e:	c3                   	ret    

0080298f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80298f:	55                   	push   %ebp
  802990:	89 e5                	mov    %esp,%ebp
  802992:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802995:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80299a:	89 c2                	mov    %eax,%edx
  80299c:	c1 e2 07             	shl    $0x7,%edx
  80299f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  8029a6:	8b 52 50             	mov    0x50(%edx),%edx
  8029a9:	39 ca                	cmp    %ecx,%edx
  8029ab:	75 11                	jne    8029be <ipc_find_env+0x2f>
			return envs[i].env_id;
  8029ad:	89 c2                	mov    %eax,%edx
  8029af:	c1 e2 07             	shl    $0x7,%edx
  8029b2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  8029b9:	8b 40 40             	mov    0x40(%eax),%eax
  8029bc:	eb 0e                	jmp    8029cc <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8029be:	83 c0 01             	add    $0x1,%eax
  8029c1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029c6:	75 d2                	jne    80299a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8029c8:	66 b8 00 00          	mov    $0x0,%ax
}
  8029cc:	5d                   	pop    %ebp
  8029cd:	c3                   	ret    

008029ce <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029ce:	55                   	push   %ebp
  8029cf:	89 e5                	mov    %esp,%ebp
  8029d1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029d4:	89 d0                	mov    %edx,%eax
  8029d6:	c1 e8 16             	shr    $0x16,%eax
  8029d9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029e0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029e5:	f6 c1 01             	test   $0x1,%cl
  8029e8:	74 1d                	je     802a07 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8029ea:	c1 ea 0c             	shr    $0xc,%edx
  8029ed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029f4:	f6 c2 01             	test   $0x1,%dl
  8029f7:	74 0e                	je     802a07 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029f9:	c1 ea 0c             	shr    $0xc,%edx
  8029fc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a03:	ef 
  802a04:	0f b7 c0             	movzwl %ax,%eax
}
  802a07:	5d                   	pop    %ebp
  802a08:	c3                   	ret    
  802a09:	66 90                	xchg   %ax,%ax
  802a0b:	66 90                	xchg   %ax,%ax
  802a0d:	66 90                	xchg   %ax,%ax
  802a0f:	90                   	nop

00802a10 <__udivdi3>:
  802a10:	55                   	push   %ebp
  802a11:	57                   	push   %edi
  802a12:	56                   	push   %esi
  802a13:	83 ec 0c             	sub    $0xc,%esp
  802a16:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a1a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802a1e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802a22:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a26:	85 c0                	test   %eax,%eax
  802a28:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802a2c:	89 ea                	mov    %ebp,%edx
  802a2e:	89 0c 24             	mov    %ecx,(%esp)
  802a31:	75 2d                	jne    802a60 <__udivdi3+0x50>
  802a33:	39 e9                	cmp    %ebp,%ecx
  802a35:	77 61                	ja     802a98 <__udivdi3+0x88>
  802a37:	85 c9                	test   %ecx,%ecx
  802a39:	89 ce                	mov    %ecx,%esi
  802a3b:	75 0b                	jne    802a48 <__udivdi3+0x38>
  802a3d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a42:	31 d2                	xor    %edx,%edx
  802a44:	f7 f1                	div    %ecx
  802a46:	89 c6                	mov    %eax,%esi
  802a48:	31 d2                	xor    %edx,%edx
  802a4a:	89 e8                	mov    %ebp,%eax
  802a4c:	f7 f6                	div    %esi
  802a4e:	89 c5                	mov    %eax,%ebp
  802a50:	89 f8                	mov    %edi,%eax
  802a52:	f7 f6                	div    %esi
  802a54:	89 ea                	mov    %ebp,%edx
  802a56:	83 c4 0c             	add    $0xc,%esp
  802a59:	5e                   	pop    %esi
  802a5a:	5f                   	pop    %edi
  802a5b:	5d                   	pop    %ebp
  802a5c:	c3                   	ret    
  802a5d:	8d 76 00             	lea    0x0(%esi),%esi
  802a60:	39 e8                	cmp    %ebp,%eax
  802a62:	77 24                	ja     802a88 <__udivdi3+0x78>
  802a64:	0f bd e8             	bsr    %eax,%ebp
  802a67:	83 f5 1f             	xor    $0x1f,%ebp
  802a6a:	75 3c                	jne    802aa8 <__udivdi3+0x98>
  802a6c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802a70:	39 34 24             	cmp    %esi,(%esp)
  802a73:	0f 86 9f 00 00 00    	jbe    802b18 <__udivdi3+0x108>
  802a79:	39 d0                	cmp    %edx,%eax
  802a7b:	0f 82 97 00 00 00    	jb     802b18 <__udivdi3+0x108>
  802a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a88:	31 d2                	xor    %edx,%edx
  802a8a:	31 c0                	xor    %eax,%eax
  802a8c:	83 c4 0c             	add    $0xc,%esp
  802a8f:	5e                   	pop    %esi
  802a90:	5f                   	pop    %edi
  802a91:	5d                   	pop    %ebp
  802a92:	c3                   	ret    
  802a93:	90                   	nop
  802a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a98:	89 f8                	mov    %edi,%eax
  802a9a:	f7 f1                	div    %ecx
  802a9c:	31 d2                	xor    %edx,%edx
  802a9e:	83 c4 0c             	add    $0xc,%esp
  802aa1:	5e                   	pop    %esi
  802aa2:	5f                   	pop    %edi
  802aa3:	5d                   	pop    %ebp
  802aa4:	c3                   	ret    
  802aa5:	8d 76 00             	lea    0x0(%esi),%esi
  802aa8:	89 e9                	mov    %ebp,%ecx
  802aaa:	8b 3c 24             	mov    (%esp),%edi
  802aad:	d3 e0                	shl    %cl,%eax
  802aaf:	89 c6                	mov    %eax,%esi
  802ab1:	b8 20 00 00 00       	mov    $0x20,%eax
  802ab6:	29 e8                	sub    %ebp,%eax
  802ab8:	89 c1                	mov    %eax,%ecx
  802aba:	d3 ef                	shr    %cl,%edi
  802abc:	89 e9                	mov    %ebp,%ecx
  802abe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802ac2:	8b 3c 24             	mov    (%esp),%edi
  802ac5:	09 74 24 08          	or     %esi,0x8(%esp)
  802ac9:	89 d6                	mov    %edx,%esi
  802acb:	d3 e7                	shl    %cl,%edi
  802acd:	89 c1                	mov    %eax,%ecx
  802acf:	89 3c 24             	mov    %edi,(%esp)
  802ad2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ad6:	d3 ee                	shr    %cl,%esi
  802ad8:	89 e9                	mov    %ebp,%ecx
  802ada:	d3 e2                	shl    %cl,%edx
  802adc:	89 c1                	mov    %eax,%ecx
  802ade:	d3 ef                	shr    %cl,%edi
  802ae0:	09 d7                	or     %edx,%edi
  802ae2:	89 f2                	mov    %esi,%edx
  802ae4:	89 f8                	mov    %edi,%eax
  802ae6:	f7 74 24 08          	divl   0x8(%esp)
  802aea:	89 d6                	mov    %edx,%esi
  802aec:	89 c7                	mov    %eax,%edi
  802aee:	f7 24 24             	mull   (%esp)
  802af1:	39 d6                	cmp    %edx,%esi
  802af3:	89 14 24             	mov    %edx,(%esp)
  802af6:	72 30                	jb     802b28 <__udivdi3+0x118>
  802af8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802afc:	89 e9                	mov    %ebp,%ecx
  802afe:	d3 e2                	shl    %cl,%edx
  802b00:	39 c2                	cmp    %eax,%edx
  802b02:	73 05                	jae    802b09 <__udivdi3+0xf9>
  802b04:	3b 34 24             	cmp    (%esp),%esi
  802b07:	74 1f                	je     802b28 <__udivdi3+0x118>
  802b09:	89 f8                	mov    %edi,%eax
  802b0b:	31 d2                	xor    %edx,%edx
  802b0d:	e9 7a ff ff ff       	jmp    802a8c <__udivdi3+0x7c>
  802b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b18:	31 d2                	xor    %edx,%edx
  802b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b1f:	e9 68 ff ff ff       	jmp    802a8c <__udivdi3+0x7c>
  802b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b28:	8d 47 ff             	lea    -0x1(%edi),%eax
  802b2b:	31 d2                	xor    %edx,%edx
  802b2d:	83 c4 0c             	add    $0xc,%esp
  802b30:	5e                   	pop    %esi
  802b31:	5f                   	pop    %edi
  802b32:	5d                   	pop    %ebp
  802b33:	c3                   	ret    
  802b34:	66 90                	xchg   %ax,%ax
  802b36:	66 90                	xchg   %ax,%ax
  802b38:	66 90                	xchg   %ax,%ax
  802b3a:	66 90                	xchg   %ax,%ax
  802b3c:	66 90                	xchg   %ax,%ax
  802b3e:	66 90                	xchg   %ax,%ax

00802b40 <__umoddi3>:
  802b40:	55                   	push   %ebp
  802b41:	57                   	push   %edi
  802b42:	56                   	push   %esi
  802b43:	83 ec 14             	sub    $0x14,%esp
  802b46:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b4a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b4e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802b52:	89 c7                	mov    %eax,%edi
  802b54:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b58:	8b 44 24 30          	mov    0x30(%esp),%eax
  802b5c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802b60:	89 34 24             	mov    %esi,(%esp)
  802b63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b67:	85 c0                	test   %eax,%eax
  802b69:	89 c2                	mov    %eax,%edx
  802b6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b6f:	75 17                	jne    802b88 <__umoddi3+0x48>
  802b71:	39 fe                	cmp    %edi,%esi
  802b73:	76 4b                	jbe    802bc0 <__umoddi3+0x80>
  802b75:	89 c8                	mov    %ecx,%eax
  802b77:	89 fa                	mov    %edi,%edx
  802b79:	f7 f6                	div    %esi
  802b7b:	89 d0                	mov    %edx,%eax
  802b7d:	31 d2                	xor    %edx,%edx
  802b7f:	83 c4 14             	add    $0x14,%esp
  802b82:	5e                   	pop    %esi
  802b83:	5f                   	pop    %edi
  802b84:	5d                   	pop    %ebp
  802b85:	c3                   	ret    
  802b86:	66 90                	xchg   %ax,%ax
  802b88:	39 f8                	cmp    %edi,%eax
  802b8a:	77 54                	ja     802be0 <__umoddi3+0xa0>
  802b8c:	0f bd e8             	bsr    %eax,%ebp
  802b8f:	83 f5 1f             	xor    $0x1f,%ebp
  802b92:	75 5c                	jne    802bf0 <__umoddi3+0xb0>
  802b94:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802b98:	39 3c 24             	cmp    %edi,(%esp)
  802b9b:	0f 87 e7 00 00 00    	ja     802c88 <__umoddi3+0x148>
  802ba1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ba5:	29 f1                	sub    %esi,%ecx
  802ba7:	19 c7                	sbb    %eax,%edi
  802ba9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bb1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bb5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802bb9:	83 c4 14             	add    $0x14,%esp
  802bbc:	5e                   	pop    %esi
  802bbd:	5f                   	pop    %edi
  802bbe:	5d                   	pop    %ebp
  802bbf:	c3                   	ret    
  802bc0:	85 f6                	test   %esi,%esi
  802bc2:	89 f5                	mov    %esi,%ebp
  802bc4:	75 0b                	jne    802bd1 <__umoddi3+0x91>
  802bc6:	b8 01 00 00 00       	mov    $0x1,%eax
  802bcb:	31 d2                	xor    %edx,%edx
  802bcd:	f7 f6                	div    %esi
  802bcf:	89 c5                	mov    %eax,%ebp
  802bd1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802bd5:	31 d2                	xor    %edx,%edx
  802bd7:	f7 f5                	div    %ebp
  802bd9:	89 c8                	mov    %ecx,%eax
  802bdb:	f7 f5                	div    %ebp
  802bdd:	eb 9c                	jmp    802b7b <__umoddi3+0x3b>
  802bdf:	90                   	nop
  802be0:	89 c8                	mov    %ecx,%eax
  802be2:	89 fa                	mov    %edi,%edx
  802be4:	83 c4 14             	add    $0x14,%esp
  802be7:	5e                   	pop    %esi
  802be8:	5f                   	pop    %edi
  802be9:	5d                   	pop    %ebp
  802bea:	c3                   	ret    
  802beb:	90                   	nop
  802bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bf0:	8b 04 24             	mov    (%esp),%eax
  802bf3:	be 20 00 00 00       	mov    $0x20,%esi
  802bf8:	89 e9                	mov    %ebp,%ecx
  802bfa:	29 ee                	sub    %ebp,%esi
  802bfc:	d3 e2                	shl    %cl,%edx
  802bfe:	89 f1                	mov    %esi,%ecx
  802c00:	d3 e8                	shr    %cl,%eax
  802c02:	89 e9                	mov    %ebp,%ecx
  802c04:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c08:	8b 04 24             	mov    (%esp),%eax
  802c0b:	09 54 24 04          	or     %edx,0x4(%esp)
  802c0f:	89 fa                	mov    %edi,%edx
  802c11:	d3 e0                	shl    %cl,%eax
  802c13:	89 f1                	mov    %esi,%ecx
  802c15:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c19:	8b 44 24 10          	mov    0x10(%esp),%eax
  802c1d:	d3 ea                	shr    %cl,%edx
  802c1f:	89 e9                	mov    %ebp,%ecx
  802c21:	d3 e7                	shl    %cl,%edi
  802c23:	89 f1                	mov    %esi,%ecx
  802c25:	d3 e8                	shr    %cl,%eax
  802c27:	89 e9                	mov    %ebp,%ecx
  802c29:	09 f8                	or     %edi,%eax
  802c2b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802c2f:	f7 74 24 04          	divl   0x4(%esp)
  802c33:	d3 e7                	shl    %cl,%edi
  802c35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c39:	89 d7                	mov    %edx,%edi
  802c3b:	f7 64 24 08          	mull   0x8(%esp)
  802c3f:	39 d7                	cmp    %edx,%edi
  802c41:	89 c1                	mov    %eax,%ecx
  802c43:	89 14 24             	mov    %edx,(%esp)
  802c46:	72 2c                	jb     802c74 <__umoddi3+0x134>
  802c48:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802c4c:	72 22                	jb     802c70 <__umoddi3+0x130>
  802c4e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802c52:	29 c8                	sub    %ecx,%eax
  802c54:	19 d7                	sbb    %edx,%edi
  802c56:	89 e9                	mov    %ebp,%ecx
  802c58:	89 fa                	mov    %edi,%edx
  802c5a:	d3 e8                	shr    %cl,%eax
  802c5c:	89 f1                	mov    %esi,%ecx
  802c5e:	d3 e2                	shl    %cl,%edx
  802c60:	89 e9                	mov    %ebp,%ecx
  802c62:	d3 ef                	shr    %cl,%edi
  802c64:	09 d0                	or     %edx,%eax
  802c66:	89 fa                	mov    %edi,%edx
  802c68:	83 c4 14             	add    $0x14,%esp
  802c6b:	5e                   	pop    %esi
  802c6c:	5f                   	pop    %edi
  802c6d:	5d                   	pop    %ebp
  802c6e:	c3                   	ret    
  802c6f:	90                   	nop
  802c70:	39 d7                	cmp    %edx,%edi
  802c72:	75 da                	jne    802c4e <__umoddi3+0x10e>
  802c74:	8b 14 24             	mov    (%esp),%edx
  802c77:	89 c1                	mov    %eax,%ecx
  802c79:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802c7d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802c81:	eb cb                	jmp    802c4e <__umoddi3+0x10e>
  802c83:	90                   	nop
  802c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c88:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802c8c:	0f 82 0f ff ff ff    	jb     802ba1 <__umoddi3+0x61>
  802c92:	e9 1a ff ff ff       	jmp    802bb1 <__umoddi3+0x71>
