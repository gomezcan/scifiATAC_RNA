#!/bin/bash

########## Load Modules #########
ml Bioinformatics bcl2fastq2/2.20.0.422-oxq6lf3
conda activate umi_tools
########## Command Lines to Run #########

# Define variables
sample=$1                # basename

# Step 1: Add barcode name from demultiplexed files to reads 1 and 3
# Create output directory for clean reads
mkdir -p "1_Clean_fq_Sample_$sample"

# Define input and output names for cleaning raw reads
R1="0_Raw_fq_Sample_$sample/${sample}_R1_001.fastq.gz"
R2="0_Raw_fq_Sample_$sample/${sample}_R3_001.fastq.gz"
tenxBC="0_Raw_fq_Sample_$sample/${sample}_R2_001.fastq.gz"

R1tenx="1_Clean_fq_Sample_$sample/${sample}_R1_001.bc1.fastq.gz"
R2tenx="1_Clean_fq_Sample_$sample/${sample}_R3_001.bc1.fastq.gz"

R1tenxtn5="1_Clean_fq_Sample_$sample/${sample}_R1_001.bc1.bc2.fastq.gz"
R2tenxtn5="1_Clean_fq_Sample_$sample/${sample}_R3_001.bc1.bc2.fastq.gz"

# Append 10x barcode to R1
umi_tools extract --bc-pattern=NNNNNNNNNNNNNNNN --stdin="$tenxBC" --read2-in="$R1" --stdout="$R1tenx" --read2-stdout

# Append 10x barcode to R2
umi_tools extract --bc-pattern=NNNNNNNNNNNNNNNN --stdin="$tenxBC" --read2-in="$R2" --stdout="$R2tenx" --read2-stdout

# Step 2: Clean reads by adding barcode from R2 to reads 1 and 3
# Append Tn5 barcode from R1 and R2 to read-name
cutadapt -e 0.2 \
  --pair-filter=any \
  -j 20 \
  --rename='{id}_{r1.cut_prefix}_{r2.cut_prefix} {comment}' \
  -u 5 \
  -U 5 \
  -g AGATGTGTATAAGAGACAG \
  -G AGATGTGTATAAGAGACAG \
  -o "$R1tenxtn5" \
  -p "$R2tenxtn5" \
  "$R1tenx" "$R2tenx"
