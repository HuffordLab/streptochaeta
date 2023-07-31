#!/bin/bash

input=$1      #input fasta file
num_iter=$2    #number of iteration
pattern=$3   #domain search pattern

name=$(echo "$input" |sed 's/\(.*\)_[[:digit:]].fa/\1/g')
initial_iter=$(echo "$input" |sed 's/.*_\([[:digit:]]\).fa/\1/g')   # Take the initial iteration number

for ((i=$initial_iter+1;i<=num_iter;i++))
do
  #blastp
  blastp -query $input -db /shares/ekellogg_share/yyu/blast/monocots_selected_010421/monocot_010421_protein.fa -outfmt 6 -evalue 1e-10 -out ${name}.blastp${i}

  #retrieve ID from blastp
  cut -f2 ${name}.blastp${i} |sort |uniq > ${name}.blastp${i}_ID.txt
  echo "Number of uniq hits from blastp${i}:"
  wc -l ${name}.blastp${i}_ID.txt

  #retrieve fasta sequences from blastp
  python2 /shares/ekellogg_share/yyu/bin/faSomeRecords.py -f /shares/ekellogg_share/yyu/blast/monocots_selected_010421/monocot_010421_protein.fa -l ${name}.blastp${i}_ID.txt -o ${name}.blastp${i}.fa

  #perform hmmscan using full sequence E-value of 1e-3 and domain E-value of 0.1
  hmmscan -E 1e-3 --domE 0.1 --domtblout ${name}.blastp${i}.hmmscan.domtbl.out -o ${name}.blastp${i}.hmmscan.out /shares/ekellogg_share/yyu/Pfam/Pfam-A.hmm ${name}.blastp${i}.fa

  #search for domain pattern. The searching pattern need to be at the beginning, such as AP2, Myb_DNA-bind
  awk -v pat="^$pattern" '$1~pat {print $4}' ${name}.blastp${i}.hmmscan.domtbl.out |sort |uniq > ${name}_id${i}.txt
  echo "Number of $pattern hits after hmmscan${i}:"
  wc -l ${name}_id${i}.txt
  python2 /shares/ekellogg_share/yyu/bin/faSomeRecords.py -f /shares/ekellogg_share/yyu/blast/monocots_selected_010421/monocot_010421_protein.fa -l ${name}_id${i}.txt -o ${name}_${i}.fa
  input=${name}_${i}.fa
done
