#!/bin/bash

# Color for messages
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
RESET='\e[0m'

# Get the selected package manager
function get_package_manager(){
local $PROJECT_NAME=$1

# Create a new NestJS project with the specified name and save the output
local OUTPUT=$(npx nest new "$PROJECT_NAME" --skip-install 2>&1 | tee /dev/tty)

# Remove ANSI color codes from the output for cleaner processing
local CLEAN_OUTPUT=$(echo "$OUTPUT" | sed 's/\x1B\[[0-9;]*[a-zA-Z]//g')

# Extract the selected package manager name from the cleaned output
PACKAGE_MANAGER=$(echo "$CLEAN_OUTPUT" | grep -oP "(?<=Which package manager would you ❤️  to use\\? ).*" | tail -1)

if [[ ! -n "$PACKAGE_MANAGER" ]]; then
    echo -e "${RED}no package manager selected.${RESET}"
    exit 1
fi

cd "$PROJECT_NAME"

return 0
}

# Get the entered project name
function get_project_name(){
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

return 0
}

# Setup env files
function setup_envs(){
    touch .env
    touch .env.example

cat << EOF > ".env"
#Application configs
PORT=4000
EOF
}