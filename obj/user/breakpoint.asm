
obj/user/breakpoint.debug:     file format elf32-i386


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
  80002c:	e8 08 00 00 00       	call   800039 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $3");
  800036:	cc                   	int3   
}
  800037:	5d                   	pop    %ebp
  800038:	c3                   	ret    

00800039 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800039:	55                   	push   %ebp
  80003a:	89 e5                	mov    %esp,%ebp
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 10             	sub    $0x10,%esp
  800041:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800044:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800047:	e8 e1 00 00 00       	call   80012d <sys_getenvid>
  80004c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800051:	89 c2                	mov    %eax,%edx
  800053:	c1 e2 07             	shl    $0x7,%edx
  800056:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  80005d:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800062:	85 db                	test   %ebx,%ebx
  800064:	7e 07                	jle    80006d <libmain+0x34>
		binaryname = argv[0];
  800066:	8b 06                	mov    (%esi),%eax
  800068:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800071:	89 1c 24             	mov    %ebx,(%esp)
  800074:	e8 ba ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800079:	e8 07 00 00 00       	call   800085 <exit>
}
  80007e:	83 c4 10             	add    $0x10,%esp
  800081:	5b                   	pop    %ebx
  800082:	5e                   	pop    %esi
  800083:	5d                   	pop    %ebp
  800084:	c3                   	ret    

00800085 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800085:	55                   	push   %ebp
  800086:	89 e5                	mov    %esp,%ebp
  800088:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80008b:	e8 da 06 00 00       	call   80076a <close_all>
	sys_env_destroy(0);
  800090:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800097:	e8 3f 00 00 00       	call   8000db <sys_env_destroy>
}
  80009c:	c9                   	leave  
  80009d:	c3                   	ret    

0080009e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	57                   	push   %edi
  8000a2:	56                   	push   %esi
  8000a3:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8000af:	89 c3                	mov    %eax,%ebx
  8000b1:	89 c7                	mov    %eax,%edi
  8000b3:	89 c6                	mov    %eax,%esi
  8000b5:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b7:	5b                   	pop    %ebx
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret    

008000bc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000bc:	55                   	push   %ebp
  8000bd:	89 e5                	mov    %esp,%ebp
  8000bf:	57                   	push   %edi
  8000c0:	56                   	push   %esi
  8000c1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	89 d3                	mov    %edx,%ebx
  8000d0:	89 d7                	mov    %edx,%edi
  8000d2:	89 d6                	mov    %edx,%esi
  8000d4:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d6:	5b                   	pop    %ebx
  8000d7:	5e                   	pop    %esi
  8000d8:	5f                   	pop    %edi
  8000d9:	5d                   	pop    %ebp
  8000da:	c3                   	ret    

008000db <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	57                   	push   %edi
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e9:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f1:	89 cb                	mov    %ecx,%ebx
  8000f3:	89 cf                	mov    %ecx,%edi
  8000f5:	89 ce                	mov    %ecx,%esi
  8000f7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8000f9:	85 c0                	test   %eax,%eax
  8000fb:	7e 28                	jle    800125 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8000fd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800101:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800108:	00 
  800109:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  800110:	00 
  800111:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800118:	00 
  800119:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  800120:	e8 21 17 00 00       	call   801846 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800125:	83 c4 2c             	add    $0x2c,%esp
  800128:	5b                   	pop    %ebx
  800129:	5e                   	pop    %esi
  80012a:	5f                   	pop    %edi
  80012b:	5d                   	pop    %ebp
  80012c:	c3                   	ret    

0080012d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	57                   	push   %edi
  800131:	56                   	push   %esi
  800132:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800133:	ba 00 00 00 00       	mov    $0x0,%edx
  800138:	b8 02 00 00 00       	mov    $0x2,%eax
  80013d:	89 d1                	mov    %edx,%ecx
  80013f:	89 d3                	mov    %edx,%ebx
  800141:	89 d7                	mov    %edx,%edi
  800143:	89 d6                	mov    %edx,%esi
  800145:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800147:	5b                   	pop    %ebx
  800148:	5e                   	pop    %esi
  800149:	5f                   	pop    %edi
  80014a:	5d                   	pop    %ebp
  80014b:	c3                   	ret    

0080014c <sys_yield>:

void
sys_yield(void)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	57                   	push   %edi
  800150:	56                   	push   %esi
  800151:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800152:	ba 00 00 00 00       	mov    $0x0,%edx
  800157:	b8 0b 00 00 00       	mov    $0xb,%eax
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	89 d3                	mov    %edx,%ebx
  800160:	89 d7                	mov    %edx,%edi
  800162:	89 d6                	mov    %edx,%esi
  800164:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800166:	5b                   	pop    %ebx
  800167:	5e                   	pop    %esi
  800168:	5f                   	pop    %edi
  800169:	5d                   	pop    %ebp
  80016a:	c3                   	ret    

0080016b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	57                   	push   %edi
  80016f:	56                   	push   %esi
  800170:	53                   	push   %ebx
  800171:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800174:	be 00 00 00 00       	mov    $0x0,%esi
  800179:	b8 04 00 00 00       	mov    $0x4,%eax
  80017e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800181:	8b 55 08             	mov    0x8(%ebp),%edx
  800184:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800187:	89 f7                	mov    %esi,%edi
  800189:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80018b:	85 c0                	test   %eax,%eax
  80018d:	7e 28                	jle    8001b7 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  80018f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800193:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80019a:	00 
  80019b:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  8001a2:	00 
  8001a3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001aa:	00 
  8001ab:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  8001b2:	e8 8f 16 00 00       	call   801846 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001b7:	83 c4 2c             	add    $0x2c,%esp
  8001ba:	5b                   	pop    %ebx
  8001bb:	5e                   	pop    %esi
  8001bc:	5f                   	pop    %edi
  8001bd:	5d                   	pop    %ebp
  8001be:	c3                   	ret    

008001bf <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	57                   	push   %edi
  8001c3:	56                   	push   %esi
  8001c4:	53                   	push   %ebx
  8001c5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001c8:	b8 05 00 00 00       	mov    $0x5,%eax
  8001cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001d9:	8b 75 18             	mov    0x18(%ebp),%esi
  8001dc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001de:	85 c0                	test   %eax,%eax
  8001e0:	7e 28                	jle    80020a <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001e2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001e6:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8001ed:	00 
  8001ee:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  8001f5:	00 
  8001f6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001fd:	00 
  8001fe:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  800205:	e8 3c 16 00 00       	call   801846 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80020a:	83 c4 2c             	add    $0x2c,%esp
  80020d:	5b                   	pop    %ebx
  80020e:	5e                   	pop    %esi
  80020f:	5f                   	pop    %edi
  800210:	5d                   	pop    %ebp
  800211:	c3                   	ret    

00800212 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	57                   	push   %edi
  800216:	56                   	push   %esi
  800217:	53                   	push   %ebx
  800218:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80021b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800220:	b8 06 00 00 00       	mov    $0x6,%eax
  800225:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800228:	8b 55 08             	mov    0x8(%ebp),%edx
  80022b:	89 df                	mov    %ebx,%edi
  80022d:	89 de                	mov    %ebx,%esi
  80022f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800231:	85 c0                	test   %eax,%eax
  800233:	7e 28                	jle    80025d <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800235:	89 44 24 10          	mov    %eax,0x10(%esp)
  800239:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800240:	00 
  800241:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  800248:	00 
  800249:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800250:	00 
  800251:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  800258:	e8 e9 15 00 00       	call   801846 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80025d:	83 c4 2c             	add    $0x2c,%esp
  800260:	5b                   	pop    %ebx
  800261:	5e                   	pop    %esi
  800262:	5f                   	pop    %edi
  800263:	5d                   	pop    %ebp
  800264:	c3                   	ret    

00800265 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
  800268:	57                   	push   %edi
  800269:	56                   	push   %esi
  80026a:	53                   	push   %ebx
  80026b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80026e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800273:	b8 08 00 00 00       	mov    $0x8,%eax
  800278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027b:	8b 55 08             	mov    0x8(%ebp),%edx
  80027e:	89 df                	mov    %ebx,%edi
  800280:	89 de                	mov    %ebx,%esi
  800282:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800284:	85 c0                	test   %eax,%eax
  800286:	7e 28                	jle    8002b0 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800288:	89 44 24 10          	mov    %eax,0x10(%esp)
  80028c:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800293:	00 
  800294:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  80029b:	00 
  80029c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002a3:	00 
  8002a4:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  8002ab:	e8 96 15 00 00       	call   801846 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002b0:	83 c4 2c             	add    $0x2c,%esp
  8002b3:	5b                   	pop    %ebx
  8002b4:	5e                   	pop    %esi
  8002b5:	5f                   	pop    %edi
  8002b6:	5d                   	pop    %ebp
  8002b7:	c3                   	ret    

008002b8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	57                   	push   %edi
  8002bc:	56                   	push   %esi
  8002bd:	53                   	push   %ebx
  8002be:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c6:	b8 09 00 00 00       	mov    $0x9,%eax
  8002cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d1:	89 df                	mov    %ebx,%edi
  8002d3:	89 de                	mov    %ebx,%esi
  8002d5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002d7:	85 c0                	test   %eax,%eax
  8002d9:	7e 28                	jle    800303 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002db:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002df:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8002e6:	00 
  8002e7:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  8002ee:	00 
  8002ef:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002f6:	00 
  8002f7:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  8002fe:	e8 43 15 00 00       	call   801846 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800303:	83 c4 2c             	add    $0x2c,%esp
  800306:	5b                   	pop    %ebx
  800307:	5e                   	pop    %esi
  800308:	5f                   	pop    %edi
  800309:	5d                   	pop    %ebp
  80030a:	c3                   	ret    

0080030b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	57                   	push   %edi
  80030f:	56                   	push   %esi
  800310:	53                   	push   %ebx
  800311:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800314:	bb 00 00 00 00       	mov    $0x0,%ebx
  800319:	b8 0a 00 00 00       	mov    $0xa,%eax
  80031e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800321:	8b 55 08             	mov    0x8(%ebp),%edx
  800324:	89 df                	mov    %ebx,%edi
  800326:	89 de                	mov    %ebx,%esi
  800328:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80032a:	85 c0                	test   %eax,%eax
  80032c:	7e 28                	jle    800356 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80032e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800332:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800339:	00 
  80033a:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  800341:	00 
  800342:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800349:	00 
  80034a:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  800351:	e8 f0 14 00 00       	call   801846 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800356:	83 c4 2c             	add    $0x2c,%esp
  800359:	5b                   	pop    %ebx
  80035a:	5e                   	pop    %esi
  80035b:	5f                   	pop    %edi
  80035c:	5d                   	pop    %ebp
  80035d:	c3                   	ret    

0080035e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80035e:	55                   	push   %ebp
  80035f:	89 e5                	mov    %esp,%ebp
  800361:	57                   	push   %edi
  800362:	56                   	push   %esi
  800363:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800364:	be 00 00 00 00       	mov    $0x0,%esi
  800369:	b8 0c 00 00 00       	mov    $0xc,%eax
  80036e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800371:	8b 55 08             	mov    0x8(%ebp),%edx
  800374:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800377:	8b 7d 14             	mov    0x14(%ebp),%edi
  80037a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80037c:	5b                   	pop    %ebx
  80037d:	5e                   	pop    %esi
  80037e:	5f                   	pop    %edi
  80037f:	5d                   	pop    %ebp
  800380:	c3                   	ret    

00800381 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800381:	55                   	push   %ebp
  800382:	89 e5                	mov    %esp,%ebp
  800384:	57                   	push   %edi
  800385:	56                   	push   %esi
  800386:	53                   	push   %ebx
  800387:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80038a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80038f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800394:	8b 55 08             	mov    0x8(%ebp),%edx
  800397:	89 cb                	mov    %ecx,%ebx
  800399:	89 cf                	mov    %ecx,%edi
  80039b:	89 ce                	mov    %ecx,%esi
  80039d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80039f:	85 c0                	test   %eax,%eax
  8003a1:	7e 28                	jle    8003cb <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003a3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003a7:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8003ae:	00 
  8003af:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  8003b6:	00 
  8003b7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003be:	00 
  8003bf:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  8003c6:	e8 7b 14 00 00       	call   801846 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8003cb:	83 c4 2c             	add    $0x2c,%esp
  8003ce:	5b                   	pop    %ebx
  8003cf:	5e                   	pop    %esi
  8003d0:	5f                   	pop    %edi
  8003d1:	5d                   	pop    %ebp
  8003d2:	c3                   	ret    

008003d3 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	57                   	push   %edi
  8003d7:	56                   	push   %esi
  8003d8:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003de:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003e3:	89 d1                	mov    %edx,%ecx
  8003e5:	89 d3                	mov    %edx,%ebx
  8003e7:	89 d7                	mov    %edx,%edi
  8003e9:	89 d6                	mov    %edx,%esi
  8003eb:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003ed:	5b                   	pop    %ebx
  8003ee:	5e                   	pop    %esi
  8003ef:	5f                   	pop    %edi
  8003f0:	5d                   	pop    %ebp
  8003f1:	c3                   	ret    

008003f2 <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  8003f2:	55                   	push   %ebp
  8003f3:	89 e5                	mov    %esp,%ebp
  8003f5:	57                   	push   %edi
  8003f6:	56                   	push   %esi
  8003f7:	53                   	push   %ebx
  8003f8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800400:	b8 0f 00 00 00       	mov    $0xf,%eax
  800405:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800408:	8b 55 08             	mov    0x8(%ebp),%edx
  80040b:	89 df                	mov    %ebx,%edi
  80040d:	89 de                	mov    %ebx,%esi
  80040f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800411:	85 c0                	test   %eax,%eax
  800413:	7e 28                	jle    80043d <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800415:	89 44 24 10          	mov    %eax,0x10(%esp)
  800419:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800420:	00 
  800421:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  800428:	00 
  800429:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800430:	00 
  800431:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  800438:	e8 09 14 00 00       	call   801846 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  80043d:	83 c4 2c             	add    $0x2c,%esp
  800440:	5b                   	pop    %ebx
  800441:	5e                   	pop    %esi
  800442:	5f                   	pop    %edi
  800443:	5d                   	pop    %ebp
  800444:	c3                   	ret    

00800445 <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  800445:	55                   	push   %ebp
  800446:	89 e5                	mov    %esp,%ebp
  800448:	57                   	push   %edi
  800449:	56                   	push   %esi
  80044a:	53                   	push   %ebx
  80044b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80044e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800453:	b8 10 00 00 00       	mov    $0x10,%eax
  800458:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80045b:	8b 55 08             	mov    0x8(%ebp),%edx
  80045e:	89 df                	mov    %ebx,%edi
  800460:	89 de                	mov    %ebx,%esi
  800462:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800464:	85 c0                	test   %eax,%eax
  800466:	7e 28                	jle    800490 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800468:	89 44 24 10          	mov    %eax,0x10(%esp)
  80046c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800473:	00 
  800474:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  80047b:	00 
  80047c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800483:	00 
  800484:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  80048b:	e8 b6 13 00 00       	call   801846 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  800490:	83 c4 2c             	add    $0x2c,%esp
  800493:	5b                   	pop    %ebx
  800494:	5e                   	pop    %esi
  800495:	5f                   	pop    %edi
  800496:	5d                   	pop    %ebp
  800497:	c3                   	ret    

00800498 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  800498:	55                   	push   %ebp
  800499:	89 e5                	mov    %esp,%ebp
  80049b:	57                   	push   %edi
  80049c:	56                   	push   %esi
  80049d:	53                   	push   %ebx
  80049e:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004a6:	b8 11 00 00 00       	mov    $0x11,%eax
  8004ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b1:	89 df                	mov    %ebx,%edi
  8004b3:	89 de                	mov    %ebx,%esi
  8004b5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8004b7:	85 c0                	test   %eax,%eax
  8004b9:	7e 28                	jle    8004e3 <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8004bb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004bf:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  8004c6:	00 
  8004c7:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  8004ce:	00 
  8004cf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004d6:	00 
  8004d7:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  8004de:	e8 63 13 00 00       	call   801846 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  8004e3:	83 c4 2c             	add    $0x2c,%esp
  8004e6:	5b                   	pop    %ebx
  8004e7:	5e                   	pop    %esi
  8004e8:	5f                   	pop    %edi
  8004e9:	5d                   	pop    %ebp
  8004ea:	c3                   	ret    

008004eb <sys_sleep>:

int
sys_sleep(int channel)
{
  8004eb:	55                   	push   %ebp
  8004ec:	89 e5                	mov    %esp,%ebp
  8004ee:	57                   	push   %edi
  8004ef:	56                   	push   %esi
  8004f0:	53                   	push   %ebx
  8004f1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004f9:	b8 12 00 00 00       	mov    $0x12,%eax
  8004fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800501:	89 cb                	mov    %ecx,%ebx
  800503:	89 cf                	mov    %ecx,%edi
  800505:	89 ce                	mov    %ecx,%esi
  800507:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800509:	85 c0                	test   %eax,%eax
  80050b:	7e 28                	jle    800535 <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80050d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800511:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800518:	00 
  800519:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  800520:	00 
  800521:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800528:	00 
  800529:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  800530:	e8 11 13 00 00       	call   801846 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  800535:	83 c4 2c             	add    $0x2c,%esp
  800538:	5b                   	pop    %ebx
  800539:	5e                   	pop    %esi
  80053a:	5f                   	pop    %edi
  80053b:	5d                   	pop    %ebp
  80053c:	c3                   	ret    

0080053d <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  80053d:	55                   	push   %ebp
  80053e:	89 e5                	mov    %esp,%ebp
  800540:	57                   	push   %edi
  800541:	56                   	push   %esi
  800542:	53                   	push   %ebx
  800543:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800546:	bb 00 00 00 00       	mov    $0x0,%ebx
  80054b:	b8 13 00 00 00       	mov    $0x13,%eax
  800550:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800553:	8b 55 08             	mov    0x8(%ebp),%edx
  800556:	89 df                	mov    %ebx,%edi
  800558:	89 de                	mov    %ebx,%esi
  80055a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80055c:	85 c0                	test   %eax,%eax
  80055e:	7e 28                	jle    800588 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800560:	89 44 24 10          	mov    %eax,0x10(%esp)
  800564:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  80056b:	00 
  80056c:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  800573:	00 
  800574:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80057b:	00 
  80057c:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  800583:	e8 be 12 00 00       	call   801846 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  800588:	83 c4 2c             	add    $0x2c,%esp
  80058b:	5b                   	pop    %ebx
  80058c:	5e                   	pop    %esi
  80058d:	5f                   	pop    %edi
  80058e:	5d                   	pop    %ebp
  80058f:	c3                   	ret    

00800590 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	05 00 00 00 30       	add    $0x30000000,%eax
  80059b:	c1 e8 0c             	shr    $0xc,%eax
}
  80059e:	5d                   	pop    %ebp
  80059f:	c3                   	ret    

008005a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8005ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005b0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8005b5:	5d                   	pop    %ebp
  8005b6:	c3                   	ret    

008005b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005bd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005c2:	89 c2                	mov    %eax,%edx
  8005c4:	c1 ea 16             	shr    $0x16,%edx
  8005c7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8005ce:	f6 c2 01             	test   $0x1,%dl
  8005d1:	74 11                	je     8005e4 <fd_alloc+0x2d>
  8005d3:	89 c2                	mov    %eax,%edx
  8005d5:	c1 ea 0c             	shr    $0xc,%edx
  8005d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8005df:	f6 c2 01             	test   $0x1,%dl
  8005e2:	75 09                	jne    8005ed <fd_alloc+0x36>
			*fd_store = fd;
  8005e4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8005e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005eb:	eb 17                	jmp    800604 <fd_alloc+0x4d>
  8005ed:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005f2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8005f7:	75 c9                	jne    8005c2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8005f9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8005ff:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800604:	5d                   	pop    %ebp
  800605:	c3                   	ret    

00800606 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800606:	55                   	push   %ebp
  800607:	89 e5                	mov    %esp,%ebp
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80060c:	83 f8 1f             	cmp    $0x1f,%eax
  80060f:	77 36                	ja     800647 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800611:	c1 e0 0c             	shl    $0xc,%eax
  800614:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800619:	89 c2                	mov    %eax,%edx
  80061b:	c1 ea 16             	shr    $0x16,%edx
  80061e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800625:	f6 c2 01             	test   $0x1,%dl
  800628:	74 24                	je     80064e <fd_lookup+0x48>
  80062a:	89 c2                	mov    %eax,%edx
  80062c:	c1 ea 0c             	shr    $0xc,%edx
  80062f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800636:	f6 c2 01             	test   $0x1,%dl
  800639:	74 1a                	je     800655 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80063b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80063e:	89 02                	mov    %eax,(%edx)
	return 0;
  800640:	b8 00 00 00 00       	mov    $0x0,%eax
  800645:	eb 13                	jmp    80065a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800647:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80064c:	eb 0c                	jmp    80065a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80064e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800653:	eb 05                	jmp    80065a <fd_lookup+0x54>
  800655:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80065a:	5d                   	pop    %ebp
  80065b:	c3                   	ret    

0080065c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80065c:	55                   	push   %ebp
  80065d:	89 e5                	mov    %esp,%ebp
  80065f:	83 ec 18             	sub    $0x18,%esp
  800662:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	eb 13                	jmp    80067f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80066c:	39 08                	cmp    %ecx,(%eax)
  80066e:	75 0c                	jne    80067c <dev_lookup+0x20>
			*dev = devtab[i];
  800670:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800673:	89 01                	mov    %eax,(%ecx)
			return 0;
  800675:	b8 00 00 00 00       	mov    $0x0,%eax
  80067a:	eb 38                	jmp    8006b4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80067c:	83 c2 01             	add    $0x1,%edx
  80067f:	8b 04 95 54 27 80 00 	mov    0x802754(,%edx,4),%eax
  800686:	85 c0                	test   %eax,%eax
  800688:	75 e2                	jne    80066c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80068a:	a1 08 40 80 00       	mov    0x804008,%eax
  80068f:	8b 40 48             	mov    0x48(%eax),%eax
  800692:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800696:	89 44 24 04          	mov    %eax,0x4(%esp)
  80069a:	c7 04 24 d8 26 80 00 	movl   $0x8026d8,(%esp)
  8006a1:	e8 99 12 00 00       	call   80193f <cprintf>
	*dev = 0;
  8006a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8006af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    

008006b6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	56                   	push   %esi
  8006ba:	53                   	push   %ebx
  8006bb:	83 ec 20             	sub    $0x20,%esp
  8006be:	8b 75 08             	mov    0x8(%ebp),%esi
  8006c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006c7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8006cb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8006d1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006d4:	89 04 24             	mov    %eax,(%esp)
  8006d7:	e8 2a ff ff ff       	call   800606 <fd_lookup>
  8006dc:	85 c0                	test   %eax,%eax
  8006de:	78 05                	js     8006e5 <fd_close+0x2f>
	    || fd != fd2)
  8006e0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8006e3:	74 0c                	je     8006f1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8006e5:	84 db                	test   %bl,%bl
  8006e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ec:	0f 44 c2             	cmove  %edx,%eax
  8006ef:	eb 3f                	jmp    800730 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8006f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006f8:	8b 06                	mov    (%esi),%eax
  8006fa:	89 04 24             	mov    %eax,(%esp)
  8006fd:	e8 5a ff ff ff       	call   80065c <dev_lookup>
  800702:	89 c3                	mov    %eax,%ebx
  800704:	85 c0                	test   %eax,%eax
  800706:	78 16                	js     80071e <fd_close+0x68>
		if (dev->dev_close)
  800708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80070b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80070e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800713:	85 c0                	test   %eax,%eax
  800715:	74 07                	je     80071e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800717:	89 34 24             	mov    %esi,(%esp)
  80071a:	ff d0                	call   *%eax
  80071c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80071e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800722:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800729:	e8 e4 fa ff ff       	call   800212 <sys_page_unmap>
	return r;
  80072e:	89 d8                	mov    %ebx,%eax
}
  800730:	83 c4 20             	add    $0x20,%esp
  800733:	5b                   	pop    %ebx
  800734:	5e                   	pop    %esi
  800735:	5d                   	pop    %ebp
  800736:	c3                   	ret    

00800737 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800737:	55                   	push   %ebp
  800738:	89 e5                	mov    %esp,%ebp
  80073a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80073d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800740:	89 44 24 04          	mov    %eax,0x4(%esp)
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	89 04 24             	mov    %eax,(%esp)
  80074a:	e8 b7 fe ff ff       	call   800606 <fd_lookup>
  80074f:	89 c2                	mov    %eax,%edx
  800751:	85 d2                	test   %edx,%edx
  800753:	78 13                	js     800768 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800755:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80075c:	00 
  80075d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800760:	89 04 24             	mov    %eax,(%esp)
  800763:	e8 4e ff ff ff       	call   8006b6 <fd_close>
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <close_all>:

void
close_all(void)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	53                   	push   %ebx
  80076e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800771:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800776:	89 1c 24             	mov    %ebx,(%esp)
  800779:	e8 b9 ff ff ff       	call   800737 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80077e:	83 c3 01             	add    $0x1,%ebx
  800781:	83 fb 20             	cmp    $0x20,%ebx
  800784:	75 f0                	jne    800776 <close_all+0xc>
		close(i);
}
  800786:	83 c4 14             	add    $0x14,%esp
  800789:	5b                   	pop    %ebx
  80078a:	5d                   	pop    %ebp
  80078b:	c3                   	ret    

0080078c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	57                   	push   %edi
  800790:	56                   	push   %esi
  800791:	53                   	push   %ebx
  800792:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800795:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800798:	89 44 24 04          	mov    %eax,0x4(%esp)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	89 04 24             	mov    %eax,(%esp)
  8007a2:	e8 5f fe ff ff       	call   800606 <fd_lookup>
  8007a7:	89 c2                	mov    %eax,%edx
  8007a9:	85 d2                	test   %edx,%edx
  8007ab:	0f 88 e1 00 00 00    	js     800892 <dup+0x106>
		return r;
	close(newfdnum);
  8007b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b4:	89 04 24             	mov    %eax,(%esp)
  8007b7:	e8 7b ff ff ff       	call   800737 <close>

	newfd = INDEX2FD(newfdnum);
  8007bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007bf:	c1 e3 0c             	shl    $0xc,%ebx
  8007c2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007cb:	89 04 24             	mov    %eax,(%esp)
  8007ce:	e8 cd fd ff ff       	call   8005a0 <fd2data>
  8007d3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8007d5:	89 1c 24             	mov    %ebx,(%esp)
  8007d8:	e8 c3 fd ff ff       	call   8005a0 <fd2data>
  8007dd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8007df:	89 f0                	mov    %esi,%eax
  8007e1:	c1 e8 16             	shr    $0x16,%eax
  8007e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8007eb:	a8 01                	test   $0x1,%al
  8007ed:	74 43                	je     800832 <dup+0xa6>
  8007ef:	89 f0                	mov    %esi,%eax
  8007f1:	c1 e8 0c             	shr    $0xc,%eax
  8007f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8007fb:	f6 c2 01             	test   $0x1,%dl
  8007fe:	74 32                	je     800832 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800800:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800807:	25 07 0e 00 00       	and    $0xe07,%eax
  80080c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800810:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800814:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80081b:	00 
  80081c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800820:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800827:	e8 93 f9 ff ff       	call   8001bf <sys_page_map>
  80082c:	89 c6                	mov    %eax,%esi
  80082e:	85 c0                	test   %eax,%eax
  800830:	78 3e                	js     800870 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800832:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800835:	89 c2                	mov    %eax,%edx
  800837:	c1 ea 0c             	shr    $0xc,%edx
  80083a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800841:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800847:	89 54 24 10          	mov    %edx,0x10(%esp)
  80084b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80084f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800856:	00 
  800857:	89 44 24 04          	mov    %eax,0x4(%esp)
  80085b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800862:	e8 58 f9 ff ff       	call   8001bf <sys_page_map>
  800867:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  800869:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80086c:	85 f6                	test   %esi,%esi
  80086e:	79 22                	jns    800892 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800870:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800874:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80087b:	e8 92 f9 ff ff       	call   800212 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800880:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800884:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80088b:	e8 82 f9 ff ff       	call   800212 <sys_page_unmap>
	return r;
  800890:	89 f0                	mov    %esi,%eax
}
  800892:	83 c4 3c             	add    $0x3c,%esp
  800895:	5b                   	pop    %ebx
  800896:	5e                   	pop    %esi
  800897:	5f                   	pop    %edi
  800898:	5d                   	pop    %ebp
  800899:	c3                   	ret    

0080089a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	53                   	push   %ebx
  80089e:	83 ec 24             	sub    $0x24,%esp
  8008a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ab:	89 1c 24             	mov    %ebx,(%esp)
  8008ae:	e8 53 fd ff ff       	call   800606 <fd_lookup>
  8008b3:	89 c2                	mov    %eax,%edx
  8008b5:	85 d2                	test   %edx,%edx
  8008b7:	78 6d                	js     800926 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	89 04 24             	mov    %eax,(%esp)
  8008c8:	e8 8f fd ff ff       	call   80065c <dev_lookup>
  8008cd:	85 c0                	test   %eax,%eax
  8008cf:	78 55                	js     800926 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8008d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d4:	8b 50 08             	mov    0x8(%eax),%edx
  8008d7:	83 e2 03             	and    $0x3,%edx
  8008da:	83 fa 01             	cmp    $0x1,%edx
  8008dd:	75 23                	jne    800902 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8008df:	a1 08 40 80 00       	mov    0x804008,%eax
  8008e4:	8b 40 48             	mov    0x48(%eax),%eax
  8008e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8008eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ef:	c7 04 24 19 27 80 00 	movl   $0x802719,(%esp)
  8008f6:	e8 44 10 00 00       	call   80193f <cprintf>
		return -E_INVAL;
  8008fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800900:	eb 24                	jmp    800926 <read+0x8c>
	}
	if (!dev->dev_read)
  800902:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800905:	8b 52 08             	mov    0x8(%edx),%edx
  800908:	85 d2                	test   %edx,%edx
  80090a:	74 15                	je     800921 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80090c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80090f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800913:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800916:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80091a:	89 04 24             	mov    %eax,(%esp)
  80091d:	ff d2                	call   *%edx
  80091f:	eb 05                	jmp    800926 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800921:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800926:	83 c4 24             	add    $0x24,%esp
  800929:	5b                   	pop    %ebx
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	57                   	push   %edi
  800930:	56                   	push   %esi
  800931:	53                   	push   %ebx
  800932:	83 ec 1c             	sub    $0x1c,%esp
  800935:	8b 7d 08             	mov    0x8(%ebp),%edi
  800938:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80093b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800940:	eb 23                	jmp    800965 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800942:	89 f0                	mov    %esi,%eax
  800944:	29 d8                	sub    %ebx,%eax
  800946:	89 44 24 08          	mov    %eax,0x8(%esp)
  80094a:	89 d8                	mov    %ebx,%eax
  80094c:	03 45 0c             	add    0xc(%ebp),%eax
  80094f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800953:	89 3c 24             	mov    %edi,(%esp)
  800956:	e8 3f ff ff ff       	call   80089a <read>
		if (m < 0)
  80095b:	85 c0                	test   %eax,%eax
  80095d:	78 10                	js     80096f <readn+0x43>
			return m;
		if (m == 0)
  80095f:	85 c0                	test   %eax,%eax
  800961:	74 0a                	je     80096d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800963:	01 c3                	add    %eax,%ebx
  800965:	39 f3                	cmp    %esi,%ebx
  800967:	72 d9                	jb     800942 <readn+0x16>
  800969:	89 d8                	mov    %ebx,%eax
  80096b:	eb 02                	jmp    80096f <readn+0x43>
  80096d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80096f:	83 c4 1c             	add    $0x1c,%esp
  800972:	5b                   	pop    %ebx
  800973:	5e                   	pop    %esi
  800974:	5f                   	pop    %edi
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	53                   	push   %ebx
  80097b:	83 ec 24             	sub    $0x24,%esp
  80097e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800981:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800984:	89 44 24 04          	mov    %eax,0x4(%esp)
  800988:	89 1c 24             	mov    %ebx,(%esp)
  80098b:	e8 76 fc ff ff       	call   800606 <fd_lookup>
  800990:	89 c2                	mov    %eax,%edx
  800992:	85 d2                	test   %edx,%edx
  800994:	78 68                	js     8009fe <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800996:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800999:	89 44 24 04          	mov    %eax,0x4(%esp)
  80099d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a0:	8b 00                	mov    (%eax),%eax
  8009a2:	89 04 24             	mov    %eax,(%esp)
  8009a5:	e8 b2 fc ff ff       	call   80065c <dev_lookup>
  8009aa:	85 c0                	test   %eax,%eax
  8009ac:	78 50                	js     8009fe <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8009b5:	75 23                	jne    8009da <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8009b7:	a1 08 40 80 00       	mov    0x804008,%eax
  8009bc:	8b 40 48             	mov    0x48(%eax),%eax
  8009bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8009c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009c7:	c7 04 24 35 27 80 00 	movl   $0x802735,(%esp)
  8009ce:	e8 6c 0f 00 00       	call   80193f <cprintf>
		return -E_INVAL;
  8009d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d8:	eb 24                	jmp    8009fe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8009da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009dd:	8b 52 0c             	mov    0xc(%edx),%edx
  8009e0:	85 d2                	test   %edx,%edx
  8009e2:	74 15                	je     8009f9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8009e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8009eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009f2:	89 04 24             	mov    %eax,(%esp)
  8009f5:	ff d2                	call   *%edx
  8009f7:	eb 05                	jmp    8009fe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8009f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8009fe:	83 c4 24             	add    $0x24,%esp
  800a01:	5b                   	pop    %ebx
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <seek>:

int
seek(int fdnum, off_t offset)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800a0a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800a0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	89 04 24             	mov    %eax,(%esp)
  800a17:	e8 ea fb ff ff       	call   800606 <fd_lookup>
  800a1c:	85 c0                	test   %eax,%eax
  800a1e:	78 0e                	js     800a2e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a26:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800a29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a2e:	c9                   	leave  
  800a2f:	c3                   	ret    

00800a30 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	53                   	push   %ebx
  800a34:	83 ec 24             	sub    $0x24,%esp
  800a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a3a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a41:	89 1c 24             	mov    %ebx,(%esp)
  800a44:	e8 bd fb ff ff       	call   800606 <fd_lookup>
  800a49:	89 c2                	mov    %eax,%edx
  800a4b:	85 d2                	test   %edx,%edx
  800a4d:	78 61                	js     800ab0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a52:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a59:	8b 00                	mov    (%eax),%eax
  800a5b:	89 04 24             	mov    %eax,(%esp)
  800a5e:	e8 f9 fb ff ff       	call   80065c <dev_lookup>
  800a63:	85 c0                	test   %eax,%eax
  800a65:	78 49                	js     800ab0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800a6e:	75 23                	jne    800a93 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800a70:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800a75:	8b 40 48             	mov    0x48(%eax),%eax
  800a78:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a80:	c7 04 24 f8 26 80 00 	movl   $0x8026f8,(%esp)
  800a87:	e8 b3 0e 00 00       	call   80193f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800a8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a91:	eb 1d                	jmp    800ab0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  800a93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a96:	8b 52 18             	mov    0x18(%edx),%edx
  800a99:	85 d2                	test   %edx,%edx
  800a9b:	74 0e                	je     800aab <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800a9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800aa4:	89 04 24             	mov    %eax,(%esp)
  800aa7:	ff d2                	call   *%edx
  800aa9:	eb 05                	jmp    800ab0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800aab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800ab0:	83 c4 24             	add    $0x24,%esp
  800ab3:	5b                   	pop    %ebx
  800ab4:	5d                   	pop    %ebp
  800ab5:	c3                   	ret    

00800ab6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	53                   	push   %ebx
  800aba:	83 ec 24             	sub    $0x24,%esp
  800abd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ac0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	89 04 24             	mov    %eax,(%esp)
  800acd:	e8 34 fb ff ff       	call   800606 <fd_lookup>
  800ad2:	89 c2                	mov    %eax,%edx
  800ad4:	85 d2                	test   %edx,%edx
  800ad6:	78 52                	js     800b2a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ad8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800adb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae2:	8b 00                	mov    (%eax),%eax
  800ae4:	89 04 24             	mov    %eax,(%esp)
  800ae7:	e8 70 fb ff ff       	call   80065c <dev_lookup>
  800aec:	85 c0                	test   %eax,%eax
  800aee:	78 3a                	js     800b2a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800af3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800af7:	74 2c                	je     800b25 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800af9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800afc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800b03:	00 00 00 
	stat->st_isdir = 0;
  800b06:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b0d:	00 00 00 
	stat->st_dev = dev;
  800b10:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800b16:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800b1d:	89 14 24             	mov    %edx,(%esp)
  800b20:	ff 50 14             	call   *0x14(%eax)
  800b23:	eb 05                	jmp    800b2a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800b25:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800b2a:	83 c4 24             	add    $0x24,%esp
  800b2d:	5b                   	pop    %ebx
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    

00800b30 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	56                   	push   %esi
  800b34:	53                   	push   %ebx
  800b35:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800b38:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800b3f:	00 
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	89 04 24             	mov    %eax,(%esp)
  800b46:	e8 1b 02 00 00       	call   800d66 <open>
  800b4b:	89 c3                	mov    %eax,%ebx
  800b4d:	85 db                	test   %ebx,%ebx
  800b4f:	78 1b                	js     800b6c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b58:	89 1c 24             	mov    %ebx,(%esp)
  800b5b:	e8 56 ff ff ff       	call   800ab6 <fstat>
  800b60:	89 c6                	mov    %eax,%esi
	close(fd);
  800b62:	89 1c 24             	mov    %ebx,(%esp)
  800b65:	e8 cd fb ff ff       	call   800737 <close>
	return r;
  800b6a:	89 f0                	mov    %esi,%eax
}
  800b6c:	83 c4 10             	add    $0x10,%esp
  800b6f:	5b                   	pop    %ebx
  800b70:	5e                   	pop    %esi
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    

00800b73 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	56                   	push   %esi
  800b77:	53                   	push   %ebx
  800b78:	83 ec 10             	sub    $0x10,%esp
  800b7b:	89 c6                	mov    %eax,%esi
  800b7d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800b7f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800b86:	75 11                	jne    800b99 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800b88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800b8f:	e8 eb 17 00 00       	call   80237f <ipc_find_env>
  800b94:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800b99:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800ba0:	00 
  800ba1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800ba8:	00 
  800ba9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bad:	a1 00 40 80 00       	mov    0x804000,%eax
  800bb2:	89 04 24             	mov    %eax,(%esp)
  800bb5:	e8 5a 17 00 00       	call   802314 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800bba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800bc1:	00 
  800bc2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800bc6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800bcd:	e8 ee 16 00 00       	call   8022c0 <ipc_recv>
}
  800bd2:	83 c4 10             	add    $0x10,%esp
  800bd5:	5b                   	pop    %ebx
  800bd6:	5e                   	pop    %esi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    

00800bd9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	8b 40 0c             	mov    0xc(%eax),%eax
  800be5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800bea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bed:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800bf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf7:	b8 02 00 00 00       	mov    $0x2,%eax
  800bfc:	e8 72 ff ff ff       	call   800b73 <fsipc>
}
  800c01:	c9                   	leave  
  800c02:	c3                   	ret    

00800c03 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8b 40 0c             	mov    0xc(%eax),%eax
  800c0f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800c14:	ba 00 00 00 00       	mov    $0x0,%edx
  800c19:	b8 06 00 00 00       	mov    $0x6,%eax
  800c1e:	e8 50 ff ff ff       	call   800b73 <fsipc>
}
  800c23:	c9                   	leave  
  800c24:	c3                   	ret    

00800c25 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	53                   	push   %ebx
  800c29:	83 ec 14             	sub    $0x14,%esp
  800c2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	8b 40 0c             	mov    0xc(%eax),%eax
  800c35:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800c3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3f:	b8 05 00 00 00       	mov    $0x5,%eax
  800c44:	e8 2a ff ff ff       	call   800b73 <fsipc>
  800c49:	89 c2                	mov    %eax,%edx
  800c4b:	85 d2                	test   %edx,%edx
  800c4d:	78 2b                	js     800c7a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800c4f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800c56:	00 
  800c57:	89 1c 24             	mov    %ebx,(%esp)
  800c5a:	e8 08 13 00 00       	call   801f67 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800c5f:	a1 80 50 80 00       	mov    0x805080,%eax
  800c64:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800c6a:	a1 84 50 80 00       	mov    0x805084,%eax
  800c6f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800c75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7a:	83 c4 14             	add    $0x14,%esp
  800c7d:	5b                   	pop    %ebx
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    

00800c80 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	83 ec 18             	sub    $0x18,%esp
  800c86:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800c89:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8c:	8b 52 0c             	mov    0xc(%edx),%edx
  800c8f:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800c95:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  800c9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ca5:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  800cac:	e8 bb 14 00 00       	call   80216c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  800cb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb6:	b8 04 00 00 00       	mov    $0x4,%eax
  800cbb:	e8 b3 fe ff ff       	call   800b73 <fsipc>
		return r;
	}

	return r;
}
  800cc0:	c9                   	leave  
  800cc1:	c3                   	ret    

00800cc2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	56                   	push   %esi
  800cc6:	53                   	push   %ebx
  800cc7:	83 ec 10             	sub    $0x10,%esp
  800cca:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8b 40 0c             	mov    0xc(%eax),%eax
  800cd3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800cd8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800cde:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce8:	e8 86 fe ff ff       	call   800b73 <fsipc>
  800ced:	89 c3                	mov    %eax,%ebx
  800cef:	85 c0                	test   %eax,%eax
  800cf1:	78 6a                	js     800d5d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800cf3:	39 c6                	cmp    %eax,%esi
  800cf5:	73 24                	jae    800d1b <devfile_read+0x59>
  800cf7:	c7 44 24 0c 68 27 80 	movl   $0x802768,0xc(%esp)
  800cfe:	00 
  800cff:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  800d06:	00 
  800d07:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  800d0e:	00 
  800d0f:	c7 04 24 84 27 80 00 	movl   $0x802784,(%esp)
  800d16:	e8 2b 0b 00 00       	call   801846 <_panic>
	assert(r <= PGSIZE);
  800d1b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800d20:	7e 24                	jle    800d46 <devfile_read+0x84>
  800d22:	c7 44 24 0c 8f 27 80 	movl   $0x80278f,0xc(%esp)
  800d29:	00 
  800d2a:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  800d31:	00 
  800d32:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  800d39:	00 
  800d3a:	c7 04 24 84 27 80 00 	movl   $0x802784,(%esp)
  800d41:	e8 00 0b 00 00       	call   801846 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800d46:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d4a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800d51:	00 
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	89 04 24             	mov    %eax,(%esp)
  800d58:	e8 a7 13 00 00       	call   802104 <memmove>
	return r;
}
  800d5d:	89 d8                	mov    %ebx,%eax
  800d5f:	83 c4 10             	add    $0x10,%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    

00800d66 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	53                   	push   %ebx
  800d6a:	83 ec 24             	sub    $0x24,%esp
  800d6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800d70:	89 1c 24             	mov    %ebx,(%esp)
  800d73:	e8 b8 11 00 00       	call   801f30 <strlen>
  800d78:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800d7d:	7f 60                	jg     800ddf <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800d7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d82:	89 04 24             	mov    %eax,(%esp)
  800d85:	e8 2d f8 ff ff       	call   8005b7 <fd_alloc>
  800d8a:	89 c2                	mov    %eax,%edx
  800d8c:	85 d2                	test   %edx,%edx
  800d8e:	78 54                	js     800de4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800d90:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d94:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800d9b:	e8 c7 11 00 00       	call   801f67 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800da8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dab:	b8 01 00 00 00       	mov    $0x1,%eax
  800db0:	e8 be fd ff ff       	call   800b73 <fsipc>
  800db5:	89 c3                	mov    %eax,%ebx
  800db7:	85 c0                	test   %eax,%eax
  800db9:	79 17                	jns    800dd2 <open+0x6c>
		fd_close(fd, 0);
  800dbb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800dc2:	00 
  800dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc6:	89 04 24             	mov    %eax,(%esp)
  800dc9:	e8 e8 f8 ff ff       	call   8006b6 <fd_close>
		return r;
  800dce:	89 d8                	mov    %ebx,%eax
  800dd0:	eb 12                	jmp    800de4 <open+0x7e>
	}

	return fd2num(fd);
  800dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dd5:	89 04 24             	mov    %eax,(%esp)
  800dd8:	e8 b3 f7 ff ff       	call   800590 <fd2num>
  800ddd:	eb 05                	jmp    800de4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800ddf:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800de4:	83 c4 24             	add    $0x24,%esp
  800de7:	5b                   	pop    %ebx
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    

00800dea <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800df0:	ba 00 00 00 00       	mov    $0x0,%edx
  800df5:	b8 08 00 00 00       	mov    $0x8,%eax
  800dfa:	e8 74 fd ff ff       	call   800b73 <fsipc>
}
  800dff:	c9                   	leave  
  800e00:	c3                   	ret    
  800e01:	66 90                	xchg   %ax,%ax
  800e03:	66 90                	xchg   %ax,%ax
  800e05:	66 90                	xchg   %ax,%ax
  800e07:	66 90                	xchg   %ax,%ax
  800e09:	66 90                	xchg   %ax,%ax
  800e0b:	66 90                	xchg   %ax,%ax
  800e0d:	66 90                	xchg   %ax,%ax
  800e0f:	90                   	nop

00800e10 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800e16:	c7 44 24 04 9b 27 80 	movl   $0x80279b,0x4(%esp)
  800e1d:	00 
  800e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e21:	89 04 24             	mov    %eax,(%esp)
  800e24:	e8 3e 11 00 00       	call   801f67 <strcpy>
	return 0;
}
  800e29:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2e:	c9                   	leave  
  800e2f:	c3                   	ret    

00800e30 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	53                   	push   %ebx
  800e34:	83 ec 14             	sub    $0x14,%esp
  800e37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800e3a:	89 1c 24             	mov    %ebx,(%esp)
  800e3d:	e8 7c 15 00 00       	call   8023be <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  800e42:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  800e47:	83 f8 01             	cmp    $0x1,%eax
  800e4a:	75 0d                	jne    800e59 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  800e4c:	8b 43 0c             	mov    0xc(%ebx),%eax
  800e4f:	89 04 24             	mov    %eax,(%esp)
  800e52:	e8 29 03 00 00       	call   801180 <nsipc_close>
  800e57:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  800e59:	89 d0                	mov    %edx,%eax
  800e5b:	83 c4 14             	add    $0x14,%esp
  800e5e:	5b                   	pop    %ebx
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    

00800e61 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800e67:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800e6e:	00 
  800e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e72:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e79:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8b 40 0c             	mov    0xc(%eax),%eax
  800e83:	89 04 24             	mov    %eax,(%esp)
  800e86:	e8 f0 03 00 00       	call   80127b <nsipc_send>
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800e93:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800e9a:	00 
  800e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8b 40 0c             	mov    0xc(%eax),%eax
  800eaf:	89 04 24             	mov    %eax,(%esp)
  800eb2:	e8 44 03 00 00       	call   8011fb <nsipc_recv>
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800ebf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800ec2:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ec6:	89 04 24             	mov    %eax,(%esp)
  800ec9:	e8 38 f7 ff ff       	call   800606 <fd_lookup>
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	78 17                	js     800ee9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800edb:	39 08                	cmp    %ecx,(%eax)
  800edd:	75 05                	jne    800ee4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800edf:	8b 40 0c             	mov    0xc(%eax),%eax
  800ee2:	eb 05                	jmp    800ee9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  800ee4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  800ee9:	c9                   	leave  
  800eea:	c3                   	ret    

00800eeb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	56                   	push   %esi
  800eef:	53                   	push   %ebx
  800ef0:	83 ec 20             	sub    $0x20,%esp
  800ef3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800ef5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ef8:	89 04 24             	mov    %eax,(%esp)
  800efb:	e8 b7 f6 ff ff       	call   8005b7 <fd_alloc>
  800f00:	89 c3                	mov    %eax,%ebx
  800f02:	85 c0                	test   %eax,%eax
  800f04:	78 21                	js     800f27 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800f06:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f0d:	00 
  800f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f11:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f1c:	e8 4a f2 ff ff       	call   80016b <sys_page_alloc>
  800f21:	89 c3                	mov    %eax,%ebx
  800f23:	85 c0                	test   %eax,%eax
  800f25:	79 0c                	jns    800f33 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  800f27:	89 34 24             	mov    %esi,(%esp)
  800f2a:	e8 51 02 00 00       	call   801180 <nsipc_close>
		return r;
  800f2f:	89 d8                	mov    %ebx,%eax
  800f31:	eb 20                	jmp    800f53 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800f33:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f3c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f41:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  800f48:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  800f4b:	89 14 24             	mov    %edx,(%esp)
  800f4e:	e8 3d f6 ff ff       	call   800590 <fd2num>
}
  800f53:	83 c4 20             	add    $0x20,%esp
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    

00800f5a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	e8 51 ff ff ff       	call   800eb9 <fd2sockid>
		return r;
  800f68:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f6a:	85 c0                	test   %eax,%eax
  800f6c:	78 23                	js     800f91 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f6e:	8b 55 10             	mov    0x10(%ebp),%edx
  800f71:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f78:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f7c:	89 04 24             	mov    %eax,(%esp)
  800f7f:	e8 45 01 00 00       	call   8010c9 <nsipc_accept>
		return r;
  800f84:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f86:	85 c0                	test   %eax,%eax
  800f88:	78 07                	js     800f91 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  800f8a:	e8 5c ff ff ff       	call   800eeb <alloc_sockfd>
  800f8f:	89 c1                	mov    %eax,%ecx
}
  800f91:	89 c8                	mov    %ecx,%eax
  800f93:	c9                   	leave  
  800f94:	c3                   	ret    

00800f95 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	e8 16 ff ff ff       	call   800eb9 <fd2sockid>
  800fa3:	89 c2                	mov    %eax,%edx
  800fa5:	85 d2                	test   %edx,%edx
  800fa7:	78 16                	js     800fbf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  800fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fac:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fb7:	89 14 24             	mov    %edx,(%esp)
  800fba:	e8 60 01 00 00       	call   80111f <nsipc_bind>
}
  800fbf:	c9                   	leave  
  800fc0:	c3                   	ret    

00800fc1 <shutdown>:

int
shutdown(int s, int how)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	e8 ea fe ff ff       	call   800eb9 <fd2sockid>
  800fcf:	89 c2                	mov    %eax,%edx
  800fd1:	85 d2                	test   %edx,%edx
  800fd3:	78 0f                	js     800fe4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  800fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fdc:	89 14 24             	mov    %edx,(%esp)
  800fdf:	e8 7a 01 00 00       	call   80115e <nsipc_shutdown>
}
  800fe4:	c9                   	leave  
  800fe5:	c3                   	ret    

00800fe6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	e8 c5 fe ff ff       	call   800eb9 <fd2sockid>
  800ff4:	89 c2                	mov    %eax,%edx
  800ff6:	85 d2                	test   %edx,%edx
  800ff8:	78 16                	js     801010 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	89 44 24 04          	mov    %eax,0x4(%esp)
  801008:	89 14 24             	mov    %edx,(%esp)
  80100b:	e8 8a 01 00 00       	call   80119a <nsipc_connect>
}
  801010:	c9                   	leave  
  801011:	c3                   	ret    

00801012 <listen>:

int
listen(int s, int backlog)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	e8 99 fe ff ff       	call   800eb9 <fd2sockid>
  801020:	89 c2                	mov    %eax,%edx
  801022:	85 d2                	test   %edx,%edx
  801024:	78 0f                	js     801035 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	89 44 24 04          	mov    %eax,0x4(%esp)
  80102d:	89 14 24             	mov    %edx,(%esp)
  801030:	e8 a4 01 00 00       	call   8011d9 <nsipc_listen>
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80103d:	8b 45 10             	mov    0x10(%ebp),%eax
  801040:	89 44 24 08          	mov    %eax,0x8(%esp)
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	89 44 24 04          	mov    %eax,0x4(%esp)
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	89 04 24             	mov    %eax,(%esp)
  801051:	e8 98 02 00 00       	call   8012ee <nsipc_socket>
  801056:	89 c2                	mov    %eax,%edx
  801058:	85 d2                	test   %edx,%edx
  80105a:	78 05                	js     801061 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80105c:	e8 8a fe ff ff       	call   800eeb <alloc_sockfd>
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	53                   	push   %ebx
  801067:	83 ec 14             	sub    $0x14,%esp
  80106a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80106c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801073:	75 11                	jne    801086 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801075:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80107c:	e8 fe 12 00 00       	call   80237f <ipc_find_env>
  801081:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801086:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80108d:	00 
  80108e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801095:	00 
  801096:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80109a:	a1 04 40 80 00       	mov    0x804004,%eax
  80109f:	89 04 24             	mov    %eax,(%esp)
  8010a2:	e8 6d 12 00 00       	call   802314 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8010a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010ae:	00 
  8010af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8010b6:	00 
  8010b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010be:	e8 fd 11 00 00       	call   8022c0 <ipc_recv>
}
  8010c3:	83 c4 14             	add    $0x14,%esp
  8010c6:	5b                   	pop    %ebx
  8010c7:	5d                   	pop    %ebp
  8010c8:	c3                   	ret    

008010c9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	56                   	push   %esi
  8010cd:	53                   	push   %ebx
  8010ce:	83 ec 10             	sub    $0x10,%esp
  8010d1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8010dc:	8b 06                	mov    (%esi),%eax
  8010de:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8010e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8010e8:	e8 76 ff ff ff       	call   801063 <nsipc>
  8010ed:	89 c3                	mov    %eax,%ebx
  8010ef:	85 c0                	test   %eax,%eax
  8010f1:	78 23                	js     801116 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8010f3:	a1 10 60 80 00       	mov    0x806010,%eax
  8010f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010fc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801103:	00 
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	89 04 24             	mov    %eax,(%esp)
  80110a:	e8 f5 0f 00 00       	call   802104 <memmove>
		*addrlen = ret->ret_addrlen;
  80110f:	a1 10 60 80 00       	mov    0x806010,%eax
  801114:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801116:	89 d8                	mov    %ebx,%eax
  801118:	83 c4 10             	add    $0x10,%esp
  80111b:	5b                   	pop    %ebx
  80111c:	5e                   	pop    %esi
  80111d:	5d                   	pop    %ebp
  80111e:	c3                   	ret    

0080111f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	53                   	push   %ebx
  801123:	83 ec 14             	sub    $0x14,%esp
  801126:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801131:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801135:	8b 45 0c             	mov    0xc(%ebp),%eax
  801138:	89 44 24 04          	mov    %eax,0x4(%esp)
  80113c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801143:	e8 bc 0f 00 00       	call   802104 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801148:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80114e:	b8 02 00 00 00       	mov    $0x2,%eax
  801153:	e8 0b ff ff ff       	call   801063 <nsipc>
}
  801158:	83 c4 14             	add    $0x14,%esp
  80115b:	5b                   	pop    %ebx
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    

0080115e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801174:	b8 03 00 00 00       	mov    $0x3,%eax
  801179:	e8 e5 fe ff ff       	call   801063 <nsipc>
}
  80117e:	c9                   	leave  
  80117f:	c3                   	ret    

00801180 <nsipc_close>:

int
nsipc_close(int s)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80118e:	b8 04 00 00 00       	mov    $0x4,%eax
  801193:	e8 cb fe ff ff       	call   801063 <nsipc>
}
  801198:	c9                   	leave  
  801199:	c3                   	ret    

0080119a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	53                   	push   %ebx
  80119e:	83 ec 14             	sub    $0x14,%esp
  8011a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8011ac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8011b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011b7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8011be:	e8 41 0f 00 00       	call   802104 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8011c3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8011c9:	b8 05 00 00 00       	mov    $0x5,%eax
  8011ce:	e8 90 fe ff ff       	call   801063 <nsipc>
}
  8011d3:	83 c4 14             	add    $0x14,%esp
  8011d6:	5b                   	pop    %ebx
  8011d7:	5d                   	pop    %ebp
  8011d8:	c3                   	ret    

008011d9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8011e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ea:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8011ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8011f4:	e8 6a fe ff ff       	call   801063 <nsipc>
}
  8011f9:	c9                   	leave  
  8011fa:	c3                   	ret    

008011fb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	56                   	push   %esi
  8011ff:	53                   	push   %ebx
  801200:	83 ec 10             	sub    $0x10,%esp
  801203:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80120e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801214:	8b 45 14             	mov    0x14(%ebp),%eax
  801217:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80121c:	b8 07 00 00 00       	mov    $0x7,%eax
  801221:	e8 3d fe ff ff       	call   801063 <nsipc>
  801226:	89 c3                	mov    %eax,%ebx
  801228:	85 c0                	test   %eax,%eax
  80122a:	78 46                	js     801272 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80122c:	39 f0                	cmp    %esi,%eax
  80122e:	7f 07                	jg     801237 <nsipc_recv+0x3c>
  801230:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801235:	7e 24                	jle    80125b <nsipc_recv+0x60>
  801237:	c7 44 24 0c a7 27 80 	movl   $0x8027a7,0xc(%esp)
  80123e:	00 
  80123f:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  801246:	00 
  801247:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80124e:	00 
  80124f:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  801256:	e8 eb 05 00 00       	call   801846 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80125b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80125f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801266:	00 
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	89 04 24             	mov    %eax,(%esp)
  80126d:	e8 92 0e 00 00       	call   802104 <memmove>
	}

	return r;
}
  801272:	89 d8                	mov    %ebx,%eax
  801274:	83 c4 10             	add    $0x10,%esp
  801277:	5b                   	pop    %ebx
  801278:	5e                   	pop    %esi
  801279:	5d                   	pop    %ebp
  80127a:	c3                   	ret    

0080127b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	53                   	push   %ebx
  80127f:	83 ec 14             	sub    $0x14,%esp
  801282:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80128d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801293:	7e 24                	jle    8012b9 <nsipc_send+0x3e>
  801295:	c7 44 24 0c c8 27 80 	movl   $0x8027c8,0xc(%esp)
  80129c:	00 
  80129d:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  8012a4:	00 
  8012a5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8012ac:	00 
  8012ad:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  8012b4:	e8 8d 05 00 00       	call   801846 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8012cb:	e8 34 0e 00 00       	call   802104 <memmove>
	nsipcbuf.send.req_size = size;
  8012d0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8012d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8012de:	b8 08 00 00 00       	mov    $0x8,%eax
  8012e3:	e8 7b fd ff ff       	call   801063 <nsipc>
}
  8012e8:	83 c4 14             	add    $0x14,%esp
  8012eb:	5b                   	pop    %ebx
  8012ec:	5d                   	pop    %ebp
  8012ed:	c3                   	ret    

008012ee <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8012fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ff:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801304:	8b 45 10             	mov    0x10(%ebp),%eax
  801307:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80130c:	b8 09 00 00 00       	mov    $0x9,%eax
  801311:	e8 4d fd ff ff       	call   801063 <nsipc>
}
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	56                   	push   %esi
  80131c:	53                   	push   %ebx
  80131d:	83 ec 10             	sub    $0x10,%esp
  801320:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	89 04 24             	mov    %eax,(%esp)
  801329:	e8 72 f2 ff ff       	call   8005a0 <fd2data>
  80132e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801330:	c7 44 24 04 d4 27 80 	movl   $0x8027d4,0x4(%esp)
  801337:	00 
  801338:	89 1c 24             	mov    %ebx,(%esp)
  80133b:	e8 27 0c 00 00       	call   801f67 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801340:	8b 46 04             	mov    0x4(%esi),%eax
  801343:	2b 06                	sub    (%esi),%eax
  801345:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80134b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801352:	00 00 00 
	stat->st_dev = &devpipe;
  801355:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80135c:	30 80 00 
	return 0;
}
  80135f:	b8 00 00 00 00       	mov    $0x0,%eax
  801364:	83 c4 10             	add    $0x10,%esp
  801367:	5b                   	pop    %ebx
  801368:	5e                   	pop    %esi
  801369:	5d                   	pop    %ebp
  80136a:	c3                   	ret    

0080136b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	53                   	push   %ebx
  80136f:	83 ec 14             	sub    $0x14,%esp
  801372:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801375:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801379:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801380:	e8 8d ee ff ff       	call   800212 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801385:	89 1c 24             	mov    %ebx,(%esp)
  801388:	e8 13 f2 ff ff       	call   8005a0 <fd2data>
  80138d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801391:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801398:	e8 75 ee ff ff       	call   800212 <sys_page_unmap>
}
  80139d:	83 c4 14             	add    $0x14,%esp
  8013a0:	5b                   	pop    %ebx
  8013a1:	5d                   	pop    %ebp
  8013a2:	c3                   	ret    

008013a3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
  8013a6:	57                   	push   %edi
  8013a7:	56                   	push   %esi
  8013a8:	53                   	push   %ebx
  8013a9:	83 ec 2c             	sub    $0x2c,%esp
  8013ac:	89 c6                	mov    %eax,%esi
  8013ae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8013b1:	a1 08 40 80 00       	mov    0x804008,%eax
  8013b6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8013b9:	89 34 24             	mov    %esi,(%esp)
  8013bc:	e8 fd 0f 00 00       	call   8023be <pageref>
  8013c1:	89 c7                	mov    %eax,%edi
  8013c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c6:	89 04 24             	mov    %eax,(%esp)
  8013c9:	e8 f0 0f 00 00       	call   8023be <pageref>
  8013ce:	39 c7                	cmp    %eax,%edi
  8013d0:	0f 94 c2             	sete   %dl
  8013d3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8013d6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  8013dc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8013df:	39 fb                	cmp    %edi,%ebx
  8013e1:	74 21                	je     801404 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8013e3:	84 d2                	test   %dl,%dl
  8013e5:	74 ca                	je     8013b1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8013e7:	8b 51 58             	mov    0x58(%ecx),%edx
  8013ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ee:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013f6:	c7 04 24 db 27 80 00 	movl   $0x8027db,(%esp)
  8013fd:	e8 3d 05 00 00       	call   80193f <cprintf>
  801402:	eb ad                	jmp    8013b1 <_pipeisclosed+0xe>
	}
}
  801404:	83 c4 2c             	add    $0x2c,%esp
  801407:	5b                   	pop    %ebx
  801408:	5e                   	pop    %esi
  801409:	5f                   	pop    %edi
  80140a:	5d                   	pop    %ebp
  80140b:	c3                   	ret    

0080140c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	57                   	push   %edi
  801410:	56                   	push   %esi
  801411:	53                   	push   %ebx
  801412:	83 ec 1c             	sub    $0x1c,%esp
  801415:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801418:	89 34 24             	mov    %esi,(%esp)
  80141b:	e8 80 f1 ff ff       	call   8005a0 <fd2data>
  801420:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801422:	bf 00 00 00 00       	mov    $0x0,%edi
  801427:	eb 45                	jmp    80146e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801429:	89 da                	mov    %ebx,%edx
  80142b:	89 f0                	mov    %esi,%eax
  80142d:	e8 71 ff ff ff       	call   8013a3 <_pipeisclosed>
  801432:	85 c0                	test   %eax,%eax
  801434:	75 41                	jne    801477 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801436:	e8 11 ed ff ff       	call   80014c <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80143b:	8b 43 04             	mov    0x4(%ebx),%eax
  80143e:	8b 0b                	mov    (%ebx),%ecx
  801440:	8d 51 20             	lea    0x20(%ecx),%edx
  801443:	39 d0                	cmp    %edx,%eax
  801445:	73 e2                	jae    801429 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801447:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80144a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80144e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801451:	99                   	cltd   
  801452:	c1 ea 1b             	shr    $0x1b,%edx
  801455:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801458:	83 e1 1f             	and    $0x1f,%ecx
  80145b:	29 d1                	sub    %edx,%ecx
  80145d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801461:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801465:	83 c0 01             	add    $0x1,%eax
  801468:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80146b:	83 c7 01             	add    $0x1,%edi
  80146e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801471:	75 c8                	jne    80143b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801473:	89 f8                	mov    %edi,%eax
  801475:	eb 05                	jmp    80147c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80147c:	83 c4 1c             	add    $0x1c,%esp
  80147f:	5b                   	pop    %ebx
  801480:	5e                   	pop    %esi
  801481:	5f                   	pop    %edi
  801482:	5d                   	pop    %ebp
  801483:	c3                   	ret    

00801484 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	57                   	push   %edi
  801488:	56                   	push   %esi
  801489:	53                   	push   %ebx
  80148a:	83 ec 1c             	sub    $0x1c,%esp
  80148d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801490:	89 3c 24             	mov    %edi,(%esp)
  801493:	e8 08 f1 ff ff       	call   8005a0 <fd2data>
  801498:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80149a:	be 00 00 00 00       	mov    $0x0,%esi
  80149f:	eb 3d                	jmp    8014de <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8014a1:	85 f6                	test   %esi,%esi
  8014a3:	74 04                	je     8014a9 <devpipe_read+0x25>
				return i;
  8014a5:	89 f0                	mov    %esi,%eax
  8014a7:	eb 43                	jmp    8014ec <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8014a9:	89 da                	mov    %ebx,%edx
  8014ab:	89 f8                	mov    %edi,%eax
  8014ad:	e8 f1 fe ff ff       	call   8013a3 <_pipeisclosed>
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	75 31                	jne    8014e7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8014b6:	e8 91 ec ff ff       	call   80014c <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8014bb:	8b 03                	mov    (%ebx),%eax
  8014bd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8014c0:	74 df                	je     8014a1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8014c2:	99                   	cltd   
  8014c3:	c1 ea 1b             	shr    $0x1b,%edx
  8014c6:	01 d0                	add    %edx,%eax
  8014c8:	83 e0 1f             	and    $0x1f,%eax
  8014cb:	29 d0                	sub    %edx,%eax
  8014cd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8014d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8014d8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014db:	83 c6 01             	add    $0x1,%esi
  8014de:	3b 75 10             	cmp    0x10(%ebp),%esi
  8014e1:	75 d8                	jne    8014bb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8014e3:	89 f0                	mov    %esi,%eax
  8014e5:	eb 05                	jmp    8014ec <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8014e7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8014ec:	83 c4 1c             	add    $0x1c,%esp
  8014ef:	5b                   	pop    %ebx
  8014f0:	5e                   	pop    %esi
  8014f1:	5f                   	pop    %edi
  8014f2:	5d                   	pop    %ebp
  8014f3:	c3                   	ret    

008014f4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	56                   	push   %esi
  8014f8:	53                   	push   %ebx
  8014f9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8014fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ff:	89 04 24             	mov    %eax,(%esp)
  801502:	e8 b0 f0 ff ff       	call   8005b7 <fd_alloc>
  801507:	89 c2                	mov    %eax,%edx
  801509:	85 d2                	test   %edx,%edx
  80150b:	0f 88 4d 01 00 00    	js     80165e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801511:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801518:	00 
  801519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801520:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801527:	e8 3f ec ff ff       	call   80016b <sys_page_alloc>
  80152c:	89 c2                	mov    %eax,%edx
  80152e:	85 d2                	test   %edx,%edx
  801530:	0f 88 28 01 00 00    	js     80165e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801536:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801539:	89 04 24             	mov    %eax,(%esp)
  80153c:	e8 76 f0 ff ff       	call   8005b7 <fd_alloc>
  801541:	89 c3                	mov    %eax,%ebx
  801543:	85 c0                	test   %eax,%eax
  801545:	0f 88 fe 00 00 00    	js     801649 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80154b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801552:	00 
  801553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801556:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801561:	e8 05 ec ff ff       	call   80016b <sys_page_alloc>
  801566:	89 c3                	mov    %eax,%ebx
  801568:	85 c0                	test   %eax,%eax
  80156a:	0f 88 d9 00 00 00    	js     801649 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801573:	89 04 24             	mov    %eax,(%esp)
  801576:	e8 25 f0 ff ff       	call   8005a0 <fd2data>
  80157b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80157d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801584:	00 
  801585:	89 44 24 04          	mov    %eax,0x4(%esp)
  801589:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801590:	e8 d6 eb ff ff       	call   80016b <sys_page_alloc>
  801595:	89 c3                	mov    %eax,%ebx
  801597:	85 c0                	test   %eax,%eax
  801599:	0f 88 97 00 00 00    	js     801636 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80159f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a2:	89 04 24             	mov    %eax,(%esp)
  8015a5:	e8 f6 ef ff ff       	call   8005a0 <fd2data>
  8015aa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8015b1:	00 
  8015b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015bd:	00 
  8015be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015c9:	e8 f1 eb ff ff       	call   8001bf <sys_page_map>
  8015ce:	89 c3                	mov    %eax,%ebx
  8015d0:	85 c0                	test   %eax,%eax
  8015d2:	78 52                	js     801626 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8015d4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8015da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015dd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8015df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8015e9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8015ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8015f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8015fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801601:	89 04 24             	mov    %eax,(%esp)
  801604:	e8 87 ef ff ff       	call   800590 <fd2num>
  801609:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80160c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80160e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801611:	89 04 24             	mov    %eax,(%esp)
  801614:	e8 77 ef ff ff       	call   800590 <fd2num>
  801619:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80161c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80161f:	b8 00 00 00 00       	mov    $0x0,%eax
  801624:	eb 38                	jmp    80165e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801626:	89 74 24 04          	mov    %esi,0x4(%esp)
  80162a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801631:	e8 dc eb ff ff       	call   800212 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801639:	89 44 24 04          	mov    %eax,0x4(%esp)
  80163d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801644:	e8 c9 eb ff ff       	call   800212 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801650:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801657:	e8 b6 eb ff ff       	call   800212 <sys_page_unmap>
  80165c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80165e:	83 c4 30             	add    $0x30,%esp
  801661:	5b                   	pop    %ebx
  801662:	5e                   	pop    %esi
  801663:	5d                   	pop    %ebp
  801664:	c3                   	ret    

00801665 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80166b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	89 04 24             	mov    %eax,(%esp)
  801678:	e8 89 ef ff ff       	call   800606 <fd_lookup>
  80167d:	89 c2                	mov    %eax,%edx
  80167f:	85 d2                	test   %edx,%edx
  801681:	78 15                	js     801698 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801686:	89 04 24             	mov    %eax,(%esp)
  801689:	e8 12 ef ff ff       	call   8005a0 <fd2data>
	return _pipeisclosed(fd, p);
  80168e:	89 c2                	mov    %eax,%edx
  801690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801693:	e8 0b fd ff ff       	call   8013a3 <_pipeisclosed>
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    
  80169a:	66 90                	xchg   %ax,%ax
  80169c:	66 90                	xchg   %ax,%ax
  80169e:	66 90                	xchg   %ax,%ax

008016a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8016a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a8:	5d                   	pop    %ebp
  8016a9:	c3                   	ret    

008016aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8016b0:	c7 44 24 04 f3 27 80 	movl   $0x8027f3,0x4(%esp)
  8016b7:	00 
  8016b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016bb:	89 04 24             	mov    %eax,(%esp)
  8016be:	e8 a4 08 00 00       	call   801f67 <strcpy>
	return 0;
}
  8016c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	57                   	push   %edi
  8016ce:	56                   	push   %esi
  8016cf:	53                   	push   %ebx
  8016d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8016db:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016e1:	eb 31                	jmp    801714 <devcons_write+0x4a>
		m = n - tot;
  8016e3:	8b 75 10             	mov    0x10(%ebp),%esi
  8016e6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8016e8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8016eb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8016f0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8016f3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8016f7:	03 45 0c             	add    0xc(%ebp),%eax
  8016fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016fe:	89 3c 24             	mov    %edi,(%esp)
  801701:	e8 fe 09 00 00       	call   802104 <memmove>
		sys_cputs(buf, m);
  801706:	89 74 24 04          	mov    %esi,0x4(%esp)
  80170a:	89 3c 24             	mov    %edi,(%esp)
  80170d:	e8 8c e9 ff ff       	call   80009e <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801712:	01 f3                	add    %esi,%ebx
  801714:	89 d8                	mov    %ebx,%eax
  801716:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801719:	72 c8                	jb     8016e3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80171b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801721:	5b                   	pop    %ebx
  801722:	5e                   	pop    %esi
  801723:	5f                   	pop    %edi
  801724:	5d                   	pop    %ebp
  801725:	c3                   	ret    

00801726 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80172c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801731:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801735:	75 07                	jne    80173e <devcons_read+0x18>
  801737:	eb 2a                	jmp    801763 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801739:	e8 0e ea ff ff       	call   80014c <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80173e:	66 90                	xchg   %ax,%ax
  801740:	e8 77 e9 ff ff       	call   8000bc <sys_cgetc>
  801745:	85 c0                	test   %eax,%eax
  801747:	74 f0                	je     801739 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801749:	85 c0                	test   %eax,%eax
  80174b:	78 16                	js     801763 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80174d:	83 f8 04             	cmp    $0x4,%eax
  801750:	74 0c                	je     80175e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  801752:	8b 55 0c             	mov    0xc(%ebp),%edx
  801755:	88 02                	mov    %al,(%edx)
	return 1;
  801757:	b8 01 00 00 00       	mov    $0x1,%eax
  80175c:	eb 05                	jmp    801763 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801771:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801778:	00 
  801779:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80177c:	89 04 24             	mov    %eax,(%esp)
  80177f:	e8 1a e9 ff ff       	call   80009e <sys_cputs>
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <getchar>:

int
getchar(void)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80178c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801793:	00 
  801794:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801797:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a2:	e8 f3 f0 ff ff       	call   80089a <read>
	if (r < 0)
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	78 0f                	js     8017ba <getchar+0x34>
		return r;
	if (r < 1)
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	7e 06                	jle    8017b5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8017af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8017b3:	eb 05                	jmp    8017ba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8017b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	89 04 24             	mov    %eax,(%esp)
  8017cf:	e8 32 ee ff ff       	call   800606 <fd_lookup>
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	78 11                	js     8017e9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8017d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017db:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8017e1:	39 10                	cmp    %edx,(%eax)
  8017e3:	0f 94 c0             	sete   %al
  8017e6:	0f b6 c0             	movzbl %al,%eax
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <opencons>:

int
opencons(void)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8017f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f4:	89 04 24             	mov    %eax,(%esp)
  8017f7:	e8 bb ed ff ff       	call   8005b7 <fd_alloc>
		return r;
  8017fc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8017fe:	85 c0                	test   %eax,%eax
  801800:	78 40                	js     801842 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801802:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801809:	00 
  80180a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801811:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801818:	e8 4e e9 ff ff       	call   80016b <sys_page_alloc>
		return r;
  80181d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80181f:	85 c0                	test   %eax,%eax
  801821:	78 1f                	js     801842 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801823:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80182e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801831:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801838:	89 04 24             	mov    %eax,(%esp)
  80183b:	e8 50 ed ff ff       	call   800590 <fd2num>
  801840:	89 c2                	mov    %eax,%edx
}
  801842:	89 d0                	mov    %edx,%eax
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	56                   	push   %esi
  80184a:	53                   	push   %ebx
  80184b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80184e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801851:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801857:	e8 d1 e8 ff ff       	call   80012d <sys_getenvid>
  80185c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801863:	8b 55 08             	mov    0x8(%ebp),%edx
  801866:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80186a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80186e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801872:	c7 04 24 00 28 80 00 	movl   $0x802800,(%esp)
  801879:	e8 c1 00 00 00       	call   80193f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80187e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801882:	8b 45 10             	mov    0x10(%ebp),%eax
  801885:	89 04 24             	mov    %eax,(%esp)
  801888:	e8 51 00 00 00       	call   8018de <vcprintf>
	cprintf("\n");
  80188d:	c7 04 24 ec 27 80 00 	movl   $0x8027ec,(%esp)
  801894:	e8 a6 00 00 00       	call   80193f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801899:	cc                   	int3   
  80189a:	eb fd                	jmp    801899 <_panic+0x53>

0080189c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	53                   	push   %ebx
  8018a0:	83 ec 14             	sub    $0x14,%esp
  8018a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8018a6:	8b 13                	mov    (%ebx),%edx
  8018a8:	8d 42 01             	lea    0x1(%edx),%eax
  8018ab:	89 03                	mov    %eax,(%ebx)
  8018ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8018b4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8018b9:	75 19                	jne    8018d4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8018bb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8018c2:	00 
  8018c3:	8d 43 08             	lea    0x8(%ebx),%eax
  8018c6:	89 04 24             	mov    %eax,(%esp)
  8018c9:	e8 d0 e7 ff ff       	call   80009e <sys_cputs>
		b->idx = 0;
  8018ce:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8018d4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8018d8:	83 c4 14             	add    $0x14,%esp
  8018db:	5b                   	pop    %ebx
  8018dc:	5d                   	pop    %ebp
  8018dd:	c3                   	ret    

008018de <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8018e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018ee:	00 00 00 
	b.cnt = 0;
  8018f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8018f8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8018fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	89 44 24 08          	mov    %eax,0x8(%esp)
  801909:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80190f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801913:	c7 04 24 9c 18 80 00 	movl   $0x80189c,(%esp)
  80191a:	e8 af 01 00 00       	call   801ace <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80191f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801925:	89 44 24 04          	mov    %eax,0x4(%esp)
  801929:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80192f:	89 04 24             	mov    %eax,(%esp)
  801932:	e8 67 e7 ff ff       	call   80009e <sys_cputs>

	return b.cnt;
}
  801937:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801945:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801948:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	89 04 24             	mov    %eax,(%esp)
  801952:	e8 87 ff ff ff       	call   8018de <vcprintf>
	va_end(ap);

	return cnt;
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    
  801959:	66 90                	xchg   %ax,%ax
  80195b:	66 90                	xchg   %ax,%ax
  80195d:	66 90                	xchg   %ax,%ax
  80195f:	90                   	nop

00801960 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	57                   	push   %edi
  801964:	56                   	push   %esi
  801965:	53                   	push   %ebx
  801966:	83 ec 3c             	sub    $0x3c,%esp
  801969:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80196c:	89 d7                	mov    %edx,%edi
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801974:	8b 45 0c             	mov    0xc(%ebp),%eax
  801977:	89 c3                	mov    %eax,%ebx
  801979:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80197c:	8b 45 10             	mov    0x10(%ebp),%eax
  80197f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801982:	b9 00 00 00 00       	mov    $0x0,%ecx
  801987:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80198a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80198d:	39 d9                	cmp    %ebx,%ecx
  80198f:	72 05                	jb     801996 <printnum+0x36>
  801991:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801994:	77 69                	ja     8019ff <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801996:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801999:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80199d:	83 ee 01             	sub    $0x1,%esi
  8019a0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019ac:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8019b0:	89 c3                	mov    %eax,%ebx
  8019b2:	89 d6                	mov    %edx,%esi
  8019b4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8019ba:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019be:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019c5:	89 04 24             	mov    %eax,(%esp)
  8019c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019cf:	e8 2c 0a 00 00       	call   802400 <__udivdi3>
  8019d4:	89 d9                	mov    %ebx,%ecx
  8019d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019da:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019de:	89 04 24             	mov    %eax,(%esp)
  8019e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019e5:	89 fa                	mov    %edi,%edx
  8019e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019ea:	e8 71 ff ff ff       	call   801960 <printnum>
  8019ef:	eb 1b                	jmp    801a0c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8019f1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8019f8:	89 04 24             	mov    %eax,(%esp)
  8019fb:	ff d3                	call   *%ebx
  8019fd:	eb 03                	jmp    801a02 <printnum+0xa2>
  8019ff:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801a02:	83 ee 01             	sub    $0x1,%esi
  801a05:	85 f6                	test   %esi,%esi
  801a07:	7f e8                	jg     8019f1 <printnum+0x91>
  801a09:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801a0c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a10:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801a14:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a17:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801a1a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a1e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a25:	89 04 24             	mov    %eax,(%esp)
  801a28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2f:	e8 fc 0a 00 00       	call   802530 <__umoddi3>
  801a34:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a38:	0f be 80 23 28 80 00 	movsbl 0x802823(%eax),%eax
  801a3f:	89 04 24             	mov    %eax,(%esp)
  801a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a45:	ff d0                	call   *%eax
}
  801a47:	83 c4 3c             	add    $0x3c,%esp
  801a4a:	5b                   	pop    %ebx
  801a4b:	5e                   	pop    %esi
  801a4c:	5f                   	pop    %edi
  801a4d:	5d                   	pop    %ebp
  801a4e:	c3                   	ret    

00801a4f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a52:	83 fa 01             	cmp    $0x1,%edx
  801a55:	7e 0e                	jle    801a65 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801a57:	8b 10                	mov    (%eax),%edx
  801a59:	8d 4a 08             	lea    0x8(%edx),%ecx
  801a5c:	89 08                	mov    %ecx,(%eax)
  801a5e:	8b 02                	mov    (%edx),%eax
  801a60:	8b 52 04             	mov    0x4(%edx),%edx
  801a63:	eb 22                	jmp    801a87 <getuint+0x38>
	else if (lflag)
  801a65:	85 d2                	test   %edx,%edx
  801a67:	74 10                	je     801a79 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801a69:	8b 10                	mov    (%eax),%edx
  801a6b:	8d 4a 04             	lea    0x4(%edx),%ecx
  801a6e:	89 08                	mov    %ecx,(%eax)
  801a70:	8b 02                	mov    (%edx),%eax
  801a72:	ba 00 00 00 00       	mov    $0x0,%edx
  801a77:	eb 0e                	jmp    801a87 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801a79:	8b 10                	mov    (%eax),%edx
  801a7b:	8d 4a 04             	lea    0x4(%edx),%ecx
  801a7e:	89 08                	mov    %ecx,(%eax)
  801a80:	8b 02                	mov    (%edx),%eax
  801a82:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a87:	5d                   	pop    %ebp
  801a88:	c3                   	ret    

00801a89 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801a8f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801a93:	8b 10                	mov    (%eax),%edx
  801a95:	3b 50 04             	cmp    0x4(%eax),%edx
  801a98:	73 0a                	jae    801aa4 <sprintputch+0x1b>
		*b->buf++ = ch;
  801a9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a9d:	89 08                	mov    %ecx,(%eax)
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	88 02                	mov    %al,(%edx)
}
  801aa4:	5d                   	pop    %ebp
  801aa5:	c3                   	ret    

00801aa6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801aac:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801aaf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ab3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	89 04 24             	mov    %eax,(%esp)
  801ac7:	e8 02 00 00 00       	call   801ace <vprintfmt>
	va_end(ap);
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	57                   	push   %edi
  801ad2:	56                   	push   %esi
  801ad3:	53                   	push   %ebx
  801ad4:	83 ec 3c             	sub    $0x3c,%esp
  801ad7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ada:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801add:	eb 14                	jmp    801af3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801adf:	85 c0                	test   %eax,%eax
  801ae1:	0f 84 b3 03 00 00    	je     801e9a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  801ae7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801aeb:	89 04 24             	mov    %eax,(%esp)
  801aee:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801af1:	89 f3                	mov    %esi,%ebx
  801af3:	8d 73 01             	lea    0x1(%ebx),%esi
  801af6:	0f b6 03             	movzbl (%ebx),%eax
  801af9:	83 f8 25             	cmp    $0x25,%eax
  801afc:	75 e1                	jne    801adf <vprintfmt+0x11>
  801afe:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  801b02:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b09:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  801b10:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  801b17:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1c:	eb 1d                	jmp    801b3b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b1e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  801b20:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801b24:	eb 15                	jmp    801b3b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b26:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b28:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801b2c:	eb 0d                	jmp    801b3b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801b2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b31:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b34:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b3b:	8d 5e 01             	lea    0x1(%esi),%ebx
  801b3e:	0f b6 0e             	movzbl (%esi),%ecx
  801b41:	0f b6 c1             	movzbl %cl,%eax
  801b44:	83 e9 23             	sub    $0x23,%ecx
  801b47:	80 f9 55             	cmp    $0x55,%cl
  801b4a:	0f 87 2a 03 00 00    	ja     801e7a <vprintfmt+0x3ac>
  801b50:	0f b6 c9             	movzbl %cl,%ecx
  801b53:	ff 24 8d a0 29 80 00 	jmp    *0x8029a0(,%ecx,4)
  801b5a:	89 de                	mov    %ebx,%esi
  801b5c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801b61:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801b64:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801b68:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801b6b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  801b6e:	83 fb 09             	cmp    $0x9,%ebx
  801b71:	77 36                	ja     801ba9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b73:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b76:	eb e9                	jmp    801b61 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b78:	8b 45 14             	mov    0x14(%ebp),%eax
  801b7b:	8d 48 04             	lea    0x4(%eax),%ecx
  801b7e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801b81:	8b 00                	mov    (%eax),%eax
  801b83:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b86:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801b88:	eb 22                	jmp    801bac <vprintfmt+0xde>
  801b8a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801b8d:	85 c9                	test   %ecx,%ecx
  801b8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b94:	0f 49 c1             	cmovns %ecx,%eax
  801b97:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b9a:	89 de                	mov    %ebx,%esi
  801b9c:	eb 9d                	jmp    801b3b <vprintfmt+0x6d>
  801b9e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801ba0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  801ba7:	eb 92                	jmp    801b3b <vprintfmt+0x6d>
  801ba9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  801bac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801bb0:	79 89                	jns    801b3b <vprintfmt+0x6d>
  801bb2:	e9 77 ff ff ff       	jmp    801b2e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801bb7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bba:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801bbc:	e9 7a ff ff ff       	jmp    801b3b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801bc1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc4:	8d 50 04             	lea    0x4(%eax),%edx
  801bc7:	89 55 14             	mov    %edx,0x14(%ebp)
  801bca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801bce:	8b 00                	mov    (%eax),%eax
  801bd0:	89 04 24             	mov    %eax,(%esp)
  801bd3:	ff 55 08             	call   *0x8(%ebp)
			break;
  801bd6:	e9 18 ff ff ff       	jmp    801af3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801bdb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bde:	8d 50 04             	lea    0x4(%eax),%edx
  801be1:	89 55 14             	mov    %edx,0x14(%ebp)
  801be4:	8b 00                	mov    (%eax),%eax
  801be6:	99                   	cltd   
  801be7:	31 d0                	xor    %edx,%eax
  801be9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801beb:	83 f8 12             	cmp    $0x12,%eax
  801bee:	7f 0b                	jg     801bfb <vprintfmt+0x12d>
  801bf0:	8b 14 85 00 2b 80 00 	mov    0x802b00(,%eax,4),%edx
  801bf7:	85 d2                	test   %edx,%edx
  801bf9:	75 20                	jne    801c1b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  801bfb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bff:	c7 44 24 08 3b 28 80 	movl   $0x80283b,0x8(%esp)
  801c06:	00 
  801c07:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	89 04 24             	mov    %eax,(%esp)
  801c11:	e8 90 fe ff ff       	call   801aa6 <printfmt>
  801c16:	e9 d8 fe ff ff       	jmp    801af3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801c1b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c1f:	c7 44 24 08 81 27 80 	movl   $0x802781,0x8(%esp)
  801c26:	00 
  801c27:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	89 04 24             	mov    %eax,(%esp)
  801c31:	e8 70 fe ff ff       	call   801aa6 <printfmt>
  801c36:	e9 b8 fe ff ff       	jmp    801af3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801c3b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801c3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c41:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c44:	8b 45 14             	mov    0x14(%ebp),%eax
  801c47:	8d 50 04             	lea    0x4(%eax),%edx
  801c4a:	89 55 14             	mov    %edx,0x14(%ebp)
  801c4d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  801c4f:	85 f6                	test   %esi,%esi
  801c51:	b8 34 28 80 00       	mov    $0x802834,%eax
  801c56:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  801c59:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  801c5d:	0f 84 97 00 00 00    	je     801cfa <vprintfmt+0x22c>
  801c63:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801c67:	0f 8e 9b 00 00 00    	jle    801d08 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c6d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c71:	89 34 24             	mov    %esi,(%esp)
  801c74:	e8 cf 02 00 00       	call   801f48 <strnlen>
  801c79:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801c7c:	29 c2                	sub    %eax,%edx
  801c7e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  801c81:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  801c85:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c88:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801c8b:	8b 75 08             	mov    0x8(%ebp),%esi
  801c8e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c91:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c93:	eb 0f                	jmp    801ca4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  801c95:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c9c:	89 04 24             	mov    %eax,(%esp)
  801c9f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801ca1:	83 eb 01             	sub    $0x1,%ebx
  801ca4:	85 db                	test   %ebx,%ebx
  801ca6:	7f ed                	jg     801c95 <vprintfmt+0x1c7>
  801ca8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801cab:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801cae:	85 d2                	test   %edx,%edx
  801cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb5:	0f 49 c2             	cmovns %edx,%eax
  801cb8:	29 c2                	sub    %eax,%edx
  801cba:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801cbd:	89 d7                	mov    %edx,%edi
  801cbf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801cc2:	eb 50                	jmp    801d14 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801cc4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cc8:	74 1e                	je     801ce8 <vprintfmt+0x21a>
  801cca:	0f be d2             	movsbl %dl,%edx
  801ccd:	83 ea 20             	sub    $0x20,%edx
  801cd0:	83 fa 5e             	cmp    $0x5e,%edx
  801cd3:	76 13                	jbe    801ce8 <vprintfmt+0x21a>
					putch('?', putdat);
  801cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801ce3:	ff 55 08             	call   *0x8(%ebp)
  801ce6:	eb 0d                	jmp    801cf5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  801ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ceb:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cef:	89 04 24             	mov    %eax,(%esp)
  801cf2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801cf5:	83 ef 01             	sub    $0x1,%edi
  801cf8:	eb 1a                	jmp    801d14 <vprintfmt+0x246>
  801cfa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801cfd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801d00:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801d03:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801d06:	eb 0c                	jmp    801d14 <vprintfmt+0x246>
  801d08:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801d0b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801d0e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801d11:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801d14:	83 c6 01             	add    $0x1,%esi
  801d17:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801d1b:	0f be c2             	movsbl %dl,%eax
  801d1e:	85 c0                	test   %eax,%eax
  801d20:	74 27                	je     801d49 <vprintfmt+0x27b>
  801d22:	85 db                	test   %ebx,%ebx
  801d24:	78 9e                	js     801cc4 <vprintfmt+0x1f6>
  801d26:	83 eb 01             	sub    $0x1,%ebx
  801d29:	79 99                	jns    801cc4 <vprintfmt+0x1f6>
  801d2b:	89 f8                	mov    %edi,%eax
  801d2d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d30:	8b 75 08             	mov    0x8(%ebp),%esi
  801d33:	89 c3                	mov    %eax,%ebx
  801d35:	eb 1a                	jmp    801d51 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801d37:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d3b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801d42:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d44:	83 eb 01             	sub    $0x1,%ebx
  801d47:	eb 08                	jmp    801d51 <vprintfmt+0x283>
  801d49:	89 fb                	mov    %edi,%ebx
  801d4b:	8b 75 08             	mov    0x8(%ebp),%esi
  801d4e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d51:	85 db                	test   %ebx,%ebx
  801d53:	7f e2                	jg     801d37 <vprintfmt+0x269>
  801d55:	89 75 08             	mov    %esi,0x8(%ebp)
  801d58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d5b:	e9 93 fd ff ff       	jmp    801af3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801d60:	83 fa 01             	cmp    $0x1,%edx
  801d63:	7e 16                	jle    801d7b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  801d65:	8b 45 14             	mov    0x14(%ebp),%eax
  801d68:	8d 50 08             	lea    0x8(%eax),%edx
  801d6b:	89 55 14             	mov    %edx,0x14(%ebp)
  801d6e:	8b 50 04             	mov    0x4(%eax),%edx
  801d71:	8b 00                	mov    (%eax),%eax
  801d73:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d76:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801d79:	eb 32                	jmp    801dad <vprintfmt+0x2df>
	else if (lflag)
  801d7b:	85 d2                	test   %edx,%edx
  801d7d:	74 18                	je     801d97 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  801d7f:	8b 45 14             	mov    0x14(%ebp),%eax
  801d82:	8d 50 04             	lea    0x4(%eax),%edx
  801d85:	89 55 14             	mov    %edx,0x14(%ebp)
  801d88:	8b 30                	mov    (%eax),%esi
  801d8a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801d8d:	89 f0                	mov    %esi,%eax
  801d8f:	c1 f8 1f             	sar    $0x1f,%eax
  801d92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d95:	eb 16                	jmp    801dad <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  801d97:	8b 45 14             	mov    0x14(%ebp),%eax
  801d9a:	8d 50 04             	lea    0x4(%eax),%edx
  801d9d:	89 55 14             	mov    %edx,0x14(%ebp)
  801da0:	8b 30                	mov    (%eax),%esi
  801da2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801da5:	89 f0                	mov    %esi,%eax
  801da7:	c1 f8 1f             	sar    $0x1f,%eax
  801daa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801dad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801db0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801db3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801db8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801dbc:	0f 89 80 00 00 00    	jns    801e42 <vprintfmt+0x374>
				putch('-', putdat);
  801dc2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801dc6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801dcd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801dd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dd3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801dd6:	f7 d8                	neg    %eax
  801dd8:	83 d2 00             	adc    $0x0,%edx
  801ddb:	f7 da                	neg    %edx
			}
			base = 10;
  801ddd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801de2:	eb 5e                	jmp    801e42 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801de4:	8d 45 14             	lea    0x14(%ebp),%eax
  801de7:	e8 63 fc ff ff       	call   801a4f <getuint>
			base = 10;
  801dec:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801df1:	eb 4f                	jmp    801e42 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  801df3:	8d 45 14             	lea    0x14(%ebp),%eax
  801df6:	e8 54 fc ff ff       	call   801a4f <getuint>
			base = 8;
  801dfb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801e00:	eb 40                	jmp    801e42 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  801e02:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e06:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801e0d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801e10:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e14:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801e1b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801e1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e21:	8d 50 04             	lea    0x4(%eax),%edx
  801e24:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801e27:	8b 00                	mov    (%eax),%eax
  801e29:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801e2e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801e33:	eb 0d                	jmp    801e42 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801e35:	8d 45 14             	lea    0x14(%ebp),%eax
  801e38:	e8 12 fc ff ff       	call   801a4f <getuint>
			base = 16;
  801e3d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801e42:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  801e46:	89 74 24 10          	mov    %esi,0x10(%esp)
  801e4a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  801e4d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e51:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e55:	89 04 24             	mov    %eax,(%esp)
  801e58:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e5c:	89 fa                	mov    %edi,%edx
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	e8 fa fa ff ff       	call   801960 <printnum>
			break;
  801e66:	e9 88 fc ff ff       	jmp    801af3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e6b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e6f:	89 04 24             	mov    %eax,(%esp)
  801e72:	ff 55 08             	call   *0x8(%ebp)
			break;
  801e75:	e9 79 fc ff ff       	jmp    801af3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e7a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e7e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801e85:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e88:	89 f3                	mov    %esi,%ebx
  801e8a:	eb 03                	jmp    801e8f <vprintfmt+0x3c1>
  801e8c:	83 eb 01             	sub    $0x1,%ebx
  801e8f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801e93:	75 f7                	jne    801e8c <vprintfmt+0x3be>
  801e95:	e9 59 fc ff ff       	jmp    801af3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801e9a:	83 c4 3c             	add    $0x3c,%esp
  801e9d:	5b                   	pop    %ebx
  801e9e:	5e                   	pop    %esi
  801e9f:	5f                   	pop    %edi
  801ea0:	5d                   	pop    %ebp
  801ea1:	c3                   	ret    

00801ea2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	83 ec 28             	sub    $0x28,%esp
  801ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eab:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801eae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801eb1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801eb5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801eb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801ebf:	85 c0                	test   %eax,%eax
  801ec1:	74 30                	je     801ef3 <vsnprintf+0x51>
  801ec3:	85 d2                	test   %edx,%edx
  801ec5:	7e 2c                	jle    801ef3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ec7:	8b 45 14             	mov    0x14(%ebp),%eax
  801eca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ece:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ed5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ed8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801edc:	c7 04 24 89 1a 80 00 	movl   $0x801a89,(%esp)
  801ee3:	e8 e6 fb ff ff       	call   801ace <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801ee8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eeb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef1:	eb 05                	jmp    801ef8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801ef3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f00:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801f03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f07:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f11:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	89 04 24             	mov    %eax,(%esp)
  801f1b:	e8 82 ff ff ff       	call   801ea2 <vsnprintf>
	va_end(ap);

	return rc;
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    
  801f22:	66 90                	xchg   %ax,%ax
  801f24:	66 90                	xchg   %ax,%ax
  801f26:	66 90                	xchg   %ax,%ax
  801f28:	66 90                	xchg   %ax,%ax
  801f2a:	66 90                	xchg   %ax,%ax
  801f2c:	66 90                	xchg   %ax,%ax
  801f2e:	66 90                	xchg   %ax,%ax

00801f30 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801f36:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3b:	eb 03                	jmp    801f40 <strlen+0x10>
		n++;
  801f3d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f40:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801f44:	75 f7                	jne    801f3d <strlen+0xd>
		n++;
	return n;
}
  801f46:	5d                   	pop    %ebp
  801f47:	c3                   	ret    

00801f48 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f51:	b8 00 00 00 00       	mov    $0x0,%eax
  801f56:	eb 03                	jmp    801f5b <strnlen+0x13>
		n++;
  801f58:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f5b:	39 d0                	cmp    %edx,%eax
  801f5d:	74 06                	je     801f65 <strnlen+0x1d>
  801f5f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801f63:	75 f3                	jne    801f58 <strnlen+0x10>
		n++;
	return n;
}
  801f65:	5d                   	pop    %ebp
  801f66:	c3                   	ret    

00801f67 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	53                   	push   %ebx
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801f71:	89 c2                	mov    %eax,%edx
  801f73:	83 c2 01             	add    $0x1,%edx
  801f76:	83 c1 01             	add    $0x1,%ecx
  801f79:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801f7d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801f80:	84 db                	test   %bl,%bl
  801f82:	75 ef                	jne    801f73 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801f84:	5b                   	pop    %ebx
  801f85:	5d                   	pop    %ebp
  801f86:	c3                   	ret    

00801f87 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	53                   	push   %ebx
  801f8b:	83 ec 08             	sub    $0x8,%esp
  801f8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801f91:	89 1c 24             	mov    %ebx,(%esp)
  801f94:	e8 97 ff ff ff       	call   801f30 <strlen>
	strcpy(dst + len, src);
  801f99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fa0:	01 d8                	add    %ebx,%eax
  801fa2:	89 04 24             	mov    %eax,(%esp)
  801fa5:	e8 bd ff ff ff       	call   801f67 <strcpy>
	return dst;
}
  801faa:	89 d8                	mov    %ebx,%eax
  801fac:	83 c4 08             	add    $0x8,%esp
  801faf:	5b                   	pop    %ebx
  801fb0:	5d                   	pop    %ebp
  801fb1:	c3                   	ret    

00801fb2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	56                   	push   %esi
  801fb6:	53                   	push   %ebx
  801fb7:	8b 75 08             	mov    0x8(%ebp),%esi
  801fba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fbd:	89 f3                	mov    %esi,%ebx
  801fbf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801fc2:	89 f2                	mov    %esi,%edx
  801fc4:	eb 0f                	jmp    801fd5 <strncpy+0x23>
		*dst++ = *src;
  801fc6:	83 c2 01             	add    $0x1,%edx
  801fc9:	0f b6 01             	movzbl (%ecx),%eax
  801fcc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801fcf:	80 39 01             	cmpb   $0x1,(%ecx)
  801fd2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801fd5:	39 da                	cmp    %ebx,%edx
  801fd7:	75 ed                	jne    801fc6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801fd9:	89 f0                	mov    %esi,%eax
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5d                   	pop    %ebp
  801fde:	c3                   	ret    

00801fdf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	56                   	push   %esi
  801fe3:	53                   	push   %ebx
  801fe4:	8b 75 08             	mov    0x8(%ebp),%esi
  801fe7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fed:	89 f0                	mov    %esi,%eax
  801fef:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801ff3:	85 c9                	test   %ecx,%ecx
  801ff5:	75 0b                	jne    802002 <strlcpy+0x23>
  801ff7:	eb 1d                	jmp    802016 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801ff9:	83 c0 01             	add    $0x1,%eax
  801ffc:	83 c2 01             	add    $0x1,%edx
  801fff:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802002:	39 d8                	cmp    %ebx,%eax
  802004:	74 0b                	je     802011 <strlcpy+0x32>
  802006:	0f b6 0a             	movzbl (%edx),%ecx
  802009:	84 c9                	test   %cl,%cl
  80200b:	75 ec                	jne    801ff9 <strlcpy+0x1a>
  80200d:	89 c2                	mov    %eax,%edx
  80200f:	eb 02                	jmp    802013 <strlcpy+0x34>
  802011:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  802013:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  802016:	29 f0                	sub    %esi,%eax
}
  802018:	5b                   	pop    %ebx
  802019:	5e                   	pop    %esi
  80201a:	5d                   	pop    %ebp
  80201b:	c3                   	ret    

0080201c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802022:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802025:	eb 06                	jmp    80202d <strcmp+0x11>
		p++, q++;
  802027:	83 c1 01             	add    $0x1,%ecx
  80202a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80202d:	0f b6 01             	movzbl (%ecx),%eax
  802030:	84 c0                	test   %al,%al
  802032:	74 04                	je     802038 <strcmp+0x1c>
  802034:	3a 02                	cmp    (%edx),%al
  802036:	74 ef                	je     802027 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802038:	0f b6 c0             	movzbl %al,%eax
  80203b:	0f b6 12             	movzbl (%edx),%edx
  80203e:	29 d0                	sub    %edx,%eax
}
  802040:	5d                   	pop    %ebp
  802041:	c3                   	ret    

00802042 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	53                   	push   %ebx
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204c:	89 c3                	mov    %eax,%ebx
  80204e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802051:	eb 06                	jmp    802059 <strncmp+0x17>
		n--, p++, q++;
  802053:	83 c0 01             	add    $0x1,%eax
  802056:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802059:	39 d8                	cmp    %ebx,%eax
  80205b:	74 15                	je     802072 <strncmp+0x30>
  80205d:	0f b6 08             	movzbl (%eax),%ecx
  802060:	84 c9                	test   %cl,%cl
  802062:	74 04                	je     802068 <strncmp+0x26>
  802064:	3a 0a                	cmp    (%edx),%cl
  802066:	74 eb                	je     802053 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802068:	0f b6 00             	movzbl (%eax),%eax
  80206b:	0f b6 12             	movzbl (%edx),%edx
  80206e:	29 d0                	sub    %edx,%eax
  802070:	eb 05                	jmp    802077 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  802072:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802077:	5b                   	pop    %ebx
  802078:	5d                   	pop    %ebp
  802079:	c3                   	ret    

0080207a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802084:	eb 07                	jmp    80208d <strchr+0x13>
		if (*s == c)
  802086:	38 ca                	cmp    %cl,%dl
  802088:	74 0f                	je     802099 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80208a:	83 c0 01             	add    $0x1,%eax
  80208d:	0f b6 10             	movzbl (%eax),%edx
  802090:	84 d2                	test   %dl,%dl
  802092:	75 f2                	jne    802086 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  802094:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802099:	5d                   	pop    %ebp
  80209a:	c3                   	ret    

0080209b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8020a5:	eb 07                	jmp    8020ae <strfind+0x13>
		if (*s == c)
  8020a7:	38 ca                	cmp    %cl,%dl
  8020a9:	74 0a                	je     8020b5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8020ab:	83 c0 01             	add    $0x1,%eax
  8020ae:	0f b6 10             	movzbl (%eax),%edx
  8020b1:	84 d2                	test   %dl,%dl
  8020b3:	75 f2                	jne    8020a7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8020b5:	5d                   	pop    %ebp
  8020b6:	c3                   	ret    

008020b7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	57                   	push   %edi
  8020bb:	56                   	push   %esi
  8020bc:	53                   	push   %ebx
  8020bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8020c3:	85 c9                	test   %ecx,%ecx
  8020c5:	74 36                	je     8020fd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8020c7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8020cd:	75 28                	jne    8020f7 <memset+0x40>
  8020cf:	f6 c1 03             	test   $0x3,%cl
  8020d2:	75 23                	jne    8020f7 <memset+0x40>
		c &= 0xFF;
  8020d4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8020d8:	89 d3                	mov    %edx,%ebx
  8020da:	c1 e3 08             	shl    $0x8,%ebx
  8020dd:	89 d6                	mov    %edx,%esi
  8020df:	c1 e6 18             	shl    $0x18,%esi
  8020e2:	89 d0                	mov    %edx,%eax
  8020e4:	c1 e0 10             	shl    $0x10,%eax
  8020e7:	09 f0                	or     %esi,%eax
  8020e9:	09 c2                	or     %eax,%edx
  8020eb:	89 d0                	mov    %edx,%eax
  8020ed:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8020ef:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8020f2:	fc                   	cld    
  8020f3:	f3 ab                	rep stos %eax,%es:(%edi)
  8020f5:	eb 06                	jmp    8020fd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8020f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fa:	fc                   	cld    
  8020fb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8020fd:	89 f8                	mov    %edi,%eax
  8020ff:	5b                   	pop    %ebx
  802100:	5e                   	pop    %esi
  802101:	5f                   	pop    %edi
  802102:	5d                   	pop    %ebp
  802103:	c3                   	ret    

00802104 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	57                   	push   %edi
  802108:	56                   	push   %esi
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80210f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802112:	39 c6                	cmp    %eax,%esi
  802114:	73 35                	jae    80214b <memmove+0x47>
  802116:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802119:	39 d0                	cmp    %edx,%eax
  80211b:	73 2e                	jae    80214b <memmove+0x47>
		s += n;
		d += n;
  80211d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  802120:	89 d6                	mov    %edx,%esi
  802122:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802124:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80212a:	75 13                	jne    80213f <memmove+0x3b>
  80212c:	f6 c1 03             	test   $0x3,%cl
  80212f:	75 0e                	jne    80213f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802131:	83 ef 04             	sub    $0x4,%edi
  802134:	8d 72 fc             	lea    -0x4(%edx),%esi
  802137:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80213a:	fd                   	std    
  80213b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80213d:	eb 09                	jmp    802148 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80213f:	83 ef 01             	sub    $0x1,%edi
  802142:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802145:	fd                   	std    
  802146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802148:	fc                   	cld    
  802149:	eb 1d                	jmp    802168 <memmove+0x64>
  80214b:	89 f2                	mov    %esi,%edx
  80214d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80214f:	f6 c2 03             	test   $0x3,%dl
  802152:	75 0f                	jne    802163 <memmove+0x5f>
  802154:	f6 c1 03             	test   $0x3,%cl
  802157:	75 0a                	jne    802163 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802159:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80215c:	89 c7                	mov    %eax,%edi
  80215e:	fc                   	cld    
  80215f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802161:	eb 05                	jmp    802168 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802163:	89 c7                	mov    %eax,%edi
  802165:	fc                   	cld    
  802166:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802168:	5e                   	pop    %esi
  802169:	5f                   	pop    %edi
  80216a:	5d                   	pop    %ebp
  80216b:	c3                   	ret    

0080216c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802172:	8b 45 10             	mov    0x10(%ebp),%eax
  802175:	89 44 24 08          	mov    %eax,0x8(%esp)
  802179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	89 04 24             	mov    %eax,(%esp)
  802186:	e8 79 ff ff ff       	call   802104 <memmove>
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	56                   	push   %esi
  802191:	53                   	push   %ebx
  802192:	8b 55 08             	mov    0x8(%ebp),%edx
  802195:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802198:	89 d6                	mov    %edx,%esi
  80219a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80219d:	eb 1a                	jmp    8021b9 <memcmp+0x2c>
		if (*s1 != *s2)
  80219f:	0f b6 02             	movzbl (%edx),%eax
  8021a2:	0f b6 19             	movzbl (%ecx),%ebx
  8021a5:	38 d8                	cmp    %bl,%al
  8021a7:	74 0a                	je     8021b3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8021a9:	0f b6 c0             	movzbl %al,%eax
  8021ac:	0f b6 db             	movzbl %bl,%ebx
  8021af:	29 d8                	sub    %ebx,%eax
  8021b1:	eb 0f                	jmp    8021c2 <memcmp+0x35>
		s1++, s2++;
  8021b3:	83 c2 01             	add    $0x1,%edx
  8021b6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8021b9:	39 f2                	cmp    %esi,%edx
  8021bb:	75 e2                	jne    80219f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8021bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021c2:	5b                   	pop    %ebx
  8021c3:	5e                   	pop    %esi
  8021c4:	5d                   	pop    %ebp
  8021c5:	c3                   	ret    

008021c6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8021cf:	89 c2                	mov    %eax,%edx
  8021d1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8021d4:	eb 07                	jmp    8021dd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  8021d6:	38 08                	cmp    %cl,(%eax)
  8021d8:	74 07                	je     8021e1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8021da:	83 c0 01             	add    $0x1,%eax
  8021dd:	39 d0                	cmp    %edx,%eax
  8021df:	72 f5                	jb     8021d6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8021e1:	5d                   	pop    %ebp
  8021e2:	c3                   	ret    

008021e3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
  8021e6:	57                   	push   %edi
  8021e7:	56                   	push   %esi
  8021e8:	53                   	push   %ebx
  8021e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ec:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8021ef:	eb 03                	jmp    8021f4 <strtol+0x11>
		s++;
  8021f1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8021f4:	0f b6 0a             	movzbl (%edx),%ecx
  8021f7:	80 f9 09             	cmp    $0x9,%cl
  8021fa:	74 f5                	je     8021f1 <strtol+0xe>
  8021fc:	80 f9 20             	cmp    $0x20,%cl
  8021ff:	74 f0                	je     8021f1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  802201:	80 f9 2b             	cmp    $0x2b,%cl
  802204:	75 0a                	jne    802210 <strtol+0x2d>
		s++;
  802206:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  802209:	bf 00 00 00 00       	mov    $0x0,%edi
  80220e:	eb 11                	jmp    802221 <strtol+0x3e>
  802210:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  802215:	80 f9 2d             	cmp    $0x2d,%cl
  802218:	75 07                	jne    802221 <strtol+0x3e>
		s++, neg = 1;
  80221a:	8d 52 01             	lea    0x1(%edx),%edx
  80221d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802221:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  802226:	75 15                	jne    80223d <strtol+0x5a>
  802228:	80 3a 30             	cmpb   $0x30,(%edx)
  80222b:	75 10                	jne    80223d <strtol+0x5a>
  80222d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  802231:	75 0a                	jne    80223d <strtol+0x5a>
		s += 2, base = 16;
  802233:	83 c2 02             	add    $0x2,%edx
  802236:	b8 10 00 00 00       	mov    $0x10,%eax
  80223b:	eb 10                	jmp    80224d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80223d:	85 c0                	test   %eax,%eax
  80223f:	75 0c                	jne    80224d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802241:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802243:	80 3a 30             	cmpb   $0x30,(%edx)
  802246:	75 05                	jne    80224d <strtol+0x6a>
		s++, base = 8;
  802248:	83 c2 01             	add    $0x1,%edx
  80224b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80224d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802252:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802255:	0f b6 0a             	movzbl (%edx),%ecx
  802258:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80225b:	89 f0                	mov    %esi,%eax
  80225d:	3c 09                	cmp    $0x9,%al
  80225f:	77 08                	ja     802269 <strtol+0x86>
			dig = *s - '0';
  802261:	0f be c9             	movsbl %cl,%ecx
  802264:	83 e9 30             	sub    $0x30,%ecx
  802267:	eb 20                	jmp    802289 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  802269:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80226c:	89 f0                	mov    %esi,%eax
  80226e:	3c 19                	cmp    $0x19,%al
  802270:	77 08                	ja     80227a <strtol+0x97>
			dig = *s - 'a' + 10;
  802272:	0f be c9             	movsbl %cl,%ecx
  802275:	83 e9 57             	sub    $0x57,%ecx
  802278:	eb 0f                	jmp    802289 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80227a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80227d:	89 f0                	mov    %esi,%eax
  80227f:	3c 19                	cmp    $0x19,%al
  802281:	77 16                	ja     802299 <strtol+0xb6>
			dig = *s - 'A' + 10;
  802283:	0f be c9             	movsbl %cl,%ecx
  802286:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  802289:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80228c:	7d 0f                	jge    80229d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80228e:	83 c2 01             	add    $0x1,%edx
  802291:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  802295:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  802297:	eb bc                	jmp    802255 <strtol+0x72>
  802299:	89 d8                	mov    %ebx,%eax
  80229b:	eb 02                	jmp    80229f <strtol+0xbc>
  80229d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80229f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022a3:	74 05                	je     8022aa <strtol+0xc7>
		*endptr = (char *) s;
  8022a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022a8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8022aa:	f7 d8                	neg    %eax
  8022ac:	85 ff                	test   %edi,%edi
  8022ae:	0f 44 c3             	cmove  %ebx,%eax
}
  8022b1:	5b                   	pop    %ebx
  8022b2:	5e                   	pop    %esi
  8022b3:	5f                   	pop    %edi
  8022b4:	5d                   	pop    %ebp
  8022b5:	c3                   	ret    
  8022b6:	66 90                	xchg   %ax,%ax
  8022b8:	66 90                	xchg   %ax,%ax
  8022ba:	66 90                	xchg   %ax,%ax
  8022bc:	66 90                	xchg   %ax,%ax
  8022be:	66 90                	xchg   %ax,%ax

008022c0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	56                   	push   %esi
  8022c4:	53                   	push   %ebx
  8022c5:	83 ec 10             	sub    $0x10,%esp
  8022c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8022cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8022d1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  8022d3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022d8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  8022db:	89 04 24             	mov    %eax,(%esp)
  8022de:	e8 9e e0 ff ff       	call   800381 <sys_ipc_recv>
  8022e3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  8022e5:	85 d2                	test   %edx,%edx
  8022e7:	75 24                	jne    80230d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  8022e9:	85 f6                	test   %esi,%esi
  8022eb:	74 0a                	je     8022f7 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  8022ed:	a1 08 40 80 00       	mov    0x804008,%eax
  8022f2:	8b 40 74             	mov    0x74(%eax),%eax
  8022f5:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  8022f7:	85 db                	test   %ebx,%ebx
  8022f9:	74 0a                	je     802305 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  8022fb:	a1 08 40 80 00       	mov    0x804008,%eax
  802300:	8b 40 78             	mov    0x78(%eax),%eax
  802303:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802305:	a1 08 40 80 00       	mov    0x804008,%eax
  80230a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80230d:	83 c4 10             	add    $0x10,%esp
  802310:	5b                   	pop    %ebx
  802311:	5e                   	pop    %esi
  802312:	5d                   	pop    %ebp
  802313:	c3                   	ret    

00802314 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	57                   	push   %edi
  802318:	56                   	push   %esi
  802319:	53                   	push   %ebx
  80231a:	83 ec 1c             	sub    $0x1c,%esp
  80231d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802320:	8b 75 0c             	mov    0xc(%ebp),%esi
  802323:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802326:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802328:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80232d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802330:	8b 45 14             	mov    0x14(%ebp),%eax
  802333:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802337:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80233b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80233f:	89 3c 24             	mov    %edi,(%esp)
  802342:	e8 17 e0 ff ff       	call   80035e <sys_ipc_try_send>

		if (ret == 0)
  802347:	85 c0                	test   %eax,%eax
  802349:	74 2c                	je     802377 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80234b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80234e:	74 20                	je     802370 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802350:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802354:	c7 44 24 08 6c 2b 80 	movl   $0x802b6c,0x8(%esp)
  80235b:	00 
  80235c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802363:	00 
  802364:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  80236b:	e8 d6 f4 ff ff       	call   801846 <_panic>
		}

		sys_yield();
  802370:	e8 d7 dd ff ff       	call   80014c <sys_yield>
	}
  802375:	eb b9                	jmp    802330 <ipc_send+0x1c>
}
  802377:	83 c4 1c             	add    $0x1c,%esp
  80237a:	5b                   	pop    %ebx
  80237b:	5e                   	pop    %esi
  80237c:	5f                   	pop    %edi
  80237d:	5d                   	pop    %ebp
  80237e:	c3                   	ret    

0080237f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
  802382:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802385:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80238a:	89 c2                	mov    %eax,%edx
  80238c:	c1 e2 07             	shl    $0x7,%edx
  80238f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  802396:	8b 52 50             	mov    0x50(%edx),%edx
  802399:	39 ca                	cmp    %ecx,%edx
  80239b:	75 11                	jne    8023ae <ipc_find_env+0x2f>
			return envs[i].env_id;
  80239d:	89 c2                	mov    %eax,%edx
  80239f:	c1 e2 07             	shl    $0x7,%edx
  8023a2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  8023a9:	8b 40 40             	mov    0x40(%eax),%eax
  8023ac:	eb 0e                	jmp    8023bc <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023ae:	83 c0 01             	add    $0x1,%eax
  8023b1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023b6:	75 d2                	jne    80238a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023b8:	66 b8 00 00          	mov    $0x0,%ax
}
  8023bc:	5d                   	pop    %ebp
  8023bd:	c3                   	ret    

008023be <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023c4:	89 d0                	mov    %edx,%eax
  8023c6:	c1 e8 16             	shr    $0x16,%eax
  8023c9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023d0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023d5:	f6 c1 01             	test   $0x1,%cl
  8023d8:	74 1d                	je     8023f7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023da:	c1 ea 0c             	shr    $0xc,%edx
  8023dd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023e4:	f6 c2 01             	test   $0x1,%dl
  8023e7:	74 0e                	je     8023f7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023e9:	c1 ea 0c             	shr    $0xc,%edx
  8023ec:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023f3:	ef 
  8023f4:	0f b7 c0             	movzwl %ax,%eax
}
  8023f7:	5d                   	pop    %ebp
  8023f8:	c3                   	ret    
  8023f9:	66 90                	xchg   %ax,%ax
  8023fb:	66 90                	xchg   %ax,%ax
  8023fd:	66 90                	xchg   %ax,%ax
  8023ff:	90                   	nop

00802400 <__udivdi3>:
  802400:	55                   	push   %ebp
  802401:	57                   	push   %edi
  802402:	56                   	push   %esi
  802403:	83 ec 0c             	sub    $0xc,%esp
  802406:	8b 44 24 28          	mov    0x28(%esp),%eax
  80240a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80240e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802412:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802416:	85 c0                	test   %eax,%eax
  802418:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80241c:	89 ea                	mov    %ebp,%edx
  80241e:	89 0c 24             	mov    %ecx,(%esp)
  802421:	75 2d                	jne    802450 <__udivdi3+0x50>
  802423:	39 e9                	cmp    %ebp,%ecx
  802425:	77 61                	ja     802488 <__udivdi3+0x88>
  802427:	85 c9                	test   %ecx,%ecx
  802429:	89 ce                	mov    %ecx,%esi
  80242b:	75 0b                	jne    802438 <__udivdi3+0x38>
  80242d:	b8 01 00 00 00       	mov    $0x1,%eax
  802432:	31 d2                	xor    %edx,%edx
  802434:	f7 f1                	div    %ecx
  802436:	89 c6                	mov    %eax,%esi
  802438:	31 d2                	xor    %edx,%edx
  80243a:	89 e8                	mov    %ebp,%eax
  80243c:	f7 f6                	div    %esi
  80243e:	89 c5                	mov    %eax,%ebp
  802440:	89 f8                	mov    %edi,%eax
  802442:	f7 f6                	div    %esi
  802444:	89 ea                	mov    %ebp,%edx
  802446:	83 c4 0c             	add    $0xc,%esp
  802449:	5e                   	pop    %esi
  80244a:	5f                   	pop    %edi
  80244b:	5d                   	pop    %ebp
  80244c:	c3                   	ret    
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	39 e8                	cmp    %ebp,%eax
  802452:	77 24                	ja     802478 <__udivdi3+0x78>
  802454:	0f bd e8             	bsr    %eax,%ebp
  802457:	83 f5 1f             	xor    $0x1f,%ebp
  80245a:	75 3c                	jne    802498 <__udivdi3+0x98>
  80245c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802460:	39 34 24             	cmp    %esi,(%esp)
  802463:	0f 86 9f 00 00 00    	jbe    802508 <__udivdi3+0x108>
  802469:	39 d0                	cmp    %edx,%eax
  80246b:	0f 82 97 00 00 00    	jb     802508 <__udivdi3+0x108>
  802471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802478:	31 d2                	xor    %edx,%edx
  80247a:	31 c0                	xor    %eax,%eax
  80247c:	83 c4 0c             	add    $0xc,%esp
  80247f:	5e                   	pop    %esi
  802480:	5f                   	pop    %edi
  802481:	5d                   	pop    %ebp
  802482:	c3                   	ret    
  802483:	90                   	nop
  802484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802488:	89 f8                	mov    %edi,%eax
  80248a:	f7 f1                	div    %ecx
  80248c:	31 d2                	xor    %edx,%edx
  80248e:	83 c4 0c             	add    $0xc,%esp
  802491:	5e                   	pop    %esi
  802492:	5f                   	pop    %edi
  802493:	5d                   	pop    %ebp
  802494:	c3                   	ret    
  802495:	8d 76 00             	lea    0x0(%esi),%esi
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	8b 3c 24             	mov    (%esp),%edi
  80249d:	d3 e0                	shl    %cl,%eax
  80249f:	89 c6                	mov    %eax,%esi
  8024a1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024a6:	29 e8                	sub    %ebp,%eax
  8024a8:	89 c1                	mov    %eax,%ecx
  8024aa:	d3 ef                	shr    %cl,%edi
  8024ac:	89 e9                	mov    %ebp,%ecx
  8024ae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024b2:	8b 3c 24             	mov    (%esp),%edi
  8024b5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024b9:	89 d6                	mov    %edx,%esi
  8024bb:	d3 e7                	shl    %cl,%edi
  8024bd:	89 c1                	mov    %eax,%ecx
  8024bf:	89 3c 24             	mov    %edi,(%esp)
  8024c2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024c6:	d3 ee                	shr    %cl,%esi
  8024c8:	89 e9                	mov    %ebp,%ecx
  8024ca:	d3 e2                	shl    %cl,%edx
  8024cc:	89 c1                	mov    %eax,%ecx
  8024ce:	d3 ef                	shr    %cl,%edi
  8024d0:	09 d7                	or     %edx,%edi
  8024d2:	89 f2                	mov    %esi,%edx
  8024d4:	89 f8                	mov    %edi,%eax
  8024d6:	f7 74 24 08          	divl   0x8(%esp)
  8024da:	89 d6                	mov    %edx,%esi
  8024dc:	89 c7                	mov    %eax,%edi
  8024de:	f7 24 24             	mull   (%esp)
  8024e1:	39 d6                	cmp    %edx,%esi
  8024e3:	89 14 24             	mov    %edx,(%esp)
  8024e6:	72 30                	jb     802518 <__udivdi3+0x118>
  8024e8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024ec:	89 e9                	mov    %ebp,%ecx
  8024ee:	d3 e2                	shl    %cl,%edx
  8024f0:	39 c2                	cmp    %eax,%edx
  8024f2:	73 05                	jae    8024f9 <__udivdi3+0xf9>
  8024f4:	3b 34 24             	cmp    (%esp),%esi
  8024f7:	74 1f                	je     802518 <__udivdi3+0x118>
  8024f9:	89 f8                	mov    %edi,%eax
  8024fb:	31 d2                	xor    %edx,%edx
  8024fd:	e9 7a ff ff ff       	jmp    80247c <__udivdi3+0x7c>
  802502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802508:	31 d2                	xor    %edx,%edx
  80250a:	b8 01 00 00 00       	mov    $0x1,%eax
  80250f:	e9 68 ff ff ff       	jmp    80247c <__udivdi3+0x7c>
  802514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802518:	8d 47 ff             	lea    -0x1(%edi),%eax
  80251b:	31 d2                	xor    %edx,%edx
  80251d:	83 c4 0c             	add    $0xc,%esp
  802520:	5e                   	pop    %esi
  802521:	5f                   	pop    %edi
  802522:	5d                   	pop    %ebp
  802523:	c3                   	ret    
  802524:	66 90                	xchg   %ax,%ax
  802526:	66 90                	xchg   %ax,%ax
  802528:	66 90                	xchg   %ax,%ax
  80252a:	66 90                	xchg   %ax,%ax
  80252c:	66 90                	xchg   %ax,%ax
  80252e:	66 90                	xchg   %ax,%ax

00802530 <__umoddi3>:
  802530:	55                   	push   %ebp
  802531:	57                   	push   %edi
  802532:	56                   	push   %esi
  802533:	83 ec 14             	sub    $0x14,%esp
  802536:	8b 44 24 28          	mov    0x28(%esp),%eax
  80253a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80253e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802542:	89 c7                	mov    %eax,%edi
  802544:	89 44 24 04          	mov    %eax,0x4(%esp)
  802548:	8b 44 24 30          	mov    0x30(%esp),%eax
  80254c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802550:	89 34 24             	mov    %esi,(%esp)
  802553:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802557:	85 c0                	test   %eax,%eax
  802559:	89 c2                	mov    %eax,%edx
  80255b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80255f:	75 17                	jne    802578 <__umoddi3+0x48>
  802561:	39 fe                	cmp    %edi,%esi
  802563:	76 4b                	jbe    8025b0 <__umoddi3+0x80>
  802565:	89 c8                	mov    %ecx,%eax
  802567:	89 fa                	mov    %edi,%edx
  802569:	f7 f6                	div    %esi
  80256b:	89 d0                	mov    %edx,%eax
  80256d:	31 d2                	xor    %edx,%edx
  80256f:	83 c4 14             	add    $0x14,%esp
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    
  802576:	66 90                	xchg   %ax,%ax
  802578:	39 f8                	cmp    %edi,%eax
  80257a:	77 54                	ja     8025d0 <__umoddi3+0xa0>
  80257c:	0f bd e8             	bsr    %eax,%ebp
  80257f:	83 f5 1f             	xor    $0x1f,%ebp
  802582:	75 5c                	jne    8025e0 <__umoddi3+0xb0>
  802584:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802588:	39 3c 24             	cmp    %edi,(%esp)
  80258b:	0f 87 e7 00 00 00    	ja     802678 <__umoddi3+0x148>
  802591:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802595:	29 f1                	sub    %esi,%ecx
  802597:	19 c7                	sbb    %eax,%edi
  802599:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80259d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025a1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025a5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025a9:	83 c4 14             	add    $0x14,%esp
  8025ac:	5e                   	pop    %esi
  8025ad:	5f                   	pop    %edi
  8025ae:	5d                   	pop    %ebp
  8025af:	c3                   	ret    
  8025b0:	85 f6                	test   %esi,%esi
  8025b2:	89 f5                	mov    %esi,%ebp
  8025b4:	75 0b                	jne    8025c1 <__umoddi3+0x91>
  8025b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bb:	31 d2                	xor    %edx,%edx
  8025bd:	f7 f6                	div    %esi
  8025bf:	89 c5                	mov    %eax,%ebp
  8025c1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025c5:	31 d2                	xor    %edx,%edx
  8025c7:	f7 f5                	div    %ebp
  8025c9:	89 c8                	mov    %ecx,%eax
  8025cb:	f7 f5                	div    %ebp
  8025cd:	eb 9c                	jmp    80256b <__umoddi3+0x3b>
  8025cf:	90                   	nop
  8025d0:	89 c8                	mov    %ecx,%eax
  8025d2:	89 fa                	mov    %edi,%edx
  8025d4:	83 c4 14             	add    $0x14,%esp
  8025d7:	5e                   	pop    %esi
  8025d8:	5f                   	pop    %edi
  8025d9:	5d                   	pop    %ebp
  8025da:	c3                   	ret    
  8025db:	90                   	nop
  8025dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025e0:	8b 04 24             	mov    (%esp),%eax
  8025e3:	be 20 00 00 00       	mov    $0x20,%esi
  8025e8:	89 e9                	mov    %ebp,%ecx
  8025ea:	29 ee                	sub    %ebp,%esi
  8025ec:	d3 e2                	shl    %cl,%edx
  8025ee:	89 f1                	mov    %esi,%ecx
  8025f0:	d3 e8                	shr    %cl,%eax
  8025f2:	89 e9                	mov    %ebp,%ecx
  8025f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f8:	8b 04 24             	mov    (%esp),%eax
  8025fb:	09 54 24 04          	or     %edx,0x4(%esp)
  8025ff:	89 fa                	mov    %edi,%edx
  802601:	d3 e0                	shl    %cl,%eax
  802603:	89 f1                	mov    %esi,%ecx
  802605:	89 44 24 08          	mov    %eax,0x8(%esp)
  802609:	8b 44 24 10          	mov    0x10(%esp),%eax
  80260d:	d3 ea                	shr    %cl,%edx
  80260f:	89 e9                	mov    %ebp,%ecx
  802611:	d3 e7                	shl    %cl,%edi
  802613:	89 f1                	mov    %esi,%ecx
  802615:	d3 e8                	shr    %cl,%eax
  802617:	89 e9                	mov    %ebp,%ecx
  802619:	09 f8                	or     %edi,%eax
  80261b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80261f:	f7 74 24 04          	divl   0x4(%esp)
  802623:	d3 e7                	shl    %cl,%edi
  802625:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802629:	89 d7                	mov    %edx,%edi
  80262b:	f7 64 24 08          	mull   0x8(%esp)
  80262f:	39 d7                	cmp    %edx,%edi
  802631:	89 c1                	mov    %eax,%ecx
  802633:	89 14 24             	mov    %edx,(%esp)
  802636:	72 2c                	jb     802664 <__umoddi3+0x134>
  802638:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80263c:	72 22                	jb     802660 <__umoddi3+0x130>
  80263e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802642:	29 c8                	sub    %ecx,%eax
  802644:	19 d7                	sbb    %edx,%edi
  802646:	89 e9                	mov    %ebp,%ecx
  802648:	89 fa                	mov    %edi,%edx
  80264a:	d3 e8                	shr    %cl,%eax
  80264c:	89 f1                	mov    %esi,%ecx
  80264e:	d3 e2                	shl    %cl,%edx
  802650:	89 e9                	mov    %ebp,%ecx
  802652:	d3 ef                	shr    %cl,%edi
  802654:	09 d0                	or     %edx,%eax
  802656:	89 fa                	mov    %edi,%edx
  802658:	83 c4 14             	add    $0x14,%esp
  80265b:	5e                   	pop    %esi
  80265c:	5f                   	pop    %edi
  80265d:	5d                   	pop    %ebp
  80265e:	c3                   	ret    
  80265f:	90                   	nop
  802660:	39 d7                	cmp    %edx,%edi
  802662:	75 da                	jne    80263e <__umoddi3+0x10e>
  802664:	8b 14 24             	mov    (%esp),%edx
  802667:	89 c1                	mov    %eax,%ecx
  802669:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80266d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802671:	eb cb                	jmp    80263e <__umoddi3+0x10e>
  802673:	90                   	nop
  802674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802678:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80267c:	0f 82 0f ff ff ff    	jb     802591 <__umoddi3+0x61>
  802682:	e9 1a ff ff ff       	jmp    8025a1 <__umoddi3+0x71>
