#!/usr/bin/env nextflow 

log.info """\
 P A R A M S -- RUN TRIMMOMATIC 
 ===================================
 fastq_paired : ${params.fastq_paired}
 data_dir     : ${params.data_dir}
 results_dir  : ${params.results_dir}
 """

// import modules
include { TRIMMOMATIC            } from '../modules/trimmomatic'
include { TRIMMOMATIC_AGGREGATE  } from '../modules/trimmomatic'
include { FASTQC                 } from '../modules/fastqc'
include { MULTIQC                } from '../modules/multiqc'

params.multiqc_report_nm = "multiqc_post_trim_report.html"

/* 
 * main script flow
 */

workflow RUN_TRIMMOMATIC {
  read_pairs_ch = channel.fromFilePairs( params.fastq_paired, checkIfExists: true )

  numberOfFiles = WorkflowUtils.fileCount("${params.data_dir}/fastq")
  dir_suffix = channel.fromList(WorkflowUtils.generateUUIDs(numberOfFiles))
  TRIMMOMATIC( read_pairs_ch, "fastq", dir_suffix )
  TRIMMOMATIC_AGGREGATE( TRIMMOMATIC.out.trimmed_path.collect() )
  if(params.include_post_trim_fastqc) {
    // Reformat the output of TRIMMOMATIC.out.trimmed_reads so it look like what FASTQC expects
    def formatted_reads_ch = TRIMMOMATIC.out.trimmed_reads.map { sample_name, read1, read2 ->
        return [sample_name, [read1, read2]]
    }
    FASTQC( "Trim_", formatted_reads_ch )
    MULTIQC( params.multiqc_report_nm, FASTQC.out.collect() )
  }
  
}

/* 
 * completion handler
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! The results can be found in --> ${params.results_dir}/trimmed\n" : "Oops .. something went wrong" )
}
