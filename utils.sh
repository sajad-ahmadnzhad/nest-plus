#!/bin/bash

function yesOrNo() {
    read -p "$1 Y/N: " "INPUT"

    if [[ -z "$INPUT" || ! "$INPUT" =~ ^[yYnN]$ ]]; then
        INPUT='y'
    fi

    INPUT=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')
    
    return 0
}