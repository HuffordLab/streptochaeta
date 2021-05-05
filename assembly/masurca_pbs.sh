#!/bin/bash
#PBS -q testq1
#PBS -l vmem=256Gb,pmem=8Gb,mem=256Gb
#PBS -l nodes=1:ppn=32:ib32
#PBS -l walltime=336:00:00
#PBS -N MS_STRP_A
#PBS -o ${PBS_JOBNAME}.o${PBS_JOBID}
#PBS -e ${PBS_JOBNAME}.e${PBS_JOBID}
#PBS -m ae
cd $PBS_O_WORKDIR
ulimit -s unlimited
module use /data004/software/GIF/modules
module load masurca/2.3.0_bin
masurca sr_config.txt
sh assemble.sh
