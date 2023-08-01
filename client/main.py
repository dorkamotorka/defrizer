from scapy.all import IP, TCP, send, sr1

def send_tcp_syn(destination_ip, destination_port):
    # Craft the IP packet
    ip_packet = IP(dst=destination_ip)

    # Craft the TCP SYN packet with a random source port
    tcp_syn_packet = TCP(dport=destination_port, sport=10000, flags='S', seq=12345)

    # Combine the IP and TCP SYN packets
    syn_packet = ip_packet / tcp_syn_packet

    # Send the TCP SYN packet and receive the SYN-ACK response
    syn_ack_response = sr1(syn_packet, verbose=False)

    # Extract the acknowledgment number from the SYN-ACK response
    acknowledgment_number = syn_ack_response[TCP].seq + 1

    return acknowledgment_number

def send_http_get_request(destination_ip, destination_port, acknowledgment_number, payload):
    # Craft the IP packet
    ip_packet = IP(dst=destination_ip)

    # Craft the TCP ACK packet (to acknowledge the server's SYN-ACK)
    tcp_ack_packet = TCP(dport=destination_port, sport=10000, flags='A', seq=12346, ack=acknowledgment_number)

    # Combine the IP and TCP ACK packets
    ack_packet = ip_packet / tcp_ack_packet

    # Create the HTTP GET request with the desired payload
    http_get_request = f"GET /function/env?namespace=openfaas-fn HTTP/1.1\r\nHost: {destination_ip}:{destination_port}\r\n\r\n"

    # Combine the HTTP GET request data with the TCP ACK packet
    final_packet = ack_packet / http_get_request

    # Send the HTTP GET request over the existing TCP connection
    response_packet = sr1(final_packet, verbose=False)

    if response_packet:
        print("HTTP GET request successful!")
    else:
        print("No response received.")

if __name__ == "__main__":
    destination_ip = '88.200.23.156'  # Replace with the actual destination IP address
    destination_port = 8080           # Replace with the actual destination port
    payload = "env"

    acknowledgment_number = send_tcp_syn(destination_ip, destination_port)
    send_http_get_request(destination_ip, destination_port, acknowledgment_number, payload)
