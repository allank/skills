#!/bin/bash

# Configuration
TEMPLATE_DIR="/Users/allank/Vaults/Personal/03. Resources/Templates"
DEFAULT_TEMPLATE="reference_template.docx"

# Help / Usage
usage() {
    echo "Usage: $0 <input_file.md> [output_file.docx]"
    echo "Converts a markdown file to a Google Docs-friendly DOCX using pandoc."
    echo "Looks for '$DEFAULT_TEMPLATE' in '$TEMPLATE_DIR' for styling."
    exit 1
}

# Input validation
INPUT_FILE="$1"
if [ -z "$INPUT_FILE" ]; then
    usage
fi

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

# Output handling
OUTPUT_FILE="$2"
if [ -z "$OUTPUT_FILE" ]; then
    # Change extension from .md (or anything) to .docx
    OUTPUT_FILE="${INPUT_FILE%.*}.docx"
fi

# Template handling
TEMPLATE_PATH="$TEMPLATE_DIR/$DEFAULT_TEMPLATE"
PANDOC_ARGS=""

if [ -f "$TEMPLATE_PATH" ]; then
    echo "Using reference template: $TEMPLATE_PATH"
    PANDOC_ARGS="--reference-doc=\"$TEMPLATE_PATH\""
else
    echo "No reference template found at $TEMPLATE_PATH (continuing without one)"
fi

# Execution
echo "Converting '$INPUT_FILE' to '$OUTPUT_FILE'..."
echo "Pipeline: md -> latex -> docx (for better formula support)"

# The magic double conversion
# We use eval to handle the quoted arguments correctly if PANDOC_ARGS is set
# shellcheck disable=SC2086
Result=$(pandoc -t latex "$INPUT_FILE" | pandoc -f latex -o "$OUTPUT_FILE" $PANDOC_ARGS 2>&1)

STATUS=$?

if [ $STATUS -eq 0 ]; then
    echo "✅ Success! Output saved to: $OUTPUT_FILE"
    # DO NOT use open -R here as it may hang the agent session
    echo "You can open it manually."
else
    echo "❌ Error during conversion. Pandoc exit code: $STATUS"
    echo "Output: $Result"
    exit $STATUS
fi
