#!/bin/bash

# Preprocessing script to convert Mermaid blocks to images
# Usage: ./mermaid-preprocessor.sh input.md output.md

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 input.md output.md"
    exit 1
fi

INPUT_FILE=$1
OUTPUT_FILE=$2
TEMP_DIR="mermaid-temp"
DIAGRAM_DIR="mermaid-diagrams"

# Create temporary directories if they don't exist
mkdir -p $TEMP_DIR
mkdir -p $DIAGRAM_DIR

# Ensure proper permissions
chmod -R 777 $TEMP_DIR $DIAGRAM_DIR

# Clear the output file if it already exists
> "$OUTPUT_FILE"

# Counter for diagrams
DIAGRAM_COUNT=0

# Read the input file line by line
{
    in_mermaid_block=false
    mermaid_content=""
    output_content=""
    
    while IFS= read -r line; do
        # Detect the start of a Mermaid block
        if [[ "$line" == '```mermaid' ]]; then
            in_mermaid_block=true
            mermaid_content=""
            continue
        fi
        
        # Detect the end of a Mermaid block
        if [[ "$in_mermaid_block" == true && "$line" == '```' ]]; then
            in_mermaid_block=false
            DIAGRAM_COUNT=$((DIAGRAM_COUNT + 1))
            DIAGRAM_FILE="${DIAGRAM_DIR}/diagram-${DIAGRAM_COUNT}.png"
            
            # Write Mermaid content to a temporary file
            echo "$mermaid_content" > "${TEMP_DIR}/diagram-${DIAGRAM_COUNT}.mmd"
            
            # Convert Mermaid diagram to image using Docker
            echo "Converting diagram ${DIAGRAM_COUNT}..."
            
            # Fix output path and add user permissions
            # Add options to control image size and background
            docker run --rm --user $(id -u):$(id -g) \
                -v "$(pwd)/${TEMP_DIR}:/data" \
                -v "$(pwd)/${DIAGRAM_DIR}:/output" \
                minlag/mermaid-cli \
                -i "/data/diagram-${DIAGRAM_COUNT}.mmd" \
                -o "/output/diagram-${DIAGRAM_COUNT}.png" \
                -w 800 -H 600 -b transparent
            
            # Check if the image was created
            if [ -f "$DIAGRAM_FILE" ]; then
                echo "Diagram ${DIAGRAM_COUNT} successfully converted."
                # Add the image reference to the output content
                # Use raw LaTeX syntax to force the image to stay in place
                output_content="${output_content}
\`\`\`{=latex}
\\begin{figure}[H]
\\centering
\\includegraphics[width=0.9\\linewidth]{${DIAGRAM_FILE}}
\\end{figure}
\`\`\`
"
            else
                echo "Error: Failed to convert diagram ${DIAGRAM_COUNT}."
                # Include the original Mermaid block as fallback
                output_content="${output_content}\`\`\`mermaid
$mermaid_content
\`\`\`
"
            fi
            continue
        fi
        
        # Collect Mermaid block content
        if [[ "$in_mermaid_block" == true ]]; then
            mermaid_content="${mermaid_content}${line}
"
            continue
        fi
        
        # Add normal lines to output content
        output_content="${output_content}${line}
"
    done

    # Write all content to the output file
    echo -n "$output_content" > "$OUTPUT_FILE"
    
} < "$INPUT_FILE"

echo "Preprocessing complete. ${DIAGRAM_COUNT} Mermaid diagrams processed."
