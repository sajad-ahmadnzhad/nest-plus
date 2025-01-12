#!/bin/bash
source scripts/core/helpers.sh

# Setup typeorm config and create typeorm.config file.
function setupTypeOrmConfig() {
cd $PROJECT_NAME/src/configs
touch typeorm.config.ts

# Add typeorm config in app.module.ts
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

# Add typeorm config in app.module.ts
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

cd ../../..

# Add dependencies for install
savePackages "typeorm" "@nestjs/typeorm"

return 0
}


# Setup mongoose config and create mongoose.config file.
function setupMongooseConfig(){
cd $PROJECT_NAME/src/configs
touch mongoose.config.ts

# Create and insert into mongoose.config.ts
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

# Add mongoose config in app.module.ts
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

cd ../../..

# Add mongoose config envs
sed -i "1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=27017\nDB_NAME=${PROJECT_NAME}\nDB_USERNAME=\nDB_PASSWORD=\n" $PROJECT_NAME/.env

# Add dependencies for install
savePackages "@nestjs/mongoose" "mongoose"

  return 0
}

# Setup mikroOrm config and create mikroOrm.config file.
function setupMikroOrmConfig() {
cd $PROJECT_NAME/src/configs

touch mikroOrm.config.ts

# Create and insert into mikroOrm.config.ts
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

# Add mikroOrm config in app.module.ts
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

cd ../../..

# Add dependencies for install
savePackages "@mikro-orm/nestjs" "@mikro-orm/core"

  return 0
}
