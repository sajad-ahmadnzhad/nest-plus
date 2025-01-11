#!/bin/bash
source helpers.sh

# Validates user input for a project name, requiring at least one word.
while true; do
    read -p "$(echo -e "${BLUE}Please enter project name: ${RESET}")" "PROJECT_NAME"

    # Extract the first word and check if it is empty.
    PROJECT_NAME=$(echo "$PROJECT_NAME" | cut -d' ' -f1)
    if [ -z "$PROJECT_NAME" ]; then
     echo -e "${RED}Project name is required${RESET}"
    else break
    fi
done

# Get the selected package manager
get_package_manager $PACKAGE_MANAGER