#!/bin/bash
source /mnt/binf/rui/bestpractice/env_bashrc
export PATH=/mnt/binf/rui/bin/jdk-17.0.2/bin:$PATH
export PATH=/mnt/binf/rui/bin/miniconda3/bin:$PATH
export PICARD_HOME="/mnt/binf/rui/bin/jars"  # The folder containing picard.jar
export PATH="$PICARD_HOME:$PATH"
source ~/.bashrc


# Input and output directories
input_dir="/mnt/binf/rui/database/beds"   # Directory containing input BAM files
output_dir="/mnt/binf/yaochen/bestpractice/scripts/intervals" # Directory for output files


# Ensure the output directory exists
mkdir -p "$output_dir"

# Reference genome file (update path if needed)
reference_fasta="/mnt/binf/rui/database/reference/hs37d5/hs37d5.fa"

# Loop through all BAM files in the input directory
for bed_file in "$input_dir"/*.bed; do
    # Get the base name of the BAM file (without extension)
    base_name=$(basename "$bed_file" .bed)

    # Run Picard CollectAlignmentSummaryMetrics with the BED file
    java -jar -Xmx12g /mnt/binf/rui/bin/jars/picard.jar BedToIntervalList \
        I="$bed_file" \
        O="$output_dir/${base_name}_list.interval_list" \
        SD="$reference_fasta" \
        
done

