// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>
#include <kern/pmap.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/kdebug.h>
#include <kern/trap.h>

#define CMDBUF_SIZE	80	// enough for one VGA text line


struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Display backtrace information", mon_backtrace },
	{ "memdump", "Display content of given memory range", mon_mem_dump},
	{ "showmappings", "Display physical page mappings of given virtual memory range", mon_show_mappings},
	{ "setmem", "Set the permissions of a given mappings", mon_set_mem},
	{ "si", "Step into the next command", mon_stepping},
	{ "c", "Continue the program", mon_continue},
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	uint32_t* ebp = (uint32_t*)read_ebp();
	uint32_t eip;
	uint32_t* stack;
	int i;
	struct Eipdebuginfo info;
	cprintf("Stack backtrace:\n");

   	while (ebp != 0x0) {
		stack = ebp;
		eip = stack[1];
		cprintf("ebp %x eip %x args", ebp, eip);
		for (i = 2; i < 7; i++) {
		   	cprintf(" %08x", stack[i]);
			if (i == 6) {
				cprintf("\n");
			}
		}

		debuginfo_eip(eip,&info);		
		cprintf("\t%s:%d: ", info.eip_file, info.eip_line);
		cprintf("%.*s", info.eip_fn_namelen, info.eip_fn_name);
		cprintf("+%d\n", eip-info.eip_fn_addr);
		ebp = (uint32_t*)(*stack);
    	}
    	return 0;
}

uint32_t string_to_number(char* string) {
	uint32_t number = 0;
	string += 2;
	while (*string != '\0') {
		if (*string >= 'a') {
			number = number * 16 + *string - 'a' + 10;
		} else {
			number = number * 16 + *string - '0';
		}
		string++;
	}
	return number;
}


//Display physical page mappings of given virtual memory range
//arg1 = virtual start address, arg2 = virtual end address
int
mon_show_mappings(int argc, char **argv, struct Trapframe *tf) {
	if (argc != 3) {
		cprintf("Incorrect amount of arguments\n");
		return 0;
	}

	uint32_t va_start = string_to_number(argv[1]);
	uint32_t va_end = string_to_number(argv[2]);
	uint32_t i = 0;
	pde_t* pgdir = KADDR((physaddr_t)(rcr3()));
	pte_t* pte;

	while (va_start+i <= va_end ) {
		pte = pgdir_walk(pgdir, (void*)(va_start+i), false);
		if (pte == NULL || (!(*pte & PTE_P))) 
			cprintf("No mapping exists for virtual address %x\n", va_start+i);
		else
			cprintf("virtual address: %x   physical page: %x   ", va_start+i, PTE_ADDR(*pte));
			cprintf("permissions: PTE_P = %x, PTE_W = %x, PTE_U = %x\n", *pte&PTE_P, *pte&PTE_W, *pte&PTE_U);
		i = i + PGSIZE;
	}

	return 0;
}

//Set the permissions of given virtual address.
//arg1 = virtual address, arg2 = permission (P,W,U), arg3 = value to set to.
int mon_set_mem(int argc, char **argv, struct Trapframe *tf) {
	if ((argc != 4) && (argc != 3)) {
		cprintf("Incorrect amount of arguments\n");
		return 0;
	}

	uint32_t addr = string_to_number(argv[1]);

	pte_t *pte = pgdir_walk(kern_pgdir, (void *) addr, false);
	pte_t old_pte_value = *pte;
	
	char perm_flag = argv[2][0];
	char perm_bit;
	if(argc == 3){
		switch (perm_flag) {
			case 'P':
				if(*pte & PTE_P){
					perm_bit = '0';
				} else {
					perm_bit = '1';
				}
				break;

			case 'W':
				if(*pte & PTE_W){
					perm_bit = '0';
				} else {
					perm_bit = '1';
				}
				break;

			case 'U':
				if(*pte & PTE_U){
					perm_bit = '0';
				} else {
					perm_bit = '1';
				}
				break;
				
			default:
				cprintf("Invalid permission type\n");
				return 0;
		}

	} else {
		perm_bit = argv[3][0];
	}
	
	uint32_t perm = 0;
	switch (perm_flag) {
		case 'P':
			perm = PTE_P;
			break;

		case 'W':
			perm = PTE_W;
			break;

		case 'U':
			perm = PTE_U;
			break;
		default:
			cprintf("Invalid permission type\n");
			return 0;
	}

	switch (perm_bit) {
		case '0':
			*pte = *pte & ~perm;
			break;

		case '1':
			*pte = *pte | perm;
			break;

		default:
			cprintf("Invalid permission value\n");
			return 0;
	}

	cprintf("%x before setting memory: ", addr);
	cprintf("PTE_P: %x, PTE_W: %x, PTE_U: %x\n", old_pte_value & PTE_P, old_pte_value & PTE_W, old_pte_value & PTE_U);
	cprintf("%x after  setting memory: ", addr);
	cprintf("PTE_P: %x, PTE_W: %x, PTE_U: %x\n", *pte & PTE_P, *pte & PTE_W, *pte & PTE_U);
	return 0;
}


//Display the memory content of given address range.
//arg1 = start address, arg2 = end address
int
mon_mem_dump(int argc, char **argv, struct Trapframe *tf) {
	if (argc != 3) {
		cprintf("Incorrect amount of arguments\n");
		return 0;
	}

	uint32_t address_start = string_to_number(argv[1]);
	uint32_t address_end = string_to_number(argv[2]);
	void** va_start = (void**) (address_start);
	void** va_end = (void**) (address_end);
	uint32_t i = 0;

	if (PGNUM(address_start) < npages)
		va_start =(void**) KADDR(address_start);

	if (PGNUM(address_end) < npages)
		va_end =(void**) KADDR(address_end);

	while (va_start+i <= va_end ) {
		cprintf("Memory content at virtual address %x is %x\n",va_start+i,va_start[i]);
		i++;
	}

	return 0;
}

//Enables single stepping by setting trap flag (bit num 8) of EFLAGS register to 1.
//no arguments
int
mon_stepping(int argc, char **argv, struct Trapframe *tf) {
	if (argc != 1) {
		cprintf("Incorrect amount of arguments\n");
		return 0;
	}

	if (tf == NULL) {
		cprintf("No valid trap frame\n");
		return 0;
	}

	tf->tf_eflags = tf->tf_eflags | FL_TF;

	return -1;
}

//Disables single stepping by setting trap flag (bit num 8) of EFLAGS register to 0.
//no arguments
int
mon_continue(int argc, char **argv, struct Trapframe *tf) {
	if (argc != 1) {
		cprintf("Incorrect amount of arguments\n");
		return 0;
	}

	if (tf == NULL) {
		cprintf("No valid trap frame\n");
		return 0;
	}

	tf->tf_eflags = tf->tf_eflags & ~FL_TF;

	return -1;
}



/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}


void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	if (tf != NULL)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
