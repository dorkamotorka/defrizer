# xdp

[![Go Reference](https://pkg.go.dev/badge/github.com/asavie/xdp.svg)](https://pkg.go.dev/github.com/asavie/xdp)

Package github.com/asavie/xdp allows one to use [XDP sockets](https://lwn.net/Articles/750845/) from the Go programming language.

For usage examples, see the [documentation](https://pkg.go.dev/github.com/asavie/xdp) or the [examples/](https://github.com/asavie/xdp/tree/master/examples) directory.

## Dependencies

In order to make the `dumpframes` work, you need to install the following packages:

	go install github.com/cilium/ebpf/cmd/bpf2go@latest
	go get github.com/asavie/xdp/dumpframes/ebpf
	sudo apt install llvm clang libelf-dev libpcap-dev gcc-multilib build-essential linux-tools-$(uname -r)

Apparently the clang and llvm libraries version need to match. Also I got it work on Ubuntu 20.04, while failed on Ubuntu 22.04, because there's and `stddef.h` library missing. 
Still something I need to understand better.

## How to run

In case you modify the `ebpf` code you need to execute:

	go generate

and if you modify the user space program, you need to compile it using:

	go build dumpframes.go

Then you can execute it using:

	sudo ./dumpframes

In case you need to create a test veth, use this [tutorial](https://linuxconfig.org/configuring-virtual-network-interfaces-in-linux).
