#!/bin/bash
set -e

# Source other bash scripts
MYDIR="$(dirname "$(realpath "$0")")"
source $MYDIR/color.sh
# takes a date and time, and returns the same moment in different time zones.

Now=$(date "+%F %Z")
NowDK=$(date +"%H:%M:%S")
DateCmd='date +%a,%FT-%H:%M(%:z)%Z -d '
DateStamp=${@:-$"Now"}

echo -e "    LOCAL TIME:  ${GREEN}${BOLD}${NowDK}${NONE}"

echo "      UTC:        $(TZ=Etc/UTC ${DateCmd} "${DateStamp}")"
echo "      CET:        $(TZ=Etc/CET ${DateCmd} "${DateStamp}")"
echo "      Copenhagen: $(TZ=Europe/Copenhagen ${DateCmd} "${DateStamp}")"
echo "      Finland:    $(TZ=Europe/Helsinki ${DateCmd} "$DateStamp")"
echo "      Florida:    $(TZ=America/New_York ${DateCmd} "$DateStamp")"
