process BOWTIE2{
    tag "BOWTIE2 on $sample_id"
    label 'process_high'
    container 'danhumassmed/bowtie-hisat2:1.0.2'
    publishDir "${params.results_dir}/alignment", mode:'copy', pattern: '*_bowtie2.sam'

    input:
    tuple val(sample_id), path(reads)
    val bowtie2_index_name
    path bowtie2_index_dir // For the BOWTIE2_INDEX process to symlink the index directory here 

    output:
    path "${sample_id}_bowtie2.sam" , emit: bowtie2_sam
    path  "versions.yml"            , emit: versions

    script:
    """
    bowtie2 ${params.bowtie2_align} -p ${task.cpus} -x ${bowtie2_index_dir}/${bowtie2_index_name} -1 ${reads[0]} -2 ${reads[1]} -S ${sample_id}_bowtie2.sam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bowtie2: \$(echo \$(bowtie2 --version 2>&1) | sed 's/^.*bowtie2-align-s version //; s/ .*\$//')
    END_VERSIONS

    """
}

process BOWTIE2_INDEX{
    tag "BOWTIE2_INDEX"
    label 'process_high'
    container 'danhumassmed/bowtie-hisat2:1.0.2'
    publishDir "${params.data_dir}", mode:'copy', pattern: 'bowtie2_index'

    input:
    path genome_file
    val bowtie2_index_name

    output:
    path "bowtie2_index" , emit: bowtie2_index_dir
    path "versions.yml"  , emit: versions

    script:
    """
    mkdir -p ./bowtie2_index
    bowtie2-build ${genome_file} bowtie2_index/${bowtie2_index_name}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bowtie2: \$(echo \$(bowtie2 --version 2>&1) | sed 's/^.*bowtie2-align-s version //; s/ .*\$//')
    END_VERSIONS
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
