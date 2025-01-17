process BOWTIE2{
    tag "BOWTIE2 on $sample_id"
    label 'process_high'
    container 'danhumassmed/bowtie-tophat:1.0.1'
    publishDir "${params.results_dir}/bowtie2", mode:'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    path "${sample_id}_bowtie2.sam" 

    script:
    """
    bowtie2 -q -N 1 -X 1000 -p ${task.cpus} -x ${params.bowtie2_reference} -1 ${reads[0]} -2 ${reads[1]} -S ${sample_id}_bowtie2.sam
    """
}
