#!/bin/bash

# Source other bash scripts
. ./log.sh

# Running examples:
# source daily

# Setting variables
today=$(date +"%Y%m%d")
dailypath="$SECOND_BRAIN/daily-notes"

# Function to fetch the newest daily file
get_newest_daily() {
    # Create array of files from daily path
    edebug "loading array from $dailypath"
    filearray=($("ls" -r $dailypath))

    # Put the newest daily file into a variable
    edebug "defineing newest_daily to be: ${filearray[1]}"
    newest_daily=${filearray[1]}
    edebug "newest_daily: $newest_daily"
}

# Function that opens or creates todays daily file, this would also create the
# file if its missing
open_file() {
    if [ -e "$dailypath/$today.md" ]; then
        # CD Into dailypath directory
        cd "$dailypath" || exit

        # Opens daily file in Neovim
        edebug "open's op today.md"
        nvim "$dailypath/$today.md"
    else
        # Runs function that finds the newest daily file
        edebug "start function to get newest daily"
        get_newest_daily

        # Sets up timestamp to use later
        timestamp=$(date +"%Y-%m-%d")

        # CD into daily path
        edebug "cd into dailypath"
        cd "$dailypath" || exit

        # Create daily file
        edebug "Create $today.md file"
        touch "$today.md"

        # input all content into today that is needed
        edebug "fill out $today.md with default infomation"
        tee "$today.md" <<EOF
---
date: $(date +"%Y-%m-%d")
tag:
- daily
---
## Notes

EOF
        # Opens up todays note in Neovim
        edebug "open up $today.md with neovim"
        nvim "$today.md"

    fi
}

# Run openfile function
edebug "trying to run open_file function"
open_file
