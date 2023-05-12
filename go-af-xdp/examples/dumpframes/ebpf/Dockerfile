FROM ubuntu:focal

RUN apt-get update
RUN apt-get install -y make cmake gcc gdb clang llvm llvm-dev autoconf libtool linux-headers-generic libbpf-dev libelf-dev

RUN /bin/bash -c " \
    curl -fsSL https://golang.org/dl/go1.16.2.linux-amd64.tar.gz -o /tmp/golang.tar.gz && \
    tar -C /usr/local -xzf /tmp/golang.tar.gz"

ENV PATH=$PATH:/usr/local/go/bin:/root/go/bin/

RUN apt -y install git

RUN go get github.com/cilium/ebpf/cmd/bpf2go@v0.4.0

ENTRYPOINT ["bash", "-c", "cd /target/examples/dumpframes/ebpf && go generate"]
