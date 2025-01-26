#!/usr/bin/env nextflow 
import nextflow.Nextflow

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
   if(WorkflowUtils.directoryExists("${params.results_dir}/trimmed")){
      fastq_paired = WorkflowUtils.fastqToTrimmedDir(params.fastq_paired)
   } else {
      fastq_paired = params.fastq_paired
   }
   read_pairs_ch = channel.fromFilePairs( fastq_paired, checkIfExists: true )
  
  if(WorkflowUtils.fileExists("${params.bowtie2_index_files}.1.bt2")) {
     Nextflow.log.info("INFO: Bowtie2 Index already created")
     Nextflow.log.info("INFO: params.bowtie2_index_files ${params.bowtie2_index_files}")
     Nextflow.log.info("INFO: fastq_paired ${fastq_paired}")
     BOWTIE2( read_pairs_ch, params.bowtie2_index_files, params.results_dir )
  } else {
     Nextflow.log.info("INFO: Bowtie2 Index needs to be created")
     BOWTIE2_INDEX( params.genome_file, params.bowtie2_index_name)
     BOWTIE2( read_pairs_ch, BOWTIE2_INDEX.out.bowtie2_index_files, BOWTIE2_INDEX.out.bowtie2_index_dir)
  }
}

/* 
 * completion handler
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! The results can be found in --> ${params.results_dir}/alignment\n" : "Oops .. something went wrong" )
}
