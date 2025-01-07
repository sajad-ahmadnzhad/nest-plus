#!/bin/bash

read -t 10 -p "Enter project name: " "PROJECT_NAME"

npx nest new $PROJECT_NAME --skip-install

if [ $? -eq 0 ]; then
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
    changeAppModule
    INSTALL_PACKAGES=()
    CHOICE=$(printf "TypeORM\nPrisma\nMicroORM\nMongoose\nNo Database" | fzf --prompt="Select ORM or ODM: ")

    if [ -n "$CHOICE" ]; then
        case $CHOICE in 
            "TypeORM")
            cd src
            generateTypeorm
             ;;
             "MicroORM")
             echo "This is microorm"
             ;;
             "Prisma")
             echo "This is prisma"
             ;;
             "Mongoose")
             cd src
             generateMongoose
             echo "Generate mongoose configs successfully."
             ;;
             "No Database")
             echo "This is no database"
             ;;
             *)
             echo "Not found item"
             ;;
        esac
    else 
        ceho "No item was selected"
        exit 1
    fi

fi

