#!/bin/bash
source scripts/user_prompts/questions.sh
source scripts/config/config.sh

# Get the selected package manager
function get_package_manager(){
# Create a new NestJS project with the specified name and save the output
local OUTPUT=$(npx nest new "$PROJECT_NAME" --skip-install 2>&1 | tee /dev/tty)

# Remove ANSI color codes from the output for cleaner processing
local CLEAN_OUTPUT=$(echo "$OUTPUT" | sed 's/\x1B\[[0-9;]*[a-zA-Z]//g')

# Extract the selected package manager name from the cleaned output
PACKAGE_MANAGER=$(echo "$CLEAN_OUTPUT" | grep -oP "(?<=Which package manager would you ❤️  to use\\? ).*" | tail -1)

if [[ ! -n "$PACKAGE_MANAGER" ]]; then
    echo -e "${RED}no package manager selected.${RESET}"
    exit 1
fi

return 0
}

# Get the entered project name
function get_project_name(){
# Validates user input for a project name, requiring at least one word.
while true; do
    read -p "$(echo -e "${BLUE}Please enter project name: ${RESET}")" "PROJECT_NAME"

    # Extract the first word and check if it is empty.
    PROJECT_NAME=$(echo "$PROJECT_NAME" | cut -d' ' -f1)
    if [ -z "$PROJECT_NAME" ]; then
     echo -e "${RED}Project name is required${RESET}"
     continue
    elif [ -d "$PROJECT_NAME" ]; then
      echo -e "${RED}Directory with this name already exists${RESET}"
      continue
    fi
break
done

return 0
}

# Setup env files
function setup_envs(){
cd $PROJECT_NAME
    touch .env
    touch .env.example

# Add default envs
cat << EOF > ".env"
#Application configs
PORT=4000
EOF
cd ..
}

# Setup base app module
function setupAppModule() {
cd $PROJECT_NAME
cat << 'EOF' > src/modules/app/app.module.ts
import { Module } from '@nestjs/common';

@Module({
  imports: [],
  controllers: [],
  providers: []
})
export class AppModule {}
EOF
cd ..
    return 0
}

# Updates the path of the main application file
function modifyMainFile(){
  cd $PROJECT_NAME
  sed -i "2s/app.module/modules\/app\/app.module/" "src/main.ts"
  sed -i '1a \\import { Logger } from "@nestjs/common";' src/main.ts
  sed -i '6a \\  const logger = new Logger("NestApplication");\n' src/main.ts
  sed -i "9a \n" src/main.ts
  sed -i '10c \  logger.log(`Application running on port ${process.env.PORT}`);' src/main.ts

  cd ..
  return 0
}

# Removes ESLint and Prettier configuration files and updates the package.json.
function removePrettierAndESLint(){
cd $PROJECT_NAME
promptYesOrNo "$(echo -e "${YELLOW}prettierrc and eslintrc.js be removed?${RESET}")"

if [ $INPUT = "y" ]; then 
    rm .eslintrc.js
    rm .prettierrc
    # Remove lines from package.json
    sed -i "10d;15d;37,41d;43d" package.json
fi
cd ..
return 0
}

# Removes Test configuration files and updates the package.json.
function removeTestFiles(){
cd $PROJECT_NAME
promptYesOrNo "$(echo -e "${YELLOW}Test files are deleted?${RESET}")"

if [ $INPUT = "y" -a -d "test" ]; then
rm -rf 'test'
rm src/modules/app/app.controller.spec.ts

# Remove specific lines from package.json based on the presence of .eslintrc.js and .prettierrc files
if [ -f ".eslintrc.js" -a -f ".prettierrc" ]; then
    sed -i "16,20d;32d;34d;36d;42d;45,46d;52,68d" package.json
    sed -i "15s/,$//;40s/,$//" package.json
else 
    sed -i "14,18d;30d;32d;34,35d;37,38d;44,60d" package.json
    sed -i "13s/,$//;32s/,$//" package.json
fi

fi

cd ..

return 0
}

function setupConfigModule() {
cd "$PROJECT_NAME/src"
local LINE=$(sed -n '4p' modules/app/app.module.ts | tr -d '[:space:]') 
local EXPECTED="imports:[],"

if [ "$LINE" == "$EXPECTED" ]; then
  sed -i '4d;5c\\   imports:[\n     ConfigModule.forRoot({\n      isGlobal: true,\n      envFilePath: `${process.cwd()}/.env`,\n    }),\n  ],' modules/app/app.module.ts
else
  sed -i '/imports: \[/a \ \ \ \ ConfigModule.forRoot({\n      isGlobal: true,\n      envFilePath: `${process.cwd()}/.env`,\n    }),' modules/app/app.module.ts
fi

sed -i '2i \import { ConfigModule } from "@nestjs/config";' modules/app/app.module.ts

savePackages "@nestjs/config" 

cd ../..

  return 0
}

function manageEnvFile() {
cd "$PROJECT_NAME/src"

cat ../.env > ../.env.example
sed -i 's/=\(.*\)$/=/' ../.env.example

cd ../..

  return 0
}

function setupValidation(){
cd $PROJECT_NAME

sed -i 's/providers: \[\]/providers: [\n    { provide: APP_PIPE, useValue: new ValidationPipe({ whitelist: true }) },\n  ]/' src/modules/app/app.module.ts

sed -i '2i \\import { APP_PIPE } from "@nestjs/core";' src/modules/app/app.module.ts
sed -i '1c\\import { Module, ValidationPipe } from "@nestjs/common";' src/modules/app/app.module.ts

savePackages "class-validator" "class-transformer"
cd ..

  return 0
}