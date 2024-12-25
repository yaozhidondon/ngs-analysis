#!/bin/bash
source /mnt/binf/rui/bestpractice/env_bashrc
export PATH=/mnt/binf/rui/bin/jdk-17.0.2/bin:$PATH
export PATH=/mnt/binf/rui/bin/miniconda3/bin:$PATH
source ~/.bashrc


# Input and output directories
input_dir="/mnt/binf/yaochen/bestpractice/scripts/02BAMdebug"   # Directory containing input BAM files
output_dir="/mnt/binf/yaochen/bestpractice/scripts/03picardmetrics" # Directory for output files

# Ensure the output directory exists
mkdir -p "$output_dir"

# Reference genome file (update path if needed)
reference_fasta="/mnt/binf/rui/database/reference/hs37d5/hs37d5.fa"

# Loop through all BAM files in the input directory
for bam_file in "$input_dir"/*sort.rmdup.bam; do

    # Get the base name of the BAM file (without extension)
    base_name=$(basename "$bam_file" sort.rmdup.bam)

    # Run Picard CollectAlignmentSummaryMetrics with the BED file
    java -jar /mnt/binf/rui/bin/jars/picard.jar CollectHsMetrics \
        -I $bam_file \
        -R $reference_fasta \
        -O "$output_dir/${base_name}hs_metrics.txt" \
        -TARGET_INTERVALS /mnt/binf/yaochen/bestpractice/scripts/intervals/mrdultra_v2.0.0.flank150_list.interval_list \
        -BAIT_INTERVALS /mnt/binf/yaochen/bestpractice/scripts/intervals/mrdultra_v2.0.0.raw_list.interval_list \
        -USE_JDK_INFLATER true \
        -USE_JDK_DEFLATER true
    
    echo "Processed $bam_file"
done

