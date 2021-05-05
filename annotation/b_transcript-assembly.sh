#!/bin/bash

dataset1=dataset1_r2_Aligned.sortedByCoord.out.bam
dataset2=dataset2_r2_Aligned.sortedByCoord.out.bam


# strawberry:

ml strawberry
for bam in $dataset1 $dataset2; do
strawberry \
   --output-gtf strawberry-${bam%.*}.gtf \
   --logfile strawberry_assembled.log \
   --no-quant \
   --num-threads 36 \
   --verbose --fr \
   --min-transcript-size 100 \
     ${bam}
done

# cufflinks

module load cufflinks
for bam in $dataset1 $dataset2; do
out=$(basename ${bam%.*})
mkdir -p ${out}
cufflinks \
   --output-dir "${out}" \
   --num-threads 36 \
   --library-type fr-firststrand \
    --frag-len-mean 100 \
   --verbose \
   --no-update-check \
   ${bam}
done

# class2

ml purge
PATH=$PATH:/work/triffid/arnstrm/Streptochaeta/09_mikado/e-class2/CLASS-2.1.7
ml gcc
ml samtools
for bam in $dataset1 $dataset2; do
ref=Streptochaeta_BioNanoRedundans_scaffolds_V1.fasta
out=$(basename ${bam%.*})
ml samtools
samtools view -h $bam | addXS $ref | samtools view -bS - > ${bam%.*}_xs.bam
run_class.pl \
   -a ${bam%.*}_xs.bam \
   -o ${out}_class.gtf \
   -p 36 \
   --verbose \
   --clean
done

# run stringtie

module load stringtie
for bam in $dataset1 $dataset2; do
out=$(basename ${bam%.*} )
stringtie \
   ${bam} \
   --rf \
   -m 100 \
   -p 36 \
   -v \
   -o ${out}_stringtie.gtf
done

# run portcullis:

#!/bin/bash
source /work/LAS/mhufford-lab/shared_dir/minconda/20181213/etc/profile.d/conda.sh
conda activate portcullis
genome=Streptochaeta_BioNanoRedundans_scaffolds_V1.fasta
nam="streptochaeta"
outdir=portcullis_out
for bam in $dataset1 $dataset2; do
portcullis full \
   -t 16 \
   --use_csi \
   --output ${outdir} \
   --orientation FR \
   --strandedness firststrand \
     $genome \
     $bam
done



