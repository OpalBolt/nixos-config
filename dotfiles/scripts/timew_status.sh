#!/usr/bin/env bash

# Get timew status
# The output format is:
# Tracking <tags>
#   Started <timestamp>
#   Current <timestamp>
#   Total   <duration>
# Or:
# There is no active time tracking.

STATUS=$(timew 2>/dev/null)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ] || echo "$STATUS" | grep -q "no active time tracking"; then
    # Inactive state
    exit 0
fi

# Check for annotation using export
# We look for the interval that doesn't have an "end" time
HAS_ANNOTATION=$(timew export | grep -v '"end":' | grep '"annotation":')

if [ -z "$HAS_ANNOTATION" ]; then
    ICON="❗"
else
    ICON="󱎫"
fi

# Extract tags (first line, everything after "Tracking ")
TAGS=$(echo "$STATUS" | grep "Tracking" | sed 's/Tracking //')

# Count tags
TAG_COUNT=$(echo "$TAGS" | wc -w)

# Extract total duration (line with "Total", last column)
DURATION=$(echo "$STATUS" | grep "Total" | awk '{print $NF}')

# Output format for Starship
if [ "$TAG_COUNT" -gt 1 ]; then
    # Multiple tags - warning
    echo "$ICON $TAGS ($DURATION)!"
else
    # Single tag
    echo "$ICON $TAGS ($DURATION)"
fi