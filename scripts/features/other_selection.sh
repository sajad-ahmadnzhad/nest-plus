#!/bin/bash
source ../user_prompts/questions.sh

promptYesOrNo "$(echo -e "${BLUE}Need more options?"${RESET})"
if [ "$INPUT" = 'y' ]; then
    bash ./redis_selection.sh

    promptYesOrNo "$(echo -e "${BLUE}add swagger?${RESET}")"
    
    if [ $INPUT = 'y' ]; then
        source ./swagger_setup.sh
        setupSwaggerConfig
        echo -e "${GREEN}Generated swagger configs successfully${RESET}"
    fi
fi