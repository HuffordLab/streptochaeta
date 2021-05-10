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

| Filename               | Fragment size | Length |     Counts |       Total Counts | Coverage (X) |
|------------------------|--------------:|-------:|-----------:|-------------------:|-------------:|
| Sample_HUSA1-1         |         250bp |  150bp | 78,167,479 |       156,334,958  |        13.03 |
| Sample_HUSA1-2         |         250bp |  150bp | 76,047,370 |       152,094,740  |        12.67 |
| Sample_HUSA1-1-9K      |           9kb |  150bp | 35,573,143 |        71,146,286  |         5.93 |
| Sample_HUSA1-2-9K      |           9kb |  150bp | 34,741,875 |        69,483,750  |         5.79 |
| Sample_HUSA1-1-11K     |          11kb |  150bp | 33,067,935 |        66,135,870  |         5.51 |
| Sample_HUSA1-2-11K     |          11kb |  150bp | 32,362,828 |        64,725,656  |         5.39 |

## Assembly evaluation and post-processing

### 1. Reducing heterozygosity

`redundans` was run using the script [`runRedundans.sh`](runRedundans.sh), with the PBS file [`redundans.sub`](redundans.sub).

### 2. BUSCO

BUSCO was run to evaluate the gene space completeness as shown in [`assembly-busco.sh`](assembly-busco.sh). The summary output is available [here](assets/busco_short_summary.txt).


### 3. Repeat annotation and LAI

First, repeats were annotated using EDTA program with the script [`assembly-edta.sh`](assembly-edta.sh). After completion, `LTR_retriever` was run using the script [`assembly-ltr_retreiver.sh`](assembly-ltr_retreiver.sh)


## Contamination detection and screening.

For contamination screening Blobtools was used.
  1. short reads were mapped to the assembly using the script [`runBWAmem.sh`](runBWAmem.sh).
  2. reads were BLAST searched against NCBI refseq database using [`runMegablast.sh`](runMegablast.sh)
  3. `blobtools` was run using the above outputs and the genome assembly with the script [`blobtools.sh`](blobtools.sh)
  
