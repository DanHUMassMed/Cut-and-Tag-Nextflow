* **run_dropbox_download** - Run Dropbox download, stages data from a provided Dropbox location onto the HPC for pipeline execution. And validates any MD5.txt files
    * Required parameters 
        * `dropbox_data` : The location of the data on Dropbox (in an rclone compatible format)
        * `rclone_conf`  : The location of the `.rclone.conf` file with credentials to Dropbox (e.g., "/user_home/.rclone.conf")
             * NOTE: .rclone_conf requires the following [remote] type = dropbox token = ********
    * Non-changable parameters
        * `destination_dir` : The Dropbox data will be downloaded to *"${launchDir}/data/fastq"*
        * `file_types`      : The process will only download files with the extensions ending in *fastq.gz* or *fq.gz* 
        * `extent of copy`  : The process will download all fastq files in the top level and all sub directories
        * `md5 checksum`    : The process will search for and validate md5 files in the nonogene format (e.g, da329e3467fca1b77f6fca08e5a51dd4  arf1-13_1.fq.gz)
        * `md5_report.html` : The Checksum report will output to *"${launchDir}/results"*

* **run_wormbase_download** - Run Wormbase Download, stages files from *Wormbase.org* to be used for genome alignment indexing.
    * Required parameters
        * `wormbase_version` : The version of the Wormbase genomic data to extract (e.g., "WS245") 
    * Non-changable parameters
        * `destination_dir`  : The Wormbase data will be downloaded to "${launchDir}/data/wormbase"

* **run_bowtie2_index** - Run process to create a Bowtie2 index based on the provided genome
    * Required parameters
        * `genome_file`      : Location of the fatsa file for indexing (e.g., genomic.fa)
        * `wormbase_version` : The name of the Wormbase Version to map the index too. 
            * Note: wormbase_version is only required if the index is for C. elegans genome
    * Non-changable parameters
        * `destination_dir`  : The bowtie2 index file will be created in this directory *"${launchDir}/data/bowtie2_index"*

*  **run_pre_trim_fastqc** - Run FastQC and MultiQC on the Original downloaded data
    * Required parameters
        * `fastq_paired`    : The mapping to the fastq files to be processed (e.g., *"${launchDir}/data/fastq/*_R{1,2}_001.fastq.gz"* )
        * `fastq_single`    : NOT IMPLEMENTED
    * Non-changable parameters
        * `destination_dir` : The report data will be place in this directory *"${launchDir}/results/quality_reports"*

* **run_trimmomatic** - Run the trimmomatic process for adapter and quality trimming of input data
    * Required parameters
        * `fastq_paired`    : The mapping to the fastq files to be processed (e.g., *"${launchDir}/data/fastq/*_R{1,2}_001.
        * `trimmomatic_control` : The options to be passed to the trimomatic program 
            * Note: Example control *'"ILLUMINACLIP:./adapters/NexteraPE-PE.fa:2:25:7:1:true TRAILING:3 SLIDINGWINDOW:4:10 TRAILING:3 MINLEN:10"'*
            * Note: standard adapters can be mapped with ./adapter/NAME.fa NAME.fa = (NexteraPE-PE.fa, TruSeq2-PE.fa, TruSeq2-SE.fa, TruSeq3-PE-2.fa, TruSeq3-PE.fa, TruSeq3-SE.fa)
    * Non-changable parameters
        * `destination_dir`     : The trimmed data will be place in this directory *"${launchDir}/results/trimmed"*

* **run_bowtie2_align** - Run the Bowtie2 Alignment process
    * Required parameters
        * `fastq_paired`        : The mapping to the fastq files to be processed (e.g., *"${launchDir}/data/fastq/*_R{1,2}_001.
            * Note: If trimmed results are found in the results directory they we be used over the files in the data directory
        * `bowtie2_align`       : Parameters for the bowtie2 process (e.g.,'"-q -N 1 -X 1000"')
        * `bowtie2_index_name`  : The prefix name used for the index files (e.g., "ce_${wormbase_version}_index" )
        * `bowtie2_index_files` : The bowtie2 index directory and bowtie2_index_name 
            * Note: Example bowtie2_index_files "${data_dir}/bowtie2_index/${bowtie2_index_name}"
    * Non-changable parameters
        * `destination_dir`     : The alignment sam files will be place in this directory *"${launchDir}/results/alignment"*
        * `file name convention`: The output file naming convension is <FASTQ_PREFIX>_bowtie2.sam

* **run_picard** - Run Dedup process with Picard
    * Required parameters
        * `aligned_sam`     : The alignment files from the bowtie2 alignment process are used as input
    * Non-changable parameters
        * `destination_dir` : The alignment bam files will be place in this directory *"${launchDir}/results/alignment"*
        * `file name convention`: The output file naming convension is <FASTQ_PREFIX>_sorted.bam and <FASTQ_PREFIX>_dedup.bam

* **run_mapq** - Run process to filter out low quality reads with `samtools`
    * Required parameters
        * `aligned_bam`  : The deduped alignment files used as input
        * `mapq_quality_score` : The quaity score that is to be matched or exceeded to pass the filter
    * Non-changable parameters
        * `destination_dir`     : The alignment sam files will be place in this directory *"${launchDir}/results/alignment"*
        * `file name convention`: The output file naming convension is <FASTQ_PREFIX>_dedup_mapq.sam

* **run_ucsc_file** - Run process to generate files for IVG
    * Required parameters
        * `ucsc_file_input_sam` : The deduped and quality filtered alignment files used as input
        * `mapq_quality_score`  : The quaity score that is to be matched or exceeded to pass the filter
    * Non-changable parameters
        * `destination_dir`     : The IVG files will be place in this directory *"${launchDir}/results/ucsc_file"*
        * `file name convention`: The output file naming convension is <FASTQ_PREFIX>_dedup_mapq.sam
