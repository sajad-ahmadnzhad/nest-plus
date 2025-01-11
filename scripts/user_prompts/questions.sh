#!/bin/bash

# Function to prompt user for a yes/no response, defaults to 'yes' if invalid.
function promptYesOrNo() {
    read -p "$1 [Y/n]: " "INPUT"

    # Check if the input is empty or not 'y', 'Y', 'n', or 'N'
    if [[ -z "$INPUT" || ! "$INPUT" =~ ^[yYnN]$ ]]; then
        INPUT='y'
    fi

    # Convert the input to lowercase for consistency
    INPUT=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')
    
    return 0
}