// Map of parameters to workflows for inclusion
def workflowIncludes = [
    run_get_dropbox_data       : { include { GET_EXPERIMENT_DATA } from "./workflows/01-get-dropbox-data" },
    run_get_wormbase_data      : { include { RUN_GET_WORMBASE_DATA } from "./workflows/00-run-get-wormbase-data" },
    run_create_star_rsem_index : { include { CREATE_STAR_RSEM_INDEX } from "./workflows/00-create-star-rsem-index" },
    run_create_salmon_index    : { include { CREATE_SALMON_INDEX } from "./workflows/00-create-salmon-index" },
    run_fastqc                 : { include { RUN_FASTQC } from "./workflows/02-run-fastqc" },
    run_find_lib_type          : { include { RUN_FIND_LIB_TYPE } from "./workflows/02b-run-find-lib-type" },
    run_trimmomatic            : { include { RUN_TRIMMOMATIC } from "./workflows/03-run-trimmomatic" },
    run_trim_galore            : { include { RUN_TRIM_GALORE } from "./workflows/03b-run-trim-galore" },
    run_rnaseq_rsem            : { include { RUN_RNASEQ_RSEM } from "./workflows/04-run-rnaseq-rsem" },
    run_rnaseq_salmon          : { include { RUN_RNASEQ_SALMON } from "./workflows/04-run-rnaseq-salmon" },
    run_deseq_rsem             : { include { RUN_DESEQ_RSEM } from "./workflows/05a-run-deseq-rsem" },
    run_deseq_rsem_report      : { include { RUN_DESEQ_RSEM_REPORT } from "./workflows/05b-run-deseq-rsem-report" },
    run_wormcat                : { include { RUN_WORMCAT } from "./workflows/06-run-wormcat" },
    run_stage_results          : { include { RUN_STAGE_RESULTS } from "./workflows/07-run-stage-results" }
]

// Include workflows based on parameters
workflowIncludes.each { param, includeAction ->
    if (params[param]) {
        includeAction()
    }
}


// Helper function to log and run workflows
def runWorkflow(condition, workflowName, workflowAction) {
    if (condition) {
        log.info("Running ${workflowName}")
        workflowAction.run()
    }
}

// Initialize the workflow
WorkflowUtils.initialize(params, log)

// Run workflows based on parameters
workflow {
    runWorkflow(params.run_fastqc, "FastQC", RUN_FASTQC)
}