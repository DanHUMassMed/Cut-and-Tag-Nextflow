
process FASTQC{
    tag "FASTQC on $sample_id"
    label 'process_medium'
    container 'danhumassmed/qc-tools:1.0.2'
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

process GET_DROPBOX_DATA {
    label 'process_low'
    container 'danhumassmed/qc-tools:1.0.2'
    publishDir params.data_dir, mode:'copy'

    input:
        val data_remote 
        val data_local

    output:
        path "${data_local}", emit: data_local_dir

    script:
        """
        mkdir -p "${data_local}"
        get_dropbox_data.sh "${data_remote}" "${data_local}" "${params.rclone_conf}"
        """    
}


process CHECK_MD5 {
    label 'process_low'
    container 'danhumassmed/qc-tools:1.0.2'
    publishDir params.results_dir, mode:'copy'

    input:
        path data_local
    
    output:
        path "md5_report.html"

    script:
        """
        check_md5.py "${data_local}"
        """

}

