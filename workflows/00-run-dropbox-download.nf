#!/usr/bin/env nextflow 


log.info """\
 P A R A M S -- GET DROPBOX DATA  
 ===================================
 dropbox_data : ${params.dropbox_data}
 data_dir     : ${params.data_dir}
 """

/* 
 * This workflow pulls fastq files from Dropbox and stages them on the HPC for downstream processing
 * If MD5 Files are included in the directories with the fastq files, an MD5 check will be made, and a report will be generated
 */

include { GET_DROPBOX_DATA } from "../modules/fastqc"
include { CHECK_MD5        } from "../modules/fastqc"

workflow RUN_DROPBOX_DOWNLOAD {
  GET_DROPBOX_DATA(params.dropbox_data, "fastq")
  CHECK_MD5(GET_DROPBOX_DATA.out.collect())
}

workflow.onComplete {
	log.info ( workflow.success ? "\nDone! The data is avialable --> ${params.data_dir}\n" : "Oops .. something went wrong" )
}


