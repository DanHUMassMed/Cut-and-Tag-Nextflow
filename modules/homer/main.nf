process UCSC_FILE {
    tag "UCSC_FILE on ${input_sam.getName().replace("_dedup_mapq.sam", "")}"
    label 'process_high'
    container 'danhumassmed/de-seq-tools:1.0.1'
    publishDir "${params.results_dir}/ucsc_file", mode:'copy'

    input:
    path(input_sam)

    output:
    path "${input_sam.getName().replace("_dedup_mapq.sam", "")}" 
    

    script:
    def file_nm_prefix = input_sam.getName().replace("_dedup_mapq.sam", "")
    """
    /usr/local/homer/bin/makeTagDirectory ${file_nm_prefix}/ ${input_sam}
    /usr/local/homer/bin/makeUCSCfile ${file_nm_prefix}/ -o auto
    """
}