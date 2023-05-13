// +build ignore

#include <linux/bpf.h>
#include <linux/in.h>
#include <linux/tcp.h>
#include <linux/if_link.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/ipv6.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>
#include <bpf/parsing_helpers.h>

#define MAX_SOCKS 64

//Ensure map references are available.
/*
        These will be initiated from go and 
        referenced in the end BPF opcodes by file descriptor
*/

struct bpf_map_def SEC("maps") xsks_map = {
	.type = BPF_MAP_TYPE_XSKMAP,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = MAX_SOCKS,
};

struct bpf_map_def SEC("maps") qidconf_map = {
	.type = BPF_MAP_TYPE_ARRAY,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = MAX_SOCKS,
};


SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
{

	int *qidconf, index = ctx->rx_queue_index;

	// A set entry here means that the correspnding queue_id
	// has an active AF_XDP socket bound to it.
	qidconf = bpf_map_lookup_elem(&qidconf_map, &index);
	if (!qidconf)
		return XDP_PASS;

	// redirect packets to an xdp socket that match the given IPv4 or IPv6 protocol; pass all other packets to the kernel
	__u32 action = XDP_PASS; // default action
	int eth_type;
	int ip_type;
	void *data = (void*)(long)ctx->data;
	void *data_end = (void*)(long)ctx->data_end;
	struct ethhdr *eth = data;
	struct iphdr *ip;
        struct ipv6hdr *ipv6;
        struct tcphdr *tcp;

	struct hdr_cursor nh;
	nh.pos = data;

	eth_type = parse_ethhdr(&nh, data_end, &eth);
	if (eth_type < 0) {
	  action = XDP_ABORTED;
	  goto out;
	}

	if (eth_type == bpf_htons(ETH_P_IP)) {
	  ip_type = parse_iphdr(&nh, data_end, &ip);
	}
	else if (eth_type == bpf_htons(ETH_P_IPV6)) {
	  ip_type = parse_ip6hdr(&nh, data_end, &ipv6);
	}
	else {
	  // Default action, pass it up the GNU/Linux network stack to be handled
	  goto out;
	}

	if (ip_type != IPPROTO_TCP) {
	  // We do not need to process non-UDP traffic, pass it up the GNU/Linux network stack to be handled
	  goto out;
	}

	if (parse_tcphdr(&nh, data_end, &tcp) < 0) {
          action = XDP_ABORTED;
          goto out;
        }

	// Forward TCP SYN Packets to XDP sockets
	if (tcp->syn == 1) {
	   if (*qidconf) { 
	      return bpf_redirect_map(&xsks_map, index, 0); 
	   }
	}

out:
	return action;
}

//Basic license just for compiling the object code
char __license[] SEC("license") = "LGPL-2.1 or BSD-2-Clause";
