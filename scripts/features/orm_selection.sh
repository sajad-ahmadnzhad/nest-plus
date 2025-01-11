#!/bin/bash
source ../core/orm_helpers.sh

CHOICE_ORMS=$(printf "TypeORM\nMikroORM\nMongoose\nNo Database" | fzf --prompt="Select ORM or ODM: ")

if [ -n "$CHOICE_ORMS" ]; then
    case $CHOICE_ORMS in 
        "TypeORM")
         setupTypeOrmConfig
         echo -e "${GREEN}Generated typeorm configs successfully.${RESET}"
         ;;
         "MikroORM")
         generateMikroOrm
         echo -e "${GREEN}Generated mikroORM configs successfully."
         ;;
         "Mongoose")
         generateMongoose
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