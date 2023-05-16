package main

import (
	"flag"
	"fmt"
	"log"
	"net"

	"github.com/cilium/ebpf/ringbuf"
	"github.com/cilium/ebpf/rlimit"
	"github.com/asavie/xdp"
	"github.com/asavie/xdp/src/ebpf"
)

func main() {
	var linkName string
	var queueID int

	log.SetFlags(log.Ldate | log.Ltime | log.Lmicroseconds)

	flag.StringVar(&linkName, "linkname", "lo", "The network link on which rebroadcast should run on.")
	flag.IntVar(&queueID, "queueid", 0, "The ID of the Rx queue to which to attach to on the network link.")
	flag.Parse()

	// Allow the current process to lock memory for eBPF resources.
	if err := rlimit.RemoveMemlock(); err != nil {
		log.Fatal(err)
	}

	interfaces, err := net.Interfaces()
	//fmt.Println(interfaces)
	if err != nil {
		fmt.Printf("error: failed to fetch the list of network interfaces on the system: %v\n", err)
		return
	}

	Ifindex := -1
	for _, iface := range interfaces {
		if iface.Name == linkName {
			Ifindex = iface.Index
			break
		}
	}
	if Ifindex == -1 {
		fmt.Printf("error: couldn't find a suitable network interface to attach to\n")
		return
	}

	var program *xdp.Program
	// Create a new XDP eBPF program and attach it to our chosen network link.
	program, err = ebpf.NewTCPSynProgram(nil)
	if err != nil {
		fmt.Printf("error: failed to create xdp program: %v\n", err)
		return
	}
	defer program.Close()

	if err := program.Attach(Ifindex); err != nil {
		fmt.Printf("error: failed to attach xdp program to interface: %v\n", err)
		return
	}
	defer program.Detach(Ifindex)

	rd, err := ringbuf.NewReader(program.Events)
	if err != nil {
	   panic(err)
	}
	defer rd.Close()

	for {
	   record, err := rd.Read()
	   if err != nil {
	      panic(err)
	   }

	   // Data is padded with 0 for alignment
	   fmt.Println("Sample:", record.RawSample)
	}
}
