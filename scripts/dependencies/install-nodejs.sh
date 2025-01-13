#!/bin/bash
source scripts/config/config.sh

while true; do
IS_INSTALL_NODEJS=$(eval nodejs -v > /dev/null 2>&1)
if [ $? != 0 ]; then
echo -e "${YELLOW}Please install nodejs to continue....
example for linux: sudo apt install nodejs
example for macos: brew install 
${RESET}"

read -p "$(echo -e "${BLUE}Please enter command for install nodejs : ${RESET}")" "COMMAND"
eval $COMMAND

IS_INSTALL_NODEJS=$(command nodejs -v /dev/null 2>&1)
if [ $? != 0 ]; then
echo -e "${RED}nodejs installation command failed. please try again...${RESET}"
continue
fi

echo -e "${GREEN}nodejs installed successfully.${RESET}"
break
fi
break
done