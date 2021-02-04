
obj/user/buggyhello.debug:     file format elf32-i386


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
  80002c:	e8 1e 00 00 00       	call   80004f <libmain>
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
	sys_cputs((char*)1, 1);
  800039:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800040:	00 
  800041:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800048:	e8 67 00 00 00       	call   8000b4 <sys_cputs>
}
  80004d:	c9                   	leave  
  80004e:	c3                   	ret    

0080004f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004f:	55                   	push   %ebp
  800050:	89 e5                	mov    %esp,%ebp
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	83 ec 10             	sub    $0x10,%esp
  800057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs+ENVX(sys_getenvid());
  80005d:	e8 e1 00 00 00       	call   800143 <sys_getenvid>
  800062:	25 ff 03 00 00       	and    $0x3ff,%eax
  800067:	89 c2                	mov    %eax,%edx
  800069:	c1 e2 07             	shl    $0x7,%edx
  80006c:	8d 84 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%eax
  800073:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800078:	85 db                	test   %ebx,%ebx
  80007a:	7e 07                	jle    800083 <libmain+0x34>
		binaryname = argv[0];
  80007c:	8b 06                	mov    (%esi),%eax
  80007e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800083:	89 74 24 04          	mov    %esi,0x4(%esp)
  800087:	89 1c 24             	mov    %ebx,(%esp)
  80008a:	e8 a4 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008f:	e8 07 00 00 00       	call   80009b <exit>
}
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	5b                   	pop    %ebx
  800098:	5e                   	pop    %esi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    

0080009b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009b:	55                   	push   %ebp
  80009c:	89 e5                	mov    %esp,%ebp
  80009e:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000a1:	e8 e4 06 00 00       	call   80078a <close_all>
	sys_env_destroy(0);
  8000a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ad:	e8 3f 00 00 00       	call   8000f1 <sys_env_destroy>
}
  8000b2:	c9                   	leave  
  8000b3:	c3                   	ret    

008000b4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b4:	55                   	push   %ebp
  8000b5:	89 e5                	mov    %esp,%ebp
  8000b7:	57                   	push   %edi
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c5:	89 c3                	mov    %eax,%ebx
  8000c7:	89 c7                	mov    %eax,%edi
  8000c9:	89 c6                	mov    %eax,%esi
  8000cb:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5f                   	pop    %edi
  8000d0:	5d                   	pop    %ebp
  8000d1:	c3                   	ret    

008000d2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d2:	55                   	push   %ebp
  8000d3:	89 e5                	mov    %esp,%ebp
  8000d5:	57                   	push   %edi
  8000d6:	56                   	push   %esi
  8000d7:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8000dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e2:	89 d1                	mov    %edx,%ecx
  8000e4:	89 d3                	mov    %edx,%ebx
  8000e6:	89 d7                	mov    %edx,%edi
  8000e8:	89 d6                	mov    %edx,%esi
  8000ea:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ec:	5b                   	pop    %ebx
  8000ed:	5e                   	pop    %esi
  8000ee:	5f                   	pop    %edi
  8000ef:	5d                   	pop    %ebp
  8000f0:	c3                   	ret    

008000f1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	57                   	push   %edi
  8000f5:	56                   	push   %esi
  8000f6:	53                   	push   %ebx
  8000f7:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ff:	b8 03 00 00 00       	mov    $0x3,%eax
  800104:	8b 55 08             	mov    0x8(%ebp),%edx
  800107:	89 cb                	mov    %ecx,%ebx
  800109:	89 cf                	mov    %ecx,%edi
  80010b:	89 ce                	mov    %ecx,%esi
  80010d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80010f:	85 c0                	test   %eax,%eax
  800111:	7e 28                	jle    80013b <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800113:	89 44 24 10          	mov    %eax,0x10(%esp)
  800117:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  80011e:	00 
  80011f:	c7 44 24 08 ca 26 80 	movl   $0x8026ca,0x8(%esp)
  800126:	00 
  800127:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80012e:	00 
  80012f:	c7 04 24 e7 26 80 00 	movl   $0x8026e7,(%esp)
  800136:	e8 2b 17 00 00       	call   801866 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80013b:	83 c4 2c             	add    $0x2c,%esp
  80013e:	5b                   	pop    %ebx
  80013f:	5e                   	pop    %esi
  800140:	5f                   	pop    %edi
  800141:	5d                   	pop    %ebp
  800142:	c3                   	ret    

00800143 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	57                   	push   %edi
  800147:	56                   	push   %esi
  800148:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800149:	ba 00 00 00 00       	mov    $0x0,%edx
  80014e:	b8 02 00 00 00       	mov    $0x2,%eax
  800153:	89 d1                	mov    %edx,%ecx
  800155:	89 d3                	mov    %edx,%ebx
  800157:	89 d7                	mov    %edx,%edi
  800159:	89 d6                	mov    %edx,%esi
  80015b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80015d:	5b                   	pop    %ebx
  80015e:	5e                   	pop    %esi
  80015f:	5f                   	pop    %edi
  800160:	5d                   	pop    %ebp
  800161:	c3                   	ret    

00800162 <sys_yield>:

void
sys_yield(void)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	57                   	push   %edi
  800166:	56                   	push   %esi
  800167:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800168:	ba 00 00 00 00       	mov    $0x0,%edx
  80016d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800172:	89 d1                	mov    %edx,%ecx
  800174:	89 d3                	mov    %edx,%ebx
  800176:	89 d7                	mov    %edx,%edi
  800178:	89 d6                	mov    %edx,%esi
  80017a:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80017c:	5b                   	pop    %ebx
  80017d:	5e                   	pop    %esi
  80017e:	5f                   	pop    %edi
  80017f:	5d                   	pop    %ebp
  800180:	c3                   	ret    

00800181 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	57                   	push   %edi
  800185:	56                   	push   %esi
  800186:	53                   	push   %ebx
  800187:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80018a:	be 00 00 00 00       	mov    $0x0,%esi
  80018f:	b8 04 00 00 00       	mov    $0x4,%eax
  800194:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800197:	8b 55 08             	mov    0x8(%ebp),%edx
  80019a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80019d:	89 f7                	mov    %esi,%edi
  80019f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001a1:	85 c0                	test   %eax,%eax
  8001a3:	7e 28                	jle    8001cd <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001a9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8001b0:	00 
  8001b1:	c7 44 24 08 ca 26 80 	movl   $0x8026ca,0x8(%esp)
  8001b8:	00 
  8001b9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001c0:	00 
  8001c1:	c7 04 24 e7 26 80 00 	movl   $0x8026e7,(%esp)
  8001c8:	e8 99 16 00 00       	call   801866 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001cd:	83 c4 2c             	add    $0x2c,%esp
  8001d0:	5b                   	pop    %ebx
  8001d1:	5e                   	pop    %esi
  8001d2:	5f                   	pop    %edi
  8001d3:	5d                   	pop    %ebp
  8001d4:	c3                   	ret    

008001d5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	57                   	push   %edi
  8001d9:	56                   	push   %esi
  8001da:	53                   	push   %ebx
  8001db:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001de:	b8 05 00 00 00       	mov    $0x5,%eax
  8001e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ec:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001ef:	8b 75 18             	mov    0x18(%ebp),%esi
  8001f2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001f4:	85 c0                	test   %eax,%eax
  8001f6:	7e 28                	jle    800220 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001fc:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800203:	00 
  800204:	c7 44 24 08 ca 26 80 	movl   $0x8026ca,0x8(%esp)
  80020b:	00 
  80020c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800213:	00 
  800214:	c7 04 24 e7 26 80 00 	movl   $0x8026e7,(%esp)
  80021b:	e8 46 16 00 00       	call   801866 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800220:	83 c4 2c             	add    $0x2c,%esp
  800223:	5b                   	pop    %ebx
  800224:	5e                   	pop    %esi
  800225:	5f                   	pop    %edi
  800226:	5d                   	pop    %ebp
  800227:	c3                   	ret    

00800228 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	57                   	push   %edi
  80022c:	56                   	push   %esi
  80022d:	53                   	push   %ebx
  80022e:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800231:	bb 00 00 00 00       	mov    $0x0,%ebx
  800236:	b8 06 00 00 00       	mov    $0x6,%eax
  80023b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80023e:	8b 55 08             	mov    0x8(%ebp),%edx
  800241:	89 df                	mov    %ebx,%edi
  800243:	89 de                	mov    %ebx,%esi
  800245:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800247:	85 c0                	test   %eax,%eax
  800249:	7e 28                	jle    800273 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80024b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80024f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800256:	00 
  800257:	c7 44 24 08 ca 26 80 	movl   $0x8026ca,0x8(%esp)
  80025e:	00 
  80025f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800266:	00 
  800267:	c7 04 24 e7 26 80 00 	movl   $0x8026e7,(%esp)
  80026e:	e8 f3 15 00 00       	call   801866 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800273:	83 c4 2c             	add    $0x2c,%esp
  800276:	5b                   	pop    %ebx
  800277:	5e                   	pop    %esi
  800278:	5f                   	pop    %edi
  800279:	5d                   	pop    %ebp
  80027a:	c3                   	ret    

0080027b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	57                   	push   %edi
  80027f:	56                   	push   %esi
  800280:	53                   	push   %ebx
  800281:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800284:	bb 00 00 00 00       	mov    $0x0,%ebx
  800289:	b8 08 00 00 00       	mov    $0x8,%eax
  80028e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800291:	8b 55 08             	mov    0x8(%ebp),%edx
  800294:	89 df                	mov    %ebx,%edi
  800296:	89 de                	mov    %ebx,%esi
  800298:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80029a:	85 c0                	test   %eax,%eax
  80029c:	7e 28                	jle    8002c6 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80029e:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002a2:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8002a9:	00 
  8002aa:	c7 44 24 08 ca 26 80 	movl   $0x8026ca,0x8(%esp)
  8002b1:	00 
  8002b2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002b9:	00 
  8002ba:	c7 04 24 e7 26 80 00 	movl   $0x8026e7,(%esp)
  8002c1:	e8 a0 15 00 00       	call   801866 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002c6:	83 c4 2c             	add    $0x2c,%esp
  8002c9:	5b                   	pop    %ebx
  8002ca:	5e                   	pop    %esi
  8002cb:	5f                   	pop    %edi
  8002cc:	5d                   	pop    %ebp
  8002cd:	c3                   	ret    

008002ce <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	57                   	push   %edi
  8002d2:	56                   	push   %esi
  8002d3:	53                   	push   %ebx
  8002d4:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002dc:	b8 09 00 00 00       	mov    $0x9,%eax
  8002e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e7:	89 df                	mov    %ebx,%edi
  8002e9:	89 de                	mov    %ebx,%esi
  8002eb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002ed:	85 c0                	test   %eax,%eax
  8002ef:	7e 28                	jle    800319 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002f5:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8002fc:	00 
  8002fd:	c7 44 24 08 ca 26 80 	movl   $0x8026ca,0x8(%esp)
  800304:	00 
  800305:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80030c:	00 
  80030d:	c7 04 24 e7 26 80 00 	movl   $0x8026e7,(%esp)
  800314:	e8 4d 15 00 00       	call   801866 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800319:	83 c4 2c             	add    $0x2c,%esp
  80031c:	5b                   	pop    %ebx
  80031d:	5e                   	pop    %esi
  80031e:	5f                   	pop    %edi
  80031f:	5d                   	pop    %ebp
  800320:	c3                   	ret    

00800321 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	57                   	push   %edi
  800325:	56                   	push   %esi
  800326:	53                   	push   %ebx
  800327:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80032a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80032f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800334:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800337:	8b 55 08             	mov    0x8(%ebp),%edx
  80033a:	89 df                	mov    %ebx,%edi
  80033c:	89 de                	mov    %ebx,%esi
  80033e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800340:	85 c0                	test   %eax,%eax
  800342:	7e 28                	jle    80036c <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800344:	89 44 24 10          	mov    %eax,0x10(%esp)
  800348:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80034f:	00 
  800350:	c7 44 24 08 ca 26 80 	movl   $0x8026ca,0x8(%esp)
  800357:	00 
  800358:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80035f:	00 
  800360:	c7 04 24 e7 26 80 00 	movl   $0x8026e7,(%esp)
  800367:	e8 fa 14 00 00       	call   801866 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80036c:	83 c4 2c             	add    $0x2c,%esp
  80036f:	5b                   	pop    %ebx
  800370:	5e                   	pop    %esi
  800371:	5f                   	pop    %edi
  800372:	5d                   	pop    %ebp
  800373:	c3                   	ret    

00800374 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	57                   	push   %edi
  800378:	56                   	push   %esi
  800379:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80037a:	be 00 00 00 00       	mov    $0x0,%esi
  80037f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800384:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800387:	8b 55 08             	mov    0x8(%ebp),%edx
  80038a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80038d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800390:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800392:	5b                   	pop    %ebx
  800393:	5e                   	pop    %esi
  800394:	5f                   	pop    %edi
  800395:	5d                   	pop    %ebp
  800396:	c3                   	ret    

00800397 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	57                   	push   %edi
  80039b:	56                   	push   %esi
  80039c:	53                   	push   %ebx
  80039d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003a5:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ad:	89 cb                	mov    %ecx,%ebx
  8003af:	89 cf                	mov    %ecx,%edi
  8003b1:	89 ce                	mov    %ecx,%esi
  8003b3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003b5:	85 c0                	test   %eax,%eax
  8003b7:	7e 28                	jle    8003e1 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003b9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003bd:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8003c4:	00 
  8003c5:	c7 44 24 08 ca 26 80 	movl   $0x8026ca,0x8(%esp)
  8003cc:	00 
  8003cd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003d4:	00 
  8003d5:	c7 04 24 e7 26 80 00 	movl   $0x8026e7,(%esp)
  8003dc:	e8 85 14 00 00       	call   801866 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8003e1:	83 c4 2c             	add    $0x2c,%esp
  8003e4:	5b                   	pop    %ebx
  8003e5:	5e                   	pop    %esi
  8003e6:	5f                   	pop    %edi
  8003e7:	5d                   	pop    %ebp
  8003e8:	c3                   	ret    

008003e9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	57                   	push   %edi
  8003ed:	56                   	push   %esi
  8003ee:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f4:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003f9:	89 d1                	mov    %edx,%ecx
  8003fb:	89 d3                	mov    %edx,%ebx
  8003fd:	89 d7                	mov    %edx,%edi
  8003ff:	89 d6                	mov    %edx,%esi
  800401:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800403:	5b                   	pop    %ebx
  800404:	5e                   	pop    %esi
  800405:	5f                   	pop    %edi
  800406:	5d                   	pop    %ebp
  800407:	c3                   	ret    

00800408 <sys_set_pri>:

int
sys_set_pri(envid_t envid, int pri)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	57                   	push   %edi
  80040c:	56                   	push   %esi
  80040d:	53                   	push   %ebx
  80040e:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800411:	bb 00 00 00 00       	mov    $0x0,%ebx
  800416:	b8 0f 00 00 00       	mov    $0xf,%eax
  80041b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80041e:	8b 55 08             	mov    0x8(%ebp),%edx
  800421:	89 df                	mov    %ebx,%edi
  800423:	89 de                	mov    %ebx,%esi
  800425:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800427:	85 c0                	test   %eax,%eax
  800429:	7e 28                	jle    800453 <sys_set_pri+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80042b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80042f:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800436:	00 
  800437:	c7 44 24 08 ca 26 80 	movl   $0x8026ca,0x8(%esp)
  80043e:	00 
  80043f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800446:	00 
  800447:	c7 04 24 e7 26 80 00 	movl   $0x8026e7,(%esp)
  80044e:	e8 13 14 00 00       	call   801866 <_panic>

int
sys_set_pri(envid_t envid, int pri)
{
	return syscall(SYS_set_pri, 1, envid, pri, 0, 0, 0);
}
  800453:	83 c4 2c             	add    $0x2c,%esp
  800456:	5b                   	pop    %ebx
  800457:	5e                   	pop    %esi
  800458:	5f                   	pop    %edi
  800459:	5d                   	pop    %ebp
  80045a:	c3                   	ret    

0080045b <sys_pkt_send>:

int
sys_pkt_send(void *addr, int size)
{
  80045b:	55                   	push   %ebp
  80045c:	89 e5                	mov    %esp,%ebp
  80045e:	57                   	push   %edi
  80045f:	56                   	push   %esi
  800460:	53                   	push   %ebx
  800461:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800464:	bb 00 00 00 00       	mov    $0x0,%ebx
  800469:	b8 10 00 00 00       	mov    $0x10,%eax
  80046e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800471:	8b 55 08             	mov    0x8(%ebp),%edx
  800474:	89 df                	mov    %ebx,%edi
  800476:	89 de                	mov    %ebx,%esi
  800478:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80047a:	85 c0                	test   %eax,%eax
  80047c:	7e 28                	jle    8004a6 <sys_pkt_send+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80047e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800482:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800489:	00 
  80048a:	c7 44 24 08 ca 26 80 	movl   $0x8026ca,0x8(%esp)
  800491:	00 
  800492:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800499:	00 
  80049a:	c7 04 24 e7 26 80 00 	movl   $0x8026e7,(%esp)
  8004a1:	e8 c0 13 00 00       	call   801866 <_panic>

int
sys_pkt_send(void *addr, int size)
{
	return syscall(SYS_pkt_send, 1, (uint32_t)addr, size, 0, 0, 0);
}
  8004a6:	83 c4 2c             	add    $0x2c,%esp
  8004a9:	5b                   	pop    %ebx
  8004aa:	5e                   	pop    %esi
  8004ab:	5f                   	pop    %edi
  8004ac:	5d                   	pop    %ebp
  8004ad:	c3                   	ret    

008004ae <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *size)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	57                   	push   %edi
  8004b2:	56                   	push   %esi
  8004b3:	53                   	push   %ebx
  8004b4:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004bc:	b8 11 00 00 00       	mov    $0x11,%eax
  8004c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c7:	89 df                	mov    %ebx,%edi
  8004c9:	89 de                	mov    %ebx,%esi
  8004cb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8004cd:	85 c0                	test   %eax,%eax
  8004cf:	7e 28                	jle    8004f9 <sys_pkt_recv+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8004d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004d5:	c7 44 24 0c 11 00 00 	movl   $0x11,0xc(%esp)
  8004dc:	00 
  8004dd:	c7 44 24 08 ca 26 80 	movl   $0x8026ca,0x8(%esp)
  8004e4:	00 
  8004e5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004ec:	00 
  8004ed:	c7 04 24 e7 26 80 00 	movl   $0x8026e7,(%esp)
  8004f4:	e8 6d 13 00 00       	call   801866 <_panic>

int
sys_pkt_recv(void *addr, size_t *size)
{
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)size, 0, 0, 0);
}
  8004f9:	83 c4 2c             	add    $0x2c,%esp
  8004fc:	5b                   	pop    %ebx
  8004fd:	5e                   	pop    %esi
  8004fe:	5f                   	pop    %edi
  8004ff:	5d                   	pop    %ebp
  800500:	c3                   	ret    

00800501 <sys_sleep>:

int
sys_sleep(int channel)
{
  800501:	55                   	push   %ebp
  800502:	89 e5                	mov    %esp,%ebp
  800504:	57                   	push   %edi
  800505:	56                   	push   %esi
  800506:	53                   	push   %ebx
  800507:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80050a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80050f:	b8 12 00 00 00       	mov    $0x12,%eax
  800514:	8b 55 08             	mov    0x8(%ebp),%edx
  800517:	89 cb                	mov    %ecx,%ebx
  800519:	89 cf                	mov    %ecx,%edi
  80051b:	89 ce                	mov    %ecx,%esi
  80051d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80051f:	85 c0                	test   %eax,%eax
  800521:	7e 28                	jle    80054b <sys_sleep+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800523:	89 44 24 10          	mov    %eax,0x10(%esp)
  800527:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80052e:	00 
  80052f:	c7 44 24 08 ca 26 80 	movl   $0x8026ca,0x8(%esp)
  800536:	00 
  800537:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80053e:	00 
  80053f:	c7 04 24 e7 26 80 00 	movl   $0x8026e7,(%esp)
  800546:	e8 1b 13 00 00       	call   801866 <_panic>

int
sys_sleep(int channel)
{
	return syscall(SYS_sleep, 1, channel, 0, 0, 0, 0);
}
  80054b:	83 c4 2c             	add    $0x2c,%esp
  80054e:	5b                   	pop    %ebx
  80054f:	5e                   	pop    %esi
  800550:	5f                   	pop    %edi
  800551:	5d                   	pop    %ebp
  800552:	c3                   	ret    

00800553 <sys_get_mac_from_eeprom>:

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
  800553:	55                   	push   %ebp
  800554:	89 e5                	mov    %esp,%ebp
  800556:	57                   	push   %edi
  800557:	56                   	push   %esi
  800558:	53                   	push   %ebx
  800559:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80055c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800561:	b8 13 00 00 00       	mov    $0x13,%eax
  800566:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800569:	8b 55 08             	mov    0x8(%ebp),%edx
  80056c:	89 df                	mov    %ebx,%edi
  80056e:	89 de                	mov    %ebx,%esi
  800570:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800572:	85 c0                	test   %eax,%eax
  800574:	7e 28                	jle    80059e <sys_get_mac_from_eeprom+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800576:	89 44 24 10          	mov    %eax,0x10(%esp)
  80057a:	c7 44 24 0c 13 00 00 	movl   $0x13,0xc(%esp)
  800581:	00 
  800582:	c7 44 24 08 ca 26 80 	movl   $0x8026ca,0x8(%esp)
  800589:	00 
  80058a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800591:	00 
  800592:	c7 04 24 e7 26 80 00 	movl   $0x8026e7,(%esp)
  800599:	e8 c8 12 00 00       	call   801866 <_panic>

int
sys_get_mac_from_eeprom(uint32_t* low, uint32_t* high)
{
	return syscall(SYS_get_mac_from_eeprom, 1, (uint32_t)low, (uint32_t)high, 0, 0, 0);
}
  80059e:	83 c4 2c             	add    $0x2c,%esp
  8005a1:	5b                   	pop    %ebx
  8005a2:	5e                   	pop    %esi
  8005a3:	5f                   	pop    %edi
  8005a4:	5d                   	pop    %ebp
  8005a5:	c3                   	ret    
  8005a6:	66 90                	xchg   %ax,%ax
  8005a8:	66 90                	xchg   %ax,%ax
  8005aa:	66 90                	xchg   %ax,%ax
  8005ac:	66 90                	xchg   %ax,%ax
  8005ae:	66 90                	xchg   %ax,%ax

008005b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8005b0:	55                   	push   %ebp
  8005b1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8005bb:	c1 e8 0c             	shr    $0xc,%eax
}
  8005be:	5d                   	pop    %ebp
  8005bf:	c3                   	ret    

008005c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8005c0:	55                   	push   %ebp
  8005c1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8005cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005d0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8005d5:	5d                   	pop    %ebp
  8005d6:	c3                   	ret    

008005d7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005d7:	55                   	push   %ebp
  8005d8:	89 e5                	mov    %esp,%ebp
  8005da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005dd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005e2:	89 c2                	mov    %eax,%edx
  8005e4:	c1 ea 16             	shr    $0x16,%edx
  8005e7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8005ee:	f6 c2 01             	test   $0x1,%dl
  8005f1:	74 11                	je     800604 <fd_alloc+0x2d>
  8005f3:	89 c2                	mov    %eax,%edx
  8005f5:	c1 ea 0c             	shr    $0xc,%edx
  8005f8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8005ff:	f6 c2 01             	test   $0x1,%dl
  800602:	75 09                	jne    80060d <fd_alloc+0x36>
			*fd_store = fd;
  800604:	89 01                	mov    %eax,(%ecx)
			return 0;
  800606:	b8 00 00 00 00       	mov    $0x0,%eax
  80060b:	eb 17                	jmp    800624 <fd_alloc+0x4d>
  80060d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800612:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800617:	75 c9                	jne    8005e2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800619:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80061f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800624:	5d                   	pop    %ebp
  800625:	c3                   	ret    

00800626 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80062c:	83 f8 1f             	cmp    $0x1f,%eax
  80062f:	77 36                	ja     800667 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800631:	c1 e0 0c             	shl    $0xc,%eax
  800634:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800639:	89 c2                	mov    %eax,%edx
  80063b:	c1 ea 16             	shr    $0x16,%edx
  80063e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800645:	f6 c2 01             	test   $0x1,%dl
  800648:	74 24                	je     80066e <fd_lookup+0x48>
  80064a:	89 c2                	mov    %eax,%edx
  80064c:	c1 ea 0c             	shr    $0xc,%edx
  80064f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800656:	f6 c2 01             	test   $0x1,%dl
  800659:	74 1a                	je     800675 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80065b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80065e:	89 02                	mov    %eax,(%edx)
	return 0;
  800660:	b8 00 00 00 00       	mov    $0x0,%eax
  800665:	eb 13                	jmp    80067a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800667:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80066c:	eb 0c                	jmp    80067a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80066e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800673:	eb 05                	jmp    80067a <fd_lookup+0x54>
  800675:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80067a:	5d                   	pop    %ebp
  80067b:	c3                   	ret    

0080067c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
  80067f:	83 ec 18             	sub    $0x18,%esp
  800682:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800685:	ba 00 00 00 00       	mov    $0x0,%edx
  80068a:	eb 13                	jmp    80069f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80068c:	39 08                	cmp    %ecx,(%eax)
  80068e:	75 0c                	jne    80069c <dev_lookup+0x20>
			*dev = devtab[i];
  800690:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800693:	89 01                	mov    %eax,(%ecx)
			return 0;
  800695:	b8 00 00 00 00       	mov    $0x0,%eax
  80069a:	eb 38                	jmp    8006d4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80069c:	83 c2 01             	add    $0x1,%edx
  80069f:	8b 04 95 74 27 80 00 	mov    0x802774(,%edx,4),%eax
  8006a6:	85 c0                	test   %eax,%eax
  8006a8:	75 e2                	jne    80068c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8006aa:	a1 08 40 80 00       	mov    0x804008,%eax
  8006af:	8b 40 48             	mov    0x48(%eax),%eax
  8006b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ba:	c7 04 24 f8 26 80 00 	movl   $0x8026f8,(%esp)
  8006c1:	e8 99 12 00 00       	call   80195f <cprintf>
	*dev = 0;
  8006c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8006cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8006d4:	c9                   	leave  
  8006d5:	c3                   	ret    

008006d6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006d6:	55                   	push   %ebp
  8006d7:	89 e5                	mov    %esp,%ebp
  8006d9:	56                   	push   %esi
  8006da:	53                   	push   %ebx
  8006db:	83 ec 20             	sub    $0x20,%esp
  8006de:	8b 75 08             	mov    0x8(%ebp),%esi
  8006e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006e7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8006eb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8006f1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006f4:	89 04 24             	mov    %eax,(%esp)
  8006f7:	e8 2a ff ff ff       	call   800626 <fd_lookup>
  8006fc:	85 c0                	test   %eax,%eax
  8006fe:	78 05                	js     800705 <fd_close+0x2f>
	    || fd != fd2)
  800700:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800703:	74 0c                	je     800711 <fd_close+0x3b>
		return (must_exist ? r : 0);
  800705:	84 db                	test   %bl,%bl
  800707:	ba 00 00 00 00       	mov    $0x0,%edx
  80070c:	0f 44 c2             	cmove  %edx,%eax
  80070f:	eb 3f                	jmp    800750 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800711:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800714:	89 44 24 04          	mov    %eax,0x4(%esp)
  800718:	8b 06                	mov    (%esi),%eax
  80071a:	89 04 24             	mov    %eax,(%esp)
  80071d:	e8 5a ff ff ff       	call   80067c <dev_lookup>
  800722:	89 c3                	mov    %eax,%ebx
  800724:	85 c0                	test   %eax,%eax
  800726:	78 16                	js     80073e <fd_close+0x68>
		if (dev->dev_close)
  800728:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80072e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800733:	85 c0                	test   %eax,%eax
  800735:	74 07                	je     80073e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800737:	89 34 24             	mov    %esi,(%esp)
  80073a:	ff d0                	call   *%eax
  80073c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80073e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800742:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800749:	e8 da fa ff ff       	call   800228 <sys_page_unmap>
	return r;
  80074e:	89 d8                	mov    %ebx,%eax
}
  800750:	83 c4 20             	add    $0x20,%esp
  800753:	5b                   	pop    %ebx
  800754:	5e                   	pop    %esi
  800755:	5d                   	pop    %ebp
  800756:	c3                   	ret    

00800757 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80075d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800760:	89 44 24 04          	mov    %eax,0x4(%esp)
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	89 04 24             	mov    %eax,(%esp)
  80076a:	e8 b7 fe ff ff       	call   800626 <fd_lookup>
  80076f:	89 c2                	mov    %eax,%edx
  800771:	85 d2                	test   %edx,%edx
  800773:	78 13                	js     800788 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800775:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80077c:	00 
  80077d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800780:	89 04 24             	mov    %eax,(%esp)
  800783:	e8 4e ff ff ff       	call   8006d6 <fd_close>
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <close_all>:

void
close_all(void)
{
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	53                   	push   %ebx
  80078e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800791:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800796:	89 1c 24             	mov    %ebx,(%esp)
  800799:	e8 b9 ff ff ff       	call   800757 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80079e:	83 c3 01             	add    $0x1,%ebx
  8007a1:	83 fb 20             	cmp    $0x20,%ebx
  8007a4:	75 f0                	jne    800796 <close_all+0xc>
		close(i);
}
  8007a6:	83 c4 14             	add    $0x14,%esp
  8007a9:	5b                   	pop    %ebx
  8007aa:	5d                   	pop    %ebp
  8007ab:	c3                   	ret    

008007ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8007ac:	55                   	push   %ebp
  8007ad:	89 e5                	mov    %esp,%ebp
  8007af:	57                   	push   %edi
  8007b0:	56                   	push   %esi
  8007b1:	53                   	push   %ebx
  8007b2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8007b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8007b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	89 04 24             	mov    %eax,(%esp)
  8007c2:	e8 5f fe ff ff       	call   800626 <fd_lookup>
  8007c7:	89 c2                	mov    %eax,%edx
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	0f 88 e1 00 00 00    	js     8008b2 <dup+0x106>
		return r;
	close(newfdnum);
  8007d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d4:	89 04 24             	mov    %eax,(%esp)
  8007d7:	e8 7b ff ff ff       	call   800757 <close>

	newfd = INDEX2FD(newfdnum);
  8007dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007df:	c1 e3 0c             	shl    $0xc,%ebx
  8007e2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8007e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007eb:	89 04 24             	mov    %eax,(%esp)
  8007ee:	e8 cd fd ff ff       	call   8005c0 <fd2data>
  8007f3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8007f5:	89 1c 24             	mov    %ebx,(%esp)
  8007f8:	e8 c3 fd ff ff       	call   8005c0 <fd2data>
  8007fd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8007ff:	89 f0                	mov    %esi,%eax
  800801:	c1 e8 16             	shr    $0x16,%eax
  800804:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80080b:	a8 01                	test   $0x1,%al
  80080d:	74 43                	je     800852 <dup+0xa6>
  80080f:	89 f0                	mov    %esi,%eax
  800811:	c1 e8 0c             	shr    $0xc,%eax
  800814:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80081b:	f6 c2 01             	test   $0x1,%dl
  80081e:	74 32                	je     800852 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800820:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800827:	25 07 0e 00 00       	and    $0xe07,%eax
  80082c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800830:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800834:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80083b:	00 
  80083c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800840:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800847:	e8 89 f9 ff ff       	call   8001d5 <sys_page_map>
  80084c:	89 c6                	mov    %eax,%esi
  80084e:	85 c0                	test   %eax,%eax
  800850:	78 3e                	js     800890 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800855:	89 c2                	mov    %eax,%edx
  800857:	c1 ea 0c             	shr    $0xc,%edx
  80085a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800861:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800867:	89 54 24 10          	mov    %edx,0x10(%esp)
  80086b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80086f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800876:	00 
  800877:	89 44 24 04          	mov    %eax,0x4(%esp)
  80087b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800882:	e8 4e f9 ff ff       	call   8001d5 <sys_page_map>
  800887:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  800889:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80088c:	85 f6                	test   %esi,%esi
  80088e:	79 22                	jns    8008b2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800890:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800894:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80089b:	e8 88 f9 ff ff       	call   800228 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8008a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8008ab:	e8 78 f9 ff ff       	call   800228 <sys_page_unmap>
	return r;
  8008b0:	89 f0                	mov    %esi,%eax
}
  8008b2:	83 c4 3c             	add    $0x3c,%esp
  8008b5:	5b                   	pop    %ebx
  8008b6:	5e                   	pop    %esi
  8008b7:	5f                   	pop    %edi
  8008b8:	5d                   	pop    %ebp
  8008b9:	c3                   	ret    

008008ba <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	53                   	push   %ebx
  8008be:	83 ec 24             	sub    $0x24,%esp
  8008c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008cb:	89 1c 24             	mov    %ebx,(%esp)
  8008ce:	e8 53 fd ff ff       	call   800626 <fd_lookup>
  8008d3:	89 c2                	mov    %eax,%edx
  8008d5:	85 d2                	test   %edx,%edx
  8008d7:	78 6d                	js     800946 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	89 04 24             	mov    %eax,(%esp)
  8008e8:	e8 8f fd ff ff       	call   80067c <dev_lookup>
  8008ed:	85 c0                	test   %eax,%eax
  8008ef:	78 55                	js     800946 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8008f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f4:	8b 50 08             	mov    0x8(%eax),%edx
  8008f7:	83 e2 03             	and    $0x3,%edx
  8008fa:	83 fa 01             	cmp    $0x1,%edx
  8008fd:	75 23                	jne    800922 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8008ff:	a1 08 40 80 00       	mov    0x804008,%eax
  800904:	8b 40 48             	mov    0x48(%eax),%eax
  800907:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80090b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80090f:	c7 04 24 39 27 80 00 	movl   $0x802739,(%esp)
  800916:	e8 44 10 00 00       	call   80195f <cprintf>
		return -E_INVAL;
  80091b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800920:	eb 24                	jmp    800946 <read+0x8c>
	}
	if (!dev->dev_read)
  800922:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800925:	8b 52 08             	mov    0x8(%edx),%edx
  800928:	85 d2                	test   %edx,%edx
  80092a:	74 15                	je     800941 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80092c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80092f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800933:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800936:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80093a:	89 04 24             	mov    %eax,(%esp)
  80093d:	ff d2                	call   *%edx
  80093f:	eb 05                	jmp    800946 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800941:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800946:	83 c4 24             	add    $0x24,%esp
  800949:	5b                   	pop    %ebx
  80094a:	5d                   	pop    %ebp
  80094b:	c3                   	ret    

0080094c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	57                   	push   %edi
  800950:	56                   	push   %esi
  800951:	53                   	push   %ebx
  800952:	83 ec 1c             	sub    $0x1c,%esp
  800955:	8b 7d 08             	mov    0x8(%ebp),%edi
  800958:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80095b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800960:	eb 23                	jmp    800985 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800962:	89 f0                	mov    %esi,%eax
  800964:	29 d8                	sub    %ebx,%eax
  800966:	89 44 24 08          	mov    %eax,0x8(%esp)
  80096a:	89 d8                	mov    %ebx,%eax
  80096c:	03 45 0c             	add    0xc(%ebp),%eax
  80096f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800973:	89 3c 24             	mov    %edi,(%esp)
  800976:	e8 3f ff ff ff       	call   8008ba <read>
		if (m < 0)
  80097b:	85 c0                	test   %eax,%eax
  80097d:	78 10                	js     80098f <readn+0x43>
			return m;
		if (m == 0)
  80097f:	85 c0                	test   %eax,%eax
  800981:	74 0a                	je     80098d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800983:	01 c3                	add    %eax,%ebx
  800985:	39 f3                	cmp    %esi,%ebx
  800987:	72 d9                	jb     800962 <readn+0x16>
  800989:	89 d8                	mov    %ebx,%eax
  80098b:	eb 02                	jmp    80098f <readn+0x43>
  80098d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80098f:	83 c4 1c             	add    $0x1c,%esp
  800992:	5b                   	pop    %ebx
  800993:	5e                   	pop    %esi
  800994:	5f                   	pop    %edi
  800995:	5d                   	pop    %ebp
  800996:	c3                   	ret    

00800997 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	53                   	push   %ebx
  80099b:	83 ec 24             	sub    $0x24,%esp
  80099e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8009a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a8:	89 1c 24             	mov    %ebx,(%esp)
  8009ab:	e8 76 fc ff ff       	call   800626 <fd_lookup>
  8009b0:	89 c2                	mov    %eax,%edx
  8009b2:	85 d2                	test   %edx,%edx
  8009b4:	78 68                	js     800a1e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c0:	8b 00                	mov    (%eax),%eax
  8009c2:	89 04 24             	mov    %eax,(%esp)
  8009c5:	e8 b2 fc ff ff       	call   80067c <dev_lookup>
  8009ca:	85 c0                	test   %eax,%eax
  8009cc:	78 50                	js     800a1e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8009d5:	75 23                	jne    8009fa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8009d7:	a1 08 40 80 00       	mov    0x804008,%eax
  8009dc:	8b 40 48             	mov    0x48(%eax),%eax
  8009df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8009e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e7:	c7 04 24 55 27 80 00 	movl   $0x802755,(%esp)
  8009ee:	e8 6c 0f 00 00       	call   80195f <cprintf>
		return -E_INVAL;
  8009f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f8:	eb 24                	jmp    800a1e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8009fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009fd:	8b 52 0c             	mov    0xc(%edx),%edx
  800a00:	85 d2                	test   %edx,%edx
  800a02:	74 15                	je     800a19 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800a04:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800a0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a12:	89 04 24             	mov    %eax,(%esp)
  800a15:	ff d2                	call   *%edx
  800a17:	eb 05                	jmp    800a1e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800a19:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  800a1e:	83 c4 24             	add    $0x24,%esp
  800a21:	5b                   	pop    %ebx
  800a22:	5d                   	pop    %ebp
  800a23:	c3                   	ret    

00800a24 <seek>:

int
seek(int fdnum, off_t offset)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800a2a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	89 04 24             	mov    %eax,(%esp)
  800a37:	e8 ea fb ff ff       	call   800626 <fd_lookup>
  800a3c:	85 c0                	test   %eax,%eax
  800a3e:	78 0e                	js     800a4e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800a40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a46:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800a49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4e:	c9                   	leave  
  800a4f:	c3                   	ret    

00800a50 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	53                   	push   %ebx
  800a54:	83 ec 24             	sub    $0x24,%esp
  800a57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a5a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a61:	89 1c 24             	mov    %ebx,(%esp)
  800a64:	e8 bd fb ff ff       	call   800626 <fd_lookup>
  800a69:	89 c2                	mov    %eax,%edx
  800a6b:	85 d2                	test   %edx,%edx
  800a6d:	78 61                	js     800ad0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a72:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a79:	8b 00                	mov    (%eax),%eax
  800a7b:	89 04 24             	mov    %eax,(%esp)
  800a7e:	e8 f9 fb ff ff       	call   80067c <dev_lookup>
  800a83:	85 c0                	test   %eax,%eax
  800a85:	78 49                	js     800ad0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800a8e:	75 23                	jne    800ab3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800a90:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800a95:	8b 40 48             	mov    0x48(%eax),%eax
  800a98:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa0:	c7 04 24 18 27 80 00 	movl   $0x802718,(%esp)
  800aa7:	e8 b3 0e 00 00       	call   80195f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800aac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ab1:	eb 1d                	jmp    800ad0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  800ab3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab6:	8b 52 18             	mov    0x18(%edx),%edx
  800ab9:	85 d2                	test   %edx,%edx
  800abb:	74 0e                	je     800acb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800abd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ac4:	89 04 24             	mov    %eax,(%esp)
  800ac7:	ff d2                	call   *%edx
  800ac9:	eb 05                	jmp    800ad0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800acb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800ad0:	83 c4 24             	add    $0x24,%esp
  800ad3:	5b                   	pop    %ebx
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	53                   	push   %ebx
  800ada:	83 ec 24             	sub    $0x24,%esp
  800add:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ae0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	89 04 24             	mov    %eax,(%esp)
  800aed:	e8 34 fb ff ff       	call   800626 <fd_lookup>
  800af2:	89 c2                	mov    %eax,%edx
  800af4:	85 d2                	test   %edx,%edx
  800af6:	78 52                	js     800b4a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800af8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800afb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b02:	8b 00                	mov    (%eax),%eax
  800b04:	89 04 24             	mov    %eax,(%esp)
  800b07:	e8 70 fb ff ff       	call   80067c <dev_lookup>
  800b0c:	85 c0                	test   %eax,%eax
  800b0e:	78 3a                	js     800b4a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b13:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800b17:	74 2c                	je     800b45 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800b19:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800b1c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800b23:	00 00 00 
	stat->st_isdir = 0;
  800b26:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b2d:	00 00 00 
	stat->st_dev = dev;
  800b30:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800b36:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800b3d:	89 14 24             	mov    %edx,(%esp)
  800b40:	ff 50 14             	call   *0x14(%eax)
  800b43:	eb 05                	jmp    800b4a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800b45:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800b4a:	83 c4 24             	add    $0x24,%esp
  800b4d:	5b                   	pop    %ebx
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    

00800b50 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
  800b55:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800b58:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800b5f:	00 
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	89 04 24             	mov    %eax,(%esp)
  800b66:	e8 1b 02 00 00       	call   800d86 <open>
  800b6b:	89 c3                	mov    %eax,%ebx
  800b6d:	85 db                	test   %ebx,%ebx
  800b6f:	78 1b                	js     800b8c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b74:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b78:	89 1c 24             	mov    %ebx,(%esp)
  800b7b:	e8 56 ff ff ff       	call   800ad6 <fstat>
  800b80:	89 c6                	mov    %eax,%esi
	close(fd);
  800b82:	89 1c 24             	mov    %ebx,(%esp)
  800b85:	e8 cd fb ff ff       	call   800757 <close>
	return r;
  800b8a:	89 f0                	mov    %esi,%eax
}
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    

00800b93 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	56                   	push   %esi
  800b97:	53                   	push   %ebx
  800b98:	83 ec 10             	sub    $0x10,%esp
  800b9b:	89 c6                	mov    %eax,%esi
  800b9d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800b9f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800ba6:	75 11                	jne    800bb9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ba8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800baf:	e8 eb 17 00 00       	call   80239f <ipc_find_env>
  800bb4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800bb9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800bc0:	00 
  800bc1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800bc8:	00 
  800bc9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bcd:	a1 00 40 80 00       	mov    0x804000,%eax
  800bd2:	89 04 24             	mov    %eax,(%esp)
  800bd5:	e8 5a 17 00 00       	call   802334 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800bda:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800be1:	00 
  800be2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800be6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800bed:	e8 ee 16 00 00       	call   8022e0 <ipc_recv>
}
  800bf2:	83 c4 10             	add    $0x10,%esp
  800bf5:	5b                   	pop    %ebx
  800bf6:	5e                   	pop    %esi
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    

00800bf9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	8b 40 0c             	mov    0xc(%eax),%eax
  800c05:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800c12:	ba 00 00 00 00       	mov    $0x0,%edx
  800c17:	b8 02 00 00 00       	mov    $0x2,%eax
  800c1c:	e8 72 ff ff ff       	call   800b93 <fsipc>
}
  800c21:	c9                   	leave  
  800c22:	c3                   	ret    

00800c23 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8b 40 0c             	mov    0xc(%eax),%eax
  800c2f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800c34:	ba 00 00 00 00       	mov    $0x0,%edx
  800c39:	b8 06 00 00 00       	mov    $0x6,%eax
  800c3e:	e8 50 ff ff ff       	call   800b93 <fsipc>
}
  800c43:	c9                   	leave  
  800c44:	c3                   	ret    

00800c45 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	53                   	push   %ebx
  800c49:	83 ec 14             	sub    $0x14,%esp
  800c4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8b 40 0c             	mov    0xc(%eax),%eax
  800c55:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800c5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5f:	b8 05 00 00 00       	mov    $0x5,%eax
  800c64:	e8 2a ff ff ff       	call   800b93 <fsipc>
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	85 d2                	test   %edx,%edx
  800c6d:	78 2b                	js     800c9a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800c6f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800c76:	00 
  800c77:	89 1c 24             	mov    %ebx,(%esp)
  800c7a:	e8 08 13 00 00       	call   801f87 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800c7f:	a1 80 50 80 00       	mov    0x805080,%eax
  800c84:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800c8a:	a1 84 50 80 00       	mov    0x805084,%eax
  800c8f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9a:	83 c4 14             	add    $0x14,%esp
  800c9d:	5b                   	pop    %ebx
  800c9e:	5d                   	pop    %ebp
  800c9f:	c3                   	ret    

00800ca0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 18             	sub    $0x18,%esp
  800ca6:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 52 0c             	mov    0xc(%edx),%edx
  800caf:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  800cb5:	a3 04 50 80 00       	mov    %eax,0x805004
	
	memcpy(fsipcbuf.write.req_buf, buf, n);
  800cba:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cc5:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  800ccc:	e8 bb 14 00 00       	call   80218c <memcpy>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0){
  800cd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd6:	b8 04 00 00 00       	mov    $0x4,%eax
  800cdb:	e8 b3 fe ff ff       	call   800b93 <fsipc>
		return r;
	}

	return r;
}
  800ce0:	c9                   	leave  
  800ce1:	c3                   	ret    

00800ce2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
  800ce7:	83 ec 10             	sub    $0x10,%esp
  800cea:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	8b 40 0c             	mov    0xc(%eax),%eax
  800cf3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800cf8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800cfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800d03:	b8 03 00 00 00       	mov    $0x3,%eax
  800d08:	e8 86 fe ff ff       	call   800b93 <fsipc>
  800d0d:	89 c3                	mov    %eax,%ebx
  800d0f:	85 c0                	test   %eax,%eax
  800d11:	78 6a                	js     800d7d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800d13:	39 c6                	cmp    %eax,%esi
  800d15:	73 24                	jae    800d3b <devfile_read+0x59>
  800d17:	c7 44 24 0c 88 27 80 	movl   $0x802788,0xc(%esp)
  800d1e:	00 
  800d1f:	c7 44 24 08 8f 27 80 	movl   $0x80278f,0x8(%esp)
  800d26:	00 
  800d27:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  800d2e:	00 
  800d2f:	c7 04 24 a4 27 80 00 	movl   $0x8027a4,(%esp)
  800d36:	e8 2b 0b 00 00       	call   801866 <_panic>
	assert(r <= PGSIZE);
  800d3b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800d40:	7e 24                	jle    800d66 <devfile_read+0x84>
  800d42:	c7 44 24 0c af 27 80 	movl   $0x8027af,0xc(%esp)
  800d49:	00 
  800d4a:	c7 44 24 08 8f 27 80 	movl   $0x80278f,0x8(%esp)
  800d51:	00 
  800d52:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  800d59:	00 
  800d5a:	c7 04 24 a4 27 80 00 	movl   $0x8027a4,(%esp)
  800d61:	e8 00 0b 00 00       	call   801866 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800d66:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d6a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800d71:	00 
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	89 04 24             	mov    %eax,(%esp)
  800d78:	e8 a7 13 00 00       	call   802124 <memmove>
	return r;
}
  800d7d:	89 d8                	mov    %ebx,%eax
  800d7f:	83 c4 10             	add    $0x10,%esp
  800d82:	5b                   	pop    %ebx
  800d83:	5e                   	pop    %esi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	53                   	push   %ebx
  800d8a:	83 ec 24             	sub    $0x24,%esp
  800d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800d90:	89 1c 24             	mov    %ebx,(%esp)
  800d93:	e8 b8 11 00 00       	call   801f50 <strlen>
  800d98:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800d9d:	7f 60                	jg     800dff <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800d9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800da2:	89 04 24             	mov    %eax,(%esp)
  800da5:	e8 2d f8 ff ff       	call   8005d7 <fd_alloc>
  800daa:	89 c2                	mov    %eax,%edx
  800dac:	85 d2                	test   %edx,%edx
  800dae:	78 54                	js     800e04 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800db0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800db4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800dbb:	e8 c7 11 00 00       	call   801f87 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800dc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dcb:	b8 01 00 00 00       	mov    $0x1,%eax
  800dd0:	e8 be fd ff ff       	call   800b93 <fsipc>
  800dd5:	89 c3                	mov    %eax,%ebx
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	79 17                	jns    800df2 <open+0x6c>
		fd_close(fd, 0);
  800ddb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800de2:	00 
  800de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800de6:	89 04 24             	mov    %eax,(%esp)
  800de9:	e8 e8 f8 ff ff       	call   8006d6 <fd_close>
		return r;
  800dee:	89 d8                	mov    %ebx,%eax
  800df0:	eb 12                	jmp    800e04 <open+0x7e>
	}

	return fd2num(fd);
  800df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800df5:	89 04 24             	mov    %eax,(%esp)
  800df8:	e8 b3 f7 ff ff       	call   8005b0 <fd2num>
  800dfd:	eb 05                	jmp    800e04 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800dff:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800e04:	83 c4 24             	add    $0x24,%esp
  800e07:	5b                   	pop    %ebx
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800e10:	ba 00 00 00 00       	mov    $0x0,%edx
  800e15:	b8 08 00 00 00       	mov    $0x8,%eax
  800e1a:	e8 74 fd ff ff       	call   800b93 <fsipc>
}
  800e1f:	c9                   	leave  
  800e20:	c3                   	ret    
  800e21:	66 90                	xchg   %ax,%ax
  800e23:	66 90                	xchg   %ax,%ax
  800e25:	66 90                	xchg   %ax,%ax
  800e27:	66 90                	xchg   %ax,%ax
  800e29:	66 90                	xchg   %ax,%ax
  800e2b:	66 90                	xchg   %ax,%ax
  800e2d:	66 90                	xchg   %ax,%ax
  800e2f:	90                   	nop

00800e30 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800e36:	c7 44 24 04 bb 27 80 	movl   $0x8027bb,0x4(%esp)
  800e3d:	00 
  800e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e41:	89 04 24             	mov    %eax,(%esp)
  800e44:	e8 3e 11 00 00       	call   801f87 <strcpy>
	return 0;
}
  800e49:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4e:	c9                   	leave  
  800e4f:	c3                   	ret    

00800e50 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	53                   	push   %ebx
  800e54:	83 ec 14             	sub    $0x14,%esp
  800e57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800e5a:	89 1c 24             	mov    %ebx,(%esp)
  800e5d:	e8 7c 15 00 00       	call   8023de <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  800e62:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  800e67:	83 f8 01             	cmp    $0x1,%eax
  800e6a:	75 0d                	jne    800e79 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  800e6c:	8b 43 0c             	mov    0xc(%ebx),%eax
  800e6f:	89 04 24             	mov    %eax,(%esp)
  800e72:	e8 29 03 00 00       	call   8011a0 <nsipc_close>
  800e77:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  800e79:	89 d0                	mov    %edx,%eax
  800e7b:	83 c4 14             	add    $0x14,%esp
  800e7e:	5b                   	pop    %ebx
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    

00800e81 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800e87:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800e8e:	00 
  800e8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e92:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e99:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8b 40 0c             	mov    0xc(%eax),%eax
  800ea3:	89 04 24             	mov    %eax,(%esp)
  800ea6:	e8 f0 03 00 00       	call   80129b <nsipc_send>
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800eb3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800eba:	00 
  800ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebe:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	8b 40 0c             	mov    0xc(%eax),%eax
  800ecf:	89 04 24             	mov    %eax,(%esp)
  800ed2:	e8 44 03 00 00       	call   80121b <nsipc_recv>
}
  800ed7:	c9                   	leave  
  800ed8:	c3                   	ret    

00800ed9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800edf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800ee2:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ee6:	89 04 24             	mov    %eax,(%esp)
  800ee9:	e8 38 f7 ff ff       	call   800626 <fd_lookup>
  800eee:	85 c0                	test   %eax,%eax
  800ef0:	78 17                	js     800f09 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800efb:	39 08                	cmp    %ecx,(%eax)
  800efd:	75 05                	jne    800f04 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800eff:	8b 40 0c             	mov    0xc(%eax),%eax
  800f02:	eb 05                	jmp    800f09 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  800f04:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  800f09:	c9                   	leave  
  800f0a:	c3                   	ret    

00800f0b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	56                   	push   %esi
  800f0f:	53                   	push   %ebx
  800f10:	83 ec 20             	sub    $0x20,%esp
  800f13:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800f15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f18:	89 04 24             	mov    %eax,(%esp)
  800f1b:	e8 b7 f6 ff ff       	call   8005d7 <fd_alloc>
  800f20:	89 c3                	mov    %eax,%ebx
  800f22:	85 c0                	test   %eax,%eax
  800f24:	78 21                	js     800f47 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800f26:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f2d:	00 
  800f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f31:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f3c:	e8 40 f2 ff ff       	call   800181 <sys_page_alloc>
  800f41:	89 c3                	mov    %eax,%ebx
  800f43:	85 c0                	test   %eax,%eax
  800f45:	79 0c                	jns    800f53 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  800f47:	89 34 24             	mov    %esi,(%esp)
  800f4a:	e8 51 02 00 00       	call   8011a0 <nsipc_close>
		return r;
  800f4f:	89 d8                	mov    %ebx,%eax
  800f51:	eb 20                	jmp    800f73 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800f53:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f5c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f61:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  800f68:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  800f6b:	89 14 24             	mov    %edx,(%esp)
  800f6e:	e8 3d f6 ff ff       	call   8005b0 <fd2num>
}
  800f73:	83 c4 20             	add    $0x20,%esp
  800f76:	5b                   	pop    %ebx
  800f77:	5e                   	pop    %esi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    

00800f7a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	e8 51 ff ff ff       	call   800ed9 <fd2sockid>
		return r;
  800f88:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	78 23                	js     800fb1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f8e:	8b 55 10             	mov    0x10(%ebp),%edx
  800f91:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f98:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f9c:	89 04 24             	mov    %eax,(%esp)
  800f9f:	e8 45 01 00 00       	call   8010e9 <nsipc_accept>
		return r;
  800fa4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800fa6:	85 c0                	test   %eax,%eax
  800fa8:	78 07                	js     800fb1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  800faa:	e8 5c ff ff ff       	call   800f0b <alloc_sockfd>
  800faf:	89 c1                	mov    %eax,%ecx
}
  800fb1:	89 c8                	mov    %ecx,%eax
  800fb3:	c9                   	leave  
  800fb4:	c3                   	ret    

00800fb5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	e8 16 ff ff ff       	call   800ed9 <fd2sockid>
  800fc3:	89 c2                	mov    %eax,%edx
  800fc5:	85 d2                	test   %edx,%edx
  800fc7:	78 16                	js     800fdf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fd7:	89 14 24             	mov    %edx,(%esp)
  800fda:	e8 60 01 00 00       	call   80113f <nsipc_bind>
}
  800fdf:	c9                   	leave  
  800fe0:	c3                   	ret    

00800fe1 <shutdown>:

int
shutdown(int s, int how)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	e8 ea fe ff ff       	call   800ed9 <fd2sockid>
  800fef:	89 c2                	mov    %eax,%edx
  800ff1:	85 d2                	test   %edx,%edx
  800ff3:	78 0f                	js     801004 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  800ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ffc:	89 14 24             	mov    %edx,(%esp)
  800fff:	e8 7a 01 00 00       	call   80117e <nsipc_shutdown>
}
  801004:	c9                   	leave  
  801005:	c3                   	ret    

00801006 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	e8 c5 fe ff ff       	call   800ed9 <fd2sockid>
  801014:	89 c2                	mov    %eax,%edx
  801016:	85 d2                	test   %edx,%edx
  801018:	78 16                	js     801030 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80101a:	8b 45 10             	mov    0x10(%ebp),%eax
  80101d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	89 44 24 04          	mov    %eax,0x4(%esp)
  801028:	89 14 24             	mov    %edx,(%esp)
  80102b:	e8 8a 01 00 00       	call   8011ba <nsipc_connect>
}
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <listen>:

int
listen(int s, int backlog)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	e8 99 fe ff ff       	call   800ed9 <fd2sockid>
  801040:	89 c2                	mov    %eax,%edx
  801042:	85 d2                	test   %edx,%edx
  801044:	78 0f                	js     801055 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	89 44 24 04          	mov    %eax,0x4(%esp)
  80104d:	89 14 24             	mov    %edx,(%esp)
  801050:	e8 a4 01 00 00       	call   8011f9 <nsipc_listen>
}
  801055:	c9                   	leave  
  801056:	c3                   	ret    

00801057 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80105d:	8b 45 10             	mov    0x10(%ebp),%eax
  801060:	89 44 24 08          	mov    %eax,0x8(%esp)
  801064:	8b 45 0c             	mov    0xc(%ebp),%eax
  801067:	89 44 24 04          	mov    %eax,0x4(%esp)
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	89 04 24             	mov    %eax,(%esp)
  801071:	e8 98 02 00 00       	call   80130e <nsipc_socket>
  801076:	89 c2                	mov    %eax,%edx
  801078:	85 d2                	test   %edx,%edx
  80107a:	78 05                	js     801081 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80107c:	e8 8a fe ff ff       	call   800f0b <alloc_sockfd>
}
  801081:	c9                   	leave  
  801082:	c3                   	ret    

00801083 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	53                   	push   %ebx
  801087:	83 ec 14             	sub    $0x14,%esp
  80108a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80108c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801093:	75 11                	jne    8010a6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801095:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80109c:	e8 fe 12 00 00       	call   80239f <ipc_find_env>
  8010a1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8010a6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8010ad:	00 
  8010ae:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8010b5:	00 
  8010b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010ba:	a1 04 40 80 00       	mov    0x804004,%eax
  8010bf:	89 04 24             	mov    %eax,(%esp)
  8010c2:	e8 6d 12 00 00       	call   802334 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8010c7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010ce:	00 
  8010cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8010d6:	00 
  8010d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010de:	e8 fd 11 00 00       	call   8022e0 <ipc_recv>
}
  8010e3:	83 c4 14             	add    $0x14,%esp
  8010e6:	5b                   	pop    %ebx
  8010e7:	5d                   	pop    %ebp
  8010e8:	c3                   	ret    

008010e9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	56                   	push   %esi
  8010ed:	53                   	push   %ebx
  8010ee:	83 ec 10             	sub    $0x10,%esp
  8010f1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8010fc:	8b 06                	mov    (%esi),%eax
  8010fe:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801103:	b8 01 00 00 00       	mov    $0x1,%eax
  801108:	e8 76 ff ff ff       	call   801083 <nsipc>
  80110d:	89 c3                	mov    %eax,%ebx
  80110f:	85 c0                	test   %eax,%eax
  801111:	78 23                	js     801136 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801113:	a1 10 60 80 00       	mov    0x806010,%eax
  801118:	89 44 24 08          	mov    %eax,0x8(%esp)
  80111c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801123:	00 
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	89 04 24             	mov    %eax,(%esp)
  80112a:	e8 f5 0f 00 00       	call   802124 <memmove>
		*addrlen = ret->ret_addrlen;
  80112f:	a1 10 60 80 00       	mov    0x806010,%eax
  801134:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801136:	89 d8                	mov    %ebx,%eax
  801138:	83 c4 10             	add    $0x10,%esp
  80113b:	5b                   	pop    %ebx
  80113c:	5e                   	pop    %esi
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    

0080113f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	53                   	push   %ebx
  801143:	83 ec 14             	sub    $0x14,%esp
  801146:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801151:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801155:	8b 45 0c             	mov    0xc(%ebp),%eax
  801158:	89 44 24 04          	mov    %eax,0x4(%esp)
  80115c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801163:	e8 bc 0f 00 00       	call   802124 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801168:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80116e:	b8 02 00 00 00       	mov    $0x2,%eax
  801173:	e8 0b ff ff ff       	call   801083 <nsipc>
}
  801178:	83 c4 14             	add    $0x14,%esp
  80117b:	5b                   	pop    %ebx
  80117c:	5d                   	pop    %ebp
  80117d:	c3                   	ret    

0080117e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801194:	b8 03 00 00 00       	mov    $0x3,%eax
  801199:	e8 e5 fe ff ff       	call   801083 <nsipc>
}
  80119e:	c9                   	leave  
  80119f:	c3                   	ret    

008011a0 <nsipc_close>:

int
nsipc_close(int s)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8011ae:	b8 04 00 00 00       	mov    $0x4,%eax
  8011b3:	e8 cb fe ff ff       	call   801083 <nsipc>
}
  8011b8:	c9                   	leave  
  8011b9:	c3                   	ret    

008011ba <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	53                   	push   %ebx
  8011be:	83 ec 14             	sub    $0x14,%esp
  8011c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8011cc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011d7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8011de:	e8 41 0f 00 00       	call   802124 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8011e3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8011e9:	b8 05 00 00 00       	mov    $0x5,%eax
  8011ee:	e8 90 fe ff ff       	call   801083 <nsipc>
}
  8011f3:	83 c4 14             	add    $0x14,%esp
  8011f6:	5b                   	pop    %ebx
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    

008011f9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80120f:	b8 06 00 00 00       	mov    $0x6,%eax
  801214:	e8 6a fe ff ff       	call   801083 <nsipc>
}
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	56                   	push   %esi
  80121f:	53                   	push   %ebx
  801220:	83 ec 10             	sub    $0x10,%esp
  801223:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80122e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801234:	8b 45 14             	mov    0x14(%ebp),%eax
  801237:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80123c:	b8 07 00 00 00       	mov    $0x7,%eax
  801241:	e8 3d fe ff ff       	call   801083 <nsipc>
  801246:	89 c3                	mov    %eax,%ebx
  801248:	85 c0                	test   %eax,%eax
  80124a:	78 46                	js     801292 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80124c:	39 f0                	cmp    %esi,%eax
  80124e:	7f 07                	jg     801257 <nsipc_recv+0x3c>
  801250:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801255:	7e 24                	jle    80127b <nsipc_recv+0x60>
  801257:	c7 44 24 0c c7 27 80 	movl   $0x8027c7,0xc(%esp)
  80125e:	00 
  80125f:	c7 44 24 08 8f 27 80 	movl   $0x80278f,0x8(%esp)
  801266:	00 
  801267:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80126e:	00 
  80126f:	c7 04 24 dc 27 80 00 	movl   $0x8027dc,(%esp)
  801276:	e8 eb 05 00 00       	call   801866 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80127b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80127f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801286:	00 
  801287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128a:	89 04 24             	mov    %eax,(%esp)
  80128d:	e8 92 0e 00 00       	call   802124 <memmove>
	}

	return r;
}
  801292:	89 d8                	mov    %ebx,%eax
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	5b                   	pop    %ebx
  801298:	5e                   	pop    %esi
  801299:	5d                   	pop    %ebp
  80129a:	c3                   	ret    

0080129b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
  80129e:	53                   	push   %ebx
  80129f:	83 ec 14             	sub    $0x14,%esp
  8012a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012ad:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012b3:	7e 24                	jle    8012d9 <nsipc_send+0x3e>
  8012b5:	c7 44 24 0c e8 27 80 	movl   $0x8027e8,0xc(%esp)
  8012bc:	00 
  8012bd:	c7 44 24 08 8f 27 80 	movl   $0x80278f,0x8(%esp)
  8012c4:	00 
  8012c5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8012cc:	00 
  8012cd:	c7 04 24 dc 27 80 00 	movl   $0x8027dc,(%esp)
  8012d4:	e8 8d 05 00 00       	call   801866 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8012eb:	e8 34 0e 00 00       	call   802124 <memmove>
	nsipcbuf.send.req_size = size;
  8012f0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8012f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8012fe:	b8 08 00 00 00       	mov    $0x8,%eax
  801303:	e8 7b fd ff ff       	call   801083 <nsipc>
}
  801308:	83 c4 14             	add    $0x14,%esp
  80130b:	5b                   	pop    %ebx
  80130c:	5d                   	pop    %ebp
  80130d:	c3                   	ret    

0080130e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80131c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801324:	8b 45 10             	mov    0x10(%ebp),%eax
  801327:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80132c:	b8 09 00 00 00       	mov    $0x9,%eax
  801331:	e8 4d fd ff ff       	call   801083 <nsipc>
}
  801336:	c9                   	leave  
  801337:	c3                   	ret    

00801338 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
  80133b:	56                   	push   %esi
  80133c:	53                   	push   %ebx
  80133d:	83 ec 10             	sub    $0x10,%esp
  801340:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	89 04 24             	mov    %eax,(%esp)
  801349:	e8 72 f2 ff ff       	call   8005c0 <fd2data>
  80134e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801350:	c7 44 24 04 f4 27 80 	movl   $0x8027f4,0x4(%esp)
  801357:	00 
  801358:	89 1c 24             	mov    %ebx,(%esp)
  80135b:	e8 27 0c 00 00       	call   801f87 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801360:	8b 46 04             	mov    0x4(%esi),%eax
  801363:	2b 06                	sub    (%esi),%eax
  801365:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80136b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801372:	00 00 00 
	stat->st_dev = &devpipe;
  801375:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80137c:	30 80 00 
	return 0;
}
  80137f:	b8 00 00 00 00       	mov    $0x0,%eax
  801384:	83 c4 10             	add    $0x10,%esp
  801387:	5b                   	pop    %ebx
  801388:	5e                   	pop    %esi
  801389:	5d                   	pop    %ebp
  80138a:	c3                   	ret    

0080138b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	53                   	push   %ebx
  80138f:	83 ec 14             	sub    $0x14,%esp
  801392:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801395:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801399:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a0:	e8 83 ee ff ff       	call   800228 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8013a5:	89 1c 24             	mov    %ebx,(%esp)
  8013a8:	e8 13 f2 ff ff       	call   8005c0 <fd2data>
  8013ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013b8:	e8 6b ee ff ff       	call   800228 <sys_page_unmap>
}
  8013bd:	83 c4 14             	add    $0x14,%esp
  8013c0:	5b                   	pop    %ebx
  8013c1:	5d                   	pop    %ebp
  8013c2:	c3                   	ret    

008013c3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	57                   	push   %edi
  8013c7:	56                   	push   %esi
  8013c8:	53                   	push   %ebx
  8013c9:	83 ec 2c             	sub    $0x2c,%esp
  8013cc:	89 c6                	mov    %eax,%esi
  8013ce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8013d1:	a1 08 40 80 00       	mov    0x804008,%eax
  8013d6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8013d9:	89 34 24             	mov    %esi,(%esp)
  8013dc:	e8 fd 0f 00 00       	call   8023de <pageref>
  8013e1:	89 c7                	mov    %eax,%edi
  8013e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e6:	89 04 24             	mov    %eax,(%esp)
  8013e9:	e8 f0 0f 00 00       	call   8023de <pageref>
  8013ee:	39 c7                	cmp    %eax,%edi
  8013f0:	0f 94 c2             	sete   %dl
  8013f3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8013f6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  8013fc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8013ff:	39 fb                	cmp    %edi,%ebx
  801401:	74 21                	je     801424 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801403:	84 d2                	test   %dl,%dl
  801405:	74 ca                	je     8013d1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801407:	8b 51 58             	mov    0x58(%ecx),%edx
  80140a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80140e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801412:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801416:	c7 04 24 fb 27 80 00 	movl   $0x8027fb,(%esp)
  80141d:	e8 3d 05 00 00       	call   80195f <cprintf>
  801422:	eb ad                	jmp    8013d1 <_pipeisclosed+0xe>
	}
}
  801424:	83 c4 2c             	add    $0x2c,%esp
  801427:	5b                   	pop    %ebx
  801428:	5e                   	pop    %esi
  801429:	5f                   	pop    %edi
  80142a:	5d                   	pop    %ebp
  80142b:	c3                   	ret    

0080142c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	57                   	push   %edi
  801430:	56                   	push   %esi
  801431:	53                   	push   %ebx
  801432:	83 ec 1c             	sub    $0x1c,%esp
  801435:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801438:	89 34 24             	mov    %esi,(%esp)
  80143b:	e8 80 f1 ff ff       	call   8005c0 <fd2data>
  801440:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801442:	bf 00 00 00 00       	mov    $0x0,%edi
  801447:	eb 45                	jmp    80148e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801449:	89 da                	mov    %ebx,%edx
  80144b:	89 f0                	mov    %esi,%eax
  80144d:	e8 71 ff ff ff       	call   8013c3 <_pipeisclosed>
  801452:	85 c0                	test   %eax,%eax
  801454:	75 41                	jne    801497 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801456:	e8 07 ed ff ff       	call   800162 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80145b:	8b 43 04             	mov    0x4(%ebx),%eax
  80145e:	8b 0b                	mov    (%ebx),%ecx
  801460:	8d 51 20             	lea    0x20(%ecx),%edx
  801463:	39 d0                	cmp    %edx,%eax
  801465:	73 e2                	jae    801449 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801467:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80146a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80146e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801471:	99                   	cltd   
  801472:	c1 ea 1b             	shr    $0x1b,%edx
  801475:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801478:	83 e1 1f             	and    $0x1f,%ecx
  80147b:	29 d1                	sub    %edx,%ecx
  80147d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801481:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801485:	83 c0 01             	add    $0x1,%eax
  801488:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80148b:	83 c7 01             	add    $0x1,%edi
  80148e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801491:	75 c8                	jne    80145b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801493:	89 f8                	mov    %edi,%eax
  801495:	eb 05                	jmp    80149c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801497:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80149c:	83 c4 1c             	add    $0x1c,%esp
  80149f:	5b                   	pop    %ebx
  8014a0:	5e                   	pop    %esi
  8014a1:	5f                   	pop    %edi
  8014a2:	5d                   	pop    %ebp
  8014a3:	c3                   	ret    

008014a4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	57                   	push   %edi
  8014a8:	56                   	push   %esi
  8014a9:	53                   	push   %ebx
  8014aa:	83 ec 1c             	sub    $0x1c,%esp
  8014ad:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8014b0:	89 3c 24             	mov    %edi,(%esp)
  8014b3:	e8 08 f1 ff ff       	call   8005c0 <fd2data>
  8014b8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014ba:	be 00 00 00 00       	mov    $0x0,%esi
  8014bf:	eb 3d                	jmp    8014fe <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8014c1:	85 f6                	test   %esi,%esi
  8014c3:	74 04                	je     8014c9 <devpipe_read+0x25>
				return i;
  8014c5:	89 f0                	mov    %esi,%eax
  8014c7:	eb 43                	jmp    80150c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8014c9:	89 da                	mov    %ebx,%edx
  8014cb:	89 f8                	mov    %edi,%eax
  8014cd:	e8 f1 fe ff ff       	call   8013c3 <_pipeisclosed>
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	75 31                	jne    801507 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8014d6:	e8 87 ec ff ff       	call   800162 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8014db:	8b 03                	mov    (%ebx),%eax
  8014dd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8014e0:	74 df                	je     8014c1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8014e2:	99                   	cltd   
  8014e3:	c1 ea 1b             	shr    $0x1b,%edx
  8014e6:	01 d0                	add    %edx,%eax
  8014e8:	83 e0 1f             	and    $0x1f,%eax
  8014eb:	29 d0                	sub    %edx,%eax
  8014ed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8014f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8014f8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014fb:	83 c6 01             	add    $0x1,%esi
  8014fe:	3b 75 10             	cmp    0x10(%ebp),%esi
  801501:	75 d8                	jne    8014db <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801503:	89 f0                	mov    %esi,%eax
  801505:	eb 05                	jmp    80150c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801507:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80150c:	83 c4 1c             	add    $0x1c,%esp
  80150f:	5b                   	pop    %ebx
  801510:	5e                   	pop    %esi
  801511:	5f                   	pop    %edi
  801512:	5d                   	pop    %ebp
  801513:	c3                   	ret    

00801514 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	56                   	push   %esi
  801518:	53                   	push   %ebx
  801519:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80151c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80151f:	89 04 24             	mov    %eax,(%esp)
  801522:	e8 b0 f0 ff ff       	call   8005d7 <fd_alloc>
  801527:	89 c2                	mov    %eax,%edx
  801529:	85 d2                	test   %edx,%edx
  80152b:	0f 88 4d 01 00 00    	js     80167e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801531:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801538:	00 
  801539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801540:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801547:	e8 35 ec ff ff       	call   800181 <sys_page_alloc>
  80154c:	89 c2                	mov    %eax,%edx
  80154e:	85 d2                	test   %edx,%edx
  801550:	0f 88 28 01 00 00    	js     80167e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801556:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801559:	89 04 24             	mov    %eax,(%esp)
  80155c:	e8 76 f0 ff ff       	call   8005d7 <fd_alloc>
  801561:	89 c3                	mov    %eax,%ebx
  801563:	85 c0                	test   %eax,%eax
  801565:	0f 88 fe 00 00 00    	js     801669 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80156b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801572:	00 
  801573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801576:	89 44 24 04          	mov    %eax,0x4(%esp)
  80157a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801581:	e8 fb eb ff ff       	call   800181 <sys_page_alloc>
  801586:	89 c3                	mov    %eax,%ebx
  801588:	85 c0                	test   %eax,%eax
  80158a:	0f 88 d9 00 00 00    	js     801669 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801593:	89 04 24             	mov    %eax,(%esp)
  801596:	e8 25 f0 ff ff       	call   8005c0 <fd2data>
  80159b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80159d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8015a4:	00 
  8015a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015b0:	e8 cc eb ff ff       	call   800181 <sys_page_alloc>
  8015b5:	89 c3                	mov    %eax,%ebx
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	0f 88 97 00 00 00    	js     801656 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c2:	89 04 24             	mov    %eax,(%esp)
  8015c5:	e8 f6 ef ff ff       	call   8005c0 <fd2data>
  8015ca:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8015d1:	00 
  8015d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015dd:	00 
  8015de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015e9:	e8 e7 eb ff ff       	call   8001d5 <sys_page_map>
  8015ee:	89 c3                	mov    %eax,%ebx
  8015f0:	85 c0                	test   %eax,%eax
  8015f2:	78 52                	js     801646 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8015f4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8015fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8015ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801602:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801609:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80160f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801612:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801617:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80161e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801621:	89 04 24             	mov    %eax,(%esp)
  801624:	e8 87 ef ff ff       	call   8005b0 <fd2num>
  801629:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80162c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80162e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801631:	89 04 24             	mov    %eax,(%esp)
  801634:	e8 77 ef ff ff       	call   8005b0 <fd2num>
  801639:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80163c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80163f:	b8 00 00 00 00       	mov    $0x0,%eax
  801644:	eb 38                	jmp    80167e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801646:	89 74 24 04          	mov    %esi,0x4(%esp)
  80164a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801651:	e8 d2 eb ff ff       	call   800228 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801659:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801664:	e8 bf eb ff ff       	call   800228 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801670:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801677:	e8 ac eb ff ff       	call   800228 <sys_page_unmap>
  80167c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80167e:	83 c4 30             	add    $0x30,%esp
  801681:	5b                   	pop    %ebx
  801682:	5e                   	pop    %esi
  801683:	5d                   	pop    %ebp
  801684:	c3                   	ret    

00801685 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80168b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80168e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	89 04 24             	mov    %eax,(%esp)
  801698:	e8 89 ef ff ff       	call   800626 <fd_lookup>
  80169d:	89 c2                	mov    %eax,%edx
  80169f:	85 d2                	test   %edx,%edx
  8016a1:	78 15                	js     8016b8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a6:	89 04 24             	mov    %eax,(%esp)
  8016a9:	e8 12 ef ff ff       	call   8005c0 <fd2data>
	return _pipeisclosed(fd, p);
  8016ae:	89 c2                	mov    %eax,%edx
  8016b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b3:	e8 0b fd ff ff       	call   8013c3 <_pipeisclosed>
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    
  8016ba:	66 90                	xchg   %ax,%ax
  8016bc:	66 90                	xchg   %ax,%ax
  8016be:	66 90                	xchg   %ax,%ax

008016c0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8016c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c8:	5d                   	pop    %ebp
  8016c9:	c3                   	ret    

008016ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8016d0:	c7 44 24 04 13 28 80 	movl   $0x802813,0x4(%esp)
  8016d7:	00 
  8016d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016db:	89 04 24             	mov    %eax,(%esp)
  8016de:	e8 a4 08 00 00       	call   801f87 <strcpy>
	return 0;
}
  8016e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	57                   	push   %edi
  8016ee:	56                   	push   %esi
  8016ef:	53                   	push   %ebx
  8016f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016f6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8016fb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801701:	eb 31                	jmp    801734 <devcons_write+0x4a>
		m = n - tot;
  801703:	8b 75 10             	mov    0x10(%ebp),%esi
  801706:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  801708:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80170b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801710:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801713:	89 74 24 08          	mov    %esi,0x8(%esp)
  801717:	03 45 0c             	add    0xc(%ebp),%eax
  80171a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171e:	89 3c 24             	mov    %edi,(%esp)
  801721:	e8 fe 09 00 00       	call   802124 <memmove>
		sys_cputs(buf, m);
  801726:	89 74 24 04          	mov    %esi,0x4(%esp)
  80172a:	89 3c 24             	mov    %edi,(%esp)
  80172d:	e8 82 e9 ff ff       	call   8000b4 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801732:	01 f3                	add    %esi,%ebx
  801734:	89 d8                	mov    %ebx,%eax
  801736:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801739:	72 c8                	jb     801703 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80173b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801741:	5b                   	pop    %ebx
  801742:	5e                   	pop    %esi
  801743:	5f                   	pop    %edi
  801744:	5d                   	pop    %ebp
  801745:	c3                   	ret    

00801746 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80174c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801751:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801755:	75 07                	jne    80175e <devcons_read+0x18>
  801757:	eb 2a                	jmp    801783 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801759:	e8 04 ea ff ff       	call   800162 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80175e:	66 90                	xchg   %ax,%ax
  801760:	e8 6d e9 ff ff       	call   8000d2 <sys_cgetc>
  801765:	85 c0                	test   %eax,%eax
  801767:	74 f0                	je     801759 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801769:	85 c0                	test   %eax,%eax
  80176b:	78 16                	js     801783 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80176d:	83 f8 04             	cmp    $0x4,%eax
  801770:	74 0c                	je     80177e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  801772:	8b 55 0c             	mov    0xc(%ebp),%edx
  801775:	88 02                	mov    %al,(%edx)
	return 1;
  801777:	b8 01 00 00 00       	mov    $0x1,%eax
  80177c:	eb 05                	jmp    801783 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80177e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801791:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801798:	00 
  801799:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80179c:	89 04 24             	mov    %eax,(%esp)
  80179f:	e8 10 e9 ff ff       	call   8000b4 <sys_cputs>
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <getchar>:

int
getchar(void)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8017ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8017b3:	00 
  8017b4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8017b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017c2:	e8 f3 f0 ff ff       	call   8008ba <read>
	if (r < 0)
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	78 0f                	js     8017da <getchar+0x34>
		return r;
	if (r < 1)
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	7e 06                	jle    8017d5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8017cf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8017d3:	eb 05                	jmp    8017da <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8017d5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	89 04 24             	mov    %eax,(%esp)
  8017ef:	e8 32 ee ff ff       	call   800626 <fd_lookup>
  8017f4:	85 c0                	test   %eax,%eax
  8017f6:	78 11                	js     801809 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8017f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801801:	39 10                	cmp    %edx,(%eax)
  801803:	0f 94 c0             	sete   %al
  801806:	0f b6 c0             	movzbl %al,%eax
}
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <opencons>:

int
opencons(void)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801811:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801814:	89 04 24             	mov    %eax,(%esp)
  801817:	e8 bb ed ff ff       	call   8005d7 <fd_alloc>
		return r;
  80181c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80181e:	85 c0                	test   %eax,%eax
  801820:	78 40                	js     801862 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801822:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801829:	00 
  80182a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801831:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801838:	e8 44 e9 ff ff       	call   800181 <sys_page_alloc>
		return r;
  80183d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80183f:	85 c0                	test   %eax,%eax
  801841:	78 1f                	js     801862 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801843:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80184e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801851:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801858:	89 04 24             	mov    %eax,(%esp)
  80185b:	e8 50 ed ff ff       	call   8005b0 <fd2num>
  801860:	89 c2                	mov    %eax,%edx
}
  801862:	89 d0                	mov    %edx,%eax
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	56                   	push   %esi
  80186a:	53                   	push   %ebx
  80186b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80186e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801871:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801877:	e8 c7 e8 ff ff       	call   800143 <sys_getenvid>
  80187c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801883:	8b 55 08             	mov    0x8(%ebp),%edx
  801886:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80188a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80188e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801892:	c7 04 24 20 28 80 00 	movl   $0x802820,(%esp)
  801899:	e8 c1 00 00 00       	call   80195f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80189e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a5:	89 04 24             	mov    %eax,(%esp)
  8018a8:	e8 51 00 00 00       	call   8018fe <vcprintf>
	cprintf("\n");
  8018ad:	c7 04 24 0c 28 80 00 	movl   $0x80280c,(%esp)
  8018b4:	e8 a6 00 00 00       	call   80195f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8018b9:	cc                   	int3   
  8018ba:	eb fd                	jmp    8018b9 <_panic+0x53>

008018bc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	53                   	push   %ebx
  8018c0:	83 ec 14             	sub    $0x14,%esp
  8018c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8018c6:	8b 13                	mov    (%ebx),%edx
  8018c8:	8d 42 01             	lea    0x1(%edx),%eax
  8018cb:	89 03                	mov    %eax,(%ebx)
  8018cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8018d4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8018d9:	75 19                	jne    8018f4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8018db:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8018e2:	00 
  8018e3:	8d 43 08             	lea    0x8(%ebx),%eax
  8018e6:	89 04 24             	mov    %eax,(%esp)
  8018e9:	e8 c6 e7 ff ff       	call   8000b4 <sys_cputs>
		b->idx = 0;
  8018ee:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8018f4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8018f8:	83 c4 14             	add    $0x14,%esp
  8018fb:	5b                   	pop    %ebx
  8018fc:	5d                   	pop    %ebp
  8018fd:	c3                   	ret    

008018fe <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801907:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80190e:	00 00 00 
	b.cnt = 0;
  801911:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801918:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80191b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	89 44 24 08          	mov    %eax,0x8(%esp)
  801929:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80192f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801933:	c7 04 24 bc 18 80 00 	movl   $0x8018bc,(%esp)
  80193a:	e8 af 01 00 00       	call   801aee <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80193f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801945:	89 44 24 04          	mov    %eax,0x4(%esp)
  801949:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80194f:	89 04 24             	mov    %eax,(%esp)
  801952:	e8 5d e7 ff ff       	call   8000b4 <sys_cputs>

	return b.cnt;
}
  801957:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801965:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801968:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	89 04 24             	mov    %eax,(%esp)
  801972:	e8 87 ff ff ff       	call   8018fe <vcprintf>
	va_end(ap);

	return cnt;
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    
  801979:	66 90                	xchg   %ax,%ax
  80197b:	66 90                	xchg   %ax,%ax
  80197d:	66 90                	xchg   %ax,%ax
  80197f:	90                   	nop

00801980 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	57                   	push   %edi
  801984:	56                   	push   %esi
  801985:	53                   	push   %ebx
  801986:	83 ec 3c             	sub    $0x3c,%esp
  801989:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80198c:	89 d7                	mov    %edx,%edi
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801994:	8b 45 0c             	mov    0xc(%ebp),%eax
  801997:	89 c3                	mov    %eax,%ebx
  801999:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80199c:	8b 45 10             	mov    0x10(%ebp),%eax
  80199f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8019a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019aa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8019ad:	39 d9                	cmp    %ebx,%ecx
  8019af:	72 05                	jb     8019b6 <printnum+0x36>
  8019b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8019b4:	77 69                	ja     801a1f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8019b6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8019b9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8019bd:	83 ee 01             	sub    $0x1,%esi
  8019c0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019cc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8019d0:	89 c3                	mov    %eax,%ebx
  8019d2:	89 d6                	mov    %edx,%esi
  8019d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019d7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8019da:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019e5:	89 04 24             	mov    %eax,(%esp)
  8019e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ef:	e8 2c 0a 00 00       	call   802420 <__udivdi3>
  8019f4:	89 d9                	mov    %ebx,%ecx
  8019f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019fa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019fe:	89 04 24             	mov    %eax,(%esp)
  801a01:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a05:	89 fa                	mov    %edi,%edx
  801a07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a0a:	e8 71 ff ff ff       	call   801980 <printnum>
  801a0f:	eb 1b                	jmp    801a2c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801a11:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a15:	8b 45 18             	mov    0x18(%ebp),%eax
  801a18:	89 04 24             	mov    %eax,(%esp)
  801a1b:	ff d3                	call   *%ebx
  801a1d:	eb 03                	jmp    801a22 <printnum+0xa2>
  801a1f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801a22:	83 ee 01             	sub    $0x1,%esi
  801a25:	85 f6                	test   %esi,%esi
  801a27:	7f e8                	jg     801a11 <printnum+0x91>
  801a29:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801a2c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a30:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801a34:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801a3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a3e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801a42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a45:	89 04 24             	mov    %eax,(%esp)
  801a48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4f:	e8 fc 0a 00 00       	call   802550 <__umoddi3>
  801a54:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a58:	0f be 80 43 28 80 00 	movsbl 0x802843(%eax),%eax
  801a5f:	89 04 24             	mov    %eax,(%esp)
  801a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a65:	ff d0                	call   *%eax
}
  801a67:	83 c4 3c             	add    $0x3c,%esp
  801a6a:	5b                   	pop    %ebx
  801a6b:	5e                   	pop    %esi
  801a6c:	5f                   	pop    %edi
  801a6d:	5d                   	pop    %ebp
  801a6e:	c3                   	ret    

00801a6f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a72:	83 fa 01             	cmp    $0x1,%edx
  801a75:	7e 0e                	jle    801a85 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801a77:	8b 10                	mov    (%eax),%edx
  801a79:	8d 4a 08             	lea    0x8(%edx),%ecx
  801a7c:	89 08                	mov    %ecx,(%eax)
  801a7e:	8b 02                	mov    (%edx),%eax
  801a80:	8b 52 04             	mov    0x4(%edx),%edx
  801a83:	eb 22                	jmp    801aa7 <getuint+0x38>
	else if (lflag)
  801a85:	85 d2                	test   %edx,%edx
  801a87:	74 10                	je     801a99 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801a89:	8b 10                	mov    (%eax),%edx
  801a8b:	8d 4a 04             	lea    0x4(%edx),%ecx
  801a8e:	89 08                	mov    %ecx,(%eax)
  801a90:	8b 02                	mov    (%edx),%eax
  801a92:	ba 00 00 00 00       	mov    $0x0,%edx
  801a97:	eb 0e                	jmp    801aa7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801a99:	8b 10                	mov    (%eax),%edx
  801a9b:	8d 4a 04             	lea    0x4(%edx),%ecx
  801a9e:	89 08                	mov    %ecx,(%eax)
  801aa0:	8b 02                	mov    (%edx),%eax
  801aa2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801aa7:	5d                   	pop    %ebp
  801aa8:	c3                   	ret    

00801aa9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801aaf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801ab3:	8b 10                	mov    (%eax),%edx
  801ab5:	3b 50 04             	cmp    0x4(%eax),%edx
  801ab8:	73 0a                	jae    801ac4 <sprintputch+0x1b>
		*b->buf++ = ch;
  801aba:	8d 4a 01             	lea    0x1(%edx),%ecx
  801abd:	89 08                	mov    %ecx,(%eax)
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	88 02                	mov    %al,(%edx)
}
  801ac4:	5d                   	pop    %ebp
  801ac5:	c3                   	ret    

00801ac6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801acc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801acf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ad3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  801add:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	89 04 24             	mov    %eax,(%esp)
  801ae7:	e8 02 00 00 00       	call   801aee <vprintfmt>
	va_end(ap);
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	57                   	push   %edi
  801af2:	56                   	push   %esi
  801af3:	53                   	push   %ebx
  801af4:	83 ec 3c             	sub    $0x3c,%esp
  801af7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801afa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801afd:	eb 14                	jmp    801b13 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801aff:	85 c0                	test   %eax,%eax
  801b01:	0f 84 b3 03 00 00    	je     801eba <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  801b07:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b0b:	89 04 24             	mov    %eax,(%esp)
  801b0e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b11:	89 f3                	mov    %esi,%ebx
  801b13:	8d 73 01             	lea    0x1(%ebx),%esi
  801b16:	0f b6 03             	movzbl (%ebx),%eax
  801b19:	83 f8 25             	cmp    $0x25,%eax
  801b1c:	75 e1                	jne    801aff <vprintfmt+0x11>
  801b1e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  801b22:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b29:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  801b30:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  801b37:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3c:	eb 1d                	jmp    801b5b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b3e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  801b40:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801b44:	eb 15                	jmp    801b5b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b46:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b48:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801b4c:	eb 0d                	jmp    801b5b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801b4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b51:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b54:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b5b:	8d 5e 01             	lea    0x1(%esi),%ebx
  801b5e:	0f b6 0e             	movzbl (%esi),%ecx
  801b61:	0f b6 c1             	movzbl %cl,%eax
  801b64:	83 e9 23             	sub    $0x23,%ecx
  801b67:	80 f9 55             	cmp    $0x55,%cl
  801b6a:	0f 87 2a 03 00 00    	ja     801e9a <vprintfmt+0x3ac>
  801b70:	0f b6 c9             	movzbl %cl,%ecx
  801b73:	ff 24 8d c0 29 80 00 	jmp    *0x8029c0(,%ecx,4)
  801b7a:	89 de                	mov    %ebx,%esi
  801b7c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801b81:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801b84:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801b88:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801b8b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  801b8e:	83 fb 09             	cmp    $0x9,%ebx
  801b91:	77 36                	ja     801bc9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b93:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b96:	eb e9                	jmp    801b81 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b98:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9b:	8d 48 04             	lea    0x4(%eax),%ecx
  801b9e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801ba1:	8b 00                	mov    (%eax),%eax
  801ba3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ba6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801ba8:	eb 22                	jmp    801bcc <vprintfmt+0xde>
  801baa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801bad:	85 c9                	test   %ecx,%ecx
  801baf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb4:	0f 49 c1             	cmovns %ecx,%eax
  801bb7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bba:	89 de                	mov    %ebx,%esi
  801bbc:	eb 9d                	jmp    801b5b <vprintfmt+0x6d>
  801bbe:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801bc0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  801bc7:	eb 92                	jmp    801b5b <vprintfmt+0x6d>
  801bc9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  801bcc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801bd0:	79 89                	jns    801b5b <vprintfmt+0x6d>
  801bd2:	e9 77 ff ff ff       	jmp    801b4e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801bd7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bda:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801bdc:	e9 7a ff ff ff       	jmp    801b5b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801be1:	8b 45 14             	mov    0x14(%ebp),%eax
  801be4:	8d 50 04             	lea    0x4(%eax),%edx
  801be7:	89 55 14             	mov    %edx,0x14(%ebp)
  801bea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801bee:	8b 00                	mov    (%eax),%eax
  801bf0:	89 04 24             	mov    %eax,(%esp)
  801bf3:	ff 55 08             	call   *0x8(%ebp)
			break;
  801bf6:	e9 18 ff ff ff       	jmp    801b13 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801bfb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfe:	8d 50 04             	lea    0x4(%eax),%edx
  801c01:	89 55 14             	mov    %edx,0x14(%ebp)
  801c04:	8b 00                	mov    (%eax),%eax
  801c06:	99                   	cltd   
  801c07:	31 d0                	xor    %edx,%eax
  801c09:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801c0b:	83 f8 12             	cmp    $0x12,%eax
  801c0e:	7f 0b                	jg     801c1b <vprintfmt+0x12d>
  801c10:	8b 14 85 20 2b 80 00 	mov    0x802b20(,%eax,4),%edx
  801c17:	85 d2                	test   %edx,%edx
  801c19:	75 20                	jne    801c3b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  801c1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c1f:	c7 44 24 08 5b 28 80 	movl   $0x80285b,0x8(%esp)
  801c26:	00 
  801c27:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	89 04 24             	mov    %eax,(%esp)
  801c31:	e8 90 fe ff ff       	call   801ac6 <printfmt>
  801c36:	e9 d8 fe ff ff       	jmp    801b13 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801c3b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c3f:	c7 44 24 08 a1 27 80 	movl   $0x8027a1,0x8(%esp)
  801c46:	00 
  801c47:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	89 04 24             	mov    %eax,(%esp)
  801c51:	e8 70 fe ff ff       	call   801ac6 <printfmt>
  801c56:	e9 b8 fe ff ff       	jmp    801b13 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801c5b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801c5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c61:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	8d 50 04             	lea    0x4(%eax),%edx
  801c6a:	89 55 14             	mov    %edx,0x14(%ebp)
  801c6d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  801c6f:	85 f6                	test   %esi,%esi
  801c71:	b8 54 28 80 00       	mov    $0x802854,%eax
  801c76:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  801c79:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  801c7d:	0f 84 97 00 00 00    	je     801d1a <vprintfmt+0x22c>
  801c83:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801c87:	0f 8e 9b 00 00 00    	jle    801d28 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c8d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c91:	89 34 24             	mov    %esi,(%esp)
  801c94:	e8 cf 02 00 00       	call   801f68 <strnlen>
  801c99:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801c9c:	29 c2                	sub    %eax,%edx
  801c9e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  801ca1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  801ca5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ca8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801cab:	8b 75 08             	mov    0x8(%ebp),%esi
  801cae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801cb1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801cb3:	eb 0f                	jmp    801cc4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  801cb5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801cb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cbc:	89 04 24             	mov    %eax,(%esp)
  801cbf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801cc1:	83 eb 01             	sub    $0x1,%ebx
  801cc4:	85 db                	test   %ebx,%ebx
  801cc6:	7f ed                	jg     801cb5 <vprintfmt+0x1c7>
  801cc8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801ccb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801cce:	85 d2                	test   %edx,%edx
  801cd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd5:	0f 49 c2             	cmovns %edx,%eax
  801cd8:	29 c2                	sub    %eax,%edx
  801cda:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801cdd:	89 d7                	mov    %edx,%edi
  801cdf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801ce2:	eb 50                	jmp    801d34 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801ce4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ce8:	74 1e                	je     801d08 <vprintfmt+0x21a>
  801cea:	0f be d2             	movsbl %dl,%edx
  801ced:	83 ea 20             	sub    $0x20,%edx
  801cf0:	83 fa 5e             	cmp    $0x5e,%edx
  801cf3:	76 13                	jbe    801d08 <vprintfmt+0x21a>
					putch('?', putdat);
  801cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cfc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801d03:	ff 55 08             	call   *0x8(%ebp)
  801d06:	eb 0d                	jmp    801d15 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  801d08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0b:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d0f:	89 04 24             	mov    %eax,(%esp)
  801d12:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801d15:	83 ef 01             	sub    $0x1,%edi
  801d18:	eb 1a                	jmp    801d34 <vprintfmt+0x246>
  801d1a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801d1d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801d20:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801d23:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801d26:	eb 0c                	jmp    801d34 <vprintfmt+0x246>
  801d28:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801d2b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801d2e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801d31:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801d34:	83 c6 01             	add    $0x1,%esi
  801d37:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801d3b:	0f be c2             	movsbl %dl,%eax
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	74 27                	je     801d69 <vprintfmt+0x27b>
  801d42:	85 db                	test   %ebx,%ebx
  801d44:	78 9e                	js     801ce4 <vprintfmt+0x1f6>
  801d46:	83 eb 01             	sub    $0x1,%ebx
  801d49:	79 99                	jns    801ce4 <vprintfmt+0x1f6>
  801d4b:	89 f8                	mov    %edi,%eax
  801d4d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d50:	8b 75 08             	mov    0x8(%ebp),%esi
  801d53:	89 c3                	mov    %eax,%ebx
  801d55:	eb 1a                	jmp    801d71 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801d57:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d5b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801d62:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d64:	83 eb 01             	sub    $0x1,%ebx
  801d67:	eb 08                	jmp    801d71 <vprintfmt+0x283>
  801d69:	89 fb                	mov    %edi,%ebx
  801d6b:	8b 75 08             	mov    0x8(%ebp),%esi
  801d6e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d71:	85 db                	test   %ebx,%ebx
  801d73:	7f e2                	jg     801d57 <vprintfmt+0x269>
  801d75:	89 75 08             	mov    %esi,0x8(%ebp)
  801d78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d7b:	e9 93 fd ff ff       	jmp    801b13 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801d80:	83 fa 01             	cmp    $0x1,%edx
  801d83:	7e 16                	jle    801d9b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  801d85:	8b 45 14             	mov    0x14(%ebp),%eax
  801d88:	8d 50 08             	lea    0x8(%eax),%edx
  801d8b:	89 55 14             	mov    %edx,0x14(%ebp)
  801d8e:	8b 50 04             	mov    0x4(%eax),%edx
  801d91:	8b 00                	mov    (%eax),%eax
  801d93:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d96:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801d99:	eb 32                	jmp    801dcd <vprintfmt+0x2df>
	else if (lflag)
  801d9b:	85 d2                	test   %edx,%edx
  801d9d:	74 18                	je     801db7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  801d9f:	8b 45 14             	mov    0x14(%ebp),%eax
  801da2:	8d 50 04             	lea    0x4(%eax),%edx
  801da5:	89 55 14             	mov    %edx,0x14(%ebp)
  801da8:	8b 30                	mov    (%eax),%esi
  801daa:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801dad:	89 f0                	mov    %esi,%eax
  801daf:	c1 f8 1f             	sar    $0x1f,%eax
  801db2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801db5:	eb 16                	jmp    801dcd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  801db7:	8b 45 14             	mov    0x14(%ebp),%eax
  801dba:	8d 50 04             	lea    0x4(%eax),%edx
  801dbd:	89 55 14             	mov    %edx,0x14(%ebp)
  801dc0:	8b 30                	mov    (%eax),%esi
  801dc2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801dc5:	89 f0                	mov    %esi,%eax
  801dc7:	c1 f8 1f             	sar    $0x1f,%eax
  801dca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801dcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801dd3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801dd8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ddc:	0f 89 80 00 00 00    	jns    801e62 <vprintfmt+0x374>
				putch('-', putdat);
  801de2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801de6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801ded:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801df0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801df3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801df6:	f7 d8                	neg    %eax
  801df8:	83 d2 00             	adc    $0x0,%edx
  801dfb:	f7 da                	neg    %edx
			}
			base = 10;
  801dfd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801e02:	eb 5e                	jmp    801e62 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801e04:	8d 45 14             	lea    0x14(%ebp),%eax
  801e07:	e8 63 fc ff ff       	call   801a6f <getuint>
			base = 10;
  801e0c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801e11:	eb 4f                	jmp    801e62 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  801e13:	8d 45 14             	lea    0x14(%ebp),%eax
  801e16:	e8 54 fc ff ff       	call   801a6f <getuint>
			base = 8;
  801e1b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801e20:	eb 40                	jmp    801e62 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  801e22:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e26:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801e2d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801e30:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e34:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801e3b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801e3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e41:	8d 50 04             	lea    0x4(%eax),%edx
  801e44:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801e47:	8b 00                	mov    (%eax),%eax
  801e49:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801e4e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801e53:	eb 0d                	jmp    801e62 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801e55:	8d 45 14             	lea    0x14(%ebp),%eax
  801e58:	e8 12 fc ff ff       	call   801a6f <getuint>
			base = 16;
  801e5d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801e62:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  801e66:	89 74 24 10          	mov    %esi,0x10(%esp)
  801e6a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  801e6d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e71:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e75:	89 04 24             	mov    %eax,(%esp)
  801e78:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e7c:	89 fa                	mov    %edi,%edx
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	e8 fa fa ff ff       	call   801980 <printnum>
			break;
  801e86:	e9 88 fc ff ff       	jmp    801b13 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e8b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e8f:	89 04 24             	mov    %eax,(%esp)
  801e92:	ff 55 08             	call   *0x8(%ebp)
			break;
  801e95:	e9 79 fc ff ff       	jmp    801b13 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e9a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e9e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801ea5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ea8:	89 f3                	mov    %esi,%ebx
  801eaa:	eb 03                	jmp    801eaf <vprintfmt+0x3c1>
  801eac:	83 eb 01             	sub    $0x1,%ebx
  801eaf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801eb3:	75 f7                	jne    801eac <vprintfmt+0x3be>
  801eb5:	e9 59 fc ff ff       	jmp    801b13 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801eba:	83 c4 3c             	add    $0x3c,%esp
  801ebd:	5b                   	pop    %ebx
  801ebe:	5e                   	pop    %esi
  801ebf:	5f                   	pop    %edi
  801ec0:	5d                   	pop    %ebp
  801ec1:	c3                   	ret    

00801ec2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	83 ec 28             	sub    $0x28,%esp
  801ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ece:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ed1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801ed5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801ed8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801edf:	85 c0                	test   %eax,%eax
  801ee1:	74 30                	je     801f13 <vsnprintf+0x51>
  801ee3:	85 d2                	test   %edx,%edx
  801ee5:	7e 2c                	jle    801f13 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ee7:	8b 45 14             	mov    0x14(%ebp),%eax
  801eea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801eee:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ef5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ef8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801efc:	c7 04 24 a9 1a 80 00 	movl   $0x801aa9,(%esp)
  801f03:	e8 e6 fb ff ff       	call   801aee <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801f08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f11:	eb 05                	jmp    801f18 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801f13:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f20:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801f23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f27:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f31:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	89 04 24             	mov    %eax,(%esp)
  801f3b:	e8 82 ff ff ff       	call   801ec2 <vsnprintf>
	va_end(ap);

	return rc;
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    
  801f42:	66 90                	xchg   %ax,%ax
  801f44:	66 90                	xchg   %ax,%ax
  801f46:	66 90                	xchg   %ax,%ax
  801f48:	66 90                	xchg   %ax,%ax
  801f4a:	66 90                	xchg   %ax,%ax
  801f4c:	66 90                	xchg   %ax,%ax
  801f4e:	66 90                	xchg   %ax,%ax

00801f50 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801f56:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5b:	eb 03                	jmp    801f60 <strlen+0x10>
		n++;
  801f5d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f60:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801f64:	75 f7                	jne    801f5d <strlen+0xd>
		n++;
	return n;
}
  801f66:	5d                   	pop    %ebp
  801f67:	c3                   	ret    

00801f68 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f71:	b8 00 00 00 00       	mov    $0x0,%eax
  801f76:	eb 03                	jmp    801f7b <strnlen+0x13>
		n++;
  801f78:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f7b:	39 d0                	cmp    %edx,%eax
  801f7d:	74 06                	je     801f85 <strnlen+0x1d>
  801f7f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801f83:	75 f3                	jne    801f78 <strnlen+0x10>
		n++;
	return n;
}
  801f85:	5d                   	pop    %ebp
  801f86:	c3                   	ret    

00801f87 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	53                   	push   %ebx
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801f91:	89 c2                	mov    %eax,%edx
  801f93:	83 c2 01             	add    $0x1,%edx
  801f96:	83 c1 01             	add    $0x1,%ecx
  801f99:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801f9d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801fa0:	84 db                	test   %bl,%bl
  801fa2:	75 ef                	jne    801f93 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801fa4:	5b                   	pop    %ebx
  801fa5:	5d                   	pop    %ebp
  801fa6:	c3                   	ret    

00801fa7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	53                   	push   %ebx
  801fab:	83 ec 08             	sub    $0x8,%esp
  801fae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801fb1:	89 1c 24             	mov    %ebx,(%esp)
  801fb4:	e8 97 ff ff ff       	call   801f50 <strlen>
	strcpy(dst + len, src);
  801fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbc:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fc0:	01 d8                	add    %ebx,%eax
  801fc2:	89 04 24             	mov    %eax,(%esp)
  801fc5:	e8 bd ff ff ff       	call   801f87 <strcpy>
	return dst;
}
  801fca:	89 d8                	mov    %ebx,%eax
  801fcc:	83 c4 08             	add    $0x8,%esp
  801fcf:	5b                   	pop    %ebx
  801fd0:	5d                   	pop    %ebp
  801fd1:	c3                   	ret    

00801fd2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	56                   	push   %esi
  801fd6:	53                   	push   %ebx
  801fd7:	8b 75 08             	mov    0x8(%ebp),%esi
  801fda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fdd:	89 f3                	mov    %esi,%ebx
  801fdf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801fe2:	89 f2                	mov    %esi,%edx
  801fe4:	eb 0f                	jmp    801ff5 <strncpy+0x23>
		*dst++ = *src;
  801fe6:	83 c2 01             	add    $0x1,%edx
  801fe9:	0f b6 01             	movzbl (%ecx),%eax
  801fec:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801fef:	80 39 01             	cmpb   $0x1,(%ecx)
  801ff2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801ff5:	39 da                	cmp    %ebx,%edx
  801ff7:	75 ed                	jne    801fe6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801ff9:	89 f0                	mov    %esi,%eax
  801ffb:	5b                   	pop    %ebx
  801ffc:	5e                   	pop    %esi
  801ffd:	5d                   	pop    %ebp
  801ffe:	c3                   	ret    

00801fff <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	56                   	push   %esi
  802003:	53                   	push   %ebx
  802004:	8b 75 08             	mov    0x8(%ebp),%esi
  802007:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80200d:	89 f0                	mov    %esi,%eax
  80200f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802013:	85 c9                	test   %ecx,%ecx
  802015:	75 0b                	jne    802022 <strlcpy+0x23>
  802017:	eb 1d                	jmp    802036 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  802019:	83 c0 01             	add    $0x1,%eax
  80201c:	83 c2 01             	add    $0x1,%edx
  80201f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802022:	39 d8                	cmp    %ebx,%eax
  802024:	74 0b                	je     802031 <strlcpy+0x32>
  802026:	0f b6 0a             	movzbl (%edx),%ecx
  802029:	84 c9                	test   %cl,%cl
  80202b:	75 ec                	jne    802019 <strlcpy+0x1a>
  80202d:	89 c2                	mov    %eax,%edx
  80202f:	eb 02                	jmp    802033 <strlcpy+0x34>
  802031:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  802033:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  802036:	29 f0                	sub    %esi,%eax
}
  802038:	5b                   	pop    %ebx
  802039:	5e                   	pop    %esi
  80203a:	5d                   	pop    %ebp
  80203b:	c3                   	ret    

0080203c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802042:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802045:	eb 06                	jmp    80204d <strcmp+0x11>
		p++, q++;
  802047:	83 c1 01             	add    $0x1,%ecx
  80204a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80204d:	0f b6 01             	movzbl (%ecx),%eax
  802050:	84 c0                	test   %al,%al
  802052:	74 04                	je     802058 <strcmp+0x1c>
  802054:	3a 02                	cmp    (%edx),%al
  802056:	74 ef                	je     802047 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802058:	0f b6 c0             	movzbl %al,%eax
  80205b:	0f b6 12             	movzbl (%edx),%edx
  80205e:	29 d0                	sub    %edx,%eax
}
  802060:	5d                   	pop    %ebp
  802061:	c3                   	ret    

00802062 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	53                   	push   %ebx
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206c:	89 c3                	mov    %eax,%ebx
  80206e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802071:	eb 06                	jmp    802079 <strncmp+0x17>
		n--, p++, q++;
  802073:	83 c0 01             	add    $0x1,%eax
  802076:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802079:	39 d8                	cmp    %ebx,%eax
  80207b:	74 15                	je     802092 <strncmp+0x30>
  80207d:	0f b6 08             	movzbl (%eax),%ecx
  802080:	84 c9                	test   %cl,%cl
  802082:	74 04                	je     802088 <strncmp+0x26>
  802084:	3a 0a                	cmp    (%edx),%cl
  802086:	74 eb                	je     802073 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802088:	0f b6 00             	movzbl (%eax),%eax
  80208b:	0f b6 12             	movzbl (%edx),%edx
  80208e:	29 d0                	sub    %edx,%eax
  802090:	eb 05                	jmp    802097 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  802092:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802097:	5b                   	pop    %ebx
  802098:	5d                   	pop    %ebp
  802099:	c3                   	ret    

0080209a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8020a4:	eb 07                	jmp    8020ad <strchr+0x13>
		if (*s == c)
  8020a6:	38 ca                	cmp    %cl,%dl
  8020a8:	74 0f                	je     8020b9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020aa:	83 c0 01             	add    $0x1,%eax
  8020ad:	0f b6 10             	movzbl (%eax),%edx
  8020b0:	84 d2                	test   %dl,%dl
  8020b2:	75 f2                	jne    8020a6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8020b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b9:	5d                   	pop    %ebp
  8020ba:	c3                   	ret    

008020bb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8020c5:	eb 07                	jmp    8020ce <strfind+0x13>
		if (*s == c)
  8020c7:	38 ca                	cmp    %cl,%dl
  8020c9:	74 0a                	je     8020d5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8020cb:	83 c0 01             	add    $0x1,%eax
  8020ce:	0f b6 10             	movzbl (%eax),%edx
  8020d1:	84 d2                	test   %dl,%dl
  8020d3:	75 f2                	jne    8020c7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8020d5:	5d                   	pop    %ebp
  8020d6:	c3                   	ret    

008020d7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	57                   	push   %edi
  8020db:	56                   	push   %esi
  8020dc:	53                   	push   %ebx
  8020dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8020e3:	85 c9                	test   %ecx,%ecx
  8020e5:	74 36                	je     80211d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8020e7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8020ed:	75 28                	jne    802117 <memset+0x40>
  8020ef:	f6 c1 03             	test   $0x3,%cl
  8020f2:	75 23                	jne    802117 <memset+0x40>
		c &= 0xFF;
  8020f4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8020f8:	89 d3                	mov    %edx,%ebx
  8020fa:	c1 e3 08             	shl    $0x8,%ebx
  8020fd:	89 d6                	mov    %edx,%esi
  8020ff:	c1 e6 18             	shl    $0x18,%esi
  802102:	89 d0                	mov    %edx,%eax
  802104:	c1 e0 10             	shl    $0x10,%eax
  802107:	09 f0                	or     %esi,%eax
  802109:	09 c2                	or     %eax,%edx
  80210b:	89 d0                	mov    %edx,%eax
  80210d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80210f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802112:	fc                   	cld    
  802113:	f3 ab                	rep stos %eax,%es:(%edi)
  802115:	eb 06                	jmp    80211d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211a:	fc                   	cld    
  80211b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80211d:	89 f8                	mov    %edi,%eax
  80211f:	5b                   	pop    %ebx
  802120:	5e                   	pop    %esi
  802121:	5f                   	pop    %edi
  802122:	5d                   	pop    %ebp
  802123:	c3                   	ret    

00802124 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	57                   	push   %edi
  802128:	56                   	push   %esi
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80212f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802132:	39 c6                	cmp    %eax,%esi
  802134:	73 35                	jae    80216b <memmove+0x47>
  802136:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802139:	39 d0                	cmp    %edx,%eax
  80213b:	73 2e                	jae    80216b <memmove+0x47>
		s += n;
		d += n;
  80213d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  802140:	89 d6                	mov    %edx,%esi
  802142:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802144:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80214a:	75 13                	jne    80215f <memmove+0x3b>
  80214c:	f6 c1 03             	test   $0x3,%cl
  80214f:	75 0e                	jne    80215f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802151:	83 ef 04             	sub    $0x4,%edi
  802154:	8d 72 fc             	lea    -0x4(%edx),%esi
  802157:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80215a:	fd                   	std    
  80215b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80215d:	eb 09                	jmp    802168 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80215f:	83 ef 01             	sub    $0x1,%edi
  802162:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802165:	fd                   	std    
  802166:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802168:	fc                   	cld    
  802169:	eb 1d                	jmp    802188 <memmove+0x64>
  80216b:	89 f2                	mov    %esi,%edx
  80216d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80216f:	f6 c2 03             	test   $0x3,%dl
  802172:	75 0f                	jne    802183 <memmove+0x5f>
  802174:	f6 c1 03             	test   $0x3,%cl
  802177:	75 0a                	jne    802183 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802179:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80217c:	89 c7                	mov    %eax,%edi
  80217e:	fc                   	cld    
  80217f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802181:	eb 05                	jmp    802188 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802183:	89 c7                	mov    %eax,%edi
  802185:	fc                   	cld    
  802186:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802188:	5e                   	pop    %esi
  802189:	5f                   	pop    %edi
  80218a:	5d                   	pop    %ebp
  80218b:	c3                   	ret    

0080218c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802192:	8b 45 10             	mov    0x10(%ebp),%eax
  802195:	89 44 24 08          	mov    %eax,0x8(%esp)
  802199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	89 04 24             	mov    %eax,(%esp)
  8021a6:	e8 79 ff ff ff       	call   802124 <memmove>
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	56                   	push   %esi
  8021b1:	53                   	push   %ebx
  8021b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021b8:	89 d6                	mov    %edx,%esi
  8021ba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8021bd:	eb 1a                	jmp    8021d9 <memcmp+0x2c>
		if (*s1 != *s2)
  8021bf:	0f b6 02             	movzbl (%edx),%eax
  8021c2:	0f b6 19             	movzbl (%ecx),%ebx
  8021c5:	38 d8                	cmp    %bl,%al
  8021c7:	74 0a                	je     8021d3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8021c9:	0f b6 c0             	movzbl %al,%eax
  8021cc:	0f b6 db             	movzbl %bl,%ebx
  8021cf:	29 d8                	sub    %ebx,%eax
  8021d1:	eb 0f                	jmp    8021e2 <memcmp+0x35>
		s1++, s2++;
  8021d3:	83 c2 01             	add    $0x1,%edx
  8021d6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8021d9:	39 f2                	cmp    %esi,%edx
  8021db:	75 e2                	jne    8021bf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8021dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e2:	5b                   	pop    %ebx
  8021e3:	5e                   	pop    %esi
  8021e4:	5d                   	pop    %ebp
  8021e5:	c3                   	ret    

008021e6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8021ef:	89 c2                	mov    %eax,%edx
  8021f1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8021f4:	eb 07                	jmp    8021fd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  8021f6:	38 08                	cmp    %cl,(%eax)
  8021f8:	74 07                	je     802201 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8021fa:	83 c0 01             	add    $0x1,%eax
  8021fd:	39 d0                	cmp    %edx,%eax
  8021ff:	72 f5                	jb     8021f6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802201:	5d                   	pop    %ebp
  802202:	c3                   	ret    

00802203 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	57                   	push   %edi
  802207:	56                   	push   %esi
  802208:	53                   	push   %ebx
  802209:	8b 55 08             	mov    0x8(%ebp),%edx
  80220c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80220f:	eb 03                	jmp    802214 <strtol+0x11>
		s++;
  802211:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802214:	0f b6 0a             	movzbl (%edx),%ecx
  802217:	80 f9 09             	cmp    $0x9,%cl
  80221a:	74 f5                	je     802211 <strtol+0xe>
  80221c:	80 f9 20             	cmp    $0x20,%cl
  80221f:	74 f0                	je     802211 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  802221:	80 f9 2b             	cmp    $0x2b,%cl
  802224:	75 0a                	jne    802230 <strtol+0x2d>
		s++;
  802226:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  802229:	bf 00 00 00 00       	mov    $0x0,%edi
  80222e:	eb 11                	jmp    802241 <strtol+0x3e>
  802230:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  802235:	80 f9 2d             	cmp    $0x2d,%cl
  802238:	75 07                	jne    802241 <strtol+0x3e>
		s++, neg = 1;
  80223a:	8d 52 01             	lea    0x1(%edx),%edx
  80223d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802241:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  802246:	75 15                	jne    80225d <strtol+0x5a>
  802248:	80 3a 30             	cmpb   $0x30,(%edx)
  80224b:	75 10                	jne    80225d <strtol+0x5a>
  80224d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  802251:	75 0a                	jne    80225d <strtol+0x5a>
		s += 2, base = 16;
  802253:	83 c2 02             	add    $0x2,%edx
  802256:	b8 10 00 00 00       	mov    $0x10,%eax
  80225b:	eb 10                	jmp    80226d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80225d:	85 c0                	test   %eax,%eax
  80225f:	75 0c                	jne    80226d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802261:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802263:	80 3a 30             	cmpb   $0x30,(%edx)
  802266:	75 05                	jne    80226d <strtol+0x6a>
		s++, base = 8;
  802268:	83 c2 01             	add    $0x1,%edx
  80226b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80226d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802272:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802275:	0f b6 0a             	movzbl (%edx),%ecx
  802278:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80227b:	89 f0                	mov    %esi,%eax
  80227d:	3c 09                	cmp    $0x9,%al
  80227f:	77 08                	ja     802289 <strtol+0x86>
			dig = *s - '0';
  802281:	0f be c9             	movsbl %cl,%ecx
  802284:	83 e9 30             	sub    $0x30,%ecx
  802287:	eb 20                	jmp    8022a9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  802289:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80228c:	89 f0                	mov    %esi,%eax
  80228e:	3c 19                	cmp    $0x19,%al
  802290:	77 08                	ja     80229a <strtol+0x97>
			dig = *s - 'a' + 10;
  802292:	0f be c9             	movsbl %cl,%ecx
  802295:	83 e9 57             	sub    $0x57,%ecx
  802298:	eb 0f                	jmp    8022a9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80229a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80229d:	89 f0                	mov    %esi,%eax
  80229f:	3c 19                	cmp    $0x19,%al
  8022a1:	77 16                	ja     8022b9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  8022a3:	0f be c9             	movsbl %cl,%ecx
  8022a6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8022a9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8022ac:	7d 0f                	jge    8022bd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  8022ae:	83 c2 01             	add    $0x1,%edx
  8022b1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8022b5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8022b7:	eb bc                	jmp    802275 <strtol+0x72>
  8022b9:	89 d8                	mov    %ebx,%eax
  8022bb:	eb 02                	jmp    8022bf <strtol+0xbc>
  8022bd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8022bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022c3:	74 05                	je     8022ca <strtol+0xc7>
		*endptr = (char *) s;
  8022c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022c8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8022ca:	f7 d8                	neg    %eax
  8022cc:	85 ff                	test   %edi,%edi
  8022ce:	0f 44 c3             	cmove  %ebx,%eax
}
  8022d1:	5b                   	pop    %ebx
  8022d2:	5e                   	pop    %esi
  8022d3:	5f                   	pop    %edi
  8022d4:	5d                   	pop    %ebp
  8022d5:	c3                   	ret    
  8022d6:	66 90                	xchg   %ax,%ax
  8022d8:	66 90                	xchg   %ax,%ax
  8022da:	66 90                	xchg   %ax,%ax
  8022dc:	66 90                	xchg   %ax,%ax
  8022de:	66 90                	xchg   %ax,%ax

008022e0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	56                   	push   %esi
  8022e4:	53                   	push   %ebx
  8022e5:	83 ec 10             	sub    $0x10,%esp
  8022e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8022eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8022f1:	85 c0                	test   %eax,%eax
		pg = (void*) UTOP;
  8022f3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022f8:	0f 44 c2             	cmove  %edx,%eax

	int ret = sys_ipc_recv(pg);
  8022fb:	89 04 24             	mov    %eax,(%esp)
  8022fe:	e8 94 e0 ff ff       	call   800397 <sys_ipc_recv>
  802303:	89 c2                	mov    %eax,%edx
	if (ret != 0) {
  802305:	85 d2                	test   %edx,%edx
  802307:	75 24                	jne    80232d <ipc_recv+0x4d>
			from_env_store = 0;
		if (perm_store != NULL)
			perm_store = 0;
		return ret;
	} else {
		if (from_env_store != NULL)
  802309:	85 f6                	test   %esi,%esi
  80230b:	74 0a                	je     802317 <ipc_recv+0x37>
			*from_env_store = (envid_t) thisenv->env_ipc_from;
  80230d:	a1 08 40 80 00       	mov    0x804008,%eax
  802312:	8b 40 74             	mov    0x74(%eax),%eax
  802315:	89 06                	mov    %eax,(%esi)
		if (perm_store != NULL)
  802317:	85 db                	test   %ebx,%ebx
  802319:	74 0a                	je     802325 <ipc_recv+0x45>
			*perm_store = (int) thisenv->env_ipc_perm;
  80231b:	a1 08 40 80 00       	mov    0x804008,%eax
  802320:	8b 40 78             	mov    0x78(%eax),%eax
  802323:	89 03                	mov    %eax,(%ebx)
		return thisenv->env_ipc_value;
  802325:	a1 08 40 80 00       	mov    0x804008,%eax
  80232a:	8b 40 70             	mov    0x70(%eax),%eax
	}
	return 0;
}
  80232d:	83 c4 10             	add    $0x10,%esp
  802330:	5b                   	pop    %ebx
  802331:	5e                   	pop    %esi
  802332:	5d                   	pop    %ebp
  802333:	c3                   	ret    

00802334 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
  802337:	57                   	push   %edi
  802338:	56                   	push   %esi
  802339:	53                   	push   %ebx
  80233a:	83 ec 1c             	sub    $0x1c,%esp
  80233d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802340:	8b 75 0c             	mov    0xc(%ebp),%esi
  802343:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int ret;
	if (pg == NULL)
  802346:	85 db                	test   %ebx,%ebx
		pg = (void*) UTOP;
  802348:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80234d:	0f 44 d8             	cmove  %eax,%ebx
	while (1) {
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802350:	8b 45 14             	mov    0x14(%ebp),%eax
  802353:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802357:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80235b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80235f:	89 3c 24             	mov    %edi,(%esp)
  802362:	e8 0d e0 ff ff       	call   800374 <sys_ipc_try_send>

		if (ret == 0)
  802367:	85 c0                	test   %eax,%eax
  802369:	74 2c                	je     802397 <ipc_send+0x63>
			break;
			
		if (ret != -E_IPC_NOT_RECV) {
  80236b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80236e:	74 20                	je     802390 <ipc_send+0x5c>
			panic("ipc_send failed with error E_IPC_NOT_RECV, %e", ret);
  802370:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802374:	c7 44 24 08 8c 2b 80 	movl   $0x802b8c,0x8(%esp)
  80237b:	00 
  80237c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802383:	00 
  802384:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  80238b:	e8 d6 f4 ff ff       	call   801866 <_panic>
		}

		sys_yield();
  802390:	e8 cd dd ff ff       	call   800162 <sys_yield>
	}
  802395:	eb b9                	jmp    802350 <ipc_send+0x1c>
}
  802397:	83 c4 1c             	add    $0x1c,%esp
  80239a:	5b                   	pop    %ebx
  80239b:	5e                   	pop    %esi
  80239c:	5f                   	pop    %edi
  80239d:	5d                   	pop    %ebp
  80239e:	c3                   	ret    

0080239f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
  8023a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023a5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023aa:	89 c2                	mov    %eax,%edx
  8023ac:	c1 e2 07             	shl    $0x7,%edx
  8023af:	8d 94 82 00 00 c0 ee 	lea    -0x11400000(%edx,%eax,4),%edx
  8023b6:	8b 52 50             	mov    0x50(%edx),%edx
  8023b9:	39 ca                	cmp    %ecx,%edx
  8023bb:	75 11                	jne    8023ce <ipc_find_env+0x2f>
			return envs[i].env_id;
  8023bd:	89 c2                	mov    %eax,%edx
  8023bf:	c1 e2 07             	shl    $0x7,%edx
  8023c2:	8d 84 82 08 00 c0 ee 	lea    -0x113ffff8(%edx,%eax,4),%eax
  8023c9:	8b 40 40             	mov    0x40(%eax),%eax
  8023cc:	eb 0e                	jmp    8023dc <ipc_find_env+0x3d>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023ce:	83 c0 01             	add    $0x1,%eax
  8023d1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023d6:	75 d2                	jne    8023aa <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023d8:	66 b8 00 00          	mov    $0x0,%ax
}
  8023dc:	5d                   	pop    %ebp
  8023dd:	c3                   	ret    

008023de <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
  8023e1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023e4:	89 d0                	mov    %edx,%eax
  8023e6:	c1 e8 16             	shr    $0x16,%eax
  8023e9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023f0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023f5:	f6 c1 01             	test   $0x1,%cl
  8023f8:	74 1d                	je     802417 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023fa:	c1 ea 0c             	shr    $0xc,%edx
  8023fd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802404:	f6 c2 01             	test   $0x1,%dl
  802407:	74 0e                	je     802417 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802409:	c1 ea 0c             	shr    $0xc,%edx
  80240c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802413:	ef 
  802414:	0f b7 c0             	movzwl %ax,%eax
}
  802417:	5d                   	pop    %ebp
  802418:	c3                   	ret    
  802419:	66 90                	xchg   %ax,%ax
  80241b:	66 90                	xchg   %ax,%ax
  80241d:	66 90                	xchg   %ax,%ax
  80241f:	90                   	nop

00802420 <__udivdi3>:
  802420:	55                   	push   %ebp
  802421:	57                   	push   %edi
  802422:	56                   	push   %esi
  802423:	83 ec 0c             	sub    $0xc,%esp
  802426:	8b 44 24 28          	mov    0x28(%esp),%eax
  80242a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80242e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802432:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802436:	85 c0                	test   %eax,%eax
  802438:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80243c:	89 ea                	mov    %ebp,%edx
  80243e:	89 0c 24             	mov    %ecx,(%esp)
  802441:	75 2d                	jne    802470 <__udivdi3+0x50>
  802443:	39 e9                	cmp    %ebp,%ecx
  802445:	77 61                	ja     8024a8 <__udivdi3+0x88>
  802447:	85 c9                	test   %ecx,%ecx
  802449:	89 ce                	mov    %ecx,%esi
  80244b:	75 0b                	jne    802458 <__udivdi3+0x38>
  80244d:	b8 01 00 00 00       	mov    $0x1,%eax
  802452:	31 d2                	xor    %edx,%edx
  802454:	f7 f1                	div    %ecx
  802456:	89 c6                	mov    %eax,%esi
  802458:	31 d2                	xor    %edx,%edx
  80245a:	89 e8                	mov    %ebp,%eax
  80245c:	f7 f6                	div    %esi
  80245e:	89 c5                	mov    %eax,%ebp
  802460:	89 f8                	mov    %edi,%eax
  802462:	f7 f6                	div    %esi
  802464:	89 ea                	mov    %ebp,%edx
  802466:	83 c4 0c             	add    $0xc,%esp
  802469:	5e                   	pop    %esi
  80246a:	5f                   	pop    %edi
  80246b:	5d                   	pop    %ebp
  80246c:	c3                   	ret    
  80246d:	8d 76 00             	lea    0x0(%esi),%esi
  802470:	39 e8                	cmp    %ebp,%eax
  802472:	77 24                	ja     802498 <__udivdi3+0x78>
  802474:	0f bd e8             	bsr    %eax,%ebp
  802477:	83 f5 1f             	xor    $0x1f,%ebp
  80247a:	75 3c                	jne    8024b8 <__udivdi3+0x98>
  80247c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802480:	39 34 24             	cmp    %esi,(%esp)
  802483:	0f 86 9f 00 00 00    	jbe    802528 <__udivdi3+0x108>
  802489:	39 d0                	cmp    %edx,%eax
  80248b:	0f 82 97 00 00 00    	jb     802528 <__udivdi3+0x108>
  802491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802498:	31 d2                	xor    %edx,%edx
  80249a:	31 c0                	xor    %eax,%eax
  80249c:	83 c4 0c             	add    $0xc,%esp
  80249f:	5e                   	pop    %esi
  8024a0:	5f                   	pop    %edi
  8024a1:	5d                   	pop    %ebp
  8024a2:	c3                   	ret    
  8024a3:	90                   	nop
  8024a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024a8:	89 f8                	mov    %edi,%eax
  8024aa:	f7 f1                	div    %ecx
  8024ac:	31 d2                	xor    %edx,%edx
  8024ae:	83 c4 0c             	add    $0xc,%esp
  8024b1:	5e                   	pop    %esi
  8024b2:	5f                   	pop    %edi
  8024b3:	5d                   	pop    %ebp
  8024b4:	c3                   	ret    
  8024b5:	8d 76 00             	lea    0x0(%esi),%esi
  8024b8:	89 e9                	mov    %ebp,%ecx
  8024ba:	8b 3c 24             	mov    (%esp),%edi
  8024bd:	d3 e0                	shl    %cl,%eax
  8024bf:	89 c6                	mov    %eax,%esi
  8024c1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024c6:	29 e8                	sub    %ebp,%eax
  8024c8:	89 c1                	mov    %eax,%ecx
  8024ca:	d3 ef                	shr    %cl,%edi
  8024cc:	89 e9                	mov    %ebp,%ecx
  8024ce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024d2:	8b 3c 24             	mov    (%esp),%edi
  8024d5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024d9:	89 d6                	mov    %edx,%esi
  8024db:	d3 e7                	shl    %cl,%edi
  8024dd:	89 c1                	mov    %eax,%ecx
  8024df:	89 3c 24             	mov    %edi,(%esp)
  8024e2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024e6:	d3 ee                	shr    %cl,%esi
  8024e8:	89 e9                	mov    %ebp,%ecx
  8024ea:	d3 e2                	shl    %cl,%edx
  8024ec:	89 c1                	mov    %eax,%ecx
  8024ee:	d3 ef                	shr    %cl,%edi
  8024f0:	09 d7                	or     %edx,%edi
  8024f2:	89 f2                	mov    %esi,%edx
  8024f4:	89 f8                	mov    %edi,%eax
  8024f6:	f7 74 24 08          	divl   0x8(%esp)
  8024fa:	89 d6                	mov    %edx,%esi
  8024fc:	89 c7                	mov    %eax,%edi
  8024fe:	f7 24 24             	mull   (%esp)
  802501:	39 d6                	cmp    %edx,%esi
  802503:	89 14 24             	mov    %edx,(%esp)
  802506:	72 30                	jb     802538 <__udivdi3+0x118>
  802508:	8b 54 24 04          	mov    0x4(%esp),%edx
  80250c:	89 e9                	mov    %ebp,%ecx
  80250e:	d3 e2                	shl    %cl,%edx
  802510:	39 c2                	cmp    %eax,%edx
  802512:	73 05                	jae    802519 <__udivdi3+0xf9>
  802514:	3b 34 24             	cmp    (%esp),%esi
  802517:	74 1f                	je     802538 <__udivdi3+0x118>
  802519:	89 f8                	mov    %edi,%eax
  80251b:	31 d2                	xor    %edx,%edx
  80251d:	e9 7a ff ff ff       	jmp    80249c <__udivdi3+0x7c>
  802522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802528:	31 d2                	xor    %edx,%edx
  80252a:	b8 01 00 00 00       	mov    $0x1,%eax
  80252f:	e9 68 ff ff ff       	jmp    80249c <__udivdi3+0x7c>
  802534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802538:	8d 47 ff             	lea    -0x1(%edi),%eax
  80253b:	31 d2                	xor    %edx,%edx
  80253d:	83 c4 0c             	add    $0xc,%esp
  802540:	5e                   	pop    %esi
  802541:	5f                   	pop    %edi
  802542:	5d                   	pop    %ebp
  802543:	c3                   	ret    
  802544:	66 90                	xchg   %ax,%ax
  802546:	66 90                	xchg   %ax,%ax
  802548:	66 90                	xchg   %ax,%ax
  80254a:	66 90                	xchg   %ax,%ax
  80254c:	66 90                	xchg   %ax,%ax
  80254e:	66 90                	xchg   %ax,%ax

00802550 <__umoddi3>:
  802550:	55                   	push   %ebp
  802551:	57                   	push   %edi
  802552:	56                   	push   %esi
  802553:	83 ec 14             	sub    $0x14,%esp
  802556:	8b 44 24 28          	mov    0x28(%esp),%eax
  80255a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80255e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802562:	89 c7                	mov    %eax,%edi
  802564:	89 44 24 04          	mov    %eax,0x4(%esp)
  802568:	8b 44 24 30          	mov    0x30(%esp),%eax
  80256c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802570:	89 34 24             	mov    %esi,(%esp)
  802573:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802577:	85 c0                	test   %eax,%eax
  802579:	89 c2                	mov    %eax,%edx
  80257b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80257f:	75 17                	jne    802598 <__umoddi3+0x48>
  802581:	39 fe                	cmp    %edi,%esi
  802583:	76 4b                	jbe    8025d0 <__umoddi3+0x80>
  802585:	89 c8                	mov    %ecx,%eax
  802587:	89 fa                	mov    %edi,%edx
  802589:	f7 f6                	div    %esi
  80258b:	89 d0                	mov    %edx,%eax
  80258d:	31 d2                	xor    %edx,%edx
  80258f:	83 c4 14             	add    $0x14,%esp
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    
  802596:	66 90                	xchg   %ax,%ax
  802598:	39 f8                	cmp    %edi,%eax
  80259a:	77 54                	ja     8025f0 <__umoddi3+0xa0>
  80259c:	0f bd e8             	bsr    %eax,%ebp
  80259f:	83 f5 1f             	xor    $0x1f,%ebp
  8025a2:	75 5c                	jne    802600 <__umoddi3+0xb0>
  8025a4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025a8:	39 3c 24             	cmp    %edi,(%esp)
  8025ab:	0f 87 e7 00 00 00    	ja     802698 <__umoddi3+0x148>
  8025b1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025b5:	29 f1                	sub    %esi,%ecx
  8025b7:	19 c7                	sbb    %eax,%edi
  8025b9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025c1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025c5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025c9:	83 c4 14             	add    $0x14,%esp
  8025cc:	5e                   	pop    %esi
  8025cd:	5f                   	pop    %edi
  8025ce:	5d                   	pop    %ebp
  8025cf:	c3                   	ret    
  8025d0:	85 f6                	test   %esi,%esi
  8025d2:	89 f5                	mov    %esi,%ebp
  8025d4:	75 0b                	jne    8025e1 <__umoddi3+0x91>
  8025d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025db:	31 d2                	xor    %edx,%edx
  8025dd:	f7 f6                	div    %esi
  8025df:	89 c5                	mov    %eax,%ebp
  8025e1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025e5:	31 d2                	xor    %edx,%edx
  8025e7:	f7 f5                	div    %ebp
  8025e9:	89 c8                	mov    %ecx,%eax
  8025eb:	f7 f5                	div    %ebp
  8025ed:	eb 9c                	jmp    80258b <__umoddi3+0x3b>
  8025ef:	90                   	nop
  8025f0:	89 c8                	mov    %ecx,%eax
  8025f2:	89 fa                	mov    %edi,%edx
  8025f4:	83 c4 14             	add    $0x14,%esp
  8025f7:	5e                   	pop    %esi
  8025f8:	5f                   	pop    %edi
  8025f9:	5d                   	pop    %ebp
  8025fa:	c3                   	ret    
  8025fb:	90                   	nop
  8025fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802600:	8b 04 24             	mov    (%esp),%eax
  802603:	be 20 00 00 00       	mov    $0x20,%esi
  802608:	89 e9                	mov    %ebp,%ecx
  80260a:	29 ee                	sub    %ebp,%esi
  80260c:	d3 e2                	shl    %cl,%edx
  80260e:	89 f1                	mov    %esi,%ecx
  802610:	d3 e8                	shr    %cl,%eax
  802612:	89 e9                	mov    %ebp,%ecx
  802614:	89 44 24 04          	mov    %eax,0x4(%esp)
  802618:	8b 04 24             	mov    (%esp),%eax
  80261b:	09 54 24 04          	or     %edx,0x4(%esp)
  80261f:	89 fa                	mov    %edi,%edx
  802621:	d3 e0                	shl    %cl,%eax
  802623:	89 f1                	mov    %esi,%ecx
  802625:	89 44 24 08          	mov    %eax,0x8(%esp)
  802629:	8b 44 24 10          	mov    0x10(%esp),%eax
  80262d:	d3 ea                	shr    %cl,%edx
  80262f:	89 e9                	mov    %ebp,%ecx
  802631:	d3 e7                	shl    %cl,%edi
  802633:	89 f1                	mov    %esi,%ecx
  802635:	d3 e8                	shr    %cl,%eax
  802637:	89 e9                	mov    %ebp,%ecx
  802639:	09 f8                	or     %edi,%eax
  80263b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80263f:	f7 74 24 04          	divl   0x4(%esp)
  802643:	d3 e7                	shl    %cl,%edi
  802645:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802649:	89 d7                	mov    %edx,%edi
  80264b:	f7 64 24 08          	mull   0x8(%esp)
  80264f:	39 d7                	cmp    %edx,%edi
  802651:	89 c1                	mov    %eax,%ecx
  802653:	89 14 24             	mov    %edx,(%esp)
  802656:	72 2c                	jb     802684 <__umoddi3+0x134>
  802658:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80265c:	72 22                	jb     802680 <__umoddi3+0x130>
  80265e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802662:	29 c8                	sub    %ecx,%eax
  802664:	19 d7                	sbb    %edx,%edi
  802666:	89 e9                	mov    %ebp,%ecx
  802668:	89 fa                	mov    %edi,%edx
  80266a:	d3 e8                	shr    %cl,%eax
  80266c:	89 f1                	mov    %esi,%ecx
  80266e:	d3 e2                	shl    %cl,%edx
  802670:	89 e9                	mov    %ebp,%ecx
  802672:	d3 ef                	shr    %cl,%edi
  802674:	09 d0                	or     %edx,%eax
  802676:	89 fa                	mov    %edi,%edx
  802678:	83 c4 14             	add    $0x14,%esp
  80267b:	5e                   	pop    %esi
  80267c:	5f                   	pop    %edi
  80267d:	5d                   	pop    %ebp
  80267e:	c3                   	ret    
  80267f:	90                   	nop
  802680:	39 d7                	cmp    %edx,%edi
  802682:	75 da                	jne    80265e <__umoddi3+0x10e>
  802684:	8b 14 24             	mov    (%esp),%edx
  802687:	89 c1                	mov    %eax,%ecx
  802689:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80268d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802691:	eb cb                	jmp    80265e <__umoddi3+0x10e>
  802693:	90                   	nop
  802694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802698:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80269c:	0f 82 0f ff ff ff    	jb     8025b1 <__umoddi3+0x61>
  8026a2:	e9 1a ff ff ff       	jmp    8025c1 <__umoddi3+0x71>
