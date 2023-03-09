#!/bin/sh

from Bio import SeqIO
ref_genome_file = 'path/to/reference/genome/file.fasta'
num_sequences = sum(1 for record in SeqIO.parse(ref_genome_file, 'fasta'))
print('The reference genome contains', num_sequences, 'sequences.')

./python_code
import os

# define the directory where the input files are located
input_dir = "inputs/"

# define a dictionary to store the counts for each sample
counts = {}

# loop through the files in the input directory
for filename in os.listdir(input_dir):
    # check if the file is a FASTQ file and if it contains one of the sample labels
    if filename.endswith(".fastq") and any(label in filename for label in ["SRR8985047", "SRR8985048", "SRR8985051", "SRR8985052"]):
        # open the file and count the number of lines
        with open(os.path.join(input_dir, filename)) as f:
            num_lines = sum(1 for line in f)
        # divide the number of lines by 4 to get the number of reads
        num_reads = num_lines / 4
        # add the count to the dictionary
        counts[filename] = num_reads

# print counts for each sample
for label in ["SRR8985047", "SRR8985048", "SRR8985051", "SRR8985052"]:
    # filter the dictionary to get the counts for the current sample
    sample_counts = {k:v for k,v in counts.items() if label in k}
    # sum the counts for all files containing the sample label
    total_count = sum(sample_counts.values())
    print(f"{label}: {total_count}")
