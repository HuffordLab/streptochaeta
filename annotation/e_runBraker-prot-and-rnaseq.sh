#!/bin/bash
source /work/LAS/mhufford-lab/arnstrm/miniconda/etc/profile.d/conda.sh
source /work/LAS/mhufford-lab/arnstrm/programs/sourceme
conda activate braker
genome="Streptochaeta_BioNanoRedundans_scaffolds_V1-softmasked.fasta"
bam="combined_round-2Aligned.sortedByCoord.out.bam,SRR3233339_r2_Aligned.sortedByCoord.out.bam"
proteins="mikado_coding_pep-renamed.fasta"
today=$(date +"%Y%m%d")
nam=sangu
profile="${nam}_prot-rna_${today}.1"

GENEMARK_PATH="/work/LAS/mhufford-lab/arnstrm/programs/genemark-et-4.33/bin"
braker.pl \
   --genome=$genome \
   --bam=$bam \
   --prot_seq=${proteins} \
   --prg=gth \
   --gth2traingenes \
   --species=${profile} \
   --softmasking \
   --cores 36 \
   --gff3
