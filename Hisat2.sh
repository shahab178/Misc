#!/bin/bash


#index hisat2

/.../hisatx-x.x.x/hisat2-build -f Homo_sapiens.GRCh38.dna.fasta ht2_base_index


#

hisat2-build cd19.fasta index_seq

#

hisat2_extract_splice_sites.py Homo_sapiens.GRCh38.96.gtf > Homo_splice_sites.txt

#

hisat2 -p 4 -x -1 seq_PE_1.fq -2 seq_PE_2.fq index_seq -S seq.sam 

#
 hisat2 -x index_seq -p 10 -1 seq_PE_1.fq -2 seq_PE_2.fq --known-splicesite-infile  Homo_splice_sites.txt  -S seq.sam
#

samtools view -bS seq.sam > seq.bam

#

hisat2 -p 4 -x /.../Hisat2/grch38/genome -1 seq_PE_1.fq -2 seq_PE_2.fq -S seq.sam
