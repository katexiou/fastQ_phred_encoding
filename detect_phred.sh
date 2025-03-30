#!/bin/bash

# Create directories
mkdir -p phred33 phred64

# Function to detect Phred encoding
detect_phred_encoding() {
    local file=$1
    local quality_scores=$(awk 'NR==4 {print; exit}' "$file")
    local converted_char=$(echo -n "$quality_scores" | od -An -t d1 | awk 'NR==1 {print $1}')  # Convert first character to ASCII with od

    if (( converted_char >= 33 && converted_char <= 74 )); then
        echo "Phred+33 is detected in $file"
        mv "$file" phred33/  # Move file to phred33 folder
    elif (( converted_char >= 64 && converted_char <= 104 )); then
        echo "Phred+64 is detected in $file"
        mv "$file" phred64/  # Move file to phred64 folder
    else
        echo "Unknown encoding detected in $file"
    fi
}

# Loop through all FASTQ files to classify them
for file in mock_reads_*.fastq; do
    detect_phred_encoding "$file"
done

echo "Encoding of all FASTQ files completed!"
