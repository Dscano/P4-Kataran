#define DEFAULT_TTL 64

header ethernet_t {
    bit<48> dst_addr;
    bit<48> src_addr;
    bit<16> ether_type;
}
const bit<16> ETH_HEADER_LEN = 14;

header ipv6_t {
    bit<4>  version;
    bit<8>  traffic_class;
    bit<20> flow_label;
    bit<16> len;
    bit<8>  next_header;
    bit<8>  hop_limit;
    bit<128> src_addr;
    bit<128> dst_addr;
}
const bit<16> IPV6_MIN_HEAD_LEN = 40;

header ipv4_t {
    bit<4>  version;
    bit<4>  ihl;
    bit<8>  tos;
    bit<16> len;
    bit<16> identification;
    bit<3>  flags;
    bit<13> frag_offset;
    bit<8>  ttl;
    bit<8>  protocol;
    bit<16> hdr_checksum;
    bit<32> src_addr;
    bit<32> dst_addr;
}
const bit<16> IPV4_MIN_HEAD_LEN = 20;

header icmp_t {
    bit<8>  type;
    bit<8>  code;
    bit<16> hdr_checksum;
}
const bit<16> ICMP_MIN_HEAD_LEN = 8;

header tcp_t {
    bit<16> src_port;
    bit<16> dst_port;
    bit<32> seq_no;
    bit<32> ack_no;
    bit<4>  data_offset;
    bit<3>  res;
    bit<3>  ecn;
    bit<6>  ctrl;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgent_ptr;
}

header udp_t {
    bit<16> src_port;
    bit<16> dst_port;
    bit<16> length;
    bit<16> checksum;
}
const bit<16> UDP_HEADER_LEN = 8;

struct headers_t {
    ethernet_t ethernet;
    ipv4_t v_ipv4;
    ipv6_t v_ipv6;
    ipv4_t ipv4;
    ipv6_t ipv6;
    icmp_t icmp;
    tcp_t tcp;
    udp_t udp;
}

struct local_metadata_t {
       bool     isIPoIP;
       bool     noHit;
       bit<16>  l4_src_port;
}

struct empty_metadata_t {
}