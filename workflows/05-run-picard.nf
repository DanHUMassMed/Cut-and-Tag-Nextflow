#!/usr/bin/env nextflow 

log.info """\
 P A R A M S -- RUN PICARD
 ===================================
 aligned_sam : ${params.aligned_sam}
 results_dir : ${params.results_dir}
 """

// import modules
include { PICARD } from '../modules/picard'

/* 
 * main script flow
 */
workflow RUN_PICARD {
    sam_file = channel.fromPath( params.aligned_sam, checkIfExists: true )
    PICARD( sam_file )
}

/* 
 * completion handler
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! The results can be found in --> ${params.results_dir}/alignment\n" : "Oops .. something went wrong" )
}
