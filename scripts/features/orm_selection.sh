#!/bin/bash
source scripts/features/orm_setup.sh

# This script prompts the user to select an ORM/ODM from a list using fzf.
CHOICE_ORMS=$(printf "TypeORM\nMikroORM\nMongoose\nNo Database" | fzf --prompt="Select ORM or ODM: ")

if [ -n "$CHOICE_ORMS" ]; then
    case $CHOICE_ORMS in 
        "TypeORM")
         setupTypeOrmConfig
         echo -e "${GREEN}Generated typeorm configs successfully.${RESET}"
         ;;
         "MikroORM")
         setupMikroOrmConfig
         echo -e "${GREEN}Generated mikroORM configs successfully."
         ;;
         "Mongoose")
         setupMongooseConfig
         echo -e "${GREEN}Generated mongoose configs successfully.${RESET}"
         ;;
         "No Database")
         echo -e "${YELLOW}no database selected${RESET}"
         ;;
         *)
         echo "${RED}Not found item${RESET}"
         exit 1
         ;;
    esac
fi