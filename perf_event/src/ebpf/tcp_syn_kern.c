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
#include "tcp_syn_kern.h"

struct bpf_map_def SEC("maps") events  = {
   .type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
};

SEC("xdp_event") int perf_event_test(void *ctx) 
{
   unsigned char buf[] = {1, 1, 1, 2, 2};
   return bpf_perf_event_output(ctx, &events, BPF_F_CURRENT_CPU, &buf[0], 5);
}

//Basic license just for compiling the object code
char __license[] SEC("license") = "GPL";
