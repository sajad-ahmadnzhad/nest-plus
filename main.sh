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

    yesOrNo "prettierrc and a eslintrc.js be removed?"

    if [ $INPUT = "y" ]; then 
    rm .eslintrc.js
    rm .prettierrc
    fi

    yesOrNo "Test files are deleted?"

    if [ $INPUT = "y" -a -d "test" ]; then
        rm -rf 'test'
        rm src/app.controller.spec.ts
    fi

      {
        echo "import { Module } from '@nestjs/common';"
        echo ""
        echo "@Module({"
        echo "  imports: [],"
        echo "  controllers: [],"
        echo "  providers: []"
        echo "})"
        echo "export class AppModule {}"
    } > src/modules/app.module.ts
      
fi
