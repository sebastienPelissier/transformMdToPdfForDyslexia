# Markdown to PDF Converter

A tool for converting Markdown documents to PDF with accessibility features, particularly using the OpenDyslexic font to improve readability for people with dyslexia.

## Project Structure

```
.
├── docker-compose.yml    # Docker configuration for the conversion process
├── md2pdf.sh            # Conversion script
├── template.tex         # LaTeX template with OpenDyslexic font configuration
├── style.css            # CSS styling for HTML output (if needed)
├── fonts/               # Directory containing font files
│   └── OpenDyslexic/    # OpenDyslexic font directory
│       ├── OpenDyslexic-Regular.otf
│       ├── OpenDyslexic-Bold.otf
│       ├── OpenDyslexic-Italic.otf
│       └── OpenDyslexic-Bold-Italic.otf
```

## Requirements

- Docker and Docker Compose
- Bash shell

## Usage

To convert a Markdown file to PDF:

```bash
./md2pdf.sh input.md [output.pdf]
```

### Parameters:

- `input.md`: The Markdown file you want to convert (required)
- `output.pdf`: The name of the output PDF file (optional - defaults to the same name as the input file with .pdf extension)

### Examples:

```bash
# Convert summary.md to summary.pdf
./md2pdf.sh summary.md

# Convert summary.md to custom-output.pdf
./md2pdf.sh summary.md custom-output.pdf
```

## Features

- Uses the OpenDyslexic font family for improved readability
- Converts Markdown to PDF using Pandoc via Docker
- Customizable LaTeX template for PDF generation
- Preserves formatting, links, and images from the Markdown source
- Supports code blocks and syntax highlighting
- Handles tables and other complex Markdown elements

## How It Works

1. The script takes your Markdown file as input
2. It updates the docker-compose.yml file with your specified input and output filenames
3. Docker Compose runs the pandocker image (based on Pandoc) with `--force-recreate` to avoid container conflicts
4. After conversion, containers are automatically cleaned up with `docker compose down`
5. The conversion uses XeLaTeX as the PDF engine for proper font rendering
6. The template.tex file provides the LaTeX configuration with OpenDyslexic font
7. The final PDF is generated with improved readability for people with dyslexia

## Troubleshooting

If you encounter any issues:

- Make sure Docker and Docker Compose are installed and running
- Verify that the fonts directory contains all required OpenDyslexic font files
- Check that your Markdown file exists and is properly formatted
- For complex Markdown with special elements, you may need to adjust the template.tex file

## License

This tool is provided as open source software. Feel free to modify and distribute according to your needs.
