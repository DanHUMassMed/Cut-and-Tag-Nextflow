// Map of parameters to workflows for inclusion, and setting variables to null if not included
def workflowIncludes = [
    run_wormbase_download : [include: { include { RUN_WORMBASE_DOWNLOAD } from "./workflows/00-run-wormbase-download" }, notIncluded: { RUN_WORMBASE_DOWNLOAD = null }],
    run_dropbox_download  : [include: { include { RUN_DROPBOX_DOWNLOAD } from "./workflows/00-run-dropbox-download" }, notIncluded: { RUN_DROPBOX_DOWNLOAD = null }],
    run_bowtie2_index     : [include: { include { RUN_BOWTIE2_INDEX } from "./workflows/00-run-bowtie2-index" }, notIncluded: { RUN_BOWTIE2_INDEX = null }],
    run_fastqc            : [include: { include { RUN_FASTQC } from "./workflows/02-run-fastqc" },               notIncluded: { RUN_FASTQC = null }],
    run_trimmomatic       : [include: { include { RUN_TRIMMOMATIC } from "./workflows/03-run-trimmomatic" },     notIncluded: { RUN_TRIMMOMATIC = null }],
    run_bowtie2           : [include: { include { RUN_BOWTIE2 } from "./workflows/04-run-bowtie2" },             notIncluded: { RUN_BOWTIE2 = null }],
    run_picard            : [include: { include { RUN_PICARD } from "./workflows/05-run-picard" },               notIncluded: { RUN_PICARD = null }],
    run_mapq              : [include: { include { RUN_MAPQ } from "./workflows/06-run-mapq" },                   notIncluded: { RUN_MAPQ = null }],
    run_ucsc_file         : [include: { include { RUN_UCSC_FILE } from "./workflows/07-run-ucsc-file" },         notIncluded: { RUN_UCSC_FILE = null }],
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
    runWorkflow(params.run_wormbase_download, "Wormbase Download", RUN_WORMBASE_DOWNLOAD)
    runWorkflow(params.run_dropbox_download, "DropBox Download", RUN_DROPBOX_DOWNLOAD)
    runWorkflow(params.run_bowtie2_index, "Bowtie2 Index", RUN_BOWTIE2_INDEX)
    runWorkflow(params.run_fastqc, "FastQC", RUN_FASTQC)
    runWorkflow(params.run_trimmomatic, "Trimmomatic", RUN_TRIMMOMATIC)
    runWorkflow(params.run_bowtie2, "Bowtie2", RUN_BOWTIE2)
    runWorkflow(params.run_picard, "Picard", RUN_PICARD)
    runWorkflow(params.run_mapq, "MapQ", RUN_MAPQ)
    runWorkflow(params.run_ucsc_file, "UCSC File", RUN_UCSC_FILE)
}