#include <core.p4>
#include <psa.p4>

#include "Include/parser.p4"
#include "Include/deparser.p4"


control Ingress(inout headers_t hdr, inout local_metadata_t local_metadata, in psa_ingress_input_metadata_t standard_metadata,
                inout psa_ingress_output_metadata_t ostd) {
        apply {

        }
}

control Egress(inout headers_t hdr, inout local_metadata_t local_metadata, in psa_egress_input_metadata_t istd, 
                inout psa_egress_output_metadata_t ostd) {
        apply {

        }
}


IngressPipeline(Parser(), 
                Ingress(), 
                Deparser()) IngressP;

EgressPipeline(Parser(), 
               Ingress(), 
               Deparser()) EgressP;

PSA_Switch(IngressP, 
           PacketReplicationEngine(),
           EgressP, 
           BufferingQueueingEngine()) main;