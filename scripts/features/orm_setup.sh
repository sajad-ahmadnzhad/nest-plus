#!/bin/bash
source scripts/config/config.sh

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
cd $PROJECT_NAME
touch mongoose.config.ts

# Create and insert into mongoose.config.ts
cat << "EOF" > src/configs/mongoose.config.ts
export const mongooseConfig = (): string => {
  const {
    MONGODB_URI,
  } = process.env;

  return MONGODB_URI as string
};
EOF

# Add mongoose config in app.module.ts
cat << DOF > src/modules/app/app.module.ts
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

# Add mongoose config envs
sed -i "1i \\#Database configs\nMONGODB_URI=mongodb://localhost:27017/${PROJECT_NAME}\n" ./.env

# Add dependencies for install
savePackages "@nestjs/mongoose" "mongoose"

cd ..

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
