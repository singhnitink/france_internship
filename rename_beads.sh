#!/bin/bash
#This file is used to rename beads
#CAB - CA;BB - C;OP - O;NP - N

#bash rename_beads.sh filename.gro

# Define the replacements
replacements=(
  's/CAB/ CA/g'
  's/BB/ C/g'
  's/OP/ O/g'
  's/NP/ N/g'
)

# Loop through the replacements and apply them to the file
for replacement in "${replacements[@]}"; do
  sed -i "$replacement" $1
done

echo "Replacements completed."
