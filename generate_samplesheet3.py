#!/usr/bin/env python3

import pandas as pd
import argparse
import os


def generate_samplesheet(sample_list_path, template_path, index_path, machine_type, output_file):
    """
    Generates a SampleSheet based on the input sample list, template, and index file.
    Args:
        sample_list_path (str): Path to the sample list file.
        template_path (str): Path to the samplesheet template file.
        index_path (str): Path to the index file.
        machine_type (str): Type of sequencing machine ("illumina" or "mgi").
        output_file (str): Path to save the generated SampleSheet.
    """
    # Load the sample list
    sample_list = pd.read_csv(sample_list_path, sep="\t", header=None, names=["Lane", "Sample_Name", "I7_Index_ID"])

    # Load the index file
    index_data = pd.read_csv(index_path, sep="\t")

    # Load the template file
    with open(template_path, "r") as template_file:
        template_content = pd.read_csv(template_path, header=None)

    # Add Sample_ID as a numerical sequence
    sample_list["Sample_ID"] = range(1, len(sample_list) + 1)



    # Merge the sample list with the index file to get Index1 and Index2
    merged_data = pd.merge(sample_list, index_data, how="left", on="I7_Index_ID")

    # Add empty columns required for the samplesheet
    merged_data["Sample_Plate"] = ""
    merged_data["Sample_Well"] = ""
    merged_data["Sample_Project"] = ""
    merged_data["Description"] = "Panel"

    # Arrange columns in the desired order
    final_columns = [
    "Sample_ID", "Lane", "Sample_Name", "Sample_Plate", "Sample_Well",
    "I7_Index_ID", "index", "I5_Index_ID", "index2", "Sample_Project","Description"]
    final_samplesheet = merged_data[final_columns]

    # Save the final samplesheet to a CSV file
    with open(output_file, "w", newline="") as f:
        # Write the template content
        template_content.iloc[:16].to_csv(f, index=False, header=False)
        # Write the generated data
        final_samplesheet.to_csv(f, index=False)

    print(f"SampleSheet generated successfully at: {output_file}")


if __name__ == "__main__":
    # Parse arguments
    parser = argparse.ArgumentParser(description="Generate a SampleSheet for sequencing.")
    parser.add_argument("sample_list", type=str, help="Path to the sample.list file")
    parser.add_argument("template_file", type=str, help="Path to the samplesheet template file")
    parser.add_argument("index_file", type=str, help="Path to the index.tsv file")
    parser.add_argument("machine_type", type=str, choices=["illumina", "mgi"],
                        help="Sequencing machine type (illumina or mgi)")
    parser.add_argument("output_file", type=str, help="File path to save the generated SampleSheet")

    args = parser.parse_args()

    # Validate input files
    if not os.path.isfile(args.sample_list):
        print(f"Error: sample.list file not found at {args.sample_list}")
        exit(1)
    if not os.path.isfile(args.template_file):
        print(f"Error: template file not found at {args.template_file}")
        exit(1)
    if not os.path.isfile(args.index_file):
        print(f"Error: index file not found at {args.index_file}")
        exit(1)
    if not os.path.isdir(os.path.dirname(args.output_file)):
        print(f"Error: output directory not found at {os.path.dirname(args.output_file)}")
        exit(1)


    # Generate the SampleSheet
    generate_samplesheet(args.sample_list, args.template_file, args.index_file, args.machine_type, args.output_file)

