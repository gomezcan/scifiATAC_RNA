#!/bin/bash

########## Load Modules #########
# conda init
# conda activate scATAC
# requares umi_tools and cutadapt
########## Command Lines to Run ######### 

name=$1 # Name base

tenxBC=${name}_R2_001.fastq.gz
R1=${name}_R1_001.fastq.gz
R2=${name}_R3_001.fastq.gz

R1tenx=${name}_R1_001.bc1.fastq.gz
R2tenx=${name}_R3_001.bc1.fastq.gz

R1tenxtn5=${name}_R1_001.bc1.bc2.fastq.gz
R2tenxtn5=${name}_R3_001.bc1.bc2.fastq.gz

# append 10x barcode to R1
umi_tools extract --bc-pattern=NNNNNNNNNNNNNNNN --stdin=$tenxBC --read2-in=$R1 --stdout=$R1tenx --read2-stdout

# append 10x barcode to R2
umi_tools extract --bc-pattern=NNNNNNNNNNNNNNNN --stdin=$tenxBC --read2-in=$R2 --stdout=$R2tenx --read2-stdout

# append Tn5 bc from R1 and R2 to read-name
cutadapt -e 0.2 \
	--pair-filter=any \
	-j 20 \
	--rename='{id}_{r1.cut_prefix}_{r2.cut_prefix} {comment}' \
	-u 5 \
	-U 5 \
	-g AGATGTGTATAAGAGACAG \
	-G AGATGTGTATAAGAGACAG \
	-o $R1tenxtn5 \
	-p $R2tenxtn5 \
	$R1tenx $R2tenx
