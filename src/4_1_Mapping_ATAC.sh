#!/bin/bash

########## Load Modules #########
ml Bioinformatics bwa/0.7.17-mil4ns7 samtools/1.13-fwwss5n
#################################

# Ref file
ref="Zm-B73-REFERENCE-NAM-5.0.chrs.mt.pt.fa"

# read files directory
dic=$1

# Sample base name
sample=$2;

# defined reads one and two 
r1="$dic/${sample}_R1_001.bc1.bc2.fastq.gz"
r2="$dic/${sample}_R3_001.bc1.bc2.fastq.gz"

# Mapp and save .sam file
bwa mem -M -t 120 $ref $r1 $r2 > $dic/${sample}_scifiATAC.raw.sam;

# sort and compress .sam as .bam file
samtools view -@ 80 -bS $dic/${sample}_scifiATAC.raw.sam > $dic/${sample}_scifiATAC.raw.bam
