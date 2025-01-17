#!/usr/bin/env nextflow 

log.info """\
 P A R A M S -- RUN FASTQC
 ===================================
 fastq_paired : ${params.fastq_paired}
 results_dir  : ${params.results_dir}
 """

// import modules
include { FASTQC  } from '../modules/fastqc'
include { MULTIQC } from '../modules/multiqc'

/* 
 * Run FastQC on each of the Fastq file
 * Run MultiQC to aggregate all the individual FastQC Reports
 */

workflow RUN_FASTQC{
  read_pairs_ch = channel.fromFilePairs( params.fastq_paired, checkIfExists: true )
  report_nm = channel.value(params.multiqc_report_nm)
  FASTQC(read_pairs_ch)
  MULTIQC(report_nm, FASTQC.out.collect()  )

}

workflow.onComplete {
	log.info ( workflow.success ? "\nDone! Open the following report in your browser --> ${params.results_dir}/quality_reports/multiqc_report.html\n" : "Oops .. something went wrong" )
}
