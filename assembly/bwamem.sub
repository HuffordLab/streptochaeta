#!/bin/bash
#PBS -l nodes=1:ppn=16:compute
#PBS -l walltime=168:00:00
#PBS -N bwamem
#PBS -o ${PBS_JOBNAME}.o${PBS_JOBID} -e ${PBS_JOBNAME}.e${PBS_JOBID}
#PBS -m ae -M arnstrm@gmail.com
cd $PBS_O_WORKDIR
ulimit -s unlimited
chmod g+rw ${PBS_JOBNAME}.[eo]${PBS_JOBID}
module use /shared/software/GIF/modules/
module load bwa
module load samtools
cat *_R1.fastq.gz >> forward_R1.fq.gz
cat *_R2.fastq.gz >> reverse_R2.fq.gz
sh runBWAmem.sh MaSuRCA_redundans_final.fasta forward_R1.fq.gz reverse_R2.fq.gz
ssh condo "qstat -f ${PBS_JOBID} | head"
