#!/bin/bash
python /shared/software/GIF/programs/redundans/0.13a/redundans.py \
  -v \
  -i HUSA1-1_L12_R1.fastq.gz HUSA1-1_L12_R2.fastq.gz HUSA1-1-9K_L12_R1.fastq.gz HUSA1-1-9K_L12_R2.fastq.gz HUSA1-1-11K_L12_R1.fastq.gz HUSA1-1-11K_L12_R2.fastq.gz \
  -f Streptochaeta_MaSuRCA_BioNano_scaffolds.fasta \
  -t 16 \
  --resume \
  --log redundans_platanus.log 


