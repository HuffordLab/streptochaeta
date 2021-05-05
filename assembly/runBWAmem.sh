#!/bin/bash
THREADS=16
GENOME=$1
READ1=$2
READ2=$3
#OUTNAME=$(basename ${READ1%.*} | cut -f 1-2 -d "_")
OUTNAME=all_reads
#index the genome
#bwa index -a bwtsw ${GENOME}
bwa mem -M -t ${THREADS} ${GENOME} ${READ1} ${READ2} | samtools view -buS - > ${OUTNAME}.bam
