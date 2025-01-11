#!/bin/bash
source ../user_prompts/question.sh

# Color for messages
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
RESET='\e[0m'

# Get the selected package manager
function get_package_manager(){
local $PROJECT_NAME=$1

# Array to hold the names of packages to be installed in the future
INSTALL_PACKAGES=()

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

# Add default envs
cat << EOF > ".env"
#Application configs
PORT=4000
EOF
}

# Setup base app module
function setupAppModule() {
cat << 'EOF' > src/modules/app/app.module.ts
import { Module } from '@nestjs/common';

@Module({
    imports: [],
    controllers: [],
    providers: []
})
export class AppModule {}
EOF
    return 0
}

# Updates the path of the main application file
function modifyMainFile(){
  sed -i "2s/app.module/modules\/app\/app.module/" "src/main.ts"

  return 0
}

# Removes ESLint and Prettier configuration files and updates the package.json.
function removePrettierAndESLint(){
promptYesOrNo "$(echo -e "${YELLOW}prettierrc and eslintrc.js be removed?${RESET}")"

if [ $INPUT = "y" ]; then 
    rm .eslintrc.js
    rm .prettierrc
    # Remove lines from package.json
    sed -i "10d;15d;37,41d;43d" package.json
fi

return 0
}

# Removes Test configuration files and updates the package.json.
function removeTestFiles(){
promptYesOrNo "$(echo -e "${YELLOW}Test files are deleted?${RESET}")"

if [ $INPUT = "y" -a -d "test" ]; then
rm -rf 'test'
rm src/app.controller.spec.ts

# Remove specific lines from package.json based on the presence of .eslintrc.js and .prettierrc files
if [ -f ".eslintrc.js" -a -f ".prettierrc" ]; then
    sed -i "16,20d;32d;34d;36d;42d;45,46d;52,68d" package.json
    sed -i "15s/,$//;40s/,$//" package.json
else 
    sed -i "14,18d;30d;32d;34,35d;37,38d;44,60d" package.json
    sed -i "13s/,$//;32s/,$//" package.json
fi

fi

return 0
}