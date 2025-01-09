#!/bin/bash

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
RESET='\e[0m'

IS_INSTALL_FZF=$(command -v fzf)
if [ $? != 0 ]; then
    echo -e "${YELLOW}Please install fzf to continue...
example for linux: sudo apt install fzf
example for macos: brew install fzf
${RESET}"
read -p "$(echo -e ${BLUE}Please enter command for install fzf: ${RESET})" "COMMAND"
command $COMMAND

if [ $? != 0 ]; then
    echo -e "${RED}fzf installation command failed. please try again${RESET}"
    exit 1
fi

echo -e "${GREEN}fzf installed successfully${RESET}"
fi


while true; do
    read -p "$(echo -e "${BLUE}Please enter project name: ${RESET}")" "PROJECT_NAME"
    if [ -z "$PROJECT_NAME" ]; then
        echo -e "${RED}Project name is required${RESET}"
    else break
    fi
done

OUTPUT=$(npx nest new "$PROJECT_NAME" --skip-install 2>&1 | tee /dev/tty)

CLEAN_OUTPUT=$(echo "$OUTPUT" | sed 's/\x1B\[[0-9;]*[a-zA-Z]//g')

PACKAGE_MANAGER=$(echo "$CLEAN_OUTPUT" | grep -oP "(?<=Which package manager would you ❤️  to use\\? ).*" | tail -1)

if [[ ! -n "$PACKAGE_MANAGER" ]]; then
    echo -e "${RED}no package manager selected.${RESET}"
    exit 1
fi

if [ $? -eq 0 ]; then
    source utils.sh
    cd "$PROJECT_NAME/src"
    mkdir common configs modules modules/app
    rm app.controller.ts app.service.ts
    mv app.module.ts modules/app
    cd common
    mkdir pipes filters guards middlewares enums decorators utils
    cd "../../"
    touch .env
    touch .env.example

cat << EOF > ".env"
#Application configs
PORT=4000
EOF

    changeAppModule
    changeMainFile

    yesOrNo "$(echo -e "${YELLOW}prettierrc and eslintrc.js be removed?${RESET}")"

    if [ $INPUT = "y" ]; then 
    rm .eslintrc.js
    rm .prettierrc
    sed -i "10d;15d;37,41d;43d" package.json
    fi

    yesOrNo "$(echo -e "${YELLOW}Test files are deleted?${RESET}")"

    if [ $INPUT = "y" -a -d "test" ]; then
        rm -rf 'test'
        rm src/app.controller.spec.ts

        if [ -f ".eslintrc.js" -a -f ".prettierrc" ]; then
            sed -i "16,20d;32d;34d;36d;42d;45,46d;52,68d" package.json
            sed -i "15s/,$//;40s/,$//" package.json
        else 
            sed -i "14,18d;30d;32d;34,35d;37,38d;44,60d" package.json
            sed -i "13s/,$//;32s/,$//" package.json
        fi

    fi
    INSTALL_PACKAGES=()
    CHOICE_ORMS=$(printf "TypeORM\nMikroORM\nMongoose\nNo Database" | fzf --prompt="Select ORM or ODM: ")

    if [ -n "$CHOICE_ORMS" ]; then
        case $CHOICE_ORMS in 
            "TypeORM")
            cd src
            generateTypeorm
            echo -e "${GREEN}Generated typeorm configs successfully.${RESET}"
             ;;
             "MikroORM")
             cd src
             generateMikroOrm
             echo -e "${GREEN}Generated mikroORM configs successfully."
             ;;
             "Mongoose")
             cd src
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

        yesOrNo "$(echo -e "${BLUE}Need more options?"${RESET})"

    if [ $INPUT = 'y' ]; then 
        CHOICE_REDIS=$(printf "Redis cache manager\nRedis\nNo redis" | fzf --prompt="Select the desired option for Redis" )
        case $CHOICE_REDIS in 
            "Redis")
            configRedis
            echo -e "${GREEN}generated redis configs successfully${RESET}"
            ;;
            "Redis cache manager")
            redisCacheManagerConfig
            echo -e "${GREEN}generated redis cache manager configs successfully${RESET}"
            ;;
            "No redis")
            echo -e "${YELLOW}No redis selected${RESET}"
            ;;
            *)
            echo -e "${RED}Not found item${RESET}"
        esac
    fi

        yesOrNo "$(echo -e "${BLUE}add swagger?${RESET}")"
      
      if [ $INPUT = 'y' ]; then
        configSwagger
        echo -e "${GREEN}generated swagger configs successfully${RESET}"
      fi
    
    addConfigModule
    manageEnvFile
    cd ..
    case $PACKAGE_MANAGER in 
         "npm")
         installPackages "npm install" "npm install" "npm run"
         ;;
         "yarn")
         installPackages "npx yarn install" "npx yarn add" "npx yarn"
         ;;
         "pnpm") 
         installPackages "npx pnpm install" "npx pnpm add" "npx pnpm"
         ;;
         *)
         echo -e "${RED}Package manager not selected${RESET}"
         exit 1
    esac

fi

