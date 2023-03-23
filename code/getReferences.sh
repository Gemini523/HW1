#!/bin/sh
#Mus Musculus mm10

#download transcriptome FASTA
#wget -O ../references/gencode.vM9.pc_transcripts.fa.gz https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M9/gencode.vM9.pc_transcripts.fa.gz
gzip -d ~/HW1/references/gencode.vM9.pc_transcripts.fa.gz
#download gtf/gff3 files
#wget -O ../references/gencode.vM9.annotation.gtf.gz https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M9/gencode.vM9.annotation.gtf.gz
#wget -O ../references/gencode.vM9.annotation.gff3.gz   https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M9/gencode.vM9.annotation.gff3.gz
#download genome FASTA
#wget -O ../references/GRCm38.p4.genome.fa.gz https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M9/GRCm38.p4.genome.fa.gz
#gzip -d ~/HW1/references/GRCm38.p4.genome.fa.gz

# Download FASTQ files
#fastq-dump --gzip --split-files -O ../inputs/ SRR8985047
#fastq-dump --gzip --split-files -O ../inputs/ SRR8985048
#fastq-dump --gzip --split-files -O ../inputs/ SRR8985051
#fastq-dump --gzip --split-files -O ../inputs/ SRR8985052
