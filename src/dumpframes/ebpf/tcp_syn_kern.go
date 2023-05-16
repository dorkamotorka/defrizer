package ebpf

import (
	"github.com/asavie/xdp"
	"github.com/cilium/ebpf"
)

//go:generate $HOME/go/bin/bpf2go -cc clang-12 tcpsyn tcp_syn_kern.c -- -I/usr/include/ -I./include -I/usr/lib/llvm-12/lib/clang/12.0.0/include/ -nostdinc -O3

// NewTCPSynProgram returns an new eBPF that directs packets to XDP sockets
func NewTCPSynProgram(options *ebpf.CollectionOptions) (*xdp.Program, error) {
	spec, err := loadTcpsyn()
	if err != nil {
		return nil, err
	}

	var program tcpsynObjects
	if err := spec.LoadAndAssign(&program, options); err != nil {
		return nil, err
	}

	p := &xdp.Program{Program: program.XdpSockProg, Queues: program.QidconfMap, Sockets: program.XsksMap}
	return p, nil
}
