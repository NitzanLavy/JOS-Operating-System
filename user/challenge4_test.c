#include <inc/lib.h>

volatile int counter;

void
umain(int argc, char **argv)
{
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
	sys_set_pri(parent, 1);

	// Fork several environments
	for (i = 0; i < 50; i++) {
		envid_t id  = fork();
		if (id == 0) {
			break;
		} else {
			sys_set_pri(id, i+3);
		}
	}
	
	if (i == 50) {
		cprintf("IM PARENT\n");
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");


	envid_t envid = sys_getenvid();
	cprintf("IM SON NUMBER %d\n",(envs[ENVX(envid)].pri)-2);
	sys_yield();

}

