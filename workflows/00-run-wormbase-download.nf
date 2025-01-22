#!/usr/bin/env nextflow 

nextflow.enable.dsl = 2


log.info """\
 P A R A M S -- GET_WORMBASE_DATA
 =====================================
 wormbase_version : ${params.wormbase_version}
 data_dir         : ${params.data_dir}
 """

// import modules
include { GET_WORMBASE_DATA } from '../modules/bowtie2'

/* 
 * main script flow
 */
workflow RUN_WORMBASE_DOWNLOAD {
    GET_WORMBASE_DATA( params.wormbase_version )
}

workflow.onComplete {
	log.info ( workflow.success ? "\nDone! Wormbase data can be found here --> ${params.data_dir}\n" : "Oops .. something went wrong" )
}