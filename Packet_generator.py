from scapy.all import *

pkt_list = []
for i in range(0, 10 * 1000):
    payload_str = "The quick brown fox jumped over the lazy dog."
    payload_data = payload_str.encode('utf-8')
    pkt = Ether(src='00:00:00:00:00:10', dst='00:00:00:00:00:05') / IP(src='10.2.2.2', dst='10.1.0.1') / UDP(sport=5792, dport=8005) / Raw(payload_data)
    sendp(pkt,  iface="eth1", inter=0.2)