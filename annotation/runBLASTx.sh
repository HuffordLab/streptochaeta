#!/bin/bash
module load blast-plus
input=$1
blastx -max_target_seqs 5 -num_threads 4 -query ${input} -outfmt 5 -db uniprot-sprot_viridiplantae.fasta -evalue 0.000001 2> ${TMPDIR}/${input%.*}.log | sed '/^$/d' | gzip -c - > ${TMPDIR}/${input%.*}.blast.xml.gz
mv ${TMPDIR}/${input%.*}.log ${TMPDIR}/${input%.*}.blast.xml.gz /work/triffid/arnstrm/Streptochaeta/09_mikado/f-mikado/blastjobs/
