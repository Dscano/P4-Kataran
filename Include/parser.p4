#include "headers.p4"


parser Parser(packet_in packet, out headers_t hdr, inout local_metadata_t local_metadata, 
                        in psa_ingress_parser_input_metadata_t standard_metadata, in empty_metadata_t resub_meta, 
                        in empty_metadata_t recirc_meta) {

    state start {
        transition parse_ethernet;
    }
    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            0x800: parse_ipv4;
            default: accept;
        }
    }
    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition select(hdr.ipv4.protocol) {
            6: parse_tcp;
            17:parse_udp;
            default: accept;
        }
    }
    state parse_tcp {
        packet.extract(hdr.tcp);
        transition accept;
    }

    state parse_udp {
        packet.extract(hdr.udp);
        transition accept;
    }
}
