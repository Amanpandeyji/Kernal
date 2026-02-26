#!/bin/bash

# LaTeX Documentation Compilation Script
# Compiles the project documentation to PDF

set -e

echo "===================================="
echo "Compiling LaTeX Documentation"
echo "===================================="

# Check if pdflatex is available
if ! command -v pdflatex &> /dev/null; then
    echo "ERROR: pdflatex not found!"
    echo "Please install TeX Live:"
    echo "  Ubuntu/Debian: sudo apt-get install texlive-full"
    echo "  Fedora: sudo dnf install texlive-scheme-full"
    echo "  macOS: brew install --cask mactex"
    exit 1
fi

# File name
TEXFILE="project_documentation.tex"
PDFFILE="project_documentation.pdf"

echo "Compiling $TEXFILE..."

# First pass
pdflatex -interaction=nonstopmode "$TEXFILE" > /dev/null 2>&1

# Second pass (for TOC and references)
pdflatex -interaction=nonstopmode "$TEXFILE" > /dev/null 2>&1

# Third pass (to resolve all references)
pdflatex -interaction=nonstopmode "$TEXFILE" > /dev/null 2>&1

# Clean up auxiliary files
echo "Cleaning up auxiliary files..."
rm -f *.aux *.log *.out *.toc *.lof *.lot

echo ""
echo "SUCCESS! PDF generated: $PDFFILE"
echo ""
echo "To view:"
echo "  Linux: xdg-open $PDFFILE"
echo "  macOS: open $PDFFILE"
echo "  Windows: start $PDFFILE"
echo ""
