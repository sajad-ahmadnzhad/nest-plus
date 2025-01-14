#!/bin/bash
source scripts/user_prompts/questions.sh
source scripts/config/config.sh

promptYesOrNo "$(echo -e "${BLUE}Need more options?"${RESET})"
if [ "$INPUT" = 'y' ]; then
    source scripts/features/redis_selection.sh

    promptYesOrNo "$(echo -e "${BLUE}Would you like to integrate Swagger for API documentation?${RESET}")"
    
    if [ $INPUT = 'y' ]; then
        source scripts/features/swagger_setup.sh
        setupSwaggerConfig
        echo -e "${GREEN}Generated swagger configs successfully${RESET}"
    fi

    promptYesOrNo "$(echo -e "${BLUE}Do you want to enable CORS for cross-origin requests?${RESET}")"
    
    if [ $INPUT = 'y' ]; then
        source scripts/features/cors_setup.sh
        setupCorsConfig
        echo -e "${GREEN}Generated cors configs successfully${RESET}"
    fi
fi