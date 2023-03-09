#!/bin/sh

#prints number of reference genome
#!/usr/bin/env python3

import gzip
from Bio import SeqIO

#Calculate (and print to the screen) the number of sequences in your reference genome

# Replace the filename with the path to your gzipped reference genome file
filename = "reference_genome.fasta.gz"
with gzip.open(filename, "rt") as handle:
    num_seqs = sum(1 for _ in SeqIO.parse(handle, "fasta"))

print("The reference genome contains", num_seqs, "sequences.")

#Calculate (and print to the screen) the number of reads in each sample.
# Define the file names

file_names = ['SRR8985047.fastq', 'SRR8985048.fastq', 'SRR8985051.fastq', 'SRR8985052.fastq']

# Loop over the files and count the number of reads in each file
for file_name in file_names:
    count = 0
    for record in SeqIO.parse(file_name, "fastq"):
        count += 1
    print("Number of reads in {}: {}".format(file_name, count))


#Calculate the number of protein-coding genes in your genome.
from Bio.SeqFeature import FeatureLocation

# specify the path to the gzipped genome annotation file
gff_file = "gencode.vM9.annotation.gff3.gz"

protein_coding_genes = 0

# parse the gzipped genome annotation file
with gzip.open(gff_file, "rt") as handle:

    for record in SeqIO.parse(handle, "gff3"):
        for feature in record.features:
            if feature.type == "gene" and "protein_coding" in feature.qualifiers.get("biotype", []):
                protein_coding_genes += 1

print(f"Total protein-coding genes: {protein_coding_genes}")



