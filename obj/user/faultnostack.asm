
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 28 00 00 00       	call   800059 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	c7 44 24 04 b0 05 80 	movl   $0x8005b0,0x4(%esp)
  800040:	00 
  800041:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800048:	e8 de 02 00 00       	call   80032b <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  80004d:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800054:	00 00 00 
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	56                   	push   %esi
  80005d:	53                   	push   %ebx
  80005e:	83 ec 10             	sub    $0x10,%esp
  800061:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800064:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800067:	e8 e1 00 00 00       	call   80014d <sys_getenvid>
  80006c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800071:	89 c2                	mov    %eax,%edx
  800073:	c1 e2 07             	shl    $0x7,%edx
  800076:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  80007d:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800082:	85 db                	test   %ebx,%ebx
  800084:	7e 07                	jle    80008d <libmain+0x34>
		binaryname = argv[0];
  800086:	8b 06                	mov    (%esi),%eax
  800088:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80008d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800091:	89 1c 24             	mov    %ebx,(%esp)
  800094:	e8 9a ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800099:	e8 07 00 00 00       	call   8000a5 <exit>
}
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	5b                   	pop    %ebx
  8000a2:	5e                   	pop    %esi
  8000a3:	5d                   	pop    %ebp
  8000a4:	c3                   	ret    

008000a5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000ab:	e8 0a 07 00 00       	call   8007ba <close_all>
	sys_env_destroy(0);
  8000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b7:	e8 3f 00 00 00       	call   8000fb <sys_env_destroy>
}
  8000bc:	c9                   	leave  
  8000bd:	c3                   	ret    

008000be <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	57                   	push   %edi
  8000c2:	56                   	push   %esi
  8000c3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8000cf:	89 c3                	mov    %eax,%ebx
  8000d1:	89 c7                	mov    %eax,%edi
  8000d3:	89 c6                	mov    %eax,%esi
  8000d5:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d7:	5b                   	pop    %ebx
  8000d8:	5e                   	pop    %esi
  8000d9:	5f                   	pop    %edi
  8000da:	5d                   	pop    %ebp
  8000db:	c3                   	ret    

008000dc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	57                   	push   %edi
  8000e0:	56                   	push   %esi
  8000e1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8000ec:	89 d1                	mov    %edx,%ecx
  8000ee:	89 d3                	mov    %edx,%ebx
  8000f0:	89 d7                	mov    %edx,%edi
  8000f2:	89 d6                	mov    %edx,%esi
  8000f4:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f6:	5b                   	pop    %ebx
  8000f7:	5e                   	pop    %esi
  8000f8:	5f                   	pop    %edi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	57                   	push   %edi
  8000ff:	56                   	push   %esi
  800100:	53                   	push   %ebx
  800101:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800104:	b9 00 00 00 00       	mov    $0x0,%ecx
  800109:	b8 03 00 00 00       	mov    $0x3,%eax
  80010e:	8b 55 08             	mov    0x8(%ebp),%edx
  800111:	89 cb                	mov    %ecx,%ebx
  800113:	89 cf                	mov    %ecx,%edi
  800115:	89 ce                	mov    %ecx,%esi
  800117:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800119:	85 c0                	test   %eax,%eax
  80011b:	7e 28                	jle    800145 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80011d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800121:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800128:	00 
  800129:	c7 44 24 08 6a 27 80 	movl   $0x80276a,0x8(%esp)
  800130:	00 
  800131:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800138:	00 
  800139:	c7 04 24 87 27 80 00 	movl   $0x802787,(%esp)
  800140:	e8 51 17 00 00       	call   801896 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800145:	83 c4 2c             	add    $0x2c,%esp
  800148:	5b                   	pop    %ebx
  800149:	5e                   	pop    %esi
  80014a:	5f                   	pop    %edi
  80014b:	5d                   	pop    %ebp
  80014c:	c3                   	ret    

0080014d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	57                   	push   %edi
  800151:	56                   	push   %esi
  800152:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800153:	ba 00 00 00 00       	mov    $0x0,%edx
  800158:	b8 02 00 00 00       	mov    $0x2,%eax
  80015d:	89 d1                	mov    %edx,%ecx
  80015f:	89 d3                	mov    %edx,%ebx
  800161:	89 d7                	mov    %edx,%edi
  800163:	89 d6                	mov    %edx,%esi
  800165:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800167:	5b                   	pop    %ebx
  800168:	5e                   	pop    %esi
  800169:	5f                   	pop    %edi
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    

0080016c <sys_yield>:

void
sys_yield(void)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	57                   	push   %edi
  800170:	56                   	push   %esi
  800171:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800172:	ba 00 00 00 00       	mov    $0x0,%edx
  800177:	b8 0b 00 00 00       	mov    $0xb,%eax
  80017c:	89 d1                	mov    %edx,%ecx
  80017e:	89 d3                	mov    %edx,%ebx
  800180:	89 d7                	mov    %edx,%edi
  800182:	89 d6                	mov    %edx,%esi
  800184:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800186:	5b                   	pop    %ebx
  800187:	5e                   	pop    %esi
  800188:	5f                   	pop    %edi
  800189:	5d                   	pop    %ebp
  80018a:	c3                   	ret    

0080018b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	57                   	push   %edi
  80018f:	56                   	push   %esi
  800190:	53                   	push   %ebx
  800191:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800194:	be 00 00 00 00       	mov    $0x0,%esi
  800199:	b8 04 00 00 00       	mov    $0x4,%eax
  80019e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a7:	89 f7                	mov    %esi,%edi
  8001a9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001ab:	85 c0                	test   %eax,%eax
  8001ad:	7e 28                	jle    8001d7 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001af:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001b3:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8001ba:	00 
  8001bb:	c7 44 24 08 6a 27 80 	movl   $0x80276a,0x8(%esp)
  8001c2:	00 
  8001c3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001ca:	00 
  8001cb:	c7 04 24 87 27 80 00 	movl   $0x802787,(%esp)
  8001d2:	e8 bf 16 00 00       	call   801896 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001d7:	83 c4 2c             	add    $0x2c,%esp
  8001da:	5b                   	pop    %ebx
  8001db:	5e                   	pop    %esi
  8001dc:	5f                   	pop    %edi
  8001dd:	5d                   	pop    %ebp
  8001de:	c3                   	ret    

008001df <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001df:	55                   	push   %ebp
  8001e0:	89 e5                	mov    %esp,%ebp
  8001e2:	57                   	push   %edi
  8001e3:	56                   	push   %esi
  8001e4:	53                   	push   %ebx
  8001e5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001e8:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001f6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001f9:	8b 75 18             	mov    0x18(%ebp),%esi
  8001fc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001fe:	85 c0                	test   %eax,%eax
  800200:	7e 28                	jle    80022a <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800202:	89 44 24 10          	mov    %eax,0x10(%esp)
  800206:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80020d:	00 
  80020e:	c7 44 24 08 6a 27 80 	movl   $0x80276a,0x8(%esp)
  800215:	00 
  800216:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80021d:	00 
  80021e:	c7 04 24 87 27 80 00 	movl   $0x802787,(%esp)
  800225:	e8 6c 16 00 00       	call   801896 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80022a:	83 c4 2c             	add    $0x2c,%esp
  80022d:	5b                   	pop    %ebx
  80022e:	5e                   	pop    %esi
  80022f:	5f                   	pop    %edi
  800230:	5d                   	pop    %ebp
  800231:	c3                   	ret    

00800232 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	57                   	push   %edi
  800236:	56                   	push   %esi
  800237:	53                   	push   %ebx
  800238:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80023b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800240:	b8 06 00 00 00       	mov    $0x6,%eax
  800245:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800248:	8b 55 08             	mov    0x8(%ebp),%edx
  80024b:	89 df                	mov    %ebx,%edi
  80024d:	89 de                	mov    %ebx,%esi
  80024f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800251:	85 c0                	test   %eax,%eax
  800253:	7e 28                	jle    80027d <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800255:	89 44 24 10          	mov    %eax,0x10(%esp)
  800259:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800260:	00 
  800261:	c7 44 24 08 6a 27 80 	movl   $0x80276a,0x8(%esp)
  800268:	00 
  800269:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800270:	00 
  800271:	c7 04 24 87 27 80 00 	movl   $0x802787,(%esp)
  800278:	e8 19 16 00 00       	call   801896 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80027d:	83 c4 2c             	add    $0x2c,%esp
  800280:	5b                   	pop    %ebx
  800281:	5e                   	pop    %esi
  800282:	5f                   	pop    %edi
  800283:	5d                   	pop    %ebp
  800284:	c3                   	ret    

00800285 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	57                   	push   %edi
  800289:	56                   	push   %esi
  80028a:	53                   	push   %ebx
  80028b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80028e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800293:	b8 08 00 00 00       	mov    $0x8,%eax
  800298:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80029b:	8b 55 08             	mov    0x8(%ebp),%edx
  80029e:	89 df                	mov    %ebx,%edi
  8002a0:	89 de                	mov    %ebx,%esi
  8002a2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002a4:	85 c0                	test   %eax,%eax
  8002a6:	7e 28                	jle    8002d0 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002ac:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8002b3:	00 
  8002b4:	c7 44 24 08 6a 27 80 	movl   $0x80276a,0x8(%esp)
  8002bb:	00 
  8002bc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002c3:	00 
  8002c4:	c7 04 24 87 27 80 00 	movl   $0x802787,(%esp)
  8002cb:	e8 c6 15 00 00       	call   801896 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002d0:	83 c4 2c             	add    $0x2c,%esp
  8002d3:	5b                   	pop    %ebx
  8002d4:	5e                   	pop    %esi
  8002d5:	5f                   	pop    %edi
  8002d6:	5d                   	pop    %ebp
  8002d7:	c3                   	ret    

008002d8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	57                   	push   %edi
  8002dc:	56                   	push   %esi
  8002dd:	53                   	push   %ebx
  8002de:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002e6:	b8 09 00 00 00       	mov    $0x9,%eax
  8002eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f1:	89 df                	mov    %ebx,%edi
  8002f3:	89 de                	mov    %ebx,%esi
  8002f5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002f7:	85 c0                	test   %eax,%eax
  8002f9:	7e 28                	jle    800323 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002fb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002ff:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800306:	00 
  800307:	c7 44 24 08 6a 27 80 	movl   $0x80276a,0x8(%esp)
  80030e:	00 
  80030f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800316:	00 
  800317:	c7 04 24 87 27 80 00 	movl   $0x802787,(%esp)
  80031e:	e8 73 15 00 00       	call   801896 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800323:	83 c4 2c             	add    $0x2c,%esp
  800326:	5b                   	pop    %ebx
  800327:	5e                   	pop    %esi
  800328:	5f                   	pop    %edi
  800329:	5d                   	pop    %ebp
  80032a:	c3                   	ret    

0080032b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	57                   	push   %edi
  80032f:	56                   	push   %esi
  800330:	53                   	push   %ebx
  800331:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800334:	bb 00 00 00 00       	mov    $0x0,%ebx
  800339:	b8 0a 00 00 00       	mov    $0xa,%eax
  80033e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800341:	8b 55 08             	mov    0x8(%ebp),%edx
  800344:	89 df                	mov    %ebx,%edi
  800346:	89 de                	mov    %ebx,%esi
  800348:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80034a:	85 c0                	test   %eax,%eax
  80034c:	7e 28                	jle    800376 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80034e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800352:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800359:	00 
  80035a:	c7 44 24 08 6a 27 80 	movl   $0x80276a,0x8(%esp)
  800361:	00 
  800362:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800369:	00 
  80036a:	c7 04 24 87 27 80 00 	movl   $0x802787,(%esp)
  800371:	e8 20 15 00 00       	call   801896 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800376:	83 c4 2c             	add    $0x2c,%esp
  800379:	5b                   	pop    %ebx
  80037a:	5e                   	pop    %esi
  80037b:	5f                   	pop    %edi
  80037c:	5d                   	pop    %ebp
  80037d:	c3                   	ret    

0080037e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	57                   	push   %edi
  800382:	56                   	push   %esi
  800383:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800384:	be 00 00 00 00       	mov    $0x0,%esi
  800389:	b8 0c 00 00 00       	mov    $0xc,%eax
  80038e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800391:	8b 55 08             	mov    0x8(%ebp),%edx
  800394:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800397:	8b 7d 14             	mov    0x14(%ebp),%edi
  80039a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80039c:	5b                   	pop    %ebx
  80039d:	5e                   	pop    %esi
  80039e:	5f                   	pop    %edi
  80039f:	5d                   	pop    %ebp
  8003a0:	c3                   	ret    

008003a1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
  8003a4:	57                   	push   %edi
  8003a5:	56                   	push   %esi
  8003a6:	53                   	push   %ebx
  8003a7:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003af:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b7:	89 cb                	mov    %ecx,%ebx
  8003b9:	89 cf                	mov    %ecx,%edi
  8003bb:	89 ce                	mov    %ecx,%esi
  8003bd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003bf:	85 c0                	test   %eax,%eax
  8003c1:	7e 28                	jle    8003eb <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003c7:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8003ce:	00 
  8003cf:	c7 44 24 08 6a 27 80 	movl   $0x80276a,0x8(%esp)
  8003d6:	00 
  8003d7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003de:	00 
  8003df:	c7 04 24 87 27 80 00 	movl   $0x802787,(%esp)
  8003e6:	e8 ab 14 00 00       	call   801896 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8003eb:	83 c4 2c             	add    $0x2c,%esp
  8003ee:	5b                   	pop    %ebx
  8003ef:	5e                   	pop    %esi
  8003f0:	5f                   	pop    %edi
  8003f1:	5d                   	pop    %ebp
  8003f2:	c3                   	ret    

008003f3 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8003f3:	55                   	push   %ebp
  8003f4:	89 e5                	mov    %esp,%ebp
  8003f6:	57                   	push   %edi
  8003f7:	56                   	push   %esi
  8003f8:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fe:	b8 0e 00 00 00       	mov    $0xe,%eax
  800403:	89 d1                	mov    %edx,%ecx
  800405:	89 d3                	mov    %edx,%ebx
  800407:	89 d7                	mov    %edx,%edi
  800409:	89 d6                	mov    %edx,%esi
  80040b:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80040d:	5b                   	pop    %ebx
  80040e:	5e                   	pop    %esi
  80040f:	5f                   	pop    %edi
  800410:	5d                   	pop    %ebp
  800411:	c3                   	ret    

00800412 <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	57                   	push   %edi
  800416:	56                   	push   %esi
  800417:	53                   	push   %ebx
  800418:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80041b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800420:	b8 0f 00 00 00       	mov    $0xf,%eax
  800425:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800428:	8b 55 08             	mov    0x8(%ebp),%edx
  80042b:	89 df                	mov    %ebx,%edi
  80042d:	89 de                	mov    %ebx,%esi
  80042f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800431:	85 c0                	test   %eax,%eax
  800433:	7e 28                	jle    80045d <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800435:	89 44 24 10          	mov    %eax,0x10(%esp)
  800439:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800440:	00 
  800441:	c7 44 24 08 6a 27 80 	movl   $0x80276a,0x8(%esp)
  800448:	00 
  800449:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800450:	00 
  800451:	c7 04 24 87 27 80 00 	movl   $0x802787,(%esp)
  800458:	e8 39 14 00 00       	call   801896 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  80045d:	83 c4 2c             	add    $0x2c,%esp
  800460:	5b                   	pop    %ebx
  800461:	5e                   	pop    %esi
  800462:	5f                   	pop    %edi
  800463:	5d                   	pop    %ebp
  800464:	c3                   	ret    

00800465 <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
  800468:	57                   	push   %edi
  800469:	56                   	push   %esi
  80046a:	53                   	push   %ebx
  80046b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80046e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800473:	b8 10 00 00 00       	mov    $0x10,%eax
  800478:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80047b:	8b 55 08             	mov    0x8(%ebp),%edx
  80047e:	89 df                	mov    %ebx,%edi
  800480:	89 de                	mov    %ebx,%esi
  800482:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800484:	85 c0                	test   %eax,%eax
  800486:	7e 28                	jle    8004b0 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800488:	89 44 24 10          	mov    %eax,0x10(%esp)
  80048c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800493:	00 
  800494:	c7 44 24 08 6a 27 80 	movl   $0x80276a,0x8(%esp)
  80049b:	00 
  80049c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004a3:	00 
  8004a4:	c7 04 24 87 27 80 00 	movl   $0x802787,(%esp)
  8004ab:	e8 e6 13 00 00       	call   801896 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  8004b0:	83 c4 2c             	add    $0x2c,%esp
  8004b3:	5b                   	pop    %ebx
  8004b4:	5e                   	pop    %esi
  8004b5:	5f                   	pop    %edi
  8004b6:	5d                   	pop    %ebp
  8004b7:	c3                   	ret    

008004b8 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	57                   	push   %edi
  8004bc:	56                   	push   %esi
  8004bd:	53                   	push   %ebx
  8004be:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004c6:	b8 11 00 00 00       	mov    $0x11,%eax
  8004cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8004d1:	89 df                	mov    %ebx,%edi
  8004d3:	89 de                	mov    %ebx,%esi
  8004d5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8004d7:	85 c0                	test   %eax,%eax
  8004d9:	7e 28                	jle    800503 <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8004db:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004df:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  8004e6:	00 
  8004e7:	c7 44 24 08 6a 27 80 	movl   $0x80276a,0x8(%esp)
  8004ee:	00 
  8004ef:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004f6:	00 
  8004f7:	c7 04 24 87 27 80 00 	movl   $0x802787,(%esp)
  8004fe:	e8 93 13 00 00       	call   801896 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  800503:	83 c4 2c             	add    $0x2c,%esp
  800506:	5b                   	pop    %ebx
  800507:	5e                   	pop    %esi
  800508:	5f                   	pop    %edi
  800509:	5d                   	pop    %ebp
  80050a:	c3                   	ret    

0080050b <sys_sleep>:

int
sys_sleep(int channel)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	57                   	push   %edi
  80050f:	56                   	push   %esi
  800510:	53                   	push   %ebx
  800511:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800514:	b9 00 00 00 00       	mov    $0x0,%ecx
  800519:	b8 12 00 00 00       	mov    $0x12,%eax
  80051e:	8b 55 08             	mov    0x8(%ebp),%edx
  800521:	89 cb                	mov    %ecx,%ebx
  800523:	89 cf                	mov    %ecx,%edi
  800525:	89 ce                	mov    %ecx,%esi
  800527:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800529:	85 c0                	test   %eax,%eax
  80052b:	7e 28                	jle    800555 <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80052d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800531:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800538:	00 
  800539:	c7 44 24 08 6a 27 80 	movl   $0x80276a,0x8(%esp)
  800540:	00 
  800541:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800548:	00 
  800549:	c7 04 24 87 27 80 00 	movl   $0x802787,(%esp)
  800550:	e8 41 13 00 00       	call   801896 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  800555:	83 c4 2c             	add    $0x2c,%esp
  800558:	5b                   	pop    %ebx
  800559:	5e                   	pop    %esi
  80055a:	5f                   	pop    %edi
  80055b:	5d                   	pop    %ebp
  80055c:	c3                   	ret    

0080055d <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  80055d:	55                   	push   %ebp
  80055e:	89 e5                	mov    %esp,%ebp
  800560:	57                   	push   %edi
  800561:	56                   	push   %esi
  800562:	53                   	push   %ebx
  800563:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800566:	bb 00 00 00 00       	mov    $0x0,%ebx
  80056b:	b8 13 00 00 00       	mov    $0x13,%eax
  800570:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800573:	8b 55 08             	mov    0x8(%ebp),%edx
  800576:	89 df                	mov    %ebx,%edi
  800578:	89 de                	mov    %ebx,%esi
  80057a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80057c:	85 c0                	test   %eax,%eax
  80057e:	7e 28                	jle    8005a8 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800580:	89 44 24 10          	mov    %eax,0x10(%esp)
  800584:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  80058b:	00 
  80058c:	c7 44 24 08 6a 27 80 	movl   $0x80276a,0x8(%esp)
  800593:	00 
  800594:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80059b:	00 
  80059c:	c7 04 24 87 27 80 00 	movl   $0x802787,(%esp)
  8005a3:	e8 ee 12 00 00       	call   801896 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  8005a8:	83 c4 2c             	add    $0x2c,%esp
  8005ab:	5b                   	pop    %ebx
  8005ac:	5e                   	pop    %esi
  8005ad:	5f                   	pop    %edi
  8005ae:	5d                   	pop    %ebp
  8005af:	c3                   	ret    

008005b0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8005b0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8005b1:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8005b6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8005b8:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %edx 
  8005bb:	8b 54 24 28          	mov    0x28(%esp),%edx
	subl $0x4, 0x30(%esp)
  8005bf:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  8005c4:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl %edx, (%eax)
  8005c8:	89 10                	mov    %edx,(%eax)
	addl $0x8, %esp
  8005ca:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8005cd:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8005ce:	83 c4 04             	add    $0x4,%esp
	popfl
  8005d1:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8005d2:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8005d3:	c3                   	ret    
  8005d4:	66 90                	xchg   %ax,%ax
  8005d6:	66 90                	xchg   %ax,%ax
  8005d8:	66 90                	xchg   %ax,%ax
  8005da:	66 90                	xchg   %ax,%ax
  8005dc:	66 90                	xchg   %ax,%ax
  8005de:	66 90                	xchg   %ax,%ax

008005e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8005eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8005ee:	5d                   	pop    %ebp
  8005ef:	c3                   	ret    

008005f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8005f0:	55                   	push   %ebp
  8005f1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8005fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800600:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800605:	5d                   	pop    %ebp
  800606:	c3                   	ret    

00800607 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800607:	55                   	push   %ebp
  800608:	89 e5                	mov    %esp,%ebp
  80060a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80060d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800612:	89 c2                	mov    %eax,%edx
  800614:	c1 ea 16             	shr    $0x16,%edx
  800617:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80061e:	f6 c2 01             	test   $0x1,%dl
  800621:	74 11                	je     800634 <fd_alloc+0x2d>
  800623:	89 c2                	mov    %eax,%edx
  800625:	c1 ea 0c             	shr    $0xc,%edx
  800628:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80062f:	f6 c2 01             	test   $0x1,%dl
  800632:	75 09                	jne    80063d <fd_alloc+0x36>
			*fd_store = fd;
  800634:	89 01                	mov    %eax,(%ecx)
			return 0;
  800636:	b8 00 00 00 00       	mov    $0x0,%eax
  80063b:	eb 17                	jmp    800654 <fd_alloc+0x4d>
  80063d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800642:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800647:	75 c9                	jne    800612 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800649:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80064f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800654:	5d                   	pop    %ebp
  800655:	c3                   	ret    

00800656 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800656:	55                   	push   %ebp
  800657:	89 e5                	mov    %esp,%ebp
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80065c:	83 f8 1f             	cmp    $0x1f,%eax
  80065f:	77 36                	ja     800697 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800661:	c1 e0 0c             	shl    $0xc,%eax
  800664:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800669:	89 c2                	mov    %eax,%edx
  80066b:	c1 ea 16             	shr    $0x16,%edx
  80066e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800675:	f6 c2 01             	test   $0x1,%dl
  800678:	74 24                	je     80069e <fd_lookup+0x48>
  80067a:	89 c2                	mov    %eax,%edx
  80067c:	c1 ea 0c             	shr    $0xc,%edx
  80067f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800686:	f6 c2 01             	test   $0x1,%dl
  800689:	74 1a                	je     8006a5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80068b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068e:	89 02                	mov    %eax,(%edx)
	return 0;
  800690:	b8 00 00 00 00       	mov    $0x0,%eax
  800695:	eb 13                	jmp    8006aa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800697:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80069c:	eb 0c                	jmp    8006aa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80069e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006a3:	eb 05                	jmp    8006aa <fd_lookup+0x54>
  8006a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8006aa:	5d                   	pop    %ebp
  8006ab:	c3                   	ret    

008006ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8006ac:	55                   	push   %ebp
  8006ad:	89 e5                	mov    %esp,%ebp
  8006af:	83 ec 18             	sub    $0x18,%esp
  8006b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8006b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ba:	eb 13                	jmp    8006cf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8006bc:	39 08                	cmp    %ecx,(%eax)
  8006be:	75 0c                	jne    8006cc <dev_lookup+0x20>
			*dev = devtab[i];
  8006c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8006c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ca:	eb 38                	jmp    800704 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8006cc:	83 c2 01             	add    $0x1,%edx
  8006cf:	8b 04 95 14 28 80 00 	mov    0x802814(,%edx,4),%eax
  8006d6:	85 c0                	test   %eax,%eax
  8006d8:	75 e2                	jne    8006bc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8006da:	a1 08 40 80 00       	mov    0x804008,%eax
  8006df:	8b 40 48             	mov    0x48(%eax),%eax
  8006e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ea:	c7 04 24 98 27 80 00 	movl   $0x802798,(%esp)
  8006f1:	e8 99 12 00 00       	call   80198f <cprintf>
	*dev = 0;
  8006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8006ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800704:	c9                   	leave  
  800705:	c3                   	ret    

00800706 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	56                   	push   %esi
  80070a:	53                   	push   %ebx
  80070b:	83 ec 20             	sub    $0x20,%esp
  80070e:	8b 75 08             	mov    0x8(%ebp),%esi
  800711:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800714:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800717:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80071b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800721:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800724:	89 04 24             	mov    %eax,(%esp)
  800727:	e8 2a ff ff ff       	call   800656 <fd_lookup>
  80072c:	85 c0                	test   %eax,%eax
  80072e:	78 05                	js     800735 <fd_close+0x2f>
	    || fd != fd2)
  800730:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800733:	74 0c                	je     800741 <fd_close+0x3b>
		return (must_exist ? r : 0);
  800735:	84 db                	test   %bl,%bl
  800737:	ba 00 00 00 00       	mov    $0x0,%edx
  80073c:	0f 44 c2             	cmove  %edx,%eax
  80073f:	eb 3f                	jmp    800780 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800741:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800744:	89 44 24 04          	mov    %eax,0x4(%esp)
  800748:	8b 06                	mov    (%esi),%eax
  80074a:	89 04 24             	mov    %eax,(%esp)
  80074d:	e8 5a ff ff ff       	call   8006ac <dev_lookup>
  800752:	89 c3                	mov    %eax,%ebx
  800754:	85 c0                	test   %eax,%eax
  800756:	78 16                	js     80076e <fd_close+0x68>
		if (dev->dev_close)
  800758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80075b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80075e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800763:	85 c0                	test   %eax,%eax
  800765:	74 07                	je     80076e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800767:	89 34 24             	mov    %esi,(%esp)
  80076a:	ff d0                	call   *%eax
  80076c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80076e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800772:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800779:	e8 b4 fa ff ff       	call   800232 <sys_page_unmap>
	return r;
  80077e:	89 d8                	mov    %ebx,%eax
}
  800780:	83 c4 20             	add    $0x20,%esp
  800783:	5b                   	pop    %ebx
  800784:	5e                   	pop    %esi
  800785:	5d                   	pop    %ebp
  800786:	c3                   	ret    

00800787 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800787:	55                   	push   %ebp
  800788:	89 e5                	mov    %esp,%ebp
  80078a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80078d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800790:	89 44 24 04          	mov    %eax,0x4(%esp)
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	89 04 24             	mov    %eax,(%esp)
  80079a:	e8 b7 fe ff ff       	call   800656 <fd_lookup>
  80079f:	89 c2                	mov    %eax,%edx
  8007a1:	85 d2                	test   %edx,%edx
  8007a3:	78 13                	js     8007b8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8007a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8007ac:	00 
  8007ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b0:	89 04 24             	mov    %eax,(%esp)
  8007b3:	e8 4e ff ff ff       	call   800706 <fd_close>
}
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    

008007ba <close_all>:

void
close_all(void)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	53                   	push   %ebx
  8007be:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8007c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8007c6:	89 1c 24             	mov    %ebx,(%esp)
  8007c9:	e8 b9 ff ff ff       	call   800787 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8007ce:	83 c3 01             	add    $0x1,%ebx
  8007d1:	83 fb 20             	cmp    $0x20,%ebx
  8007d4:	75 f0                	jne    8007c6 <close_all+0xc>
		close(i);
}
  8007d6:	83 c4 14             	add    $0x14,%esp
  8007d9:	5b                   	pop    %ebx
  8007da:	5d                   	pop    %ebp
  8007db:	c3                   	ret    

008007dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	57                   	push   %edi
  8007e0:	56                   	push   %esi
  8007e1:	53                   	push   %ebx
  8007e2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8007e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8007e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	89 04 24             	mov    %eax,(%esp)
  8007f2:	e8 5f fe ff ff       	call   800656 <fd_lookup>
  8007f7:	89 c2                	mov    %eax,%edx
  8007f9:	85 d2                	test   %edx,%edx
  8007fb:	0f 88 e1 00 00 00    	js     8008e2 <dup+0x106>
		return r;
	close(newfdnum);
  800801:	8b 45 0c             	mov    0xc(%ebp),%eax
  800804:	89 04 24             	mov    %eax,(%esp)
  800807:	e8 7b ff ff ff       	call   800787 <close>

	newfd = INDEX2FD(newfdnum);
  80080c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80080f:	c1 e3 0c             	shl    $0xc,%ebx
  800812:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800818:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80081b:	89 04 24             	mov    %eax,(%esp)
  80081e:	e8 cd fd ff ff       	call   8005f0 <fd2data>
  800823:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800825:	89 1c 24             	mov    %ebx,(%esp)
  800828:	e8 c3 fd ff ff       	call   8005f0 <fd2data>
  80082d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80082f:	89 f0                	mov    %esi,%eax
  800831:	c1 e8 16             	shr    $0x16,%eax
  800834:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80083b:	a8 01                	test   $0x1,%al
  80083d:	74 43                	je     800882 <dup+0xa6>
  80083f:	89 f0                	mov    %esi,%eax
  800841:	c1 e8 0c             	shr    $0xc,%eax
  800844:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80084b:	f6 c2 01             	test   $0x1,%dl
  80084e:	74 32                	je     800882 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800850:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800857:	25 07 0e 00 00       	and    $0xe07,%eax
  80085c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800860:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800864:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80086b:	00 
  80086c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800870:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800877:	e8 63 f9 ff ff       	call   8001df <sys_page_map>
  80087c:	89 c6                	mov    %eax,%esi
  80087e:	85 c0                	test   %eax,%eax
  800880:	78 3e                	js     8008c0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800885:	89 c2                	mov    %eax,%edx
  800887:	c1 ea 0c             	shr    $0xc,%edx
  80088a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800891:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800897:	89 54 24 10          	mov    %edx,0x10(%esp)
  80089b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80089f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8008a6:	00 
  8008a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8008b2:	e8 28 f9 ff ff       	call   8001df <sys_page_map>
  8008b7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8008b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8008bc:	85 f6                	test   %esi,%esi
  8008be:	79 22                	jns    8008e2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8008c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8008cb:	e8 62 f9 ff ff       	call   800232 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8008d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8008db:	e8 52 f9 ff ff       	call   800232 <sys_page_unmap>
	return r;
  8008e0:	89 f0                	mov    %esi,%eax
}
  8008e2:	83 c4 3c             	add    $0x3c,%esp
  8008e5:	5b                   	pop    %ebx
  8008e6:	5e                   	pop    %esi
  8008e7:	5f                   	pop    %edi
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	53                   	push   %ebx
  8008ee:	83 ec 24             	sub    $0x24,%esp
  8008f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008fb:	89 1c 24             	mov    %ebx,(%esp)
  8008fe:	e8 53 fd ff ff       	call   800656 <fd_lookup>
  800903:	89 c2                	mov    %eax,%edx
  800905:	85 d2                	test   %edx,%edx
  800907:	78 6d                	js     800976 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800909:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80090c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	89 04 24             	mov    %eax,(%esp)
  800918:	e8 8f fd ff ff       	call   8006ac <dev_lookup>
  80091d:	85 c0                	test   %eax,%eax
  80091f:	78 55                	js     800976 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800921:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800924:	8b 50 08             	mov    0x8(%eax),%edx
  800927:	83 e2 03             	and    $0x3,%edx
  80092a:	83 fa 01             	cmp    $0x1,%edx
  80092d:	75 23                	jne    800952 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80092f:	a1 08 40 80 00       	mov    0x804008,%eax
  800934:	8b 40 48             	mov    0x48(%eax),%eax
  800937:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80093b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80093f:	c7 04 24 d9 27 80 00 	movl   $0x8027d9,(%esp)
  800946:	e8 44 10 00 00       	call   80198f <cprintf>
		return -E_INVAL;
  80094b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800950:	eb 24                	jmp    800976 <read+0x8c>
	}
	if (!dev->dev_read)
  800952:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800955:	8b 52 08             	mov    0x8(%edx),%edx
  800958:	85 d2                	test   %edx,%edx
  80095a:	74 15                	je     800971 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80095c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80095f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800963:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800966:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80096a:	89 04 24             	mov    %eax,(%esp)
  80096d:	ff d2                	call   *%edx
  80096f:	eb 05                	jmp    800976 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800971:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800976:	83 c4 24             	add    $0x24,%esp
  800979:	5b                   	pop    %ebx
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	57                   	push   %edi
  800980:	56                   	push   %esi
  800981:	53                   	push   %ebx
  800982:	83 ec 1c             	sub    $0x1c,%esp
  800985:	8b 7d 08             	mov    0x8(%ebp),%edi
  800988:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80098b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800990:	eb 23                	jmp    8009b5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800992:	89 f0                	mov    %esi,%eax
  800994:	29 d8                	sub    %ebx,%eax
  800996:	89 44 24 08          	mov    %eax,0x8(%esp)
  80099a:	89 d8                	mov    %ebx,%eax
  80099c:	03 45 0c             	add    0xc(%ebp),%eax
  80099f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a3:	89 3c 24             	mov    %edi,(%esp)
  8009a6:	e8 3f ff ff ff       	call   8008ea <read>
		if (m < 0)
  8009ab:	85 c0                	test   %eax,%eax
  8009ad:	78 10                	js     8009bf <readn+0x43>
			return m;
		if (m == 0)
  8009af:	85 c0                	test   %eax,%eax
  8009b1:	74 0a                	je     8009bd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8009b3:	01 c3                	add    %eax,%ebx
  8009b5:	39 f3                	cmp    %esi,%ebx
  8009b7:	72 d9                	jb     800992 <readn+0x16>
  8009b9:	89 d8                	mov    %ebx,%eax
  8009bb:	eb 02                	jmp    8009bf <readn+0x43>
  8009bd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8009bf:	83 c4 1c             	add    $0x1c,%esp
  8009c2:	5b                   	pop    %ebx
  8009c3:	5e                   	pop    %esi
  8009c4:	5f                   	pop    %edi
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	53                   	push   %ebx
  8009cb:	83 ec 24             	sub    $0x24,%esp
  8009ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8009d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009d8:	89 1c 24             	mov    %ebx,(%esp)
  8009db:	e8 76 fc ff ff       	call   800656 <fd_lookup>
  8009e0:	89 c2                	mov    %eax,%edx
  8009e2:	85 d2                	test   %edx,%edx
  8009e4:	78 68                	js     800a4e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009f0:	8b 00                	mov    (%eax),%eax
  8009f2:	89 04 24             	mov    %eax,(%esp)
  8009f5:	e8 b2 fc ff ff       	call   8006ac <dev_lookup>
  8009fa:	85 c0                	test   %eax,%eax
  8009fc:	78 50                	js     800a4e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a01:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800a05:	75 23                	jne    800a2a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800a07:	a1 08 40 80 00       	mov    0x804008,%eax
  800a0c:	8b 40 48             	mov    0x48(%eax),%eax
  800a0f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a17:	c7 04 24 f5 27 80 00 	movl   $0x8027f5,(%esp)
  800a1e:	e8 6c 0f 00 00       	call   80198f <cprintf>
		return -E_INVAL;
  800a23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a28:	eb 24                	jmp    800a4e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800a2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a2d:	8b 52 0c             	mov    0xc(%edx),%edx
  800a30:	85 d2                	test   %edx,%edx
  800a32:	74 15                	je     800a49 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800a34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800a3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a42:	89 04 24             	mov    %eax,(%esp)
  800a45:	ff d2                	call   *%edx
  800a47:	eb 05                	jmp    800a4e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800a49:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  800a4e:	83 c4 24             	add    $0x24,%esp
  800a51:	5b                   	pop    %ebx
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <seek>:

int
seek(int fdnum, off_t offset)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800a5a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	89 04 24             	mov    %eax,(%esp)
  800a67:	e8 ea fb ff ff       	call   800656 <fd_lookup>
  800a6c:	85 c0                	test   %eax,%eax
  800a6e:	78 0e                	js     800a7e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800a70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a76:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800a79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7e:	c9                   	leave  
  800a7f:	c3                   	ret    

00800a80 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	53                   	push   %ebx
  800a84:	83 ec 24             	sub    $0x24,%esp
  800a87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a8a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a91:	89 1c 24             	mov    %ebx,(%esp)
  800a94:	e8 bd fb ff ff       	call   800656 <fd_lookup>
  800a99:	89 c2                	mov    %eax,%edx
  800a9b:	85 d2                	test   %edx,%edx
  800a9d:	78 61                	js     800b00 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	89 04 24             	mov    %eax,(%esp)
  800aae:	e8 f9 fb ff ff       	call   8006ac <dev_lookup>
  800ab3:	85 c0                	test   %eax,%eax
  800ab5:	78 49                	js     800b00 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800abe:	75 23                	jne    800ae3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800ac0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800ac5:	8b 40 48             	mov    0x48(%eax),%eax
  800ac8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800acc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ad0:	c7 04 24 b8 27 80 00 	movl   $0x8027b8,(%esp)
  800ad7:	e8 b3 0e 00 00       	call   80198f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800adc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ae1:	eb 1d                	jmp    800b00 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  800ae3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ae6:	8b 52 18             	mov    0x18(%edx),%edx
  800ae9:	85 d2                	test   %edx,%edx
  800aeb:	74 0e                	je     800afb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800aed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800af4:	89 04 24             	mov    %eax,(%esp)
  800af7:	ff d2                	call   *%edx
  800af9:	eb 05                	jmp    800b00 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800afb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800b00:	83 c4 24             	add    $0x24,%esp
  800b03:	5b                   	pop    %ebx
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	53                   	push   %ebx
  800b0a:	83 ec 24             	sub    $0x24,%esp
  800b0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b10:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800b13:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	89 04 24             	mov    %eax,(%esp)
  800b1d:	e8 34 fb ff ff       	call   800656 <fd_lookup>
  800b22:	89 c2                	mov    %eax,%edx
  800b24:	85 d2                	test   %edx,%edx
  800b26:	78 52                	js     800b7a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	89 04 24             	mov    %eax,(%esp)
  800b37:	e8 70 fb ff ff       	call   8006ac <dev_lookup>
  800b3c:	85 c0                	test   %eax,%eax
  800b3e:	78 3a                	js     800b7a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b43:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800b47:	74 2c                	je     800b75 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800b49:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800b4c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800b53:	00 00 00 
	stat->st_isdir = 0;
  800b56:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b5d:	00 00 00 
	stat->st_dev = dev;
  800b60:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800b66:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800b6d:	89 14 24             	mov    %edx,(%esp)
  800b70:	ff 50 14             	call   *0x14(%eax)
  800b73:	eb 05                	jmp    800b7a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800b75:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800b7a:	83 c4 24             	add    $0x24,%esp
  800b7d:	5b                   	pop    %ebx
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    

00800b80 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	56                   	push   %esi
  800b84:	53                   	push   %ebx
  800b85:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800b88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800b8f:	00 
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	89 04 24             	mov    %eax,(%esp)
  800b96:	e8 1b 02 00 00       	call   800db6 <open>
  800b9b:	89 c3                	mov    %eax,%ebx
  800b9d:	85 db                	test   %ebx,%ebx
  800b9f:	78 1b                	js     800bbc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ba8:	89 1c 24             	mov    %ebx,(%esp)
  800bab:	e8 56 ff ff ff       	call   800b06 <fstat>
  800bb0:	89 c6                	mov    %eax,%esi
	close(fd);
  800bb2:	89 1c 24             	mov    %ebx,(%esp)
  800bb5:	e8 cd fb ff ff       	call   800787 <close>
	return r;
  800bba:	89 f0                	mov    %esi,%eax
}
  800bbc:	83 c4 10             	add    $0x10,%esp
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5d                   	pop    %ebp
  800bc2:	c3                   	ret    

00800bc3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	56                   	push   %esi
  800bc7:	53                   	push   %ebx
  800bc8:	83 ec 10             	sub    $0x10,%esp
  800bcb:	89 c6                	mov    %eax,%esi
  800bcd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800bcf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800bd6:	75 11                	jne    800be9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800bd8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800bdf:	e8 6b 18 00 00       	call   80244f <ipc_find_env>
  800be4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800be9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800bf0:	00 
  800bf1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800bf8:	00 
  800bf9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bfd:	a1 00 40 80 00       	mov    0x804000,%eax
  800c02:	89 04 24             	mov    %eax,(%esp)
  800c05:	e8 da 17 00 00       	call   8023e4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800c0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800c11:	00 
  800c12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c1d:	e8 6e 17 00 00       	call   802390 <ipc_recv>
}
  800c22:	83 c4 10             	add    $0x10,%esp
  800c25:	5b                   	pop    %ebx
  800c26:	5e                   	pop    %esi
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	8b 40 0c             	mov    0xc(%eax),%eax
  800c35:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800c42:	ba 00 00 00 00       	mov    $0x0,%edx
  800c47:	b8 02 00 00 00       	mov    $0x2,%eax
  800c4c:	e8 72 ff ff ff       	call   800bc3 <fsipc>
}
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8b 40 0c             	mov    0xc(%eax),%eax
  800c5f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800c64:	ba 00 00 00 00       	mov    $0x0,%edx
  800c69:	b8 06 00 00 00       	mov    $0x6,%eax
  800c6e:	e8 50 ff ff ff       	call   800bc3 <fsipc>
}
  800c73:	c9                   	leave  
  800c74:	c3                   	ret    

00800c75 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	53                   	push   %ebx
  800c79:	83 ec 14             	sub    $0x14,%esp
  800c7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8b 40 0c             	mov    0xc(%eax),%eax
  800c85:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800c8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8f:	b8 05 00 00 00       	mov    $0x5,%eax
  800c94:	e8 2a ff ff ff       	call   800bc3 <fsipc>
  800c99:	89 c2                	mov    %eax,%edx
  800c9b:	85 d2                	test   %edx,%edx
  800c9d:	78 2b                	js     800cca <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800c9f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800ca6:	00 
  800ca7:	89 1c 24             	mov    %ebx,(%esp)
  800caa:	e8 08 13 00 00       	call   801fb7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800caf:	a1 80 50 80 00       	mov    0x805080,%eax
  800cb4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800cba:	a1 84 50 80 00       	mov    0x805084,%eax
  800cbf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cca:	83 c4 14             	add    $0x14,%esp
  800ccd:	5b                   	pop    %ebx
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	83 ec 18             	sub    $0x18,%esp
  800cd6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800cd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdc:	8b 52 0c             	mov    0xc(%edx),%edx
  800cdf:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800ce5:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  800cea:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cf5:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  800cfc:	e8 bb 14 00 00       	call   8021bc <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  800d01:	ba 00 00 00 00       	mov    $0x0,%edx
  800d06:	b8 04 00 00 00       	mov    $0x4,%eax
  800d0b:	e8 b3 fe ff ff       	call   800bc3 <fsipc>
		return r;
	}

	return r;
}
  800d10:	c9                   	leave  
  800d11:	c3                   	ret    

00800d12 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	56                   	push   %esi
  800d16:	53                   	push   %ebx
  800d17:	83 ec 10             	sub    $0x10,%esp
  800d1a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8b 40 0c             	mov    0xc(%eax),%eax
  800d23:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800d28:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800d2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d33:	b8 03 00 00 00       	mov    $0x3,%eax
  800d38:	e8 86 fe ff ff       	call   800bc3 <fsipc>
  800d3d:	89 c3                	mov    %eax,%ebx
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	78 6a                	js     800dad <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800d43:	39 c6                	cmp    %eax,%esi
  800d45:	73 24                	jae    800d6b <devfile_read+0x59>
  800d47:	c7 44 24 0c 28 28 80 	movl   $0x802828,0xc(%esp)
  800d4e:	00 
  800d4f:	c7 44 24 08 2f 28 80 	movl   $0x80282f,0x8(%esp)
  800d56:	00 
  800d57:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  800d5e:	00 
  800d5f:	c7 04 24 44 28 80 00 	movl   $0x802844,(%esp)
  800d66:	e8 2b 0b 00 00       	call   801896 <_panic>
	assert(r <= PGSIZE);
  800d6b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800d70:	7e 24                	jle    800d96 <devfile_read+0x84>
  800d72:	c7 44 24 0c 4f 28 80 	movl   $0x80284f,0xc(%esp)
  800d79:	00 
  800d7a:	c7 44 24 08 2f 28 80 	movl   $0x80282f,0x8(%esp)
  800d81:	00 
  800d82:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  800d89:	00 
  800d8a:	c7 04 24 44 28 80 00 	movl   $0x802844,(%esp)
  800d91:	e8 00 0b 00 00       	call   801896 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800d96:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d9a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800da1:	00 
  800da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da5:	89 04 24             	mov    %eax,(%esp)
  800da8:	e8 a7 13 00 00       	call   802154 <memmove>
	return r;
}
  800dad:	89 d8                	mov    %ebx,%eax
  800daf:	83 c4 10             	add    $0x10,%esp
  800db2:	5b                   	pop    %ebx
  800db3:	5e                   	pop    %esi
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    

00800db6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	53                   	push   %ebx
  800dba:	83 ec 24             	sub    $0x24,%esp
  800dbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800dc0:	89 1c 24             	mov    %ebx,(%esp)
  800dc3:	e8 b8 11 00 00       	call   801f80 <strlen>
  800dc8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800dcd:	7f 60                	jg     800e2f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800dcf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dd2:	89 04 24             	mov    %eax,(%esp)
  800dd5:	e8 2d f8 ff ff       	call   800607 <fd_alloc>
  800dda:	89 c2                	mov    %eax,%edx
  800ddc:	85 d2                	test   %edx,%edx
  800dde:	78 54                	js     800e34 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800de0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800de4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800deb:	e8 c7 11 00 00       	call   801fb7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800df8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfb:	b8 01 00 00 00       	mov    $0x1,%eax
  800e00:	e8 be fd ff ff       	call   800bc3 <fsipc>
  800e05:	89 c3                	mov    %eax,%ebx
  800e07:	85 c0                	test   %eax,%eax
  800e09:	79 17                	jns    800e22 <open+0x6c>
		fd_close(fd, 0);
  800e0b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800e12:	00 
  800e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e16:	89 04 24             	mov    %eax,(%esp)
  800e19:	e8 e8 f8 ff ff       	call   800706 <fd_close>
		return r;
  800e1e:	89 d8                	mov    %ebx,%eax
  800e20:	eb 12                	jmp    800e34 <open+0x7e>
	}

	return fd2num(fd);
  800e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e25:	89 04 24             	mov    %eax,(%esp)
  800e28:	e8 b3 f7 ff ff       	call   8005e0 <fd2num>
  800e2d:	eb 05                	jmp    800e34 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800e2f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800e34:	83 c4 24             	add    $0x24,%esp
  800e37:	5b                   	pop    %ebx
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    

00800e3a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800e40:	ba 00 00 00 00       	mov    $0x0,%edx
  800e45:	b8 08 00 00 00       	mov    $0x8,%eax
  800e4a:	e8 74 fd ff ff       	call   800bc3 <fsipc>
}
  800e4f:	c9                   	leave  
  800e50:	c3                   	ret    
  800e51:	66 90                	xchg   %ax,%ax
  800e53:	66 90                	xchg   %ax,%ax
  800e55:	66 90                	xchg   %ax,%ax
  800e57:	66 90                	xchg   %ax,%ax
  800e59:	66 90                	xchg   %ax,%ax
  800e5b:	66 90                	xchg   %ax,%ax
  800e5d:	66 90                	xchg   %ax,%ax
  800e5f:	90                   	nop

00800e60 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800e66:	c7 44 24 04 5b 28 80 	movl   $0x80285b,0x4(%esp)
  800e6d:	00 
  800e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e71:	89 04 24             	mov    %eax,(%esp)
  800e74:	e8 3e 11 00 00       	call   801fb7 <strcpy>
	return 0;
}
  800e79:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	53                   	push   %ebx
  800e84:	83 ec 14             	sub    $0x14,%esp
  800e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800e8a:	89 1c 24             	mov    %ebx,(%esp)
  800e8d:	e8 fc 15 00 00       	call   80248e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  800e92:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  800e97:	83 f8 01             	cmp    $0x1,%eax
  800e9a:	75 0d                	jne    800ea9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  800e9c:	8b 43 0c             	mov    0xc(%ebx),%eax
  800e9f:	89 04 24             	mov    %eax,(%esp)
  800ea2:	e8 29 03 00 00       	call   8011d0 <nsipc_close>
  800ea7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  800ea9:	89 d0                	mov    %edx,%eax
  800eab:	83 c4 14             	add    $0x14,%esp
  800eae:	5b                   	pop    %ebx
  800eaf:	5d                   	pop    %ebp
  800eb0:	c3                   	ret    

00800eb1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800eb7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800ebe:	00 
  800ebf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec2:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8b 40 0c             	mov    0xc(%eax),%eax
  800ed3:	89 04 24             	mov    %eax,(%esp)
  800ed6:	e8 f0 03 00 00       	call   8012cb <nsipc_send>
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800ee3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800eea:	00 
  800eeb:	8b 45 10             	mov    0x10(%ebp),%eax
  800eee:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8b 40 0c             	mov    0xc(%eax),%eax
  800eff:	89 04 24             	mov    %eax,(%esp)
  800f02:	e8 44 03 00 00       	call   80124b <nsipc_recv>
}
  800f07:	c9                   	leave  
  800f08:	c3                   	ret    

00800f09 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f0f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f12:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f16:	89 04 24             	mov    %eax,(%esp)
  800f19:	e8 38 f7 ff ff       	call   800656 <fd_lookup>
  800f1e:	85 c0                	test   %eax,%eax
  800f20:	78 17                	js     800f39 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f25:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800f2b:	39 08                	cmp    %ecx,(%eax)
  800f2d:	75 05                	jne    800f34 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800f2f:	8b 40 0c             	mov    0xc(%eax),%eax
  800f32:	eb 05                	jmp    800f39 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  800f34:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	56                   	push   %esi
  800f3f:	53                   	push   %ebx
  800f40:	83 ec 20             	sub    $0x20,%esp
  800f43:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800f45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f48:	89 04 24             	mov    %eax,(%esp)
  800f4b:	e8 b7 f6 ff ff       	call   800607 <fd_alloc>
  800f50:	89 c3                	mov    %eax,%ebx
  800f52:	85 c0                	test   %eax,%eax
  800f54:	78 21                	js     800f77 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800f56:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f5d:	00 
  800f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f61:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f6c:	e8 1a f2 ff ff       	call   80018b <sys_page_alloc>
  800f71:	89 c3                	mov    %eax,%ebx
  800f73:	85 c0                	test   %eax,%eax
  800f75:	79 0c                	jns    800f83 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  800f77:	89 34 24             	mov    %esi,(%esp)
  800f7a:	e8 51 02 00 00       	call   8011d0 <nsipc_close>
		return r;
  800f7f:	89 d8                	mov    %ebx,%eax
  800f81:	eb 20                	jmp    800fa3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800f83:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f8c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f91:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  800f98:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  800f9b:	89 14 24             	mov    %edx,(%esp)
  800f9e:	e8 3d f6 ff ff       	call   8005e0 <fd2num>
}
  800fa3:	83 c4 20             	add    $0x20,%esp
  800fa6:	5b                   	pop    %ebx
  800fa7:	5e                   	pop    %esi
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    

00800faa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	e8 51 ff ff ff       	call   800f09 <fd2sockid>
		return r;
  800fb8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fba:	85 c0                	test   %eax,%eax
  800fbc:	78 23                	js     800fe1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800fbe:	8b 55 10             	mov    0x10(%ebp),%edx
  800fc1:	89 54 24 08          	mov    %edx,0x8(%esp)
  800fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc8:	89 54 24 04          	mov    %edx,0x4(%esp)
  800fcc:	89 04 24             	mov    %eax,(%esp)
  800fcf:	e8 45 01 00 00       	call   801119 <nsipc_accept>
		return r;
  800fd4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	78 07                	js     800fe1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  800fda:	e8 5c ff ff ff       	call   800f3b <alloc_sockfd>
  800fdf:	89 c1                	mov    %eax,%ecx
}
  800fe1:	89 c8                	mov    %ecx,%eax
  800fe3:	c9                   	leave  
  800fe4:	c3                   	ret    

00800fe5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	e8 16 ff ff ff       	call   800f09 <fd2sockid>
  800ff3:	89 c2                	mov    %eax,%edx
  800ff5:	85 d2                	test   %edx,%edx
  800ff7:	78 16                	js     80100f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  800ff9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801000:	8b 45 0c             	mov    0xc(%ebp),%eax
  801003:	89 44 24 04          	mov    %eax,0x4(%esp)
  801007:	89 14 24             	mov    %edx,(%esp)
  80100a:	e8 60 01 00 00       	call   80116f <nsipc_bind>
}
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <shutdown>:

int
shutdown(int s, int how)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	e8 ea fe ff ff       	call   800f09 <fd2sockid>
  80101f:	89 c2                	mov    %eax,%edx
  801021:	85 d2                	test   %edx,%edx
  801023:	78 0f                	js     801034 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	89 44 24 04          	mov    %eax,0x4(%esp)
  80102c:	89 14 24             	mov    %edx,(%esp)
  80102f:	e8 7a 01 00 00       	call   8011ae <nsipc_shutdown>
}
  801034:	c9                   	leave  
  801035:	c3                   	ret    

00801036 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	e8 c5 fe ff ff       	call   800f09 <fd2sockid>
  801044:	89 c2                	mov    %eax,%edx
  801046:	85 d2                	test   %edx,%edx
  801048:	78 16                	js     801060 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80104a:	8b 45 10             	mov    0x10(%ebp),%eax
  80104d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	89 44 24 04          	mov    %eax,0x4(%esp)
  801058:	89 14 24             	mov    %edx,(%esp)
  80105b:	e8 8a 01 00 00       	call   8011ea <nsipc_connect>
}
  801060:	c9                   	leave  
  801061:	c3                   	ret    

00801062 <listen>:

int
listen(int s, int backlog)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	e8 99 fe ff ff       	call   800f09 <fd2sockid>
  801070:	89 c2                	mov    %eax,%edx
  801072:	85 d2                	test   %edx,%edx
  801074:	78 0f                	js     801085 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801076:	8b 45 0c             	mov    0xc(%ebp),%eax
  801079:	89 44 24 04          	mov    %eax,0x4(%esp)
  80107d:	89 14 24             	mov    %edx,(%esp)
  801080:	e8 a4 01 00 00       	call   801229 <nsipc_listen>
}
  801085:	c9                   	leave  
  801086:	c3                   	ret    

00801087 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	89 44 24 08          	mov    %eax,0x8(%esp)
  801094:	8b 45 0c             	mov    0xc(%ebp),%eax
  801097:	89 44 24 04          	mov    %eax,0x4(%esp)
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	89 04 24             	mov    %eax,(%esp)
  8010a1:	e8 98 02 00 00       	call   80133e <nsipc_socket>
  8010a6:	89 c2                	mov    %eax,%edx
  8010a8:	85 d2                	test   %edx,%edx
  8010aa:	78 05                	js     8010b1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8010ac:	e8 8a fe ff ff       	call   800f3b <alloc_sockfd>
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	53                   	push   %ebx
  8010b7:	83 ec 14             	sub    $0x14,%esp
  8010ba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8010bc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8010c3:	75 11                	jne    8010d6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8010c5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8010cc:	e8 7e 13 00 00       	call   80244f <ipc_find_env>
  8010d1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8010d6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8010dd:	00 
  8010de:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8010e5:	00 
  8010e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8010ef:	89 04 24             	mov    %eax,(%esp)
  8010f2:	e8 ed 12 00 00       	call   8023e4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8010f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010fe:	00 
  8010ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801106:	00 
  801107:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80110e:	e8 7d 12 00 00       	call   802390 <ipc_recv>
}
  801113:	83 c4 14             	add    $0x14,%esp
  801116:	5b                   	pop    %ebx
  801117:	5d                   	pop    %ebp
  801118:	c3                   	ret    

00801119 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	56                   	push   %esi
  80111d:	53                   	push   %ebx
  80111e:	83 ec 10             	sub    $0x10,%esp
  801121:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80112c:	8b 06                	mov    (%esi),%eax
  80112e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801133:	b8 01 00 00 00       	mov    $0x1,%eax
  801138:	e8 76 ff ff ff       	call   8010b3 <nsipc>
  80113d:	89 c3                	mov    %eax,%ebx
  80113f:	85 c0                	test   %eax,%eax
  801141:	78 23                	js     801166 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801143:	a1 10 60 80 00       	mov    0x806010,%eax
  801148:	89 44 24 08          	mov    %eax,0x8(%esp)
  80114c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801153:	00 
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	89 04 24             	mov    %eax,(%esp)
  80115a:	e8 f5 0f 00 00       	call   802154 <memmove>
		*addrlen = ret->ret_addrlen;
  80115f:	a1 10 60 80 00       	mov    0x806010,%eax
  801164:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801166:	89 d8                	mov    %ebx,%eax
  801168:	83 c4 10             	add    $0x10,%esp
  80116b:	5b                   	pop    %ebx
  80116c:	5e                   	pop    %esi
  80116d:	5d                   	pop    %ebp
  80116e:	c3                   	ret    

0080116f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	53                   	push   %ebx
  801173:	83 ec 14             	sub    $0x14,%esp
  801176:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801181:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801185:	8b 45 0c             	mov    0xc(%ebp),%eax
  801188:	89 44 24 04          	mov    %eax,0x4(%esp)
  80118c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801193:	e8 bc 0f 00 00       	call   802154 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801198:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80119e:	b8 02 00 00 00       	mov    $0x2,%eax
  8011a3:	e8 0b ff ff ff       	call   8010b3 <nsipc>
}
  8011a8:	83 c4 14             	add    $0x14,%esp
  8011ab:	5b                   	pop    %ebx
  8011ac:	5d                   	pop    %ebp
  8011ad:	c3                   	ret    

008011ae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011c4:	b8 03 00 00 00       	mov    $0x3,%eax
  8011c9:	e8 e5 fe ff ff       	call   8010b3 <nsipc>
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <nsipc_close>:

int
nsipc_close(int s)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8011de:	b8 04 00 00 00       	mov    $0x4,%eax
  8011e3:	e8 cb fe ff ff       	call   8010b3 <nsipc>
}
  8011e8:	c9                   	leave  
  8011e9:	c3                   	ret    

008011ea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	53                   	push   %ebx
  8011ee:	83 ec 14             	sub    $0x14,%esp
  8011f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8011fc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	89 44 24 04          	mov    %eax,0x4(%esp)
  801207:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  80120e:	e8 41 0f 00 00       	call   802154 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801213:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801219:	b8 05 00 00 00       	mov    $0x5,%eax
  80121e:	e8 90 fe ff ff       	call   8010b3 <nsipc>
}
  801223:	83 c4 14             	add    $0x14,%esp
  801226:	5b                   	pop    %ebx
  801227:	5d                   	pop    %ebp
  801228:	c3                   	ret    

00801229 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80123f:	b8 06 00 00 00       	mov    $0x6,%eax
  801244:	e8 6a fe ff ff       	call   8010b3 <nsipc>
}
  801249:	c9                   	leave  
  80124a:	c3                   	ret    

0080124b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	56                   	push   %esi
  80124f:	53                   	push   %ebx
  801250:	83 ec 10             	sub    $0x10,%esp
  801253:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80125e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801264:	8b 45 14             	mov    0x14(%ebp),%eax
  801267:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80126c:	b8 07 00 00 00       	mov    $0x7,%eax
  801271:	e8 3d fe ff ff       	call   8010b3 <nsipc>
  801276:	89 c3                	mov    %eax,%ebx
  801278:	85 c0                	test   %eax,%eax
  80127a:	78 46                	js     8012c2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80127c:	39 f0                	cmp    %esi,%eax
  80127e:	7f 07                	jg     801287 <nsipc_recv+0x3c>
  801280:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801285:	7e 24                	jle    8012ab <nsipc_recv+0x60>
  801287:	c7 44 24 0c 67 28 80 	movl   $0x802867,0xc(%esp)
  80128e:	00 
  80128f:	c7 44 24 08 2f 28 80 	movl   $0x80282f,0x8(%esp)
  801296:	00 
  801297:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80129e:	00 
  80129f:	c7 04 24 7c 28 80 00 	movl   $0x80287c,(%esp)
  8012a6:	e8 eb 05 00 00       	call   801896 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8012ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012af:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8012b6:	00 
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	89 04 24             	mov    %eax,(%esp)
  8012bd:	e8 92 0e 00 00       	call   802154 <memmove>
	}

	return r;
}
  8012c2:	89 d8                	mov    %ebx,%eax
  8012c4:	83 c4 10             	add    $0x10,%esp
  8012c7:	5b                   	pop    %ebx
  8012c8:	5e                   	pop    %esi
  8012c9:	5d                   	pop    %ebp
  8012ca:	c3                   	ret    

008012cb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	53                   	push   %ebx
  8012cf:	83 ec 14             	sub    $0x14,%esp
  8012d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012dd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012e3:	7e 24                	jle    801309 <nsipc_send+0x3e>
  8012e5:	c7 44 24 0c 88 28 80 	movl   $0x802888,0xc(%esp)
  8012ec:	00 
  8012ed:	c7 44 24 08 2f 28 80 	movl   $0x80282f,0x8(%esp)
  8012f4:	00 
  8012f5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8012fc:	00 
  8012fd:	c7 04 24 7c 28 80 00 	movl   $0x80287c,(%esp)
  801304:	e8 8d 05 00 00       	call   801896 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801309:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80130d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801310:	89 44 24 04          	mov    %eax,0x4(%esp)
  801314:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80131b:	e8 34 0e 00 00       	call   802154 <memmove>
	nsipcbuf.send.req_size = size;
  801320:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801326:	8b 45 14             	mov    0x14(%ebp),%eax
  801329:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80132e:	b8 08 00 00 00       	mov    $0x8,%eax
  801333:	e8 7b fd ff ff       	call   8010b3 <nsipc>
}
  801338:	83 c4 14             	add    $0x14,%esp
  80133b:	5b                   	pop    %ebx
  80133c:	5d                   	pop    %ebp
  80133d:	c3                   	ret    

0080133e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80134c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80135c:	b8 09 00 00 00       	mov    $0x9,%eax
  801361:	e8 4d fd ff ff       	call   8010b3 <nsipc>
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
  80136b:	56                   	push   %esi
  80136c:	53                   	push   %ebx
  80136d:	83 ec 10             	sub    $0x10,%esp
  801370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	89 04 24             	mov    %eax,(%esp)
  801379:	e8 72 f2 ff ff       	call   8005f0 <fd2data>
  80137e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801380:	c7 44 24 04 94 28 80 	movl   $0x802894,0x4(%esp)
  801387:	00 
  801388:	89 1c 24             	mov    %ebx,(%esp)
  80138b:	e8 27 0c 00 00       	call   801fb7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801390:	8b 46 04             	mov    0x4(%esi),%eax
  801393:	2b 06                	sub    (%esi),%eax
  801395:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80139b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013a2:	00 00 00 
	stat->st_dev = &devpipe;
  8013a5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8013ac:	30 80 00 
	return 0;
}
  8013af:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b4:	83 c4 10             	add    $0x10,%esp
  8013b7:	5b                   	pop    %ebx
  8013b8:	5e                   	pop    %esi
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	53                   	push   %ebx
  8013bf:	83 ec 14             	sub    $0x14,%esp
  8013c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8013c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013d0:	e8 5d ee ff ff       	call   800232 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8013d5:	89 1c 24             	mov    %ebx,(%esp)
  8013d8:	e8 13 f2 ff ff       	call   8005f0 <fd2data>
  8013dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013e8:	e8 45 ee ff ff       	call   800232 <sys_page_unmap>
}
  8013ed:	83 c4 14             	add    $0x14,%esp
  8013f0:	5b                   	pop    %ebx
  8013f1:	5d                   	pop    %ebp
  8013f2:	c3                   	ret    

008013f3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	57                   	push   %edi
  8013f7:	56                   	push   %esi
  8013f8:	53                   	push   %ebx
  8013f9:	83 ec 2c             	sub    $0x2c,%esp
  8013fc:	89 c6                	mov    %eax,%esi
  8013fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801401:	a1 08 40 80 00       	mov    0x804008,%eax
  801406:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801409:	89 34 24             	mov    %esi,(%esp)
  80140c:	e8 7d 10 00 00       	call   80248e <pageref>
  801411:	89 c7                	mov    %eax,%edi
  801413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801416:	89 04 24             	mov    %eax,(%esp)
  801419:	e8 70 10 00 00       	call   80248e <pageref>
  80141e:	39 c7                	cmp    %eax,%edi
  801420:	0f 94 c2             	sete   %dl
  801423:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801426:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  80142c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80142f:	39 fb                	cmp    %edi,%ebx
  801431:	74 21                	je     801454 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801433:	84 d2                	test   %dl,%dl
  801435:	74 ca                	je     801401 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801437:	8b 51 58             	mov    0x58(%ecx),%edx
  80143a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80143e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801442:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801446:	c7 04 24 9b 28 80 00 	movl   $0x80289b,(%esp)
  80144d:	e8 3d 05 00 00       	call   80198f <cprintf>
  801452:	eb ad                	jmp    801401 <_pipeisclosed+0xe>
	}
}
  801454:	83 c4 2c             	add    $0x2c,%esp
  801457:	5b                   	pop    %ebx
  801458:	5e                   	pop    %esi
  801459:	5f                   	pop    %edi
  80145a:	5d                   	pop    %ebp
  80145b:	c3                   	ret    

0080145c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	57                   	push   %edi
  801460:	56                   	push   %esi
  801461:	53                   	push   %ebx
  801462:	83 ec 1c             	sub    $0x1c,%esp
  801465:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801468:	89 34 24             	mov    %esi,(%esp)
  80146b:	e8 80 f1 ff ff       	call   8005f0 <fd2data>
  801470:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801472:	bf 00 00 00 00       	mov    $0x0,%edi
  801477:	eb 45                	jmp    8014be <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801479:	89 da                	mov    %ebx,%edx
  80147b:	89 f0                	mov    %esi,%eax
  80147d:	e8 71 ff ff ff       	call   8013f3 <_pipeisclosed>
  801482:	85 c0                	test   %eax,%eax
  801484:	75 41                	jne    8014c7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801486:	e8 e1 ec ff ff       	call   80016c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80148b:	8b 43 04             	mov    0x4(%ebx),%eax
  80148e:	8b 0b                	mov    (%ebx),%ecx
  801490:	8d 51 20             	lea    0x20(%ecx),%edx
  801493:	39 d0                	cmp    %edx,%eax
  801495:	73 e2                	jae    801479 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801497:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80149a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80149e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8014a1:	99                   	cltd   
  8014a2:	c1 ea 1b             	shr    $0x1b,%edx
  8014a5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8014a8:	83 e1 1f             	and    $0x1f,%ecx
  8014ab:	29 d1                	sub    %edx,%ecx
  8014ad:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8014b1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8014b5:	83 c0 01             	add    $0x1,%eax
  8014b8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014bb:	83 c7 01             	add    $0x1,%edi
  8014be:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8014c1:	75 c8                	jne    80148b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8014c3:	89 f8                	mov    %edi,%eax
  8014c5:	eb 05                	jmp    8014cc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8014c7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8014cc:	83 c4 1c             	add    $0x1c,%esp
  8014cf:	5b                   	pop    %ebx
  8014d0:	5e                   	pop    %esi
  8014d1:	5f                   	pop    %edi
  8014d2:	5d                   	pop    %ebp
  8014d3:	c3                   	ret    

008014d4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	57                   	push   %edi
  8014d8:	56                   	push   %esi
  8014d9:	53                   	push   %ebx
  8014da:	83 ec 1c             	sub    $0x1c,%esp
  8014dd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8014e0:	89 3c 24             	mov    %edi,(%esp)
  8014e3:	e8 08 f1 ff ff       	call   8005f0 <fd2data>
  8014e8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014ea:	be 00 00 00 00       	mov    $0x0,%esi
  8014ef:	eb 3d                	jmp    80152e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8014f1:	85 f6                	test   %esi,%esi
  8014f3:	74 04                	je     8014f9 <devpipe_read+0x25>
				return i;
  8014f5:	89 f0                	mov    %esi,%eax
  8014f7:	eb 43                	jmp    80153c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8014f9:	89 da                	mov    %ebx,%edx
  8014fb:	89 f8                	mov    %edi,%eax
  8014fd:	e8 f1 fe ff ff       	call   8013f3 <_pipeisclosed>
  801502:	85 c0                	test   %eax,%eax
  801504:	75 31                	jne    801537 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801506:	e8 61 ec ff ff       	call   80016c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80150b:	8b 03                	mov    (%ebx),%eax
  80150d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801510:	74 df                	je     8014f1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801512:	99                   	cltd   
  801513:	c1 ea 1b             	shr    $0x1b,%edx
  801516:	01 d0                	add    %edx,%eax
  801518:	83 e0 1f             	and    $0x1f,%eax
  80151b:	29 d0                	sub    %edx,%eax
  80151d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801522:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801525:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801528:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80152b:	83 c6 01             	add    $0x1,%esi
  80152e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801531:	75 d8                	jne    80150b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801533:	89 f0                	mov    %esi,%eax
  801535:	eb 05                	jmp    80153c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801537:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80153c:	83 c4 1c             	add    $0x1c,%esp
  80153f:	5b                   	pop    %ebx
  801540:	5e                   	pop    %esi
  801541:	5f                   	pop    %edi
  801542:	5d                   	pop    %ebp
  801543:	c3                   	ret    

00801544 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	56                   	push   %esi
  801548:	53                   	push   %ebx
  801549:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80154c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154f:	89 04 24             	mov    %eax,(%esp)
  801552:	e8 b0 f0 ff ff       	call   800607 <fd_alloc>
  801557:	89 c2                	mov    %eax,%edx
  801559:	85 d2                	test   %edx,%edx
  80155b:	0f 88 4d 01 00 00    	js     8016ae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801561:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801568:	00 
  801569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801570:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801577:	e8 0f ec ff ff       	call   80018b <sys_page_alloc>
  80157c:	89 c2                	mov    %eax,%edx
  80157e:	85 d2                	test   %edx,%edx
  801580:	0f 88 28 01 00 00    	js     8016ae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801586:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801589:	89 04 24             	mov    %eax,(%esp)
  80158c:	e8 76 f0 ff ff       	call   800607 <fd_alloc>
  801591:	89 c3                	mov    %eax,%ebx
  801593:	85 c0                	test   %eax,%eax
  801595:	0f 88 fe 00 00 00    	js     801699 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80159b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8015a2:	00 
  8015a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015b1:	e8 d5 eb ff ff       	call   80018b <sys_page_alloc>
  8015b6:	89 c3                	mov    %eax,%ebx
  8015b8:	85 c0                	test   %eax,%eax
  8015ba:	0f 88 d9 00 00 00    	js     801699 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	89 04 24             	mov    %eax,(%esp)
  8015c6:	e8 25 f0 ff ff       	call   8005f0 <fd2data>
  8015cb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015cd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8015d4:	00 
  8015d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015e0:	e8 a6 eb ff ff       	call   80018b <sys_page_alloc>
  8015e5:	89 c3                	mov    %eax,%ebx
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	0f 88 97 00 00 00    	js     801686 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f2:	89 04 24             	mov    %eax,(%esp)
  8015f5:	e8 f6 ef ff ff       	call   8005f0 <fd2data>
  8015fa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801601:	00 
  801602:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801606:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80160d:	00 
  80160e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801612:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801619:	e8 c1 eb ff ff       	call   8001df <sys_page_map>
  80161e:	89 c3                	mov    %eax,%ebx
  801620:	85 c0                	test   %eax,%eax
  801622:	78 52                	js     801676 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801624:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80162a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80162f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801632:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801639:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80163f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801642:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801647:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80164e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801651:	89 04 24             	mov    %eax,(%esp)
  801654:	e8 87 ef ff ff       	call   8005e0 <fd2num>
  801659:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80165c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80165e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801661:	89 04 24             	mov    %eax,(%esp)
  801664:	e8 77 ef ff ff       	call   8005e0 <fd2num>
  801669:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80166c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80166f:	b8 00 00 00 00       	mov    $0x0,%eax
  801674:	eb 38                	jmp    8016ae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801676:	89 74 24 04          	mov    %esi,0x4(%esp)
  80167a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801681:	e8 ac eb ff ff       	call   800232 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801689:	89 44 24 04          	mov    %eax,0x4(%esp)
  80168d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801694:	e8 99 eb ff ff       	call   800232 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016a7:	e8 86 eb ff ff       	call   800232 <sys_page_unmap>
  8016ac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8016ae:	83 c4 30             	add    $0x30,%esp
  8016b1:	5b                   	pop    %ebx
  8016b2:	5e                   	pop    %esi
  8016b3:	5d                   	pop    %ebp
  8016b4:	c3                   	ret    

008016b5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	89 04 24             	mov    %eax,(%esp)
  8016c8:	e8 89 ef ff ff       	call   800656 <fd_lookup>
  8016cd:	89 c2                	mov    %eax,%edx
  8016cf:	85 d2                	test   %edx,%edx
  8016d1:	78 15                	js     8016e8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8016d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d6:	89 04 24             	mov    %eax,(%esp)
  8016d9:	e8 12 ef ff ff       	call   8005f0 <fd2data>
	return _pipeisclosed(fd, p);
  8016de:	89 c2                	mov    %eax,%edx
  8016e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e3:	e8 0b fd ff ff       	call   8013f3 <_pipeisclosed>
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    
  8016ea:	66 90                	xchg   %ax,%ax
  8016ec:	66 90                	xchg   %ax,%ax
  8016ee:	66 90                	xchg   %ax,%ax

008016f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8016f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f8:	5d                   	pop    %ebp
  8016f9:	c3                   	ret    

008016fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801700:	c7 44 24 04 b3 28 80 	movl   $0x8028b3,0x4(%esp)
  801707:	00 
  801708:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170b:	89 04 24             	mov    %eax,(%esp)
  80170e:	e8 a4 08 00 00       	call   801fb7 <strcpy>
	return 0;
}
  801713:	b8 00 00 00 00       	mov    $0x0,%eax
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
  80171d:	57                   	push   %edi
  80171e:	56                   	push   %esi
  80171f:	53                   	push   %ebx
  801720:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801726:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80172b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801731:	eb 31                	jmp    801764 <devcons_write+0x4a>
		m = n - tot;
  801733:	8b 75 10             	mov    0x10(%ebp),%esi
  801736:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  801738:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80173b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801740:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801743:	89 74 24 08          	mov    %esi,0x8(%esp)
  801747:	03 45 0c             	add    0xc(%ebp),%eax
  80174a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80174e:	89 3c 24             	mov    %edi,(%esp)
  801751:	e8 fe 09 00 00       	call   802154 <memmove>
		sys_cputs(buf, m);
  801756:	89 74 24 04          	mov    %esi,0x4(%esp)
  80175a:	89 3c 24             	mov    %edi,(%esp)
  80175d:	e8 5c e9 ff ff       	call   8000be <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801762:	01 f3                	add    %esi,%ebx
  801764:	89 d8                	mov    %ebx,%eax
  801766:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801769:	72 c8                	jb     801733 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80176b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801771:	5b                   	pop    %ebx
  801772:	5e                   	pop    %esi
  801773:	5f                   	pop    %edi
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80177c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801781:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801785:	75 07                	jne    80178e <devcons_read+0x18>
  801787:	eb 2a                	jmp    8017b3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801789:	e8 de e9 ff ff       	call   80016c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80178e:	66 90                	xchg   %ax,%ax
  801790:	e8 47 e9 ff ff       	call   8000dc <sys_cgetc>
  801795:	85 c0                	test   %eax,%eax
  801797:	74 f0                	je     801789 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801799:	85 c0                	test   %eax,%eax
  80179b:	78 16                	js     8017b3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80179d:	83 f8 04             	cmp    $0x4,%eax
  8017a0:	74 0c                	je     8017ae <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8017a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a5:	88 02                	mov    %al,(%edx)
	return 1;
  8017a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ac:	eb 05                	jmp    8017b3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8017ae:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8017c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017c8:	00 
  8017c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8017cc:	89 04 24             	mov    %eax,(%esp)
  8017cf:	e8 ea e8 ff ff       	call   8000be <sys_cputs>
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <getchar>:

int
getchar(void)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8017dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8017e3:	00 
  8017e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8017e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f2:	e8 f3 f0 ff ff       	call   8008ea <read>
	if (r < 0)
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	78 0f                	js     80180a <getchar+0x34>
		return r;
	if (r < 1)
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	7e 06                	jle    801805 <getchar+0x2f>
		return -E_EOF;
	return c;
  8017ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801803:	eb 05                	jmp    80180a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801805:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801812:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801815:	89 44 24 04          	mov    %eax,0x4(%esp)
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	89 04 24             	mov    %eax,(%esp)
  80181f:	e8 32 ee ff ff       	call   800656 <fd_lookup>
  801824:	85 c0                	test   %eax,%eax
  801826:	78 11                	js     801839 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801831:	39 10                	cmp    %edx,(%eax)
  801833:	0f 94 c0             	sete   %al
  801836:	0f b6 c0             	movzbl %al,%eax
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <opencons>:

int
opencons(void)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801841:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801844:	89 04 24             	mov    %eax,(%esp)
  801847:	e8 bb ed ff ff       	call   800607 <fd_alloc>
		return r;
  80184c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80184e:	85 c0                	test   %eax,%eax
  801850:	78 40                	js     801892 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801852:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801859:	00 
  80185a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801861:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801868:	e8 1e e9 ff ff       	call   80018b <sys_page_alloc>
		return r;
  80186d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80186f:	85 c0                	test   %eax,%eax
  801871:	78 1f                	js     801892 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801873:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80187e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801881:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801888:	89 04 24             	mov    %eax,(%esp)
  80188b:	e8 50 ed ff ff       	call   8005e0 <fd2num>
  801890:	89 c2                	mov    %eax,%edx
}
  801892:	89 d0                	mov    %edx,%eax
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	56                   	push   %esi
  80189a:	53                   	push   %ebx
  80189b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80189e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8018a1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8018a7:	e8 a1 e8 ff ff       	call   80014d <sys_getenvid>
  8018ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018af:	89 54 24 10          	mov    %edx,0x10(%esp)
  8018b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8018ba:	89 74 24 08          	mov    %esi,0x8(%esp)
  8018be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c2:	c7 04 24 c0 28 80 00 	movl   $0x8028c0,(%esp)
  8018c9:	e8 c1 00 00 00       	call   80198f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8018ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d5:	89 04 24             	mov    %eax,(%esp)
  8018d8:	e8 51 00 00 00       	call   80192e <vcprintf>
	cprintf("\n");
  8018dd:	c7 04 24 ac 28 80 00 	movl   $0x8028ac,(%esp)
  8018e4:	e8 a6 00 00 00       	call   80198f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8018e9:	cc                   	int3   
  8018ea:	eb fd                	jmp    8018e9 <_panic+0x53>

008018ec <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	53                   	push   %ebx
  8018f0:	83 ec 14             	sub    $0x14,%esp
  8018f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8018f6:	8b 13                	mov    (%ebx),%edx
  8018f8:	8d 42 01             	lea    0x1(%edx),%eax
  8018fb:	89 03                	mov    %eax,(%ebx)
  8018fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801900:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801904:	3d ff 00 00 00       	cmp    $0xff,%eax
  801909:	75 19                	jne    801924 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80190b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801912:	00 
  801913:	8d 43 08             	lea    0x8(%ebx),%eax
  801916:	89 04 24             	mov    %eax,(%esp)
  801919:	e8 a0 e7 ff ff       	call   8000be <sys_cputs>
		b->idx = 0;
  80191e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801924:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801928:	83 c4 14             	add    $0x14,%esp
  80192b:	5b                   	pop    %ebx
  80192c:	5d                   	pop    %ebp
  80192d:	c3                   	ret    

0080192e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801937:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80193e:	00 00 00 
	b.cnt = 0;
  801941:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801948:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80194b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	89 44 24 08          	mov    %eax,0x8(%esp)
  801959:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80195f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801963:	c7 04 24 ec 18 80 00 	movl   $0x8018ec,(%esp)
  80196a:	e8 af 01 00 00       	call   801b1e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80196f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801975:	89 44 24 04          	mov    %eax,0x4(%esp)
  801979:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80197f:	89 04 24             	mov    %eax,(%esp)
  801982:	e8 37 e7 ff ff       	call   8000be <sys_cputs>

	return b.cnt;
}
  801987:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
  801992:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801995:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801998:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	89 04 24             	mov    %eax,(%esp)
  8019a2:	e8 87 ff ff ff       	call   80192e <vcprintf>
	va_end(ap);

	return cnt;
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    
  8019a9:	66 90                	xchg   %ax,%ax
  8019ab:	66 90                	xchg   %ax,%ax
  8019ad:	66 90                	xchg   %ax,%ax
  8019af:	90                   	nop

008019b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	57                   	push   %edi
  8019b4:	56                   	push   %esi
  8019b5:	53                   	push   %ebx
  8019b6:	83 ec 3c             	sub    $0x3c,%esp
  8019b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019bc:	89 d7                	mov    %edx,%edi
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c7:	89 c3                	mov    %eax,%ebx
  8019c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8019cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8019d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019da:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8019dd:	39 d9                	cmp    %ebx,%ecx
  8019df:	72 05                	jb     8019e6 <printnum+0x36>
  8019e1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8019e4:	77 69                	ja     801a4f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8019e6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8019e9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8019ed:	83 ee 01             	sub    $0x1,%esi
  8019f0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019fc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801a00:	89 c3                	mov    %eax,%ebx
  801a02:	89 d6                	mov    %edx,%esi
  801a04:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a07:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801a0a:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a0e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a15:	89 04 24             	mov    %eax,(%esp)
  801a18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1f:	e8 ac 0a 00 00       	call   8024d0 <__udivdi3>
  801a24:	89 d9                	mov    %ebx,%ecx
  801a26:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a2a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801a2e:	89 04 24             	mov    %eax,(%esp)
  801a31:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a35:	89 fa                	mov    %edi,%edx
  801a37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a3a:	e8 71 ff ff ff       	call   8019b0 <printnum>
  801a3f:	eb 1b                	jmp    801a5c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801a41:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a45:	8b 45 18             	mov    0x18(%ebp),%eax
  801a48:	89 04 24             	mov    %eax,(%esp)
  801a4b:	ff d3                	call   *%ebx
  801a4d:	eb 03                	jmp    801a52 <printnum+0xa2>
  801a4f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801a52:	83 ee 01             	sub    $0x1,%esi
  801a55:	85 f6                	test   %esi,%esi
  801a57:	7f e8                	jg     801a41 <printnum+0x91>
  801a59:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801a5c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a60:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801a64:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a67:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801a6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a6e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a75:	89 04 24             	mov    %eax,(%esp)
  801a78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a7f:	e8 7c 0b 00 00       	call   802600 <__umoddi3>
  801a84:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a88:	0f be 80 e3 28 80 00 	movsbl 0x8028e3(%eax),%eax
  801a8f:	89 04 24             	mov    %eax,(%esp)
  801a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a95:	ff d0                	call   *%eax
}
  801a97:	83 c4 3c             	add    $0x3c,%esp
  801a9a:	5b                   	pop    %ebx
  801a9b:	5e                   	pop    %esi
  801a9c:	5f                   	pop    %edi
  801a9d:	5d                   	pop    %ebp
  801a9e:	c3                   	ret    

00801a9f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801aa2:	83 fa 01             	cmp    $0x1,%edx
  801aa5:	7e 0e                	jle    801ab5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801aa7:	8b 10                	mov    (%eax),%edx
  801aa9:	8d 4a 08             	lea    0x8(%edx),%ecx
  801aac:	89 08                	mov    %ecx,(%eax)
  801aae:	8b 02                	mov    (%edx),%eax
  801ab0:	8b 52 04             	mov    0x4(%edx),%edx
  801ab3:	eb 22                	jmp    801ad7 <getuint+0x38>
	else if (lflag)
  801ab5:	85 d2                	test   %edx,%edx
  801ab7:	74 10                	je     801ac9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801ab9:	8b 10                	mov    (%eax),%edx
  801abb:	8d 4a 04             	lea    0x4(%edx),%ecx
  801abe:	89 08                	mov    %ecx,(%eax)
  801ac0:	8b 02                	mov    (%edx),%eax
  801ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac7:	eb 0e                	jmp    801ad7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801ac9:	8b 10                	mov    (%eax),%edx
  801acb:	8d 4a 04             	lea    0x4(%edx),%ecx
  801ace:	89 08                	mov    %ecx,(%eax)
  801ad0:	8b 02                	mov    (%edx),%eax
  801ad2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801ad7:	5d                   	pop    %ebp
  801ad8:	c3                   	ret    

00801ad9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801adf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801ae3:	8b 10                	mov    (%eax),%edx
  801ae5:	3b 50 04             	cmp    0x4(%eax),%edx
  801ae8:	73 0a                	jae    801af4 <sprintputch+0x1b>
		*b->buf++ = ch;
  801aea:	8d 4a 01             	lea    0x1(%edx),%ecx
  801aed:	89 08                	mov    %ecx,(%eax)
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	88 02                	mov    %al,(%edx)
}
  801af4:	5d                   	pop    %ebp
  801af5:	c3                   	ret    

00801af6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801afc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801aff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b03:	8b 45 10             	mov    0x10(%ebp),%eax
  801b06:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	89 04 24             	mov    %eax,(%esp)
  801b17:	e8 02 00 00 00       	call   801b1e <vprintfmt>
	va_end(ap);
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	57                   	push   %edi
  801b22:	56                   	push   %esi
  801b23:	53                   	push   %ebx
  801b24:	83 ec 3c             	sub    $0x3c,%esp
  801b27:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b2d:	eb 14                	jmp    801b43 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801b2f:	85 c0                	test   %eax,%eax
  801b31:	0f 84 b3 03 00 00    	je     801eea <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  801b37:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b3b:	89 04 24             	mov    %eax,(%esp)
  801b3e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b41:	89 f3                	mov    %esi,%ebx
  801b43:	8d 73 01             	lea    0x1(%ebx),%esi
  801b46:	0f b6 03             	movzbl (%ebx),%eax
  801b49:	83 f8 25             	cmp    $0x25,%eax
  801b4c:	75 e1                	jne    801b2f <vprintfmt+0x11>
  801b4e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  801b52:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b59:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  801b60:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  801b67:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6c:	eb 1d                	jmp    801b8b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b6e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  801b70:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801b74:	eb 15                	jmp    801b8b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b76:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b78:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801b7c:	eb 0d                	jmp    801b8b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801b7e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b81:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b84:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b8b:	8d 5e 01             	lea    0x1(%esi),%ebx
  801b8e:	0f b6 0e             	movzbl (%esi),%ecx
  801b91:	0f b6 c1             	movzbl %cl,%eax
  801b94:	83 e9 23             	sub    $0x23,%ecx
  801b97:	80 f9 55             	cmp    $0x55,%cl
  801b9a:	0f 87 2a 03 00 00    	ja     801eca <vprintfmt+0x3ac>
  801ba0:	0f b6 c9             	movzbl %cl,%ecx
  801ba3:	ff 24 8d 60 2a 80 00 	jmp    *0x802a60(,%ecx,4)
  801baa:	89 de                	mov    %ebx,%esi
  801bac:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801bb1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801bb4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801bb8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801bbb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  801bbe:	83 fb 09             	cmp    $0x9,%ebx
  801bc1:	77 36                	ja     801bf9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801bc3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801bc6:	eb e9                	jmp    801bb1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcb:	8d 48 04             	lea    0x4(%eax),%ecx
  801bce:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801bd1:	8b 00                	mov    (%eax),%eax
  801bd3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bd6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801bd8:	eb 22                	jmp    801bfc <vprintfmt+0xde>
  801bda:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801bdd:	85 c9                	test   %ecx,%ecx
  801bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801be4:	0f 49 c1             	cmovns %ecx,%eax
  801be7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bea:	89 de                	mov    %ebx,%esi
  801bec:	eb 9d                	jmp    801b8b <vprintfmt+0x6d>
  801bee:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801bf0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  801bf7:	eb 92                	jmp    801b8b <vprintfmt+0x6d>
  801bf9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  801bfc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c00:	79 89                	jns    801b8b <vprintfmt+0x6d>
  801c02:	e9 77 ff ff ff       	jmp    801b7e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801c07:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801c0a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801c0c:	e9 7a ff ff ff       	jmp    801b8b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801c11:	8b 45 14             	mov    0x14(%ebp),%eax
  801c14:	8d 50 04             	lea    0x4(%eax),%edx
  801c17:	89 55 14             	mov    %edx,0x14(%ebp)
  801c1a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c1e:	8b 00                	mov    (%eax),%eax
  801c20:	89 04 24             	mov    %eax,(%esp)
  801c23:	ff 55 08             	call   *0x8(%ebp)
			break;
  801c26:	e9 18 ff ff ff       	jmp    801b43 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801c2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c2e:	8d 50 04             	lea    0x4(%eax),%edx
  801c31:	89 55 14             	mov    %edx,0x14(%ebp)
  801c34:	8b 00                	mov    (%eax),%eax
  801c36:	99                   	cltd   
  801c37:	31 d0                	xor    %edx,%eax
  801c39:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801c3b:	83 f8 12             	cmp    $0x12,%eax
  801c3e:	7f 0b                	jg     801c4b <vprintfmt+0x12d>
  801c40:	8b 14 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%edx
  801c47:	85 d2                	test   %edx,%edx
  801c49:	75 20                	jne    801c6b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  801c4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c4f:	c7 44 24 08 fb 28 80 	movl   $0x8028fb,0x8(%esp)
  801c56:	00 
  801c57:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	89 04 24             	mov    %eax,(%esp)
  801c61:	e8 90 fe ff ff       	call   801af6 <printfmt>
  801c66:	e9 d8 fe ff ff       	jmp    801b43 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801c6b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c6f:	c7 44 24 08 41 28 80 	movl   $0x802841,0x8(%esp)
  801c76:	00 
  801c77:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	89 04 24             	mov    %eax,(%esp)
  801c81:	e8 70 fe ff ff       	call   801af6 <printfmt>
  801c86:	e9 b8 fe ff ff       	jmp    801b43 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801c8b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801c8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c91:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c94:	8b 45 14             	mov    0x14(%ebp),%eax
  801c97:	8d 50 04             	lea    0x4(%eax),%edx
  801c9a:	89 55 14             	mov    %edx,0x14(%ebp)
  801c9d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  801c9f:	85 f6                	test   %esi,%esi
  801ca1:	b8 f4 28 80 00       	mov    $0x8028f4,%eax
  801ca6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  801ca9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  801cad:	0f 84 97 00 00 00    	je     801d4a <vprintfmt+0x22c>
  801cb3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801cb7:	0f 8e 9b 00 00 00    	jle    801d58 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  801cbd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cc1:	89 34 24             	mov    %esi,(%esp)
  801cc4:	e8 cf 02 00 00       	call   801f98 <strnlen>
  801cc9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801ccc:	29 c2                	sub    %eax,%edx
  801cce:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  801cd1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  801cd5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801cd8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801cdb:	8b 75 08             	mov    0x8(%ebp),%esi
  801cde:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801ce1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801ce3:	eb 0f                	jmp    801cf4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  801ce5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ce9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cec:	89 04 24             	mov    %eax,(%esp)
  801cef:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801cf1:	83 eb 01             	sub    $0x1,%ebx
  801cf4:	85 db                	test   %ebx,%ebx
  801cf6:	7f ed                	jg     801ce5 <vprintfmt+0x1c7>
  801cf8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801cfb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801cfe:	85 d2                	test   %edx,%edx
  801d00:	b8 00 00 00 00       	mov    $0x0,%eax
  801d05:	0f 49 c2             	cmovns %edx,%eax
  801d08:	29 c2                	sub    %eax,%edx
  801d0a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801d0d:	89 d7                	mov    %edx,%edi
  801d0f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801d12:	eb 50                	jmp    801d64 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801d14:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d18:	74 1e                	je     801d38 <vprintfmt+0x21a>
  801d1a:	0f be d2             	movsbl %dl,%edx
  801d1d:	83 ea 20             	sub    $0x20,%edx
  801d20:	83 fa 5e             	cmp    $0x5e,%edx
  801d23:	76 13                	jbe    801d38 <vprintfmt+0x21a>
					putch('?', putdat);
  801d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d2c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801d33:	ff 55 08             	call   *0x8(%ebp)
  801d36:	eb 0d                	jmp    801d45 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  801d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3b:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d3f:	89 04 24             	mov    %eax,(%esp)
  801d42:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801d45:	83 ef 01             	sub    $0x1,%edi
  801d48:	eb 1a                	jmp    801d64 <vprintfmt+0x246>
  801d4a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801d4d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801d50:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801d53:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801d56:	eb 0c                	jmp    801d64 <vprintfmt+0x246>
  801d58:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801d5b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801d5e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801d61:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801d64:	83 c6 01             	add    $0x1,%esi
  801d67:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801d6b:	0f be c2             	movsbl %dl,%eax
  801d6e:	85 c0                	test   %eax,%eax
  801d70:	74 27                	je     801d99 <vprintfmt+0x27b>
  801d72:	85 db                	test   %ebx,%ebx
  801d74:	78 9e                	js     801d14 <vprintfmt+0x1f6>
  801d76:	83 eb 01             	sub    $0x1,%ebx
  801d79:	79 99                	jns    801d14 <vprintfmt+0x1f6>
  801d7b:	89 f8                	mov    %edi,%eax
  801d7d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d80:	8b 75 08             	mov    0x8(%ebp),%esi
  801d83:	89 c3                	mov    %eax,%ebx
  801d85:	eb 1a                	jmp    801da1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801d87:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d8b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801d92:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d94:	83 eb 01             	sub    $0x1,%ebx
  801d97:	eb 08                	jmp    801da1 <vprintfmt+0x283>
  801d99:	89 fb                	mov    %edi,%ebx
  801d9b:	8b 75 08             	mov    0x8(%ebp),%esi
  801d9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801da1:	85 db                	test   %ebx,%ebx
  801da3:	7f e2                	jg     801d87 <vprintfmt+0x269>
  801da5:	89 75 08             	mov    %esi,0x8(%ebp)
  801da8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801dab:	e9 93 fd ff ff       	jmp    801b43 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801db0:	83 fa 01             	cmp    $0x1,%edx
  801db3:	7e 16                	jle    801dcb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  801db5:	8b 45 14             	mov    0x14(%ebp),%eax
  801db8:	8d 50 08             	lea    0x8(%eax),%edx
  801dbb:	89 55 14             	mov    %edx,0x14(%ebp)
  801dbe:	8b 50 04             	mov    0x4(%eax),%edx
  801dc1:	8b 00                	mov    (%eax),%eax
  801dc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801dc6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801dc9:	eb 32                	jmp    801dfd <vprintfmt+0x2df>
	else if (lflag)
  801dcb:	85 d2                	test   %edx,%edx
  801dcd:	74 18                	je     801de7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  801dcf:	8b 45 14             	mov    0x14(%ebp),%eax
  801dd2:	8d 50 04             	lea    0x4(%eax),%edx
  801dd5:	89 55 14             	mov    %edx,0x14(%ebp)
  801dd8:	8b 30                	mov    (%eax),%esi
  801dda:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801ddd:	89 f0                	mov    %esi,%eax
  801ddf:	c1 f8 1f             	sar    $0x1f,%eax
  801de2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801de5:	eb 16                	jmp    801dfd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  801de7:	8b 45 14             	mov    0x14(%ebp),%eax
  801dea:	8d 50 04             	lea    0x4(%eax),%edx
  801ded:	89 55 14             	mov    %edx,0x14(%ebp)
  801df0:	8b 30                	mov    (%eax),%esi
  801df2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801df5:	89 f0                	mov    %esi,%eax
  801df7:	c1 f8 1f             	sar    $0x1f,%eax
  801dfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801dfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801e03:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801e08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e0c:	0f 89 80 00 00 00    	jns    801e92 <vprintfmt+0x374>
				putch('-', putdat);
  801e12:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e16:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801e1d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801e20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e26:	f7 d8                	neg    %eax
  801e28:	83 d2 00             	adc    $0x0,%edx
  801e2b:	f7 da                	neg    %edx
			}
			base = 10;
  801e2d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801e32:	eb 5e                	jmp    801e92 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801e34:	8d 45 14             	lea    0x14(%ebp),%eax
  801e37:	e8 63 fc ff ff       	call   801a9f <getuint>
			base = 10;
  801e3c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801e41:	eb 4f                	jmp    801e92 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  801e43:	8d 45 14             	lea    0x14(%ebp),%eax
  801e46:	e8 54 fc ff ff       	call   801a9f <getuint>
			base = 8;
  801e4b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801e50:	eb 40                	jmp    801e92 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  801e52:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e56:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801e5d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801e60:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e64:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801e6b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801e6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e71:	8d 50 04             	lea    0x4(%eax),%edx
  801e74:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801e77:	8b 00                	mov    (%eax),%eax
  801e79:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801e7e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801e83:	eb 0d                	jmp    801e92 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801e85:	8d 45 14             	lea    0x14(%ebp),%eax
  801e88:	e8 12 fc ff ff       	call   801a9f <getuint>
			base = 16;
  801e8d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801e92:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  801e96:	89 74 24 10          	mov    %esi,0x10(%esp)
  801e9a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  801e9d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801ea1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ea5:	89 04 24             	mov    %eax,(%esp)
  801ea8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801eac:	89 fa                	mov    %edi,%edx
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	e8 fa fa ff ff       	call   8019b0 <printnum>
			break;
  801eb6:	e9 88 fc ff ff       	jmp    801b43 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801ebb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ebf:	89 04 24             	mov    %eax,(%esp)
  801ec2:	ff 55 08             	call   *0x8(%ebp)
			break;
  801ec5:	e9 79 fc ff ff       	jmp    801b43 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801eca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ece:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801ed5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ed8:	89 f3                	mov    %esi,%ebx
  801eda:	eb 03                	jmp    801edf <vprintfmt+0x3c1>
  801edc:	83 eb 01             	sub    $0x1,%ebx
  801edf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801ee3:	75 f7                	jne    801edc <vprintfmt+0x3be>
  801ee5:	e9 59 fc ff ff       	jmp    801b43 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801eea:	83 c4 3c             	add    $0x3c,%esp
  801eed:	5b                   	pop    %ebx
  801eee:	5e                   	pop    %esi
  801eef:	5f                   	pop    %edi
  801ef0:	5d                   	pop    %ebp
  801ef1:	c3                   	ret    

00801ef2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 28             	sub    $0x28,%esp
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801efe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f01:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801f05:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801f08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	74 30                	je     801f43 <vsnprintf+0x51>
  801f13:	85 d2                	test   %edx,%edx
  801f15:	7e 2c                	jle    801f43 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801f17:	8b 45 14             	mov    0x14(%ebp),%eax
  801f1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f21:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f25:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2c:	c7 04 24 d9 1a 80 00 	movl   $0x801ad9,(%esp)
  801f33:	e8 e6 fb ff ff       	call   801b1e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801f38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f41:	eb 05                	jmp    801f48 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801f43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f50:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801f53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f57:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f61:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	89 04 24             	mov    %eax,(%esp)
  801f6b:	e8 82 ff ff ff       	call   801ef2 <vsnprintf>
	va_end(ap);

	return rc;
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    
  801f72:	66 90                	xchg   %ax,%ax
  801f74:	66 90                	xchg   %ax,%ax
  801f76:	66 90                	xchg   %ax,%ax
  801f78:	66 90                	xchg   %ax,%ax
  801f7a:	66 90                	xchg   %ax,%ax
  801f7c:	66 90                	xchg   %ax,%ax
  801f7e:	66 90                	xchg   %ax,%ax

00801f80 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801f86:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8b:	eb 03                	jmp    801f90 <strlen+0x10>
		n++;
  801f8d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f90:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801f94:	75 f7                	jne    801f8d <strlen+0xd>
		n++;
	return n;
}
  801f96:	5d                   	pop    %ebp
  801f97:	c3                   	ret    

00801f98 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f9e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fa1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa6:	eb 03                	jmp    801fab <strnlen+0x13>
		n++;
  801fa8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801fab:	39 d0                	cmp    %edx,%eax
  801fad:	74 06                	je     801fb5 <strnlen+0x1d>
  801faf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801fb3:	75 f3                	jne    801fa8 <strnlen+0x10>
		n++;
	return n;
}
  801fb5:	5d                   	pop    %ebp
  801fb6:	c3                   	ret    

00801fb7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	53                   	push   %ebx
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801fc1:	89 c2                	mov    %eax,%edx
  801fc3:	83 c2 01             	add    $0x1,%edx
  801fc6:	83 c1 01             	add    $0x1,%ecx
  801fc9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801fcd:	88 5a ff             	mov    %bl,-0x1(%edx)
  801fd0:	84 db                	test   %bl,%bl
  801fd2:	75 ef                	jne    801fc3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801fd4:	5b                   	pop    %ebx
  801fd5:	5d                   	pop    %ebp
  801fd6:	c3                   	ret    

00801fd7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	53                   	push   %ebx
  801fdb:	83 ec 08             	sub    $0x8,%esp
  801fde:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801fe1:	89 1c 24             	mov    %ebx,(%esp)
  801fe4:	e8 97 ff ff ff       	call   801f80 <strlen>
	strcpy(dst + len, src);
  801fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fec:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ff0:	01 d8                	add    %ebx,%eax
  801ff2:	89 04 24             	mov    %eax,(%esp)
  801ff5:	e8 bd ff ff ff       	call   801fb7 <strcpy>
	return dst;
}
  801ffa:	89 d8                	mov    %ebx,%eax
  801ffc:	83 c4 08             	add    $0x8,%esp
  801fff:	5b                   	pop    %ebx
  802000:	5d                   	pop    %ebp
  802001:	c3                   	ret    

00802002 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	56                   	push   %esi
  802006:	53                   	push   %ebx
  802007:	8b 75 08             	mov    0x8(%ebp),%esi
  80200a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80200d:	89 f3                	mov    %esi,%ebx
  80200f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802012:	89 f2                	mov    %esi,%edx
  802014:	eb 0f                	jmp    802025 <strncpy+0x23>
		*dst++ = *src;
  802016:	83 c2 01             	add    $0x1,%edx
  802019:	0f b6 01             	movzbl (%ecx),%eax
  80201c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80201f:	80 39 01             	cmpb   $0x1,(%ecx)
  802022:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802025:	39 da                	cmp    %ebx,%edx
  802027:	75 ed                	jne    802016 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  802029:	89 f0                	mov    %esi,%eax
  80202b:	5b                   	pop    %ebx
  80202c:	5e                   	pop    %esi
  80202d:	5d                   	pop    %ebp
  80202e:	c3                   	ret    

0080202f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	56                   	push   %esi
  802033:	53                   	push   %ebx
  802034:	8b 75 08             	mov    0x8(%ebp),%esi
  802037:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80203d:	89 f0                	mov    %esi,%eax
  80203f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802043:	85 c9                	test   %ecx,%ecx
  802045:	75 0b                	jne    802052 <strlcpy+0x23>
  802047:	eb 1d                	jmp    802066 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  802049:	83 c0 01             	add    $0x1,%eax
  80204c:	83 c2 01             	add    $0x1,%edx
  80204f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802052:	39 d8                	cmp    %ebx,%eax
  802054:	74 0b                	je     802061 <strlcpy+0x32>
  802056:	0f b6 0a             	movzbl (%edx),%ecx
  802059:	84 c9                	test   %cl,%cl
  80205b:	75 ec                	jne    802049 <strlcpy+0x1a>
  80205d:	89 c2                	mov    %eax,%edx
  80205f:	eb 02                	jmp    802063 <strlcpy+0x34>
  802061:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  802063:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  802066:	29 f0                	sub    %esi,%eax
}
  802068:	5b                   	pop    %ebx
  802069:	5e                   	pop    %esi
  80206a:	5d                   	pop    %ebp
  80206b:	c3                   	ret    

0080206c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802072:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802075:	eb 06                	jmp    80207d <strcmp+0x11>
		p++, q++;
  802077:	83 c1 01             	add    $0x1,%ecx
  80207a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80207d:	0f b6 01             	movzbl (%ecx),%eax
  802080:	84 c0                	test   %al,%al
  802082:	74 04                	je     802088 <strcmp+0x1c>
  802084:	3a 02                	cmp    (%edx),%al
  802086:	74 ef                	je     802077 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802088:	0f b6 c0             	movzbl %al,%eax
  80208b:	0f b6 12             	movzbl (%edx),%edx
  80208e:	29 d0                	sub    %edx,%eax
}
  802090:	5d                   	pop    %ebp
  802091:	c3                   	ret    

00802092 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	53                   	push   %ebx
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209c:	89 c3                	mov    %eax,%ebx
  80209e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8020a1:	eb 06                	jmp    8020a9 <strncmp+0x17>
		n--, p++, q++;
  8020a3:	83 c0 01             	add    $0x1,%eax
  8020a6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8020a9:	39 d8                	cmp    %ebx,%eax
  8020ab:	74 15                	je     8020c2 <strncmp+0x30>
  8020ad:	0f b6 08             	movzbl (%eax),%ecx
  8020b0:	84 c9                	test   %cl,%cl
  8020b2:	74 04                	je     8020b8 <strncmp+0x26>
  8020b4:	3a 0a                	cmp    (%edx),%cl
  8020b6:	74 eb                	je     8020a3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8020b8:	0f b6 00             	movzbl (%eax),%eax
  8020bb:	0f b6 12             	movzbl (%edx),%edx
  8020be:	29 d0                	sub    %edx,%eax
  8020c0:	eb 05                	jmp    8020c7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8020c2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8020c7:	5b                   	pop    %ebx
  8020c8:	5d                   	pop    %ebp
  8020c9:	c3                   	ret    

008020ca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8020d4:	eb 07                	jmp    8020dd <strchr+0x13>
		if (*s == c)
  8020d6:	38 ca                	cmp    %cl,%dl
  8020d8:	74 0f                	je     8020e9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020da:	83 c0 01             	add    $0x1,%eax
  8020dd:	0f b6 10             	movzbl (%eax),%edx
  8020e0:	84 d2                	test   %dl,%dl
  8020e2:	75 f2                	jne    8020d6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8020e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e9:	5d                   	pop    %ebp
  8020ea:	c3                   	ret    

008020eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8020f5:	eb 07                	jmp    8020fe <strfind+0x13>
		if (*s == c)
  8020f7:	38 ca                	cmp    %cl,%dl
  8020f9:	74 0a                	je     802105 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8020fb:	83 c0 01             	add    $0x1,%eax
  8020fe:	0f b6 10             	movzbl (%eax),%edx
  802101:	84 d2                	test   %dl,%dl
  802103:	75 f2                	jne    8020f7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  802105:	5d                   	pop    %ebp
  802106:	c3                   	ret    

00802107 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	57                   	push   %edi
  80210b:	56                   	push   %esi
  80210c:	53                   	push   %ebx
  80210d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802110:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802113:	85 c9                	test   %ecx,%ecx
  802115:	74 36                	je     80214d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802117:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80211d:	75 28                	jne    802147 <memset+0x40>
  80211f:	f6 c1 03             	test   $0x3,%cl
  802122:	75 23                	jne    802147 <memset+0x40>
		c &= 0xFF;
  802124:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802128:	89 d3                	mov    %edx,%ebx
  80212a:	c1 e3 08             	shl    $0x8,%ebx
  80212d:	89 d6                	mov    %edx,%esi
  80212f:	c1 e6 18             	shl    $0x18,%esi
  802132:	89 d0                	mov    %edx,%eax
  802134:	c1 e0 10             	shl    $0x10,%eax
  802137:	09 f0                	or     %esi,%eax
  802139:	09 c2                	or     %eax,%edx
  80213b:	89 d0                	mov    %edx,%eax
  80213d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80213f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802142:	fc                   	cld    
  802143:	f3 ab                	rep stos %eax,%es:(%edi)
  802145:	eb 06                	jmp    80214d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214a:	fc                   	cld    
  80214b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80214d:	89 f8                	mov    %edi,%eax
  80214f:	5b                   	pop    %ebx
  802150:	5e                   	pop    %esi
  802151:	5f                   	pop    %edi
  802152:	5d                   	pop    %ebp
  802153:	c3                   	ret    

00802154 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	57                   	push   %edi
  802158:	56                   	push   %esi
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80215f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802162:	39 c6                	cmp    %eax,%esi
  802164:	73 35                	jae    80219b <memmove+0x47>
  802166:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802169:	39 d0                	cmp    %edx,%eax
  80216b:	73 2e                	jae    80219b <memmove+0x47>
		s += n;
		d += n;
  80216d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  802170:	89 d6                	mov    %edx,%esi
  802172:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802174:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80217a:	75 13                	jne    80218f <memmove+0x3b>
  80217c:	f6 c1 03             	test   $0x3,%cl
  80217f:	75 0e                	jne    80218f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802181:	83 ef 04             	sub    $0x4,%edi
  802184:	8d 72 fc             	lea    -0x4(%edx),%esi
  802187:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80218a:	fd                   	std    
  80218b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80218d:	eb 09                	jmp    802198 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80218f:	83 ef 01             	sub    $0x1,%edi
  802192:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802195:	fd                   	std    
  802196:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802198:	fc                   	cld    
  802199:	eb 1d                	jmp    8021b8 <memmove+0x64>
  80219b:	89 f2                	mov    %esi,%edx
  80219d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80219f:	f6 c2 03             	test   $0x3,%dl
  8021a2:	75 0f                	jne    8021b3 <memmove+0x5f>
  8021a4:	f6 c1 03             	test   $0x3,%cl
  8021a7:	75 0a                	jne    8021b3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8021a9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8021ac:	89 c7                	mov    %eax,%edi
  8021ae:	fc                   	cld    
  8021af:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8021b1:	eb 05                	jmp    8021b8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8021b3:	89 c7                	mov    %eax,%edi
  8021b5:	fc                   	cld    
  8021b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8021b8:	5e                   	pop    %esi
  8021b9:	5f                   	pop    %edi
  8021ba:	5d                   	pop    %ebp
  8021bb:	c3                   	ret    

008021bc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8021c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	89 04 24             	mov    %eax,(%esp)
  8021d6:	e8 79 ff ff ff       	call   802154 <memmove>
}
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    

008021dd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
  8021e0:	56                   	push   %esi
  8021e1:	53                   	push   %ebx
  8021e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021e8:	89 d6                	mov    %edx,%esi
  8021ea:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8021ed:	eb 1a                	jmp    802209 <memcmp+0x2c>
		if (*s1 != *s2)
  8021ef:	0f b6 02             	movzbl (%edx),%eax
  8021f2:	0f b6 19             	movzbl (%ecx),%ebx
  8021f5:	38 d8                	cmp    %bl,%al
  8021f7:	74 0a                	je     802203 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8021f9:	0f b6 c0             	movzbl %al,%eax
  8021fc:	0f b6 db             	movzbl %bl,%ebx
  8021ff:	29 d8                	sub    %ebx,%eax
  802201:	eb 0f                	jmp    802212 <memcmp+0x35>
		s1++, s2++;
  802203:	83 c2 01             	add    $0x1,%edx
  802206:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802209:	39 f2                	cmp    %esi,%edx
  80220b:	75 e2                	jne    8021ef <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80220d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802212:	5b                   	pop    %ebx
  802213:	5e                   	pop    %esi
  802214:	5d                   	pop    %ebp
  802215:	c3                   	ret    

00802216 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80221f:	89 c2                	mov    %eax,%edx
  802221:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802224:	eb 07                	jmp    80222d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  802226:	38 08                	cmp    %cl,(%eax)
  802228:	74 07                	je     802231 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80222a:	83 c0 01             	add    $0x1,%eax
  80222d:	39 d0                	cmp    %edx,%eax
  80222f:	72 f5                	jb     802226 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802231:	5d                   	pop    %ebp
  802232:	c3                   	ret    

00802233 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	57                   	push   %edi
  802237:	56                   	push   %esi
  802238:	53                   	push   %ebx
  802239:	8b 55 08             	mov    0x8(%ebp),%edx
  80223c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80223f:	eb 03                	jmp    802244 <strtol+0x11>
		s++;
  802241:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802244:	0f b6 0a             	movzbl (%edx),%ecx
  802247:	80 f9 09             	cmp    $0x9,%cl
  80224a:	74 f5                	je     802241 <strtol+0xe>
  80224c:	80 f9 20             	cmp    $0x20,%cl
  80224f:	74 f0                	je     802241 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  802251:	80 f9 2b             	cmp    $0x2b,%cl
  802254:	75 0a                	jne    802260 <strtol+0x2d>
		s++;
  802256:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  802259:	bf 00 00 00 00       	mov    $0x0,%edi
  80225e:	eb 11                	jmp    802271 <strtol+0x3e>
  802260:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  802265:	80 f9 2d             	cmp    $0x2d,%cl
  802268:	75 07                	jne    802271 <strtol+0x3e>
		s++, neg = 1;
  80226a:	8d 52 01             	lea    0x1(%edx),%edx
  80226d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802271:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  802276:	75 15                	jne    80228d <strtol+0x5a>
  802278:	80 3a 30             	cmpb   $0x30,(%edx)
  80227b:	75 10                	jne    80228d <strtol+0x5a>
  80227d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  802281:	75 0a                	jne    80228d <strtol+0x5a>
		s += 2, base = 16;
  802283:	83 c2 02             	add    $0x2,%edx
  802286:	b8 10 00 00 00       	mov    $0x10,%eax
  80228b:	eb 10                	jmp    80229d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80228d:	85 c0                	test   %eax,%eax
  80228f:	75 0c                	jne    80229d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802291:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802293:	80 3a 30             	cmpb   $0x30,(%edx)
  802296:	75 05                	jne    80229d <strtol+0x6a>
		s++, base = 8;
  802298:	83 c2 01             	add    $0x1,%edx
  80229b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80229d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022a2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8022a5:	0f b6 0a             	movzbl (%edx),%ecx
  8022a8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8022ab:	89 f0                	mov    %esi,%eax
  8022ad:	3c 09                	cmp    $0x9,%al
  8022af:	77 08                	ja     8022b9 <strtol+0x86>
			dig = *s - '0';
  8022b1:	0f be c9             	movsbl %cl,%ecx
  8022b4:	83 e9 30             	sub    $0x30,%ecx
  8022b7:	eb 20                	jmp    8022d9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  8022b9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8022bc:	89 f0                	mov    %esi,%eax
  8022be:	3c 19                	cmp    $0x19,%al
  8022c0:	77 08                	ja     8022ca <strtol+0x97>
			dig = *s - 'a' + 10;
  8022c2:	0f be c9             	movsbl %cl,%ecx
  8022c5:	83 e9 57             	sub    $0x57,%ecx
  8022c8:	eb 0f                	jmp    8022d9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8022ca:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8022cd:	89 f0                	mov    %esi,%eax
  8022cf:	3c 19                	cmp    $0x19,%al
  8022d1:	77 16                	ja     8022e9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  8022d3:	0f be c9             	movsbl %cl,%ecx
  8022d6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8022d9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8022dc:	7d 0f                	jge    8022ed <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  8022de:	83 c2 01             	add    $0x1,%edx
  8022e1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8022e5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8022e7:	eb bc                	jmp    8022a5 <strtol+0x72>
  8022e9:	89 d8                	mov    %ebx,%eax
  8022eb:	eb 02                	jmp    8022ef <strtol+0xbc>
  8022ed:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8022ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022f3:	74 05                	je     8022fa <strtol+0xc7>
		*endptr = (char *) s;
  8022f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022f8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8022fa:	f7 d8                	neg    %eax
  8022fc:	85 ff                	test   %edi,%edi
  8022fe:	0f 44 c3             	cmove  %ebx,%eax
}
  802301:	5b                   	pop    %ebx
  802302:	5e                   	pop    %esi
  802303:	5f                   	pop    %edi
  802304:	5d                   	pop    %ebp
  802305:	c3                   	ret    

00802306 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80230c:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802313:	75 70                	jne    802385 <set_pgfault_handler+0x7f>
		// First time through!
		// LAB 4: Your code here.
		int error = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_W);
  802315:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  80231c:	00 
  80231d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802324:	ee 
  802325:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80232c:	e8 5a de ff ff       	call   80018b <sys_page_alloc>
		if (error < 0)
  802331:	85 c0                	test   %eax,%eax
  802333:	79 1c                	jns    802351 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: allocation failed");
  802335:	c7 44 24 08 2c 2c 80 	movl   $0x802c2c,0x8(%esp)
  80233c:	00 
  80233d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802344:	00 
  802345:	c7 04 24 7f 2c 80 00 	movl   $0x802c7f,(%esp)
  80234c:	e8 45 f5 ff ff       	call   801896 <_panic>
		error = sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  802351:	c7 44 24 04 b0 05 80 	movl   $0x8005b0,0x4(%esp)
  802358:	00 
  802359:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802360:	e8 c6 df ff ff       	call   80032b <sys_env_set_pgfault_upcall>
		if (error < 0)
  802365:	85 c0                	test   %eax,%eax
  802367:	79 1c                	jns    802385 <set_pgfault_handler+0x7f>
			panic("set_pgfault_handler: pgfault_upcall failed");
  802369:	c7 44 24 08 54 2c 80 	movl   $0x802c54,0x8(%esp)
  802370:	00 
  802371:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802378:	00 
  802379:	c7 04 24 7f 2c 80 00 	movl   $0x802c7f,(%esp)
  802380:	e8 11 f5 ff ff       	call   801896 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    
  80238f:	90                   	nop

00802390 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	56                   	push   %esi
  802394:	53                   	push   %ebx
  802395:	83 ec 10             	sub    $0x10,%esp
  802398:	8b 75 08             	mov    0x8(%ebp),%esi
  80239b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8023a1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  8023a3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8023a8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  8023ab:	89 04 24             	mov    %eax,(%esp)
  8023ae:	e8 ee df ff ff       	call   8003a1 <sys_ipc_recv>
  8023b3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  8023b5:	85 d2                	test   %edx,%edx
  8023b7:	75 24                	jne    8023dd <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  8023b9:	85 f6                	test   %esi,%esi
  8023bb:	74 0a                	je     8023c7 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  8023bd:	a1 08 40 80 00       	mov    0x804008,%eax
  8023c2:	8b 40 74             	mov    0x74(%eax),%eax
  8023c5:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  8023c7:	85 db                	test   %ebx,%ebx
  8023c9:	74 0a                	je     8023d5 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  8023cb:	a1 08 40 80 00       	mov    0x804008,%eax
  8023d0:	8b 40 78             	mov    0x78(%eax),%eax
  8023d3:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  8023d5:	a1 08 40 80 00       	mov    0x804008,%eax
  8023da:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  8023dd:	83 c4 10             	add    $0x10,%esp
  8023e0:	5b                   	pop    %ebx
  8023e1:	5e                   	pop    %esi
  8023e2:	5d                   	pop    %ebp
  8023e3:	c3                   	ret    

008023e4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	57                   	push   %edi
  8023e8:	56                   	push   %esi
  8023e9:	53                   	push   %ebx
  8023ea:	83 ec 1c             	sub    $0x1c,%esp
  8023ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  8023f6:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  8023f8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023fd:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802400:	8b 45 14             	mov    0x14(%ebp),%eax
  802403:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802407:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80240b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80240f:	89 3c 24             	mov    %edi,(%esp)
  802412:	e8 67 df ff ff       	call   80037e <sys_ipc_try_send>

		if (ret == 0)
  802417:	85 c0                	test   %eax,%eax
  802419:	74 2c                	je     802447 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80241b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80241e:	74 20                	je     802440 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802420:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802424:	c7 44 24 08 90 2c 80 	movl   $0x802c90,0x8(%esp)
  80242b:	00 
  80242c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802433:	00 
  802434:	c7 04 24 c0 2c 80 00 	movl   $0x802cc0,(%esp)
  80243b:	e8 56 f4 ff ff       	call   801896 <_panic>
		}

		sys_yield();
  802440:	e8 27 dd ff ff       	call   80016c <sys_yield>
	}
  802445:	eb b9                	jmp    802400 <ipc_send+0x1c>
}
  802447:	83 c4 1c             	add    $0x1c,%esp
  80244a:	5b                   	pop    %ebx
  80244b:	5e                   	pop    %esi
  80244c:	5f                   	pop    %edi
  80244d:	5d                   	pop    %ebp
  80244e:	c3                   	ret    

0080244f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
  802452:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802455:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80245a:	89 c2                	mov    %eax,%edx
  80245c:	c1 e2 07             	shl    $0x7,%edx
  80245f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802466:	8b 52 50             	mov    0x50(%edx),%edx
  802469:	39 ca                	cmp    %ecx,%edx
  80246b:	75 11                	jne    80247e <ipc_find_env+0x2f>
			return envs[i].env_id;
  80246d:	89 c2                	mov    %eax,%edx
  80246f:	c1 e2 07             	shl    $0x7,%edx
  802472:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  802479:	8b 40 40             	mov    0x40(%eax),%eax
  80247c:	eb 0e                	jmp    80248c <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80247e:	83 c0 01             	add    $0x1,%eax
  802481:	3d 00 04 00 00       	cmp    $0x400,%eax
  802486:	75 d2                	jne    80245a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802488:	66 b8 00 00          	mov    $0x0,%ax
}
  80248c:	5d                   	pop    %ebp
  80248d:	c3                   	ret    

0080248e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
  802491:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802494:	89 d0                	mov    %edx,%eax
  802496:	c1 e8 16             	shr    $0x16,%eax
  802499:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024a0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024a5:	f6 c1 01             	test   $0x1,%cl
  8024a8:	74 1d                	je     8024c7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8024aa:	c1 ea 0c             	shr    $0xc,%edx
  8024ad:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024b4:	f6 c2 01             	test   $0x1,%dl
  8024b7:	74 0e                	je     8024c7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024b9:	c1 ea 0c             	shr    $0xc,%edx
  8024bc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024c3:	ef 
  8024c4:	0f b7 c0             	movzwl %ax,%eax
}
  8024c7:	5d                   	pop    %ebp
  8024c8:	c3                   	ret    
  8024c9:	66 90                	xchg   %ax,%ax
  8024cb:	66 90                	xchg   %ax,%ax
  8024cd:	66 90                	xchg   %ax,%ax
  8024cf:	90                   	nop

008024d0 <__udivdi3>:
  8024d0:	55                   	push   %ebp
  8024d1:	57                   	push   %edi
  8024d2:	56                   	push   %esi
  8024d3:	83 ec 0c             	sub    $0xc,%esp
  8024d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8024da:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8024de:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8024e2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024e6:	85 c0                	test   %eax,%eax
  8024e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024ec:	89 ea                	mov    %ebp,%edx
  8024ee:	89 0c 24             	mov    %ecx,(%esp)
  8024f1:	75 2d                	jne    802520 <__udivdi3+0x50>
  8024f3:	39 e9                	cmp    %ebp,%ecx
  8024f5:	77 61                	ja     802558 <__udivdi3+0x88>
  8024f7:	85 c9                	test   %ecx,%ecx
  8024f9:	89 ce                	mov    %ecx,%esi
  8024fb:	75 0b                	jne    802508 <__udivdi3+0x38>
  8024fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802502:	31 d2                	xor    %edx,%edx
  802504:	f7 f1                	div    %ecx
  802506:	89 c6                	mov    %eax,%esi
  802508:	31 d2                	xor    %edx,%edx
  80250a:	89 e8                	mov    %ebp,%eax
  80250c:	f7 f6                	div    %esi
  80250e:	89 c5                	mov    %eax,%ebp
  802510:	89 f8                	mov    %edi,%eax
  802512:	f7 f6                	div    %esi
  802514:	89 ea                	mov    %ebp,%edx
  802516:	83 c4 0c             	add    $0xc,%esp
  802519:	5e                   	pop    %esi
  80251a:	5f                   	pop    %edi
  80251b:	5d                   	pop    %ebp
  80251c:	c3                   	ret    
  80251d:	8d 76 00             	lea    0x0(%esi),%esi
  802520:	39 e8                	cmp    %ebp,%eax
  802522:	77 24                	ja     802548 <__udivdi3+0x78>
  802524:	0f bd e8             	bsr    %eax,%ebp
  802527:	83 f5 1f             	xor    $0x1f,%ebp
  80252a:	75 3c                	jne    802568 <__udivdi3+0x98>
  80252c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802530:	39 34 24             	cmp    %esi,(%esp)
  802533:	0f 86 9f 00 00 00    	jbe    8025d8 <__udivdi3+0x108>
  802539:	39 d0                	cmp    %edx,%eax
  80253b:	0f 82 97 00 00 00    	jb     8025d8 <__udivdi3+0x108>
  802541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802548:	31 d2                	xor    %edx,%edx
  80254a:	31 c0                	xor    %eax,%eax
  80254c:	83 c4 0c             	add    $0xc,%esp
  80254f:	5e                   	pop    %esi
  802550:	5f                   	pop    %edi
  802551:	5d                   	pop    %ebp
  802552:	c3                   	ret    
  802553:	90                   	nop
  802554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802558:	89 f8                	mov    %edi,%eax
  80255a:	f7 f1                	div    %ecx
  80255c:	31 d2                	xor    %edx,%edx
  80255e:	83 c4 0c             	add    $0xc,%esp
  802561:	5e                   	pop    %esi
  802562:	5f                   	pop    %edi
  802563:	5d                   	pop    %ebp
  802564:	c3                   	ret    
  802565:	8d 76 00             	lea    0x0(%esi),%esi
  802568:	89 e9                	mov    %ebp,%ecx
  80256a:	8b 3c 24             	mov    (%esp),%edi
  80256d:	d3 e0                	shl    %cl,%eax
  80256f:	89 c6                	mov    %eax,%esi
  802571:	b8 20 00 00 00       	mov    $0x20,%eax
  802576:	29 e8                	sub    %ebp,%eax
  802578:	89 c1                	mov    %eax,%ecx
  80257a:	d3 ef                	shr    %cl,%edi
  80257c:	89 e9                	mov    %ebp,%ecx
  80257e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802582:	8b 3c 24             	mov    (%esp),%edi
  802585:	09 74 24 08          	or     %esi,0x8(%esp)
  802589:	89 d6                	mov    %edx,%esi
  80258b:	d3 e7                	shl    %cl,%edi
  80258d:	89 c1                	mov    %eax,%ecx
  80258f:	89 3c 24             	mov    %edi,(%esp)
  802592:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802596:	d3 ee                	shr    %cl,%esi
  802598:	89 e9                	mov    %ebp,%ecx
  80259a:	d3 e2                	shl    %cl,%edx
  80259c:	89 c1                	mov    %eax,%ecx
  80259e:	d3 ef                	shr    %cl,%edi
  8025a0:	09 d7                	or     %edx,%edi
  8025a2:	89 f2                	mov    %esi,%edx
  8025a4:	89 f8                	mov    %edi,%eax
  8025a6:	f7 74 24 08          	divl   0x8(%esp)
  8025aa:	89 d6                	mov    %edx,%esi
  8025ac:	89 c7                	mov    %eax,%edi
  8025ae:	f7 24 24             	mull   (%esp)
  8025b1:	39 d6                	cmp    %edx,%esi
  8025b3:	89 14 24             	mov    %edx,(%esp)
  8025b6:	72 30                	jb     8025e8 <__udivdi3+0x118>
  8025b8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025bc:	89 e9                	mov    %ebp,%ecx
  8025be:	d3 e2                	shl    %cl,%edx
  8025c0:	39 c2                	cmp    %eax,%edx
  8025c2:	73 05                	jae    8025c9 <__udivdi3+0xf9>
  8025c4:	3b 34 24             	cmp    (%esp),%esi
  8025c7:	74 1f                	je     8025e8 <__udivdi3+0x118>
  8025c9:	89 f8                	mov    %edi,%eax
  8025cb:	31 d2                	xor    %edx,%edx
  8025cd:	e9 7a ff ff ff       	jmp    80254c <__udivdi3+0x7c>
  8025d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025d8:	31 d2                	xor    %edx,%edx
  8025da:	b8 01 00 00 00       	mov    $0x1,%eax
  8025df:	e9 68 ff ff ff       	jmp    80254c <__udivdi3+0x7c>
  8025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025e8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8025eb:	31 d2                	xor    %edx,%edx
  8025ed:	83 c4 0c             	add    $0xc,%esp
  8025f0:	5e                   	pop    %esi
  8025f1:	5f                   	pop    %edi
  8025f2:	5d                   	pop    %ebp
  8025f3:	c3                   	ret    
  8025f4:	66 90                	xchg   %ax,%ax
  8025f6:	66 90                	xchg   %ax,%ax
  8025f8:	66 90                	xchg   %ax,%ax
  8025fa:	66 90                	xchg   %ax,%ax
  8025fc:	66 90                	xchg   %ax,%ax
  8025fe:	66 90                	xchg   %ax,%ax

00802600 <__umoddi3>:
  802600:	55                   	push   %ebp
  802601:	57                   	push   %edi
  802602:	56                   	push   %esi
  802603:	83 ec 14             	sub    $0x14,%esp
  802606:	8b 44 24 28          	mov    0x28(%esp),%eax
  80260a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80260e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802612:	89 c7                	mov    %eax,%edi
  802614:	89 44 24 04          	mov    %eax,0x4(%esp)
  802618:	8b 44 24 30          	mov    0x30(%esp),%eax
  80261c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802620:	89 34 24             	mov    %esi,(%esp)
  802623:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802627:	85 c0                	test   %eax,%eax
  802629:	89 c2                	mov    %eax,%edx
  80262b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80262f:	75 17                	jne    802648 <__umoddi3+0x48>
  802631:	39 fe                	cmp    %edi,%esi
  802633:	76 4b                	jbe    802680 <__umoddi3+0x80>
  802635:	89 c8                	mov    %ecx,%eax
  802637:	89 fa                	mov    %edi,%edx
  802639:	f7 f6                	div    %esi
  80263b:	89 d0                	mov    %edx,%eax
  80263d:	31 d2                	xor    %edx,%edx
  80263f:	83 c4 14             	add    $0x14,%esp
  802642:	5e                   	pop    %esi
  802643:	5f                   	pop    %edi
  802644:	5d                   	pop    %ebp
  802645:	c3                   	ret    
  802646:	66 90                	xchg   %ax,%ax
  802648:	39 f8                	cmp    %edi,%eax
  80264a:	77 54                	ja     8026a0 <__umoddi3+0xa0>
  80264c:	0f bd e8             	bsr    %eax,%ebp
  80264f:	83 f5 1f             	xor    $0x1f,%ebp
  802652:	75 5c                	jne    8026b0 <__umoddi3+0xb0>
  802654:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802658:	39 3c 24             	cmp    %edi,(%esp)
  80265b:	0f 87 e7 00 00 00    	ja     802748 <__umoddi3+0x148>
  802661:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802665:	29 f1                	sub    %esi,%ecx
  802667:	19 c7                	sbb    %eax,%edi
  802669:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80266d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802671:	8b 44 24 08          	mov    0x8(%esp),%eax
  802675:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802679:	83 c4 14             	add    $0x14,%esp
  80267c:	5e                   	pop    %esi
  80267d:	5f                   	pop    %edi
  80267e:	5d                   	pop    %ebp
  80267f:	c3                   	ret    
  802680:	85 f6                	test   %esi,%esi
  802682:	89 f5                	mov    %esi,%ebp
  802684:	75 0b                	jne    802691 <__umoddi3+0x91>
  802686:	b8 01 00 00 00       	mov    $0x1,%eax
  80268b:	31 d2                	xor    %edx,%edx
  80268d:	f7 f6                	div    %esi
  80268f:	89 c5                	mov    %eax,%ebp
  802691:	8b 44 24 04          	mov    0x4(%esp),%eax
  802695:	31 d2                	xor    %edx,%edx
  802697:	f7 f5                	div    %ebp
  802699:	89 c8                	mov    %ecx,%eax
  80269b:	f7 f5                	div    %ebp
  80269d:	eb 9c                	jmp    80263b <__umoddi3+0x3b>
  80269f:	90                   	nop
  8026a0:	89 c8                	mov    %ecx,%eax
  8026a2:	89 fa                	mov    %edi,%edx
  8026a4:	83 c4 14             	add    $0x14,%esp
  8026a7:	5e                   	pop    %esi
  8026a8:	5f                   	pop    %edi
  8026a9:	5d                   	pop    %ebp
  8026aa:	c3                   	ret    
  8026ab:	90                   	nop
  8026ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026b0:	8b 04 24             	mov    (%esp),%eax
  8026b3:	be 20 00 00 00       	mov    $0x20,%esi
  8026b8:	89 e9                	mov    %ebp,%ecx
  8026ba:	29 ee                	sub    %ebp,%esi
  8026bc:	d3 e2                	shl    %cl,%edx
  8026be:	89 f1                	mov    %esi,%ecx
  8026c0:	d3 e8                	shr    %cl,%eax
  8026c2:	89 e9                	mov    %ebp,%ecx
  8026c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c8:	8b 04 24             	mov    (%esp),%eax
  8026cb:	09 54 24 04          	or     %edx,0x4(%esp)
  8026cf:	89 fa                	mov    %edi,%edx
  8026d1:	d3 e0                	shl    %cl,%eax
  8026d3:	89 f1                	mov    %esi,%ecx
  8026d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026d9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8026dd:	d3 ea                	shr    %cl,%edx
  8026df:	89 e9                	mov    %ebp,%ecx
  8026e1:	d3 e7                	shl    %cl,%edi
  8026e3:	89 f1                	mov    %esi,%ecx
  8026e5:	d3 e8                	shr    %cl,%eax
  8026e7:	89 e9                	mov    %ebp,%ecx
  8026e9:	09 f8                	or     %edi,%eax
  8026eb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8026ef:	f7 74 24 04          	divl   0x4(%esp)
  8026f3:	d3 e7                	shl    %cl,%edi
  8026f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026f9:	89 d7                	mov    %edx,%edi
  8026fb:	f7 64 24 08          	mull   0x8(%esp)
  8026ff:	39 d7                	cmp    %edx,%edi
  802701:	89 c1                	mov    %eax,%ecx
  802703:	89 14 24             	mov    %edx,(%esp)
  802706:	72 2c                	jb     802734 <__umoddi3+0x134>
  802708:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80270c:	72 22                	jb     802730 <__umoddi3+0x130>
  80270e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802712:	29 c8                	sub    %ecx,%eax
  802714:	19 d7                	sbb    %edx,%edi
  802716:	89 e9                	mov    %ebp,%ecx
  802718:	89 fa                	mov    %edi,%edx
  80271a:	d3 e8                	shr    %cl,%eax
  80271c:	89 f1                	mov    %esi,%ecx
  80271e:	d3 e2                	shl    %cl,%edx
  802720:	89 e9                	mov    %ebp,%ecx
  802722:	d3 ef                	shr    %cl,%edi
  802724:	09 d0                	or     %edx,%eax
  802726:	89 fa                	mov    %edi,%edx
  802728:	83 c4 14             	add    $0x14,%esp
  80272b:	5e                   	pop    %esi
  80272c:	5f                   	pop    %edi
  80272d:	5d                   	pop    %ebp
  80272e:	c3                   	ret    
  80272f:	90                   	nop
  802730:	39 d7                	cmp    %edx,%edi
  802732:	75 da                	jne    80270e <__umoddi3+0x10e>
  802734:	8b 14 24             	mov    (%esp),%edx
  802737:	89 c1                	mov    %eax,%ecx
  802739:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80273d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802741:	eb cb                	jmp    80270e <__umoddi3+0x10e>
  802743:	90                   	nop
  802744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802748:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80274c:	0f 82 0f ff ff ff    	jb     802661 <__umoddi3+0x61>
  802752:	e9 1a ff ff ff       	jmp    802671 <__umoddi3+0x71>
