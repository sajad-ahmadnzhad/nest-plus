#!/bin/bash

function setupTypeOrmConfig() {
cd src/configs
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

cd ../..

INSTALL_PACKAGES+=("typeorm" "@nestjs/typeorm")

return 0
}
