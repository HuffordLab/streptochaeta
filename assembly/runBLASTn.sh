#!/bin/bash
infile="$1"
outfile="$(basename "${infile%.*}").stdout"
database="/data021/GIF/arnstrm/Baum/GenePrediction_Hg_20160115/05_databases/nt/nt"
module load ncbi-blast
blastn \
 -query "${infile}" \
 -db "${database}" \
 -out "${outfile}" \
 -num_threads 16 \
 -max_target_seqs 15 
# -outfmt 5
# -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore staxids salltitles"
# -evalue 1e-20 \
