
obj/user/faultwritekernel.debug:     file format elf32-i386


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
  80002c:	e8 11 00 00 00       	call   800042 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	*(unsigned*)0xf0100000 = 0;
  800036:	c7 05 00 00 10 f0 00 	movl   $0x0,0xf0100000
  80003d:	00 00 00 
}
  800040:	5d                   	pop    %ebp
  800041:	c3                   	ret    

00800042 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800042:	55                   	push   %ebp
  800043:	89 e5                	mov    %esp,%ebp
  800045:	56                   	push   %esi
  800046:	53                   	push   %ebx
  800047:	83 ec 10             	sub    $0x10,%esp
  80004a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  800050:	e8 e1 00 00 00       	call   800136 <sys_getenvid>
  800055:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005a:	89 c2                	mov    %eax,%edx
  80005c:	c1 e2 07             	shl    $0x7,%edx
  80005f:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800066:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006b:	85 db                	test   %ebx,%ebx
  80006d:	7e 07                	jle    800076 <libmain+0x34>
		binaryname = argv[0];
  80006f:	8b 06                	mov    (%esi),%eax
  800071:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800076:	89 74 24 04          	mov    %esi,0x4(%esp)
  80007a:	89 1c 24             	mov    %ebx,(%esp)
  80007d:	e8 b1 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800082:	e8 07 00 00 00       	call   80008e <exit>
}
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	5b                   	pop    %ebx
  80008b:	5e                   	pop    %esi
  80008c:	5d                   	pop    %ebp
  80008d:	c3                   	ret    

0080008e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008e:	55                   	push   %ebp
  80008f:	89 e5                	mov    %esp,%ebp
  800091:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800094:	e8 e1 06 00 00       	call   80077a <close_all>
	sys_env_destroy(0);
  800099:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a0:	e8 3f 00 00 00       	call   8000e4 <sys_env_destroy>
}
  8000a5:	c9                   	leave  
  8000a6:	c3                   	ret    

008000a7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	57                   	push   %edi
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b8:	89 c3                	mov    %eax,%ebx
  8000ba:	89 c7                	mov    %eax,%edi
  8000bc:	89 c6                	mov    %eax,%esi
  8000be:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c0:	5b                   	pop    %ebx
  8000c1:	5e                   	pop    %esi
  8000c2:	5f                   	pop    %edi
  8000c3:	5d                   	pop    %ebp
  8000c4:	c3                   	ret    

008000c5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c5:	55                   	push   %ebp
  8000c6:	89 e5                	mov    %esp,%ebp
  8000c8:	57                   	push   %edi
  8000c9:	56                   	push   %esi
  8000ca:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d5:	89 d1                	mov    %edx,%ecx
  8000d7:	89 d3                	mov    %edx,%ebx
  8000d9:	89 d7                	mov    %edx,%edi
  8000db:	89 d6                	mov    %edx,%esi
  8000dd:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000df:	5b                   	pop    %ebx
  8000e0:	5e                   	pop    %esi
  8000e1:	5f                   	pop    %edi
  8000e2:	5d                   	pop    %ebp
  8000e3:	c3                   	ret    

008000e4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	57                   	push   %edi
  8000e8:	56                   	push   %esi
  8000e9:	53                   	push   %ebx
  8000ea:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f2:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fa:	89 cb                	mov    %ecx,%ebx
  8000fc:	89 cf                	mov    %ecx,%edi
  8000fe:	89 ce                	mov    %ecx,%esi
  800100:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800102:	85 c0                	test   %eax,%eax
  800104:	7e 28                	jle    80012e <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800106:	89 44 24 10          	mov    %eax,0x10(%esp)
  80010a:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800111:	00 
  800112:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  800119:	00 
  80011a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800121:	00 
  800122:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  800129:	e8 28 17 00 00       	call   801856 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80012e:	83 c4 2c             	add    $0x2c,%esp
  800131:	5b                   	pop    %ebx
  800132:	5e                   	pop    %esi
  800133:	5f                   	pop    %edi
  800134:	5d                   	pop    %ebp
  800135:	c3                   	ret    

00800136 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	57                   	push   %edi
  80013a:	56                   	push   %esi
  80013b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80013c:	ba 00 00 00 00       	mov    $0x0,%edx
  800141:	b8 02 00 00 00       	mov    $0x2,%eax
  800146:	89 d1                	mov    %edx,%ecx
  800148:	89 d3                	mov    %edx,%ebx
  80014a:	89 d7                	mov    %edx,%edi
  80014c:	89 d6                	mov    %edx,%esi
  80014e:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800150:	5b                   	pop    %ebx
  800151:	5e                   	pop    %esi
  800152:	5f                   	pop    %edi
  800153:	5d                   	pop    %ebp
  800154:	c3                   	ret    

00800155 <sys_yield>:

void
sys_yield(void)
{
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	57                   	push   %edi
  800159:	56                   	push   %esi
  80015a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80015b:	ba 00 00 00 00       	mov    $0x0,%edx
  800160:	b8 0b 00 00 00       	mov    $0xb,%eax
  800165:	89 d1                	mov    %edx,%ecx
  800167:	89 d3                	mov    %edx,%ebx
  800169:	89 d7                	mov    %edx,%edi
  80016b:	89 d6                	mov    %edx,%esi
  80016d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80016f:	5b                   	pop    %ebx
  800170:	5e                   	pop    %esi
  800171:	5f                   	pop    %edi
  800172:	5d                   	pop    %ebp
  800173:	c3                   	ret    

00800174 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	57                   	push   %edi
  800178:	56                   	push   %esi
  800179:	53                   	push   %ebx
  80017a:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80017d:	be 00 00 00 00       	mov    $0x0,%esi
  800182:	b8 04 00 00 00       	mov    $0x4,%eax
  800187:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80018a:	8b 55 08             	mov    0x8(%ebp),%edx
  80018d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800190:	89 f7                	mov    %esi,%edi
  800192:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800194:	85 c0                	test   %eax,%eax
  800196:	7e 28                	jle    8001c0 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800198:	89 44 24 10          	mov    %eax,0x10(%esp)
  80019c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8001a3:	00 
  8001a4:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  8001ab:	00 
  8001ac:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001b3:	00 
  8001b4:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  8001bb:	e8 96 16 00 00       	call   801856 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001c0:	83 c4 2c             	add    $0x2c,%esp
  8001c3:	5b                   	pop    %ebx
  8001c4:	5e                   	pop    %esi
  8001c5:	5f                   	pop    %edi
  8001c6:	5d                   	pop    %ebp
  8001c7:	c3                   	ret    

008001c8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	57                   	push   %edi
  8001cc:	56                   	push   %esi
  8001cd:	53                   	push   %ebx
  8001ce:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001d1:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001df:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001e2:	8b 75 18             	mov    0x18(%ebp),%esi
  8001e5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001e7:	85 c0                	test   %eax,%eax
  8001e9:	7e 28                	jle    800213 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001eb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001ef:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8001f6:	00 
  8001f7:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  8001fe:	00 
  8001ff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800206:	00 
  800207:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  80020e:	e8 43 16 00 00       	call   801856 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800213:	83 c4 2c             	add    $0x2c,%esp
  800216:	5b                   	pop    %ebx
  800217:	5e                   	pop    %esi
  800218:	5f                   	pop    %edi
  800219:	5d                   	pop    %ebp
  80021a:	c3                   	ret    

0080021b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80021b:	55                   	push   %ebp
  80021c:	89 e5                	mov    %esp,%ebp
  80021e:	57                   	push   %edi
  80021f:	56                   	push   %esi
  800220:	53                   	push   %ebx
  800221:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800224:	bb 00 00 00 00       	mov    $0x0,%ebx
  800229:	b8 06 00 00 00       	mov    $0x6,%eax
  80022e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800231:	8b 55 08             	mov    0x8(%ebp),%edx
  800234:	89 df                	mov    %ebx,%edi
  800236:	89 de                	mov    %ebx,%esi
  800238:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80023a:	85 c0                	test   %eax,%eax
  80023c:	7e 28                	jle    800266 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80023e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800242:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800249:	00 
  80024a:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  800251:	00 
  800252:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800259:	00 
  80025a:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  800261:	e8 f0 15 00 00       	call   801856 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800266:	83 c4 2c             	add    $0x2c,%esp
  800269:	5b                   	pop    %ebx
  80026a:	5e                   	pop    %esi
  80026b:	5f                   	pop    %edi
  80026c:	5d                   	pop    %ebp
  80026d:	c3                   	ret    

0080026e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	57                   	push   %edi
  800272:	56                   	push   %esi
  800273:	53                   	push   %ebx
  800274:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800277:	bb 00 00 00 00       	mov    $0x0,%ebx
  80027c:	b8 08 00 00 00       	mov    $0x8,%eax
  800281:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800284:	8b 55 08             	mov    0x8(%ebp),%edx
  800287:	89 df                	mov    %ebx,%edi
  800289:	89 de                	mov    %ebx,%esi
  80028b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80028d:	85 c0                	test   %eax,%eax
  80028f:	7e 28                	jle    8002b9 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800291:	89 44 24 10          	mov    %eax,0x10(%esp)
  800295:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80029c:	00 
  80029d:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  8002a4:	00 
  8002a5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002ac:	00 
  8002ad:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  8002b4:	e8 9d 15 00 00       	call   801856 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002b9:	83 c4 2c             	add    $0x2c,%esp
  8002bc:	5b                   	pop    %ebx
  8002bd:	5e                   	pop    %esi
  8002be:	5f                   	pop    %edi
  8002bf:	5d                   	pop    %ebp
  8002c0:	c3                   	ret    

008002c1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	57                   	push   %edi
  8002c5:	56                   	push   %esi
  8002c6:	53                   	push   %ebx
  8002c7:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002cf:	b8 09 00 00 00       	mov    $0x9,%eax
  8002d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002da:	89 df                	mov    %ebx,%edi
  8002dc:	89 de                	mov    %ebx,%esi
  8002de:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002e0:	85 c0                	test   %eax,%eax
  8002e2:	7e 28                	jle    80030c <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002e8:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8002ef:	00 
  8002f0:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  8002f7:	00 
  8002f8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002ff:	00 
  800300:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  800307:	e8 4a 15 00 00       	call   801856 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80030c:	83 c4 2c             	add    $0x2c,%esp
  80030f:	5b                   	pop    %ebx
  800310:	5e                   	pop    %esi
  800311:	5f                   	pop    %edi
  800312:	5d                   	pop    %ebp
  800313:	c3                   	ret    

00800314 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800314:	55                   	push   %ebp
  800315:	89 e5                	mov    %esp,%ebp
  800317:	57                   	push   %edi
  800318:	56                   	push   %esi
  800319:	53                   	push   %ebx
  80031a:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80031d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800322:	b8 0a 00 00 00       	mov    $0xa,%eax
  800327:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80032a:	8b 55 08             	mov    0x8(%ebp),%edx
  80032d:	89 df                	mov    %ebx,%edi
  80032f:	89 de                	mov    %ebx,%esi
  800331:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800333:	85 c0                	test   %eax,%eax
  800335:	7e 28                	jle    80035f <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800337:	89 44 24 10          	mov    %eax,0x10(%esp)
  80033b:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800342:	00 
  800343:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  80034a:	00 
  80034b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800352:	00 
  800353:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  80035a:	e8 f7 14 00 00       	call   801856 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80035f:	83 c4 2c             	add    $0x2c,%esp
  800362:	5b                   	pop    %ebx
  800363:	5e                   	pop    %esi
  800364:	5f                   	pop    %edi
  800365:	5d                   	pop    %ebp
  800366:	c3                   	ret    

00800367 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	57                   	push   %edi
  80036b:	56                   	push   %esi
  80036c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80036d:	be 00 00 00 00       	mov    $0x0,%esi
  800372:	b8 0c 00 00 00       	mov    $0xc,%eax
  800377:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80037a:	8b 55 08             	mov    0x8(%ebp),%edx
  80037d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800380:	8b 7d 14             	mov    0x14(%ebp),%edi
  800383:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800385:	5b                   	pop    %ebx
  800386:	5e                   	pop    %esi
  800387:	5f                   	pop    %edi
  800388:	5d                   	pop    %ebp
  800389:	c3                   	ret    

0080038a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80038a:	55                   	push   %ebp
  80038b:	89 e5                	mov    %esp,%ebp
  80038d:	57                   	push   %edi
  80038e:	56                   	push   %esi
  80038f:	53                   	push   %ebx
  800390:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800393:	b9 00 00 00 00       	mov    $0x0,%ecx
  800398:	b8 0d 00 00 00       	mov    $0xd,%eax
  80039d:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a0:	89 cb                	mov    %ecx,%ebx
  8003a2:	89 cf                	mov    %ecx,%edi
  8003a4:	89 ce                	mov    %ecx,%esi
  8003a6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	7e 28                	jle    8003d4 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003b0:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8003b7:	00 
  8003b8:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  8003bf:	00 
  8003c0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003c7:	00 
  8003c8:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  8003cf:	e8 82 14 00 00       	call   801856 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8003d4:	83 c4 2c             	add    $0x2c,%esp
  8003d7:	5b                   	pop    %ebx
  8003d8:	5e                   	pop    %esi
  8003d9:	5f                   	pop    %edi
  8003da:	5d                   	pop    %ebp
  8003db:	c3                   	ret    

008003dc <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	57                   	push   %edi
  8003e0:	56                   	push   %esi
  8003e1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e7:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003ec:	89 d1                	mov    %edx,%ecx
  8003ee:	89 d3                	mov    %edx,%ebx
  8003f0:	89 d7                	mov    %edx,%edi
  8003f2:	89 d6                	mov    %edx,%esi
  8003f4:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003f6:	5b                   	pop    %ebx
  8003f7:	5e                   	pop    %esi
  8003f8:	5f                   	pop    %edi
  8003f9:	5d                   	pop    %ebp
  8003fa:	c3                   	ret    

008003fb <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
  8003fe:	57                   	push   %edi
  8003ff:	56                   	push   %esi
  800400:	53                   	push   %ebx
  800401:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800404:	bb 00 00 00 00       	mov    $0x0,%ebx
  800409:	b8 0f 00 00 00       	mov    $0xf,%eax
  80040e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800411:	8b 55 08             	mov    0x8(%ebp),%edx
  800414:	89 df                	mov    %ebx,%edi
  800416:	89 de                	mov    %ebx,%esi
  800418:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80041a:	85 c0                	test   %eax,%eax
  80041c:	7e 28                	jle    800446 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80041e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800422:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800429:	00 
  80042a:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  800431:	00 
  800432:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800439:	00 
  80043a:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  800441:	e8 10 14 00 00       	call   801856 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800446:	83 c4 2c             	add    $0x2c,%esp
  800449:	5b                   	pop    %ebx
  80044a:	5e                   	pop    %esi
  80044b:	5f                   	pop    %edi
  80044c:	5d                   	pop    %ebp
  80044d:	c3                   	ret    

0080044e <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
  800451:	57                   	push   %edi
  800452:	56                   	push   %esi
  800453:	53                   	push   %ebx
  800454:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800457:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045c:	b8 10 00 00 00       	mov    $0x10,%eax
  800461:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800464:	8b 55 08             	mov    0x8(%ebp),%edx
  800467:	89 df                	mov    %ebx,%edi
  800469:	89 de                	mov    %ebx,%esi
  80046b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80046d:	85 c0                	test   %eax,%eax
  80046f:	7e 28                	jle    800499 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800471:	89 44 24 10          	mov    %eax,0x10(%esp)
  800475:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80047c:	00 
  80047d:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  800484:	00 
  800485:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80048c:	00 
  80048d:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  800494:	e8 bd 13 00 00       	call   801856 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  800499:	83 c4 2c             	add    $0x2c,%esp
  80049c:	5b                   	pop    %ebx
  80049d:	5e                   	pop    %esi
  80049e:	5f                   	pop    %edi
  80049f:	5d                   	pop    %ebp
  8004a0:	c3                   	ret    

008004a1 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  8004a1:	55                   	push   %ebp
  8004a2:	89 e5                	mov    %esp,%ebp
  8004a4:	57                   	push   %edi
  8004a5:	56                   	push   %esi
  8004a6:	53                   	push   %ebx
  8004a7:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004af:	b8 11 00 00 00       	mov    $0x11,%eax
  8004b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ba:	89 df                	mov    %ebx,%edi
  8004bc:	89 de                	mov    %ebx,%esi
  8004be:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8004c0:	85 c0                	test   %eax,%eax
  8004c2:	7e 28                	jle    8004ec <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8004c4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004c8:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  8004cf:	00 
  8004d0:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  8004d7:	00 
  8004d8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004df:	00 
  8004e0:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  8004e7:	e8 6a 13 00 00       	call   801856 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  8004ec:	83 c4 2c             	add    $0x2c,%esp
  8004ef:	5b                   	pop    %ebx
  8004f0:	5e                   	pop    %esi
  8004f1:	5f                   	pop    %edi
  8004f2:	5d                   	pop    %ebp
  8004f3:	c3                   	ret    

008004f4 <sys_sleep>:

int
sys_sleep(int channel)
{
  8004f4:	55                   	push   %ebp
  8004f5:	89 e5                	mov    %esp,%ebp
  8004f7:	57                   	push   %edi
  8004f8:	56                   	push   %esi
  8004f9:	53                   	push   %ebx
  8004fa:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800502:	b8 12 00 00 00       	mov    $0x12,%eax
  800507:	8b 55 08             	mov    0x8(%ebp),%edx
  80050a:	89 cb                	mov    %ecx,%ebx
  80050c:	89 cf                	mov    %ecx,%edi
  80050e:	89 ce                	mov    %ecx,%esi
  800510:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800512:	85 c0                	test   %eax,%eax
  800514:	7e 28                	jle    80053e <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800516:	89 44 24 10          	mov    %eax,0x10(%esp)
  80051a:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800521:	00 
  800522:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  800529:	00 
  80052a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800531:	00 
  800532:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  800539:	e8 18 13 00 00       	call   801856 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80053e:	83 c4 2c             	add    $0x2c,%esp
  800541:	5b                   	pop    %ebx
  800542:	5e                   	pop    %esi
  800543:	5f                   	pop    %edi
  800544:	5d                   	pop    %ebp
  800545:	c3                   	ret    

00800546 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  800546:	55                   	push   %ebp
  800547:	89 e5                	mov    %esp,%ebp
  800549:	57                   	push   %edi
  80054a:	56                   	push   %esi
  80054b:	53                   	push   %ebx
  80054c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80054f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800554:	b8 13 00 00 00       	mov    $0x13,%eax
  800559:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80055c:	8b 55 08             	mov    0x8(%ebp),%edx
  80055f:	89 df                	mov    %ebx,%edi
  800561:	89 de                	mov    %ebx,%esi
  800563:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800565:	85 c0                	test   %eax,%eax
  800567:	7e 28                	jle    800591 <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800569:	89 44 24 10          	mov    %eax,0x10(%esp)
  80056d:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  800574:	00 
  800575:	c7 44 24 08 aa 26 80 	movl   $0x8026aa,0x8(%esp)
  80057c:	00 
  80057d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800584:	00 
  800585:	c7 04 24 c7 26 80 00 	movl   $0x8026c7,(%esp)
  80058c:	e8 c5 12 00 00       	call   801856 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  800591:	83 c4 2c             	add    $0x2c,%esp
  800594:	5b                   	pop    %ebx
  800595:	5e                   	pop    %esi
  800596:	5f                   	pop    %edi
  800597:	5d                   	pop    %ebp
  800598:	c3                   	ret    
  800599:	66 90                	xchg   %ax,%ax
  80059b:	66 90                	xchg   %ax,%ax
  80059d:	66 90                	xchg   %ax,%ax
  80059f:	90                   	nop

008005a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8005ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8005ae:	5d                   	pop    %ebp
  8005af:	c3                   	ret    

008005b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8005b0:	55                   	push   %ebp
  8005b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8005bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8005c5:	5d                   	pop    %ebp
  8005c6:	c3                   	ret    

008005c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005d2:	89 c2                	mov    %eax,%edx
  8005d4:	c1 ea 16             	shr    $0x16,%edx
  8005d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8005de:	f6 c2 01             	test   $0x1,%dl
  8005e1:	74 11                	je     8005f4 <fd_alloc+0x2d>
  8005e3:	89 c2                	mov    %eax,%edx
  8005e5:	c1 ea 0c             	shr    $0xc,%edx
  8005e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8005ef:	f6 c2 01             	test   $0x1,%dl
  8005f2:	75 09                	jne    8005fd <fd_alloc+0x36>
			*fd_store = fd;
  8005f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8005f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005fb:	eb 17                	jmp    800614 <fd_alloc+0x4d>
  8005fd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800602:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800607:	75 c9                	jne    8005d2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800609:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80060f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800614:	5d                   	pop    %ebp
  800615:	c3                   	ret    

00800616 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80061c:	83 f8 1f             	cmp    $0x1f,%eax
  80061f:	77 36                	ja     800657 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800621:	c1 e0 0c             	shl    $0xc,%eax
  800624:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800629:	89 c2                	mov    %eax,%edx
  80062b:	c1 ea 16             	shr    $0x16,%edx
  80062e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800635:	f6 c2 01             	test   $0x1,%dl
  800638:	74 24                	je     80065e <fd_lookup+0x48>
  80063a:	89 c2                	mov    %eax,%edx
  80063c:	c1 ea 0c             	shr    $0xc,%edx
  80063f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800646:	f6 c2 01             	test   $0x1,%dl
  800649:	74 1a                	je     800665 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80064b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80064e:	89 02                	mov    %eax,(%edx)
	return 0;
  800650:	b8 00 00 00 00       	mov    $0x0,%eax
  800655:	eb 13                	jmp    80066a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800657:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80065c:	eb 0c                	jmp    80066a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80065e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800663:	eb 05                	jmp    80066a <fd_lookup+0x54>
  800665:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80066a:	5d                   	pop    %ebp
  80066b:	c3                   	ret    

0080066c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80066c:	55                   	push   %ebp
  80066d:	89 e5                	mov    %esp,%ebp
  80066f:	83 ec 18             	sub    $0x18,%esp
  800672:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800675:	ba 00 00 00 00       	mov    $0x0,%edx
  80067a:	eb 13                	jmp    80068f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80067c:	39 08                	cmp    %ecx,(%eax)
  80067e:	75 0c                	jne    80068c <dev_lookup+0x20>
			*dev = devtab[i];
  800680:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800683:	89 01                	mov    %eax,(%ecx)
			return 0;
  800685:	b8 00 00 00 00       	mov    $0x0,%eax
  80068a:	eb 38                	jmp    8006c4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80068c:	83 c2 01             	add    $0x1,%edx
  80068f:	8b 04 95 54 27 80 00 	mov    0x802754(,%edx,4),%eax
  800696:	85 c0                	test   %eax,%eax
  800698:	75 e2                	jne    80067c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80069a:	a1 08 40 80 00       	mov    0x804008,%eax
  80069f:	8b 40 48             	mov    0x48(%eax),%eax
  8006a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006aa:	c7 04 24 d8 26 80 00 	movl   $0x8026d8,(%esp)
  8006b1:	e8 99 12 00 00       	call   80194f <cprintf>
	*dev = 0;
  8006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8006bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8006c4:	c9                   	leave  
  8006c5:	c3                   	ret    

008006c6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006c6:	55                   	push   %ebp
  8006c7:	89 e5                	mov    %esp,%ebp
  8006c9:	56                   	push   %esi
  8006ca:	53                   	push   %ebx
  8006cb:	83 ec 20             	sub    $0x20,%esp
  8006ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006d7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8006db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8006e1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006e4:	89 04 24             	mov    %eax,(%esp)
  8006e7:	e8 2a ff ff ff       	call   800616 <fd_lookup>
  8006ec:	85 c0                	test   %eax,%eax
  8006ee:	78 05                	js     8006f5 <fd_close+0x2f>
	    || fd != fd2)
  8006f0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8006f3:	74 0c                	je     800701 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8006f5:	84 db                	test   %bl,%bl
  8006f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fc:	0f 44 c2             	cmove  %edx,%eax
  8006ff:	eb 3f                	jmp    800740 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800701:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800704:	89 44 24 04          	mov    %eax,0x4(%esp)
  800708:	8b 06                	mov    (%esi),%eax
  80070a:	89 04 24             	mov    %eax,(%esp)
  80070d:	e8 5a ff ff ff       	call   80066c <dev_lookup>
  800712:	89 c3                	mov    %eax,%ebx
  800714:	85 c0                	test   %eax,%eax
  800716:	78 16                	js     80072e <fd_close+0x68>
		if (dev->dev_close)
  800718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80071e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800723:	85 c0                	test   %eax,%eax
  800725:	74 07                	je     80072e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800727:	89 34 24             	mov    %esi,(%esp)
  80072a:	ff d0                	call   *%eax
  80072c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80072e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800732:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800739:	e8 dd fa ff ff       	call   80021b <sys_page_unmap>
	return r;
  80073e:	89 d8                	mov    %ebx,%eax
}
  800740:	83 c4 20             	add    $0x20,%esp
  800743:	5b                   	pop    %ebx
  800744:	5e                   	pop    %esi
  800745:	5d                   	pop    %ebp
  800746:	c3                   	ret    

00800747 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800747:	55                   	push   %ebp
  800748:	89 e5                	mov    %esp,%ebp
  80074a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80074d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800750:	89 44 24 04          	mov    %eax,0x4(%esp)
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	89 04 24             	mov    %eax,(%esp)
  80075a:	e8 b7 fe ff ff       	call   800616 <fd_lookup>
  80075f:	89 c2                	mov    %eax,%edx
  800761:	85 d2                	test   %edx,%edx
  800763:	78 13                	js     800778 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800765:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80076c:	00 
  80076d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800770:	89 04 24             	mov    %eax,(%esp)
  800773:	e8 4e ff ff ff       	call   8006c6 <fd_close>
}
  800778:	c9                   	leave  
  800779:	c3                   	ret    

0080077a <close_all>:

void
close_all(void)
{
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	53                   	push   %ebx
  80077e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800781:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800786:	89 1c 24             	mov    %ebx,(%esp)
  800789:	e8 b9 ff ff ff       	call   800747 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80078e:	83 c3 01             	add    $0x1,%ebx
  800791:	83 fb 20             	cmp    $0x20,%ebx
  800794:	75 f0                	jne    800786 <close_all+0xc>
		close(i);
}
  800796:	83 c4 14             	add    $0x14,%esp
  800799:	5b                   	pop    %ebx
  80079a:	5d                   	pop    %ebp
  80079b:	c3                   	ret    

0080079c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	57                   	push   %edi
  8007a0:	56                   	push   %esi
  8007a1:	53                   	push   %ebx
  8007a2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8007a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8007a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	89 04 24             	mov    %eax,(%esp)
  8007b2:	e8 5f fe ff ff       	call   800616 <fd_lookup>
  8007b7:	89 c2                	mov    %eax,%edx
  8007b9:	85 d2                	test   %edx,%edx
  8007bb:	0f 88 e1 00 00 00    	js     8008a2 <dup+0x106>
		return r;
	close(newfdnum);
  8007c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c4:	89 04 24             	mov    %eax,(%esp)
  8007c7:	e8 7b ff ff ff       	call   800747 <close>

	newfd = INDEX2FD(newfdnum);
  8007cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007cf:	c1 e3 0c             	shl    $0xc,%ebx
  8007d2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8007d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007db:	89 04 24             	mov    %eax,(%esp)
  8007de:	e8 cd fd ff ff       	call   8005b0 <fd2data>
  8007e3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8007e5:	89 1c 24             	mov    %ebx,(%esp)
  8007e8:	e8 c3 fd ff ff       	call   8005b0 <fd2data>
  8007ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8007ef:	89 f0                	mov    %esi,%eax
  8007f1:	c1 e8 16             	shr    $0x16,%eax
  8007f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8007fb:	a8 01                	test   $0x1,%al
  8007fd:	74 43                	je     800842 <dup+0xa6>
  8007ff:	89 f0                	mov    %esi,%eax
  800801:	c1 e8 0c             	shr    $0xc,%eax
  800804:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80080b:	f6 c2 01             	test   $0x1,%dl
  80080e:	74 32                	je     800842 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800810:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800817:	25 07 0e 00 00       	and    $0xe07,%eax
  80081c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800820:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800824:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80082b:	00 
  80082c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800830:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800837:	e8 8c f9 ff ff       	call   8001c8 <sys_page_map>
  80083c:	89 c6                	mov    %eax,%esi
  80083e:	85 c0                	test   %eax,%eax
  800840:	78 3e                	js     800880 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800845:	89 c2                	mov    %eax,%edx
  800847:	c1 ea 0c             	shr    $0xc,%edx
  80084a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800851:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800857:	89 54 24 10          	mov    %edx,0x10(%esp)
  80085b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80085f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800866:	00 
  800867:	89 44 24 04          	mov    %eax,0x4(%esp)
  80086b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800872:	e8 51 f9 ff ff       	call   8001c8 <sys_page_map>
  800877:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  800879:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80087c:	85 f6                	test   %esi,%esi
  80087e:	79 22                	jns    8008a2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800880:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800884:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80088b:	e8 8b f9 ff ff       	call   80021b <sys_page_unmap>
	sys_page_unmap(0, nva);
  800890:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800894:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80089b:	e8 7b f9 ff ff       	call   80021b <sys_page_unmap>
	return r;
  8008a0:	89 f0                	mov    %esi,%eax
}
  8008a2:	83 c4 3c             	add    $0x3c,%esp
  8008a5:	5b                   	pop    %ebx
  8008a6:	5e                   	pop    %esi
  8008a7:	5f                   	pop    %edi
  8008a8:	5d                   	pop    %ebp
  8008a9:	c3                   	ret    

008008aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	53                   	push   %ebx
  8008ae:	83 ec 24             	sub    $0x24,%esp
  8008b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008bb:	89 1c 24             	mov    %ebx,(%esp)
  8008be:	e8 53 fd ff ff       	call   800616 <fd_lookup>
  8008c3:	89 c2                	mov    %eax,%edx
  8008c5:	85 d2                	test   %edx,%edx
  8008c7:	78 6d                	js     800936 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	89 04 24             	mov    %eax,(%esp)
  8008d8:	e8 8f fd ff ff       	call   80066c <dev_lookup>
  8008dd:	85 c0                	test   %eax,%eax
  8008df:	78 55                	js     800936 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8008e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e4:	8b 50 08             	mov    0x8(%eax),%edx
  8008e7:	83 e2 03             	and    $0x3,%edx
  8008ea:	83 fa 01             	cmp    $0x1,%edx
  8008ed:	75 23                	jne    800912 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8008ef:	a1 08 40 80 00       	mov    0x804008,%eax
  8008f4:	8b 40 48             	mov    0x48(%eax),%eax
  8008f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8008fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ff:	c7 04 24 19 27 80 00 	movl   $0x802719,(%esp)
  800906:	e8 44 10 00 00       	call   80194f <cprintf>
		return -E_INVAL;
  80090b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800910:	eb 24                	jmp    800936 <read+0x8c>
	}
	if (!dev->dev_read)
  800912:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800915:	8b 52 08             	mov    0x8(%edx),%edx
  800918:	85 d2                	test   %edx,%edx
  80091a:	74 15                	je     800931 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80091c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80091f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800923:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800926:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80092a:	89 04 24             	mov    %eax,(%esp)
  80092d:	ff d2                	call   *%edx
  80092f:	eb 05                	jmp    800936 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800931:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800936:	83 c4 24             	add    $0x24,%esp
  800939:	5b                   	pop    %ebx
  80093a:	5d                   	pop    %ebp
  80093b:	c3                   	ret    

0080093c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	57                   	push   %edi
  800940:	56                   	push   %esi
  800941:	53                   	push   %ebx
  800942:	83 ec 1c             	sub    $0x1c,%esp
  800945:	8b 7d 08             	mov    0x8(%ebp),%edi
  800948:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80094b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800950:	eb 23                	jmp    800975 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800952:	89 f0                	mov    %esi,%eax
  800954:	29 d8                	sub    %ebx,%eax
  800956:	89 44 24 08          	mov    %eax,0x8(%esp)
  80095a:	89 d8                	mov    %ebx,%eax
  80095c:	03 45 0c             	add    0xc(%ebp),%eax
  80095f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800963:	89 3c 24             	mov    %edi,(%esp)
  800966:	e8 3f ff ff ff       	call   8008aa <read>
		if (m < 0)
  80096b:	85 c0                	test   %eax,%eax
  80096d:	78 10                	js     80097f <readn+0x43>
			return m;
		if (m == 0)
  80096f:	85 c0                	test   %eax,%eax
  800971:	74 0a                	je     80097d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800973:	01 c3                	add    %eax,%ebx
  800975:	39 f3                	cmp    %esi,%ebx
  800977:	72 d9                	jb     800952 <readn+0x16>
  800979:	89 d8                	mov    %ebx,%eax
  80097b:	eb 02                	jmp    80097f <readn+0x43>
  80097d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80097f:	83 c4 1c             	add    $0x1c,%esp
  800982:	5b                   	pop    %ebx
  800983:	5e                   	pop    %esi
  800984:	5f                   	pop    %edi
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    

00800987 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	53                   	push   %ebx
  80098b:	83 ec 24             	sub    $0x24,%esp
  80098e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800991:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800994:	89 44 24 04          	mov    %eax,0x4(%esp)
  800998:	89 1c 24             	mov    %ebx,(%esp)
  80099b:	e8 76 fc ff ff       	call   800616 <fd_lookup>
  8009a0:	89 c2                	mov    %eax,%edx
  8009a2:	85 d2                	test   %edx,%edx
  8009a4:	78 68                	js     800a0e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	89 04 24             	mov    %eax,(%esp)
  8009b5:	e8 b2 fc ff ff       	call   80066c <dev_lookup>
  8009ba:	85 c0                	test   %eax,%eax
  8009bc:	78 50                	js     800a0e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8009c5:	75 23                	jne    8009ea <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8009c7:	a1 08 40 80 00       	mov    0x804008,%eax
  8009cc:	8b 40 48             	mov    0x48(%eax),%eax
  8009cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8009d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009d7:	c7 04 24 35 27 80 00 	movl   $0x802735,(%esp)
  8009de:	e8 6c 0f 00 00       	call   80194f <cprintf>
		return -E_INVAL;
  8009e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009e8:	eb 24                	jmp    800a0e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8009ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8009f0:	85 d2                	test   %edx,%edx
  8009f2:	74 15                	je     800a09 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8009f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8009fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a02:	89 04 24             	mov    %eax,(%esp)
  800a05:	ff d2                	call   *%edx
  800a07:	eb 05                	jmp    800a0e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800a09:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  800a0e:	83 c4 24             	add    $0x24,%esp
  800a11:	5b                   	pop    %ebx
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <seek>:

int
seek(int fdnum, off_t offset)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800a1a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	89 04 24             	mov    %eax,(%esp)
  800a27:	e8 ea fb ff ff       	call   800616 <fd_lookup>
  800a2c:	85 c0                	test   %eax,%eax
  800a2e:	78 0e                	js     800a3e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a36:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800a39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a3e:	c9                   	leave  
  800a3f:	c3                   	ret    

00800a40 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	53                   	push   %ebx
  800a44:	83 ec 24             	sub    $0x24,%esp
  800a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a4a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a51:	89 1c 24             	mov    %ebx,(%esp)
  800a54:	e8 bd fb ff ff       	call   800616 <fd_lookup>
  800a59:	89 c2                	mov    %eax,%edx
  800a5b:	85 d2                	test   %edx,%edx
  800a5d:	78 61                	js     800ac0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a62:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 00                	mov    (%eax),%eax
  800a6b:	89 04 24             	mov    %eax,(%esp)
  800a6e:	e8 f9 fb ff ff       	call   80066c <dev_lookup>
  800a73:	85 c0                	test   %eax,%eax
  800a75:	78 49                	js     800ac0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800a7e:	75 23                	jne    800aa3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800a80:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800a85:	8b 40 48             	mov    0x48(%eax),%eax
  800a88:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a90:	c7 04 24 f8 26 80 00 	movl   $0x8026f8,(%esp)
  800a97:	e8 b3 0e 00 00       	call   80194f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800a9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aa1:	eb 1d                	jmp    800ac0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  800aa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aa6:	8b 52 18             	mov    0x18(%edx),%edx
  800aa9:	85 d2                	test   %edx,%edx
  800aab:	74 0e                	je     800abb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800aad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ab4:	89 04 24             	mov    %eax,(%esp)
  800ab7:	ff d2                	call   *%edx
  800ab9:	eb 05                	jmp    800ac0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800abb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800ac0:	83 c4 24             	add    $0x24,%esp
  800ac3:	5b                   	pop    %ebx
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	53                   	push   %ebx
  800aca:	83 ec 24             	sub    $0x24,%esp
  800acd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ad0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	89 04 24             	mov    %eax,(%esp)
  800add:	e8 34 fb ff ff       	call   800616 <fd_lookup>
  800ae2:	89 c2                	mov    %eax,%edx
  800ae4:	85 d2                	test   %edx,%edx
  800ae6:	78 52                	js     800b3a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ae8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	89 04 24             	mov    %eax,(%esp)
  800af7:	e8 70 fb ff ff       	call   80066c <dev_lookup>
  800afc:	85 c0                	test   %eax,%eax
  800afe:	78 3a                	js     800b3a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b03:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800b07:	74 2c                	je     800b35 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800b09:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800b0c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800b13:	00 00 00 
	stat->st_isdir = 0;
  800b16:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b1d:	00 00 00 
	stat->st_dev = dev;
  800b20:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800b26:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800b2d:	89 14 24             	mov    %edx,(%esp)
  800b30:	ff 50 14             	call   *0x14(%eax)
  800b33:	eb 05                	jmp    800b3a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800b35:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800b3a:	83 c4 24             	add    $0x24,%esp
  800b3d:	5b                   	pop    %ebx
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	56                   	push   %esi
  800b44:	53                   	push   %ebx
  800b45:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800b48:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800b4f:	00 
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	89 04 24             	mov    %eax,(%esp)
  800b56:	e8 1b 02 00 00       	call   800d76 <open>
  800b5b:	89 c3                	mov    %eax,%ebx
  800b5d:	85 db                	test   %ebx,%ebx
  800b5f:	78 1b                	js     800b7c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b68:	89 1c 24             	mov    %ebx,(%esp)
  800b6b:	e8 56 ff ff ff       	call   800ac6 <fstat>
  800b70:	89 c6                	mov    %eax,%esi
	close(fd);
  800b72:	89 1c 24             	mov    %ebx,(%esp)
  800b75:	e8 cd fb ff ff       	call   800747 <close>
	return r;
  800b7a:	89 f0                	mov    %esi,%eax
}
  800b7c:	83 c4 10             	add    $0x10,%esp
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	56                   	push   %esi
  800b87:	53                   	push   %ebx
  800b88:	83 ec 10             	sub    $0x10,%esp
  800b8b:	89 c6                	mov    %eax,%esi
  800b8d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800b8f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800b96:	75 11                	jne    800ba9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800b98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800b9f:	e8 eb 17 00 00       	call   80238f <ipc_find_env>
  800ba4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800ba9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800bb0:	00 
  800bb1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800bb8:	00 
  800bb9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bbd:	a1 00 40 80 00       	mov    0x804000,%eax
  800bc2:	89 04 24             	mov    %eax,(%esp)
  800bc5:	e8 5a 17 00 00       	call   802324 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800bca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800bd1:	00 
  800bd2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800bd6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800bdd:	e8 ee 16 00 00       	call   8022d0 <ipc_recv>
}
  800be2:	83 c4 10             	add    $0x10,%esp
  800be5:	5b                   	pop    %ebx
  800be6:	5e                   	pop    %esi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  800bf5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800c02:	ba 00 00 00 00       	mov    $0x0,%edx
  800c07:	b8 02 00 00 00       	mov    $0x2,%eax
  800c0c:	e8 72 ff ff ff       	call   800b83 <fsipc>
}
  800c11:	c9                   	leave  
  800c12:	c3                   	ret    

00800c13 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8b 40 0c             	mov    0xc(%eax),%eax
  800c1f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800c24:	ba 00 00 00 00       	mov    $0x0,%edx
  800c29:	b8 06 00 00 00       	mov    $0x6,%eax
  800c2e:	e8 50 ff ff ff       	call   800b83 <fsipc>
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	53                   	push   %ebx
  800c39:	83 ec 14             	sub    $0x14,%esp
  800c3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8b 40 0c             	mov    0xc(%eax),%eax
  800c45:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4f:	b8 05 00 00 00       	mov    $0x5,%eax
  800c54:	e8 2a ff ff ff       	call   800b83 <fsipc>
  800c59:	89 c2                	mov    %eax,%edx
  800c5b:	85 d2                	test   %edx,%edx
  800c5d:	78 2b                	js     800c8a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800c5f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800c66:	00 
  800c67:	89 1c 24             	mov    %ebx,(%esp)
  800c6a:	e8 08 13 00 00       	call   801f77 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800c6f:	a1 80 50 80 00       	mov    0x805080,%eax
  800c74:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800c7a:	a1 84 50 80 00       	mov    0x805084,%eax
  800c7f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800c85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c8a:	83 c4 14             	add    $0x14,%esp
  800c8d:	5b                   	pop    %ebx
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	83 ec 18             	sub    $0x18,%esp
  800c96:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800c99:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9c:	8b 52 0c             	mov    0xc(%edx),%edx
  800c9f:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800ca5:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  800caa:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cb5:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  800cbc:	e8 bb 14 00 00       	call   80217c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  800cc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc6:	b8 04 00 00 00       	mov    $0x4,%eax
  800ccb:	e8 b3 fe ff ff       	call   800b83 <fsipc>
		return r;
	}

	return r;
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	83 ec 10             	sub    $0x10,%esp
  800cda:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 40 0c             	mov    0xc(%eax),%eax
  800ce3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ce8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800cee:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf3:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf8:	e8 86 fe ff ff       	call   800b83 <fsipc>
  800cfd:	89 c3                	mov    %eax,%ebx
  800cff:	85 c0                	test   %eax,%eax
  800d01:	78 6a                	js     800d6d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800d03:	39 c6                	cmp    %eax,%esi
  800d05:	73 24                	jae    800d2b <devfile_read+0x59>
  800d07:	c7 44 24 0c 68 27 80 	movl   $0x802768,0xc(%esp)
  800d0e:	00 
  800d0f:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  800d16:	00 
  800d17:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  800d1e:	00 
  800d1f:	c7 04 24 84 27 80 00 	movl   $0x802784,(%esp)
  800d26:	e8 2b 0b 00 00       	call   801856 <_panic>
	assert(r <= PGSIZE);
  800d2b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800d30:	7e 24                	jle    800d56 <devfile_read+0x84>
  800d32:	c7 44 24 0c 8f 27 80 	movl   $0x80278f,0xc(%esp)
  800d39:	00 
  800d3a:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  800d41:	00 
  800d42:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  800d49:	00 
  800d4a:	c7 04 24 84 27 80 00 	movl   $0x802784,(%esp)
  800d51:	e8 00 0b 00 00       	call   801856 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800d56:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d5a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800d61:	00 
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	89 04 24             	mov    %eax,(%esp)
  800d68:	e8 a7 13 00 00       	call   802114 <memmove>
	return r;
}
  800d6d:	89 d8                	mov    %ebx,%eax
  800d6f:	83 c4 10             	add    $0x10,%esp
  800d72:	5b                   	pop    %ebx
  800d73:	5e                   	pop    %esi
  800d74:	5d                   	pop    %ebp
  800d75:	c3                   	ret    

00800d76 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	53                   	push   %ebx
  800d7a:	83 ec 24             	sub    $0x24,%esp
  800d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800d80:	89 1c 24             	mov    %ebx,(%esp)
  800d83:	e8 b8 11 00 00       	call   801f40 <strlen>
  800d88:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800d8d:	7f 60                	jg     800def <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800d8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d92:	89 04 24             	mov    %eax,(%esp)
  800d95:	e8 2d f8 ff ff       	call   8005c7 <fd_alloc>
  800d9a:	89 c2                	mov    %eax,%edx
  800d9c:	85 d2                	test   %edx,%edx
  800d9e:	78 54                	js     800df4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800da0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800da4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800dab:	e8 c7 11 00 00       	call   801f77 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800db8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dbb:	b8 01 00 00 00       	mov    $0x1,%eax
  800dc0:	e8 be fd ff ff       	call   800b83 <fsipc>
  800dc5:	89 c3                	mov    %eax,%ebx
  800dc7:	85 c0                	test   %eax,%eax
  800dc9:	79 17                	jns    800de2 <open+0x6c>
		fd_close(fd, 0);
  800dcb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800dd2:	00 
  800dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dd6:	89 04 24             	mov    %eax,(%esp)
  800dd9:	e8 e8 f8 ff ff       	call   8006c6 <fd_close>
		return r;
  800dde:	89 d8                	mov    %ebx,%eax
  800de0:	eb 12                	jmp    800df4 <open+0x7e>
	}

	return fd2num(fd);
  800de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800de5:	89 04 24             	mov    %eax,(%esp)
  800de8:	e8 b3 f7 ff ff       	call   8005a0 <fd2num>
  800ded:	eb 05                	jmp    800df4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800def:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800df4:	83 c4 24             	add    $0x24,%esp
  800df7:	5b                   	pop    %ebx
  800df8:	5d                   	pop    %ebp
  800df9:	c3                   	ret    

00800dfa <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800e00:	ba 00 00 00 00       	mov    $0x0,%edx
  800e05:	b8 08 00 00 00       	mov    $0x8,%eax
  800e0a:	e8 74 fd ff ff       	call   800b83 <fsipc>
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    
  800e11:	66 90                	xchg   %ax,%ax
  800e13:	66 90                	xchg   %ax,%ax
  800e15:	66 90                	xchg   %ax,%ax
  800e17:	66 90                	xchg   %ax,%ax
  800e19:	66 90                	xchg   %ax,%ax
  800e1b:	66 90                	xchg   %ax,%ax
  800e1d:	66 90                	xchg   %ax,%ax
  800e1f:	90                   	nop

00800e20 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800e26:	c7 44 24 04 9b 27 80 	movl   $0x80279b,0x4(%esp)
  800e2d:	00 
  800e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e31:	89 04 24             	mov    %eax,(%esp)
  800e34:	e8 3e 11 00 00       	call   801f77 <strcpy>
	return 0;
}
  800e39:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	53                   	push   %ebx
  800e44:	83 ec 14             	sub    $0x14,%esp
  800e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800e4a:	89 1c 24             	mov    %ebx,(%esp)
  800e4d:	e8 7c 15 00 00       	call   8023ce <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  800e52:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  800e57:	83 f8 01             	cmp    $0x1,%eax
  800e5a:	75 0d                	jne    800e69 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  800e5c:	8b 43 0c             	mov    0xc(%ebx),%eax
  800e5f:	89 04 24             	mov    %eax,(%esp)
  800e62:	e8 29 03 00 00       	call   801190 <nsipc_close>
  800e67:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  800e69:	89 d0                	mov    %edx,%eax
  800e6b:	83 c4 14             	add    $0x14,%esp
  800e6e:	5b                   	pop    %ebx
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    

00800e71 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800e77:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800e7e:	00 
  800e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e82:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	8b 40 0c             	mov    0xc(%eax),%eax
  800e93:	89 04 24             	mov    %eax,(%esp)
  800e96:	e8 f0 03 00 00       	call   80128b <nsipc_send>
}
  800e9b:	c9                   	leave  
  800e9c:	c3                   	ret    

00800e9d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800ea3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800eaa:	00 
  800eab:	8b 45 10             	mov    0x10(%ebp),%eax
  800eae:	89 44 24 08          	mov    %eax,0x8(%esp)
  800eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8b 40 0c             	mov    0xc(%eax),%eax
  800ebf:	89 04 24             	mov    %eax,(%esp)
  800ec2:	e8 44 03 00 00       	call   80120b <nsipc_recv>
}
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800ecf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800ed2:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ed6:	89 04 24             	mov    %eax,(%esp)
  800ed9:	e8 38 f7 ff ff       	call   800616 <fd_lookup>
  800ede:	85 c0                	test   %eax,%eax
  800ee0:	78 17                	js     800ef9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800eeb:	39 08                	cmp    %ecx,(%eax)
  800eed:	75 05                	jne    800ef4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800eef:	8b 40 0c             	mov    0xc(%eax),%eax
  800ef2:	eb 05                	jmp    800ef9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  800ef4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	56                   	push   %esi
  800eff:	53                   	push   %ebx
  800f00:	83 ec 20             	sub    $0x20,%esp
  800f03:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800f05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f08:	89 04 24             	mov    %eax,(%esp)
  800f0b:	e8 b7 f6 ff ff       	call   8005c7 <fd_alloc>
  800f10:	89 c3                	mov    %eax,%ebx
  800f12:	85 c0                	test   %eax,%eax
  800f14:	78 21                	js     800f37 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800f16:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f1d:	00 
  800f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f21:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f2c:	e8 43 f2 ff ff       	call   800174 <sys_page_alloc>
  800f31:	89 c3                	mov    %eax,%ebx
  800f33:	85 c0                	test   %eax,%eax
  800f35:	79 0c                	jns    800f43 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  800f37:	89 34 24             	mov    %esi,(%esp)
  800f3a:	e8 51 02 00 00       	call   801190 <nsipc_close>
		return r;
  800f3f:	89 d8                	mov    %ebx,%eax
  800f41:	eb 20                	jmp    800f63 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800f43:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f4c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f51:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  800f58:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  800f5b:	89 14 24             	mov    %edx,(%esp)
  800f5e:	e8 3d f6 ff ff       	call   8005a0 <fd2num>
}
  800f63:	83 c4 20             	add    $0x20,%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    

00800f6a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	e8 51 ff ff ff       	call   800ec9 <fd2sockid>
		return r;
  800f78:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	78 23                	js     800fa1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f7e:	8b 55 10             	mov    0x10(%ebp),%edx
  800f81:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f88:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f8c:	89 04 24             	mov    %eax,(%esp)
  800f8f:	e8 45 01 00 00       	call   8010d9 <nsipc_accept>
		return r;
  800f94:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f96:	85 c0                	test   %eax,%eax
  800f98:	78 07                	js     800fa1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  800f9a:	e8 5c ff ff ff       	call   800efb <alloc_sockfd>
  800f9f:	89 c1                	mov    %eax,%ecx
}
  800fa1:	89 c8                	mov    %ecx,%eax
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    

00800fa5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	e8 16 ff ff ff       	call   800ec9 <fd2sockid>
  800fb3:	89 c2                	mov    %eax,%edx
  800fb5:	85 d2                	test   %edx,%edx
  800fb7:	78 16                	js     800fcf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fc7:	89 14 24             	mov    %edx,(%esp)
  800fca:	e8 60 01 00 00       	call   80112f <nsipc_bind>
}
  800fcf:	c9                   	leave  
  800fd0:	c3                   	ret    

00800fd1 <shutdown>:

int
shutdown(int s, int how)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	e8 ea fe ff ff       	call   800ec9 <fd2sockid>
  800fdf:	89 c2                	mov    %eax,%edx
  800fe1:	85 d2                	test   %edx,%edx
  800fe3:	78 0f                	js     800ff4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fec:	89 14 24             	mov    %edx,(%esp)
  800fef:	e8 7a 01 00 00       	call   80116e <nsipc_shutdown>
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	e8 c5 fe ff ff       	call   800ec9 <fd2sockid>
  801004:	89 c2                	mov    %eax,%edx
  801006:	85 d2                	test   %edx,%edx
  801008:	78 16                	js     801020 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80100a:	8b 45 10             	mov    0x10(%ebp),%eax
  80100d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801011:	8b 45 0c             	mov    0xc(%ebp),%eax
  801014:	89 44 24 04          	mov    %eax,0x4(%esp)
  801018:	89 14 24             	mov    %edx,(%esp)
  80101b:	e8 8a 01 00 00       	call   8011aa <nsipc_connect>
}
  801020:	c9                   	leave  
  801021:	c3                   	ret    

00801022 <listen>:

int
listen(int s, int backlog)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	e8 99 fe ff ff       	call   800ec9 <fd2sockid>
  801030:	89 c2                	mov    %eax,%edx
  801032:	85 d2                	test   %edx,%edx
  801034:	78 0f                	js     801045 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80103d:	89 14 24             	mov    %edx,(%esp)
  801040:	e8 a4 01 00 00       	call   8011e9 <nsipc_listen>
}
  801045:	c9                   	leave  
  801046:	c3                   	ret    

00801047 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80104d:	8b 45 10             	mov    0x10(%ebp),%eax
  801050:	89 44 24 08          	mov    %eax,0x8(%esp)
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	89 44 24 04          	mov    %eax,0x4(%esp)
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	89 04 24             	mov    %eax,(%esp)
  801061:	e8 98 02 00 00       	call   8012fe <nsipc_socket>
  801066:	89 c2                	mov    %eax,%edx
  801068:	85 d2                	test   %edx,%edx
  80106a:	78 05                	js     801071 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80106c:	e8 8a fe ff ff       	call   800efb <alloc_sockfd>
}
  801071:	c9                   	leave  
  801072:	c3                   	ret    

00801073 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	53                   	push   %ebx
  801077:	83 ec 14             	sub    $0x14,%esp
  80107a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80107c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801083:	75 11                	jne    801096 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801085:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80108c:	e8 fe 12 00 00       	call   80238f <ipc_find_env>
  801091:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801096:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80109d:	00 
  80109e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8010a5:	00 
  8010a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010aa:	a1 04 40 80 00       	mov    0x804004,%eax
  8010af:	89 04 24             	mov    %eax,(%esp)
  8010b2:	e8 6d 12 00 00       	call   802324 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8010b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010be:	00 
  8010bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8010c6:	00 
  8010c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010ce:	e8 fd 11 00 00       	call   8022d0 <ipc_recv>
}
  8010d3:	83 c4 14             	add    $0x14,%esp
  8010d6:	5b                   	pop    %ebx
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	56                   	push   %esi
  8010dd:	53                   	push   %ebx
  8010de:	83 ec 10             	sub    $0x10,%esp
  8010e1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8010ec:	8b 06                	mov    (%esi),%eax
  8010ee:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8010f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8010f8:	e8 76 ff ff ff       	call   801073 <nsipc>
  8010fd:	89 c3                	mov    %eax,%ebx
  8010ff:	85 c0                	test   %eax,%eax
  801101:	78 23                	js     801126 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801103:	a1 10 60 80 00       	mov    0x806010,%eax
  801108:	89 44 24 08          	mov    %eax,0x8(%esp)
  80110c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801113:	00 
  801114:	8b 45 0c             	mov    0xc(%ebp),%eax
  801117:	89 04 24             	mov    %eax,(%esp)
  80111a:	e8 f5 0f 00 00       	call   802114 <memmove>
		*addrlen = ret->ret_addrlen;
  80111f:	a1 10 60 80 00       	mov    0x806010,%eax
  801124:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801126:	89 d8                	mov    %ebx,%eax
  801128:	83 c4 10             	add    $0x10,%esp
  80112b:	5b                   	pop    %ebx
  80112c:	5e                   	pop    %esi
  80112d:	5d                   	pop    %ebp
  80112e:	c3                   	ret    

0080112f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	53                   	push   %ebx
  801133:	83 ec 14             	sub    $0x14,%esp
  801136:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801141:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	89 44 24 04          	mov    %eax,0x4(%esp)
  80114c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801153:	e8 bc 0f 00 00       	call   802114 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801158:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80115e:	b8 02 00 00 00       	mov    $0x2,%eax
  801163:	e8 0b ff ff ff       	call   801073 <nsipc>
}
  801168:	83 c4 14             	add    $0x14,%esp
  80116b:	5b                   	pop    %ebx
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801184:	b8 03 00 00 00       	mov    $0x3,%eax
  801189:	e8 e5 fe ff ff       	call   801073 <nsipc>
}
  80118e:	c9                   	leave  
  80118f:	c3                   	ret    

00801190 <nsipc_close>:

int
nsipc_close(int s)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80119e:	b8 04 00 00 00       	mov    $0x4,%eax
  8011a3:	e8 cb fe ff ff       	call   801073 <nsipc>
}
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	53                   	push   %ebx
  8011ae:	83 ec 14             	sub    $0x14,%esp
  8011b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8011bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011c7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8011ce:	e8 41 0f 00 00       	call   802114 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8011d3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8011d9:	b8 05 00 00 00       	mov    $0x5,%eax
  8011de:	e8 90 fe ff ff       	call   801073 <nsipc>
}
  8011e3:	83 c4 14             	add    $0x14,%esp
  8011e6:	5b                   	pop    %ebx
  8011e7:	5d                   	pop    %ebp
  8011e8:	c3                   	ret    

008011e9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8011ff:	b8 06 00 00 00       	mov    $0x6,%eax
  801204:	e8 6a fe ff ff       	call   801073 <nsipc>
}
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	56                   	push   %esi
  80120f:	53                   	push   %ebx
  801210:	83 ec 10             	sub    $0x10,%esp
  801213:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80121e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801224:	8b 45 14             	mov    0x14(%ebp),%eax
  801227:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80122c:	b8 07 00 00 00       	mov    $0x7,%eax
  801231:	e8 3d fe ff ff       	call   801073 <nsipc>
  801236:	89 c3                	mov    %eax,%ebx
  801238:	85 c0                	test   %eax,%eax
  80123a:	78 46                	js     801282 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80123c:	39 f0                	cmp    %esi,%eax
  80123e:	7f 07                	jg     801247 <nsipc_recv+0x3c>
  801240:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801245:	7e 24                	jle    80126b <nsipc_recv+0x60>
  801247:	c7 44 24 0c a7 27 80 	movl   $0x8027a7,0xc(%esp)
  80124e:	00 
  80124f:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  801256:	00 
  801257:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80125e:	00 
  80125f:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  801266:	e8 eb 05 00 00       	call   801856 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80126b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80126f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801276:	00 
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	89 04 24             	mov    %eax,(%esp)
  80127d:	e8 92 0e 00 00       	call   802114 <memmove>
	}

	return r;
}
  801282:	89 d8                	mov    %ebx,%eax
  801284:	83 c4 10             	add    $0x10,%esp
  801287:	5b                   	pop    %ebx
  801288:	5e                   	pop    %esi
  801289:	5d                   	pop    %ebp
  80128a:	c3                   	ret    

0080128b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	53                   	push   %ebx
  80128f:	83 ec 14             	sub    $0x14,%esp
  801292:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80129d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012a3:	7e 24                	jle    8012c9 <nsipc_send+0x3e>
  8012a5:	c7 44 24 0c c8 27 80 	movl   $0x8027c8,0xc(%esp)
  8012ac:	00 
  8012ad:	c7 44 24 08 6f 27 80 	movl   $0x80276f,0x8(%esp)
  8012b4:	00 
  8012b5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8012bc:	00 
  8012bd:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  8012c4:	e8 8d 05 00 00       	call   801856 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012d4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8012db:	e8 34 0e 00 00       	call   802114 <memmove>
	nsipcbuf.send.req_size = size;
  8012e0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8012e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8012ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8012f3:	e8 7b fd ff ff       	call   801073 <nsipc>
}
  8012f8:	83 c4 14             	add    $0x14,%esp
  8012fb:	5b                   	pop    %ebx
  8012fc:	5d                   	pop    %ebp
  8012fd:	c3                   	ret    

008012fe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801314:	8b 45 10             	mov    0x10(%ebp),%eax
  801317:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80131c:	b8 09 00 00 00       	mov    $0x9,%eax
  801321:	e8 4d fd ff ff       	call   801073 <nsipc>
}
  801326:	c9                   	leave  
  801327:	c3                   	ret    

00801328 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	56                   	push   %esi
  80132c:	53                   	push   %ebx
  80132d:	83 ec 10             	sub    $0x10,%esp
  801330:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	89 04 24             	mov    %eax,(%esp)
  801339:	e8 72 f2 ff ff       	call   8005b0 <fd2data>
  80133e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801340:	c7 44 24 04 d4 27 80 	movl   $0x8027d4,0x4(%esp)
  801347:	00 
  801348:	89 1c 24             	mov    %ebx,(%esp)
  80134b:	e8 27 0c 00 00       	call   801f77 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801350:	8b 46 04             	mov    0x4(%esi),%eax
  801353:	2b 06                	sub    (%esi),%eax
  801355:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80135b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801362:	00 00 00 
	stat->st_dev = &devpipe;
  801365:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80136c:	30 80 00 
	return 0;
}
  80136f:	b8 00 00 00 00       	mov    $0x0,%eax
  801374:	83 c4 10             	add    $0x10,%esp
  801377:	5b                   	pop    %ebx
  801378:	5e                   	pop    %esi
  801379:	5d                   	pop    %ebp
  80137a:	c3                   	ret    

0080137b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	53                   	push   %ebx
  80137f:	83 ec 14             	sub    $0x14,%esp
  801382:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801385:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801389:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801390:	e8 86 ee ff ff       	call   80021b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801395:	89 1c 24             	mov    %ebx,(%esp)
  801398:	e8 13 f2 ff ff       	call   8005b0 <fd2data>
  80139d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a8:	e8 6e ee ff ff       	call   80021b <sys_page_unmap>
}
  8013ad:	83 c4 14             	add    $0x14,%esp
  8013b0:	5b                   	pop    %ebx
  8013b1:	5d                   	pop    %ebp
  8013b2:	c3                   	ret    

008013b3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	57                   	push   %edi
  8013b7:	56                   	push   %esi
  8013b8:	53                   	push   %ebx
  8013b9:	83 ec 2c             	sub    $0x2c,%esp
  8013bc:	89 c6                	mov    %eax,%esi
  8013be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8013c1:	a1 08 40 80 00       	mov    0x804008,%eax
  8013c6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8013c9:	89 34 24             	mov    %esi,(%esp)
  8013cc:	e8 fd 0f 00 00       	call   8023ce <pageref>
  8013d1:	89 c7                	mov    %eax,%edi
  8013d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d6:	89 04 24             	mov    %eax,(%esp)
  8013d9:	e8 f0 0f 00 00       	call   8023ce <pageref>
  8013de:	39 c7                	cmp    %eax,%edi
  8013e0:	0f 94 c2             	sete   %dl
  8013e3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8013e6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  8013ec:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8013ef:	39 fb                	cmp    %edi,%ebx
  8013f1:	74 21                	je     801414 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8013f3:	84 d2                	test   %dl,%dl
  8013f5:	74 ca                	je     8013c1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8013f7:	8b 51 58             	mov    0x58(%ecx),%edx
  8013fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013fe:	89 54 24 08          	mov    %edx,0x8(%esp)
  801402:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801406:	c7 04 24 db 27 80 00 	movl   $0x8027db,(%esp)
  80140d:	e8 3d 05 00 00       	call   80194f <cprintf>
  801412:	eb ad                	jmp    8013c1 <_pipeisclosed+0xe>
	}
}
  801414:	83 c4 2c             	add    $0x2c,%esp
  801417:	5b                   	pop    %ebx
  801418:	5e                   	pop    %esi
  801419:	5f                   	pop    %edi
  80141a:	5d                   	pop    %ebp
  80141b:	c3                   	ret    

0080141c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	57                   	push   %edi
  801420:	56                   	push   %esi
  801421:	53                   	push   %ebx
  801422:	83 ec 1c             	sub    $0x1c,%esp
  801425:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801428:	89 34 24             	mov    %esi,(%esp)
  80142b:	e8 80 f1 ff ff       	call   8005b0 <fd2data>
  801430:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801432:	bf 00 00 00 00       	mov    $0x0,%edi
  801437:	eb 45                	jmp    80147e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801439:	89 da                	mov    %ebx,%edx
  80143b:	89 f0                	mov    %esi,%eax
  80143d:	e8 71 ff ff ff       	call   8013b3 <_pipeisclosed>
  801442:	85 c0                	test   %eax,%eax
  801444:	75 41                	jne    801487 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801446:	e8 0a ed ff ff       	call   800155 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80144b:	8b 43 04             	mov    0x4(%ebx),%eax
  80144e:	8b 0b                	mov    (%ebx),%ecx
  801450:	8d 51 20             	lea    0x20(%ecx),%edx
  801453:	39 d0                	cmp    %edx,%eax
  801455:	73 e2                	jae    801439 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801457:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80145e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801461:	99                   	cltd   
  801462:	c1 ea 1b             	shr    $0x1b,%edx
  801465:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801468:	83 e1 1f             	and    $0x1f,%ecx
  80146b:	29 d1                	sub    %edx,%ecx
  80146d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801471:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801475:	83 c0 01             	add    $0x1,%eax
  801478:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80147b:	83 c7 01             	add    $0x1,%edi
  80147e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801481:	75 c8                	jne    80144b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801483:	89 f8                	mov    %edi,%eax
  801485:	eb 05                	jmp    80148c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801487:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80148c:	83 c4 1c             	add    $0x1c,%esp
  80148f:	5b                   	pop    %ebx
  801490:	5e                   	pop    %esi
  801491:	5f                   	pop    %edi
  801492:	5d                   	pop    %ebp
  801493:	c3                   	ret    

00801494 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	57                   	push   %edi
  801498:	56                   	push   %esi
  801499:	53                   	push   %ebx
  80149a:	83 ec 1c             	sub    $0x1c,%esp
  80149d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8014a0:	89 3c 24             	mov    %edi,(%esp)
  8014a3:	e8 08 f1 ff ff       	call   8005b0 <fd2data>
  8014a8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014aa:	be 00 00 00 00       	mov    $0x0,%esi
  8014af:	eb 3d                	jmp    8014ee <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8014b1:	85 f6                	test   %esi,%esi
  8014b3:	74 04                	je     8014b9 <devpipe_read+0x25>
				return i;
  8014b5:	89 f0                	mov    %esi,%eax
  8014b7:	eb 43                	jmp    8014fc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8014b9:	89 da                	mov    %ebx,%edx
  8014bb:	89 f8                	mov    %edi,%eax
  8014bd:	e8 f1 fe ff ff       	call   8013b3 <_pipeisclosed>
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	75 31                	jne    8014f7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8014c6:	e8 8a ec ff ff       	call   800155 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8014cb:	8b 03                	mov    (%ebx),%eax
  8014cd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8014d0:	74 df                	je     8014b1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8014d2:	99                   	cltd   
  8014d3:	c1 ea 1b             	shr    $0x1b,%edx
  8014d6:	01 d0                	add    %edx,%eax
  8014d8:	83 e0 1f             	and    $0x1f,%eax
  8014db:	29 d0                	sub    %edx,%eax
  8014dd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8014e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8014e8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014eb:	83 c6 01             	add    $0x1,%esi
  8014ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8014f1:	75 d8                	jne    8014cb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8014f3:	89 f0                	mov    %esi,%eax
  8014f5:	eb 05                	jmp    8014fc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8014f7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8014fc:	83 c4 1c             	add    $0x1c,%esp
  8014ff:	5b                   	pop    %ebx
  801500:	5e                   	pop    %esi
  801501:	5f                   	pop    %edi
  801502:	5d                   	pop    %ebp
  801503:	c3                   	ret    

00801504 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	56                   	push   %esi
  801508:	53                   	push   %ebx
  801509:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80150c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150f:	89 04 24             	mov    %eax,(%esp)
  801512:	e8 b0 f0 ff ff       	call   8005c7 <fd_alloc>
  801517:	89 c2                	mov    %eax,%edx
  801519:	85 d2                	test   %edx,%edx
  80151b:	0f 88 4d 01 00 00    	js     80166e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801521:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801528:	00 
  801529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801530:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801537:	e8 38 ec ff ff       	call   800174 <sys_page_alloc>
  80153c:	89 c2                	mov    %eax,%edx
  80153e:	85 d2                	test   %edx,%edx
  801540:	0f 88 28 01 00 00    	js     80166e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801546:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801549:	89 04 24             	mov    %eax,(%esp)
  80154c:	e8 76 f0 ff ff       	call   8005c7 <fd_alloc>
  801551:	89 c3                	mov    %eax,%ebx
  801553:	85 c0                	test   %eax,%eax
  801555:	0f 88 fe 00 00 00    	js     801659 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80155b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801562:	00 
  801563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801566:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801571:	e8 fe eb ff ff       	call   800174 <sys_page_alloc>
  801576:	89 c3                	mov    %eax,%ebx
  801578:	85 c0                	test   %eax,%eax
  80157a:	0f 88 d9 00 00 00    	js     801659 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801583:	89 04 24             	mov    %eax,(%esp)
  801586:	e8 25 f0 ff ff       	call   8005b0 <fd2data>
  80158b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80158d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801594:	00 
  801595:	89 44 24 04          	mov    %eax,0x4(%esp)
  801599:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015a0:	e8 cf eb ff ff       	call   800174 <sys_page_alloc>
  8015a5:	89 c3                	mov    %eax,%ebx
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	0f 88 97 00 00 00    	js     801646 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b2:	89 04 24             	mov    %eax,(%esp)
  8015b5:	e8 f6 ef ff ff       	call   8005b0 <fd2data>
  8015ba:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8015c1:	00 
  8015c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015cd:	00 
  8015ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015d9:	e8 ea eb ff ff       	call   8001c8 <sys_page_map>
  8015de:	89 c3                	mov    %eax,%ebx
  8015e0:	85 c0                	test   %eax,%eax
  8015e2:	78 52                	js     801636 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8015e4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8015ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ed:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8015ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8015f9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8015ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801602:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801607:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80160e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801611:	89 04 24             	mov    %eax,(%esp)
  801614:	e8 87 ef ff ff       	call   8005a0 <fd2num>
  801619:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80161c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80161e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801621:	89 04 24             	mov    %eax,(%esp)
  801624:	e8 77 ef ff ff       	call   8005a0 <fd2num>
  801629:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80162c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80162f:	b8 00 00 00 00       	mov    $0x0,%eax
  801634:	eb 38                	jmp    80166e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801636:	89 74 24 04          	mov    %esi,0x4(%esp)
  80163a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801641:	e8 d5 eb ff ff       	call   80021b <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801649:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801654:	e8 c2 eb ff ff       	call   80021b <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801660:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801667:	e8 af eb ff ff       	call   80021b <sys_page_unmap>
  80166c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80166e:	83 c4 30             	add    $0x30,%esp
  801671:	5b                   	pop    %ebx
  801672:	5e                   	pop    %esi
  801673:	5d                   	pop    %ebp
  801674:	c3                   	ret    

00801675 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80167b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	89 04 24             	mov    %eax,(%esp)
  801688:	e8 89 ef ff ff       	call   800616 <fd_lookup>
  80168d:	89 c2                	mov    %eax,%edx
  80168f:	85 d2                	test   %edx,%edx
  801691:	78 15                	js     8016a8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801696:	89 04 24             	mov    %eax,(%esp)
  801699:	e8 12 ef ff ff       	call   8005b0 <fd2data>
	return _pipeisclosed(fd, p);
  80169e:	89 c2                	mov    %eax,%edx
  8016a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a3:	e8 0b fd ff ff       	call   8013b3 <_pipeisclosed>
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    
  8016aa:	66 90                	xchg   %ax,%ax
  8016ac:	66 90                	xchg   %ax,%ax
  8016ae:	66 90                	xchg   %ax,%ax

008016b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8016b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b8:	5d                   	pop    %ebp
  8016b9:	c3                   	ret    

008016ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8016c0:	c7 44 24 04 f3 27 80 	movl   $0x8027f3,0x4(%esp)
  8016c7:	00 
  8016c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cb:	89 04 24             	mov    %eax,(%esp)
  8016ce:	e8 a4 08 00 00       	call   801f77 <strcpy>
	return 0;
}
  8016d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	57                   	push   %edi
  8016de:	56                   	push   %esi
  8016df:	53                   	push   %ebx
  8016e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016e6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8016eb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016f1:	eb 31                	jmp    801724 <devcons_write+0x4a>
		m = n - tot;
  8016f3:	8b 75 10             	mov    0x10(%ebp),%esi
  8016f6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8016f8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8016fb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801700:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801703:	89 74 24 08          	mov    %esi,0x8(%esp)
  801707:	03 45 0c             	add    0xc(%ebp),%eax
  80170a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170e:	89 3c 24             	mov    %edi,(%esp)
  801711:	e8 fe 09 00 00       	call   802114 <memmove>
		sys_cputs(buf, m);
  801716:	89 74 24 04          	mov    %esi,0x4(%esp)
  80171a:	89 3c 24             	mov    %edi,(%esp)
  80171d:	e8 85 e9 ff ff       	call   8000a7 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801722:	01 f3                	add    %esi,%ebx
  801724:	89 d8                	mov    %ebx,%eax
  801726:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801729:	72 c8                	jb     8016f3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80172b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801731:	5b                   	pop    %ebx
  801732:	5e                   	pop    %esi
  801733:	5f                   	pop    %edi
  801734:	5d                   	pop    %ebp
  801735:	c3                   	ret    

00801736 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80173c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801741:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801745:	75 07                	jne    80174e <devcons_read+0x18>
  801747:	eb 2a                	jmp    801773 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801749:	e8 07 ea ff ff       	call   800155 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80174e:	66 90                	xchg   %ax,%ax
  801750:	e8 70 e9 ff ff       	call   8000c5 <sys_cgetc>
  801755:	85 c0                	test   %eax,%eax
  801757:	74 f0                	je     801749 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801759:	85 c0                	test   %eax,%eax
  80175b:	78 16                	js     801773 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80175d:	83 f8 04             	cmp    $0x4,%eax
  801760:	74 0c                	je     80176e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  801762:	8b 55 0c             	mov    0xc(%ebp),%edx
  801765:	88 02                	mov    %al,(%edx)
	return 1;
  801767:	b8 01 00 00 00       	mov    $0x1,%eax
  80176c:	eb 05                	jmp    801773 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801781:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801788:	00 
  801789:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80178c:	89 04 24             	mov    %eax,(%esp)
  80178f:	e8 13 e9 ff ff       	call   8000a7 <sys_cputs>
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <getchar>:

int
getchar(void)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80179c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8017a3:	00 
  8017a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8017a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017b2:	e8 f3 f0 ff ff       	call   8008aa <read>
	if (r < 0)
  8017b7:	85 c0                	test   %eax,%eax
  8017b9:	78 0f                	js     8017ca <getchar+0x34>
		return r;
	if (r < 1)
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	7e 06                	jle    8017c5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8017bf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8017c3:	eb 05                	jmp    8017ca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8017c5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	89 04 24             	mov    %eax,(%esp)
  8017df:	e8 32 ee ff ff       	call   800616 <fd_lookup>
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	78 11                	js     8017f9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8017e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017eb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8017f1:	39 10                	cmp    %edx,(%eax)
  8017f3:	0f 94 c0             	sete   %al
  8017f6:	0f b6 c0             	movzbl %al,%eax
}
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <opencons>:

int
opencons(void)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801801:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801804:	89 04 24             	mov    %eax,(%esp)
  801807:	e8 bb ed ff ff       	call   8005c7 <fd_alloc>
		return r;
  80180c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80180e:	85 c0                	test   %eax,%eax
  801810:	78 40                	js     801852 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801812:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801819:	00 
  80181a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801821:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801828:	e8 47 e9 ff ff       	call   800174 <sys_page_alloc>
		return r;
  80182d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80182f:	85 c0                	test   %eax,%eax
  801831:	78 1f                	js     801852 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801833:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80183e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801841:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801848:	89 04 24             	mov    %eax,(%esp)
  80184b:	e8 50 ed ff ff       	call   8005a0 <fd2num>
  801850:	89 c2                	mov    %eax,%edx
}
  801852:	89 d0                	mov    %edx,%eax
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	56                   	push   %esi
  80185a:	53                   	push   %ebx
  80185b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80185e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801861:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801867:	e8 ca e8 ff ff       	call   800136 <sys_getenvid>
  80186c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801873:	8b 55 08             	mov    0x8(%ebp),%edx
  801876:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80187a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80187e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801882:	c7 04 24 00 28 80 00 	movl   $0x802800,(%esp)
  801889:	e8 c1 00 00 00       	call   80194f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80188e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801892:	8b 45 10             	mov    0x10(%ebp),%eax
  801895:	89 04 24             	mov    %eax,(%esp)
  801898:	e8 51 00 00 00       	call   8018ee <vcprintf>
	cprintf("\n");
  80189d:	c7 04 24 ec 27 80 00 	movl   $0x8027ec,(%esp)
  8018a4:	e8 a6 00 00 00       	call   80194f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8018a9:	cc                   	int3   
  8018aa:	eb fd                	jmp    8018a9 <_panic+0x53>

008018ac <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	53                   	push   %ebx
  8018b0:	83 ec 14             	sub    $0x14,%esp
  8018b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8018b6:	8b 13                	mov    (%ebx),%edx
  8018b8:	8d 42 01             	lea    0x1(%edx),%eax
  8018bb:	89 03                	mov    %eax,(%ebx)
  8018bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8018c4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8018c9:	75 19                	jne    8018e4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8018cb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8018d2:	00 
  8018d3:	8d 43 08             	lea    0x8(%ebx),%eax
  8018d6:	89 04 24             	mov    %eax,(%esp)
  8018d9:	e8 c9 e7 ff ff       	call   8000a7 <sys_cputs>
		b->idx = 0;
  8018de:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8018e4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8018e8:	83 c4 14             	add    $0x14,%esp
  8018eb:	5b                   	pop    %ebx
  8018ec:	5d                   	pop    %ebp
  8018ed:	c3                   	ret    

008018ee <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8018f7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018fe:	00 00 00 
	b.cnt = 0;
  801901:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801908:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80190b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	89 44 24 08          	mov    %eax,0x8(%esp)
  801919:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80191f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801923:	c7 04 24 ac 18 80 00 	movl   $0x8018ac,(%esp)
  80192a:	e8 af 01 00 00       	call   801ade <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80192f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801935:	89 44 24 04          	mov    %eax,0x4(%esp)
  801939:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80193f:	89 04 24             	mov    %eax,(%esp)
  801942:	e8 60 e7 ff ff       	call   8000a7 <sys_cputs>

	return b.cnt;
}
  801947:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801955:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	89 04 24             	mov    %eax,(%esp)
  801962:	e8 87 ff ff ff       	call   8018ee <vcprintf>
	va_end(ap);

	return cnt;
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    
  801969:	66 90                	xchg   %ax,%ax
  80196b:	66 90                	xchg   %ax,%ax
  80196d:	66 90                	xchg   %ax,%ax
  80196f:	90                   	nop

00801970 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	57                   	push   %edi
  801974:	56                   	push   %esi
  801975:	53                   	push   %ebx
  801976:	83 ec 3c             	sub    $0x3c,%esp
  801979:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80197c:	89 d7                	mov    %edx,%edi
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801984:	8b 45 0c             	mov    0xc(%ebp),%eax
  801987:	89 c3                	mov    %eax,%ebx
  801989:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80198c:	8b 45 10             	mov    0x10(%ebp),%eax
  80198f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801992:	b9 00 00 00 00       	mov    $0x0,%ecx
  801997:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80199a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80199d:	39 d9                	cmp    %ebx,%ecx
  80199f:	72 05                	jb     8019a6 <printnum+0x36>
  8019a1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8019a4:	77 69                	ja     801a0f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8019a6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8019a9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8019ad:	83 ee 01             	sub    $0x1,%esi
  8019b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019bc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8019c0:	89 c3                	mov    %eax,%ebx
  8019c2:	89 d6                	mov    %edx,%esi
  8019c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8019ca:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019ce:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019d5:	89 04 24             	mov    %eax,(%esp)
  8019d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019df:	e8 2c 0a 00 00       	call   802410 <__udivdi3>
  8019e4:	89 d9                	mov    %ebx,%ecx
  8019e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019ea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019ee:	89 04 24             	mov    %eax,(%esp)
  8019f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019f5:	89 fa                	mov    %edi,%edx
  8019f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019fa:	e8 71 ff ff ff       	call   801970 <printnum>
  8019ff:	eb 1b                	jmp    801a1c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801a01:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a05:	8b 45 18             	mov    0x18(%ebp),%eax
  801a08:	89 04 24             	mov    %eax,(%esp)
  801a0b:	ff d3                	call   *%ebx
  801a0d:	eb 03                	jmp    801a12 <printnum+0xa2>
  801a0f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801a12:	83 ee 01             	sub    $0x1,%esi
  801a15:	85 f6                	test   %esi,%esi
  801a17:	7f e8                	jg     801a01 <printnum+0x91>
  801a19:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801a1c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a20:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801a24:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a27:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801a2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a2e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a35:	89 04 24             	mov    %eax,(%esp)
  801a38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3f:	e8 fc 0a 00 00       	call   802540 <__umoddi3>
  801a44:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a48:	0f be 80 23 28 80 00 	movsbl 0x802823(%eax),%eax
  801a4f:	89 04 24             	mov    %eax,(%esp)
  801a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a55:	ff d0                	call   *%eax
}
  801a57:	83 c4 3c             	add    $0x3c,%esp
  801a5a:	5b                   	pop    %ebx
  801a5b:	5e                   	pop    %esi
  801a5c:	5f                   	pop    %edi
  801a5d:	5d                   	pop    %ebp
  801a5e:	c3                   	ret    

00801a5f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a62:	83 fa 01             	cmp    $0x1,%edx
  801a65:	7e 0e                	jle    801a75 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801a67:	8b 10                	mov    (%eax),%edx
  801a69:	8d 4a 08             	lea    0x8(%edx),%ecx
  801a6c:	89 08                	mov    %ecx,(%eax)
  801a6e:	8b 02                	mov    (%edx),%eax
  801a70:	8b 52 04             	mov    0x4(%edx),%edx
  801a73:	eb 22                	jmp    801a97 <getuint+0x38>
	else if (lflag)
  801a75:	85 d2                	test   %edx,%edx
  801a77:	74 10                	je     801a89 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801a79:	8b 10                	mov    (%eax),%edx
  801a7b:	8d 4a 04             	lea    0x4(%edx),%ecx
  801a7e:	89 08                	mov    %ecx,(%eax)
  801a80:	8b 02                	mov    (%edx),%eax
  801a82:	ba 00 00 00 00       	mov    $0x0,%edx
  801a87:	eb 0e                	jmp    801a97 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801a89:	8b 10                	mov    (%eax),%edx
  801a8b:	8d 4a 04             	lea    0x4(%edx),%ecx
  801a8e:	89 08                	mov    %ecx,(%eax)
  801a90:	8b 02                	mov    (%edx),%eax
  801a92:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a97:	5d                   	pop    %ebp
  801a98:	c3                   	ret    

00801a99 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801a9f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801aa3:	8b 10                	mov    (%eax),%edx
  801aa5:	3b 50 04             	cmp    0x4(%eax),%edx
  801aa8:	73 0a                	jae    801ab4 <sprintputch+0x1b>
		*b->buf++ = ch;
  801aaa:	8d 4a 01             	lea    0x1(%edx),%ecx
  801aad:	89 08                	mov    %ecx,(%eax)
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	88 02                	mov    %al,(%edx)
}
  801ab4:	5d                   	pop    %ebp
  801ab5:	c3                   	ret    

00801ab6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801abc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801abf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ac3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	89 04 24             	mov    %eax,(%esp)
  801ad7:	e8 02 00 00 00       	call   801ade <vprintfmt>
	va_end(ap);
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	57                   	push   %edi
  801ae2:	56                   	push   %esi
  801ae3:	53                   	push   %ebx
  801ae4:	83 ec 3c             	sub    $0x3c,%esp
  801ae7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801aea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801aed:	eb 14                	jmp    801b03 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801aef:	85 c0                	test   %eax,%eax
  801af1:	0f 84 b3 03 00 00    	je     801eaa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  801af7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801afb:	89 04 24             	mov    %eax,(%esp)
  801afe:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b01:	89 f3                	mov    %esi,%ebx
  801b03:	8d 73 01             	lea    0x1(%ebx),%esi
  801b06:	0f b6 03             	movzbl (%ebx),%eax
  801b09:	83 f8 25             	cmp    $0x25,%eax
  801b0c:	75 e1                	jne    801aef <vprintfmt+0x11>
  801b0e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  801b12:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b19:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  801b20:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  801b27:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2c:	eb 1d                	jmp    801b4b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b2e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  801b30:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801b34:	eb 15                	jmp    801b4b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b36:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b38:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801b3c:	eb 0d                	jmp    801b4b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801b3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b41:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b44:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b4b:	8d 5e 01             	lea    0x1(%esi),%ebx
  801b4e:	0f b6 0e             	movzbl (%esi),%ecx
  801b51:	0f b6 c1             	movzbl %cl,%eax
  801b54:	83 e9 23             	sub    $0x23,%ecx
  801b57:	80 f9 55             	cmp    $0x55,%cl
  801b5a:	0f 87 2a 03 00 00    	ja     801e8a <vprintfmt+0x3ac>
  801b60:	0f b6 c9             	movzbl %cl,%ecx
  801b63:	ff 24 8d a0 29 80 00 	jmp    *0x8029a0(,%ecx,4)
  801b6a:	89 de                	mov    %ebx,%esi
  801b6c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801b71:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801b74:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801b78:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801b7b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  801b7e:	83 fb 09             	cmp    $0x9,%ebx
  801b81:	77 36                	ja     801bb9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b83:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b86:	eb e9                	jmp    801b71 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b88:	8b 45 14             	mov    0x14(%ebp),%eax
  801b8b:	8d 48 04             	lea    0x4(%eax),%ecx
  801b8e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801b91:	8b 00                	mov    (%eax),%eax
  801b93:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b96:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801b98:	eb 22                	jmp    801bbc <vprintfmt+0xde>
  801b9a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801b9d:	85 c9                	test   %ecx,%ecx
  801b9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba4:	0f 49 c1             	cmovns %ecx,%eax
  801ba7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801baa:	89 de                	mov    %ebx,%esi
  801bac:	eb 9d                	jmp    801b4b <vprintfmt+0x6d>
  801bae:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801bb0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  801bb7:	eb 92                	jmp    801b4b <vprintfmt+0x6d>
  801bb9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  801bbc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801bc0:	79 89                	jns    801b4b <vprintfmt+0x6d>
  801bc2:	e9 77 ff ff ff       	jmp    801b3e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801bc7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bca:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801bcc:	e9 7a ff ff ff       	jmp    801b4b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801bd1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd4:	8d 50 04             	lea    0x4(%eax),%edx
  801bd7:	89 55 14             	mov    %edx,0x14(%ebp)
  801bda:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801bde:	8b 00                	mov    (%eax),%eax
  801be0:	89 04 24             	mov    %eax,(%esp)
  801be3:	ff 55 08             	call   *0x8(%ebp)
			break;
  801be6:	e9 18 ff ff ff       	jmp    801b03 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801beb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bee:	8d 50 04             	lea    0x4(%eax),%edx
  801bf1:	89 55 14             	mov    %edx,0x14(%ebp)
  801bf4:	8b 00                	mov    (%eax),%eax
  801bf6:	99                   	cltd   
  801bf7:	31 d0                	xor    %edx,%eax
  801bf9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801bfb:	83 f8 12             	cmp    $0x12,%eax
  801bfe:	7f 0b                	jg     801c0b <vprintfmt+0x12d>
  801c00:	8b 14 85 00 2b 80 00 	mov    0x802b00(,%eax,4),%edx
  801c07:	85 d2                	test   %edx,%edx
  801c09:	75 20                	jne    801c2b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  801c0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c0f:	c7 44 24 08 3b 28 80 	movl   $0x80283b,0x8(%esp)
  801c16:	00 
  801c17:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	89 04 24             	mov    %eax,(%esp)
  801c21:	e8 90 fe ff ff       	call   801ab6 <printfmt>
  801c26:	e9 d8 fe ff ff       	jmp    801b03 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801c2b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c2f:	c7 44 24 08 81 27 80 	movl   $0x802781,0x8(%esp)
  801c36:	00 
  801c37:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	89 04 24             	mov    %eax,(%esp)
  801c41:	e8 70 fe ff ff       	call   801ab6 <printfmt>
  801c46:	e9 b8 fe ff ff       	jmp    801b03 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801c4b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801c4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c51:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c54:	8b 45 14             	mov    0x14(%ebp),%eax
  801c57:	8d 50 04             	lea    0x4(%eax),%edx
  801c5a:	89 55 14             	mov    %edx,0x14(%ebp)
  801c5d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  801c5f:	85 f6                	test   %esi,%esi
  801c61:	b8 34 28 80 00       	mov    $0x802834,%eax
  801c66:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  801c69:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  801c6d:	0f 84 97 00 00 00    	je     801d0a <vprintfmt+0x22c>
  801c73:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801c77:	0f 8e 9b 00 00 00    	jle    801d18 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c7d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c81:	89 34 24             	mov    %esi,(%esp)
  801c84:	e8 cf 02 00 00       	call   801f58 <strnlen>
  801c89:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801c8c:	29 c2                	sub    %eax,%edx
  801c8e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  801c91:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  801c95:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c98:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801c9b:	8b 75 08             	mov    0x8(%ebp),%esi
  801c9e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801ca1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801ca3:	eb 0f                	jmp    801cb4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  801ca5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ca9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cac:	89 04 24             	mov    %eax,(%esp)
  801caf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801cb1:	83 eb 01             	sub    $0x1,%ebx
  801cb4:	85 db                	test   %ebx,%ebx
  801cb6:	7f ed                	jg     801ca5 <vprintfmt+0x1c7>
  801cb8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801cbb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801cbe:	85 d2                	test   %edx,%edx
  801cc0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc5:	0f 49 c2             	cmovns %edx,%eax
  801cc8:	29 c2                	sub    %eax,%edx
  801cca:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801ccd:	89 d7                	mov    %edx,%edi
  801ccf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801cd2:	eb 50                	jmp    801d24 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801cd4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cd8:	74 1e                	je     801cf8 <vprintfmt+0x21a>
  801cda:	0f be d2             	movsbl %dl,%edx
  801cdd:	83 ea 20             	sub    $0x20,%edx
  801ce0:	83 fa 5e             	cmp    $0x5e,%edx
  801ce3:	76 13                	jbe    801cf8 <vprintfmt+0x21a>
					putch('?', putdat);
  801ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cec:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801cf3:	ff 55 08             	call   *0x8(%ebp)
  801cf6:	eb 0d                	jmp    801d05 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  801cf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfb:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cff:	89 04 24             	mov    %eax,(%esp)
  801d02:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801d05:	83 ef 01             	sub    $0x1,%edi
  801d08:	eb 1a                	jmp    801d24 <vprintfmt+0x246>
  801d0a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801d0d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801d10:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801d13:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801d16:	eb 0c                	jmp    801d24 <vprintfmt+0x246>
  801d18:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801d1b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801d1e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801d21:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801d24:	83 c6 01             	add    $0x1,%esi
  801d27:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801d2b:	0f be c2             	movsbl %dl,%eax
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	74 27                	je     801d59 <vprintfmt+0x27b>
  801d32:	85 db                	test   %ebx,%ebx
  801d34:	78 9e                	js     801cd4 <vprintfmt+0x1f6>
  801d36:	83 eb 01             	sub    $0x1,%ebx
  801d39:	79 99                	jns    801cd4 <vprintfmt+0x1f6>
  801d3b:	89 f8                	mov    %edi,%eax
  801d3d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d40:	8b 75 08             	mov    0x8(%ebp),%esi
  801d43:	89 c3                	mov    %eax,%ebx
  801d45:	eb 1a                	jmp    801d61 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801d47:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d4b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801d52:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d54:	83 eb 01             	sub    $0x1,%ebx
  801d57:	eb 08                	jmp    801d61 <vprintfmt+0x283>
  801d59:	89 fb                	mov    %edi,%ebx
  801d5b:	8b 75 08             	mov    0x8(%ebp),%esi
  801d5e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d61:	85 db                	test   %ebx,%ebx
  801d63:	7f e2                	jg     801d47 <vprintfmt+0x269>
  801d65:	89 75 08             	mov    %esi,0x8(%ebp)
  801d68:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d6b:	e9 93 fd ff ff       	jmp    801b03 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801d70:	83 fa 01             	cmp    $0x1,%edx
  801d73:	7e 16                	jle    801d8b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  801d75:	8b 45 14             	mov    0x14(%ebp),%eax
  801d78:	8d 50 08             	lea    0x8(%eax),%edx
  801d7b:	89 55 14             	mov    %edx,0x14(%ebp)
  801d7e:	8b 50 04             	mov    0x4(%eax),%edx
  801d81:	8b 00                	mov    (%eax),%eax
  801d83:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d86:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801d89:	eb 32                	jmp    801dbd <vprintfmt+0x2df>
	else if (lflag)
  801d8b:	85 d2                	test   %edx,%edx
  801d8d:	74 18                	je     801da7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  801d8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801d92:	8d 50 04             	lea    0x4(%eax),%edx
  801d95:	89 55 14             	mov    %edx,0x14(%ebp)
  801d98:	8b 30                	mov    (%eax),%esi
  801d9a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801d9d:	89 f0                	mov    %esi,%eax
  801d9f:	c1 f8 1f             	sar    $0x1f,%eax
  801da2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801da5:	eb 16                	jmp    801dbd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  801da7:	8b 45 14             	mov    0x14(%ebp),%eax
  801daa:	8d 50 04             	lea    0x4(%eax),%edx
  801dad:	89 55 14             	mov    %edx,0x14(%ebp)
  801db0:	8b 30                	mov    (%eax),%esi
  801db2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801db5:	89 f0                	mov    %esi,%eax
  801db7:	c1 f8 1f             	sar    $0x1f,%eax
  801dba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801dbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801dc3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801dc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801dcc:	0f 89 80 00 00 00    	jns    801e52 <vprintfmt+0x374>
				putch('-', putdat);
  801dd2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801dd6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801ddd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801de0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801de6:	f7 d8                	neg    %eax
  801de8:	83 d2 00             	adc    $0x0,%edx
  801deb:	f7 da                	neg    %edx
			}
			base = 10;
  801ded:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801df2:	eb 5e                	jmp    801e52 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801df4:	8d 45 14             	lea    0x14(%ebp),%eax
  801df7:	e8 63 fc ff ff       	call   801a5f <getuint>
			base = 10;
  801dfc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801e01:	eb 4f                	jmp    801e52 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  801e03:	8d 45 14             	lea    0x14(%ebp),%eax
  801e06:	e8 54 fc ff ff       	call   801a5f <getuint>
			base = 8;
  801e0b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801e10:	eb 40                	jmp    801e52 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  801e12:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e16:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801e1d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801e20:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e24:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801e2b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801e2e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e31:	8d 50 04             	lea    0x4(%eax),%edx
  801e34:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801e37:	8b 00                	mov    (%eax),%eax
  801e39:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801e3e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801e43:	eb 0d                	jmp    801e52 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801e45:	8d 45 14             	lea    0x14(%ebp),%eax
  801e48:	e8 12 fc ff ff       	call   801a5f <getuint>
			base = 16;
  801e4d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801e52:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  801e56:	89 74 24 10          	mov    %esi,0x10(%esp)
  801e5a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  801e5d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e61:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e65:	89 04 24             	mov    %eax,(%esp)
  801e68:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e6c:	89 fa                	mov    %edi,%edx
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e71:	e8 fa fa ff ff       	call   801970 <printnum>
			break;
  801e76:	e9 88 fc ff ff       	jmp    801b03 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e7b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e7f:	89 04 24             	mov    %eax,(%esp)
  801e82:	ff 55 08             	call   *0x8(%ebp)
			break;
  801e85:	e9 79 fc ff ff       	jmp    801b03 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e8a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e8e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801e95:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e98:	89 f3                	mov    %esi,%ebx
  801e9a:	eb 03                	jmp    801e9f <vprintfmt+0x3c1>
  801e9c:	83 eb 01             	sub    $0x1,%ebx
  801e9f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801ea3:	75 f7                	jne    801e9c <vprintfmt+0x3be>
  801ea5:	e9 59 fc ff ff       	jmp    801b03 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801eaa:	83 c4 3c             	add    $0x3c,%esp
  801ead:	5b                   	pop    %ebx
  801eae:	5e                   	pop    %esi
  801eaf:	5f                   	pop    %edi
  801eb0:	5d                   	pop    %ebp
  801eb1:	c3                   	ret    

00801eb2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 28             	sub    $0x28,%esp
  801eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ebe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ec1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801ec5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801ec8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	74 30                	je     801f03 <vsnprintf+0x51>
  801ed3:	85 d2                	test   %edx,%edx
  801ed5:	7e 2c                	jle    801f03 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ed7:	8b 45 14             	mov    0x14(%ebp),%eax
  801eda:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ede:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ee5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ee8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eec:	c7 04 24 99 1a 80 00 	movl   $0x801a99,(%esp)
  801ef3:	e8 e6 fb ff ff       	call   801ade <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801efb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f01:	eb 05                	jmp    801f08 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801f03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f10:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801f13:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f17:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	89 04 24             	mov    %eax,(%esp)
  801f2b:	e8 82 ff ff ff       	call   801eb2 <vsnprintf>
	va_end(ap);

	return rc;
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    
  801f32:	66 90                	xchg   %ax,%ax
  801f34:	66 90                	xchg   %ax,%ax
  801f36:	66 90                	xchg   %ax,%ax
  801f38:	66 90                	xchg   %ax,%ax
  801f3a:	66 90                	xchg   %ax,%ax
  801f3c:	66 90                	xchg   %ax,%ax
  801f3e:	66 90                	xchg   %ax,%ax

00801f40 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801f46:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4b:	eb 03                	jmp    801f50 <strlen+0x10>
		n++;
  801f4d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f50:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801f54:	75 f7                	jne    801f4d <strlen+0xd>
		n++;
	return n;
}
  801f56:	5d                   	pop    %ebp
  801f57:	c3                   	ret    

00801f58 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f5e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
  801f66:	eb 03                	jmp    801f6b <strnlen+0x13>
		n++;
  801f68:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f6b:	39 d0                	cmp    %edx,%eax
  801f6d:	74 06                	je     801f75 <strnlen+0x1d>
  801f6f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801f73:	75 f3                	jne    801f68 <strnlen+0x10>
		n++;
	return n;
}
  801f75:	5d                   	pop    %ebp
  801f76:	c3                   	ret    

00801f77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	53                   	push   %ebx
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801f81:	89 c2                	mov    %eax,%edx
  801f83:	83 c2 01             	add    $0x1,%edx
  801f86:	83 c1 01             	add    $0x1,%ecx
  801f89:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801f8d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801f90:	84 db                	test   %bl,%bl
  801f92:	75 ef                	jne    801f83 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801f94:	5b                   	pop    %ebx
  801f95:	5d                   	pop    %ebp
  801f96:	c3                   	ret    

00801f97 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	53                   	push   %ebx
  801f9b:	83 ec 08             	sub    $0x8,%esp
  801f9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801fa1:	89 1c 24             	mov    %ebx,(%esp)
  801fa4:	e8 97 ff ff ff       	call   801f40 <strlen>
	strcpy(dst + len, src);
  801fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fac:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fb0:	01 d8                	add    %ebx,%eax
  801fb2:	89 04 24             	mov    %eax,(%esp)
  801fb5:	e8 bd ff ff ff       	call   801f77 <strcpy>
	return dst;
}
  801fba:	89 d8                	mov    %ebx,%eax
  801fbc:	83 c4 08             	add    $0x8,%esp
  801fbf:	5b                   	pop    %ebx
  801fc0:	5d                   	pop    %ebp
  801fc1:	c3                   	ret    

00801fc2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	56                   	push   %esi
  801fc6:	53                   	push   %ebx
  801fc7:	8b 75 08             	mov    0x8(%ebp),%esi
  801fca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fcd:	89 f3                	mov    %esi,%ebx
  801fcf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801fd2:	89 f2                	mov    %esi,%edx
  801fd4:	eb 0f                	jmp    801fe5 <strncpy+0x23>
		*dst++ = *src;
  801fd6:	83 c2 01             	add    $0x1,%edx
  801fd9:	0f b6 01             	movzbl (%ecx),%eax
  801fdc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801fdf:	80 39 01             	cmpb   $0x1,(%ecx)
  801fe2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801fe5:	39 da                	cmp    %ebx,%edx
  801fe7:	75 ed                	jne    801fd6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801fe9:	89 f0                	mov    %esi,%eax
  801feb:	5b                   	pop    %ebx
  801fec:	5e                   	pop    %esi
  801fed:	5d                   	pop    %ebp
  801fee:	c3                   	ret    

00801fef <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	56                   	push   %esi
  801ff3:	53                   	push   %ebx
  801ff4:	8b 75 08             	mov    0x8(%ebp),%esi
  801ff7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ffd:	89 f0                	mov    %esi,%eax
  801fff:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802003:	85 c9                	test   %ecx,%ecx
  802005:	75 0b                	jne    802012 <strlcpy+0x23>
  802007:	eb 1d                	jmp    802026 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  802009:	83 c0 01             	add    $0x1,%eax
  80200c:	83 c2 01             	add    $0x1,%edx
  80200f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802012:	39 d8                	cmp    %ebx,%eax
  802014:	74 0b                	je     802021 <strlcpy+0x32>
  802016:	0f b6 0a             	movzbl (%edx),%ecx
  802019:	84 c9                	test   %cl,%cl
  80201b:	75 ec                	jne    802009 <strlcpy+0x1a>
  80201d:	89 c2                	mov    %eax,%edx
  80201f:	eb 02                	jmp    802023 <strlcpy+0x34>
  802021:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  802023:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  802026:	29 f0                	sub    %esi,%eax
}
  802028:	5b                   	pop    %ebx
  802029:	5e                   	pop    %esi
  80202a:	5d                   	pop    %ebp
  80202b:	c3                   	ret    

0080202c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802032:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802035:	eb 06                	jmp    80203d <strcmp+0x11>
		p++, q++;
  802037:	83 c1 01             	add    $0x1,%ecx
  80203a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80203d:	0f b6 01             	movzbl (%ecx),%eax
  802040:	84 c0                	test   %al,%al
  802042:	74 04                	je     802048 <strcmp+0x1c>
  802044:	3a 02                	cmp    (%edx),%al
  802046:	74 ef                	je     802037 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802048:	0f b6 c0             	movzbl %al,%eax
  80204b:	0f b6 12             	movzbl (%edx),%edx
  80204e:	29 d0                	sub    %edx,%eax
}
  802050:	5d                   	pop    %ebp
  802051:	c3                   	ret    

00802052 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
  802055:	53                   	push   %ebx
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205c:	89 c3                	mov    %eax,%ebx
  80205e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802061:	eb 06                	jmp    802069 <strncmp+0x17>
		n--, p++, q++;
  802063:	83 c0 01             	add    $0x1,%eax
  802066:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802069:	39 d8                	cmp    %ebx,%eax
  80206b:	74 15                	je     802082 <strncmp+0x30>
  80206d:	0f b6 08             	movzbl (%eax),%ecx
  802070:	84 c9                	test   %cl,%cl
  802072:	74 04                	je     802078 <strncmp+0x26>
  802074:	3a 0a                	cmp    (%edx),%cl
  802076:	74 eb                	je     802063 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802078:	0f b6 00             	movzbl (%eax),%eax
  80207b:	0f b6 12             	movzbl (%edx),%edx
  80207e:	29 d0                	sub    %edx,%eax
  802080:	eb 05                	jmp    802087 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  802082:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802087:	5b                   	pop    %ebx
  802088:	5d                   	pop    %ebp
  802089:	c3                   	ret    

0080208a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802094:	eb 07                	jmp    80209d <strchr+0x13>
		if (*s == c)
  802096:	38 ca                	cmp    %cl,%dl
  802098:	74 0f                	je     8020a9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80209a:	83 c0 01             	add    $0x1,%eax
  80209d:	0f b6 10             	movzbl (%eax),%edx
  8020a0:	84 d2                	test   %dl,%dl
  8020a2:	75 f2                	jne    802096 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a9:	5d                   	pop    %ebp
  8020aa:	c3                   	ret    

008020ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8020b5:	eb 07                	jmp    8020be <strfind+0x13>
		if (*s == c)
  8020b7:	38 ca                	cmp    %cl,%dl
  8020b9:	74 0a                	je     8020c5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8020bb:	83 c0 01             	add    $0x1,%eax
  8020be:	0f b6 10             	movzbl (%eax),%edx
  8020c1:	84 d2                	test   %dl,%dl
  8020c3:	75 f2                	jne    8020b7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8020c5:	5d                   	pop    %ebp
  8020c6:	c3                   	ret    

008020c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	57                   	push   %edi
  8020cb:	56                   	push   %esi
  8020cc:	53                   	push   %ebx
  8020cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8020d3:	85 c9                	test   %ecx,%ecx
  8020d5:	74 36                	je     80210d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8020d7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8020dd:	75 28                	jne    802107 <memset+0x40>
  8020df:	f6 c1 03             	test   $0x3,%cl
  8020e2:	75 23                	jne    802107 <memset+0x40>
		c &= 0xFF;
  8020e4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8020e8:	89 d3                	mov    %edx,%ebx
  8020ea:	c1 e3 08             	shl    $0x8,%ebx
  8020ed:	89 d6                	mov    %edx,%esi
  8020ef:	c1 e6 18             	shl    $0x18,%esi
  8020f2:	89 d0                	mov    %edx,%eax
  8020f4:	c1 e0 10             	shl    $0x10,%eax
  8020f7:	09 f0                	or     %esi,%eax
  8020f9:	09 c2                	or     %eax,%edx
  8020fb:	89 d0                	mov    %edx,%eax
  8020fd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8020ff:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802102:	fc                   	cld    
  802103:	f3 ab                	rep stos %eax,%es:(%edi)
  802105:	eb 06                	jmp    80210d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210a:	fc                   	cld    
  80210b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80210d:	89 f8                	mov    %edi,%eax
  80210f:	5b                   	pop    %ebx
  802110:	5e                   	pop    %esi
  802111:	5f                   	pop    %edi
  802112:	5d                   	pop    %ebp
  802113:	c3                   	ret    

00802114 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	57                   	push   %edi
  802118:	56                   	push   %esi
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80211f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802122:	39 c6                	cmp    %eax,%esi
  802124:	73 35                	jae    80215b <memmove+0x47>
  802126:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802129:	39 d0                	cmp    %edx,%eax
  80212b:	73 2e                	jae    80215b <memmove+0x47>
		s += n;
		d += n;
  80212d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  802130:	89 d6                	mov    %edx,%esi
  802132:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802134:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80213a:	75 13                	jne    80214f <memmove+0x3b>
  80213c:	f6 c1 03             	test   $0x3,%cl
  80213f:	75 0e                	jne    80214f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802141:	83 ef 04             	sub    $0x4,%edi
  802144:	8d 72 fc             	lea    -0x4(%edx),%esi
  802147:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80214a:	fd                   	std    
  80214b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80214d:	eb 09                	jmp    802158 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80214f:	83 ef 01             	sub    $0x1,%edi
  802152:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802155:	fd                   	std    
  802156:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802158:	fc                   	cld    
  802159:	eb 1d                	jmp    802178 <memmove+0x64>
  80215b:	89 f2                	mov    %esi,%edx
  80215d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80215f:	f6 c2 03             	test   $0x3,%dl
  802162:	75 0f                	jne    802173 <memmove+0x5f>
  802164:	f6 c1 03             	test   $0x3,%cl
  802167:	75 0a                	jne    802173 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802169:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80216c:	89 c7                	mov    %eax,%edi
  80216e:	fc                   	cld    
  80216f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802171:	eb 05                	jmp    802178 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802173:	89 c7                	mov    %eax,%edi
  802175:	fc                   	cld    
  802176:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802178:	5e                   	pop    %esi
  802179:	5f                   	pop    %edi
  80217a:	5d                   	pop    %ebp
  80217b:	c3                   	ret    

0080217c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802182:	8b 45 10             	mov    0x10(%ebp),%eax
  802185:	89 44 24 08          	mov    %eax,0x8(%esp)
  802189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	89 04 24             	mov    %eax,(%esp)
  802196:	e8 79 ff ff ff       	call   802114 <memmove>
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	56                   	push   %esi
  8021a1:	53                   	push   %ebx
  8021a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021a8:	89 d6                	mov    %edx,%esi
  8021aa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8021ad:	eb 1a                	jmp    8021c9 <memcmp+0x2c>
		if (*s1 != *s2)
  8021af:	0f b6 02             	movzbl (%edx),%eax
  8021b2:	0f b6 19             	movzbl (%ecx),%ebx
  8021b5:	38 d8                	cmp    %bl,%al
  8021b7:	74 0a                	je     8021c3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8021b9:	0f b6 c0             	movzbl %al,%eax
  8021bc:	0f b6 db             	movzbl %bl,%ebx
  8021bf:	29 d8                	sub    %ebx,%eax
  8021c1:	eb 0f                	jmp    8021d2 <memcmp+0x35>
		s1++, s2++;
  8021c3:	83 c2 01             	add    $0x1,%edx
  8021c6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8021c9:	39 f2                	cmp    %esi,%edx
  8021cb:	75 e2                	jne    8021af <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8021cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d2:	5b                   	pop    %ebx
  8021d3:	5e                   	pop    %esi
  8021d4:	5d                   	pop    %ebp
  8021d5:	c3                   	ret    

008021d6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8021df:	89 c2                	mov    %eax,%edx
  8021e1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8021e4:	eb 07                	jmp    8021ed <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  8021e6:	38 08                	cmp    %cl,(%eax)
  8021e8:	74 07                	je     8021f1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8021ea:	83 c0 01             	add    $0x1,%eax
  8021ed:	39 d0                	cmp    %edx,%eax
  8021ef:	72 f5                	jb     8021e6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8021f1:	5d                   	pop    %ebp
  8021f2:	c3                   	ret    

008021f3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	57                   	push   %edi
  8021f7:	56                   	push   %esi
  8021f8:	53                   	push   %ebx
  8021f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021fc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8021ff:	eb 03                	jmp    802204 <strtol+0x11>
		s++;
  802201:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802204:	0f b6 0a             	movzbl (%edx),%ecx
  802207:	80 f9 09             	cmp    $0x9,%cl
  80220a:	74 f5                	je     802201 <strtol+0xe>
  80220c:	80 f9 20             	cmp    $0x20,%cl
  80220f:	74 f0                	je     802201 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  802211:	80 f9 2b             	cmp    $0x2b,%cl
  802214:	75 0a                	jne    802220 <strtol+0x2d>
		s++;
  802216:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  802219:	bf 00 00 00 00       	mov    $0x0,%edi
  80221e:	eb 11                	jmp    802231 <strtol+0x3e>
  802220:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  802225:	80 f9 2d             	cmp    $0x2d,%cl
  802228:	75 07                	jne    802231 <strtol+0x3e>
		s++, neg = 1;
  80222a:	8d 52 01             	lea    0x1(%edx),%edx
  80222d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802231:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  802236:	75 15                	jne    80224d <strtol+0x5a>
  802238:	80 3a 30             	cmpb   $0x30,(%edx)
  80223b:	75 10                	jne    80224d <strtol+0x5a>
  80223d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  802241:	75 0a                	jne    80224d <strtol+0x5a>
		s += 2, base = 16;
  802243:	83 c2 02             	add    $0x2,%edx
  802246:	b8 10 00 00 00       	mov    $0x10,%eax
  80224b:	eb 10                	jmp    80225d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80224d:	85 c0                	test   %eax,%eax
  80224f:	75 0c                	jne    80225d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802251:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802253:	80 3a 30             	cmpb   $0x30,(%edx)
  802256:	75 05                	jne    80225d <strtol+0x6a>
		s++, base = 8;
  802258:	83 c2 01             	add    $0x1,%edx
  80225b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80225d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802262:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802265:	0f b6 0a             	movzbl (%edx),%ecx
  802268:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80226b:	89 f0                	mov    %esi,%eax
  80226d:	3c 09                	cmp    $0x9,%al
  80226f:	77 08                	ja     802279 <strtol+0x86>
			dig = *s - '0';
  802271:	0f be c9             	movsbl %cl,%ecx
  802274:	83 e9 30             	sub    $0x30,%ecx
  802277:	eb 20                	jmp    802299 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  802279:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80227c:	89 f0                	mov    %esi,%eax
  80227e:	3c 19                	cmp    $0x19,%al
  802280:	77 08                	ja     80228a <strtol+0x97>
			dig = *s - 'a' + 10;
  802282:	0f be c9             	movsbl %cl,%ecx
  802285:	83 e9 57             	sub    $0x57,%ecx
  802288:	eb 0f                	jmp    802299 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80228a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80228d:	89 f0                	mov    %esi,%eax
  80228f:	3c 19                	cmp    $0x19,%al
  802291:	77 16                	ja     8022a9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  802293:	0f be c9             	movsbl %cl,%ecx
  802296:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  802299:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80229c:	7d 0f                	jge    8022ad <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80229e:	83 c2 01             	add    $0x1,%edx
  8022a1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8022a5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8022a7:	eb bc                	jmp    802265 <strtol+0x72>
  8022a9:	89 d8                	mov    %ebx,%eax
  8022ab:	eb 02                	jmp    8022af <strtol+0xbc>
  8022ad:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8022af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022b3:	74 05                	je     8022ba <strtol+0xc7>
		*endptr = (char *) s;
  8022b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022b8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8022ba:	f7 d8                	neg    %eax
  8022bc:	85 ff                	test   %edi,%edi
  8022be:	0f 44 c3             	cmove  %ebx,%eax
}
  8022c1:	5b                   	pop    %ebx
  8022c2:	5e                   	pop    %esi
  8022c3:	5f                   	pop    %edi
  8022c4:	5d                   	pop    %ebp
  8022c5:	c3                   	ret    
  8022c6:	66 90                	xchg   %ax,%ax
  8022c8:	66 90                	xchg   %ax,%ax
  8022ca:	66 90                	xchg   %ax,%ax
  8022cc:	66 90                	xchg   %ax,%ax
  8022ce:	66 90                	xchg   %ax,%ax

008022d0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	56                   	push   %esi
  8022d4:	53                   	push   %ebx
  8022d5:	83 ec 10             	sub    $0x10,%esp
  8022d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8022db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8022e1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  8022e3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022e8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  8022eb:	89 04 24             	mov    %eax,(%esp)
  8022ee:	e8 97 e0 ff ff       	call   80038a <sys_ipc_recv>
  8022f3:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  8022f5:	85 d2                	test   %edx,%edx
  8022f7:	75 24                	jne    80231d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  8022f9:	85 f6                	test   %esi,%esi
  8022fb:	74 0a                	je     802307 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  8022fd:	a1 08 40 80 00       	mov    0x804008,%eax
  802302:	8b 40 74             	mov    0x74(%eax),%eax
  802305:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802307:	85 db                	test   %ebx,%ebx
  802309:	74 0a                	je     802315 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80230b:	a1 08 40 80 00       	mov    0x804008,%eax
  802310:	8b 40 78             	mov    0x78(%eax),%eax
  802313:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802315:	a1 08 40 80 00       	mov    0x804008,%eax
  80231a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80231d:	83 c4 10             	add    $0x10,%esp
  802320:	5b                   	pop    %ebx
  802321:	5e                   	pop    %esi
  802322:	5d                   	pop    %ebp
  802323:	c3                   	ret    

00802324 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	57                   	push   %edi
  802328:	56                   	push   %esi
  802329:	53                   	push   %ebx
  80232a:	83 ec 1c             	sub    $0x1c,%esp
  80232d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802330:	8b 75 0c             	mov    0xc(%ebp),%esi
  802333:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802336:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802338:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80233d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802340:	8b 45 14             	mov    0x14(%ebp),%eax
  802343:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802347:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80234b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80234f:	89 3c 24             	mov    %edi,(%esp)
  802352:	e8 10 e0 ff ff       	call   800367 <sys_ipc_try_send>

		if (ret == 0)
  802357:	85 c0                	test   %eax,%eax
  802359:	74 2c                	je     802387 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80235b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80235e:	74 20                	je     802380 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802360:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802364:	c7 44 24 08 6c 2b 80 	movl   $0x802b6c,0x8(%esp)
  80236b:	00 
  80236c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802373:	00 
  802374:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  80237b:	e8 d6 f4 ff ff       	call   801856 <_panic>
		}

		sys_yield();
  802380:	e8 d0 dd ff ff       	call   800155 <sys_yield>
	}
  802385:	eb b9                	jmp    802340 <ipc_send+0x1c>
}
  802387:	83 c4 1c             	add    $0x1c,%esp
  80238a:	5b                   	pop    %ebx
  80238b:	5e                   	pop    %esi
  80238c:	5f                   	pop    %edi
  80238d:	5d                   	pop    %ebp
  80238e:	c3                   	ret    

0080238f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802395:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80239a:	89 c2                	mov    %eax,%edx
  80239c:	c1 e2 07             	shl    $0x7,%edx
  80239f:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  8023a6:	8b 52 50             	mov    0x50(%edx),%edx
  8023a9:	39 ca                	cmp    %ecx,%edx
  8023ab:	75 11                	jne    8023be <ipc_find_env+0x2f>
			return envs[i].env_id;
  8023ad:	89 c2                	mov    %eax,%edx
  8023af:	c1 e2 07             	shl    $0x7,%edx
  8023b2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  8023b9:	8b 40 40             	mov    0x40(%eax),%eax
  8023bc:	eb 0e                	jmp    8023cc <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023be:	83 c0 01             	add    $0x1,%eax
  8023c1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023c6:	75 d2                	jne    80239a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023c8:	66 b8 00 00          	mov    $0x0,%ax
}
  8023cc:	5d                   	pop    %ebp
  8023cd:	c3                   	ret    

008023ce <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
  8023d1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023d4:	89 d0                	mov    %edx,%eax
  8023d6:	c1 e8 16             	shr    $0x16,%eax
  8023d9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023e0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023e5:	f6 c1 01             	test   $0x1,%cl
  8023e8:	74 1d                	je     802407 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023ea:	c1 ea 0c             	shr    $0xc,%edx
  8023ed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023f4:	f6 c2 01             	test   $0x1,%dl
  8023f7:	74 0e                	je     802407 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023f9:	c1 ea 0c             	shr    $0xc,%edx
  8023fc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802403:	ef 
  802404:	0f b7 c0             	movzwl %ax,%eax
}
  802407:	5d                   	pop    %ebp
  802408:	c3                   	ret    
  802409:	66 90                	xchg   %ax,%ax
  80240b:	66 90                	xchg   %ax,%ax
  80240d:	66 90                	xchg   %ax,%ax
  80240f:	90                   	nop

00802410 <__udivdi3>:
  802410:	55                   	push   %ebp
  802411:	57                   	push   %edi
  802412:	56                   	push   %esi
  802413:	83 ec 0c             	sub    $0xc,%esp
  802416:	8b 44 24 28          	mov    0x28(%esp),%eax
  80241a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80241e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802422:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802426:	85 c0                	test   %eax,%eax
  802428:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80242c:	89 ea                	mov    %ebp,%edx
  80242e:	89 0c 24             	mov    %ecx,(%esp)
  802431:	75 2d                	jne    802460 <__udivdi3+0x50>
  802433:	39 e9                	cmp    %ebp,%ecx
  802435:	77 61                	ja     802498 <__udivdi3+0x88>
  802437:	85 c9                	test   %ecx,%ecx
  802439:	89 ce                	mov    %ecx,%esi
  80243b:	75 0b                	jne    802448 <__udivdi3+0x38>
  80243d:	b8 01 00 00 00       	mov    $0x1,%eax
  802442:	31 d2                	xor    %edx,%edx
  802444:	f7 f1                	div    %ecx
  802446:	89 c6                	mov    %eax,%esi
  802448:	31 d2                	xor    %edx,%edx
  80244a:	89 e8                	mov    %ebp,%eax
  80244c:	f7 f6                	div    %esi
  80244e:	89 c5                	mov    %eax,%ebp
  802450:	89 f8                	mov    %edi,%eax
  802452:	f7 f6                	div    %esi
  802454:	89 ea                	mov    %ebp,%edx
  802456:	83 c4 0c             	add    $0xc,%esp
  802459:	5e                   	pop    %esi
  80245a:	5f                   	pop    %edi
  80245b:	5d                   	pop    %ebp
  80245c:	c3                   	ret    
  80245d:	8d 76 00             	lea    0x0(%esi),%esi
  802460:	39 e8                	cmp    %ebp,%eax
  802462:	77 24                	ja     802488 <__udivdi3+0x78>
  802464:	0f bd e8             	bsr    %eax,%ebp
  802467:	83 f5 1f             	xor    $0x1f,%ebp
  80246a:	75 3c                	jne    8024a8 <__udivdi3+0x98>
  80246c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802470:	39 34 24             	cmp    %esi,(%esp)
  802473:	0f 86 9f 00 00 00    	jbe    802518 <__udivdi3+0x108>
  802479:	39 d0                	cmp    %edx,%eax
  80247b:	0f 82 97 00 00 00    	jb     802518 <__udivdi3+0x108>
  802481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802488:	31 d2                	xor    %edx,%edx
  80248a:	31 c0                	xor    %eax,%eax
  80248c:	83 c4 0c             	add    $0xc,%esp
  80248f:	5e                   	pop    %esi
  802490:	5f                   	pop    %edi
  802491:	5d                   	pop    %ebp
  802492:	c3                   	ret    
  802493:	90                   	nop
  802494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802498:	89 f8                	mov    %edi,%eax
  80249a:	f7 f1                	div    %ecx
  80249c:	31 d2                	xor    %edx,%edx
  80249e:	83 c4 0c             	add    $0xc,%esp
  8024a1:	5e                   	pop    %esi
  8024a2:	5f                   	pop    %edi
  8024a3:	5d                   	pop    %ebp
  8024a4:	c3                   	ret    
  8024a5:	8d 76 00             	lea    0x0(%esi),%esi
  8024a8:	89 e9                	mov    %ebp,%ecx
  8024aa:	8b 3c 24             	mov    (%esp),%edi
  8024ad:	d3 e0                	shl    %cl,%eax
  8024af:	89 c6                	mov    %eax,%esi
  8024b1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024b6:	29 e8                	sub    %ebp,%eax
  8024b8:	89 c1                	mov    %eax,%ecx
  8024ba:	d3 ef                	shr    %cl,%edi
  8024bc:	89 e9                	mov    %ebp,%ecx
  8024be:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024c2:	8b 3c 24             	mov    (%esp),%edi
  8024c5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024c9:	89 d6                	mov    %edx,%esi
  8024cb:	d3 e7                	shl    %cl,%edi
  8024cd:	89 c1                	mov    %eax,%ecx
  8024cf:	89 3c 24             	mov    %edi,(%esp)
  8024d2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024d6:	d3 ee                	shr    %cl,%esi
  8024d8:	89 e9                	mov    %ebp,%ecx
  8024da:	d3 e2                	shl    %cl,%edx
  8024dc:	89 c1                	mov    %eax,%ecx
  8024de:	d3 ef                	shr    %cl,%edi
  8024e0:	09 d7                	or     %edx,%edi
  8024e2:	89 f2                	mov    %esi,%edx
  8024e4:	89 f8                	mov    %edi,%eax
  8024e6:	f7 74 24 08          	divl   0x8(%esp)
  8024ea:	89 d6                	mov    %edx,%esi
  8024ec:	89 c7                	mov    %eax,%edi
  8024ee:	f7 24 24             	mull   (%esp)
  8024f1:	39 d6                	cmp    %edx,%esi
  8024f3:	89 14 24             	mov    %edx,(%esp)
  8024f6:	72 30                	jb     802528 <__udivdi3+0x118>
  8024f8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024fc:	89 e9                	mov    %ebp,%ecx
  8024fe:	d3 e2                	shl    %cl,%edx
  802500:	39 c2                	cmp    %eax,%edx
  802502:	73 05                	jae    802509 <__udivdi3+0xf9>
  802504:	3b 34 24             	cmp    (%esp),%esi
  802507:	74 1f                	je     802528 <__udivdi3+0x118>
  802509:	89 f8                	mov    %edi,%eax
  80250b:	31 d2                	xor    %edx,%edx
  80250d:	e9 7a ff ff ff       	jmp    80248c <__udivdi3+0x7c>
  802512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802518:	31 d2                	xor    %edx,%edx
  80251a:	b8 01 00 00 00       	mov    $0x1,%eax
  80251f:	e9 68 ff ff ff       	jmp    80248c <__udivdi3+0x7c>
  802524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802528:	8d 47 ff             	lea    -0x1(%edi),%eax
  80252b:	31 d2                	xor    %edx,%edx
  80252d:	83 c4 0c             	add    $0xc,%esp
  802530:	5e                   	pop    %esi
  802531:	5f                   	pop    %edi
  802532:	5d                   	pop    %ebp
  802533:	c3                   	ret    
  802534:	66 90                	xchg   %ax,%ax
  802536:	66 90                	xchg   %ax,%ax
  802538:	66 90                	xchg   %ax,%ax
  80253a:	66 90                	xchg   %ax,%ax
  80253c:	66 90                	xchg   %ax,%ax
  80253e:	66 90                	xchg   %ax,%ax

00802540 <__umoddi3>:
  802540:	55                   	push   %ebp
  802541:	57                   	push   %edi
  802542:	56                   	push   %esi
  802543:	83 ec 14             	sub    $0x14,%esp
  802546:	8b 44 24 28          	mov    0x28(%esp),%eax
  80254a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80254e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802552:	89 c7                	mov    %eax,%edi
  802554:	89 44 24 04          	mov    %eax,0x4(%esp)
  802558:	8b 44 24 30          	mov    0x30(%esp),%eax
  80255c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802560:	89 34 24             	mov    %esi,(%esp)
  802563:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802567:	85 c0                	test   %eax,%eax
  802569:	89 c2                	mov    %eax,%edx
  80256b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80256f:	75 17                	jne    802588 <__umoddi3+0x48>
  802571:	39 fe                	cmp    %edi,%esi
  802573:	76 4b                	jbe    8025c0 <__umoddi3+0x80>
  802575:	89 c8                	mov    %ecx,%eax
  802577:	89 fa                	mov    %edi,%edx
  802579:	f7 f6                	div    %esi
  80257b:	89 d0                	mov    %edx,%eax
  80257d:	31 d2                	xor    %edx,%edx
  80257f:	83 c4 14             	add    $0x14,%esp
  802582:	5e                   	pop    %esi
  802583:	5f                   	pop    %edi
  802584:	5d                   	pop    %ebp
  802585:	c3                   	ret    
  802586:	66 90                	xchg   %ax,%ax
  802588:	39 f8                	cmp    %edi,%eax
  80258a:	77 54                	ja     8025e0 <__umoddi3+0xa0>
  80258c:	0f bd e8             	bsr    %eax,%ebp
  80258f:	83 f5 1f             	xor    $0x1f,%ebp
  802592:	75 5c                	jne    8025f0 <__umoddi3+0xb0>
  802594:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802598:	39 3c 24             	cmp    %edi,(%esp)
  80259b:	0f 87 e7 00 00 00    	ja     802688 <__umoddi3+0x148>
  8025a1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025a5:	29 f1                	sub    %esi,%ecx
  8025a7:	19 c7                	sbb    %eax,%edi
  8025a9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025b1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025b5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025b9:	83 c4 14             	add    $0x14,%esp
  8025bc:	5e                   	pop    %esi
  8025bd:	5f                   	pop    %edi
  8025be:	5d                   	pop    %ebp
  8025bf:	c3                   	ret    
  8025c0:	85 f6                	test   %esi,%esi
  8025c2:	89 f5                	mov    %esi,%ebp
  8025c4:	75 0b                	jne    8025d1 <__umoddi3+0x91>
  8025c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025cb:	31 d2                	xor    %edx,%edx
  8025cd:	f7 f6                	div    %esi
  8025cf:	89 c5                	mov    %eax,%ebp
  8025d1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025d5:	31 d2                	xor    %edx,%edx
  8025d7:	f7 f5                	div    %ebp
  8025d9:	89 c8                	mov    %ecx,%eax
  8025db:	f7 f5                	div    %ebp
  8025dd:	eb 9c                	jmp    80257b <__umoddi3+0x3b>
  8025df:	90                   	nop
  8025e0:	89 c8                	mov    %ecx,%eax
  8025e2:	89 fa                	mov    %edi,%edx
  8025e4:	83 c4 14             	add    $0x14,%esp
  8025e7:	5e                   	pop    %esi
  8025e8:	5f                   	pop    %edi
  8025e9:	5d                   	pop    %ebp
  8025ea:	c3                   	ret    
  8025eb:	90                   	nop
  8025ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025f0:	8b 04 24             	mov    (%esp),%eax
  8025f3:	be 20 00 00 00       	mov    $0x20,%esi
  8025f8:	89 e9                	mov    %ebp,%ecx
  8025fa:	29 ee                	sub    %ebp,%esi
  8025fc:	d3 e2                	shl    %cl,%edx
  8025fe:	89 f1                	mov    %esi,%ecx
  802600:	d3 e8                	shr    %cl,%eax
  802602:	89 e9                	mov    %ebp,%ecx
  802604:	89 44 24 04          	mov    %eax,0x4(%esp)
  802608:	8b 04 24             	mov    (%esp),%eax
  80260b:	09 54 24 04          	or     %edx,0x4(%esp)
  80260f:	89 fa                	mov    %edi,%edx
  802611:	d3 e0                	shl    %cl,%eax
  802613:	89 f1                	mov    %esi,%ecx
  802615:	89 44 24 08          	mov    %eax,0x8(%esp)
  802619:	8b 44 24 10          	mov    0x10(%esp),%eax
  80261d:	d3 ea                	shr    %cl,%edx
  80261f:	89 e9                	mov    %ebp,%ecx
  802621:	d3 e7                	shl    %cl,%edi
  802623:	89 f1                	mov    %esi,%ecx
  802625:	d3 e8                	shr    %cl,%eax
  802627:	89 e9                	mov    %ebp,%ecx
  802629:	09 f8                	or     %edi,%eax
  80262b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80262f:	f7 74 24 04          	divl   0x4(%esp)
  802633:	d3 e7                	shl    %cl,%edi
  802635:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802639:	89 d7                	mov    %edx,%edi
  80263b:	f7 64 24 08          	mull   0x8(%esp)
  80263f:	39 d7                	cmp    %edx,%edi
  802641:	89 c1                	mov    %eax,%ecx
  802643:	89 14 24             	mov    %edx,(%esp)
  802646:	72 2c                	jb     802674 <__umoddi3+0x134>
  802648:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80264c:	72 22                	jb     802670 <__umoddi3+0x130>
  80264e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802652:	29 c8                	sub    %ecx,%eax
  802654:	19 d7                	sbb    %edx,%edi
  802656:	89 e9                	mov    %ebp,%ecx
  802658:	89 fa                	mov    %edi,%edx
  80265a:	d3 e8                	shr    %cl,%eax
  80265c:	89 f1                	mov    %esi,%ecx
  80265e:	d3 e2                	shl    %cl,%edx
  802660:	89 e9                	mov    %ebp,%ecx
  802662:	d3 ef                	shr    %cl,%edi
  802664:	09 d0                	or     %edx,%eax
  802666:	89 fa                	mov    %edi,%edx
  802668:	83 c4 14             	add    $0x14,%esp
  80266b:	5e                   	pop    %esi
  80266c:	5f                   	pop    %edi
  80266d:	5d                   	pop    %ebp
  80266e:	c3                   	ret    
  80266f:	90                   	nop
  802670:	39 d7                	cmp    %edx,%edi
  802672:	75 da                	jne    80264e <__umoddi3+0x10e>
  802674:	8b 14 24             	mov    (%esp),%edx
  802677:	89 c1                	mov    %eax,%ecx
  802679:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80267d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802681:	eb cb                	jmp    80264e <__umoddi3+0x10e>
  802683:	90                   	nop
  802684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802688:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80268c:	0f 82 0f ff ff ff    	jb     8025a1 <__umoddi3+0x61>
  802692:	e9 1a ff ff ff       	jmp    8025b1 <__umoddi3+0x71>
