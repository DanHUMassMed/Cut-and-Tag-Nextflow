
process FASTQC{
    tag "FASTQC on $sample_id"
    label 'process_medium'
    container 'danhumassmed/qc-tools:1.0.1'
    publishDir "${params.results_dir}/quality_reports", mode:'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    path "${sample_id}_logs" 

    script:
    """
    mkdir -p ${sample_id}_logs
    fastqc -o ${sample_id}_logs -f fastq -q ${reads}
    """
}

