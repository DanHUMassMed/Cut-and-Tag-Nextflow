#!/usr/bin/env nextflow 

log.info """\
 P A R A M S -- RUN TRIMMOMATIC 
 ===================================
 fastq_paired : ${params.fastq_paired}
 results_dir  : ${params.results_dir}
 """

// import modules
include { TRIMMOMATIC           } from '../modules/trimmomatic'
include { TRIMMOMATIC_AGGREGATE } from '../modules/trimmomatic'

/* 
 * main script flow
 */
workflow RUN_TRIMMOMATIC {
  read_pairs_ch = channel.fromFilePairs( params.fastq_paired, checkIfExists: true )
  dir_suffix = channel.fromList(WorkflowUtils.generateUUIDs(50))
  TRIMMOMATIC( read_pairs_ch, "fastq", dir_suffix )
  TRIMMOMATIC_AGGREGATE(TRIMMOMATIC.out.collect() )
}

/* 
 * completion handler
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! The results can be found in --> ${params.results_dir}/trimmed\n" : "Oops .. something went wrong" )
}
