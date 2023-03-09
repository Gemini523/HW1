#!/bin/sh

from Bio import SeqIO
ref_genome_file = 'path/to/reference/genome/file.fasta'
num_sequences = sum(1 for record in SeqIO.parse(ref_genome_file, 'fasta'))
print('The reference genome contains', num_sequences, 'sequences.')

./python_code
