#include "ns.h"
#include "inc/lib.h"

#define PKT_MAX_SIZE 2048

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
	binaryname = "ns_input";

	// LAB 6: Your code here:
	// 	- read a packet from the device driver
	//	- send it to the network server
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.

	uint32_t len;
	char buf[PKT_MAX_SIZE];
	int err;

	while(1)
	{
		err = sys_pkt_recv(buf, &len);
		if(err != 0)
		{
			sys_sleep(ENV_CHANNEL_RX);
			continue;
		}

		nsipcbuf.pkt.jp_len = len;
		memcpy(nsipcbuf.pkt.jp_data, buf, len);
		
		ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U);

		// Waiting for some time
		unsigned wait = sys_time_msec() + 50;
		while (sys_time_msec() < wait){
			sys_yield();
		}
	}
}


