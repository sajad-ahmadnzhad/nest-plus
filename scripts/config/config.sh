#!/bin/bash

# Color for messages
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
RESET='\e[0m'

INSTALL_PACKAGES_FILE="/tmp/install_packages.sh"

function cleanupTmpFile() {
  if [[ -f "$INSTALL_PACKAGES_FILE" ]]; then
    rm -f "$INSTALL_PACKAGES_FILE"
  fi
}

# Array to hold the names of packages to be installed in the future
function savePackages(){
  if [ -f $INSTALL_PACKAGES_FILE ]; then
    source $INSTALL_PACKAGES_FILE
    else 
    INSTALL_PACKAGES=()
  fi

  INSTALL_PACKAGES+=($@)

  declare -p INSTALL_PACKAGES > $INSTALL_PACKAGES_FILE
}