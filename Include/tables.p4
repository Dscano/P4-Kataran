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
       
    }

    apply {
        table_fwd.apply();
     }
}
