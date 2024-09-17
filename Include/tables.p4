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

    //ActionSelector(PSA_HashAlgorithm_t.CRC32, 128, 10) as1;
    //ActionSelector(PSA_HashAlgorithm_t.CRC32, 128, 10) as2;

    action forwarding_encap_v6(bit<128> ipv6_dst) {
        hdr.v_ipv6.setValid();
        hdr.v_ipv6.dst_addr = ipv6_dst;
        //to be filled
    }

    action forwarding_encap_v4(bit<32> ipv4_dst) {

        hdr.ipv4.setValid();
        hdr.ipv4.dst_addr = ipv4_dst;
        //to be filled
    }

    table table_fwd_encap_v4 {
        key = {
           //hash
           hdr.v_ipv4.isValid(): exact;
           hdr.ipv4.dst_addr: exact; //selector;
        }
        actions = {
            forwarding_encap_v4;
            NoAction;
        }
        //psa_implementation = as1;
        const default_action = NoAction();
        size = 10;
       
    }

    table table_fwd_encap_v6 {
        key = {
           //hash
           hdr.v_ipv6.isValid(): exact;
           hdr.ipv6.dst_addr: exact;//selector;
        }
        actions = {
            forwarding_encap_v6;
            NoAction;
        }
        //psa_implementation = as2;
        const default_action = NoAction();
        size = 10;
       
    }

    apply {
        table_fwd_encap_v4.apply();
        table_fwd_encap_v6.apply();
     }
}