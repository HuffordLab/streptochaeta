#!/bin/bash
blastxml=mikado.blast.xml
targets=/work/LAS/mhufford-lab/arnstrm/newNAM/analyses/g-transcript-assembly/uniprot-sprot_viridiplantae.fasta
orfs=/work/triffid/arnstrm/Streptochaeta/09_mikado/f-mikado/transdecoder/mikado_prepared.fasta.transdecoder.bed
junctions=/work/triffid/arnstrm/Streptochaeta/09_mikado/a-portcullis/SRR3233339/portcullis_out/3-filt/portcullis_filtered.pass.junctions.bed
genome=/work/triffid/arnstrm/Streptochaeta/04-RNAmapping/Streptochaeta_BioNanoRedundans_scaffolds_V1.fasta
source /work/LAS/mhufford-lab/arnstrm/miniconda/etc/profile.d/conda.sh
conda activate mikado
#serialise
mikado serialise \
   --start-method spawn \
   --procs 36 \
   --blast_targets ${targets} \
   --json-conf config.toml \
   --xml ${blastxml} \
   --orfs ${orfs}
#pick
mikado pick \
   --start-method spawn \
   --procs 36 \
   --json-conf config.toml \
   --subloci-out mikado_subloci-out.gff3
