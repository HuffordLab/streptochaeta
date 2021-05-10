# Assembly steps

## Data QC

### 1. FastQC summary:

```bash
for file in *.fastq.gz; do
  fastqc --threads 16 $file
done
```
### 2. Kmer profile

Genomescope was used for generating the Kmer profile



## Genome assembly

MaSuRCA parameters and input files were configured in the config file [`sr_config.txt`](assets/sr_config.txt), and the it was run as shown in [`masurca.slurm`](masurca_pbs.sh) file.

The input data is as shown:

| Lane   | Filename                                                | Fragment size | Length |     Counts |       Total Counts | Coverage (X) |
|--------|---------------------------------------------------------|--------------:|-------:|-----------:|-------------------:|-------------:|
| Lane 1 | Sample_HUSA1-1/HUSA1-1_CGATGT_L001_R1_001.fastq         |         250bp |  150bp | 78,167,479 |       156,334,958  |        13.03 |
| Lane 1 | Sample_HUSA1-1/HUSA1-1_CGATGT_L002_R1_001.fastq         |         250bp |  150bp | 76,047,370 |       152,094,740  |        12.67 |
| Lane 2 | Sample_HUSA1-1-9K/HUSA1-1-9K_ACAGTG_L001_R1_001.fastq   |           9kb |  150bp | 35,573,143 |        71,146,286  |         5.93 |
| Lane 2 | Sample_HUSA1-1-9K/HUSA1-1-9K_ACAGTG_L002_R1_001.fastq   |           9kb |  150bp | 34,741,875 |        69,483,750  |         5.79 |
| Lane 2 | Sample_HUSA1-1-11K/HUSA1-1-11K_GTGAAA_L001_R1_001.fastq |          11kb |  150bp | 33,067,935 |        66,135,870  |         5.51 |
| Lane 2 | Sample_HUSA1-1-11K/HUSA1-1-11K_GTGAAA_L002_R1_001.fastq |          11kb |  150bp | 32,362,828 |        64,725,656  |         5.39 |

## Assembly evaluation and post-processing

### 1. Reducing heterozygosity

`redundans` was run using the script [`runRedundans.sh`](runRedundans.sh), with the PBS file [`redundans.sub`](redundans.sub).

### 2. BUSCO

BUSCO was run to evaluate the gene space completeness as shown in [`assembly-busco.sh`](assembly-busco.sh). The summary output is available [here](assets/busco_short_summary.txt).


### 3. Repeat annotation and LAI



## Contamination detection and screening.
