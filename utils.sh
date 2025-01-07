#!/bin/bash

function yesOrNo() {
    read -p "$1 Y/N: " "INPUT"

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
  imports: [ TypeOrmModule.forRoot(typeormConfig()) ],
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
export const mongooseConfig = () => {
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

  return {
    uri,
    useNewUrlParser: true,
    useUnifiedTopology: true,
  };
};
EOF

cd "../modules"

cat << DOF > app/app.module.ts
import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { mongooseConfig } from '../../configs/mongoose.config';

@Module({
  imports: [
    MongooseModule.forRootAsync({
      useFactory: mongooseConfig,
    }),
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
DOF

cd ../

INSTALL_PACKAGES+=("@nestjs/mongoose" "mongoose")

  return 0
}

function generateMicroOrm() {
  
  cd configs
  touch microOrm.config.ts

cat << DOF > microOrm.config.ts
import { MikroOrmModuleOptions } from '@mikro-orm/nestjs';

export const mikroOrmConfig = (): MikroOrmModuleOptions => {
  const {
    DB_HOST,
    DB_PORT,
    DB_USERNAME,
    DB_PASSWORD,
    DB_NAME,
    DB_SYNCHRONIZE,
  } = process.env;

  return {
    type: 'postgresql',
    host: DB_HOST,
    port: Number(DB_PORT),
    user: DB_USERNAME,
    password: DB_PASSWORD,
    dbName: DB_NAME,
    synchronize: !!Number(DB_SYNCHRONIZE)
  };
};
DOF

cd "../modules"

cat << DOF > app/app.module.ts
import { Module } from '@nestjs/common';
import { MikroOrmModule } from '@mikro-orm/nestjs';
import { mikroOrmConfig } from '../../configs/mikro-orm.config';

@Module({
  imports: [
    MikroOrmModule.forRoot(mikroOrmConfig()),
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
DOF

cd ../

INSTALL_PACKAGES+=("@micro-orm/nestjs" "@mikro-orm/core")

  return 0
}


function configMysql(){
  
  case "$CHOICE_ORMS" in 
      "TypeORM")
      INSTALL_PACKAGES+=("mysql2")
      sed -i '14s/postgres/mysql/' configs/typeorm.config.ts
      ;;
      "MicroORM")
      INSTALL_PACKAGES+=("@mikro-orm/mysql" "mysql2")
      sed -i '14s/postgres/mysql/' configs/microOrm.config.ts
      ;;
  esac

  return 0
}