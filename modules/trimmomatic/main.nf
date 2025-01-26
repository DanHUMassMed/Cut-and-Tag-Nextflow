
//http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf

/**********************************
Phred+33 Scores

Quality | Prob.       | Accuracy
 Score  | Score is    |    of 
        | Incorrect   | Base Call
====================================
   10   | 1 in 10     | 90%
   20   | 1 in 100    | 99%
   30   | 1 in 1,000  | 99.90%
   40   | 1 in 10,000 | 99.99%
*************************************/

process TRIMMOMATIC {
    label 'process_medium'
    tag "TRIMMOMATIC on $sample_id"
    container "danhumassmed/picard-trimmomatic:1.0.2"

    input:
    tuple val(sample_id), path(reads)
    val data_root
    val dir_suffix

    output:
    path "trim_${dir_suffix}", emit: trimmed_path
    tuple val("${sample_id}"), path("trim_${dir_suffix}/T_${reads[0]}"), path("trim_${dir_suffix}/T_${reads[1]}"), emit: trimmed_reads


    script:
    """
    mkdir -p ./adapters
    cp -r /opt/conda/pkgs/trimmomatic-0.39-hdfd78af_2/share/trimmomatic-0.39-2/adapters .
    trimmomatic.sh ${reads[0]} ${reads[1]} ${data_root} ${dir_suffix} ${params.trimmomatic_control}
    """
}


process TRIMMOMATIC_AGGREGATE {
    label 'process_low'
    container "danhumassmed/picard-trimmomatic:1.0.2"
    publishDir params.results_dir, mode:'copy'

    input:
    path('*')

    output:
    path "trimmed" ,emit: trimmed_path

    script:
    """
    trimmomatic_aggregate.sh
    """
}

