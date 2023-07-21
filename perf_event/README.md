# Perf Buffer Implementation (PerfBuf)

- `perf` is the user program that can be used to do performance profiling
- `perf_event` is the core struct in kernel. There are several types of perf event, such as tracepoint, software, hardware + custom event triggered by BPF
