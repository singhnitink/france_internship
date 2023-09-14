#!/bin/bash
# This file is used to rename beads
# CAB - CA; BB - C; OP - O; NP - N

# Usage: bash rename_beads.sh filename.gro

# Define the replacements
replacements=(
  's/\bCAB\b/ CA/g'
  's/\bBB\b/ C/g'
  's/\bOP\b/ O/g'
  's/\bNP\b/ N/g'
)

# Loop through the replacements and apply them to the file
for replacement in "${replacements[@]}"; do
  sed -i "$replacement" "$1"
done

echo "Replacements completed."
