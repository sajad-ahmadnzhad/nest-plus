#!/bin/bash

read -t 10 -p "Enter project name: " "PROJECT_NAME"

npx nest new $PROJECT_NAME --skip-install

if [ $? -eq 0 ]; then
    source utils.sh
    cd "$PROJECT_NAME/src"
    mkdir "common"
    mkdir "configs"
    mkdir "modules"
    rm app.controller.ts
    rm app.service.ts
    mv app.module.ts modules
    cd "../"

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
fi