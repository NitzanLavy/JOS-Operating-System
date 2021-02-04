
obj/user/faultbadhandler.debug:     file format elf32-i386


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
  80002c:	e8 44 00 00 00       	call   800075 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800040:	00 
  800041:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800048:	ee 
  800049:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800050:	e8 52 01 00 00       	call   8001a7 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xDeadBeef);
  800055:	c7 44 24 04 ef be ad 	movl   $0xdeadbeef,0x4(%esp)
  80005c:	de 
  80005d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800064:	e8 de 02 00 00       	call   800347 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800069:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800070:	00 00 00 
}
  800073:	c9                   	leave  
  800074:	c3                   	ret    

00800075 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800075:	55                   	push   %ebp
  800076:	89 e5                	mov    %esp,%ebp
  800078:	56                   	push   %esi
  800079:	53                   	push   %ebx
  80007a:	83 ec 10             	sub    $0x10,%esp
  80007d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800080:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800083:	e8 e1 00 00 00       	call   800169 <sys_getenvid>
  800088:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008d:	89 c2                	mov    %eax,%edx
  80008f:	c1 e2 07             	shl    $0x7,%edx
  800092:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800099:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009e:	85 db                	test   %ebx,%ebx
  8000a0:	7e 07                	jle    8000a9 <libmain+0x34>
		binaryname = argv[0];
  8000a2:	8b 06                	mov    (%esi),%eax
  8000a4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000ad:	89 1c 24             	mov    %ebx,(%esp)
  8000b0:	e8 7e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b5:	e8 07 00 00 00       	call   8000c1 <exit>
}
  8000ba:	83 c4 10             	add    $0x10,%esp
  8000bd:	5b                   	pop    %ebx
  8000be:	5e                   	pop    %esi
  8000bf:	5d                   	pop    %ebp
  8000c0:	c3                   	ret    

008000c1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000c7:	e8 de 06 00 00       	call   8007aa <close_all>
	sys_env_destroy(0);
  8000cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000d3:	e8 3f 00 00 00       	call   800117 <sys_env_destroy>
}
  8000d8:	c9                   	leave  
  8000d9:	c3                   	ret    

008000da <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000da:	55                   	push   %ebp
  8000db:	89 e5                	mov    %esp,%ebp
  8000dd:	57                   	push   %edi
  8000de:	56                   	push   %esi
  8000df:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000eb:	89 c3                	mov    %eax,%ebx
  8000ed:	89 c7                	mov    %eax,%edi
  8000ef:	89 c6                	mov    %eax,%esi
  8000f1:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5f                   	pop    %edi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    

008000f8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	57                   	push   %edi
  8000fc:	56                   	push   %esi
  8000fd:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800103:	b8 01 00 00 00       	mov    $0x1,%eax
  800108:	89 d1                	mov    %edx,%ecx
  80010a:	89 d3                	mov    %edx,%ebx
  80010c:	89 d7                	mov    %edx,%edi
  80010e:	89 d6                	mov    %edx,%esi
  800110:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800112:	5b                   	pop    %ebx
  800113:	5e                   	pop    %esi
  800114:	5f                   	pop    %edi
  800115:	5d                   	pop    %ebp
  800116:	c3                   	ret    

00800117 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800117:	55                   	push   %ebp
  800118:	89 e5                	mov    %esp,%ebp
  80011a:	57                   	push   %edi
  80011b:	56                   	push   %esi
  80011c:	53                   	push   %ebx
  80011d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800120:	b9 00 00 00 00       	mov    $0x0,%ecx
  800125:	b8 03 00 00 00       	mov    $0x3,%eax
  80012a:	8b 55 08             	mov    0x8(%ebp),%edx
  80012d:	89 cb                	mov    %ecx,%ebx
  80012f:	89 cf                	mov    %ecx,%edi
  800131:	89 ce                	mov    %ecx,%esi
  800133:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800135:	85 c0                	test   %eax,%eax
  800137:	7e 28                	jle    800161 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800139:	89 44 24 10          	mov    %eax,0x10(%esp)
  80013d:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800144:	00 
  800145:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  80014c:	00 
  80014d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800154:	00 
  800155:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  80015c:	e8 25 17 00 00       	call   801886 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800161:	83 c4 2c             	add    $0x2c,%esp
  800164:	5b                   	pop    %ebx
  800165:	5e                   	pop    %esi
  800166:	5f                   	pop    %edi
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    

00800169 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800169:	55                   	push   %ebp
  80016a:	89 e5                	mov    %esp,%ebp
  80016c:	57                   	push   %edi
  80016d:	56                   	push   %esi
  80016e:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80016f:	ba 00 00 00 00       	mov    $0x0,%edx
  800174:	b8 02 00 00 00       	mov    $0x2,%eax
  800179:	89 d1                	mov    %edx,%ecx
  80017b:	89 d3                	mov    %edx,%ebx
  80017d:	89 d7                	mov    %edx,%edi
  80017f:	89 d6                	mov    %edx,%esi
  800181:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800183:	5b                   	pop    %ebx
  800184:	5e                   	pop    %esi
  800185:	5f                   	pop    %edi
  800186:	5d                   	pop    %ebp
  800187:	c3                   	ret    

00800188 <sys_yield>:

void
sys_yield(void)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	57                   	push   %edi
  80018c:	56                   	push   %esi
  80018d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80018e:	ba 00 00 00 00       	mov    $0x0,%edx
  800193:	b8 0b 00 00 00       	mov    $0xb,%eax
  800198:	89 d1                	mov    %edx,%ecx
  80019a:	89 d3                	mov    %edx,%ebx
  80019c:	89 d7                	mov    %edx,%edi
  80019e:	89 d6                	mov    %edx,%esi
  8001a0:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001a2:	5b                   	pop    %ebx
  8001a3:	5e                   	pop    %esi
  8001a4:	5f                   	pop    %edi
  8001a5:	5d                   	pop    %ebp
  8001a6:	c3                   	ret    

008001a7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	57                   	push   %edi
  8001ab:	56                   	push   %esi
  8001ac:	53                   	push   %ebx
  8001ad:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001b0:	be 00 00 00 00       	mov    $0x0,%esi
  8001b5:	b8 04 00 00 00       	mov    $0x4,%eax
  8001ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c3:	89 f7                	mov    %esi,%edi
  8001c5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001c7:	85 c0                	test   %eax,%eax
  8001c9:	7e 28                	jle    8001f3 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001cb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001cf:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8001d6:	00 
  8001d7:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  8001de:	00 
  8001df:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001e6:	00 
  8001e7:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  8001ee:	e8 93 16 00 00       	call   801886 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001f3:	83 c4 2c             	add    $0x2c,%esp
  8001f6:	5b                   	pop    %ebx
  8001f7:	5e                   	pop    %esi
  8001f8:	5f                   	pop    %edi
  8001f9:	5d                   	pop    %ebp
  8001fa:	c3                   	ret    

008001fb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001fb:	55                   	push   %ebp
  8001fc:	89 e5                	mov    %esp,%ebp
  8001fe:	57                   	push   %edi
  8001ff:	56                   	push   %esi
  800200:	53                   	push   %ebx
  800201:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800204:	b8 05 00 00 00       	mov    $0x5,%eax
  800209:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80020c:	8b 55 08             	mov    0x8(%ebp),%edx
  80020f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800212:	8b 7d 14             	mov    0x14(%ebp),%edi
  800215:	8b 75 18             	mov    0x18(%ebp),%esi
  800218:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80021a:	85 c0                	test   %eax,%eax
  80021c:	7e 28                	jle    800246 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80021e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800222:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800229:	00 
  80022a:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  800231:	00 
  800232:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800239:	00 
  80023a:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  800241:	e8 40 16 00 00       	call   801886 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800246:	83 c4 2c             	add    $0x2c,%esp
  800249:	5b                   	pop    %ebx
  80024a:	5e                   	pop    %esi
  80024b:	5f                   	pop    %edi
  80024c:	5d                   	pop    %ebp
  80024d:	c3                   	ret    

0080024e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	57                   	push   %edi
  800252:	56                   	push   %esi
  800253:	53                   	push   %ebx
  800254:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800257:	bb 00 00 00 00       	mov    $0x0,%ebx
  80025c:	b8 06 00 00 00       	mov    $0x6,%eax
  800261:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800264:	8b 55 08             	mov    0x8(%ebp),%edx
  800267:	89 df                	mov    %ebx,%edi
  800269:	89 de                	mov    %ebx,%esi
  80026b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80026d:	85 c0                	test   %eax,%eax
  80026f:	7e 28                	jle    800299 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800271:	89 44 24 10          	mov    %eax,0x10(%esp)
  800275:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80027c:	00 
  80027d:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  800284:	00 
  800285:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80028c:	00 
  80028d:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  800294:	e8 ed 15 00 00       	call   801886 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800299:	83 c4 2c             	add    $0x2c,%esp
  80029c:	5b                   	pop    %ebx
  80029d:	5e                   	pop    %esi
  80029e:	5f                   	pop    %edi
  80029f:	5d                   	pop    %ebp
  8002a0:	c3                   	ret    

008002a1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	57                   	push   %edi
  8002a5:	56                   	push   %esi
  8002a6:	53                   	push   %ebx
  8002a7:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002af:	b8 08 00 00 00       	mov    $0x8,%eax
  8002b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ba:	89 df                	mov    %ebx,%edi
  8002bc:	89 de                	mov    %ebx,%esi
  8002be:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002c0:	85 c0                	test   %eax,%eax
  8002c2:	7e 28                	jle    8002ec <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002c8:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8002cf:	00 
  8002d0:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  8002d7:	00 
  8002d8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002df:	00 
  8002e0:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  8002e7:	e8 9a 15 00 00       	call   801886 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002ec:	83 c4 2c             	add    $0x2c,%esp
  8002ef:	5b                   	pop    %ebx
  8002f0:	5e                   	pop    %esi
  8002f1:	5f                   	pop    %edi
  8002f2:	5d                   	pop    %ebp
  8002f3:	c3                   	ret    

008002f4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	57                   	push   %edi
  8002f8:	56                   	push   %esi
  8002f9:	53                   	push   %ebx
  8002fa:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800302:	b8 09 00 00 00       	mov    $0x9,%eax
  800307:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80030a:	8b 55 08             	mov    0x8(%ebp),%edx
  80030d:	89 df                	mov    %ebx,%edi
  80030f:	89 de                	mov    %ebx,%esi
  800311:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800313:	85 c0                	test   %eax,%eax
  800315:	7e 28                	jle    80033f <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800317:	89 44 24 10          	mov    %eax,0x10(%esp)
  80031b:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800322:	00 
  800323:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  80032a:	00 
  80032b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800332:	00 
  800333:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  80033a:	e8 47 15 00 00       	call   801886 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80033f:	83 c4 2c             	add    $0x2c,%esp
  800342:	5b                   	pop    %ebx
  800343:	5e                   	pop    %esi
  800344:	5f                   	pop    %edi
  800345:	5d                   	pop    %ebp
  800346:	c3                   	ret    

00800347 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	57                   	push   %edi
  80034b:	56                   	push   %esi
  80034c:	53                   	push   %ebx
  80034d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800350:	bb 00 00 00 00       	mov    $0x0,%ebx
  800355:	b8 0a 00 00 00       	mov    $0xa,%eax
  80035a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80035d:	8b 55 08             	mov    0x8(%ebp),%edx
  800360:	89 df                	mov    %ebx,%edi
  800362:	89 de                	mov    %ebx,%esi
  800364:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800366:	85 c0                	test   %eax,%eax
  800368:	7e 28                	jle    800392 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80036a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80036e:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800375:	00 
  800376:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  80037d:	00 
  80037e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800385:	00 
  800386:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  80038d:	e8 f4 14 00 00       	call   801886 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800392:	83 c4 2c             	add    $0x2c,%esp
  800395:	5b                   	pop    %ebx
  800396:	5e                   	pop    %esi
  800397:	5f                   	pop    %edi
  800398:	5d                   	pop    %ebp
  800399:	c3                   	ret    

0080039a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	57                   	push   %edi
  80039e:	56                   	push   %esi
  80039f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003a0:	be 00 00 00 00       	mov    $0x0,%esi
  8003a5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8003aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003b3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8003b6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8003b8:	5b                   	pop    %ebx
  8003b9:	5e                   	pop    %esi
  8003ba:	5f                   	pop    %edi
  8003bb:	5d                   	pop    %ebp
  8003bc:	c3                   	ret    

008003bd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	57                   	push   %edi
  8003c1:	56                   	push   %esi
  8003c2:	53                   	push   %ebx
  8003c3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003cb:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8003d3:	89 cb                	mov    %ecx,%ebx
  8003d5:	89 cf                	mov    %ecx,%edi
  8003d7:	89 ce                	mov    %ecx,%esi
  8003d9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003db:	85 c0                	test   %eax,%eax
  8003dd:	7e 28                	jle    800407 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003df:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003e3:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8003ea:	00 
  8003eb:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  8003f2:	00 
  8003f3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003fa:	00 
  8003fb:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  800402:	e8 7f 14 00 00       	call   801886 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800407:	83 c4 2c             	add    $0x2c,%esp
  80040a:	5b                   	pop    %ebx
  80040b:	5e                   	pop    %esi
  80040c:	5f                   	pop    %edi
  80040d:	5d                   	pop    %ebp
  80040e:	c3                   	ret    

0080040f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
  800412:	57                   	push   %edi
  800413:	56                   	push   %esi
  800414:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800415:	ba 00 00 00 00       	mov    $0x0,%edx
  80041a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80041f:	89 d1                	mov    %edx,%ecx
  800421:	89 d3                	mov    %edx,%ebx
  800423:	89 d7                	mov    %edx,%edi
  800425:	89 d6                	mov    %edx,%esi
  800427:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800429:	5b                   	pop    %ebx
  80042a:	5e                   	pop    %esi
  80042b:	5f                   	pop    %edi
  80042c:	5d                   	pop    %ebp
  80042d:	c3                   	ret    

0080042e <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	57                   	push   %edi
  800432:	56                   	push   %esi
  800433:	53                   	push   %ebx
  800434:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800437:	bb 00 00 00 00       	mov    $0x0,%ebx
  80043c:	b8 0f 00 00 00       	mov    $0xf,%eax
  800441:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800444:	8b 55 08             	mov    0x8(%ebp),%edx
  800447:	89 df                	mov    %ebx,%edi
  800449:	89 de                	mov    %ebx,%esi
  80044b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80044d:	85 c0                	test   %eax,%eax
  80044f:	7e 28                	jle    800479 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800451:	89 44 24 10          	mov    %eax,0x10(%esp)
  800455:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80045c:	00 
  80045d:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  800464:	00 
  800465:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80046c:	00 
  80046d:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  800474:	e8 0d 14 00 00       	call   801886 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800479:	83 c4 2c             	add    $0x2c,%esp
  80047c:	5b                   	pop    %ebx
  80047d:	5e                   	pop    %esi
  80047e:	5f                   	pop    %edi
  80047f:	5d                   	pop    %ebp
  800480:	c3                   	ret    

00800481 <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	57                   	push   %edi
  800485:	56                   	push   %esi
  800486:	53                   	push   %ebx
  800487:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80048a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80048f:	b8 10 00 00 00       	mov    $0x10,%eax
  800494:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800497:	8b 55 08             	mov    0x8(%ebp),%edx
  80049a:	89 df                	mov    %ebx,%edi
  80049c:	89 de                	mov    %ebx,%esi
  80049e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8004a0:	85 c0                	test   %eax,%eax
  8004a2:	7e 28                	jle    8004cc <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8004a4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004a8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8004af:	00 
  8004b0:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  8004b7:	00 
  8004b8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004bf:	00 
  8004c0:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  8004c7:	e8 ba 13 00 00       	call   801886 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  8004cc:	83 c4 2c             	add    $0x2c,%esp
  8004cf:	5b                   	pop    %ebx
  8004d0:	5e                   	pop    %esi
  8004d1:	5f                   	pop    %edi
  8004d2:	5d                   	pop    %ebp
  8004d3:	c3                   	ret    

008004d4 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
  8004d7:	57                   	push   %edi
  8004d8:	56                   	push   %esi
  8004d9:	53                   	push   %ebx
  8004da:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004e2:	b8 11 00 00 00       	mov    $0x11,%eax
  8004e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ed:	89 df                	mov    %ebx,%edi
  8004ef:	89 de                	mov    %ebx,%esi
  8004f1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8004f3:	85 c0                	test   %eax,%eax
  8004f5:	7e 28                	jle    80051f <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8004f7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004fb:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  800502:	00 
  800503:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  80050a:	00 
  80050b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800512:	00 
  800513:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  80051a:	e8 67 13 00 00       	call   801886 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  80051f:	83 c4 2c             	add    $0x2c,%esp
  800522:	5b                   	pop    %ebx
  800523:	5e                   	pop    %esi
  800524:	5f                   	pop    %edi
  800525:	5d                   	pop    %ebp
  800526:	c3                   	ret    

00800527 <sys_sleep>:

int
sys_sleep(int channel)
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	57                   	push   %edi
  80052b:	56                   	push   %esi
  80052c:	53                   	push   %ebx
  80052d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800530:	b9 00 00 00 00       	mov    $0x0,%ecx
  800535:	b8 12 00 00 00       	mov    $0x12,%eax
  80053a:	8b 55 08             	mov    0x8(%ebp),%edx
  80053d:	89 cb                	mov    %ecx,%ebx
  80053f:	89 cf                	mov    %ecx,%edi
  800541:	89 ce                	mov    %ecx,%esi
  800543:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800545:	85 c0                	test   %eax,%eax
  800547:	7e 28                	jle    800571 <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800549:	89 44 24 10          	mov    %eax,0x10(%esp)
  80054d:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800554:	00 
  800555:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  80055c:	00 
  80055d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800564:	00 
  800565:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  80056c:	e8 15 13 00 00       	call   801886 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  800571:	83 c4 2c             	add    $0x2c,%esp
  800574:	5b                   	pop    %ebx
  800575:	5e                   	pop    %esi
  800576:	5f                   	pop    %edi
  800577:	5d                   	pop    %ebp
  800578:	c3                   	ret    

00800579 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  800579:	55                   	push   %ebp
  80057a:	89 e5                	mov    %esp,%ebp
  80057c:	57                   	push   %edi
  80057d:	56                   	push   %esi
  80057e:	53                   	push   %ebx
  80057f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800582:	bb 00 00 00 00       	mov    $0x0,%ebx
  800587:	b8 13 00 00 00       	mov    $0x13,%eax
  80058c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80058f:	8b 55 08             	mov    0x8(%ebp),%edx
  800592:	89 df                	mov    %ebx,%edi
  800594:	89 de                	mov    %ebx,%esi
  800596:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800598:	85 c0                	test   %eax,%eax
  80059a:	7e 28                	jle    8005c4 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80059c:	89 44 24 10          	mov    %eax,0x10(%esp)
  8005a0:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  8005a7:	00 
  8005a8:	c7 44 24 08 ea 26 80 	movl   $0x8026ea,0x8(%esp)
  8005af:	00 
  8005b0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8005b7:	00 
  8005b8:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  8005bf:	e8 c2 12 00 00       	call   801886 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  8005c4:	83 c4 2c             	add    $0x2c,%esp
  8005c7:	5b                   	pop    %ebx
  8005c8:	5e                   	pop    %esi
  8005c9:	5f                   	pop    %edi
  8005ca:	5d                   	pop    %ebp
  8005cb:	c3                   	ret    
  8005cc:	66 90                	xchg   %ax,%ax
  8005ce:	66 90                	xchg   %ax,%ax

008005d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8005db:	c1 e8 0c             	shr    $0xc,%eax
}
  8005de:	5d                   	pop    %ebp
  8005df:	c3                   	ret    

008005e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8005eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005f0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8005f5:	5d                   	pop    %ebp
  8005f6:	c3                   	ret    

008005f7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005f7:	55                   	push   %ebp
  8005f8:	89 e5                	mov    %esp,%ebp
  8005fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005fd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800602:	89 c2                	mov    %eax,%edx
  800604:	c1 ea 16             	shr    $0x16,%edx
  800607:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80060e:	f6 c2 01             	test   $0x1,%dl
  800611:	74 11                	je     800624 <fd_alloc+0x2d>
  800613:	89 c2                	mov    %eax,%edx
  800615:	c1 ea 0c             	shr    $0xc,%edx
  800618:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80061f:	f6 c2 01             	test   $0x1,%dl
  800622:	75 09                	jne    80062d <fd_alloc+0x36>
			*fd_store = fd;
  800624:	89 01                	mov    %eax,(%ecx)
			return 0;
  800626:	b8 00 00 00 00       	mov    $0x0,%eax
  80062b:	eb 17                	jmp    800644 <fd_alloc+0x4d>
  80062d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800632:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800637:	75 c9                	jne    800602 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800639:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80063f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800644:	5d                   	pop    %ebp
  800645:	c3                   	ret    

00800646 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800646:	55                   	push   %ebp
  800647:	89 e5                	mov    %esp,%ebp
  800649:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80064c:	83 f8 1f             	cmp    $0x1f,%eax
  80064f:	77 36                	ja     800687 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800651:	c1 e0 0c             	shl    $0xc,%eax
  800654:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800659:	89 c2                	mov    %eax,%edx
  80065b:	c1 ea 16             	shr    $0x16,%edx
  80065e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800665:	f6 c2 01             	test   $0x1,%dl
  800668:	74 24                	je     80068e <fd_lookup+0x48>
  80066a:	89 c2                	mov    %eax,%edx
  80066c:	c1 ea 0c             	shr    $0xc,%edx
  80066f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800676:	f6 c2 01             	test   $0x1,%dl
  800679:	74 1a                	je     800695 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80067b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067e:	89 02                	mov    %eax,(%edx)
	return 0;
  800680:	b8 00 00 00 00       	mov    $0x0,%eax
  800685:	eb 13                	jmp    80069a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800687:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80068c:	eb 0c                	jmp    80069a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80068e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800693:	eb 05                	jmp    80069a <fd_lookup+0x54>
  800695:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80069a:	5d                   	pop    %ebp
  80069b:	c3                   	ret    

0080069c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80069c:	55                   	push   %ebp
  80069d:	89 e5                	mov    %esp,%ebp
  80069f:	83 ec 18             	sub    $0x18,%esp
  8006a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006aa:	eb 13                	jmp    8006bf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8006ac:	39 08                	cmp    %ecx,(%eax)
  8006ae:	75 0c                	jne    8006bc <dev_lookup+0x20>
			*dev = devtab[i];
  8006b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8006b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ba:	eb 38                	jmp    8006f4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8006bc:	83 c2 01             	add    $0x1,%edx
  8006bf:	8b 04 95 94 27 80 00 	mov    0x802794(,%edx,4),%eax
  8006c6:	85 c0                	test   %eax,%eax
  8006c8:	75 e2                	jne    8006ac <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8006ca:	a1 08 40 80 00       	mov    0x804008,%eax
  8006cf:	8b 40 48             	mov    0x48(%eax),%eax
  8006d2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006da:	c7 04 24 18 27 80 00 	movl   $0x802718,(%esp)
  8006e1:	e8 99 12 00 00       	call   80197f <cprintf>
	*dev = 0;
  8006e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8006ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8006f4:	c9                   	leave  
  8006f5:	c3                   	ret    

008006f6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  8006f9:	56                   	push   %esi
  8006fa:	53                   	push   %ebx
  8006fb:	83 ec 20             	sub    $0x20,%esp
  8006fe:	8b 75 08             	mov    0x8(%ebp),%esi
  800701:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800704:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800707:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80070b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800711:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800714:	89 04 24             	mov    %eax,(%esp)
  800717:	e8 2a ff ff ff       	call   800646 <fd_lookup>
  80071c:	85 c0                	test   %eax,%eax
  80071e:	78 05                	js     800725 <fd_close+0x2f>
	    || fd != fd2)
  800720:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800723:	74 0c                	je     800731 <fd_close+0x3b>
		return (must_exist ? r : 0);
  800725:	84 db                	test   %bl,%bl
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
  80072c:	0f 44 c2             	cmove  %edx,%eax
  80072f:	eb 3f                	jmp    800770 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800731:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800734:	89 44 24 04          	mov    %eax,0x4(%esp)
  800738:	8b 06                	mov    (%esi),%eax
  80073a:	89 04 24             	mov    %eax,(%esp)
  80073d:	e8 5a ff ff ff       	call   80069c <dev_lookup>
  800742:	89 c3                	mov    %eax,%ebx
  800744:	85 c0                	test   %eax,%eax
  800746:	78 16                	js     80075e <fd_close+0x68>
		if (dev->dev_close)
  800748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80074e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800753:	85 c0                	test   %eax,%eax
  800755:	74 07                	je     80075e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800757:	89 34 24             	mov    %esi,(%esp)
  80075a:	ff d0                	call   *%eax
  80075c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80075e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800762:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800769:	e8 e0 fa ff ff       	call   80024e <sys_page_unmap>
	return r;
  80076e:	89 d8                	mov    %ebx,%eax
}
  800770:	83 c4 20             	add    $0x20,%esp
  800773:	5b                   	pop    %ebx
  800774:	5e                   	pop    %esi
  800775:	5d                   	pop    %ebp
  800776:	c3                   	ret    

00800777 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80077d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800780:	89 44 24 04          	mov    %eax,0x4(%esp)
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	89 04 24             	mov    %eax,(%esp)
  80078a:	e8 b7 fe ff ff       	call   800646 <fd_lookup>
  80078f:	89 c2                	mov    %eax,%edx
  800791:	85 d2                	test   %edx,%edx
  800793:	78 13                	js     8007a8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800795:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80079c:	00 
  80079d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a0:	89 04 24             	mov    %eax,(%esp)
  8007a3:	e8 4e ff ff ff       	call   8006f6 <fd_close>
}
  8007a8:	c9                   	leave  
  8007a9:	c3                   	ret    

008007aa <close_all>:

void
close_all(void)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	53                   	push   %ebx
  8007ae:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8007b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8007b6:	89 1c 24             	mov    %ebx,(%esp)
  8007b9:	e8 b9 ff ff ff       	call   800777 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8007be:	83 c3 01             	add    $0x1,%ebx
  8007c1:	83 fb 20             	cmp    $0x20,%ebx
  8007c4:	75 f0                	jne    8007b6 <close_all+0xc>
		close(i);
}
  8007c6:	83 c4 14             	add    $0x14,%esp
  8007c9:	5b                   	pop    %ebx
  8007ca:	5d                   	pop    %ebp
  8007cb:	c3                   	ret    

008007cc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	57                   	push   %edi
  8007d0:	56                   	push   %esi
  8007d1:	53                   	push   %ebx
  8007d2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8007d5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8007d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	89 04 24             	mov    %eax,(%esp)
  8007e2:	e8 5f fe ff ff       	call   800646 <fd_lookup>
  8007e7:	89 c2                	mov    %eax,%edx
  8007e9:	85 d2                	test   %edx,%edx
  8007eb:	0f 88 e1 00 00 00    	js     8008d2 <dup+0x106>
		return r;
	close(newfdnum);
  8007f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f4:	89 04 24             	mov    %eax,(%esp)
  8007f7:	e8 7b ff ff ff       	call   800777 <close>

	newfd = INDEX2FD(newfdnum);
  8007fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007ff:	c1 e3 0c             	shl    $0xc,%ebx
  800802:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80080b:	89 04 24             	mov    %eax,(%esp)
  80080e:	e8 cd fd ff ff       	call   8005e0 <fd2data>
  800813:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800815:	89 1c 24             	mov    %ebx,(%esp)
  800818:	e8 c3 fd ff ff       	call   8005e0 <fd2data>
  80081d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80081f:	89 f0                	mov    %esi,%eax
  800821:	c1 e8 16             	shr    $0x16,%eax
  800824:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80082b:	a8 01                	test   $0x1,%al
  80082d:	74 43                	je     800872 <dup+0xa6>
  80082f:	89 f0                	mov    %esi,%eax
  800831:	c1 e8 0c             	shr    $0xc,%eax
  800834:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80083b:	f6 c2 01             	test   $0x1,%dl
  80083e:	74 32                	je     800872 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800840:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800847:	25 07 0e 00 00       	and    $0xe07,%eax
  80084c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800850:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800854:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80085b:	00 
  80085c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800860:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800867:	e8 8f f9 ff ff       	call   8001fb <sys_page_map>
  80086c:	89 c6                	mov    %eax,%esi
  80086e:	85 c0                	test   %eax,%eax
  800870:	78 3e                	js     8008b0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800875:	89 c2                	mov    %eax,%edx
  800877:	c1 ea 0c             	shr    $0xc,%edx
  80087a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800881:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800887:	89 54 24 10          	mov    %edx,0x10(%esp)
  80088b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80088f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800896:	00 
  800897:	89 44 24 04          	mov    %eax,0x4(%esp)
  80089b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8008a2:	e8 54 f9 ff ff       	call   8001fb <sys_page_map>
  8008a7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8008a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8008ac:	85 f6                	test   %esi,%esi
  8008ae:	79 22                	jns    8008d2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8008b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8008bb:	e8 8e f9 ff ff       	call   80024e <sys_page_unmap>
	sys_page_unmap(0, nva);
  8008c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8008cb:	e8 7e f9 ff ff       	call   80024e <sys_page_unmap>
	return r;
  8008d0:	89 f0                	mov    %esi,%eax
}
  8008d2:	83 c4 3c             	add    $0x3c,%esp
  8008d5:	5b                   	pop    %ebx
  8008d6:	5e                   	pop    %esi
  8008d7:	5f                   	pop    %edi
  8008d8:	5d                   	pop    %ebp
  8008d9:	c3                   	ret    

008008da <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	53                   	push   %ebx
  8008de:	83 ec 24             	sub    $0x24,%esp
  8008e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008eb:	89 1c 24             	mov    %ebx,(%esp)
  8008ee:	e8 53 fd ff ff       	call   800646 <fd_lookup>
  8008f3:	89 c2                	mov    %eax,%edx
  8008f5:	85 d2                	test   %edx,%edx
  8008f7:	78 6d                	js     800966 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	89 04 24             	mov    %eax,(%esp)
  800908:	e8 8f fd ff ff       	call   80069c <dev_lookup>
  80090d:	85 c0                	test   %eax,%eax
  80090f:	78 55                	js     800966 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800914:	8b 50 08             	mov    0x8(%eax),%edx
  800917:	83 e2 03             	and    $0x3,%edx
  80091a:	83 fa 01             	cmp    $0x1,%edx
  80091d:	75 23                	jne    800942 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80091f:	a1 08 40 80 00       	mov    0x804008,%eax
  800924:	8b 40 48             	mov    0x48(%eax),%eax
  800927:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80092b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80092f:	c7 04 24 59 27 80 00 	movl   $0x802759,(%esp)
  800936:	e8 44 10 00 00       	call   80197f <cprintf>
		return -E_INVAL;
  80093b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800940:	eb 24                	jmp    800966 <read+0x8c>
	}
	if (!dev->dev_read)
  800942:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800945:	8b 52 08             	mov    0x8(%edx),%edx
  800948:	85 d2                	test   %edx,%edx
  80094a:	74 15                	je     800961 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80094c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80094f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800953:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800956:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80095a:	89 04 24             	mov    %eax,(%esp)
  80095d:	ff d2                	call   *%edx
  80095f:	eb 05                	jmp    800966 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800961:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800966:	83 c4 24             	add    $0x24,%esp
  800969:	5b                   	pop    %ebx
  80096a:	5d                   	pop    %ebp
  80096b:	c3                   	ret    

0080096c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	57                   	push   %edi
  800970:	56                   	push   %esi
  800971:	53                   	push   %ebx
  800972:	83 ec 1c             	sub    $0x1c,%esp
  800975:	8b 7d 08             	mov    0x8(%ebp),%edi
  800978:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80097b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800980:	eb 23                	jmp    8009a5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800982:	89 f0                	mov    %esi,%eax
  800984:	29 d8                	sub    %ebx,%eax
  800986:	89 44 24 08          	mov    %eax,0x8(%esp)
  80098a:	89 d8                	mov    %ebx,%eax
  80098c:	03 45 0c             	add    0xc(%ebp),%eax
  80098f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800993:	89 3c 24             	mov    %edi,(%esp)
  800996:	e8 3f ff ff ff       	call   8008da <read>
		if (m < 0)
  80099b:	85 c0                	test   %eax,%eax
  80099d:	78 10                	js     8009af <readn+0x43>
			return m;
		if (m == 0)
  80099f:	85 c0                	test   %eax,%eax
  8009a1:	74 0a                	je     8009ad <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8009a3:	01 c3                	add    %eax,%ebx
  8009a5:	39 f3                	cmp    %esi,%ebx
  8009a7:	72 d9                	jb     800982 <readn+0x16>
  8009a9:	89 d8                	mov    %ebx,%eax
  8009ab:	eb 02                	jmp    8009af <readn+0x43>
  8009ad:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8009af:	83 c4 1c             	add    $0x1c,%esp
  8009b2:	5b                   	pop    %ebx
  8009b3:	5e                   	pop    %esi
  8009b4:	5f                   	pop    %edi
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	53                   	push   %ebx
  8009bb:	83 ec 24             	sub    $0x24,%esp
  8009be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8009c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009c8:	89 1c 24             	mov    %ebx,(%esp)
  8009cb:	e8 76 fc ff ff       	call   800646 <fd_lookup>
  8009d0:	89 c2                	mov    %eax,%edx
  8009d2:	85 d2                	test   %edx,%edx
  8009d4:	78 68                	js     800a3e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e0:	8b 00                	mov    (%eax),%eax
  8009e2:	89 04 24             	mov    %eax,(%esp)
  8009e5:	e8 b2 fc ff ff       	call   80069c <dev_lookup>
  8009ea:	85 c0                	test   %eax,%eax
  8009ec:	78 50                	js     800a3e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009f1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8009f5:	75 23                	jne    800a1a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8009f7:	a1 08 40 80 00       	mov    0x804008,%eax
  8009fc:	8b 40 48             	mov    0x48(%eax),%eax
  8009ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a07:	c7 04 24 75 27 80 00 	movl   $0x802775,(%esp)
  800a0e:	e8 6c 0f 00 00       	call   80197f <cprintf>
		return -E_INVAL;
  800a13:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a18:	eb 24                	jmp    800a3e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a1d:	8b 52 0c             	mov    0xc(%edx),%edx
  800a20:	85 d2                	test   %edx,%edx
  800a22:	74 15                	je     800a39 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800a24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a27:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800a2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a32:	89 04 24             	mov    %eax,(%esp)
  800a35:	ff d2                	call   *%edx
  800a37:	eb 05                	jmp    800a3e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800a39:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  800a3e:	83 c4 24             	add    $0x24,%esp
  800a41:	5b                   	pop    %ebx
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <seek>:

int
seek(int fdnum, off_t offset)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800a4a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	89 04 24             	mov    %eax,(%esp)
  800a57:	e8 ea fb ff ff       	call   800646 <fd_lookup>
  800a5c:	85 c0                	test   %eax,%eax
  800a5e:	78 0e                	js     800a6e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a66:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800a69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a6e:	c9                   	leave  
  800a6f:	c3                   	ret    

00800a70 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	53                   	push   %ebx
  800a74:	83 ec 24             	sub    $0x24,%esp
  800a77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a7a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a81:	89 1c 24             	mov    %ebx,(%esp)
  800a84:	e8 bd fb ff ff       	call   800646 <fd_lookup>
  800a89:	89 c2                	mov    %eax,%edx
  800a8b:	85 d2                	test   %edx,%edx
  800a8d:	78 61                	js     800af0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a92:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a99:	8b 00                	mov    (%eax),%eax
  800a9b:	89 04 24             	mov    %eax,(%esp)
  800a9e:	e8 f9 fb ff ff       	call   80069c <dev_lookup>
  800aa3:	85 c0                	test   %eax,%eax
  800aa5:	78 49                	js     800af0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aaa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800aae:	75 23                	jne    800ad3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800ab0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800ab5:	8b 40 48             	mov    0x48(%eax),%eax
  800ab8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800abc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ac0:	c7 04 24 38 27 80 00 	movl   $0x802738,(%esp)
  800ac7:	e8 b3 0e 00 00       	call   80197f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800acc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ad1:	eb 1d                	jmp    800af0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  800ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad6:	8b 52 18             	mov    0x18(%edx),%edx
  800ad9:	85 d2                	test   %edx,%edx
  800adb:	74 0e                	je     800aeb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800add:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ae4:	89 04 24             	mov    %eax,(%esp)
  800ae7:	ff d2                	call   *%edx
  800ae9:	eb 05                	jmp    800af0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800aeb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800af0:	83 c4 24             	add    $0x24,%esp
  800af3:	5b                   	pop    %ebx
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	53                   	push   %ebx
  800afa:	83 ec 24             	sub    $0x24,%esp
  800afd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b00:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800b03:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	89 04 24             	mov    %eax,(%esp)
  800b0d:	e8 34 fb ff ff       	call   800646 <fd_lookup>
  800b12:	89 c2                	mov    %eax,%edx
  800b14:	85 d2                	test   %edx,%edx
  800b16:	78 52                	js     800b6a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	89 04 24             	mov    %eax,(%esp)
  800b27:	e8 70 fb ff ff       	call   80069c <dev_lookup>
  800b2c:	85 c0                	test   %eax,%eax
  800b2e:	78 3a                	js     800b6a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b33:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800b37:	74 2c                	je     800b65 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800b39:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800b3c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800b43:	00 00 00 
	stat->st_isdir = 0;
  800b46:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b4d:	00 00 00 
	stat->st_dev = dev;
  800b50:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800b56:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800b5d:	89 14 24             	mov    %edx,(%esp)
  800b60:	ff 50 14             	call   *0x14(%eax)
  800b63:	eb 05                	jmp    800b6a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800b65:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800b6a:	83 c4 24             	add    $0x24,%esp
  800b6d:	5b                   	pop    %ebx
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	56                   	push   %esi
  800b74:	53                   	push   %ebx
  800b75:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800b78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800b7f:	00 
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 04 24             	mov    %eax,(%esp)
  800b86:	e8 1b 02 00 00       	call   800da6 <open>
  800b8b:	89 c3                	mov    %eax,%ebx
  800b8d:	85 db                	test   %ebx,%ebx
  800b8f:	78 1b                	js     800bac <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b98:	89 1c 24             	mov    %ebx,(%esp)
  800b9b:	e8 56 ff ff ff       	call   800af6 <fstat>
  800ba0:	89 c6                	mov    %eax,%esi
	close(fd);
  800ba2:	89 1c 24             	mov    %ebx,(%esp)
  800ba5:	e8 cd fb ff ff       	call   800777 <close>
	return r;
  800baa:	89 f0                	mov    %esi,%eax
}
  800bac:	83 c4 10             	add    $0x10,%esp
  800baf:	5b                   	pop    %ebx
  800bb0:	5e                   	pop    %esi
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	56                   	push   %esi
  800bb7:	53                   	push   %ebx
  800bb8:	83 ec 10             	sub    $0x10,%esp
  800bbb:	89 c6                	mov    %eax,%esi
  800bbd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800bbf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800bc6:	75 11                	jne    800bd9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800bc8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800bcf:	e8 eb 17 00 00       	call   8023bf <ipc_find_env>
  800bd4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800bd9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800be0:	00 
  800be1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800be8:	00 
  800be9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bed:	a1 00 40 80 00       	mov    0x804000,%eax
  800bf2:	89 04 24             	mov    %eax,(%esp)
  800bf5:	e8 5a 17 00 00       	call   802354 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800bfa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800c01:	00 
  800c02:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c0d:	e8 ee 16 00 00       	call   802300 <ipc_recv>
}
  800c12:	83 c4 10             	add    $0x10,%esp
  800c15:	5b                   	pop    %ebx
  800c16:	5e                   	pop    %esi
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    

00800c19 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8b 40 0c             	mov    0xc(%eax),%eax
  800c25:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800c32:	ba 00 00 00 00       	mov    $0x0,%edx
  800c37:	b8 02 00 00 00       	mov    $0x2,%eax
  800c3c:	e8 72 ff ff ff       	call   800bb3 <fsipc>
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8b 40 0c             	mov    0xc(%eax),%eax
  800c4f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800c54:	ba 00 00 00 00       	mov    $0x0,%edx
  800c59:	b8 06 00 00 00       	mov    $0x6,%eax
  800c5e:	e8 50 ff ff ff       	call   800bb3 <fsipc>
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	53                   	push   %ebx
  800c69:	83 ec 14             	sub    $0x14,%esp
  800c6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	8b 40 0c             	mov    0xc(%eax),%eax
  800c75:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800c7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7f:	b8 05 00 00 00       	mov    $0x5,%eax
  800c84:	e8 2a ff ff ff       	call   800bb3 <fsipc>
  800c89:	89 c2                	mov    %eax,%edx
  800c8b:	85 d2                	test   %edx,%edx
  800c8d:	78 2b                	js     800cba <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800c8f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800c96:	00 
  800c97:	89 1c 24             	mov    %ebx,(%esp)
  800c9a:	e8 08 13 00 00       	call   801fa7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800c9f:	a1 80 50 80 00       	mov    0x805080,%eax
  800ca4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800caa:	a1 84 50 80 00       	mov    0x805084,%eax
  800caf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800cb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cba:	83 c4 14             	add    $0x14,%esp
  800cbd:	5b                   	pop    %ebx
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    

00800cc0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	83 ec 18             	sub    $0x18,%esp
  800cc6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	8b 52 0c             	mov    0xc(%edx),%edx
  800ccf:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800cd5:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  800cda:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ce5:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  800cec:	e8 bb 14 00 00       	call   8021ac <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  800cf1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf6:	b8 04 00 00 00       	mov    $0x4,%eax
  800cfb:	e8 b3 fe ff ff       	call   800bb3 <fsipc>
		return r;
	}

	return r;
}
  800d00:	c9                   	leave  
  800d01:	c3                   	ret    

00800d02 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	56                   	push   %esi
  800d06:	53                   	push   %ebx
  800d07:	83 ec 10             	sub    $0x10,%esp
  800d0a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8b 40 0c             	mov    0xc(%eax),%eax
  800d13:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800d18:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800d1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d23:	b8 03 00 00 00       	mov    $0x3,%eax
  800d28:	e8 86 fe ff ff       	call   800bb3 <fsipc>
  800d2d:	89 c3                	mov    %eax,%ebx
  800d2f:	85 c0                	test   %eax,%eax
  800d31:	78 6a                	js     800d9d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800d33:	39 c6                	cmp    %eax,%esi
  800d35:	73 24                	jae    800d5b <devfile_read+0x59>
  800d37:	c7 44 24 0c a8 27 80 	movl   $0x8027a8,0xc(%esp)
  800d3e:	00 
  800d3f:	c7 44 24 08 af 27 80 	movl   $0x8027af,0x8(%esp)
  800d46:	00 
  800d47:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  800d4e:	00 
  800d4f:	c7 04 24 c4 27 80 00 	movl   $0x8027c4,(%esp)
  800d56:	e8 2b 0b 00 00       	call   801886 <_panic>
	assert(r <= PGSIZE);
  800d5b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800d60:	7e 24                	jle    800d86 <devfile_read+0x84>
  800d62:	c7 44 24 0c cf 27 80 	movl   $0x8027cf,0xc(%esp)
  800d69:	00 
  800d6a:	c7 44 24 08 af 27 80 	movl   $0x8027af,0x8(%esp)
  800d71:	00 
  800d72:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  800d79:	00 
  800d7a:	c7 04 24 c4 27 80 00 	movl   $0x8027c4,(%esp)
  800d81:	e8 00 0b 00 00       	call   801886 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800d86:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d8a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800d91:	00 
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	89 04 24             	mov    %eax,(%esp)
  800d98:	e8 a7 13 00 00       	call   802144 <memmove>
	return r;
}
  800d9d:	89 d8                	mov    %ebx,%eax
  800d9f:	83 c4 10             	add    $0x10,%esp
  800da2:	5b                   	pop    %ebx
  800da3:	5e                   	pop    %esi
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	53                   	push   %ebx
  800daa:	83 ec 24             	sub    $0x24,%esp
  800dad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800db0:	89 1c 24             	mov    %ebx,(%esp)
  800db3:	e8 b8 11 00 00       	call   801f70 <strlen>
  800db8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800dbd:	7f 60                	jg     800e1f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800dbf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dc2:	89 04 24             	mov    %eax,(%esp)
  800dc5:	e8 2d f8 ff ff       	call   8005f7 <fd_alloc>
  800dca:	89 c2                	mov    %eax,%edx
  800dcc:	85 d2                	test   %edx,%edx
  800dce:	78 54                	js     800e24 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800dd0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800dd4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800ddb:	e8 c7 11 00 00       	call   801fa7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800de8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800deb:	b8 01 00 00 00       	mov    $0x1,%eax
  800df0:	e8 be fd ff ff       	call   800bb3 <fsipc>
  800df5:	89 c3                	mov    %eax,%ebx
  800df7:	85 c0                	test   %eax,%eax
  800df9:	79 17                	jns    800e12 <open+0x6c>
		fd_close(fd, 0);
  800dfb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800e02:	00 
  800e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e06:	89 04 24             	mov    %eax,(%esp)
  800e09:	e8 e8 f8 ff ff       	call   8006f6 <fd_close>
		return r;
  800e0e:	89 d8                	mov    %ebx,%eax
  800e10:	eb 12                	jmp    800e24 <open+0x7e>
	}

	return fd2num(fd);
  800e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e15:	89 04 24             	mov    %eax,(%esp)
  800e18:	e8 b3 f7 ff ff       	call   8005d0 <fd2num>
  800e1d:	eb 05                	jmp    800e24 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800e1f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800e24:	83 c4 24             	add    $0x24,%esp
  800e27:	5b                   	pop    %ebx
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800e30:	ba 00 00 00 00       	mov    $0x0,%edx
  800e35:	b8 08 00 00 00       	mov    $0x8,%eax
  800e3a:	e8 74 fd ff ff       	call   800bb3 <fsipc>
}
  800e3f:	c9                   	leave  
  800e40:	c3                   	ret    
  800e41:	66 90                	xchg   %ax,%ax
  800e43:	66 90                	xchg   %ax,%ax
  800e45:	66 90                	xchg   %ax,%ax
  800e47:	66 90                	xchg   %ax,%ax
  800e49:	66 90                	xchg   %ax,%ax
  800e4b:	66 90                	xchg   %ax,%ax
  800e4d:	66 90                	xchg   %ax,%ax
  800e4f:	90                   	nop

00800e50 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800e56:	c7 44 24 04 db 27 80 	movl   $0x8027db,0x4(%esp)
  800e5d:	00 
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	89 04 24             	mov    %eax,(%esp)
  800e64:	e8 3e 11 00 00       	call   801fa7 <strcpy>
	return 0;
}
  800e69:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	53                   	push   %ebx
  800e74:	83 ec 14             	sub    $0x14,%esp
  800e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800e7a:	89 1c 24             	mov    %ebx,(%esp)
  800e7d:	e8 7c 15 00 00       	call   8023fe <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  800e82:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  800e87:	83 f8 01             	cmp    $0x1,%eax
  800e8a:	75 0d                	jne    800e99 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  800e8c:	8b 43 0c             	mov    0xc(%ebx),%eax
  800e8f:	89 04 24             	mov    %eax,(%esp)
  800e92:	e8 29 03 00 00       	call   8011c0 <nsipc_close>
  800e97:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  800e99:	89 d0                	mov    %edx,%eax
  800e9b:	83 c4 14             	add    $0x14,%esp
  800e9e:	5b                   	pop    %ebx
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    

00800ea1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800ea7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800eae:	00 
  800eaf:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb2:	89 44 24 08          	mov    %eax,0x8(%esp)
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8b 40 0c             	mov    0xc(%eax),%eax
  800ec3:	89 04 24             	mov    %eax,(%esp)
  800ec6:	e8 f0 03 00 00       	call   8012bb <nsipc_send>
}
  800ecb:	c9                   	leave  
  800ecc:	c3                   	ret    

00800ecd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800ed3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800eda:	00 
  800edb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ede:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8b 40 0c             	mov    0xc(%eax),%eax
  800eef:	89 04 24             	mov    %eax,(%esp)
  800ef2:	e8 44 03 00 00       	call   80123b <nsipc_recv>
}
  800ef7:	c9                   	leave  
  800ef8:	c3                   	ret    

00800ef9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800eff:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f02:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f06:	89 04 24             	mov    %eax,(%esp)
  800f09:	e8 38 f7 ff ff       	call   800646 <fd_lookup>
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	78 17                	js     800f29 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f15:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800f1b:	39 08                	cmp    %ecx,(%eax)
  800f1d:	75 05                	jne    800f24 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800f1f:	8b 40 0c             	mov    0xc(%eax),%eax
  800f22:	eb 05                	jmp    800f29 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  800f24:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  800f29:	c9                   	leave  
  800f2a:	c3                   	ret    

00800f2b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	56                   	push   %esi
  800f2f:	53                   	push   %ebx
  800f30:	83 ec 20             	sub    $0x20,%esp
  800f33:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800f35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f38:	89 04 24             	mov    %eax,(%esp)
  800f3b:	e8 b7 f6 ff ff       	call   8005f7 <fd_alloc>
  800f40:	89 c3                	mov    %eax,%ebx
  800f42:	85 c0                	test   %eax,%eax
  800f44:	78 21                	js     800f67 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800f46:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f4d:	00 
  800f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f51:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f5c:	e8 46 f2 ff ff       	call   8001a7 <sys_page_alloc>
  800f61:	89 c3                	mov    %eax,%ebx
  800f63:	85 c0                	test   %eax,%eax
  800f65:	79 0c                	jns    800f73 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  800f67:	89 34 24             	mov    %esi,(%esp)
  800f6a:	e8 51 02 00 00       	call   8011c0 <nsipc_close>
		return r;
  800f6f:	89 d8                	mov    %ebx,%eax
  800f71:	eb 20                	jmp    800f93 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800f73:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f7c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800f7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f81:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  800f88:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  800f8b:	89 14 24             	mov    %edx,(%esp)
  800f8e:	e8 3d f6 ff ff       	call   8005d0 <fd2num>
}
  800f93:	83 c4 20             	add    $0x20,%esp
  800f96:	5b                   	pop    %ebx
  800f97:	5e                   	pop    %esi
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    

00800f9a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	e8 51 ff ff ff       	call   800ef9 <fd2sockid>
		return r;
  800fa8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  800faa:	85 c0                	test   %eax,%eax
  800fac:	78 23                	js     800fd1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800fae:	8b 55 10             	mov    0x10(%ebp),%edx
  800fb1:	89 54 24 08          	mov    %edx,0x8(%esp)
  800fb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb8:	89 54 24 04          	mov    %edx,0x4(%esp)
  800fbc:	89 04 24             	mov    %eax,(%esp)
  800fbf:	e8 45 01 00 00       	call   801109 <nsipc_accept>
		return r;
  800fc4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	78 07                	js     800fd1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  800fca:	e8 5c ff ff ff       	call   800f2b <alloc_sockfd>
  800fcf:	89 c1                	mov    %eax,%ecx
}
  800fd1:	89 c8                	mov    %ecx,%eax
  800fd3:	c9                   	leave  
  800fd4:	c3                   	ret    

00800fd5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
  800fd8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	e8 16 ff ff ff       	call   800ef9 <fd2sockid>
  800fe3:	89 c2                	mov    %eax,%edx
  800fe5:	85 d2                	test   %edx,%edx
  800fe7:	78 16                	js     800fff <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  800fe9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fec:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ff7:	89 14 24             	mov    %edx,(%esp)
  800ffa:	e8 60 01 00 00       	call   80115f <nsipc_bind>
}
  800fff:	c9                   	leave  
  801000:	c3                   	ret    

00801001 <shutdown>:

int
shutdown(int s, int how)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	e8 ea fe ff ff       	call   800ef9 <fd2sockid>
  80100f:	89 c2                	mov    %eax,%edx
  801011:	85 d2                	test   %edx,%edx
  801013:	78 0f                	js     801024 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	89 44 24 04          	mov    %eax,0x4(%esp)
  80101c:	89 14 24             	mov    %edx,(%esp)
  80101f:	e8 7a 01 00 00       	call   80119e <nsipc_shutdown>
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	e8 c5 fe ff ff       	call   800ef9 <fd2sockid>
  801034:	89 c2                	mov    %eax,%edx
  801036:	85 d2                	test   %edx,%edx
  801038:	78 16                	js     801050 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80103a:	8b 45 10             	mov    0x10(%ebp),%eax
  80103d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	89 44 24 04          	mov    %eax,0x4(%esp)
  801048:	89 14 24             	mov    %edx,(%esp)
  80104b:	e8 8a 01 00 00       	call   8011da <nsipc_connect>
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <listen>:

int
listen(int s, int backlog)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	e8 99 fe ff ff       	call   800ef9 <fd2sockid>
  801060:	89 c2                	mov    %eax,%edx
  801062:	85 d2                	test   %edx,%edx
  801064:	78 0f                	js     801075 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801066:	8b 45 0c             	mov    0xc(%ebp),%eax
  801069:	89 44 24 04          	mov    %eax,0x4(%esp)
  80106d:	89 14 24             	mov    %edx,(%esp)
  801070:	e8 a4 01 00 00       	call   801219 <nsipc_listen>
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80107d:	8b 45 10             	mov    0x10(%ebp),%eax
  801080:	89 44 24 08          	mov    %eax,0x8(%esp)
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	89 44 24 04          	mov    %eax,0x4(%esp)
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	89 04 24             	mov    %eax,(%esp)
  801091:	e8 98 02 00 00       	call   80132e <nsipc_socket>
  801096:	89 c2                	mov    %eax,%edx
  801098:	85 d2                	test   %edx,%edx
  80109a:	78 05                	js     8010a1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80109c:	e8 8a fe ff ff       	call   800f2b <alloc_sockfd>
}
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	53                   	push   %ebx
  8010a7:	83 ec 14             	sub    $0x14,%esp
  8010aa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8010ac:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8010b3:	75 11                	jne    8010c6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8010b5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8010bc:	e8 fe 12 00 00       	call   8023bf <ipc_find_env>
  8010c1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8010c6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8010cd:	00 
  8010ce:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8010d5:	00 
  8010d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010da:	a1 04 40 80 00       	mov    0x804004,%eax
  8010df:	89 04 24             	mov    %eax,(%esp)
  8010e2:	e8 6d 12 00 00       	call   802354 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8010e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010ee:	00 
  8010ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8010f6:	00 
  8010f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010fe:	e8 fd 11 00 00       	call   802300 <ipc_recv>
}
  801103:	83 c4 14             	add    $0x14,%esp
  801106:	5b                   	pop    %ebx
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    

00801109 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	56                   	push   %esi
  80110d:	53                   	push   %ebx
  80110e:	83 ec 10             	sub    $0x10,%esp
  801111:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80111c:	8b 06                	mov    (%esi),%eax
  80111e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801123:	b8 01 00 00 00       	mov    $0x1,%eax
  801128:	e8 76 ff ff ff       	call   8010a3 <nsipc>
  80112d:	89 c3                	mov    %eax,%ebx
  80112f:	85 c0                	test   %eax,%eax
  801131:	78 23                	js     801156 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801133:	a1 10 60 80 00       	mov    0x806010,%eax
  801138:	89 44 24 08          	mov    %eax,0x8(%esp)
  80113c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801143:	00 
  801144:	8b 45 0c             	mov    0xc(%ebp),%eax
  801147:	89 04 24             	mov    %eax,(%esp)
  80114a:	e8 f5 0f 00 00       	call   802144 <memmove>
		*addrlen = ret->ret_addrlen;
  80114f:	a1 10 60 80 00       	mov    0x806010,%eax
  801154:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801156:	89 d8                	mov    %ebx,%eax
  801158:	83 c4 10             	add    $0x10,%esp
  80115b:	5b                   	pop    %ebx
  80115c:	5e                   	pop    %esi
  80115d:	5d                   	pop    %ebp
  80115e:	c3                   	ret    

0080115f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	53                   	push   %ebx
  801163:	83 ec 14             	sub    $0x14,%esp
  801166:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801171:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801175:	8b 45 0c             	mov    0xc(%ebp),%eax
  801178:	89 44 24 04          	mov    %eax,0x4(%esp)
  80117c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801183:	e8 bc 0f 00 00       	call   802144 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801188:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80118e:	b8 02 00 00 00       	mov    $0x2,%eax
  801193:	e8 0b ff ff ff       	call   8010a3 <nsipc>
}
  801198:	83 c4 14             	add    $0x14,%esp
  80119b:	5b                   	pop    %ebx
  80119c:	5d                   	pop    %ebp
  80119d:	c3                   	ret    

0080119e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011af:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011b4:	b8 03 00 00 00       	mov    $0x3,%eax
  8011b9:	e8 e5 fe ff ff       	call   8010a3 <nsipc>
}
  8011be:	c9                   	leave  
  8011bf:	c3                   	ret    

008011c0 <nsipc_close>:

int
nsipc_close(int s)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8011ce:	b8 04 00 00 00       	mov    $0x4,%eax
  8011d3:	e8 cb fe ff ff       	call   8010a3 <nsipc>
}
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    

008011da <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	53                   	push   %ebx
  8011de:	83 ec 14             	sub    $0x14,%esp
  8011e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8011ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011f7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8011fe:	e8 41 0f 00 00       	call   802144 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801203:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801209:	b8 05 00 00 00       	mov    $0x5,%eax
  80120e:	e8 90 fe ff ff       	call   8010a3 <nsipc>
}
  801213:	83 c4 14             	add    $0x14,%esp
  801216:	5b                   	pop    %ebx
  801217:	5d                   	pop    %ebp
  801218:	c3                   	ret    

00801219 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80122f:	b8 06 00 00 00       	mov    $0x6,%eax
  801234:	e8 6a fe ff ff       	call   8010a3 <nsipc>
}
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	56                   	push   %esi
  80123f:	53                   	push   %ebx
  801240:	83 ec 10             	sub    $0x10,%esp
  801243:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80124e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801254:	8b 45 14             	mov    0x14(%ebp),%eax
  801257:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80125c:	b8 07 00 00 00       	mov    $0x7,%eax
  801261:	e8 3d fe ff ff       	call   8010a3 <nsipc>
  801266:	89 c3                	mov    %eax,%ebx
  801268:	85 c0                	test   %eax,%eax
  80126a:	78 46                	js     8012b2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80126c:	39 f0                	cmp    %esi,%eax
  80126e:	7f 07                	jg     801277 <nsipc_recv+0x3c>
  801270:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801275:	7e 24                	jle    80129b <nsipc_recv+0x60>
  801277:	c7 44 24 0c e7 27 80 	movl   $0x8027e7,0xc(%esp)
  80127e:	00 
  80127f:	c7 44 24 08 af 27 80 	movl   $0x8027af,0x8(%esp)
  801286:	00 
  801287:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80128e:	00 
  80128f:	c7 04 24 fc 27 80 00 	movl   $0x8027fc,(%esp)
  801296:	e8 eb 05 00 00       	call   801886 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80129b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80129f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8012a6:	00 
  8012a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012aa:	89 04 24             	mov    %eax,(%esp)
  8012ad:	e8 92 0e 00 00       	call   802144 <memmove>
	}

	return r;
}
  8012b2:	89 d8                	mov    %ebx,%eax
  8012b4:	83 c4 10             	add    $0x10,%esp
  8012b7:	5b                   	pop    %ebx
  8012b8:	5e                   	pop    %esi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    

008012bb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	53                   	push   %ebx
  8012bf:	83 ec 14             	sub    $0x14,%esp
  8012c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012cd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012d3:	7e 24                	jle    8012f9 <nsipc_send+0x3e>
  8012d5:	c7 44 24 0c 08 28 80 	movl   $0x802808,0xc(%esp)
  8012dc:	00 
  8012dd:	c7 44 24 08 af 27 80 	movl   $0x8027af,0x8(%esp)
  8012e4:	00 
  8012e5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8012ec:	00 
  8012ed:	c7 04 24 fc 27 80 00 	movl   $0x8027fc,(%esp)
  8012f4:	e8 8d 05 00 00       	call   801886 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801300:	89 44 24 04          	mov    %eax,0x4(%esp)
  801304:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80130b:	e8 34 0e 00 00       	call   802144 <memmove>
	nsipcbuf.send.req_size = size;
  801310:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801316:	8b 45 14             	mov    0x14(%ebp),%eax
  801319:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80131e:	b8 08 00 00 00       	mov    $0x8,%eax
  801323:	e8 7b fd ff ff       	call   8010a3 <nsipc>
}
  801328:	83 c4 14             	add    $0x14,%esp
  80132b:	5b                   	pop    %ebx
  80132c:	5d                   	pop    %ebp
  80132d:	c3                   	ret    

0080132e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801344:	8b 45 10             	mov    0x10(%ebp),%eax
  801347:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80134c:	b8 09 00 00 00       	mov    $0x9,%eax
  801351:	e8 4d fd ff ff       	call   8010a3 <nsipc>
}
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	56                   	push   %esi
  80135c:	53                   	push   %ebx
  80135d:	83 ec 10             	sub    $0x10,%esp
  801360:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	89 04 24             	mov    %eax,(%esp)
  801369:	e8 72 f2 ff ff       	call   8005e0 <fd2data>
  80136e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801370:	c7 44 24 04 14 28 80 	movl   $0x802814,0x4(%esp)
  801377:	00 
  801378:	89 1c 24             	mov    %ebx,(%esp)
  80137b:	e8 27 0c 00 00       	call   801fa7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801380:	8b 46 04             	mov    0x4(%esi),%eax
  801383:	2b 06                	sub    (%esi),%eax
  801385:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80138b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801392:	00 00 00 
	stat->st_dev = &devpipe;
  801395:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80139c:	30 80 00 
	return 0;
}
  80139f:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a4:	83 c4 10             	add    $0x10,%esp
  8013a7:	5b                   	pop    %ebx
  8013a8:	5e                   	pop    %esi
  8013a9:	5d                   	pop    %ebp
  8013aa:	c3                   	ret    

008013ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	53                   	push   %ebx
  8013af:	83 ec 14             	sub    $0x14,%esp
  8013b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8013b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013c0:	e8 89 ee ff ff       	call   80024e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8013c5:	89 1c 24             	mov    %ebx,(%esp)
  8013c8:	e8 13 f2 ff ff       	call   8005e0 <fd2data>
  8013cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013d8:	e8 71 ee ff ff       	call   80024e <sys_page_unmap>
}
  8013dd:	83 c4 14             	add    $0x14,%esp
  8013e0:	5b                   	pop    %ebx
  8013e1:	5d                   	pop    %ebp
  8013e2:	c3                   	ret    

008013e3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	57                   	push   %edi
  8013e7:	56                   	push   %esi
  8013e8:	53                   	push   %ebx
  8013e9:	83 ec 2c             	sub    $0x2c,%esp
  8013ec:	89 c6                	mov    %eax,%esi
  8013ee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8013f1:	a1 08 40 80 00       	mov    0x804008,%eax
  8013f6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8013f9:	89 34 24             	mov    %esi,(%esp)
  8013fc:	e8 fd 0f 00 00       	call   8023fe <pageref>
  801401:	89 c7                	mov    %eax,%edi
  801403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801406:	89 04 24             	mov    %eax,(%esp)
  801409:	e8 f0 0f 00 00       	call   8023fe <pageref>
  80140e:	39 c7                	cmp    %eax,%edi
  801410:	0f 94 c2             	sete   %dl
  801413:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801416:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  80141c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80141f:	39 fb                	cmp    %edi,%ebx
  801421:	74 21                	je     801444 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801423:	84 d2                	test   %dl,%dl
  801425:	74 ca                	je     8013f1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801427:	8b 51 58             	mov    0x58(%ecx),%edx
  80142a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80142e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801432:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801436:	c7 04 24 1b 28 80 00 	movl   $0x80281b,(%esp)
  80143d:	e8 3d 05 00 00       	call   80197f <cprintf>
  801442:	eb ad                	jmp    8013f1 <_pipeisclosed+0xe>
	}
}
  801444:	83 c4 2c             	add    $0x2c,%esp
  801447:	5b                   	pop    %ebx
  801448:	5e                   	pop    %esi
  801449:	5f                   	pop    %edi
  80144a:	5d                   	pop    %ebp
  80144b:	c3                   	ret    

0080144c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	57                   	push   %edi
  801450:	56                   	push   %esi
  801451:	53                   	push   %ebx
  801452:	83 ec 1c             	sub    $0x1c,%esp
  801455:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801458:	89 34 24             	mov    %esi,(%esp)
  80145b:	e8 80 f1 ff ff       	call   8005e0 <fd2data>
  801460:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801462:	bf 00 00 00 00       	mov    $0x0,%edi
  801467:	eb 45                	jmp    8014ae <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801469:	89 da                	mov    %ebx,%edx
  80146b:	89 f0                	mov    %esi,%eax
  80146d:	e8 71 ff ff ff       	call   8013e3 <_pipeisclosed>
  801472:	85 c0                	test   %eax,%eax
  801474:	75 41                	jne    8014b7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801476:	e8 0d ed ff ff       	call   800188 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80147b:	8b 43 04             	mov    0x4(%ebx),%eax
  80147e:	8b 0b                	mov    (%ebx),%ecx
  801480:	8d 51 20             	lea    0x20(%ecx),%edx
  801483:	39 d0                	cmp    %edx,%eax
  801485:	73 e2                	jae    801469 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801487:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80148a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80148e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801491:	99                   	cltd   
  801492:	c1 ea 1b             	shr    $0x1b,%edx
  801495:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801498:	83 e1 1f             	and    $0x1f,%ecx
  80149b:	29 d1                	sub    %edx,%ecx
  80149d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8014a1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8014a5:	83 c0 01             	add    $0x1,%eax
  8014a8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014ab:	83 c7 01             	add    $0x1,%edi
  8014ae:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8014b1:	75 c8                	jne    80147b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8014b3:	89 f8                	mov    %edi,%eax
  8014b5:	eb 05                	jmp    8014bc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8014b7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8014bc:	83 c4 1c             	add    $0x1c,%esp
  8014bf:	5b                   	pop    %ebx
  8014c0:	5e                   	pop    %esi
  8014c1:	5f                   	pop    %edi
  8014c2:	5d                   	pop    %ebp
  8014c3:	c3                   	ret    

008014c4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	57                   	push   %edi
  8014c8:	56                   	push   %esi
  8014c9:	53                   	push   %ebx
  8014ca:	83 ec 1c             	sub    $0x1c,%esp
  8014cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8014d0:	89 3c 24             	mov    %edi,(%esp)
  8014d3:	e8 08 f1 ff ff       	call   8005e0 <fd2data>
  8014d8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014da:	be 00 00 00 00       	mov    $0x0,%esi
  8014df:	eb 3d                	jmp    80151e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8014e1:	85 f6                	test   %esi,%esi
  8014e3:	74 04                	je     8014e9 <devpipe_read+0x25>
				return i;
  8014e5:	89 f0                	mov    %esi,%eax
  8014e7:	eb 43                	jmp    80152c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8014e9:	89 da                	mov    %ebx,%edx
  8014eb:	89 f8                	mov    %edi,%eax
  8014ed:	e8 f1 fe ff ff       	call   8013e3 <_pipeisclosed>
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	75 31                	jne    801527 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8014f6:	e8 8d ec ff ff       	call   800188 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8014fb:	8b 03                	mov    (%ebx),%eax
  8014fd:	3b 43 04             	cmp    0x4(%ebx),%eax
  801500:	74 df                	je     8014e1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801502:	99                   	cltd   
  801503:	c1 ea 1b             	shr    $0x1b,%edx
  801506:	01 d0                	add    %edx,%eax
  801508:	83 e0 1f             	and    $0x1f,%eax
  80150b:	29 d0                	sub    %edx,%eax
  80150d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801512:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801515:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801518:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80151b:	83 c6 01             	add    $0x1,%esi
  80151e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801521:	75 d8                	jne    8014fb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801523:	89 f0                	mov    %esi,%eax
  801525:	eb 05                	jmp    80152c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801527:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80152c:	83 c4 1c             	add    $0x1c,%esp
  80152f:	5b                   	pop    %ebx
  801530:	5e                   	pop    %esi
  801531:	5f                   	pop    %edi
  801532:	5d                   	pop    %ebp
  801533:	c3                   	ret    

00801534 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
  801537:	56                   	push   %esi
  801538:	53                   	push   %ebx
  801539:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80153c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153f:	89 04 24             	mov    %eax,(%esp)
  801542:	e8 b0 f0 ff ff       	call   8005f7 <fd_alloc>
  801547:	89 c2                	mov    %eax,%edx
  801549:	85 d2                	test   %edx,%edx
  80154b:	0f 88 4d 01 00 00    	js     80169e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801551:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801558:	00 
  801559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801560:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801567:	e8 3b ec ff ff       	call   8001a7 <sys_page_alloc>
  80156c:	89 c2                	mov    %eax,%edx
  80156e:	85 d2                	test   %edx,%edx
  801570:	0f 88 28 01 00 00    	js     80169e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801576:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801579:	89 04 24             	mov    %eax,(%esp)
  80157c:	e8 76 f0 ff ff       	call   8005f7 <fd_alloc>
  801581:	89 c3                	mov    %eax,%ebx
  801583:	85 c0                	test   %eax,%eax
  801585:	0f 88 fe 00 00 00    	js     801689 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80158b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801592:	00 
  801593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801596:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015a1:	e8 01 ec ff ff       	call   8001a7 <sys_page_alloc>
  8015a6:	89 c3                	mov    %eax,%ebx
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	0f 88 d9 00 00 00    	js     801689 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b3:	89 04 24             	mov    %eax,(%esp)
  8015b6:	e8 25 f0 ff ff       	call   8005e0 <fd2data>
  8015bb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015bd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8015c4:	00 
  8015c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015d0:	e8 d2 eb ff ff       	call   8001a7 <sys_page_alloc>
  8015d5:	89 c3                	mov    %eax,%ebx
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	0f 88 97 00 00 00    	js     801676 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e2:	89 04 24             	mov    %eax,(%esp)
  8015e5:	e8 f6 ef ff ff       	call   8005e0 <fd2data>
  8015ea:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8015f1:	00 
  8015f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015fd:	00 
  8015fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801602:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801609:	e8 ed eb ff ff       	call   8001fb <sys_page_map>
  80160e:	89 c3                	mov    %eax,%ebx
  801610:	85 c0                	test   %eax,%eax
  801612:	78 52                	js     801666 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801614:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80161a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80161f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801622:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801629:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80162f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801632:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801637:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801641:	89 04 24             	mov    %eax,(%esp)
  801644:	e8 87 ef ff ff       	call   8005d0 <fd2num>
  801649:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80164c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80164e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801651:	89 04 24             	mov    %eax,(%esp)
  801654:	e8 77 ef ff ff       	call   8005d0 <fd2num>
  801659:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80165c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80165f:	b8 00 00 00 00       	mov    $0x0,%eax
  801664:	eb 38                	jmp    80169e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801666:	89 74 24 04          	mov    %esi,0x4(%esp)
  80166a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801671:	e8 d8 eb ff ff       	call   80024e <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801679:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801684:	e8 c5 eb ff ff       	call   80024e <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801690:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801697:	e8 b2 eb ff ff       	call   80024e <sys_page_unmap>
  80169c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80169e:	83 c4 30             	add    $0x30,%esp
  8016a1:	5b                   	pop    %ebx
  8016a2:	5e                   	pop    %esi
  8016a3:	5d                   	pop    %ebp
  8016a4:	c3                   	ret    

008016a5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	89 04 24             	mov    %eax,(%esp)
  8016b8:	e8 89 ef ff ff       	call   800646 <fd_lookup>
  8016bd:	89 c2                	mov    %eax,%edx
  8016bf:	85 d2                	test   %edx,%edx
  8016c1:	78 15                	js     8016d8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8016c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c6:	89 04 24             	mov    %eax,(%esp)
  8016c9:	e8 12 ef ff ff       	call   8005e0 <fd2data>
	return _pipeisclosed(fd, p);
  8016ce:	89 c2                	mov    %eax,%edx
  8016d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d3:	e8 0b fd ff ff       	call   8013e3 <_pipeisclosed>
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    
  8016da:	66 90                	xchg   %ax,%ax
  8016dc:	66 90                	xchg   %ax,%ax
  8016de:	66 90                	xchg   %ax,%ax

008016e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8016e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e8:	5d                   	pop    %ebp
  8016e9:	c3                   	ret    

008016ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8016f0:	c7 44 24 04 33 28 80 	movl   $0x802833,0x4(%esp)
  8016f7:	00 
  8016f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fb:	89 04 24             	mov    %eax,(%esp)
  8016fe:	e8 a4 08 00 00       	call   801fa7 <strcpy>
	return 0;
}
  801703:	b8 00 00 00 00       	mov    $0x0,%eax
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	57                   	push   %edi
  80170e:	56                   	push   %esi
  80170f:	53                   	push   %ebx
  801710:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801716:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80171b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801721:	eb 31                	jmp    801754 <devcons_write+0x4a>
		m = n - tot;
  801723:	8b 75 10             	mov    0x10(%ebp),%esi
  801726:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  801728:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80172b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801730:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801733:	89 74 24 08          	mov    %esi,0x8(%esp)
  801737:	03 45 0c             	add    0xc(%ebp),%eax
  80173a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173e:	89 3c 24             	mov    %edi,(%esp)
  801741:	e8 fe 09 00 00       	call   802144 <memmove>
		sys_cputs(buf, m);
  801746:	89 74 24 04          	mov    %esi,0x4(%esp)
  80174a:	89 3c 24             	mov    %edi,(%esp)
  80174d:	e8 88 e9 ff ff       	call   8000da <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801752:	01 f3                	add    %esi,%ebx
  801754:	89 d8                	mov    %ebx,%eax
  801756:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801759:	72 c8                	jb     801723 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80175b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801761:	5b                   	pop    %ebx
  801762:	5e                   	pop    %esi
  801763:	5f                   	pop    %edi
  801764:	5d                   	pop    %ebp
  801765:	c3                   	ret    

00801766 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80176c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801771:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801775:	75 07                	jne    80177e <devcons_read+0x18>
  801777:	eb 2a                	jmp    8017a3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801779:	e8 0a ea ff ff       	call   800188 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80177e:	66 90                	xchg   %ax,%ax
  801780:	e8 73 e9 ff ff       	call   8000f8 <sys_cgetc>
  801785:	85 c0                	test   %eax,%eax
  801787:	74 f0                	je     801779 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801789:	85 c0                	test   %eax,%eax
  80178b:	78 16                	js     8017a3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80178d:	83 f8 04             	cmp    $0x4,%eax
  801790:	74 0c                	je     80179e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  801792:	8b 55 0c             	mov    0xc(%ebp),%edx
  801795:	88 02                	mov    %al,(%edx)
	return 1;
  801797:	b8 01 00 00 00       	mov    $0x1,%eax
  80179c:	eb 05                	jmp    8017a3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80179e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8017b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017b8:	00 
  8017b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8017bc:	89 04 24             	mov    %eax,(%esp)
  8017bf:	e8 16 e9 ff ff       	call   8000da <sys_cputs>
}
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <getchar>:

int
getchar(void)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8017cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8017d3:	00 
  8017d4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8017d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017e2:	e8 f3 f0 ff ff       	call   8008da <read>
	if (r < 0)
  8017e7:	85 c0                	test   %eax,%eax
  8017e9:	78 0f                	js     8017fa <getchar+0x34>
		return r;
	if (r < 1)
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	7e 06                	jle    8017f5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8017ef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8017f3:	eb 05                	jmp    8017fa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8017f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801802:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801805:	89 44 24 04          	mov    %eax,0x4(%esp)
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	89 04 24             	mov    %eax,(%esp)
  80180f:	e8 32 ee ff ff       	call   800646 <fd_lookup>
  801814:	85 c0                	test   %eax,%eax
  801816:	78 11                	js     801829 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801821:	39 10                	cmp    %edx,(%eax)
  801823:	0f 94 c0             	sete   %al
  801826:	0f b6 c0             	movzbl %al,%eax
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <opencons>:

int
opencons(void)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801831:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801834:	89 04 24             	mov    %eax,(%esp)
  801837:	e8 bb ed ff ff       	call   8005f7 <fd_alloc>
		return r;
  80183c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80183e:	85 c0                	test   %eax,%eax
  801840:	78 40                	js     801882 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801842:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801849:	00 
  80184a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801851:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801858:	e8 4a e9 ff ff       	call   8001a7 <sys_page_alloc>
		return r;
  80185d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80185f:	85 c0                	test   %eax,%eax
  801861:	78 1f                	js     801882 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801863:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801871:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801878:	89 04 24             	mov    %eax,(%esp)
  80187b:	e8 50 ed ff ff       	call   8005d0 <fd2num>
  801880:	89 c2                	mov    %eax,%edx
}
  801882:	89 d0                	mov    %edx,%eax
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	56                   	push   %esi
  80188a:	53                   	push   %ebx
  80188b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80188e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801891:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801897:	e8 cd e8 ff ff       	call   800169 <sys_getenvid>
  80189c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189f:	89 54 24 10          	mov    %edx,0x10(%esp)
  8018a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8018aa:	89 74 24 08          	mov    %esi,0x8(%esp)
  8018ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b2:	c7 04 24 40 28 80 00 	movl   $0x802840,(%esp)
  8018b9:	e8 c1 00 00 00       	call   80197f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8018be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c5:	89 04 24             	mov    %eax,(%esp)
  8018c8:	e8 51 00 00 00       	call   80191e <vcprintf>
	cprintf("\n");
  8018cd:	c7 04 24 2c 28 80 00 	movl   $0x80282c,(%esp)
  8018d4:	e8 a6 00 00 00       	call   80197f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8018d9:	cc                   	int3   
  8018da:	eb fd                	jmp    8018d9 <_panic+0x53>

008018dc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	53                   	push   %ebx
  8018e0:	83 ec 14             	sub    $0x14,%esp
  8018e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8018e6:	8b 13                	mov    (%ebx),%edx
  8018e8:	8d 42 01             	lea    0x1(%edx),%eax
  8018eb:	89 03                	mov    %eax,(%ebx)
  8018ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8018f4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8018f9:	75 19                	jne    801914 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8018fb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801902:	00 
  801903:	8d 43 08             	lea    0x8(%ebx),%eax
  801906:	89 04 24             	mov    %eax,(%esp)
  801909:	e8 cc e7 ff ff       	call   8000da <sys_cputs>
		b->idx = 0;
  80190e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801914:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801918:	83 c4 14             	add    $0x14,%esp
  80191b:	5b                   	pop    %ebx
  80191c:	5d                   	pop    %ebp
  80191d:	c3                   	ret    

0080191e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801927:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80192e:	00 00 00 
	b.cnt = 0;
  801931:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801938:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80193b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	89 44 24 08          	mov    %eax,0x8(%esp)
  801949:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80194f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801953:	c7 04 24 dc 18 80 00 	movl   $0x8018dc,(%esp)
  80195a:	e8 af 01 00 00       	call   801b0e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80195f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801965:	89 44 24 04          	mov    %eax,0x4(%esp)
  801969:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80196f:	89 04 24             	mov    %eax,(%esp)
  801972:	e8 63 e7 ff ff       	call   8000da <sys_cputs>

	return b.cnt;
}
  801977:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801985:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801988:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	89 04 24             	mov    %eax,(%esp)
  801992:	e8 87 ff ff ff       	call   80191e <vcprintf>
	va_end(ap);

	return cnt;
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    
  801999:	66 90                	xchg   %ax,%ax
  80199b:	66 90                	xchg   %ax,%ax
  80199d:	66 90                	xchg   %ax,%ax
  80199f:	90                   	nop

008019a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	57                   	push   %edi
  8019a4:	56                   	push   %esi
  8019a5:	53                   	push   %ebx
  8019a6:	83 ec 3c             	sub    $0x3c,%esp
  8019a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019ac:	89 d7                	mov    %edx,%edi
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b7:	89 c3                	mov    %eax,%ebx
  8019b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8019bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8019bf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8019c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019ca:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8019cd:	39 d9                	cmp    %ebx,%ecx
  8019cf:	72 05                	jb     8019d6 <printnum+0x36>
  8019d1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8019d4:	77 69                	ja     801a3f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8019d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8019d9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8019dd:	83 ee 01             	sub    $0x1,%esi
  8019e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019ec:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8019f0:	89 c3                	mov    %eax,%ebx
  8019f2:	89 d6                	mov    %edx,%esi
  8019f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019f7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8019fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019fe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a05:	89 04 24             	mov    %eax,(%esp)
  801a08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0f:	e8 2c 0a 00 00       	call   802440 <__udivdi3>
  801a14:	89 d9                	mov    %ebx,%ecx
  801a16:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a1a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801a1e:	89 04 24             	mov    %eax,(%esp)
  801a21:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a25:	89 fa                	mov    %edi,%edx
  801a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a2a:	e8 71 ff ff ff       	call   8019a0 <printnum>
  801a2f:	eb 1b                	jmp    801a4c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801a31:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a35:	8b 45 18             	mov    0x18(%ebp),%eax
  801a38:	89 04 24             	mov    %eax,(%esp)
  801a3b:	ff d3                	call   *%ebx
  801a3d:	eb 03                	jmp    801a42 <printnum+0xa2>
  801a3f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801a42:	83 ee 01             	sub    $0x1,%esi
  801a45:	85 f6                	test   %esi,%esi
  801a47:	7f e8                	jg     801a31 <printnum+0x91>
  801a49:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801a4c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a50:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801a54:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a57:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801a5a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a5e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a65:	89 04 24             	mov    %eax,(%esp)
  801a68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6f:	e8 fc 0a 00 00       	call   802570 <__umoddi3>
  801a74:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a78:	0f be 80 63 28 80 00 	movsbl 0x802863(%eax),%eax
  801a7f:	89 04 24             	mov    %eax,(%esp)
  801a82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a85:	ff d0                	call   *%eax
}
  801a87:	83 c4 3c             	add    $0x3c,%esp
  801a8a:	5b                   	pop    %ebx
  801a8b:	5e                   	pop    %esi
  801a8c:	5f                   	pop    %edi
  801a8d:	5d                   	pop    %ebp
  801a8e:	c3                   	ret    

00801a8f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a92:	83 fa 01             	cmp    $0x1,%edx
  801a95:	7e 0e                	jle    801aa5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801a97:	8b 10                	mov    (%eax),%edx
  801a99:	8d 4a 08             	lea    0x8(%edx),%ecx
  801a9c:	89 08                	mov    %ecx,(%eax)
  801a9e:	8b 02                	mov    (%edx),%eax
  801aa0:	8b 52 04             	mov    0x4(%edx),%edx
  801aa3:	eb 22                	jmp    801ac7 <getuint+0x38>
	else if (lflag)
  801aa5:	85 d2                	test   %edx,%edx
  801aa7:	74 10                	je     801ab9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801aa9:	8b 10                	mov    (%eax),%edx
  801aab:	8d 4a 04             	lea    0x4(%edx),%ecx
  801aae:	89 08                	mov    %ecx,(%eax)
  801ab0:	8b 02                	mov    (%edx),%eax
  801ab2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab7:	eb 0e                	jmp    801ac7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801ab9:	8b 10                	mov    (%eax),%edx
  801abb:	8d 4a 04             	lea    0x4(%edx),%ecx
  801abe:	89 08                	mov    %ecx,(%eax)
  801ac0:	8b 02                	mov    (%edx),%eax
  801ac2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801ac7:	5d                   	pop    %ebp
  801ac8:	c3                   	ret    

00801ac9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801acf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801ad3:	8b 10                	mov    (%eax),%edx
  801ad5:	3b 50 04             	cmp    0x4(%eax),%edx
  801ad8:	73 0a                	jae    801ae4 <sprintputch+0x1b>
		*b->buf++ = ch;
  801ada:	8d 4a 01             	lea    0x1(%edx),%ecx
  801add:	89 08                	mov    %ecx,(%eax)
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	88 02                	mov    %al,(%edx)
}
  801ae4:	5d                   	pop    %ebp
  801ae5:	c3                   	ret    

00801ae6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801aec:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801aef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801af3:	8b 45 10             	mov    0x10(%ebp),%eax
  801af6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	89 04 24             	mov    %eax,(%esp)
  801b07:	e8 02 00 00 00       	call   801b0e <vprintfmt>
	va_end(ap);
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	57                   	push   %edi
  801b12:	56                   	push   %esi
  801b13:	53                   	push   %ebx
  801b14:	83 ec 3c             	sub    $0x3c,%esp
  801b17:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b1d:	eb 14                	jmp    801b33 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	0f 84 b3 03 00 00    	je     801eda <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  801b27:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b2b:	89 04 24             	mov    %eax,(%esp)
  801b2e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b31:	89 f3                	mov    %esi,%ebx
  801b33:	8d 73 01             	lea    0x1(%ebx),%esi
  801b36:	0f b6 03             	movzbl (%ebx),%eax
  801b39:	83 f8 25             	cmp    $0x25,%eax
  801b3c:	75 e1                	jne    801b1f <vprintfmt+0x11>
  801b3e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  801b42:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b49:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  801b50:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  801b57:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5c:	eb 1d                	jmp    801b7b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b5e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  801b60:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801b64:	eb 15                	jmp    801b7b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b66:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b68:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801b6c:	eb 0d                	jmp    801b7b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801b6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b71:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b74:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b7b:	8d 5e 01             	lea    0x1(%esi),%ebx
  801b7e:	0f b6 0e             	movzbl (%esi),%ecx
  801b81:	0f b6 c1             	movzbl %cl,%eax
  801b84:	83 e9 23             	sub    $0x23,%ecx
  801b87:	80 f9 55             	cmp    $0x55,%cl
  801b8a:	0f 87 2a 03 00 00    	ja     801eba <vprintfmt+0x3ac>
  801b90:	0f b6 c9             	movzbl %cl,%ecx
  801b93:	ff 24 8d e0 29 80 00 	jmp    *0x8029e0(,%ecx,4)
  801b9a:	89 de                	mov    %ebx,%esi
  801b9c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801ba1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801ba4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801ba8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801bab:	8d 58 d0             	lea    -0x30(%eax),%ebx
  801bae:	83 fb 09             	cmp    $0x9,%ebx
  801bb1:	77 36                	ja     801be9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801bb3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801bb6:	eb e9                	jmp    801ba1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801bb8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bbb:	8d 48 04             	lea    0x4(%eax),%ecx
  801bbe:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801bc1:	8b 00                	mov    (%eax),%eax
  801bc3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bc6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801bc8:	eb 22                	jmp    801bec <vprintfmt+0xde>
  801bca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801bcd:	85 c9                	test   %ecx,%ecx
  801bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd4:	0f 49 c1             	cmovns %ecx,%eax
  801bd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bda:	89 de                	mov    %ebx,%esi
  801bdc:	eb 9d                	jmp    801b7b <vprintfmt+0x6d>
  801bde:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801be0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  801be7:	eb 92                	jmp    801b7b <vprintfmt+0x6d>
  801be9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  801bec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801bf0:	79 89                	jns    801b7b <vprintfmt+0x6d>
  801bf2:	e9 77 ff ff ff       	jmp    801b6e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801bf7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bfa:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801bfc:	e9 7a ff ff ff       	jmp    801b7b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801c01:	8b 45 14             	mov    0x14(%ebp),%eax
  801c04:	8d 50 04             	lea    0x4(%eax),%edx
  801c07:	89 55 14             	mov    %edx,0x14(%ebp)
  801c0a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c0e:	8b 00                	mov    (%eax),%eax
  801c10:	89 04 24             	mov    %eax,(%esp)
  801c13:	ff 55 08             	call   *0x8(%ebp)
			break;
  801c16:	e9 18 ff ff ff       	jmp    801b33 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801c1b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1e:	8d 50 04             	lea    0x4(%eax),%edx
  801c21:	89 55 14             	mov    %edx,0x14(%ebp)
  801c24:	8b 00                	mov    (%eax),%eax
  801c26:	99                   	cltd   
  801c27:	31 d0                	xor    %edx,%eax
  801c29:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801c2b:	83 f8 12             	cmp    $0x12,%eax
  801c2e:	7f 0b                	jg     801c3b <vprintfmt+0x12d>
  801c30:	8b 14 85 40 2b 80 00 	mov    0x802b40(,%eax,4),%edx
  801c37:	85 d2                	test   %edx,%edx
  801c39:	75 20                	jne    801c5b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  801c3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c3f:	c7 44 24 08 7b 28 80 	movl   $0x80287b,0x8(%esp)
  801c46:	00 
  801c47:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	89 04 24             	mov    %eax,(%esp)
  801c51:	e8 90 fe ff ff       	call   801ae6 <printfmt>
  801c56:	e9 d8 fe ff ff       	jmp    801b33 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801c5b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c5f:	c7 44 24 08 c1 27 80 	movl   $0x8027c1,0x8(%esp)
  801c66:	00 
  801c67:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	89 04 24             	mov    %eax,(%esp)
  801c71:	e8 70 fe ff ff       	call   801ae6 <printfmt>
  801c76:	e9 b8 fe ff ff       	jmp    801b33 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801c7b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801c7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c81:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c84:	8b 45 14             	mov    0x14(%ebp),%eax
  801c87:	8d 50 04             	lea    0x4(%eax),%edx
  801c8a:	89 55 14             	mov    %edx,0x14(%ebp)
  801c8d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  801c8f:	85 f6                	test   %esi,%esi
  801c91:	b8 74 28 80 00       	mov    $0x802874,%eax
  801c96:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  801c99:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  801c9d:	0f 84 97 00 00 00    	je     801d3a <vprintfmt+0x22c>
  801ca3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801ca7:	0f 8e 9b 00 00 00    	jle    801d48 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  801cad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cb1:	89 34 24             	mov    %esi,(%esp)
  801cb4:	e8 cf 02 00 00       	call   801f88 <strnlen>
  801cb9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801cbc:	29 c2                	sub    %eax,%edx
  801cbe:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  801cc1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  801cc5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801cc8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801ccb:	8b 75 08             	mov    0x8(%ebp),%esi
  801cce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801cd1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801cd3:	eb 0f                	jmp    801ce4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  801cd5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801cd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cdc:	89 04 24             	mov    %eax,(%esp)
  801cdf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801ce1:	83 eb 01             	sub    $0x1,%ebx
  801ce4:	85 db                	test   %ebx,%ebx
  801ce6:	7f ed                	jg     801cd5 <vprintfmt+0x1c7>
  801ce8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801ceb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801cee:	85 d2                	test   %edx,%edx
  801cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf5:	0f 49 c2             	cmovns %edx,%eax
  801cf8:	29 c2                	sub    %eax,%edx
  801cfa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801cfd:	89 d7                	mov    %edx,%edi
  801cff:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801d02:	eb 50                	jmp    801d54 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801d04:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d08:	74 1e                	je     801d28 <vprintfmt+0x21a>
  801d0a:	0f be d2             	movsbl %dl,%edx
  801d0d:	83 ea 20             	sub    $0x20,%edx
  801d10:	83 fa 5e             	cmp    $0x5e,%edx
  801d13:	76 13                	jbe    801d28 <vprintfmt+0x21a>
					putch('?', putdat);
  801d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801d23:	ff 55 08             	call   *0x8(%ebp)
  801d26:	eb 0d                	jmp    801d35 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  801d28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2b:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d2f:	89 04 24             	mov    %eax,(%esp)
  801d32:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801d35:	83 ef 01             	sub    $0x1,%edi
  801d38:	eb 1a                	jmp    801d54 <vprintfmt+0x246>
  801d3a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801d3d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801d40:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801d43:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801d46:	eb 0c                	jmp    801d54 <vprintfmt+0x246>
  801d48:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801d4b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801d4e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801d51:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801d54:	83 c6 01             	add    $0x1,%esi
  801d57:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801d5b:	0f be c2             	movsbl %dl,%eax
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	74 27                	je     801d89 <vprintfmt+0x27b>
  801d62:	85 db                	test   %ebx,%ebx
  801d64:	78 9e                	js     801d04 <vprintfmt+0x1f6>
  801d66:	83 eb 01             	sub    $0x1,%ebx
  801d69:	79 99                	jns    801d04 <vprintfmt+0x1f6>
  801d6b:	89 f8                	mov    %edi,%eax
  801d6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d70:	8b 75 08             	mov    0x8(%ebp),%esi
  801d73:	89 c3                	mov    %eax,%ebx
  801d75:	eb 1a                	jmp    801d91 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801d77:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d7b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801d82:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d84:	83 eb 01             	sub    $0x1,%ebx
  801d87:	eb 08                	jmp    801d91 <vprintfmt+0x283>
  801d89:	89 fb                	mov    %edi,%ebx
  801d8b:	8b 75 08             	mov    0x8(%ebp),%esi
  801d8e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d91:	85 db                	test   %ebx,%ebx
  801d93:	7f e2                	jg     801d77 <vprintfmt+0x269>
  801d95:	89 75 08             	mov    %esi,0x8(%ebp)
  801d98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d9b:	e9 93 fd ff ff       	jmp    801b33 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801da0:	83 fa 01             	cmp    $0x1,%edx
  801da3:	7e 16                	jle    801dbb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  801da5:	8b 45 14             	mov    0x14(%ebp),%eax
  801da8:	8d 50 08             	lea    0x8(%eax),%edx
  801dab:	89 55 14             	mov    %edx,0x14(%ebp)
  801dae:	8b 50 04             	mov    0x4(%eax),%edx
  801db1:	8b 00                	mov    (%eax),%eax
  801db3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801db6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801db9:	eb 32                	jmp    801ded <vprintfmt+0x2df>
	else if (lflag)
  801dbb:	85 d2                	test   %edx,%edx
  801dbd:	74 18                	je     801dd7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  801dbf:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc2:	8d 50 04             	lea    0x4(%eax),%edx
  801dc5:	89 55 14             	mov    %edx,0x14(%ebp)
  801dc8:	8b 30                	mov    (%eax),%esi
  801dca:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801dcd:	89 f0                	mov    %esi,%eax
  801dcf:	c1 f8 1f             	sar    $0x1f,%eax
  801dd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dd5:	eb 16                	jmp    801ded <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  801dd7:	8b 45 14             	mov    0x14(%ebp),%eax
  801dda:	8d 50 04             	lea    0x4(%eax),%edx
  801ddd:	89 55 14             	mov    %edx,0x14(%ebp)
  801de0:	8b 30                	mov    (%eax),%esi
  801de2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801de5:	89 f0                	mov    %esi,%eax
  801de7:	c1 f8 1f             	sar    $0x1f,%eax
  801dea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801ded:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801df0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801df3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801df8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801dfc:	0f 89 80 00 00 00    	jns    801e82 <vprintfmt+0x374>
				putch('-', putdat);
  801e02:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e06:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801e0d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801e10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e16:	f7 d8                	neg    %eax
  801e18:	83 d2 00             	adc    $0x0,%edx
  801e1b:	f7 da                	neg    %edx
			}
			base = 10;
  801e1d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801e22:	eb 5e                	jmp    801e82 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801e24:	8d 45 14             	lea    0x14(%ebp),%eax
  801e27:	e8 63 fc ff ff       	call   801a8f <getuint>
			base = 10;
  801e2c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801e31:	eb 4f                	jmp    801e82 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  801e33:	8d 45 14             	lea    0x14(%ebp),%eax
  801e36:	e8 54 fc ff ff       	call   801a8f <getuint>
			base = 8;
  801e3b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801e40:	eb 40                	jmp    801e82 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  801e42:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e46:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801e4d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801e50:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e54:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801e5b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801e5e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e61:	8d 50 04             	lea    0x4(%eax),%edx
  801e64:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801e67:	8b 00                	mov    (%eax),%eax
  801e69:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801e6e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801e73:	eb 0d                	jmp    801e82 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801e75:	8d 45 14             	lea    0x14(%ebp),%eax
  801e78:	e8 12 fc ff ff       	call   801a8f <getuint>
			base = 16;
  801e7d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801e82:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  801e86:	89 74 24 10          	mov    %esi,0x10(%esp)
  801e8a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  801e8d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e91:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e95:	89 04 24             	mov    %eax,(%esp)
  801e98:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e9c:	89 fa                	mov    %edi,%edx
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	e8 fa fa ff ff       	call   8019a0 <printnum>
			break;
  801ea6:	e9 88 fc ff ff       	jmp    801b33 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801eab:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801eaf:	89 04 24             	mov    %eax,(%esp)
  801eb2:	ff 55 08             	call   *0x8(%ebp)
			break;
  801eb5:	e9 79 fc ff ff       	jmp    801b33 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801eba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ebe:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801ec5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ec8:	89 f3                	mov    %esi,%ebx
  801eca:	eb 03                	jmp    801ecf <vprintfmt+0x3c1>
  801ecc:	83 eb 01             	sub    $0x1,%ebx
  801ecf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801ed3:	75 f7                	jne    801ecc <vprintfmt+0x3be>
  801ed5:	e9 59 fc ff ff       	jmp    801b33 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801eda:	83 c4 3c             	add    $0x3c,%esp
  801edd:	5b                   	pop    %ebx
  801ede:	5e                   	pop    %esi
  801edf:	5f                   	pop    %edi
  801ee0:	5d                   	pop    %ebp
  801ee1:	c3                   	ret    

00801ee2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	83 ec 28             	sub    $0x28,%esp
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801eee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ef1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801ef5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801ef8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801eff:	85 c0                	test   %eax,%eax
  801f01:	74 30                	je     801f33 <vsnprintf+0x51>
  801f03:	85 d2                	test   %edx,%edx
  801f05:	7e 2c                	jle    801f33 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801f07:	8b 45 14             	mov    0x14(%ebp),%eax
  801f0a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f11:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f15:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f1c:	c7 04 24 c9 1a 80 00 	movl   $0x801ac9,(%esp)
  801f23:	e8 e6 fb ff ff       	call   801b0e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f31:	eb 05                	jmp    801f38 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801f33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f40:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801f43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f47:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	89 04 24             	mov    %eax,(%esp)
  801f5b:	e8 82 ff ff ff       	call   801ee2 <vsnprintf>
	va_end(ap);

	return rc;
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    
  801f62:	66 90                	xchg   %ax,%ax
  801f64:	66 90                	xchg   %ax,%ax
  801f66:	66 90                	xchg   %ax,%ax
  801f68:	66 90                	xchg   %ax,%ax
  801f6a:	66 90                	xchg   %ax,%ax
  801f6c:	66 90                	xchg   %ax,%ax
  801f6e:	66 90                	xchg   %ax,%ax

00801f70 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801f76:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7b:	eb 03                	jmp    801f80 <strlen+0x10>
		n++;
  801f7d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f80:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801f84:	75 f7                	jne    801f7d <strlen+0xd>
		n++;
	return n;
}
  801f86:	5d                   	pop    %ebp
  801f87:	c3                   	ret    

00801f88 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f8e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f91:	b8 00 00 00 00       	mov    $0x0,%eax
  801f96:	eb 03                	jmp    801f9b <strnlen+0x13>
		n++;
  801f98:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f9b:	39 d0                	cmp    %edx,%eax
  801f9d:	74 06                	je     801fa5 <strnlen+0x1d>
  801f9f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801fa3:	75 f3                	jne    801f98 <strnlen+0x10>
		n++;
	return n;
}
  801fa5:	5d                   	pop    %ebp
  801fa6:	c3                   	ret    

00801fa7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	53                   	push   %ebx
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801fb1:	89 c2                	mov    %eax,%edx
  801fb3:	83 c2 01             	add    $0x1,%edx
  801fb6:	83 c1 01             	add    $0x1,%ecx
  801fb9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801fbd:	88 5a ff             	mov    %bl,-0x1(%edx)
  801fc0:	84 db                	test   %bl,%bl
  801fc2:	75 ef                	jne    801fb3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801fc4:	5b                   	pop    %ebx
  801fc5:	5d                   	pop    %ebp
  801fc6:	c3                   	ret    

00801fc7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	53                   	push   %ebx
  801fcb:	83 ec 08             	sub    $0x8,%esp
  801fce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801fd1:	89 1c 24             	mov    %ebx,(%esp)
  801fd4:	e8 97 ff ff ff       	call   801f70 <strlen>
	strcpy(dst + len, src);
  801fd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdc:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fe0:	01 d8                	add    %ebx,%eax
  801fe2:	89 04 24             	mov    %eax,(%esp)
  801fe5:	e8 bd ff ff ff       	call   801fa7 <strcpy>
	return dst;
}
  801fea:	89 d8                	mov    %ebx,%eax
  801fec:	83 c4 08             	add    $0x8,%esp
  801fef:	5b                   	pop    %ebx
  801ff0:	5d                   	pop    %ebp
  801ff1:	c3                   	ret    

00801ff2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	56                   	push   %esi
  801ff6:	53                   	push   %ebx
  801ff7:	8b 75 08             	mov    0x8(%ebp),%esi
  801ffa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ffd:	89 f3                	mov    %esi,%ebx
  801fff:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802002:	89 f2                	mov    %esi,%edx
  802004:	eb 0f                	jmp    802015 <strncpy+0x23>
		*dst++ = *src;
  802006:	83 c2 01             	add    $0x1,%edx
  802009:	0f b6 01             	movzbl (%ecx),%eax
  80200c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80200f:	80 39 01             	cmpb   $0x1,(%ecx)
  802012:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802015:	39 da                	cmp    %ebx,%edx
  802017:	75 ed                	jne    802006 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  802019:	89 f0                	mov    %esi,%eax
  80201b:	5b                   	pop    %ebx
  80201c:	5e                   	pop    %esi
  80201d:	5d                   	pop    %ebp
  80201e:	c3                   	ret    

0080201f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	56                   	push   %esi
  802023:	53                   	push   %ebx
  802024:	8b 75 08             	mov    0x8(%ebp),%esi
  802027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202d:	89 f0                	mov    %esi,%eax
  80202f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802033:	85 c9                	test   %ecx,%ecx
  802035:	75 0b                	jne    802042 <strlcpy+0x23>
  802037:	eb 1d                	jmp    802056 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  802039:	83 c0 01             	add    $0x1,%eax
  80203c:	83 c2 01             	add    $0x1,%edx
  80203f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802042:	39 d8                	cmp    %ebx,%eax
  802044:	74 0b                	je     802051 <strlcpy+0x32>
  802046:	0f b6 0a             	movzbl (%edx),%ecx
  802049:	84 c9                	test   %cl,%cl
  80204b:	75 ec                	jne    802039 <strlcpy+0x1a>
  80204d:	89 c2                	mov    %eax,%edx
  80204f:	eb 02                	jmp    802053 <strlcpy+0x34>
  802051:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  802053:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  802056:	29 f0                	sub    %esi,%eax
}
  802058:	5b                   	pop    %ebx
  802059:	5e                   	pop    %esi
  80205a:	5d                   	pop    %ebp
  80205b:	c3                   	ret    

0080205c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802062:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802065:	eb 06                	jmp    80206d <strcmp+0x11>
		p++, q++;
  802067:	83 c1 01             	add    $0x1,%ecx
  80206a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80206d:	0f b6 01             	movzbl (%ecx),%eax
  802070:	84 c0                	test   %al,%al
  802072:	74 04                	je     802078 <strcmp+0x1c>
  802074:	3a 02                	cmp    (%edx),%al
  802076:	74 ef                	je     802067 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802078:	0f b6 c0             	movzbl %al,%eax
  80207b:	0f b6 12             	movzbl (%edx),%edx
  80207e:	29 d0                	sub    %edx,%eax
}
  802080:	5d                   	pop    %ebp
  802081:	c3                   	ret    

00802082 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	53                   	push   %ebx
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208c:	89 c3                	mov    %eax,%ebx
  80208e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802091:	eb 06                	jmp    802099 <strncmp+0x17>
		n--, p++, q++;
  802093:	83 c0 01             	add    $0x1,%eax
  802096:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802099:	39 d8                	cmp    %ebx,%eax
  80209b:	74 15                	je     8020b2 <strncmp+0x30>
  80209d:	0f b6 08             	movzbl (%eax),%ecx
  8020a0:	84 c9                	test   %cl,%cl
  8020a2:	74 04                	je     8020a8 <strncmp+0x26>
  8020a4:	3a 0a                	cmp    (%edx),%cl
  8020a6:	74 eb                	je     802093 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8020a8:	0f b6 00             	movzbl (%eax),%eax
  8020ab:	0f b6 12             	movzbl (%edx),%edx
  8020ae:	29 d0                	sub    %edx,%eax
  8020b0:	eb 05                	jmp    8020b7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8020b2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8020b7:	5b                   	pop    %ebx
  8020b8:	5d                   	pop    %ebp
  8020b9:	c3                   	ret    

008020ba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8020c4:	eb 07                	jmp    8020cd <strchr+0x13>
		if (*s == c)
  8020c6:	38 ca                	cmp    %cl,%dl
  8020c8:	74 0f                	je     8020d9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020ca:	83 c0 01             	add    $0x1,%eax
  8020cd:	0f b6 10             	movzbl (%eax),%edx
  8020d0:	84 d2                	test   %dl,%dl
  8020d2:	75 f2                	jne    8020c6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8020d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d9:	5d                   	pop    %ebp
  8020da:	c3                   	ret    

008020db <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8020e5:	eb 07                	jmp    8020ee <strfind+0x13>
		if (*s == c)
  8020e7:	38 ca                	cmp    %cl,%dl
  8020e9:	74 0a                	je     8020f5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8020eb:	83 c0 01             	add    $0x1,%eax
  8020ee:	0f b6 10             	movzbl (%eax),%edx
  8020f1:	84 d2                	test   %dl,%dl
  8020f3:	75 f2                	jne    8020e7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8020f5:	5d                   	pop    %ebp
  8020f6:	c3                   	ret    

008020f7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	57                   	push   %edi
  8020fb:	56                   	push   %esi
  8020fc:	53                   	push   %ebx
  8020fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  802100:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802103:	85 c9                	test   %ecx,%ecx
  802105:	74 36                	je     80213d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802107:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80210d:	75 28                	jne    802137 <memset+0x40>
  80210f:	f6 c1 03             	test   $0x3,%cl
  802112:	75 23                	jne    802137 <memset+0x40>
		c &= 0xFF;
  802114:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802118:	89 d3                	mov    %edx,%ebx
  80211a:	c1 e3 08             	shl    $0x8,%ebx
  80211d:	89 d6                	mov    %edx,%esi
  80211f:	c1 e6 18             	shl    $0x18,%esi
  802122:	89 d0                	mov    %edx,%eax
  802124:	c1 e0 10             	shl    $0x10,%eax
  802127:	09 f0                	or     %esi,%eax
  802129:	09 c2                	or     %eax,%edx
  80212b:	89 d0                	mov    %edx,%eax
  80212d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80212f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802132:	fc                   	cld    
  802133:	f3 ab                	rep stos %eax,%es:(%edi)
  802135:	eb 06                	jmp    80213d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213a:	fc                   	cld    
  80213b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80213d:	89 f8                	mov    %edi,%eax
  80213f:	5b                   	pop    %ebx
  802140:	5e                   	pop    %esi
  802141:	5f                   	pop    %edi
  802142:	5d                   	pop    %ebp
  802143:	c3                   	ret    

00802144 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	57                   	push   %edi
  802148:	56                   	push   %esi
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80214f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802152:	39 c6                	cmp    %eax,%esi
  802154:	73 35                	jae    80218b <memmove+0x47>
  802156:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802159:	39 d0                	cmp    %edx,%eax
  80215b:	73 2e                	jae    80218b <memmove+0x47>
		s += n;
		d += n;
  80215d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  802160:	89 d6                	mov    %edx,%esi
  802162:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802164:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80216a:	75 13                	jne    80217f <memmove+0x3b>
  80216c:	f6 c1 03             	test   $0x3,%cl
  80216f:	75 0e                	jne    80217f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802171:	83 ef 04             	sub    $0x4,%edi
  802174:	8d 72 fc             	lea    -0x4(%edx),%esi
  802177:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80217a:	fd                   	std    
  80217b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80217d:	eb 09                	jmp    802188 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80217f:	83 ef 01             	sub    $0x1,%edi
  802182:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802185:	fd                   	std    
  802186:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802188:	fc                   	cld    
  802189:	eb 1d                	jmp    8021a8 <memmove+0x64>
  80218b:	89 f2                	mov    %esi,%edx
  80218d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80218f:	f6 c2 03             	test   $0x3,%dl
  802192:	75 0f                	jne    8021a3 <memmove+0x5f>
  802194:	f6 c1 03             	test   $0x3,%cl
  802197:	75 0a                	jne    8021a3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802199:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80219c:	89 c7                	mov    %eax,%edi
  80219e:	fc                   	cld    
  80219f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8021a1:	eb 05                	jmp    8021a8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8021a3:	89 c7                	mov    %eax,%edi
  8021a5:	fc                   	cld    
  8021a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8021a8:	5e                   	pop    %esi
  8021a9:	5f                   	pop    %edi
  8021aa:	5d                   	pop    %ebp
  8021ab:	c3                   	ret    

008021ac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8021b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	89 04 24             	mov    %eax,(%esp)
  8021c6:	e8 79 ff ff ff       	call   802144 <memmove>
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	56                   	push   %esi
  8021d1:	53                   	push   %ebx
  8021d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021d8:	89 d6                	mov    %edx,%esi
  8021da:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8021dd:	eb 1a                	jmp    8021f9 <memcmp+0x2c>
		if (*s1 != *s2)
  8021df:	0f b6 02             	movzbl (%edx),%eax
  8021e2:	0f b6 19             	movzbl (%ecx),%ebx
  8021e5:	38 d8                	cmp    %bl,%al
  8021e7:	74 0a                	je     8021f3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8021e9:	0f b6 c0             	movzbl %al,%eax
  8021ec:	0f b6 db             	movzbl %bl,%ebx
  8021ef:	29 d8                	sub    %ebx,%eax
  8021f1:	eb 0f                	jmp    802202 <memcmp+0x35>
		s1++, s2++;
  8021f3:	83 c2 01             	add    $0x1,%edx
  8021f6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8021f9:	39 f2                	cmp    %esi,%edx
  8021fb:	75 e2                	jne    8021df <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8021fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802202:	5b                   	pop    %ebx
  802203:	5e                   	pop    %esi
  802204:	5d                   	pop    %ebp
  802205:	c3                   	ret    

00802206 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80220f:	89 c2                	mov    %eax,%edx
  802211:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802214:	eb 07                	jmp    80221d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  802216:	38 08                	cmp    %cl,(%eax)
  802218:	74 07                	je     802221 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80221a:	83 c0 01             	add    $0x1,%eax
  80221d:	39 d0                	cmp    %edx,%eax
  80221f:	72 f5                	jb     802216 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802221:	5d                   	pop    %ebp
  802222:	c3                   	ret    

00802223 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	57                   	push   %edi
  802227:	56                   	push   %esi
  802228:	53                   	push   %ebx
  802229:	8b 55 08             	mov    0x8(%ebp),%edx
  80222c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80222f:	eb 03                	jmp    802234 <strtol+0x11>
		s++;
  802231:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802234:	0f b6 0a             	movzbl (%edx),%ecx
  802237:	80 f9 09             	cmp    $0x9,%cl
  80223a:	74 f5                	je     802231 <strtol+0xe>
  80223c:	80 f9 20             	cmp    $0x20,%cl
  80223f:	74 f0                	je     802231 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  802241:	80 f9 2b             	cmp    $0x2b,%cl
  802244:	75 0a                	jne    802250 <strtol+0x2d>
		s++;
  802246:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  802249:	bf 00 00 00 00       	mov    $0x0,%edi
  80224e:	eb 11                	jmp    802261 <strtol+0x3e>
  802250:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  802255:	80 f9 2d             	cmp    $0x2d,%cl
  802258:	75 07                	jne    802261 <strtol+0x3e>
		s++, neg = 1;
  80225a:	8d 52 01             	lea    0x1(%edx),%edx
  80225d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802261:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  802266:	75 15                	jne    80227d <strtol+0x5a>
  802268:	80 3a 30             	cmpb   $0x30,(%edx)
  80226b:	75 10                	jne    80227d <strtol+0x5a>
  80226d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  802271:	75 0a                	jne    80227d <strtol+0x5a>
		s += 2, base = 16;
  802273:	83 c2 02             	add    $0x2,%edx
  802276:	b8 10 00 00 00       	mov    $0x10,%eax
  80227b:	eb 10                	jmp    80228d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80227d:	85 c0                	test   %eax,%eax
  80227f:	75 0c                	jne    80228d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802281:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802283:	80 3a 30             	cmpb   $0x30,(%edx)
  802286:	75 05                	jne    80228d <strtol+0x6a>
		s++, base = 8;
  802288:	83 c2 01             	add    $0x1,%edx
  80228b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80228d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802292:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802295:	0f b6 0a             	movzbl (%edx),%ecx
  802298:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80229b:	89 f0                	mov    %esi,%eax
  80229d:	3c 09                	cmp    $0x9,%al
  80229f:	77 08                	ja     8022a9 <strtol+0x86>
			dig = *s - '0';
  8022a1:	0f be c9             	movsbl %cl,%ecx
  8022a4:	83 e9 30             	sub    $0x30,%ecx
  8022a7:	eb 20                	jmp    8022c9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  8022a9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8022ac:	89 f0                	mov    %esi,%eax
  8022ae:	3c 19                	cmp    $0x19,%al
  8022b0:	77 08                	ja     8022ba <strtol+0x97>
			dig = *s - 'a' + 10;
  8022b2:	0f be c9             	movsbl %cl,%ecx
  8022b5:	83 e9 57             	sub    $0x57,%ecx
  8022b8:	eb 0f                	jmp    8022c9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8022ba:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8022bd:	89 f0                	mov    %esi,%eax
  8022bf:	3c 19                	cmp    $0x19,%al
  8022c1:	77 16                	ja     8022d9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  8022c3:	0f be c9             	movsbl %cl,%ecx
  8022c6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8022c9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8022cc:	7d 0f                	jge    8022dd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  8022ce:	83 c2 01             	add    $0x1,%edx
  8022d1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8022d5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8022d7:	eb bc                	jmp    802295 <strtol+0x72>
  8022d9:	89 d8                	mov    %ebx,%eax
  8022db:	eb 02                	jmp    8022df <strtol+0xbc>
  8022dd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8022df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022e3:	74 05                	je     8022ea <strtol+0xc7>
		*endptr = (char *) s;
  8022e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022e8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8022ea:	f7 d8                	neg    %eax
  8022ec:	85 ff                	test   %edi,%edi
  8022ee:	0f 44 c3             	cmove  %ebx,%eax
}
  8022f1:	5b                   	pop    %ebx
  8022f2:	5e                   	pop    %esi
  8022f3:	5f                   	pop    %edi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    
  8022f6:	66 90                	xchg   %ax,%ax
  8022f8:	66 90                	xchg   %ax,%ax
  8022fa:	66 90                	xchg   %ax,%ax
  8022fc:	66 90                	xchg   %ax,%ax
  8022fe:	66 90                	xchg   %ax,%ax

00802300 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	56                   	push   %esi
  802304:	53                   	push   %ebx
  802305:	83 ec 10             	sub    $0x10,%esp
  802308:	8b 75 08             	mov    0x8(%ebp),%esi
  80230b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802311:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  802313:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802318:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  80231b:	89 04 24             	mov    %eax,(%esp)
  80231e:	e8 9a e0 ff ff       	call   8003bd <sys_ipc_recv>
  802323:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802325:	85 d2                	test   %edx,%edx
  802327:	75 24                	jne    80234d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802329:	85 f6                	test   %esi,%esi
  80232b:	74 0a                	je     802337 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80232d:	a1 08 40 80 00       	mov    0x804008,%eax
  802332:	8b 40 74             	mov    0x74(%eax),%eax
  802335:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802337:	85 db                	test   %ebx,%ebx
  802339:	74 0a                	je     802345 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80233b:	a1 08 40 80 00       	mov    0x804008,%eax
  802340:	8b 40 78             	mov    0x78(%eax),%eax
  802343:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802345:	a1 08 40 80 00       	mov    0x804008,%eax
  80234a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80234d:	83 c4 10             	add    $0x10,%esp
  802350:	5b                   	pop    %ebx
  802351:	5e                   	pop    %esi
  802352:	5d                   	pop    %ebp
  802353:	c3                   	ret    

00802354 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	57                   	push   %edi
  802358:	56                   	push   %esi
  802359:	53                   	push   %ebx
  80235a:	83 ec 1c             	sub    $0x1c,%esp
  80235d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802360:	8b 75 0c             	mov    0xc(%ebp),%esi
  802363:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802366:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802368:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80236d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802370:	8b 45 14             	mov    0x14(%ebp),%eax
  802373:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802377:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80237b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80237f:	89 3c 24             	mov    %edi,(%esp)
  802382:	e8 13 e0 ff ff       	call   80039a <sys_ipc_try_send>

		if (ret == 0)
  802387:	85 c0                	test   %eax,%eax
  802389:	74 2c                	je     8023b7 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80238b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80238e:	74 20                	je     8023b0 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802390:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802394:	c7 44 24 08 ac 2b 80 	movl   $0x802bac,0x8(%esp)
  80239b:	00 
  80239c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8023a3:	00 
  8023a4:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  8023ab:	e8 d6 f4 ff ff       	call   801886 <_panic>
		}

		sys_yield();
  8023b0:	e8 d3 dd ff ff       	call   800188 <sys_yield>
	}
  8023b5:	eb b9                	jmp    802370 <ipc_send+0x1c>
}
  8023b7:	83 c4 1c             	add    $0x1c,%esp
  8023ba:	5b                   	pop    %ebx
  8023bb:	5e                   	pop    %esi
  8023bc:	5f                   	pop    %edi
  8023bd:	5d                   	pop    %ebp
  8023be:	c3                   	ret    

008023bf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023c5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023ca:	89 c2                	mov    %eax,%edx
  8023cc:	c1 e2 07             	shl    $0x7,%edx
  8023cf:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  8023d6:	8b 52 50             	mov    0x50(%edx),%edx
  8023d9:	39 ca                	cmp    %ecx,%edx
  8023db:	75 11                	jne    8023ee <ipc_find_env+0x2f>
			return envs[i].env_id;
  8023dd:	89 c2                	mov    %eax,%edx
  8023df:	c1 e2 07             	shl    $0x7,%edx
  8023e2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  8023e9:	8b 40 40             	mov    0x40(%eax),%eax
  8023ec:	eb 0e                	jmp    8023fc <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023ee:	83 c0 01             	add    $0x1,%eax
  8023f1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023f6:	75 d2                	jne    8023ca <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023f8:	66 b8 00 00          	mov    $0x0,%ax
}
  8023fc:	5d                   	pop    %ebp
  8023fd:	c3                   	ret    

008023fe <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
  802401:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802404:	89 d0                	mov    %edx,%eax
  802406:	c1 e8 16             	shr    $0x16,%eax
  802409:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802410:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802415:	f6 c1 01             	test   $0x1,%cl
  802418:	74 1d                	je     802437 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80241a:	c1 ea 0c             	shr    $0xc,%edx
  80241d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802424:	f6 c2 01             	test   $0x1,%dl
  802427:	74 0e                	je     802437 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802429:	c1 ea 0c             	shr    $0xc,%edx
  80242c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802433:	ef 
  802434:	0f b7 c0             	movzwl %ax,%eax
}
  802437:	5d                   	pop    %ebp
  802438:	c3                   	ret    
  802439:	66 90                	xchg   %ax,%ax
  80243b:	66 90                	xchg   %ax,%ax
  80243d:	66 90                	xchg   %ax,%ax
  80243f:	90                   	nop

00802440 <__udivdi3>:
  802440:	55                   	push   %ebp
  802441:	57                   	push   %edi
  802442:	56                   	push   %esi
  802443:	83 ec 0c             	sub    $0xc,%esp
  802446:	8b 44 24 28          	mov    0x28(%esp),%eax
  80244a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80244e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802452:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802456:	85 c0                	test   %eax,%eax
  802458:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80245c:	89 ea                	mov    %ebp,%edx
  80245e:	89 0c 24             	mov    %ecx,(%esp)
  802461:	75 2d                	jne    802490 <__udivdi3+0x50>
  802463:	39 e9                	cmp    %ebp,%ecx
  802465:	77 61                	ja     8024c8 <__udivdi3+0x88>
  802467:	85 c9                	test   %ecx,%ecx
  802469:	89 ce                	mov    %ecx,%esi
  80246b:	75 0b                	jne    802478 <__udivdi3+0x38>
  80246d:	b8 01 00 00 00       	mov    $0x1,%eax
  802472:	31 d2                	xor    %edx,%edx
  802474:	f7 f1                	div    %ecx
  802476:	89 c6                	mov    %eax,%esi
  802478:	31 d2                	xor    %edx,%edx
  80247a:	89 e8                	mov    %ebp,%eax
  80247c:	f7 f6                	div    %esi
  80247e:	89 c5                	mov    %eax,%ebp
  802480:	89 f8                	mov    %edi,%eax
  802482:	f7 f6                	div    %esi
  802484:	89 ea                	mov    %ebp,%edx
  802486:	83 c4 0c             	add    $0xc,%esp
  802489:	5e                   	pop    %esi
  80248a:	5f                   	pop    %edi
  80248b:	5d                   	pop    %ebp
  80248c:	c3                   	ret    
  80248d:	8d 76 00             	lea    0x0(%esi),%esi
  802490:	39 e8                	cmp    %ebp,%eax
  802492:	77 24                	ja     8024b8 <__udivdi3+0x78>
  802494:	0f bd e8             	bsr    %eax,%ebp
  802497:	83 f5 1f             	xor    $0x1f,%ebp
  80249a:	75 3c                	jne    8024d8 <__udivdi3+0x98>
  80249c:	8b 74 24 04          	mov    0x4(%esp),%esi
  8024a0:	39 34 24             	cmp    %esi,(%esp)
  8024a3:	0f 86 9f 00 00 00    	jbe    802548 <__udivdi3+0x108>
  8024a9:	39 d0                	cmp    %edx,%eax
  8024ab:	0f 82 97 00 00 00    	jb     802548 <__udivdi3+0x108>
  8024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	31 d2                	xor    %edx,%edx
  8024ba:	31 c0                	xor    %eax,%eax
  8024bc:	83 c4 0c             	add    $0xc,%esp
  8024bf:	5e                   	pop    %esi
  8024c0:	5f                   	pop    %edi
  8024c1:	5d                   	pop    %ebp
  8024c2:	c3                   	ret    
  8024c3:	90                   	nop
  8024c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	89 f8                	mov    %edi,%eax
  8024ca:	f7 f1                	div    %ecx
  8024cc:	31 d2                	xor    %edx,%edx
  8024ce:	83 c4 0c             	add    $0xc,%esp
  8024d1:	5e                   	pop    %esi
  8024d2:	5f                   	pop    %edi
  8024d3:	5d                   	pop    %ebp
  8024d4:	c3                   	ret    
  8024d5:	8d 76 00             	lea    0x0(%esi),%esi
  8024d8:	89 e9                	mov    %ebp,%ecx
  8024da:	8b 3c 24             	mov    (%esp),%edi
  8024dd:	d3 e0                	shl    %cl,%eax
  8024df:	89 c6                	mov    %eax,%esi
  8024e1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024e6:	29 e8                	sub    %ebp,%eax
  8024e8:	89 c1                	mov    %eax,%ecx
  8024ea:	d3 ef                	shr    %cl,%edi
  8024ec:	89 e9                	mov    %ebp,%ecx
  8024ee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024f2:	8b 3c 24             	mov    (%esp),%edi
  8024f5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024f9:	89 d6                	mov    %edx,%esi
  8024fb:	d3 e7                	shl    %cl,%edi
  8024fd:	89 c1                	mov    %eax,%ecx
  8024ff:	89 3c 24             	mov    %edi,(%esp)
  802502:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802506:	d3 ee                	shr    %cl,%esi
  802508:	89 e9                	mov    %ebp,%ecx
  80250a:	d3 e2                	shl    %cl,%edx
  80250c:	89 c1                	mov    %eax,%ecx
  80250e:	d3 ef                	shr    %cl,%edi
  802510:	09 d7                	or     %edx,%edi
  802512:	89 f2                	mov    %esi,%edx
  802514:	89 f8                	mov    %edi,%eax
  802516:	f7 74 24 08          	divl   0x8(%esp)
  80251a:	89 d6                	mov    %edx,%esi
  80251c:	89 c7                	mov    %eax,%edi
  80251e:	f7 24 24             	mull   (%esp)
  802521:	39 d6                	cmp    %edx,%esi
  802523:	89 14 24             	mov    %edx,(%esp)
  802526:	72 30                	jb     802558 <__udivdi3+0x118>
  802528:	8b 54 24 04          	mov    0x4(%esp),%edx
  80252c:	89 e9                	mov    %ebp,%ecx
  80252e:	d3 e2                	shl    %cl,%edx
  802530:	39 c2                	cmp    %eax,%edx
  802532:	73 05                	jae    802539 <__udivdi3+0xf9>
  802534:	3b 34 24             	cmp    (%esp),%esi
  802537:	74 1f                	je     802558 <__udivdi3+0x118>
  802539:	89 f8                	mov    %edi,%eax
  80253b:	31 d2                	xor    %edx,%edx
  80253d:	e9 7a ff ff ff       	jmp    8024bc <__udivdi3+0x7c>
  802542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802548:	31 d2                	xor    %edx,%edx
  80254a:	b8 01 00 00 00       	mov    $0x1,%eax
  80254f:	e9 68 ff ff ff       	jmp    8024bc <__udivdi3+0x7c>
  802554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802558:	8d 47 ff             	lea    -0x1(%edi),%eax
  80255b:	31 d2                	xor    %edx,%edx
  80255d:	83 c4 0c             	add    $0xc,%esp
  802560:	5e                   	pop    %esi
  802561:	5f                   	pop    %edi
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    
  802564:	66 90                	xchg   %ax,%ax
  802566:	66 90                	xchg   %ax,%ax
  802568:	66 90                	xchg   %ax,%ax
  80256a:	66 90                	xchg   %ax,%ax
  80256c:	66 90                	xchg   %ax,%ax
  80256e:	66 90                	xchg   %ax,%ax

00802570 <__umoddi3>:
  802570:	55                   	push   %ebp
  802571:	57                   	push   %edi
  802572:	56                   	push   %esi
  802573:	83 ec 14             	sub    $0x14,%esp
  802576:	8b 44 24 28          	mov    0x28(%esp),%eax
  80257a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80257e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802582:	89 c7                	mov    %eax,%edi
  802584:	89 44 24 04          	mov    %eax,0x4(%esp)
  802588:	8b 44 24 30          	mov    0x30(%esp),%eax
  80258c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802590:	89 34 24             	mov    %esi,(%esp)
  802593:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802597:	85 c0                	test   %eax,%eax
  802599:	89 c2                	mov    %eax,%edx
  80259b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80259f:	75 17                	jne    8025b8 <__umoddi3+0x48>
  8025a1:	39 fe                	cmp    %edi,%esi
  8025a3:	76 4b                	jbe    8025f0 <__umoddi3+0x80>
  8025a5:	89 c8                	mov    %ecx,%eax
  8025a7:	89 fa                	mov    %edi,%edx
  8025a9:	f7 f6                	div    %esi
  8025ab:	89 d0                	mov    %edx,%eax
  8025ad:	31 d2                	xor    %edx,%edx
  8025af:	83 c4 14             	add    $0x14,%esp
  8025b2:	5e                   	pop    %esi
  8025b3:	5f                   	pop    %edi
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    
  8025b6:	66 90                	xchg   %ax,%ax
  8025b8:	39 f8                	cmp    %edi,%eax
  8025ba:	77 54                	ja     802610 <__umoddi3+0xa0>
  8025bc:	0f bd e8             	bsr    %eax,%ebp
  8025bf:	83 f5 1f             	xor    $0x1f,%ebp
  8025c2:	75 5c                	jne    802620 <__umoddi3+0xb0>
  8025c4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025c8:	39 3c 24             	cmp    %edi,(%esp)
  8025cb:	0f 87 e7 00 00 00    	ja     8026b8 <__umoddi3+0x148>
  8025d1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025d5:	29 f1                	sub    %esi,%ecx
  8025d7:	19 c7                	sbb    %eax,%edi
  8025d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025e1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025e5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025e9:	83 c4 14             	add    $0x14,%esp
  8025ec:	5e                   	pop    %esi
  8025ed:	5f                   	pop    %edi
  8025ee:	5d                   	pop    %ebp
  8025ef:	c3                   	ret    
  8025f0:	85 f6                	test   %esi,%esi
  8025f2:	89 f5                	mov    %esi,%ebp
  8025f4:	75 0b                	jne    802601 <__umoddi3+0x91>
  8025f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025fb:	31 d2                	xor    %edx,%edx
  8025fd:	f7 f6                	div    %esi
  8025ff:	89 c5                	mov    %eax,%ebp
  802601:	8b 44 24 04          	mov    0x4(%esp),%eax
  802605:	31 d2                	xor    %edx,%edx
  802607:	f7 f5                	div    %ebp
  802609:	89 c8                	mov    %ecx,%eax
  80260b:	f7 f5                	div    %ebp
  80260d:	eb 9c                	jmp    8025ab <__umoddi3+0x3b>
  80260f:	90                   	nop
  802610:	89 c8                	mov    %ecx,%eax
  802612:	89 fa                	mov    %edi,%edx
  802614:	83 c4 14             	add    $0x14,%esp
  802617:	5e                   	pop    %esi
  802618:	5f                   	pop    %edi
  802619:	5d                   	pop    %ebp
  80261a:	c3                   	ret    
  80261b:	90                   	nop
  80261c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802620:	8b 04 24             	mov    (%esp),%eax
  802623:	be 20 00 00 00       	mov    $0x20,%esi
  802628:	89 e9                	mov    %ebp,%ecx
  80262a:	29 ee                	sub    %ebp,%esi
  80262c:	d3 e2                	shl    %cl,%edx
  80262e:	89 f1                	mov    %esi,%ecx
  802630:	d3 e8                	shr    %cl,%eax
  802632:	89 e9                	mov    %ebp,%ecx
  802634:	89 44 24 04          	mov    %eax,0x4(%esp)
  802638:	8b 04 24             	mov    (%esp),%eax
  80263b:	09 54 24 04          	or     %edx,0x4(%esp)
  80263f:	89 fa                	mov    %edi,%edx
  802641:	d3 e0                	shl    %cl,%eax
  802643:	89 f1                	mov    %esi,%ecx
  802645:	89 44 24 08          	mov    %eax,0x8(%esp)
  802649:	8b 44 24 10          	mov    0x10(%esp),%eax
  80264d:	d3 ea                	shr    %cl,%edx
  80264f:	89 e9                	mov    %ebp,%ecx
  802651:	d3 e7                	shl    %cl,%edi
  802653:	89 f1                	mov    %esi,%ecx
  802655:	d3 e8                	shr    %cl,%eax
  802657:	89 e9                	mov    %ebp,%ecx
  802659:	09 f8                	or     %edi,%eax
  80265b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80265f:	f7 74 24 04          	divl   0x4(%esp)
  802663:	d3 e7                	shl    %cl,%edi
  802665:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802669:	89 d7                	mov    %edx,%edi
  80266b:	f7 64 24 08          	mull   0x8(%esp)
  80266f:	39 d7                	cmp    %edx,%edi
  802671:	89 c1                	mov    %eax,%ecx
  802673:	89 14 24             	mov    %edx,(%esp)
  802676:	72 2c                	jb     8026a4 <__umoddi3+0x134>
  802678:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80267c:	72 22                	jb     8026a0 <__umoddi3+0x130>
  80267e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802682:	29 c8                	sub    %ecx,%eax
  802684:	19 d7                	sbb    %edx,%edi
  802686:	89 e9                	mov    %ebp,%ecx
  802688:	89 fa                	mov    %edi,%edx
  80268a:	d3 e8                	shr    %cl,%eax
  80268c:	89 f1                	mov    %esi,%ecx
  80268e:	d3 e2                	shl    %cl,%edx
  802690:	89 e9                	mov    %ebp,%ecx
  802692:	d3 ef                	shr    %cl,%edi
  802694:	09 d0                	or     %edx,%eax
  802696:	89 fa                	mov    %edi,%edx
  802698:	83 c4 14             	add    $0x14,%esp
  80269b:	5e                   	pop    %esi
  80269c:	5f                   	pop    %edi
  80269d:	5d                   	pop    %ebp
  80269e:	c3                   	ret    
  80269f:	90                   	nop
  8026a0:	39 d7                	cmp    %edx,%edi
  8026a2:	75 da                	jne    80267e <__umoddi3+0x10e>
  8026a4:	8b 14 24             	mov    (%esp),%edx
  8026a7:	89 c1                	mov    %eax,%ecx
  8026a9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8026ad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8026b1:	eb cb                	jmp    80267e <__umoddi3+0x10e>
  8026b3:	90                   	nop
  8026b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026b8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8026bc:	0f 82 0f ff ff ff    	jb     8025d1 <__umoddi3+0x61>
  8026c2:	e9 1a ff ff ff       	jmp    8025e1 <__umoddi3+0x71>
