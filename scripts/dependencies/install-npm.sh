#!/bin/bash
source scripts/config/config.sh

while true; do
IS_INSTALL_NPM=$(command npm -v)
if [ $? != 0 ]; then
echo -e "${YELLOW}Please install npm to continue....
example for linux: sudo apt install npm
example for macos: brew install npm
${RESET}"

read -p $(echo -e "${BLUE}Please enter command for install npm: ${RESET}") "COMMAND"

eval $COMMAND

IS_INSTALL_NPM=$(command npm -v)
if [ $? != 0 ]; then
echo -e "${RED}npm installation command failed. please try again...${RESET}"
continue
fi

echo -e "${GREEN}npm installed successfully.${RESET}"
break
fi

done