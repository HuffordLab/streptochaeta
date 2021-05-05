#!/bin/bash
#PBS -l nodes=1:ppn=16
#PBS -l walltime=4:00:00
#PBS -N blobtools
#PBS -o ${PBS_JOBNAME}.o${PBS_JOBID} -e ${PBS_JOBNAME}.e${PBS_JOBID}
#PBS -m ae -M arnstrm@gmail.com
cd $PBS_O_WORKDIR
ulimit -s unlimited
chmod g+rw ${PBS_JOBNAME}.[eo]${PBS_JOBID}
module use /shared/software/GIF/modules/
module load bwa
module load samtools
module load blobtools
BAM=all_reads.bam
GENOME=MaSuRCA_redundans_final.fasta
BLAST=MaSuRCA_redundans_final.vs.nt.cul5.1e25.megablast.txt
NODES=/shared/software/GIF/programs/blobtools/nodes.dmp
NAMES=/shared/software/GIF/programs/blobtools/names.dmp

blobtools create \
  -i $GENOME \
  -b $BAM \
  -t $BLAST \
  --nodes $NODES \
  --names $NAMES \
  -o blobplot_out

mkdir -p blobplot_files

blobtools view \
  -i blobplot_out.blobDB.json \
  -o blobplot_files/

blobtools blobplot -i blobplot_out.blobDB.json -o blobplot_files/

grep -v '^#' blobplot_files/blobplot_out.blobDB.table.txt | cut -f 1,3 > blobDB.id.gc.txt
awk '$2 < 0.25' blobDB.id.gc.txt |   cut -f1 |   perl -lne 'print $_.",<20%"'   > blobDB.id.gc.catcolour.txt
awk '$2 >= 0.20 && $2 < 0.30' blobDB.id.gc.txt |   cut -f1 |   perl -lne 'print $_.",20-29%"'   >> blobDB.id.gc.catcolour.txt
awk '$2 >= 0.30 && $2 < 0.40' blobDB.id.gc.txt |   cut -f1 |   perl -lne 'print $_.",30-39%"'   >> blobDB.id.gc.catcolour.txt
awk '$2 >= 0.40 && $2 < 0.50' blobDB.id.gc.txt |   cut -f1 |   perl -lne 'print $_.",40-49%"'   >> blobDB.id.gc.catcolour.txt
awk '$2 >= 0.50 && $2 < 0.60' blobDB.id.gc.txt |   cut -f1 |   perl -lne 'print $_.",50-59%"'   >> blobDB.id.gc.catcolour.txt
awk '$2 >= 0.60 && $2 < 0.70' blobDB.id.gc.txt |   cut -f1 |   perl -lne 'print $_.",60-69%"'   >> blobDB.id.gc.catcolour.txt
awk '$2 >= 0.70 && $2 < 0.80' blobDB.id.gc.txt |   cut -f1 |   perl -lne 'print $_.",70-79%"'   >> blobDB.id.gc.catcolour.txt
awk '$2 >= 0.80 && $2 < 0.90' blobDB.id.gc.txt |   cut -f1 |   perl -lne 'print $_.",80-89%"'   >> blobDB.id.gc.catcolour.txt
awk '$2 >= 0.90 && $2 < 1.00' blobDB.id.gc.txt |   cut -f1 |   perl -lne 'print $_.",90-99%"'   >> blobDB.id.gc.catcolour.txt

blobtools covplot \ 
  -i blobplot_out.blobDB.json \
  -c all_reads.bam.cov \
  --catcolour blobDB.id.gc.catcolour.txt \
  --notitle \
  --ylabel WGA-resequencing-library \
  --xlabel WGS-resequencing-library \

ssh condo "qstat -f ${PBS_JOBID} | head"
