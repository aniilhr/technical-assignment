#!/bin/bash
# Check whether a URL was provided.
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <CSV_URL>"
    exit 1
fi
CSV_URL="$1"
# Download the CSV into a temporary file.
TEMP_FILE=$(mktemp)
cleanup() {
    rm -f "$TEMP_FILE"
}
trap cleanup EXIT
if ! curl -L --fail --silent --show-error "$CSV_URL" -o "$TEMP_FILE"; then
    echo "Error: Failed to retrieve the CSV dataset."
    exit 1
fi
echo "Company Name | Location | Founded"
echo "---------------------------------------------"

# Skip the header, extract required columns and sort by founding year.
awk -F',' '
NR > 1 {
    company = $2
    location = $5
    founded = $8
    # Extract the first four-digit year.
    match(founded, /[0-9]{4}/, year)
    if (year[0] != "") {
        printf "%s|%s|%s\n", year[0], company, location
    }
}
' "$TEMP_FILE" |
sort -t'|' -k1,1n |
awk -F'|' '
{
    printf "%-6s | %-35s | %s\n", $1, $2, $3
}
'
