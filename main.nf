// Map of parameters to workflows for inclusion, and setting variables to null if not included
def workflowIncludes = [
    run_get_dropbox_data       : [include: { include { GET_EXPERIMENT_DATA } from "./workflows/01-get-dropbox-data" },          notIncluded: { GET_EXPERIMENT_DATA = null }],
    run_get_wormbase_data      : [include: { include { RUN_GET_WORMBASE_DATA } from "./workflows/00-run-get-wormbase-data" },   notIncluded: { RUN_GET_WORMBASE_DATA = null }],
    run_create_star_rsem_index : [include: { include { CREATE_STAR_RSEM_INDEX } from "./workflows/00-create-star-rsem-index" }, notIncluded: { CREATE_STAR_RSEM_INDEX = null }],
    run_create_salmon_index    : [include: { include { CREATE_SALMON_INDEX } from "./workflows/00-create-salmon-index" },       notIncluded: { CREATE_SALMON_INDEX = null }],
    run_fastqc                 : [include: { include { RUN_FASTQC } from "./workflows/02-run-fastqc" },                         notIncluded: { RUN_FASTQC = null }],
    run_trimmomatic            : [include: { include { RUN_TRIMMOMATIC } from "./workflows/03-run-trimmomatic" },               notIncluded: { RUN_TRIMMOMATIC = null }],
    run_trim_galore            : [include: { include { RUN_TRIM_GALORE } from "./workflows/03b-run-trim-galore" },              notIncluded: { RUN_TRIM_GALORE = null }],
    run_bowtie2                : [include: { include { RUN_BOWTIE2 } from "./workflows/04-run-bowtie2" },                       notIncluded: { RUN_BOWTIE2 = null }],
    run_picard                 : [include: { include { RUN_PICARD } from "./workflows/05-run-picard" },                         notIncluded: { RUN_PICARD = null }],
    run_mapq                   : [include: { include { RUN_MAPQ } from "./workflows/06-run-mapq" },                             notIncluded: { RUN_MAPQ = null }],
    run_ucsc_file              : [include: { include { RUN_UCSC_FILE } from "./workflows/07-run-ucsc-file" },                   notIncluded: { RUN_UCSC_FILE = null }],
    run_deseq_rsem_report      : [include: { include { RUN_DESEQ_RSEM_REPORT } from "./workflows/05b-run-deseq-rsem-report" },  notIncluded: { RUN_DESEQ_RSEM_REPORT = null }],
    run_stage_results          : [include: { include { RUN_STAGE_RESULTS } from "./workflows/07-run-stage-results" },           notIncluded: { RUN_STAGE_RESULTS = null }]
]

// Include workflows based on parameters, or set to null if not included
workflowIncludes.each { param, actions ->
    if (params[param]) {
        actions.include()
    } else {
        actions.notIncluded()
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
    runWorkflow(params.run_trimmomatic, "Trimmomatic", RUN_TRIMMOMATIC)
    runWorkflow(params.run_bowtie2, "Bowtie2", RUN_BOWTIE2)
    runWorkflow(params.run_picard, "Picard", RUN_PICARD)
    runWorkflow(params.run_mapq, "MapQ", RUN_MAPQ)
    runWorkflow(params.run_ucsc_file, "UCSC File", RUN_UCSC_FILE)
}