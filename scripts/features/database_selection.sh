#!/bin/bash

if [[ "$CHOICE_ORMS" != "No Database" && "$CHOICE_ORMS" != "Mongoose" ]]; then
CHOICE_DB=$(printf "Mysql\nPostgresql\nMariadb\nSqlite" | fzf --prompt="Select database: ")

case $CHOICE_DB in 
    "Mysql")
    configMysql
    echo -e "${GREEN}Mysql was set as the database${RESET}"
    ;;
    "Postgresql")
    configPostgresql
    echo -e "${GREEN}Postgresql was set as the database${RESET}"
    ;;
    "Mariadb")
    configMariadb
    echo -e "${GREEN}Maria was set as the database${RESET}"
    ;;
    "Sqlite")
    configSqlite
    echo -e "${GREEN}Sqlite was set as the database${RESET}"
    ;;
    *)
    echo -e "${RED}No db selected${RESET}"
    exit 1
esac

fi

else 
    echo -e "${RED}No item was selected${RESET}"
    exit 1
fi