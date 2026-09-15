#!/bin/bash

# 1. Verification of Arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <samples_directory> <operation>"
    exit 1
fi

SAMPLES_DIR="$1"
OPERATION="$2"

# Check if samples directory exists
if [ ! -d "$SAMPLES_DIR" ]; then
    echo "Error: Directory $SAMPLES_DIR does not exist."
    exit 2
fi

# 2. Function for processing a single sample
process_sample() {
    local file="$1"
    echo "[$(date)] Processing $file for operation: $OPERATION" >> logs/pipeline.log

    # DNA check using grep (looks for Thymine 'T')
    if grep -q "T" "$file"; then
        echo "$file -> Result: DNA Sample Detected" >> reports/pipeline_report.txt
        cp "$file" backup/
    else
        echo "$file -> Result: Non-DNA Sample (RNA/Protein)" >> reports/pipeline_report.txt
    fi
}

# 3. Case statement for operations
case "$OPERATION" in
    "scan")
        echo "--- Starting Pipeline Run: $(date) ---" >> reports/pipeline_report.txt
        echo "[$(date)] Pipeline started on $SAMPLES_DIR" >> logs/pipeline.log
        
        # 4. For loop over sample files
        for file in "$SAMPLES_DIR"/*.txt; do
            if [ -f "$file" ]; then
                process_sample "$file"
            fi
        done
        
        echo "[$(date)] Pipeline completed successfully." >> logs/pipeline.log
        echo "Scan completed. Check reports/pipeline_report.txt and logs/pipeline.log"
        exit 0
        ;;
    *)
        echo "Invalid operation: $OPERATION. Use 'scan'."
        exit 3
        ;;
esac

