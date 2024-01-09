#!/bin/bash

#Assembly 

gunzip *.gz

cat *R1*.fastq > seq_R1.fastq

cat *R2*.fastq > seq_R2.fastq

chmod 755 /.../FastQC/fastqc

/.../FastQC/fastqc -t 1 --nogroup *.fastq

chmod 755 /.../Trimmomatic-0.36/trimmomatic-x.xx.jar

java -jar /.../Trimmomatic-0.38/trimmomatic-x.xx.jar PE -threads 2 -phred33 ./seq_R1.fastq ./seq_R2.fastq seq_PE_1.fq seq_SR_1.fq seq_PE_2.fq seq_SR_2.fq LEADING:20 TRAILING:20 SLIDINGWINDOW:4:25 MINLEN:36

/.../FastQC/fastqc -t 1 --nogroup *.fq

fastx_quality_stats -Q 33 -i seq_PE_1.fq -o seq_PE_1.txt

fastx_quality_stats -Q 33 -i seq_PE_2.fq -o seq_PE_2.txt

cat *.txt | awk '{sum += $2} END {print sum}' > seq.quality_bases.txt

#Prepare the indexes of the reference genome with bowtie2

 bowtie2-build GRCh38.p12.genome.fa fr-unstranded

#tophat/align the transcript against the reference (individually for each sample)

tophat2 -p 8 -G gencode.v28.annotation.gtf -o seqxx_thout fr-unstranded seqxx_PE_1.fq seqxx_PE_2.fq 

#cufflinks:Input accepted.bam (output of tophat(accepted_hits.bam))/output cuff_xx

/.../cufflinks-x.x.x.Linux_xx_xx/cufflinks -p 8 -o cuff_xx accepted_hits_xx.bam 

 python3 /.../cufflinks-x.x.x.Linux_x86_64/cuffmerge -p 6 -g /.../gencode.v28.annotation.gtf -s /.../GRCh38.p12.genome.fa -o merged-asm /.../assemblies.txt 
#cuffdiff[-p threads, -q quiet, -u multi-read-correction, -N upper-quartile-norm is requested, -L two groups are compared labled (-L) C1,C2, -o output]
/.../cufflinks-x.x.x.Linux_xx_xx/cuffdiff -p 6 -q -u -N -o diff_out -b /.../GRCh38.p12.genome.fa -L C1,C2 /.../merged-asm/merged.gtf /.../accepted_hits_xx.bam /.../accepted_hits_xx.bam 











