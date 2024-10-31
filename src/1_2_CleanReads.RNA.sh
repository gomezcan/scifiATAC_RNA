#!/bin/bash

########## Load Modules #########
ml Bioinformatics bcl2fastq2/2.20.0.422-oxq6lf3
conda activate umi_tools

########## Command Lines to Run ######### 
name=$1 # Sample  base name

tenxBC=${name}_R2_001.fastq.gz
R1=${name}_R1_001.fastq.gz
R2=${name}_R3_001.fastq.gz

R1tenx=${name}_R1_001.bc1.fastq.gz
R2tenx=${name}_R3_001.bc1.fastq.gz

R1tenxt_pre=${name}_R1_001.bc1.prebc2.fastq.gz

R1tenxtn5=${name}_R1_001.bc1.bc2.fastq.gz
R2tenxtn5=${name}_R3_001.bc1.bc2.fastq.gz

# Step 1: Add barcode name from demultiplexed files to reads 1 and 3
# append 10x barcode to R1
umi_tools extract --bc-pattern=NNNNNNNNNNNNNNNN --stdin=$tenxBC --read2-in=$R1 --stdout=$R1tenx --read2-stdout

# append 10x barcode to R2
umi_tools extract --bc-pattern=NNNNNNNNNNNNNNNN --stdin=$tenxBC --read2-in=$R2 --stdout=$R2tenx --read2-stdout

# Step 2: remove adapter before umi from R1
cutadapt -e 0.2 -j 72 \
	-g CTCTTCCGATCT \
	-o $R1tenxt_pre \
	$R1tenx

# Step 3: removepy TTT and add index R1 and UMI to name of bc from R1 and R2
cutadapt -e 0.2 \
	--minimum-length 15 \
	--pair-filter=any \
	-j 72 \
	--rename='{id}_{r1.cut_prefix} {comment}' \
	-u 21 \
	-g TTTTTTTTTTTTTTT \
	-o $R1tenxtn5 \
	-p $R2tenxtn5 \
	$R1tenxt_pre $R2tenx
