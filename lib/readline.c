#include <inc/stdio.h>
#include <inc/error.h>
#include <inc/string.h>

#define BUFLEN 1024
static char buf[BUFLEN];

#define NUM_CMDS 17

static char *commands[NUM_CMDS] = {
	"motd",
	"testfdsharing",
	"script",
	"cat",
 	"echo",
 	"ls",
	"testpteshare",
 	"num",
	"forktree",
	"primes",
	"lorem",
 	"testkbd",
	"newmotd",
 	"testpipe",
	"lsfd",
	"primespipe",
	"hello"
};

int tab_handler(int tab_pos);


char *
readline(const char *prompt)
{
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
			if (echoing)
				cputchar(c);
			buf[i++] = c;
		} else if (c == '\n' || c == '\r') {
			if (echoing)
				cputchar('\n');
			buf[i] = 0;
			return buf;
		} else if (c == '\t') {
			i += tab_handler(i);
		}
	}
}

int
tab_handler(int tab_pos)
{
	char* begin = buf + tab_pos;
	while ((begin > buf) && (*(begin -1) != ' '))
		begin--;
	
	int len = buf + tab_pos - begin, found_num = 0, cmd_append_len = 0, i;
	char* cmd = 0;

    	for (i = 0; len > 0 && i < NUM_CMDS; i++) {
      		if (strncmp(begin, commands[i], len) == 0) {
			found_num++;
         		cmd = commands[i];
         		cmd_append_len = strlen(cmd) - len;
      		}
   	}

	if (found_num > 1) {
		#if JOS_KERNEL
			cprintf("\nYour options are:\n");
		#else
			fprintf(1, "\nYour options are:\n");
		#endif
		for (i = 0; i < NUM_CMDS; i++) {
			if (strncmp(begin, commands[i], len) == 0) {
                    		#if JOS_KERNEL
                            		cprintf("%s\n", commands[i]);
                   		 #else
                           		fprintf(1, "%s\n", commands[i]);
                   		 #endif
                 	}
            	}
		#if JOS_KERNEL
			cprintf("$ ");
		#else
			fprintf(1, "$ ");
		#endif
		return -len;
	}

	int pos_to_write = tab_pos;

	if (cmd_append_len > 0){
		for (i = len; i < strlen(cmd); i++) {
      			buf[pos_to_write] = cmd[i];
			pos_to_write++;
      			cputchar(cmd[i]);
   		}

	}

	return cmd_append_len;
}

