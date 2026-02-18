---
name: markdown-publisher
description: Converts Markdown files to Google Docs-friendly DOCX format using Pandoc (via a helper script).
---

# Markdown Publisher Skill

This skill allows you to convert Markdown files into `.docx` files optimized for import into Google Docs. It handles LaTeX formulas by converting them to native Word equations (via an intermediate LaTeX step).

## When to Use
Use this skill when the user asks to:
- "Publish" a note or document.
- "Convert this to Google Docs" or "Make a GDoc".
- "Export to Word" or "Create a DOCX".
- "Prepare this for sharing".

## How to Use

1.  **Identify the Input File**:
    - If the user specifies a file, use that.
    - If no file is specified, **assume the currently active file**.

2.  **Run the Conversion Script**:
    - Execute the `md2gdoc.sh` script located in the `scripts` subdirectory of this skill.
    - Path: `.agent/skills/markdown-publisher/scripts/md2gdoc.sh` (resolve to absolute path).

    ```bash
    # Syntax
    /path/to/scripts/md2gdoc.sh <input_file_absolute_path>
    ```

3.  **Confirm Success**:
    - The script will output "✅ Success!" and reveal the file in Finder if successful.
    - Report the location of the generated file to the user.

## Dependencies
- `pandoc` must be installed on the system (User confirmed it is).
- `reference_template.docx` (optional) in `03. Resources/Templates/` for styling.

## Troubleshooting
- If the script fails, check if the input file path has spaces and ensure it's quoted.
- If formulas aren't rendering, ensure they are standard LaTeX format (`$..$` or `$$..$$`).
