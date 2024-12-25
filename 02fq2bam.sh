#!/bin/bash

source /mnt/binf/rui/bestpractice/env_bashrc
export PATH=/mnt/binf/rui/bin/jdk-17.0.2/bin:$PATH
# Input and output directories
input_dir="/mnt/binf/yaochen/bestpractice/scripts/01FQdebug"  # Directory with the input FASTQ files
output_dir="/mnt/binf/yaochen/bestpractice/scripts/02BAMdebug"  # Directory for the output BAM files

# Ensure output directory exists
mkdir -p "$output_dir"

# Temporary directory for intermediate files
tmp_dir="/mnt/binf/yaochen/bestpractice/scripts/02BAMdebug/TEMP"
mkdir -p "$tmp_dir"

# Loop through all paired-end fastq files in the input directory
for file1 in "$input_dir"/*clean_R1.fastq.gz; do
    # Derive the corresponding R2 file name
    file2="${file1/clean_R1.fastq.gz/clean_R2.fastq.gz}"

    # Extract base name without file extension
    base_name=$(basename "$file1" clean_R1.fastq.gz)

    # Step 1: Align FASTQ files to the reference genome (bwa mem -> sambamba sort)
    /mnt/binf/rui/bin/bwa mem -Y -M -t 8 \
        -R '@RG\tID:1\tSM:${base_name}\tPL:ILLUMINA\tLB:.\tPU:${base_name}' \
        /mnt/binf/rui/database/reference/hs37d5/hs37d5.fa \
        "$file1" \
        "$file2" | \
    /mnt/binf/rui/bin/software/bin/sambamba view -t 8 -f bam -l 0 -S /dev/stdin | \
    /mnt/binf/rui/bin/software/bin/sambamba sort -m 12G --tmpdir "$tmp_dir" -t 8 -o "$output_dir/${base_name}.sort.bam" /dev/stdin

    # Step 2: Mark duplicates (gatk MarkDuplicates)
    gatk --java-options "-Xmx8G -XX:ParallelGCThreads=8" MarkDuplicates \
        -I "$output_dir/${base_name}.sort.bam" \
        -O "$output_dir/${base_name}.sort.rmdup.bam" \
        -M "$output_dir/${base_name}.sort.rmdup.metrics" \
        --TMP_DIR "$tmp_dir" \
        --REMOVE_DUPLICATES true --ASSUME_SORTED true --CREATE_INDEX true

    # Step 3: Move the index file to the correct location
    mv "$output_dir/${base_name}.sort.rmdup.bai" "$output_dir/${base_name}.sort.rmdup.bam.bai"

    ## Step 4: Recalibrate base quality scores using a custom script (SC_misc_MaskBam.py)
    #/mnt/binf/rui/bin/software/bin/sambamba view -t 2 -h "$output_dir/${base_name}.sort.rmdup.bam" | \
    #/mnt/binf/rui/bin/SC_misc_MaskBam.py ${base_name} - 2>"$output_dir/${base_name}.sort.rmdup.recal.log" | \
    #/mnt/binf/rui/bin/software/bin/sambamba view -t 2 -f bam -S -o "$output_dir/${base_name}.sort.rmdup.recal.bam" /dev/stdin

done
