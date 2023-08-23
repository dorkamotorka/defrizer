# Defrizer

## Edit Faas Gateway

* On the local machine, build new gateway docker image by updating version in `/faas/gateway/Makefile` and calling `make`
* Push new image using `docker push dorkamotorka/gateway:(version)`
* Update gateway container version in `faasd/docker-compose.yaml` on the `faas` server

## Install Faasd

Set up faasd by calling `./hack/install.sh` from the `faasd` directory on the FaaS server

This sets up Faasd containers and loads the fresh BPF program into the kernel.

## Uninstall Faasd

* Stop faasd and faasd-provider
```
sudo systemctl stop faasd
sudo systemctl stop faasd-provider
sudo systemctl stop containerd
```

* Remove faasd from machine
```
sudo systemctl disable faasd
sudo systemctl disable faasd-provider
sudo systemctl disable containerd
sudo rm -rf /usr/local/bin/faasd
sudo rm -rf /var/lib/faasd
sudo rm -rf /usr/lib/systemd/system/faasd-provider.service
sudo rm -rf /usr/lib/systemd/system/faasd.service
sudo rm -rf /usr/lib/systemd/system/containerd
sudo systemctl daemon-reload
sudo rm -rf /usr/local/bin/containerd
sudo rm -rf /usr/local/bin/containerd-shim-runc-v2
```

## Loading BPF

Since Faasd only loads the BPF program, it still needs to be attached to a specific network interface.

* list BPF programs to find the ID:
```
sudo bpftool prog
```

* Attach BPF using:
```
sudo bpftool net attach xdp id [ID] dev [NET.INTERFACE]
```

* Check if BPF successfully attached:
```
ip link (| grep xdp)
```

## Unloading BPF

* Detach BPF from network interface:
```
sudo bpftool net detach xdp dev [NET.INTERFACE]
```

## Debug FaasD and BPF
* Faas Gateway logs
```
journalctl -u containerd -f --all -o short-unix | grep openfaas:gateway
```

* TCP log of the TCP SYN packets on the network interface:
```
sudo tcpdump -i [NET.INTERFACE] "tcp[tcpflags] & (tcp-syn) != 0"
```

* BPF program log:
```
sudo cat  /sys/kernel/debug/tracing/trace_pipe
```

* Debug TCP SYN packets:
```
sudo tshark -i enp5s0 -Y "ip.addr == 193.2.76.142 and tcp.flags.syn==1 and tcp.flags.ack==0" -V
```

## Setup TC tool

* Call from `tcgui` directory of the FaaS server:
```
sudo python3 main.py
```

* Then on the localmachine, port forward the GUI from the FaaS server:
```
ssh -L 127.0.0.1:5000:127.0.0.1:5000 -N ubuntu@88.200.23.156
```

## TCP Client

Disable sending of TCP RST packet using:
```
sudo iptables -A OUTPUT -p tcp --tcp-flags RST RST --sport <PORT> -j DROP
```
