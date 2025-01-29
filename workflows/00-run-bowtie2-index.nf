#!/usr/bin/env nextflow 

nextflow.enable.dsl = 2


log.info """\
 P A R A M S -- BOWTIE2 INDEX
 ============================================
 wormbase_version : ${params.wormbase_version}
 data_dir         : ${params.data_dir}
 """

// import modules
include { GET_WORMBASE_DATA } from '../modules/bowtie2'
include { BOWTIE2_INDEX     } from '../modules/bowtie2'


/* 
 * main script flow
 */
workflow RUN_BOWTIE2_INDEX {
  if(WorkflowUtils.fileExists("${params.genome_file}")){
    log.info("INFO: Genome File already downloaded")
    BOWTIE2_INDEX( params.genome_file, params.bowtie2_index_name)
  }else{
    GET_WORMBASE_DATA( params.wormbase_version )
    BOWTIE2_INDEX( GET_WORMBASE_DATA.out.genome_file, params.bowtie2_index_name)
  }

}

workflow.onComplete {
	log.info ( workflow.success ? "\nDone! Index files can be found here --> ${params.data_dir}\n" : "Oops .. something went wrong" )
}