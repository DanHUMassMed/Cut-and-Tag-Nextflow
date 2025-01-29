process PICARD {
    tag "PICARD on ${input_sam.getName().replace("_bowtie2.sam", "")}"
    label 'process_high'
    container 'danhumassmed/picard-trimmomatic:1.0.1'
    publishDir "${params.results_dir}/alignment", mode:'copy', pattern: '*.bam'

    input:
    path(input_sam)
    
    output:
    path "${input_sam.getName().replace("_bowtie2.sam", "")}_sort.bam"  ,emit: sort_bam
    path "${input_sam.getName().replace("_bowtie2.sam", "")}_dedup.bam" ,emit: dedup_bam
    path  "versions.yml" , emit: versions

    script:
    def file_nm_prefix = input_sam.getName().replace("_bowtie2.sam", "")
    def tmp_dir = "/tmp/picard_" + WorkflowUtils.generateUUIDs(1)
    """
    mkdir -p "${tmp_dir}-1" "${tmp_dir}-2"
    picard -Xmx4g SortSam \
           INPUT=${input_sam} \
           OUTPUT=${file_nm_prefix}_sort.bam \
           VALIDATION_STRINGENCY=LENIENT \
           TMP_DIR=${tmp_dir}-1 \
           SORT_ORDER=coordinate
    picard -Xmx4g MarkDuplicates \
           INPUT=${file_nm_prefix}_sort.bam \
           OUTPUT=${file_nm_prefix}_dedup.bam \
           VALIDATION_STRINGENCY=LENIENT \
           TMP_DIR=${tmp_dir}-2 \
           METRICS_FILE=${file_nm_prefix}_dup.txt \
           REMOVE_DUPLICATES=true

    cat <<-END_VERSIONS >> versions.yml
    "${task.process}":
        picard: \$(echo \$(picard MarkDuplicates --version 2>&1) | grep -o 'Version:.*' | cut -f2- -d:)
    END_VERSIONS

    """
}
