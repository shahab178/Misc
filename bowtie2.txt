#!/usr/bin/env bash

#index
 bowtie-build ./Homo_sapiens.GRCh38.dna.primary_assembly.fa bt2_base
# aligning
 bowtie2 -p 6 -x /.../bowtie2/bt2_base -1 /.../seq_PE_1.fq -2 /.../seq_PE_2.fq -S /.../bowtie2/xx.sam

 samtools sort -o xx.sorted.bam -O bam xx.sam

 java -jar /.../picard.jar MarkDuplicates INPUT=xx.sorted.bam OUTPUT=xx.map.markdup.bam METRICS_FILE=$SAMPLE.map.markdup.metrics AS=TRUE VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 REMOVE_DUPLICATES=TRUE
 
htseq-count -r pos -t CDS -f bam xx.map.markdup.bam /.../bowtie2/Homo_sapiens.GRCh38.101.gtf > xx.count