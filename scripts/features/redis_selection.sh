#!/bin/bash
source ../user_prompts/questions.sh

promptYesOrNo "$(echo -e "${BLUE}Need more options?"${RESET})"

if [ $INPUT = 'y' ]; then 
    CHOICE_REDIS=$(printf "Redis cache manager\nRedis\nNo redis" | fzf --prompt="Select the desired option for Redis" )
    case $CHOICE_REDIS in 
        "Redis")
        setupRedisConfig
        echo -e "${GREEN}generated redis configs successfully${RESET}"
        ;;
        "Redis cache manager")
        setupRedisCacheManagerConfig
        echo -e "${GREEN}generated redis cache manager configs successfully${RESET}"
        ;;
        "No redis")
        echo -e "${YELLOW}No redis selected${RESET}"
        ;;
        *)
        echo -e "${RED}Not found item${RESET}"
    esac
        
    promptYesOrNo "$(echo -e "${BLUE}add swagger?${RESET}")"
      
    if [ $INPUT = 'y' ]; then
        configSwagger
        echo -e "${GREEN}generated swagger configs successfully${RESET}"
    fi
    
fi