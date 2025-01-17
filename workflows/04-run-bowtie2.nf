#!/usr/bin/env nextflow 

log.info """\
 P A R A M S -- RUN BOWTIE2 
 ===================================
 fastq_paired : ${params.fastq_paired}
 fastq_single : ${params.fastq_single}
 data_for     : ${params.data_for}
 results_dir  : ${params.results_dir}
 """

// import modules
include { BOWTIE2 } from '../modules/bowtie2'

/* 
 * main script flow
 */
workflow RUN_BOWTIE2 {
  if(params.fastq_paired) {
    read_pairs_ch = channel.fromFilePairs( params.fastq_paired, checkIfExists: true )
    BOWTIE2( read_pairs_ch )
  }

  if(params.fastq_single)  {
    read_ch = channel.fromPath( params.fastq_single, checkIfExists: true ) 
    //BOWTIE2_SINGLE(read_ch, "fastq", dir_suffix )
  }

}

/* 
 * completion handler
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! The results can be found in --> ${params.results_dir}/bowtie2\n" : "Oops .. something went wrong" )
}
