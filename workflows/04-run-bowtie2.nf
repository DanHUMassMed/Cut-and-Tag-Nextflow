#!/usr/bin/env nextflow 

log.info """\
 P A R A M S -- RUN BOWTIE2 
 ===================================
 fastq_paired : ${params.fastq_paired}
 results_dir  : ${params.results_dir}
 """

// import modules
include { BOWTIE2 } from '../modules/bowtie2'

/* 
 * main script flow
 */
workflow RUN_BOWTIE2 {
  read_pairs_ch = channel.fromFilePairs( params.fastq_paired, checkIfExists: true )
  BOWTIE2( read_pairs_ch )
}

/* 
 * completion handler
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! The results can be found in --> ${params.results_dir}/alignment\n" : "Oops .. something went wrong" )
}
