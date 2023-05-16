from scapy.all import *
import time

# Define the IPv6 address and port to send the packet to
target = "::1"

# Define destination port on the receiving side
dport = 7777

# Define the TCP flags to use - SYN Packet flag 
# NOTE: even if you don't specify this, TCP sends the SYN packet because this is always the first packet
flags = "S"

# Define some random payload
payload = "hello"

# Construct the TCP SYN packet
ip = IPv6(dst=target)
tcp = TCP(sport=5555, dport=dport, flags=flags)
raw = Raw(load=payload)
packet = ip/tcp/raw
print(packet.payload)

# Send the SYN packet and wait for a response
while True:
    start_time = time.time()
    syn_ack = send(packet)
    end_time = time.time()
    time.sleep(0.5)
