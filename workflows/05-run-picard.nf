#!/usr/bin/env nextflow 

log.info """\
 P A R A M S -- RUN PICARD
 ===================================
 bowtie2_sam : ${params.bowtie2_sam}
 results_dir  : ${params.results_dir}
 """

// import modules
include { PICARD } from '../modules/picard'

/* 
 * main script flow
 */
workflow RUN_PICARD {
    sam_file = channel.fromPath( params.bowtie2_sam, checkIfExists: true )
    PICARD( sam_file )
}

/* 
 * completion handler
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! The results can be found in --> ${params.results_dir}/picard\n" : "Oops .. something went wrong" )
}
