process BOWTIE2{
    tag "BOWTIE2 on $sample_id"
    label 'process_high'
    container 'danhumassmed/bowtie-hisat2:1.0.2'
    publishDir "${params.results_dir}/alignment", mode:'copy'

    input:
    tuple val(sample_id), path(reads)
    val bowtie2_index_files
    path forces_process // For the index process to map the index directory 

    output:
    path "${sample_id}_bowtie2.sam" 

    script:
    """
    bowtie2 ${params.bowtie2_align} -p ${task.cpus} -x ${bowtie2_index_files} -1 ${reads[0]} -2 ${reads[1]} -S ${sample_id}_bowtie2.sam
    """
}

process BOWTIE2_INDEX{
    tag "BOWTIE2_INDEX"
    label 'process_high'
    container 'danhumassmed/bowtie-hisat2:1.0.2'
    publishDir "${params.data_dir}", mode:'copy'

    input:
    path genome_file
    val index_nm

    output:
    path "bowtie2_index" , emit: bowtie2_index_dir
    val "./bowtie2_index/${index_nm}", emit: bowtie2_index_files

    script:
    """
    mkdir -p ./bowtie2_index
    bowtie2-build ${genome_file} bowtie2_index/${index_nm}
    """
}

process GET_WORMBASE_DATA {
    label 'process_low'
    container "danhumassmed/bowtie-hisat2:1.0.2"
    publishDir params.data_dir, mode:'copy'

    input:
    val wormbase_version

    output:
    path "wormbase", emit: wormbase_dir
    path "wormbase/c_elegans.PRJNA13758.${wormbase_version}.canonical_geneset.gtf", emit: annotation_file, optional: true
    path "wormbase/c_elegans.PRJNA13758.${wormbase_version}.genomic.fa", emit: genome_file
    path "wormbase/c_elegans.PRJNA13758.${wormbase_version}.mRNA_transcripts.fa", emit: transcripts_file
    path "wormbase/c_elegans.PRJNA13758.${wormbase_version}.geneIDs.csv", emit: gene_ids

    script:
    """
    mkdir -p wormbase
    cd wormbase
    wormbase_download.sh ${wormbase_version}
    """
}
