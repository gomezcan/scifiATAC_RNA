#!/bin/bash

##########   Load Modules     ##########
module load Bioinformatics star/2.7.11a-hdp2onj
#########################################

# Sample name base
sample=$1;

# genome
Index="GenomesIndex/Zea/Index_B73v5_star"

# reads 
f1="${sample}_R1_001.bc1.bc2.fastq.gz"
f2="${sample}_R3_001.bc1.bc2.fastq.gz"

# override temdir for tem files
rm -r /scratch/amarand_root/amarand0/gomezcan/_temfiles/tempalign

STAR --runThreadN 72 --genomeDir $Index \
  --readFilesIn $f1 $f2 --outSAMtype BAM Unsorted \
  --outTmpDir /scratch/amarand_root/amarand0/gomezcan/_temfiles/tempalign \
	--quantMode GeneCounts \
	--alignIntronMax 20000 \
	--outFilterScoreMinOverLread 0 \
	--outFilterMatchNminOverLread 0 \
	--outFilterMatchNmin 0 \
	--readFilesCommand zcat \
	--outFileNamePrefix ${sample}_scifiRNA.raw. ;

# keep names simple
mv ${sample}R_scifiRNA.raw.Aligned.out.bam ${sample}R_scifiRNA.raw.bam
