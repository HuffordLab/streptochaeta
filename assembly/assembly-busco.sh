#!/bin/bash
fasta=Streptochaeta_BioNanoRedundans_scaffolds_V1.fasta
source /work/LAS/mhufford-lab/arnstrm/miniconda/etc/profile.d/conda.sh
conda activate busco
run_BUSCO.py \
   -i ${fasta} \
   -c 36 \
   -o ${fasta%.*} \
   -m genome \
   -l /work/LAS/mhufford-lab/arnstrm/PanAnd/1_data/busco_profiles/liliopsida_odb10 \
   -f \
   -r \
   -t $TMPDIR
