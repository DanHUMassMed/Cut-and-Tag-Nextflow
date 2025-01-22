process BOWTIE2{
    tag "BOWTIE2 on $sample_id"
    label 'process_high'
    container 'danhumassmed/bowtie-hisat2:1.0.2'
    publishDir "${params.results_dir}/alignment", mode:'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    path "${sample_id}_bowtie2.sam" 

    script:
    """
    bowtie2 -q -N 1 -X 1000 -p ${task.cpus} -x ${params.bowtie2_reference} -1 ${reads[0]} -2 ${reads[1]} -S ${sample_id}_bowtie2.sam
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

process BOWTIE2_INDEX{
    tag "BOWTIE2_INDEX"
    label 'process_high'
    container 'danhumassmed/bowtie-hisat2:1.0.2'
    publishDir "${params.data_dir}/bowtie2_index", mode:'copy'

    input:
    path genome_file
    val wormbase_version

    output:
    path "ce_${wormbase_version}_index*" 

    script:
    """
    bowtie2-build ${genome_file} ce_${wormbase_version}_index
    """
}

