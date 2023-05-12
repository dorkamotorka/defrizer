# xdp

[![Go Reference](https://pkg.go.dev/badge/github.com/asavie/xdp.svg)](https://pkg.go.dev/github.com/asavie/xdp)

Package github.com/asavie/xdp allows one to use [XDP sockets](https://lwn.net/Articles/750845/) from the Go programming language.

For usage examples, see the [documentation](https://pkg.go.dev/github.com/asavie/xdp) or the [examples/](https://github.com/asavie/xdp/tree/master/examples) directory.

## How to run

In case you modify the `ebpf` code you need to execute:

	go generate

and if you modify the user space program, you need to compile it using:

	go build dumpframes.go

Then you can execute it using:

	sudo ./dumpframes

In case you need to create a test veth, use this [tutorial](https://linuxconfig.org/configuring-virtual-network-interfaces-in-linux).
