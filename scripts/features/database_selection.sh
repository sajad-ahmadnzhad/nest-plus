#!/bin/bash
source scripts/features/database_setup.sh
source scripts/core/helpers.sh

if [[ "$CHOICE_ORMS" != "No Database" && "$CHOICE_ORMS" != "Mongoose" ]]; then
CHOICE_DB=$(printf "Mysql\nPostgresql\nMariadb\nSqlite" | fzf --prompt="Select database: ")

case $CHOICE_DB in 
    "Mysql")
    setupMysqlConfig
    echo -e "${GREEN}Mysql was set as the database${RESET}"
    ;;
    "Postgresql")
    setupPostgresqlConfig
    echo -e "${GREEN}Postgresql was set as the database${RESET}"
    ;;
    "Mariadb")
    setupMariadbConfig
    echo -e "${GREEN}Maria was set as the database${RESET}"
    ;;
    "Sqlite")
    setupSqliteConfig
    echo -e "${GREEN}Sqlite was set as the database${RESET}"
    ;;
    *)
    echo -e "${RED}No db selected${RESET}"
    exit 1
esac

fi