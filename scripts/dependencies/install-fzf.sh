#!/bin/bash
source scripts/config/config.sh

while true; do

IS_INSTALL_FZF=$(command -v fzf)
if [ $? != 0 ]; then
    echo -e "${YELLOW}Please install fzf to continue...
example for linux: sudo apt install fzf
example for macos: brew install fzf
${RESET}"

read -p "$(echo -e ${BLUE}Please enter command for install fzf: ${RESET})" "COMMAND"
command $COMMAND

if [ $? != 0  -o -z "$COMMAND" ]; then
    echo -e "${RED}fzf installation command failed. please try again${RESET}"
    continue
fi

echo -e "${GREEN}fzf installed successfully${RESET}"
break
fi
break
done