#!/bin/bash
source scripts/user_prompts/questions.sh
source scripts/config/config.sh

promptYesOrNo "$(echo -e "${BLUE}Need more options?"${RESET})"
if [ "$INPUT" = 'y' ]; then
    source scripts/features/redis_selection.sh

    promptYesOrNo "$(echo -e "${BLUE}add swagger?${RESET}")"
    
    if [ $INPUT = 'y' ]; then
        source scripts/features/swagger_setup.sh
        setupSwaggerConfig
        echo -e "${GREEN}Generated swagger configs successfully${RESET}"
    fi
fi