#!/bin/bash

input=$1
gap=$2
conservation=$3
name=$(echo "$input" |sed 's/\(.*\)_id.txt/\1/g')   #input needs to be a format of "XXX_id.txt"

# Get the fasta files and header
python2 /shares/ekellogg_share/yyu/bin/faSomeRecords.py -f /shares/ekellogg_share/yyu/blast/monocots_selected_010421/monocot_011521_protein.fa -l $input -o $name.fa
python2 /shares/ekellogg_share/yyu/bin/faSomeRecords.py -f /shares/ekellogg_share/yyu/blast/monocots_selected_010421/monocot_011521_cds.fa -l $input -o ${name}_cds.fa

# Make alignment with mafft and muscle
mafft $name.fa > $name.fa.mafft.align

#Use pal2nal to convert protein alignment into nucleotide alignment. 
perl /shares/ekellogg_share/yyu/bin/pal2nal.pl $name.fa.mafft.align ${name}_cds.fa -output fasta > ${name}_cds.fa.mafft.align

# Do trimal in mafft alignment
trimal -in $name.fa.mafft.align -out $name.mafft.trimal_gt${gap}_con${conservation}.align -gt $gap -cons $conservation -htmlout $name.mafft.trimal_gt${gap}_con${conservation}.html
trimal -in ${name}_cds.fa.mafft.align -out ${name}_cds.mafft.trimal_gt${gap}_con${conservation}.align -gt $gap -cons $conservation -htmlout ${name}_cds.mafft.trimal_gt${gap}_con${conservation}.html

# Run iqtree
iqtree -s ${name}_cds.mafft.trimal_gt${gap}_con${conservation}.align -alrt 1000 -bb 1000 -nt 8

