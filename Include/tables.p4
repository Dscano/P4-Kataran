control table_ingress(inout headers_t hdr,
                          inout local_metadata_t local_metadata,
                          in psa_ingress_input_metadata_t standard_metadata,
                          inout psa_ingress_output_metadata_t ostd) {

    action forwarding(PortId_t port) {
        ostd.egress_port = port;
        local_metadata.noHit = true;
    }

    table table_fwd {
        key = {
            hdr.v_ipv6.dst_addr  : ternary;
            hdr.v_ipv4.dst_addr  : ternary;
            hdr.v_ipv4.isValid() : exact;
            hdr.v_ipv6.isValid() : exact;
            local_metadata.isIPoIP : exact;
        }
        actions = {
            forwarding;
            NoAction;
        }
        const default_action = NoAction();
        size = 10;

    }

    apply {
        table_fwd.apply();
     }
}



control table_forward_encap(inout headers_t hdr,
                          inout local_metadata_t local_metadata,
                          in psa_ingress_input_metadata_t standard_metadata,
                          inout psa_ingress_output_metadata_t ostd) {

    ActionSelector(PSA_HashAlgorithm_t.CRC32, 128, 10) as1;
    ActionSelector(PSA_HashAlgorithm_t.CRC32, 128, 10) as2;

    action forwarding_encap_v6(bit<128> ipv6_dst, bit<128> ipv6_src) {
        // The IPV4 fields are filled according to create_v6_hdr function from encap_helpers.h
        hdr.v_ipv6.setValid();
        hdr.ipv6.version = hdr.v_ipv6.version;
        hdr.ipv6.traffic_class = hdr.v_ipv6.traffic_class;
        hdr.ipv6.flow_label = hdr.v_ipv6.flow_label;
        hdr.ipv6.len = hdr.v_ipv6.len + IPV6_MIN_HEAD_LEN;
        hdr.ipv6.next_header = hdr.v_ipv6.next_header;
        hdr.ipv6.hop_limit = DEFAULT_TTL;
        hdr.ipv6.dst_addr = ipv6_dst;
        hdr.ipv6.src_addr = ipv6_src;
    }

    action forwarding_encap_v4(bit<32> ipv4_dst, bit<32> ipv4_src) {
        // The IPV4 fields are filled according to create_v4_hdr function from encap_helpers.h
        hdr.ipv4.setValid();
        hdr.ipv4.version = hdr.v_ipv4.version;
        hdr.ipv4.ihl = 5;
        hdr.ipv4.frag_offset = 0;
        hdr.ipv4.protocol = hdr.v_ipv4.protocol;
        hdr.ipv4.tos = hdr.v_ipv4.tos;
        hdr.ipv4.len = hdr.v_ipv4.len + IPV4_MIN_HEAD_LEN;
        hdr.ipv4.identification = hdr.v_ipv4.identification;
        hdr.ipv4.ttl = DEFAULT_TTL;
        hdr.ipv4.dst_addr = ipv4_dst;
        hdr.ipv4.src_addr = ipv4_src;
    }

    table table_fwd_encap_v4 {
        key = {
           hdr.v_ipv4.isValid():        exact;
           // Fields contained in Katran packet_description data structure
           hdr.ipv4.dst_addr:           selector;
           hdr.ipv4.src_addr:           selector;
           hdr.ipv4.tos     :           selector;
           hdr.ipv4.protocol:           selector;
           local_metadata.l4_src_port:  selector;
        }
        actions = {
            forwarding_encap_v4;
            NoAction;
        }
        psa_implementation = as1;
        const default_action = NoAction();
        size = 10;

    }

    table table_fwd_encap_v6 {
        key = {
           hdr.v_ipv6.isValid():        exact;
           // Fields contained in Katran packet_description data structure
           hdr.ipv6.dst_addr:           selector;
           hdr.ipv6.src_addr:           selector;
           hdr.ipv6.traffic_class:      selector;
           hdr.ipv6.next_header:        selector;
           local_metadata.l4_src_port:  selector;
        }
        actions = {
            forwarding_encap_v6;
            NoAction;
        }
        psa_implementation = as2;
        const default_action = NoAction();
        size = 10;
    }

    apply {
        table_fwd_encap_v4.apply();
        table_fwd_encap_v6.apply();
     }
}