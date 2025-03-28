#!/bin/bash

# Script to convert Markdown files to PDF with support for Mermaid diagrams
# and using OpenDyslexic font for accessibility

# Check if an input file was specified
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 input.md [output.pdf]"
    exit 1
fi

# Get the input filename
input_file=$1

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File $input_file does not exist."
    exit 1
fi

# Determine the output filename
if [ "$#" -ge 2 ]; then
    output_file=$2
else
    # If no output filename is specified, use the same name with .pdf extension
    output_file="${input_file%.*}.pdf"
fi

# Create a temporary file for Mermaid preprocessing
temp_file="${input_file%.*}-processed.md"

echo "Converting $input_file to $output_file..."

# Preprocess the file to convert Mermaid diagrams to images
echo "Preprocessing Mermaid diagrams..."
./mermaid-preprocessor.sh "$input_file" "$temp_file"

# Set environment variables for docker-compose
export INPUT_FILE="$temp_file"
export OUTPUT_FILE="$output_file"

# Run docker-compose for the conversion
docker compose up --force-recreate

# Clean up after conversion
docker compose down

echo "Conversion complete. Output saved to $output_file"
