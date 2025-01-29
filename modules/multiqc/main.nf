
process MULTIQC {
    label 'process_medium'
    container 'danhumassmed/qc-tools:1.0.2'
    publishDir "${params.results_dir}/quality_reports", mode:'copy', pattern: '*.html'

    input:
    val report_nm
    path('*')

    output:
    path(report_nm)      , emit: multiqc_report_nm
    path  "versions.yml" , emit: versions
    

    script:
    """
    multiqc . --filename ${report_nm}

    cat <<-END_VERSIONS >> versions.yml
    "${task.process}":
        multiqc: \$( multiqc --version | sed -e 's/multiqc, version //g' )
    END_VERSIONS
    """
}
