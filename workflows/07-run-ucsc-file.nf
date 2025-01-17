#!/usr/bin/env nextflow 

log.info """\
 P A R A M S -- RUN UCSC_FILE
 ===================================
 ucsc_file_input_sam : ${params.ucsc_file_input_sam}
 results_dir  : ${params.results_dir}
 """

// import modules
include { UCSC_FILE } from '../modules/homer'

/* 
 * main script flow
 */
workflow RUN_UCSC_FILE {
    ucsc_file_input_sam = channel.fromPath( params.ucsc_file_input_sam, checkIfExists: true )
    UCSC_FILE( ucsc_file_input_sam )
}

/* 
 * completion handler
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! The results can be found in --> ${params.results_dir}/ucsc_file\n" : "Oops .. something went wrong" )
}
