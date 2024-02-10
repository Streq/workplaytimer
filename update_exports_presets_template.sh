#!/bin/bash

filename="export_presets.cfg"
output_file="export_presets.cfg.template"

# Regex patterns
pattern='(.*((keystore)|(password)).*)="(.+)"'
replacement='\1=""'

echo "Copying non-sensitive data from $filename to $output_file"

# Perform the replacement and save to a new file
sed -E "s#$pattern#$replacement#g" "$filename" > "$output_file"

echo "Replacement completed."
