process PICARD {
    tag "PICARD on ${input_sam.getName().replace("_bowtie2.sam", "")}"
    label 'process_high'
    container 'danhumassmed/picard-trimmomatic:1.0.1'
    publishDir "${params.results_dir}/picard", mode:'copy'

    input:
    path(input_sam)

    output:
    path "${input_sam.getName().replace("_bowtie2.sam", "")}_picard_sort.bam" 
    path "${input_sam.getName().replace("_bowtie2.sam", "")}_picard_dedup.bam" 

    script:
    def file_nm_prefix = input_sam.getName().replace("_bowtie2.sam", "")
    """
    picard -Xmx4g SortSam \
           INPUT=${input_sam} \
           OUTPUT=${file_nm_prefix}_picard_sort.bam \
           VALIDATION_STRINGENCY=LENIENT \
           TMP_DIR=/tmp \
           SORT_ORDER=coordinate
    picard -Xmx4g MarkDuplicates \
           INPUT=${file_nm_prefix}_picard_sort.bam \
           OUTPUT=${file_nm_prefix}_picard_dedup.bam \
           VALIDATION_STRINGENCY=LENIENT \
           TMP_DIR=/tmp \
           METRICS_FILE=${file_nm_prefix}_dup.txt \
           REMOVE_DUPLICATES=true
    """
}
