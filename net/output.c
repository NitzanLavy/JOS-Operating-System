#include "ns.h"
#include "inc/lib.h"

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
	binaryname = "ns_output";


	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver

	int p;
	envid_t envid;
	int32_t res;
	int err;
	while(1)
	{		
		res = ipc_recv(&envid, &nsipcbuf, &p);
		if(res != NSREQ_OUTPUT)
			continue;

		if(!(p & PTE_P))
			continue;
		
		while (1) {
			err = sys_pkt_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);

			if(err == 0)
				break;

			if(err == E_PACKET_TOO_BIG)
				break;

			sys_sleep(ENV_CHANNEL_TX);
		}

	}
}

