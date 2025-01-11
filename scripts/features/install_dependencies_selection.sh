#!/bin/bash
source scripts/features/install_dependencies_setup.sh

case $PACKAGE_MANAGER in 
    "npm")
    installPackages "npm install" "npm install" "npm run"
    ;;
    "yarn")
    installPackages "npx yarn install" "npx yarn add" "npx yarn"
    ;;
    "pnpm") 
    installPackages "npx pnpm install" "npx pnpm add" "npx pnpm"
    ;;
    *)
    echo -e "${RED}Package manager not selected${RESET}"
    exit 1
esac