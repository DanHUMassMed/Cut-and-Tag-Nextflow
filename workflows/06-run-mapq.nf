#!/usr/bin/env nextflow 

log.info """\
 P A R A M S -- RUN MAPQ
 ===================================
 picard_dedup_bam : ${params.picard_dedup_bam}
 results_dir  : ${params.results_dir}
 """

// import modules
include { MAPQ } from '../modules/samtools'

/* 
 * main script flow
 */
workflow RUN_MAPQ {
    picard_dedup_bam = channel.fromPath( params.picard_dedup_bam, checkIfExists: true )
    MAPQ( picard_dedup_bam )
}

/* 
 * completion handler
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! The results can be found in --> ${params.results_dir}/mapq\n" : "Oops .. something went wrong" )
}
