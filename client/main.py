from scapy.all import IP, TCP, Raw, send, sr1, raw 

def send_tcp_syn(destination_ip, destination_port, source_port, payload):
    # Craft the IP packet
    ip_packet = IP(dst=destination_ip)

    # Craft the TCP SYN packet with a random source port
    # TODO: Add (254, namespace)
    tcp_syn_packet = TCP(dport=destination_port, sport=source_port, flags='S', options=[(254, (0xf989, 0xcafe, 0x0102, 0x0002)), ('NOP', 0), ('NOP', 0)])
    print(tcp_syn_packet.options)

    # Combine the IP and TCP SYN packets
    syn_packet = ip_packet / tcp_syn_packet
    print(raw(syn_packet))

    # Send the TCP SYN packet and receive the SYN-ACK response
    syn_ack_response = sr1(syn_packet, verbose=False)

    # Extract the acknowledgment number from the SYN-ACK response
    acknowledgment_number = syn_ack_response[TCP].seq + 1
    sequence_number = syn_ack_response[TCP].ack

    return acknowledgment_number, sequence_number

def send_http_get_request(destination_ip, destination_port, source_port, acknowledgment_number, sequence_number):
    # Craft the IP packet
    ip_packet = IP(dst=destination_ip)

    # Craft the TCP ACK packet (to acknowledge the server's SYN-ACK)
    tcp_ack_packet = TCP(dport=destination_port, sport=source_port, flags='A', seq=sequence_number, ack=acknowledgment_number)

    # Combine the IP and TCP ACK packets
    ack_packet = ip_packet / tcp_ack_packet

    # Create the HTTP GET request with the desired payload
    http_get_request = f"GET /function/env?namespace=openfaas-fn HTTP/1.1\r\nHost: {destination_ip}:{destination_port}\r\n\r\n"

    # Combine the HTTP GET request data with the TCP ACK packet
    http_packet = ack_packet / http_get_request

    # Send the HTTP GET request over the existing TCP connection
    response_packet = sr1(http_packet, verbose=False)

    if response_packet:
        print("HTTP GET request successful!")
    else:
        print("No response received.")

    # Extract the acknowledgment number from the SYN-ACK response
    acknowledgment_number = response_packet[TCP].seq + 1
    sequence_number = response_packet[TCP].ack

    # Close TCP connection
    fin_packet = ip_packet / TCP(dport=destination_port, sport=source_port, flags='FA', seq=sequence_number, ack=acknowledgment_number)
    finack_packet = sr1(fin_packet)

    acknowledgment_number = finack_packet[TCP].seq + 1
    sequence_number = finack_packet[TCP].ack
    last_ack = ip_packet / TCP(dport=destination_port, sport=source_port, flags="A", seq=sequence_number, ack=acknowledgment_number)
    send(last_ack)

def pad(payload):
    while (len(payload) != 8): 
       payload += "\x00"

    return payload

if __name__ == "__main__":
    destination_ip = '88.200.23.156'  # Replace with the actual destination IP address
    destination_port = 8080           # Replace with the actual destination port
    source_port = 110
    payload = "env"

    acknowledgment_number, sequence_number = send_tcp_syn(destination_ip, destination_port, source_port, payload)
    send_http_get_request(destination_ip, destination_port, source_port, acknowledgment_number, sequence_number)
