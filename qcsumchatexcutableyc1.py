import os
import json
import pandas as pd
import argparse
import glob


def process_json(input_files, output_file):
    all_data = []
    for input_file in input_files:
        try:
            # Load the JSON file
            with open(input_file, 'r') as file:
                data = json.load(file)

            # Extract data from the specified dictionaries
            summary_before = data.get('summary', {}).get('before_filtering', {})
            summary_after = data.get('summary', {}).get('after_filtering', {})
            filtering_result = data.get('filtering_result', {})

            # Perform the required calculations
            row = {
                "SampleID": input_file.replace('.json', ''),
                "LENGTH": int((summary_before.get('read1_mean_length', 0) + summary_before.get('read2_mean_length', 0)) / 2),
                "GC(%)": "{:.2f}%".format(summary_before.get('gc_content', 0) *100),
                "Q20%": "{:.2f}%".format(summary_before.get('q20_rate', 0)*100),
                "Q30(%)": "{:.2f}%".format(summary_before.get('q30_rate', 0)*100),
                "PF_READS": filtering_result.get('passed_filter_reads', 0),
                "CLEAN_READS": summary_before.get('total_reads', 0),
                "RATIO_OF_READS(%)":  "{:.2f}%".format(filtering_result.get('passed_filter_reads',1) /summary_before.get('total_reads', 0) * 100),
                "PF_BASES": summary_before.get('total_bases', 0),
                "CLEAN_BASES": summary_after.get('total_bases', 0),
                "RATIO_OF_BASES(%)": "{:.2f}%".format(summary_after.get('total_bases', 0) / summary_before.get('total_bases', 1) * 100),
                "CLEAN_Q20(%)": "{:.2f}%".format(summary_after.get('q20_rate', 0)*100),
                "CLEAN_Q30(%)": "{:.2f}%".format(summary_after.get('q30_rate', 0)*100),
            }

            # Append the row to the data list
            all_data.append(row)
        except Exception as e:
            print(f"Error processing file {input_file}: {e}")

    # Convert the list of dictionaries to a DataFrame
    df = pd.DataFrame(all_data)

    # Save the DataFrame to a TSV file
    df.to_csv(output_file, sep='\t', index=False)
    print(f"Processed data has been saved to {output_file}")


def main():
    parser = argparse.ArgumentParser(description="Process JSON files and generate TSV summary.")
    parser.add_argument("input_files", nargs='+', help="Paths to the input JSON files (e.g., '*.json')")
    parser.add_argument("output_file", help="Path to the output TSV file")
    args = parser.parse_args()

    # Expand wildcards (e.g., *.json) into file paths
    input_files = [file for pattern in args.input_files for file in glob.glob(pattern)]

    # Process the JSON files
    process_json(input_files, args.output_file)


if __name__ == "__main__":
    main()
