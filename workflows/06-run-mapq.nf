#!/usr/bin/env nextflow 

log.info """\
 P A R A M S -- RUN MAPQ
 ===================================
 aligned_bam : ${params.aligned_bam}
 results_dir : ${params.results_dir}
 """

// import modules
include { MAPQ } from '../modules/samtools'

/* 
 * main script flow
 */
workflow RUN_MAPQ {
    aligned_bam = channel.fromPath( params.aligned_bam, checkIfExists: true )
    MAPQ( aligned_bam )
}

/* 
 * completion handler
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! The results can be found in --> ${params.results_dir}/alignment\n" : "Oops .. something went wrong" )
}
