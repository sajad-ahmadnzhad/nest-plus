#!/bin/bash
source scripts/config/config.sh

function installPackages() {
  source "$INSTALL_PACKAGES_FILE"
  cd $PROJECT_NAME
  echo -e "${BLUE}Please Wait for installing ${INSTALL_PACKAGES[@]} packages.....${RESET}"
  echo -e "${YELLOW}If there is a problem installing the packages, enter the following command: $2 ${INSTALL_PACKAGES[@]}${RESET}"
  command $2 "${INSTALL_PACKAGES[@]}"

  echo -e "${BLUE}Wait for installing additional packages.....${RESET}"
  echo -e "${YELLOW}If there is a problem installing the packages, enter the following command: $1${RESET}"
  command $1

  cleanupTmpFile
  echo -e "${GREEN}Thanks for using nest-plus${RESET}"
  echo -e "${BLUE}Starting project....${RESET}"
  command $3 "start:dev"
}
