#!/bin/bash

function retryCommand() {
  local command=$1
  local max_retries=$2
  local description=$3
  local retry_count=0

  while [ $retry_count -lt $max_retries ]; do
    if [ $retry_count != 0 ]; then
    echo -e "${BLUE}${description}... Attempt $(($retry_count + 1))/${max_retries}${RESET}"
    fi
   command $command
    if [ $? -eq 0 ]; then
      return 0
    fi
    echo -e "${RED}Failed to execute: ${description}, retrying...${RESET}"
    ((retry_count++))
  done

  echo -e "${RED}${description} failed after ${max_retries} attempts.${RESET}"
  return 1
}

function installPackages() {
  echo -e "${BLUE}Please Wait for installing ${INSTALL_PACKAGES[@]} packages.....${RESET}"
  
  retryCommand "$1" 3 "Installing base packages"
  if [ $? -ne 0 ]; then
    return 1
  fi

  echo -e "${BLUE}Wait for installing additional packages.....${RESET}"
  retryCommand "$2 ${INSTALL_PACKAGES[@]}" 3 "Installing additional packages"
  if [ $? -ne 0 ]; then
    return 1
  fi

  echo -e "${GREEN}Thanks for using nest-plus${RESET}"
  echo -e "${BLUE}Starting project....${RESET}"
  command $3 "start:dev"
}
