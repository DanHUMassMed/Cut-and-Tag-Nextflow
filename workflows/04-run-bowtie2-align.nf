#!/usr/bin/env nextflow 


log.info """\
 P A R A M S -- RUN BOWTIE2 ALIGN
 ===================================
 fastq_paired : ${params.fastq_paired}
 results_dir  : ${params.results_dir}
 """

// import modules
include { BOWTIE2       } from '../modules/bowtie2'
include { BOWTIE2_INDEX } from '../modules/bowtie2'

/* 
 * main script flow
 */
workflow RUN_BOWTIE2_ALIGN {
   fastq_paired = params.fastq_paired
   if(WorkflowUtils.directoryExists("${params.results_dir}/trimmed") ) {
      log.info("INFO: Trimmed dir exists")
      fastq_paired = WorkflowUtils.fastqToTrimmedDir(params.fastq_paired)
   }

   log.info("INFO: fastq_paired= ${fastq_paired}")
   read_pairs_ch = channel.fromFilePairs( fastq_paired, checkIfExists: true )
  
   log.info("INFO: params.bowtie2_index_files= ${params.bowtie2_index_files}")

  if(WorkflowUtils.fileExists("${params.bowtie2_index_files}.1.bt2")) {
     log.info("INFO: Bowtie2 Index already created")
     BOWTIE2( read_pairs_ch, params.bowtie2_index_name, params.bowtie2_index_dir )
  } else {
     log.info("INFO: Bowtie2 Index needs to be created")
     BOWTIE2_INDEX( params.genome_file, params.bowtie2_index_name)
     BOWTIE2( read_pairs_ch, params.bowtie2_index_name, BOWTIE2_INDEX.out.bowtie2_index_dir)
  }
}

/* 
 * completion handler
 */

workflow.onComplete {
	log.info ( workflow.success ? "\nDone! The results can be found in --> ${params.results_dir}/alignment\n" : "Oops .. something went wrong" )
}
