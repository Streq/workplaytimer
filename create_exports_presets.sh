#!/bin/bash

cfg="export_presets.cfg"
cfg_template="export_presets.cfg.template"

# if no cfg_template then return
if [ ! -f "$cfg_template" ]; then
    echo "no $cfg_template file found"
    exit 1
fi


# Create cfg if it doesn't exist and paste contents from cfg_template
if [ ! -f "$cfg" ]; then
    cp "$cfg_template" "$cfg"
    exit 0
fi

# Regex pattern
pattern='(.*((keystore)|(password)).*)="(.+)"'

# Temporarily store the lines from file A that match the regex
temp_file=$(mktemp)
grep -E "$pattern" "$cfg" > "$temp_file"

echo "showing temp file"
cat "$temp_file"

# Overwrite file A with the contents of file B
cp "$cfg_template" "$cfg"

# Replace lines in file A with corresponding lines from temp_file
while IFS= read -r line; do
    key=$(echo "$line" | sed -E "s/$pattern/\1/")
    echo "found key $key"
    escaped_key=$(sed 's/[][\/$*.^|]/\\&/g' <<< "$key")
    echo "escaped into $escaped_key"
    echo "running: sed -i -E '/$escaped_key/c$line' '$cfg'"
    sed -i -E "/$escaped_key/c$line" "$cfg"
done < "$temp_file"

# Remove the temporary file
rm "$temp_file"

echo "Replacement completed. File A updated with matched lines from File B."
