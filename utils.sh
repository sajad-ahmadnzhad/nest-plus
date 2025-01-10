#!/bin/bash

function yesOrNo() {
    read -p "$1 [Y/n]: " "INPUT"

    if [[ -z "$INPUT" || ! "$INPUT" =~ ^[yYnN]$ ]]; then
        INPUT='y'
    fi

    INPUT=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')
    
    return 0
}

function changeAppModule() {
    {
        echo "import { Module } from '@nestjs/common';"
        echo ""
        echo "@Module({"
        echo "  imports: [],"
        echo "  controllers: [],"
        echo "  providers: []"
        echo "})"
        echo "export class AppModule {}"
    } > src/modules/app/app.module.ts
    
    return 0
}

function changeMainFile(){
  cd src
  sed -i "2s/app.module/modules\/app\/app.module/" "main.ts"
  cd ..
  return 0
}

function generateTypeorm() {

    cd configs
    touch typeorm.config.ts

cat << EOF > typeorm.config.ts
import { TypeOrmModuleOptions } from "@nestjs/typeorm";

export const typeormConfig = (): TypeOrmModuleOptions => {
  const {
    DB_HOST,
    DB_PORT,
    DB_USERNAME,
    DB_PASSWORD,
    DB_NAME,
    DB_SYNCHRONIZE,
  } = process.env;

  return {
    type: "postgres",
    host: DB_HOST,
    port: Number(DB_PORT),
    username: DB_USERNAME,
    password: DB_PASSWORD,
    database: DB_NAME,
    synchronize: !!Number(DB_SYNCHRONIZE),
    entities: [],
    autoLoadEntities: false,
  };
};
EOF

cd "../modules"

cat << EOF > app/app.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from "@nestjs/typeorm";
import { typeormConfig } from "../../configs/typeorm.config";

@Module({
  imports: [ 
    TypeOrmModule.forRoot(typeormConfig())
  ],
  controllers: [],
  providers: []
})
export class AppModule {}
EOF

cd ../

INSTALL_PACKAGES+=("typeorm" "@nestjs/typeorm")

    return 0
}


function generateMongoose(){
  
cd configs
touch mongoose.config.ts

cat << "EOF" > mongoose.config.ts
export const mongooseConfig = (): string => {
  const {
    DB_HOST,
    DB_PORT,
    DB_NAME,
    DB_USERNAME,
    DB_PASSWORD,
  } = process.env;

  let uri = `mongodb://${DB_HOST}:${DB_PORT}/${DB_NAME}`;
  
  if (DB_USERNAME && DB_PASSWORD) {
    uri = `mongodb://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}?authSource=admin`;
  }

  return uri
};
EOF

cd "../modules"

cat << DOF > app/app.module.ts
import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { mongooseConfig } from '../../configs/mongoose.config';

@Module({
  imports: [
    MongooseModule.forRoot(mongooseConfig())
  ],
  controllers: [],
  providers: []
})
export class AppModule {}
DOF

cd ../

sed -i "1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=27017\nDB_NAME=${PROJECT_NAME}\nDB_USERNAME=\nDB_PASSWORD=\n" ../.env

INSTALL_PACKAGES+=("@nestjs/mongoose" "mongoose")

  return 0
}

function generateMikroOrm() {
  
  cd configs
  touch mikroOrm.config.ts

cat << DOF > mikroOrm.config.ts
import { MikroOrmModuleOptions } from '@mikro-orm/nestjs';
import { PostgreSqlDriver } from '@mikro-orm/postgresql';

export const mikroOrmConfig = (): MikroOrmModuleOptions => {
  const {
    DB_HOST,
    DB_PORT,
    DB_USERNAME,
    DB_PASSWORD,
    DB_NAME,
  } = process.env;

  return {
    driver: PostgreSqlDriver,
    host: DB_HOST,
    port: Number(DB_PORT),
    user: DB_USERNAME,
    password: DB_PASSWORD,
    dbName: DB_NAME,
    autoLoadEntities: false,
    entities: ["./dist/**/*.entity.js"],
    entitiesTs: ['./src/**/*.entity.ts'],
    discovery: {
      warnWhenNoEntities: false
    }
  };
};
DOF

cd "../modules"

cat << DOF > app/app.module.ts
import { Module } from '@nestjs/common';
import { MikroOrmModule } from '@mikro-orm/nestjs';
import { mikroOrmConfig } from '../../configs/mikroOrm.config';

@Module({
  imports: [
    MikroOrmModule.forRoot(mikroOrmConfig())
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
DOF

cd ../

INSTALL_PACKAGES+=("@mikro-orm/nestjs" "@mikro-orm/core")

  return 0
}


function configMysql(){
  
  case "$CHOICE_ORMS" in 
      "TypeORM")
      INSTALL_PACKAGES+=("mysql2")
      sed -i '14s/postgres/mysql/' configs/typeorm.config.ts
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=3306\nDB_NAME=mysql\nDB_USERNAME=root\nDB_PASSWORD=\nSYNCHRONIZE=1\n' ../.env
      ;;
      "MikroORM")
      INSTALL_PACKAGES+=("@mikro-orm/mysql" "mysql2")
      sed -i "2c\import { MySqlDriver } from '@mikro-orm/mysql';" configs/mikroOrm.config.ts
      sed -i "14c\    driver: MySqlDriver," configs/mikroOrm.config.ts
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=3306\nDB_NAME=mysql\nDB_USERNAME=root\nDB_PASSWORD=\n' ../.env
      ;;
  esac

  return 0
}


function configPostgresql(){
  case "$CHOICE_ORMS" in 
      "TypeORM")
      INSTALL_PACKAGES+=("pg")
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=5432\nDB_NAME=postgres\nDB_USERNAME=postgres\nDB_PASSWORD=postgres\nSYNCHRONIZE=1\n' ../.env
      ;;
      "MikroORM")
      INSTALL_PACKAGES+=("@mikro-orm/postgresql")
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=5432\nDB_NAME=postgres\nDB_USERNAME=postgres\nDB_PASSWORD=postgres\n' ../.env
      ;;
  esac

  return 0
}

function configMariadb(){
  case "$CHOICE_ORMS" in 
      "TypeORM")
      INSTALL_PACKAGES+=("mariadb")
      sed -i "14s/postgres/mariadb/" configs/typeorm.config.ts
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=3306\nDB_NAME=mariadb\nDB_USERNAME=root\nDB_PASSWORD=\nSYNCHRONIZE=1\n' ../.env
      ;;
      "MikroORM")
      INSTALL_PACKAGES+=("@mikro-orm/mariadb")
      sed -i "2c\import { MariaDbDriver } from '@mikro-orm/mariadb';" configs/mikroOrm.config.ts
      sed -i "14c\    driver: MariaDbDriver," configs/mikroOrm.config.ts
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=3306\nDB_NAME=mariadb\nDB_USERNAME=root\nDB_PASSWORD=\n' ../.env
      ;;
  esac


  return 0
}

function configSqlite(){
  case "$CHOICE_ORMS" in 
      "TypeORM")
      INSTALL_PACKAGES+=("sqlite3")
      sed -i "14s/postgres/sqlite/" configs/typeorm.config.ts
      sed -i "5,8d;15,18d" configs/typeorm.config.ts
      sed -i "1i \\#Database configs\nDB_NAME=${PROJECT_NAME}.sqlite\nDB_SYNCHRONIZE=1\n" ../.env
      ;;
      "MikroORM")
      INSTALL_PACKAGES+=("@mikro-orm/sqlite")
      sed -i "2c \\import { SqliteDriver } from '@mikro-orm/sqlite';" configs/mikroOrm.config.ts
      sed -i "6,9d;15,18d;14c\    driver: SqliteDriver," configs/mikroOrm.config.ts
      sed -i "1i \\#Database configs\nDB_NAME=${PROJECT_NAME}.sqlite\n" ../.env
      ;;
  esac

  return 0
}

function configRedis(){
  
touch configs/redis.config.ts

cat << EOF > configs/redis.config.ts
import { RedisModuleOptions } from "@nestjs-modules/ioredis";

export default (): RedisModuleOptions => {
  return {
    type: "single",
    options: {
      host: process.env.REDIS_HOST,
      port: +process.env.REDIS_PORT,
      password: process.env.REDIS_PASSWORD,
    },
  };
};
EOF


if [ "$CHOICE_ORMS" = "No database" ]; then
  sed -i '4c\\  imports: [\n    RedisModule.forRoot(redisConfig())\n  ],' "modules/app/app.module.ts"
  sed -i '1a\import { RedisModule } from "@nestjs-modules/ioredis";\nimport redisConfig from "../../configs/redis.config";' modules/app/app.module.ts
else
  sed -i '2a\import { RedisModule } from "@nestjs-modules/ioredis";\nimport redisConfig from "../../configs/redis.config";' modules/app/app.module.ts
  sed -i '9s/$/,/;10i\    RedisModule.forRoot(redisConfig())' "modules/app/app.module.ts"

fi

sed -i '1i \#Redis configs\nREDIS_HOST=localhost\nREDIS_PORT=6379\nDB_PASSWORD=\n' ../.env

INSTALL_PACKAGES+=("@nestjs-modules/ioredis")

  return 0
}


function configSwagger(){ 
touch configs/swagger.config.ts

cat << EOF > configs/swagger.config.ts
import { INestApplication } from "@nestjs/common";
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";
import { SecuritySchemeObject } from "@nestjs/swagger/dist/interfaces/open-api-spec.interface";

export const swaggerConfigInit = (app: INestApplication) => {
  const swaggerConfig = new DocumentBuilder()
    .setTitle("$PROJECT_NAME")
    .setDescription("description for $PROJECT_NAME")
    .setVersion("0.0.1")
    .addBearerAuth(swaggerAuthConfig(), "Authorization")
    .build();

  const document = SwaggerModule.createDocument(app, swaggerConfig);

  SwaggerModule.setup("swagger", app, document, {
    jsonDocumentUrl: "swagger/json",
  });
};

function swaggerAuthConfig(): SecuritySchemeObject {
  return {
    scheme: "bearer",
    type: "http",
    in: "header",
    bearerFormat: "JWT",
  };
}
EOF

sed -i "3c \import { swaggerConfigInit } from './configs/swagger.config';" main.ts
sed -i '4i \\' main.ts


sed -i '7i \\n\n' main.ts
sed -i '8c \  swaggerConfigInit(app);' main.ts

INSTALL_PACKAGES+=("@nestjs/swagger")

  return 0
}

function redisCacheManagerConfig() {
  touch configs/cache.config.ts

cat << EOF > configs/cache.config.ts
import { CacheModuleAsyncOptions } from "@nestjs/cache-manager";
import { redisStore } from "cache-manager-redis-yet";

export const cacheConfig = (): CacheModuleAsyncOptions => {
  return {
    isGlobal: true,
    async useFactory() {
      const store = await redisStore({
        socket: {
          host: process.env.REDIS_HOST,
          port: Number(process.env.REDIS_PORT),
        },
        password: process.env.REDIS_PASSWORD,
      });

      return { store };
    },
  };
};
EOF

if [ "$CHOICE_ORMS" != "No database" ]; then
  sed -i '3i \\import { CacheModule } from "@nestjs/cache-manager";\nimport { cacheConfig } from "../../configs/cache.config";' modules/app/app.module.ts
  sed -i '9s/$/,/' modules/app/app.module.ts
  sed -i '10i \\    CacheModule.registerAsync(cacheConfig())' modules/app/app.module.ts
else
  sed -i '4c \  imports: [\n    CacheModule.registerAsync(cacheConfig())\n  ],' modules/app/app.module.ts
  sed -i '2i \\import { CacheModule } from "@nestjs/cache-manager";\nimport { cacheConfig } from "../../configs/cache.config";' modules/app/app.module.ts
fi

sed -i '1i \#Redis configs\nREDIS_HOST=localhost\nREDIS_PORT=6379\nDB_PASSWORD=\n' ../.env


INSTALL_PACKAGES+=("@nestjs/cache-manager" "cache-manager-redis-yet")

return 0
}

function addConfigModule() {
  sed -i '2i \import { ConfigModule } from "@nestjs/config";' modules/app/app.module.ts
  sed -i '/imports: \[/a \ \ \ \ ConfigModule.forRoot({\n      isGlobal: true,\n      envFilePath: `${process.cwd()}/.env`,\n    }),' modules/app/app.module.ts

  INSTALL_PACKAGES+=("@nestjs/config")
  return 0
}

function manageEnvFile(){ 
  
cat ../.env > ../.env.example
sed -i 's/=\(.*\)$/=/' ../.env.example

  return 0
}


function installPackages(){
  
    echo -e "${BLUE}Wait for installing other packages.....${RESET}"
    command $1

    echo -e "${BLUE}Please Wait for installing ${INSTALL_PACKAGES[@]}.....${RESET}"
    command $2 "${INSTALL_PACKAGES[@]}"

    echo -e "${GREEN}Thanks for using nest-plus${RESET}"
    echo -e "${BLUE}Starting project....${RESET}"
    command $3 start:dev
  
  return 0
}