#!/bin/bash

# dataset1 (paired-end)
### download sra datasets:
python3 enaBrowserTools-1.6/python3/enaDataGet.py -f fastq -as  ~/.aspera_setting.ini SRR3233339
dataset1_R1=SRR3233339_1.fastq.gz
dataset1_R2=SRR3233339_2.fastq.gz

# dataset2 (single-end)
dataset2_R1=combined_forward.fastq


# index genome using STAR
index=/work/triffid/arnstrm/Streptochaeta/01-data/Streptochaeta
genome=Streptochaeta_BioNanoRedundans_scaffolds_V1.fasta
STAR --runMode genomeGenerate --runThreadN 30 --genomeDir $index --genomeFastaFiles $genome

# map dataset1 round 1
STAR \
 --genomeDir $index \
 --runThreadN 36 \
 --runMode alignReads \
 --readFilesIn ${dataset1_R1} ${dataset1_R2} \
 --readFilesCommand zcat \
 --outFileNamePrefix dataset1_ \
 --outSAMtype None

# map dataset2 round 1
STAR \
 --genomeDir $index \
 --runThreadN 36 \
 --runMode alignReads \
 --readFilesIn ${dataset2_R1} \
 --outFileNamePrefix dataset2_ \
 --outSAMtype None

# merge splice junctions
awk -f sjCollapseSamples.awk *_SJ.out.tab | sort -k1,1V -k2,2n -k3,3n > SJ.all

# map dataset1 round 2
STAR \
 --genomeDir $index \
 --runThreadN 36 \
 --sjdbFileChrStartEnd SJ.all \
 --runMode alignReads \
 --readFilesIn ${dataset1_R1} ${dataset1_R2} \
 --readFilesCommand zcat \
 --outFileNamePrefix dataset1_r2_ \
 --outSAMstrandField intronMotif \
 --outFilterIntronMotifs RemoveNoncanonical \
 --outBAMsortingThreadN 4 \
 --limitSjdbInsertNsj 3545859 \
 --limitBAMsortRAM 40000000000 \
 --outSAMtype BAM SortedByCoordinate

# map dataset2 round 2
STAR \
 --genomeDir $index \
 --runThreadN 36 \
 --sjdbFileChrStartEnd SJ.all \
 --runMode alignReads \
 --readFilesIn ${dataset2_R1} \
 --outSAMattributes All \
 --outSAMmapqUnique 10 \
 --outFilterMismatchNmax 0 \
 --outFileNamePrefix dataset2_r2 \
 --outBAMsortingThreadN 4 \
 --outSAMtype BAM SortedByCoordinate

## output files
# dataset1_r2_Aligned.sortedByCoord.out.bam
# dataset2_r2_Aligned.sortedByCoord.out.bam

# run qc
ml fastqc
fastqc ${dataset1_R1} ${dataset1_R2}
fastqc ${dataset2_R1}
# report
ml multiqc
multiqc .
