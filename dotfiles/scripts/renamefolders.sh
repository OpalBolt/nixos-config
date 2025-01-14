#!/bin/zsh

# Check if correct number of arguments are provided
if [ "$#" -lt 3 ] || [ "$#" -gt 4 ]; then
    echo "Usage: $0 <from_string> <to_string> <directory> [auto]"
    exit 1
fi

# Source the log.sh script from the same directory
source "$(dirname "$0")/log.sh"

from_string="$1"
to_string="$2"
directory="$3"
confirmation="confirm"

if [ "$#" -eq 4 ] && [ "$4" == "auto" ]; then
    confirmation="auto"
fi

einfo "Starting string replacement process."
einfo "From: $from_string, To: $to_string, Directory: $directory"

# Function to confirm replacement
confirm_replace() {
    local file="$1"
    local new_filename="$2"

    # Prompt for confirmation
    printf "Replace '%s' with '%s' in '%s'? [y/N] " "$from_string" "$to_string" "$file"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        # Perform the replacement
        new_filename=$(echo "$file" | sed "s/$from_string/$to_string/")
        mv "$file" "$new_filename"
        einfo "Replaced '$from_string' with '$to_string' in '$file'."
        return 0
    else
        ewarn "Skipping replacement in '$file'."
        return 1
    fi
}

# Loop through each file in the directory and its subdirectories
for file in $directory/**/*$from_string*; do
    einfo "Performing string replacement in: $file"

    # Perform the replacement
    if [ "$confirmation" = "confirm" ]; then
        confirm_replace "$file"
    else
        # Perform the replacement without confirmation
        new_filename=$(echo "$file" | sed "s/$from_string/$to_string/")
        mv "$file" "$new_filename"
        einfo "Replaced '$from_string' with '$to_string' in '$file'."
    fi
done

einfo "String replacement process completed."

