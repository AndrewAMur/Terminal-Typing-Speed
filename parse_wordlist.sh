#!/bin/bash

INPUT_FILE="5664-freq-treegle-may.txt"
OUTPUT_FILE="wordlist.txt"

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Input file not found!"
    exit 1
fi

# Create or clear the output file
> "$OUTPUT_FILE"

# Skip the first three lines and parse the rest
while IFS=, read -r count word; do
    echo "$word" >> "$OUTPUT_FILE"
done < <(tail -n +4 "$INPUT_FILE")

echo "Parsed words have been written to $OUTPUT_FILE"

