#!/bin/bash
ltr_image="/work/triffid/arnstrm/Streptochaeta/06_EDTA/ltr-retriever/ltr_retriever_latest.sif"
module purge
ml singularity
genome=Streptochaeta_BioNanoRedundans_scaffolds_V1.fasta
intact=$(find $(pwd) -name "*fasta.mod.pass.list")
anno=$(find $(pwd) -name "*fasta.mod.EDTA.TEanno.out")
singularity exec --bind $PWD ${ltr_image} /LTR_retriever/LAI \
    -genome $genome \
    -intact $intact \
    -all $anno \
    -t 36
