/* SPDX-License-Identifier: GPL-2.0 */

#include <linux/bpf.h>
#include "bpf_helpers.h"

/* Each Xsk socket is binded to a particular netdev queue */
struct bpf_map_def SEC("maps") xsks_map = {
	.type = BPF_MAP_TYPE_XSKMAP,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 64,  /* Assume netdev has no more than 64 queues - each (virtual) interface it's own queue */
};

/* Each CPU has its own array of key:value pairs - userspace program needs to take care of aggregation */
struct bpf_map_def SEC("maps") xdp_stats_map = {
	.type        = BPF_MAP_TYPE_ARRAY,
	.key_size    = sizeof(int),
	.value_size  = sizeof(__u32),
	.max_entries = 64,
};

/* user accessible metadata for XDP packet hook
struct xdp_md {
	__u32 data;
	__u32 data_end;
	__u32 data_meta;
	__u32 ingress_ifindex; // rxq->dev->ifindex
	__u32 rx_queue_index;  // rxq->queue_index

	__u32 egress_ifindex;  // txq->dev->ifindex
};
*/
SEC("xdp_sock")
int xdp_sock_prog(struct xdp_md *ctx)
{
    int index = ctx->rx_queue_index;
    __u32 *pkt_count;
    // Lookup stat for a particular netdev queue
    pkt_count = bpf_map_lookup_elem(&xdp_stats_map, &index);
    if (pkt_count) {
        /* We pass every other packet */
        if ((*pkt_count)++ & 1)
            return XDP_PASS;
    }

    /* A set entry here means that the correspnding queue_id
     * has an active AF_XDP socket bound to it. */
    // Lookup if the netdev queue id (index) has a corresponding Xsk
    if (bpf_map_lookup_elem(&xsks_map, &index))
       	// Redirect the packet to the endpoint referenced by map at index key
        return bpf_redirect_map(&xsks_map, index, 0);

    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
