#!/bin/bash


# Input and output directories
input_dir="/mnt/binf/rui/Debug_test/241218_debug"
output_dir="/mnt/binf/yaochen/bestpractice/scripts/02BAMdebug"

# Ensure output directory exists
mkdir -p "$output_dir"

# Loop through all paired-end fastq files in the input directory
for file1 in "$input_dir"/*_R1_001.fastq.gz; do
    # Derive the corresponding R2 file name
    file2="${file1/_R1_001.fastq.gz/_R2_001.fastq.gz}"

    # Extract base name without file extension to use in output files
    base_name=$(basename "$file1" _R1_001.fastq.gz)

    # Run fastp for the current pair of fastq files
    /mnt/binf/rui/bin/software/bin/fastp \
        -i "$file1" \
        -I "$file2" \
        -o "$output_dir/${base_name}_clean_R1.fastq.gz" \
        -O "$output_dir/${base_name}_clean_R2.fastq.gz" \
        --unpaired1 "$output_dir/${base_name}_unpaired_R1.fastq.gz" \
        --unpaired2 "$output_dir/${base_name}_unpaired_R2.fastq.gz" \
        --failed_out "$output_dir/${base_name}_failed.fastq.gz" \
        --json "$output_dir/${base_name}.fastp.json" \
        --html "$output_dir/${base_name}.fastp.html" \
        --detect_adapter_for_pe -w 10 \
        --cut_tail \
        --cut_tail_window_size 1 \
        --cut_tail_mean_quality 15 \
        --cut_right \
        --cut_right_window_size 5 \
        --cut_right_mean_quality 20 \
        --average_qual 20 \
        --length_required 30 \
        --disable_trim_poly_g

done

