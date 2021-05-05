#!/bin/bash
set -x
nam=
list=list.txt
junctions=$(find $(pwd) -name "portcullis_filtered.pass.junctions.bed")
genome=Streptochaeta_BioNanoRedundans_scaffolds_V1.fasta
source /work/LAS/mhufford-lab/arnstrm/miniconda/etc/profile.d/conda.sh
conda activate mikado
mikado configure \
   --list $list \
   --reference $genome \
   --mode permissive \
   --scoring plants.yaml \
   --copy-scoring plants.yaml \
   --junctions $junctions configuration.yaml

cp /work/LAS/mhufford-lab/arnstrm/newNAM/analyses/g-transcript-assembly/plants.yaml ./
sed -i 's/procs: 1/procs: 36/g' configuration.yaml
sed -i 's+plants.yaml+'${pwd}'/plants.yaml+g' configuration.yaml
mikado prepare \
   --json-conf configuration.yaml
mkdir blastjobs
cd blastjobs
ln -s ../mikado_prepared.fasta
fasta-splitter.pl --n-parts 8 mikado_prepared.fasta
unlink mikado_prepared.fasta
for f in mikado_prepared.part-?.fasta; do
   echo "/work/LAS/mhufford-lab/arnstrm/newNAM/analyses/g-transcript-assembly/runBLASTx.sh $f"
done > ${nam}.cmds
makeSLURMp.py 8 ${nam}.cmds
for f in /work/LAS/mhufford-lab/arnstrm/newNAM/analyses/g-transcript-assembly/uniprot-sprot_viridiplantae.fasta*; do
ln -s $f;
done
for f in *.sub; do 
 sed -i 's/j 1 --joblog/j 8 --joblog/g' $f;
 sbatch $f;
done
cd /work/LAS/mhufford-lab/arnstrm/newNAM/analyses/g-transcript-assembly/${nam}/mikado
echo "/work/LAS/mhufford-lab/arnstrm/newNAM/analyses/g-transcript-assembly/runTransDecoder.sh" > td.cmds
makeSLURMs.py 1 td.cmds
sbatch td_0.sub

