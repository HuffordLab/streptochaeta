#!/bin/bash
#SBATCH -N 1
#SBATCH -A triffid
#SBATCH -n 36
#SBATCH -t 96:00:00
#SBATCH -J te-sort_0
#SBATCH -o te-sort_0.o%j
#SBATCH -e te-sort_0.e%j
#SBATCH --mail-user=arnstrm@gmail.com
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
cd $SLURM_SUBMIT_DIR
ulimit -s unlimited
module purge
ml hmmer blast-plus
python TEsorter/TEsorter.py -p 36 -db rexdb-plant --tmp-dir /scratch/arnstrm/3027213  augustus.hints.codingseq
scontrol show job $SLURM_JOB_ID
