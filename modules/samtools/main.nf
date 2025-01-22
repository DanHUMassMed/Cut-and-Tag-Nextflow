process MAPQ {
    tag "MAPQ on ${input_sam.getName().replace("_dedup.bam", "")}"
    label 'process_high'
    container 'danhumassmed/samtools-bedtools:1.0.2'
    publishDir "${params.results_dir}/alignment", mode:'copy'

    input:
    path(input_sam)

    output:
    path "${input_sam.getName().replace("_dedup.bam", "")}_dedup_mapq.sam" 
    

    script:
    def file_nm_prefix = input_sam.getName().replace("_dedup.bam", "")
    """
    samtools view -hq 10 ${input_sam} > ${file_nm_prefix}_dedup_mapq.sam
    """
}