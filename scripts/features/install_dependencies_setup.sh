#!/bin/bash
source scripts/config/config.sh

function installPackages() {
  source "$INSTALL_PACKAGES_FILE"
  cd $PROJECT_NAME
  echo -e "${BLUE}Please Wait for installing npm packages.....${RESET}"
  echo -e "${YELLOW}If there is a problem installing the packages, enter the following command: $2 ${INSTALL_PACKAGES[@]}${RESET}"
  command $2 "${INSTALL_PACKAGES[@]}"

  cleanupTmpFile
  echo -e "${GREEN}Thanks for using nest-plus${RESET}"
  echo -e "${BLUE}Starting project....${RESET}"
  command $3 "start:dev"
}
