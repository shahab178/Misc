#!/bin/bash
# index reference transcriptome (cDNA)

/home/shahab/Downloads/software/salmon-latest_linux_x86_64/bin/salmon index -t Homo_sapiens.GRCh38.cdna.all.fa -i trans_index_1 

#Quantify TPM

/home/shahab/Downloads/software/salmon-latest_linux_x86_64/bin/salmon quant --validateMappings -p 4 -i /.../trans_index_all -l A -1 ./seq_PE_1.fq -2 ./seq_PE_2.fq -o transcripts_xx_quant --seqBias --numBootstraps 100


