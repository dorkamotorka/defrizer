build:
	cd ebpf/include && make && cd ../..
	cd ebpf && go generate && cd ..
	go build dumpframes.go
