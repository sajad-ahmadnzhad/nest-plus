#!/bin/bash

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
RESET='\e[0m'
READ_BLUE_COLOR=$(tput setaf 4)
READ_REST_COLOR_CMD=$(tput sgr0)

IS_INSTALL_FZF=$(command -v fzf)
if [ $? != 0 ]; then
    echo -e "${YELLOW}Please install fzf to continue...
example for linux: sudo apt install fzf
example for macos: brew install fzf
${RESET}"

read -p "${READ_BLUE_COLOR}Plase enter command for install fzf: ${READ_REST_COLOR_CMD}" "COMMAND"
command $COMMAND
echo -e "${GREEN}fzf installed successfully${RESET}"
fi

read -t 10 -p "${READ_BLUE_COLOR}Enter project name${READ_REST_COLOR_CMD}: " "PROJECT_NAME"

npx nest new $PROJECT_NAME --skip-install
if [ $? -eq 0 ]; then

    if [ ! "$PROJECT_NAME" ]; then
        PROJECT_NAME="nest-app"
    fi

    source utils.sh
    cd "$PROJECT_NAME/src"
    mkdir "common"
    mkdir "configs"
    mkdir "modules"
    mkdir "modules/app"
    rm app.controller.ts
    rm app.service.ts
    mv app.module.ts modules/app
    cd "../"
    touch .env
    touch .env.example

cat << EOF > ".env"
PORT=4000
EOF

cat << EOF > ".env.example"
#Application configs
PORT=
EOF
    changeAppModule
    changeMainFile

    yesOrNo "prettierrc and eslintrc.js be removed?"

    if [ $INPUT = "y" ]; then 
    rm .eslintrc.js
    rm .prettierrc
    sed -i "10d;15d;37,41d;43d" package.json
    fi

    yesOrNo "Test files are deleted?"

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
    CHOICE_ORMS=$(printf "TypeORM\nMicroORM\nMongoose\nNo Database" | fzf --prompt="Select ORM or ODM: ")

    if [ -n "$CHOICE_ORMS" ]; then
        case $CHOICE_ORMS in 
            "TypeORM")
            cd src
            generateTypeorm
            echo "Generated typeorm configs successfully."
             ;;
             "MicroORM")
             cd src
             generateMicroOrm
             echo "Generated microOrm configs successfully."
             ;;
             "Mongoose")
             cd src
             generateMongoose
             echo "Generated mongoose configs successfully."
             ;;
             "No Database")
             echo "no database selected"
             ;;
             *)
             echo "Not found item"
             ;;
        esac

    if [[ "$CHOICE_ORMS" != "No Database" && "$CHOICE_ORMS" != "Mongoose" ]]; then
    CHOICE_DB=$(printf "Mysql\nPostgresql\nMariadb\nSqlite" | fzf --prompt="Select database: ")

    case $CHOICE_DB in 
        "Mysql")
        configMysql
        echo "Mysql was set as the database"
        ;;
        "Postgresql")
        configPostgresql
        echo "Postgresql was set as the database"
        ;;
        "Mariadb")
        configMariadb
        echo "Maria was set as the database"
        ;;
        "Sqlite")
        configSqlite
        echo "Sqlite was set as the database"
        ;;
        *)
        echo "No db selected"
        exit 1
    esac

    fi

    else 
        ceho "No item was selected"
        exit 1
    fi

    yesOrNo "Need more options?"

    if [ $INPUT = 'y' ]; then 
        CHOICE_REDIS=$(printf "Redis cache manager\nRedis\nNo redis" | fzf --prompt="Select the desired option for Redis" )
        case $CHOICE_REDIS in 
            "Redis")
            cd src
            configRedis
            echo "generated redis configs successfully"
            ;;
            "Redis cache manager")
            echo "generated redis cache manager configs successfully"
            ;;
            "No redis")
            echo "No redis selected"
            ;;
            *)
            echo "Not found item"
        esac
    fi

    cd ..
    echo "Plase wait for downloading packages....."
    npx yarn install
    echo "Wait for downloading ${INSTALL_PACKAGES[@]}....."
    npx yarn add "${INSTALL_PACKAGES[@]}"
    echo "Thanks for using nest-plus"
fi

