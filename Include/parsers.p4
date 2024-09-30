#include "headers.p4"


parser parser_ingress(packet_in packet, 
                      out headers_t hdr, 
                      inout local_metadata_t local_metadata, 
                      in psa_ingress_parser_input_metadata_t standard_metadata, 
                      in empty_metadata_t resub_meta, 
                      in empty_metadata_t recirc_meta) {

    state start {
        transition parse_ethernet;
    }

    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.ether_type) {
            0x800:  parse_v_ipv4;
            0x86dd: parse_v_ipv6;
            default: accept;
        }
    }
    // Virtual IP address
    state parse_v_ipv4 {
        packet.extract(hdr.v_ipv4);
        transition select(hdr.v_ipv4.protocol) {
            0x01: parse_icmp;
            0x04: parse_ipv4;
            0x06: parse_tcp;
            0x11: parse_udp;
            default: accept;
        }
    }
    // Virtual IP address
    state parse_v_ipv6 {
        packet.extract(hdr.v_ipv6);
        transition select(hdr.v_ipv6.next_header) {
            0x04: parse_ipv6;
            0x06: parse_tcp;
            0x11: parse_udp;
            0x3a: parse_icmp;
            default: accept;
        }
    }
    // Service IP address
    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        local_metadata.isIPoIP = true;
        transition select(hdr.ipv4.protocol) {
            0x01: parse_icmp;
            0x06: parse_tcp;
            0x11: parse_udp;
            default: accept;
        }
    }
    // Service IP address
    state parse_ipv6 {
        packet.extract(hdr.ipv6);
        local_metadata.isIPoIP = true;
        transition select(hdr.ipv6.next_header) {
            0x3a: parse_icmp;
            0x06: parse_tcp;
            //0x11: parse_udp;
            default: accept;
        }
    }

     state parse_icmp {
        packet.extract(hdr.icmp);
        transition accept;
    }

    state parse_tcp {
        packet.extract(hdr.tcp);
        transition accept;
    }

    /*state parse_udp {
        packet.extract(hdr.udp);
        transition accept;
    }*/
}


parser parser_egress(packet_in packet, 
                    out headers_t hdr, 
                    inout local_metadata_t local_metadata,
                    in psa_egress_parser_input_metadata_t istd, 
                    in empty_metadata_t normal_meta, 
                    in empty_metadata_t clone_i2e_meta, 
                    in empty_metadata_t clone_e2e_meta) {
    state start {
        transition accept;
    }
}