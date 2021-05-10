#!/bin/bash
mikado=mikado.loci.gff3
awk '$3=="gene"' $mikado |\
   cut -f 9 |\
   cut -f 2 -d ";" |\
   cut -f 2 -d "=" > genes.txt
mikado util grep --genes genes.txt $mikado mikado-coding.gff3
```
