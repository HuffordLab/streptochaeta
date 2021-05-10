# sRNA analyses

### Trimming

```bash
#!/bin/sh
cutadapt -a TGGAATTCTCGGGTGCCAAGGAACTCCAGTCAC -g GTTCAGAGTTCTACAGTCCGACGATC --trim-n -m 15 -M 34 -o /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/trim/Phar_ant_1_0m_raw.fastq.gz /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/raw/Phar_ant_1_0m_raw.fastq.gz
cutadapt -a TGGAATTCTCGGGTGCCAAGGAACTCCAGTCAC -g GTTCAGAGTTCTACAGTCCGACGATC --trim-n -m 15 -M 34 -o /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/trim/Phar_fem1_raw.fastq.gz /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/raw/Phar_fem1_raw.fastq.gz
cutadapt -a TGGAATTCTCGGGTGCCAAGGAACTCCAGTCAC -g GTTCAGAGTTCTACAGTCCGACGATC --trim-n -m 15 -M 34 -o /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/trim/Phar_leaf1_raw.fastq.gz /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/raw/Phar_leaf1_raw.fastq.gz
cutadapt -a TGGAATTCTCGGGTGCCAAGGAACTCCAGTCAC -g GTTCAGAGTTCTACAGTCCGACGATC --trim-n -m 15 -M 34 -o /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/trim/Strep_an_1_5_raw.fastq.gz /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/raw/Strep_an_1_5_raw.fastq.gz
cutadapt -a TGGAATTCTCGGGTGCCAAGGAACTCCAGTCAC -g GTTCAGAGTTCTACAGTCCGACGATC --trim-n -m 15 -M 34 -o /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/trim/Strep_an_3_0_raw.fastq.gz /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/raw/Strep_an_3_0_raw.fastq.gz
cutadapt -a TGGAATTCTCGGGTGCCAAGGAACTCCAGTCAC -g GTTCAGAGTTCTACAGTCCGACGATC --trim-n -m 15 -M 34 -o /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/trim/Strep_an_4_0_raw.fastq.gz /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/raw/Strep_an_4_0_raw.fastq.gz
cutadapt -a TGGAATTCTCGGGTGCCAAGGAACTCCAGTCAC -g GTTCAGAGTTCTACAGTCCGACGATC --trim-n -m 15 -M 34 -o /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/trim/Strep_leaf_raw.fastq.gz /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/raw/Strep_leaf_raw.fastq.gz
cutadapt -a TGGAATTCTCGGGTGCCAAGGAACTCCAGTCAC -g GTTCAGAGTTCTACAGTCCGACGATC --trim-n -m 15 -M 34 -o /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/trim/Strep_pistil_raw.fastq.gz /Users/sbelanger/research/data/sequencing/S.angustifolia/srna.anther/raw/Strep_pistil_raw.fastq.gz
```



### sRNA mapping

```bash
#!/bin/sh

# The batch script may contain options preceded with "#SBATCH" before any executable commands in the script:
#SBATCH --job-name=San_srna1    # Name of job (Default: Script name)
#SBATCH --output=%x-%j.out      # Output to a file with a name constructed from the job name (%x)
# and the job ID number (%j) (Default: slurm-%j.out)
#SBATCH --time=45:00:00             # Time limit (Format: hh:mm:ss or mm:ss) (Default: 1:00:00)
#SBATCH --cpus-per-task=10       # Number of processors per task (Default: 1)
#SBATCH --mem=100G              # Memory per node (Default: 256MB/cpu)


export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK    # Required by OpenMP

module add samtools bowtie viennarna

ref="/home/sbelange/scratch/data/ref/Streptochaeta_BioNanoRedundans_scaffolds_V1.fasta"

rm -r /home/sbelange/scratch/srna/S.angustifolia
out1="/home/sbelange/scratch/srna/S.angustifolia"
out2="/home/sbelange/scratch/srna/S.angustifolia.v2"

cd /home/sbelange/scratch/data/srna/
./ShortStack --bowtie_cores 10 --sort_mem 100G --mismatches 0 --bowtie_m 50 --dicermin 19 --dicermax 25 --mmap u --mincov 0.5rpm --outdir ${out2} --readfile Strep_an_1_5_raw.fastq.gz Strep_an_3_0_raw.fastq.gz Strep_an_4_0_raw.fastq.gz Strep_leaf_raw.fastq.gz Strep_pistil_raw.fastq.gz --genomefile ${ref}
```




### known mirna annotation

```bash
###Using the Bash terminal, creating the fasta file format containing the sequences and perform the homology search
u="/Users/sbelanger/research/S.angustifolia/anther/san.srna.txt"
v="/Users/sbelanger/research/S.angustifolia/anther/annotation/san.tag.fa"
sed '1d' < ${u} | awk '{print $2 "\t" $9}' | awk '$0=">"$0' | awk '{print $1 "\n" $2}' > ${v}


#To use the script of Blake to annotate mirna.
cd /Users/sbelanger/research/S.angustifolia/anther/annotation
bash san.mirna.sh
```


### upset plot


```R
#Install package on R3.6.1
#install.packages("UpSetR")

#Load package on R3.6.1
library(UpSetR)
library(dplyr)
library(tidyr)
library(tibble)
require(gridExtra)


# Reading the data
setwd("/Users/sbelanger/Documents/research/S.angustifolia/anther/visualization")
x1 = read.delim("S.angustifolia.miRNA.comparison.txt",row.names=1)
x2 = read.delim("S.angustifolia.miRNA.comparison.species.txt",row.names=1)
x3 = read.delim("S.angustifolia.PARE.txt",row.names=1)


upset(x1, sets = c("Anther_1.5mm", "Anther_3.0mm", "Anther_4.0mm", "Pistil", "Leaf"), mb.ratio = c(0.55, 0.45), order.by = "degree")
upset(x2, sets = c("A.officinalis", "O.sativa", "S.angustifolia", "Z.mays"), mb.ratio = c(0.55, 0.45), order.by = "degree")


p1=upset(x1, sets = c("Anther_1.5mm", "Anther_3.0mm", "Anther_4.0mm", "Pistil", "Leaf"), mb.ratio = c(0.55, 0.45), order.by = "degree")
p2=upset(x2, sets = c("A.officinalis", "O.sativa", "S.angustifolia", "Z.mays"), mb.ratio = c(0.55, 0.45), order.by = "degree")

grid.arrange(p1,p2,ncol=2)

upset(x1, sets = c("Anther_1.5mm", "Anther_3.0mm", "Anther_4.0mm", "Pistil", "Leaf"), mb.ratio = c(0.55, 0.45), order.by = "degree", queries = list(list(query = intersects, params = list("Anther_1.5mm", "Anther_3.0mm", "Anther_4.0mm"), color = "green", active = T), list(query = intersects, params = list("Anther_1.5mm", "Anther_3.0mm", "Anther_4.0mm", "Pistil", "Leaf"), active = T)))
upset(x2, sets = c("A.officinalis", "O.sativa", "S.angustifolia", "Z.mays"), mb.ratio = c(0.55, 0.45), order.by = "degree", queries = list(list(query = intersects, params = list("S.angustifolia"), color = "green", active = T), list(query = intersects, params = list("A.officinalis", "O.sativa", "S.angustifolia", "Z.mays"), active = T)))
```




### pare analysis#

```bash
#Few paths
/Users/sbelanger/Documents/research/data/reference/S.angustifolia/
/Users/sbelanger/Documents/research/data/data.sequencing/S.angustifolia/pare/trim/
/Users/sbelanger/Documents/research/S.angustifolia/anther/pare/param/

#To extract the full lenght transcirpt from the GFF3 file
cd /Users/sbelanger/Documents/research/data/reference/S.angustifolia/
samtools faidx /Users/sbelanger/Documents/research/data/reference/S.angustifolia/Streptochaeta_BioNanoRedundans_scaffolds_V1.fasta
gffread -w Streptochaeta_BIND_v2.7-transcripts.fa -g /Users/sbelanger/Documents/research/data/reference/S.angustifolia/Streptochaeta_BioNanoRedundans_scaffolds_V1.fasta /Users/sbelanger/Documents/research/data/reference/S.angustifolia/Streptochaeta_BIND_v2.7.gff3

#PAREsnip2 --- annotated miRNAs and phasiRNAs
cd /Users/sbelanger/Documents/software/UEA_Workbench_4.7/
java -Xmx12g -jar Workbench.jar -tool paresnip2 \
    -parameters /Users/sbelanger/Documents/research/S.angustifolia/anther/pare/param/parameters.cfg \
    -targeting_rules /Users/sbelanger/Documents/research/S.angustifolia/anther/pare/param/targetting.rules.carrington.cfg \
    -srna_files /Users/sbelanger/Documents/research/S.angustifolia/anther/pare/mirna.fasta \
    -pare_files /Users/sbelanger/Documents/research/data/data.sequencing/S.angustifolia/pare/trim/Strepto_PARE_anther_trim.fastq \
    -reference /Users/sbelanger/Documents/research/data/reference/S.angustifolia/Streptochaeta_BIND_v2.7-transcripts.fa \
    -output_dir /Users/sbelanger/Documents/research/S.angustifolia/anther/pare

cd /Users/sbelanger/Documents/software/UEA_Workbench_4.7/
java -Xmx16g -jar Workbench.jar -tool paresnip2 \
    -parameters /Users/sbelanger/Documents/research/S.angustifolia/anther/pare/param/parameters.cfg \
    -targeting_rules /Users/sbelanger/Documents/research/S.angustifolia/anther/pare/param/targetting.rules.carrington.cfg \
    -srna_files /Users/sbelanger/Documents/research/S.angustifolia/anther/pare/mirna.fasta \
    -pare_files /Users/sbelanger/Documents/research/data/data.sequencing/S.angustifolia/pare/trim/Strepto_PARE_pistil_trim.fastq \
    -reference /Users/sbelanger/Documents/research/data/reference/S.angustifolia/Streptochaeta_BIND_v2.7-transcripts.fa \
    -output_dir /Users/sbelanger/Documents/research/S.angustifolia/anther/pare

cd /Users/sbelanger/Documents/software/UEA_Workbench_4.7/
java -Xmx16g -jar Workbench.jar -tool paresnip2 \
    -parameters /Users/sbelanger/Documents/research/S.angustifolia/anther/pare/param/parameters.cfg \
    -targeting_rules /Users/sbelanger/Documents/research/S.angustifolia/anther/pare/param/targetting.rules.carrington.cfg \
    -srna_files /Users/sbelanger/Documents/research/S.angustifolia/anther/pare/mirna.fasta \
    -pare_files /Users/sbelanger/Documents/research/data/data.sequencing/S.angustifolia/pare/trim/Strepto_PARE_leaf_trim.fastq \
    -reference /Users/sbelanger/Documents/research/data/reference/S.angustifolia/Streptochaeta_BIND_v2.7-transcripts.fa \
    -output_dir /Users/sbelanger/Documents/research/S.angustifolia/anther/pare
```
