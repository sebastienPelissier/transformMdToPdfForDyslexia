#!/bin/bash

# Check if a filename was provided
if [ -z "$1" ]; then
    echo "Error: No input file specified."
    echo "Usage: ./md2pdf.sh input.md [output.pdf]"
    exit 1
fi

# Get the input filename
INPUT_FILE="$1"

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

# Determine the output filename
if [ -z "$2" ]; then
    # If no output filename is provided, use the input filename with .pdf extension
    OUTPUT_FILE="${INPUT_FILE%.md}.pdf"
else
    OUTPUT_FILE="$2"
fi

echo "Converting $INPUT_FILE to $OUTPUT_FILE..."

# Update the docker-compose.yml file with the current filenames
sed -i "s|command: .*|command: [\"$INPUT_FILE\", \"-o\", \"$OUTPUT_FILE\", \"--template=template.tex\", \"--pdf-engine=xelatex\"]|" docker-compose.yml

# Run the docker compose command with force-recreate to avoid container conflicts
docker compose up --force-recreate

# Clean up the container after conversion
docker compose down

echo "Conversion complete. Output saved to $OUTPUT_FILE"
