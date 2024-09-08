 control deparser(packet_out packet, 
                  out empty_metadata_t clone_i2e_meta, 
                  out empty_metadata_t resubmit_meta,
                  out empty_metadata_t normal_meta, 
                  inout headers_t hdr, 
                  in local_metadata_t local_metadata,
                  in psa_ingress_output_metadata_t istd) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.v_ipv4);
        packet.emit(hdr.v_ipv6);
        packet.emit(hdr.ipv4);
        packet.emit(hdr.ipv6);
        packet.emit(hdr.tcp);
        packet.emit(hdr.udp);
    }
}

control deparser_egress(packet_out packet, 
                        out empty_metadata_t clone_e2e_meta, 
                        out empty_metadata_t recirculate_meta, 
                        inout headers_t hdr, 
                        in local_metadata_t local_metadata, 
                        in psa_egress_output_metadata_t istd,
                        in psa_egress_deparser_input_metadata_t edstd) {
    apply {
    }
}