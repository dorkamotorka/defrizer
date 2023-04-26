from scapy.all import *
import time

# Define the IPv6 address and port to send the packet to
ipv6_address = "fc00:dead:cafe:4::1"
port = 80

# Define the TCP flags to use - SYN Packet flag
flags = "S"

for _ in range(10):
    # Construct the TCP SYN packet
    ip = IPv6(dst=ipv6_address)
    tcp = TCP(dport=port, flags=flags)

    # Send the SYN packet and wait for a response
    start_time = time.time()
    syn_ack = sr1(ip/tcp, timeout=1, verbose=False)
    end_time = time.time()

    # If we received a response, print the response time
    if syn_ack:
        print(f"TCP ping response time: {end_time - start_time:.3f} seconds")
    else:
        print("TCP ping failed: no response received")
