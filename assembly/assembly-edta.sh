#!/bin/bash
ml singularity
genome="Streptochaeta_BioNanoRedundans_scaffolds_V1.fasta"
cds="Streptochaeta_maker_standard_transcripts_V1.fasta"
edta_image=/work/triffid/arnstrm/Streptochaeta/01-data/edta/EDTA.sif
singularity exec ${edta_image} /EDTA/EDTA.pl \
    --genome $genome \
    --species others \
    --cds $cds \
    --anno 1 \
    --threads 36
