# Test environment script

This directory contains a setup script that you can use to create test
environments for testing your XDP programs. It works by creating virtual
ethernet (veth) interface pairs and moving one end of each pair to another
network namespace. You can load the XDP program in the other namespace and
send traffic to it through the interface that is visible in the root
namespace.

## Run

The client can be run using:

	sudo ./testenv.sh ping --name veth-basic2

You can check if the BPF program is running on the netdev using:

	ip link list dev veth-basic2

You should have bind it to a netdev using:

	sudo ./af_xdp_user --dev veth-basic2 --force --progsec xdp_sock

## Understanding the network topology

When setting up a test environment, there will be a virtual link between the
environment inside the new namespace, and the interface visible from the
host system root namespace. The new namespace will be named after the
environment name passed to the script, as will the interface visible in the
outer namespace. The interface *inside* the namespace will always be named
'veth0'.

To illustrate this, creating a test environment with the name `test01` (with
 `t setup --name test01`) will result in the following environment being set
up:

```
+-----------------------------+                          +-----------------------------+
| Root namespace              |                          | Testenv namespace 'test01'  |
|                             |      From 'test01'       |                             |
|                    +--------+ TX->                RX-> +--------+                    |
|                    | test01 +--------------------------+  veth0 |                    |
|                    +--------+ <-RX                <-TX +--------+                    |
|                             |       From 'veth0'       |                             |
+-----------------------------+                          +-----------------------------+
```

The `test01` interface visible in the root namespace is the one we will be
installing XDP programs on in the tutorial lessons. The XDP program will see
packets being *received* on this interface; as you can see from the diagram,
this means all packets being transmitted from inside the new namespace.

The setup is created this way to simulate the case where the host machine
have physical interfaces; but instead of the traffic arriving from outside
hosts on physical interfaces, they will arrive from inside the namespace on
the virtual interface. This also means that when you generate traffic to
test your XDP programs, you need to generate it from *inside* the test
environment. The `t ping` command will start the ping inside the test
environment by default, and you can run arbitrary programs inside the
environment by using `t exec -- <command>`, or simply spawning a shell with
`t enter`.
