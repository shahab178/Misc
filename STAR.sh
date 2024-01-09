#e.g.1
STAR --genomeDir ${REF_DIR}/Sequence/STAR \
--readFilesIn ${FASTQ} \
--readFilesCommand zcat \
--outFileNamePrefix STAR/${OUT}_ \
--outFilterMultimapNmax 1 \
--outSAMtype BAM SortedByCoordinate \
--runThreadN 4 \
--alignIntronMin 1 \
--alignIntronMax 2500 \
--sjdbGTFfile ${REF_DIR}/Annotation/Genes/sacCer3.gtf \
--sjdbOverhang 49

#e.g.2
STAR --runThreadN 3 \
--genomeDir /groups/hbctraining/intro_rnaseq_hpc/reference_STAR \
--readFilesIn raw_data/Mov10_oe_1.subset.fq \
--outFileNamePrefix results/STAR/Mov10_oe_1_ \
--outSAMtype BAM SortedByCoordinate \
--quantMode GeneCounts \
--sjdbGTFfile $GTFFILE \
--outReadsUnmapped Fastx \
--outSAMunmapped Within \
--outSAMattributes NH HI NM MD AS

### Options

-runThreadN: number of threads
--readFilesIn: /path/to/FASTQ_file
--genomeDir: /path/to/genome_indices directory
--readFilesCommand : if reads are compressed or not

###optional
--outFileNamePrefix: prefix for all output files(e.g. A549_0_1)
--outSAMtype: output filetype (SAM default)
--outSAMUnmapped: what to do with unmapped reads
--outSAMattributes: SAM attributes
--quantMode : STAR will count the number of reads per gene while mapping (This option requires annotations (GTF or GFF with –sjdbGTFfile option) used at the genome generation step, or at the mapping step)


##
STAR --runThreadN 23 --runMode genomeGenerate --genomeDir ./star-genome --genomeFastaFiles ./GRCh38.primary_assembly.genome.fa --sjdbGTFfile ./Homo_sapiens.GRCh38.101.gtf


##server
STAR --runThreadN 30 --genomeDir /.../STAR/star-genome/ --readFilesIn /.../F20/seq_PE_1.fq /.../F20/seq_PE_2.fq --outFileNamePrefix ./star/out --outSAMtype BAM SortedByCoordinate -- quantMode GeneCounts --sjdbGTFfile /.../STAR/Homo_sapiens.GRCh38.101.gtf --outReadsUnmapped ./Fastx 

