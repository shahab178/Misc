# Transcriptome analysis second pipeline/StringTie
#1.Install HISAT2with conda install -c bioconda hisat2
#2.Index reference genome with hisat2
hisat2-build GRCh38.p12.genome.fa index_name
#3.Alingment with hista against reference genome 
perl /.../hisat2-x.x.x/hisat2 -p 8 --dta -x index_name -1 /.../seqxx_PE_1.fq -2 /.../seqxx_PE_2.fq -S seqxx.sam
#4.convert SAM to BAM with samtools
samtools view -bS seqxx.sam > seqxx_unsorted.bam

samtools sort -@ 8 seqxx_unsorted.bam seqxx

#5.Transcriptome Assembley with StringTie

/.../stringtie-x.x.xd.Linux_x86_64/stringtie -p 8 -G Homo_sapiens.GRCh38.93.gtf -o seqxx.gtf -l seqxx seqxx.bam


/.../stringtie-x.x.xd.Linux_x86_64/stringtie -p 8 -G Homo_sapiens.GRCh38.93.gtf -o seqxx.gtf -l seqxx seqxx.bam


#6. Merge all the samples togather  ( make a txt file ./seq15.gtf ./seq57.gtf)
/.../stringtie-x.x.xd.Linux_x86_64/stringtie --merge -p 8 -G Homo_sapiens.GRCh38.93.gtf -o stringtie_merged.gtf mergelist.txt 

#7.Estimate transcript abundances and creat table counts for ballgown
 /.../stringtie-x.x.xd.Linux_x86_64/stringtie -e -B -p 8 -G stringtie_merged.gtf -o ballgown/xx/seqxx.gtf seqxx.bam
 /h.../stringtie-x.x.xd.Linux_x86_64/stringtie -e -B -p 8 -G stringtie_merged.gtf -o ballgown/xx/seqxx.gtf seqxx.bam

