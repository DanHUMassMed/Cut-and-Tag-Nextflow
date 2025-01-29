process MAPQ {
    tag "MAPQ on ${input_sam.getName().replace("_dedup.bam", "")}"
    label 'process_high'
    container 'danhumassmed/samtools-bedtools:1.0.2'
    publishDir "${params.results_dir}/alignment", mode:'copy', pattern: '*.sam'

    input:
    path(input_sam)

    output:
    path "${input_sam.getName().replace("_dedup.bam", "")}_dedup_mapq.sam" , emit: dedup_mapq_sam
    path  "versions.yml" , emit: versions
    

    script:
    def file_nm_prefix = input_sam.getName().replace("_dedup.bam", "")
    """
    samtools view -hq ${params.mapq_quality_score} ${input_sam} > ${file_nm_prefix}_dedup_mapq.sam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
    """
}