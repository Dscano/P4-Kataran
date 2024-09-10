#include <core.p4>
#include <psa.p4>

#include "Include/parsers.p4"
#include "Include/deparsers.p4"
#include "Include/tables.p4"


control ingress(inout headers_t hdr, inout local_metadata_t local_metadata, in psa_ingress_input_metadata_t standard_metadata,
                inout psa_ingress_output_metadata_t ostd) {
   
        Hash<bit<32>>(PSA_HashAlgorithm_t.CRC32) h;

        apply {
           if (local_metadata.isIPoIP){
        
                //For an incoming packet toward a VIP - katran is checking if it saw packet from the same 
                //session before, and if it has - it sends the packet to the same real 
                //(actual server/l7 lb which then processes/terminates the TCP session).
                table_ingress.apply(hdr,local_metadata, standard_metadata,ostd);

                //Outer packet destination not matched 
                if(!local_metadata.noHit){
                
                //If it's a new session - from 5 tuples in the packet, calculate a hash value.
                        if(hdr.v_ipv4.isValid()){
                              h.get_hash({hdr.v_ipv4.dst_addr,hdr.v_ipv4.src_addr});
                        }

                        else{
                              h.get_hash({hdr.v_ipv6.dst_addr,hdr.v_ipv6.src_addr});
                        }
                }
           }
           else{
        
                table_ingress.apply(hdr,local_metadata, standard_metadata,ostd);
           }
        }
}

control egress(inout headers_t hdr, inout local_metadata_t local_metadata, in psa_egress_input_metadata_t istd, 
               inout psa_egress_output_metadata_t ostd) {
        apply {}
}

IngressPipeline(parser_ingress(), 
                ingress(), 
                deparser()) IngressP;

EgressPipeline(parser_egress(), 
               egress(), 
               deparser_egress()) EgressP;

PSA_Switch(IngressP, 
           PacketReplicationEngine(),
           EgressP, 
           BufferingQueueingEngine()) main;