#!/usr/bin/env python3

import pandas as pd
import argparse
import os

def process_id_list(id_list_file):
    """Process the id.list file to strip 'IDTV2' and tab delimiters."""
    id_list_df = pd.read_csv(id_list_file, header=None, engine='python', names=["Sample"])
    id_list_df["Sample"] = id_list_df["Sample"].str.replace("IDTV2", "", regex=False).str.strip()
    return id_list_df["Sample"].tolist()

def process_kit_file(kit_file):
    """Read and return the content of kit.txt."""
    with open(kit_file, "r") as f:
        return f.read().strip()

def process_id_pair(id_pair_file):
    """Process the id.pair file to generate pairs."""
    id_pairs = pd.read_csv(id_pair_file, header=None, sep='\s+', names=["Sample1", "Sample2"])
    return id_pairs

def generate_config(cleaned_id_list, kit, id_pairs, module, output_file):
    """Generate the configuration file."""
    config_lines = []

    # Step 1: Add sample details
    for sample in cleaned_id_list:
        config_lines.append(f"{sample}:")
        config_lines.append("  isclean: false")
        config_lines.append("  istumor: true")
        config_lines.append(f"  kit: {kit}")
        config_lines.append("  machine: NovaSeq")
        config_lines.append("  panel: SureSelectv6")
        config_lines.append("  stype: FFPE")
        config_lines.append("  umi: umi")


    # Step 2: Add cln and module
    config_lines.append("cln: false")
    config_lines.append(f"module: {module}")


    # Step 3: Add pairs
    config_lines.append("pairs:")
    for _, row in id_pairs.iterrows():
        sample1, sample2 = row["Sample1"], row["Sample2"]
        config_lines.append(f"  {sample1}: {sample2}")


    # Step 4: Add sample list
    config_lines.append("Sample:")
    for sample in cleaned_id_list:
        config_lines.append(f"- {sample}")

    # Write to output file
    with open(output_file, "w") as f:
        f.write("\n".join(config_lines))

    print(f"Configuration file generated at: {output_file}")

def main():
    """Main function to handle argument parsing and execution."""
    # Setup argument parser
    parser = argparse.ArgumentParser(description="Generate a configuration file from input files.")
    parser.add_argument("id_list", help="Path to the ID list file (e.g., id.list)")
    parser.add_argument("id_pair", help="Path to the ID pair file (e.g., id.pair)")
    parser.add_argument("kit", help="Path to the kit file (e.g., kit.txt)")
    parser.add_argument("--module", default="snv", help="Specify the module (default: cnv)")
    parser.add_argument("output", help="Path to the output configuration file (e.g., output.config)")


    args = parser.parse_args()

    # Process files
    cleaned_id_list = process_id_list(args.id_list)
    kit = process_kit_file(args.kit)
    id_pairs = process_id_pair(args.id_pair)

    # Generate configuration
    generate_config(cleaned_id_list, kit, id_pairs, args.module, args.output)

if __name__ == "__main__":
    main()

