#!/bin/bash

###################################
#######       Modules     #########
###################################

module load Bioinformatics star/2.7.11a-hdp2onj bwa/0.7.17-mil4ns7

########## Command Lines to Run #########
# Set input file
input_fasta="/Genomes/Zea/Zm_B73_REFERENCE_NAM_5.0/Zm-B73-REFERENCE-NAM-5.0.chrs.mt.pt.fa"
input_gtf="/Genomes/Zea/Zm_B73_REFERENCE_NAM_5.0/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.Chr.Mt.Pt.transcript.gtf"

# Output dir for STAR index. For mapping of scifiRNA-seq
dir="/GenomesIndex/Zea/Index_B73v5_star"

## Index for scifiRNA-seq mapping
STAR --runThreadN 36 --runMode genomeGenerate \
	--genomeDir $dir \
	--genomeFastaFiles $input_fasta \
	--sjdbGTFfile $input_gtf

## Index for scifATAC-seq mapping 
bwa index $input_fasta > Index_B73v5_bwa 
