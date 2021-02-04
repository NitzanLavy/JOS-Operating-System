#include <inc/mmu.h>
#include <inc/x86.h>
#include <inc/assert.h>

#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/env.h>
#include <kern/syscall.h>
#include <kern/sched.h>
#include <kern/kclock.h>
#include <kern/picirq.h>
#include <kern/cpu.h>
#include <kern/spinlock.h>
#include <kern/time.h>
#include <kern/e1000.h>

static struct Taskstate ts;

/* For debugging, so print_trapframe can distinguish between printing
 * a saved trapframe and printing the current trapframe and print some
 * additional information in the latter case.
 */
static struct Trapframe *last_tf;

/* Interrupt descriptor table.  (Must be built at run time because
 * shifted function addresses can't be represented in relocation records.)
 */
struct Gatedesc idt[256] = { { 0 } };
struct Pseudodesc idt_pd = {
	sizeof(idt) - 1, (uint32_t) idt
};


static const char *trapname(int trapno)
{
	static const char * const excnames[] = {
		"Divide error",
		"Debug",
		"Non-Maskable Interrupt",
		"Breakpoint",
		"Overflow",
		"BOUND Range Exceeded",
		"Invalid Opcode",
		"Device Not Available",
		"Double Fault",
		"Coprocessor Segment Overrun",
		"Invalid TSS",
		"Segment Not Present",
		"Stack Fault",
		"General Protection",
		"Page Fault",
		"(unknown trap)",
		"x87 FPU Floating-Point Error",
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
		return "Hardware Interrupt";
	return "(unknown trap)";
}

#define MAKE_THE_MF_T(i_n,the_mf_t,per) void the_mf_t(); SETGATE(idt[i_n], 0, GD_KT, the_mf_t, per);

void
trap_init(void)
{
	extern struct Segdesc gdt[];

	// LAB 3: Your code here.

	MAKE_THE_MF_T(0,t_func_divide,0)
	MAKE_THE_MF_T(1,t_func_debug,0)

	MAKE_THE_MF_T(3, t_func_brkpt, 3);
	MAKE_THE_MF_T(4, t_func_oflow, 0);
	MAKE_THE_MF_T(5, t_func_bound, 0);
	MAKE_THE_MF_T(6, t_func_illop, 0);
	MAKE_THE_MF_T(7, t_func_device, 0);
	MAKE_THE_MF_T(8, t_func_dblfit, 0);

	MAKE_THE_MF_T(10, t_func_tss, 0);
	MAKE_THE_MF_T(11, t_func_segnp, 0);
	MAKE_THE_MF_T(12, t_func_stack, 0);
	MAKE_THE_MF_T(13, t_func_gpflt, 0);
	MAKE_THE_MF_T(14, t_func_pgflt, 0);

	MAKE_THE_MF_T(16, t_func_fperr, 0);


	MAKE_THE_MF_T(48, t_func_syscall, 3);

	extern void IRQ_0();
	extern void IRQ_1();
	extern void IRQ_2();
	extern void IRQ_3();
	extern void IRQ_4();
	extern void IRQ_5();
	extern void IRQ_6();
	extern void IRQ_7();
	extern void IRQ_8();
	extern void IRQ_9();
	extern void IRQ_10();
	extern void IRQ_11();
	extern void IRQ_12();
	extern void IRQ_13();
	extern void IRQ_14();
	extern void IRQ_15();
	SETGATE(idt[IRQ_OFFSET + 0], 0, GD_KT, IRQ_0, 0);
	SETGATE(idt[IRQ_OFFSET + 1], 0, GD_KT, IRQ_1, 0);
	SETGATE(idt[IRQ_OFFSET + 2], 0, GD_KT, IRQ_2, 0);
	SETGATE(idt[IRQ_OFFSET + 3], 0, GD_KT, IRQ_3, 0);
	SETGATE(idt[IRQ_OFFSET + 4], 0, GD_KT, IRQ_4, 0);
	SETGATE(idt[IRQ_OFFSET + 5], 0, GD_KT, IRQ_5, 0);
	SETGATE(idt[IRQ_OFFSET + 6], 0, GD_KT, IRQ_6, 0);
	SETGATE(idt[IRQ_OFFSET + 7], 0, GD_KT, IRQ_7, 0);
	SETGATE(idt[IRQ_OFFSET + 8], 0, GD_KT, IRQ_8, 0);
	SETGATE(idt[IRQ_OFFSET + 9], 0, GD_KT, IRQ_9, 0);
	SETGATE(idt[IRQ_OFFSET + 10], 0, GD_KT, IRQ_10, 0);
	SETGATE(idt[IRQ_OFFSET + 11], 0, GD_KT, IRQ_11, 0);
	SETGATE(idt[IRQ_OFFSET + 12], 0, GD_KT, IRQ_12, 0);
	SETGATE(idt[IRQ_OFFSET + 13], 0, GD_KT, IRQ_13, 0);
	SETGATE(idt[IRQ_OFFSET + 14], 0, GD_KT, IRQ_14, 0);
	SETGATE(idt[IRQ_OFFSET + 15], 0, GD_KT, IRQ_15, 0);
	

	// Per-CPU setup 
	trap_init_percpu();
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
	// The example code here sets up the Task State Segment (TSS) and
	// the TSS descriptor for CPU 0. But it is incorrect if we are
	// running on other CPUs because each CPU has its own kernel stack.
	// Fix the code so that it works for all CPUs.
	//
	// Hints:
	//   - The macro "thiscpu" always refers to the current CPU's
	//     struct CpuInfo;
	//   - The ID of the current CPU is given by cpunum() or
	//     thiscpu->cpu_id;
	//   - Use "thiscpu->cpu_ts" as the TSS for the current CPU,
	//     rather than the global "ts" variable;
	//   - Use gdt[(GD_TSS0 >> 3) + i] for CPU i's TSS descriptor;
	//   - You mapped the per-CPU kernel stacks in mem_init_mp()
	//
	// ltr sets a 'busy' flag in the TSS selector, so if you
	// accidentally load the same TSS on more than one CPU, you'll
	// get a triple fault.  If you set up an individual CPU's TSS
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - thiscpu->cpu_id * (KSTKSIZE + KSTKGAP);
	thiscpu->cpu_ts.ts_ss0 = GD_KD;

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3) + thiscpu->cpu_id] = SEG16(STS_T32A, (uint32_t) (&thiscpu->cpu_ts),
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + thiscpu->cpu_id].sd_s = 0;

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0 + (thiscpu->cpu_id << 3));

	// Load the IDT
	lidt(&idt_pd);
}

void
print_trapframe(struct Trapframe *tf)
{
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
		cprintf("  cr2  0x%08x\n", rcr2());
	cprintf("  err  0x%08x", tf->tf_err);
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
	cprintf("  eip  0x%08x\n", tf->tf_eip);
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
	if ((tf->tf_cs & 3) != 0) {
		cprintf("  esp  0x%08x\n", tf->tf_esp);
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
	}
}

void
print_regs(struct PushRegs *regs)
{
	cprintf("  edi  0x%08x\n", regs->reg_edi);
	cprintf("  esi  0x%08x\n", regs->reg_esi);
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
	cprintf("  edx  0x%08x\n", regs->reg_edx);
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
	cprintf("  eax  0x%08x\n", regs->reg_eax);
}

static void
trap_dispatch(struct Trapframe *tf)
{
	// Handle processor exceptions.
	// LAB 3: Your code here.
	switch (tf->tf_trapno) {

		case T_PGFLT:
			page_fault_handler(tf);
			return;

		case T_DEBUG:
			monitor(tf);
			return;

		case T_BRKPT:
			monitor(tf);
			return;

		case T_SYSCALL:
			tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx, tf->tf_regs.reg_ebx, tf->tf_regs.reg_edi, tf->tf_regs.reg_esi);
			return;

		default:
			break;
	}

	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
		cprintf("Spurious interrupt on irq 7\n");
		print_trapframe(tf);
		return;
	}

	// Handle clock interrupts. Don't forget to acknowledge the
	// interrupt using lapic_eoi() before calling the scheduler!
	// LAB 4: Your code here.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
		lapic_eoi();
		if (cpunum() == 0)
			time_tick();
		sched_yield();
	}

	// Add time tick increment to clock interrupts.
	// Be careful! In multiprocessors, clock interrupts are
	// triggered on every CPU.
	// LAB 6: Your code here.

	// Was more logical in my opinion to implement it alongside the previous if condition.

	// Handling interrupt from NIC
	// LAB 6

	if (tf->tf_trapno == IRQ_OFFSET +IRQ_NIC) {
		uint32_t icr_reg = nic_get_reg(E1000_ICR);
		enum EnvChannel channel;

		if (icr_reg & E1000_ICR_TXDW)
			channel = ENV_CHANNEL_TX;
		
		if (icr_reg & E1000_ICR_RXT0)
			channel = ENV_CHANNEL_RX;

		wakeup(channel);
		lapic_eoi();
		irq_eoi();
		return;
	}


	// Handle keyboard and serial interrupts.
	// LAB 5: Your code here.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_KBD) {
		kbd_intr();
		return;
	}

	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL) {
		serial_intr();
		return;
	}

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
	if (tf->tf_cs == GD_KT)
		panic("unhandled trap in kernel");
	else {
		env_destroy(curenv);
		return;
	}
}

void
trap(struct Trapframe *tf)
{
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");

	// Halt the CPU if some other CPU has called panic()
	extern char *panicstr;
	if (panicstr)
		asm volatile("hlt");

	// Re-acqurie the big kernel lock if we were halted in
	// sched_yield()
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
		lock_kernel();
	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));

	if ((tf->tf_cs & 3) == 3) {
		// Trapped from user mode.
		// Acquire the big kernel lock before doing any
		// serious kernel work.
		// LAB 4: Your code here.
		lock_kernel();
		assert(curenv);

		// Garbage collect if current enviroment is a zombie
		if (curenv->env_status == ENV_DYING) {
			env_free(curenv);
			curenv = NULL;
			sched_yield();
		}

		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
	}

	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNING)
		env_run(curenv);
	else
		sched_yield();
}


void
page_fault_handler(struct Trapframe *tf)
{
	uint32_t fault_va;

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if ((tf->tf_cs&3) == 0){
		panic("Kernel page fault! Faulty address %08x",fault_va);
	}

	// We've already handled kernel-mode exceptions, so if we get here,
	// the page fault happened in user mode.

	// Call the environment's page fault upcall, if one exists.  Set up a
	// page fault stack frame on the user exception stack (below
	// UXSTACKTOP), then branch to curenv->env_pgfault_upcall.
	//
	// The page fault upcall might cause another page fault, in which case
	// we branch to the page fault upcall recursively, pushing another
	// page fault stack frame on top of the user exception stack.
	//
	// The trap handler needs one word of scratch space at the top of the
	// trap-time stack in order to return.  In the non-recursive case, we
	// don't have to worry about this because the top of the regular user
	// stack is free.  In the recursive case, this means we have to leave
	// an extra word between the current top of the exception stack and
	// the new stack frame because the exception stack _is_ the trap-time
	// stack.
	//
	// If there's no page fault upcall, the environment didn't allocate a
	// page for its exception stack or can't write to it, or the exception
	// stack overflows, then destroy the environment that caused the fault.
	// Note that the grade script assumes you will first check for the page
	// fault upcall and print the "user fault va" message below if there is
	// none.  The remaining three checks can be combined into a single test.
	//
	// Hints:
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	
	if(curenv->env_pgfault_upcall == NULL){
		cprintf("[%08x] user fault va %08x ip %08x\n",curenv->env_id, fault_va, tf->tf_eip);
		print_trapframe(tf);
		env_destroy(curenv);
	}

	struct UTrapframe* utf = NULL;
	uint32_t cur_esp = tf->tf_esp;

	if(tf->tf_esp < UXSTACKTOP && tf->tf_esp >= (UXSTACKTOP-PGSIZE)) {
		utf = (struct UTrapframe *)(cur_esp - 4);
	} else {
		utf = (struct UTrapframe *)UXSTACKTOP;
	}

	utf -= sizeof(struct UTrapframe)/4;

	user_mem_assert(curenv, (void *)utf, sizeof(struct UTrapframe), PTE_U);
	user_mem_assert(curenv, curenv->env_pgfault_upcall, 1, PTE_U);
		
	utf->utf_fault_va = fault_va;
	utf->utf_err = tf->tf_err;
	utf->utf_regs = tf->tf_regs;
	utf->utf_eip = tf->tf_eip;
	utf->utf_eflags = tf->tf_eflags;
	utf->utf_esp = tf->tf_esp;

	tf->tf_eip = (uint32_t)(curenv->env_pgfault_upcall);
	tf->tf_esp = (uint32_t)utf;
	env_run(curenv);


}

