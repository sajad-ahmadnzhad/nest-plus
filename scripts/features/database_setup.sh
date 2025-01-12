#!/bin/bash
source scripts/core/helpers.sh

function setupMysqlConfig(){
cd $PROJECT_NAME
  case "$CHOICE_ORMS" in 
      "TypeORM")
      savePackages "mysql2"
      sed -i '14s/postgres/mysql/' src/configs/typeorm.config.ts
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=3306\nDB_NAME=mysql\nDB_USERNAME=root\nDB_PASSWORD=\nSYNCHRONIZE=1\n' .env
      ;;
      "MikroORM")
      savePackages "@mikro-orm/mysql"
      sed -i "2c\import { MySqlDriver } from '@mikro-orm/mysql';" src/configs/mikroOrm.config.ts
      sed -i "14c\    driver: MySqlDriver," src/configs/mikroOrm.config.ts
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=3306\nDB_NAME=mysql\nDB_USERNAME=root\nDB_PASSWORD=\n' .env
      ;;
  esac
cd ..
  return 0
}


function setupPostgresqlConfig(){
cd $PROJECT_NAME
  case "$CHOICE_ORMS" in 
      "TypeORM")
      savePackages "pg"
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=5432\nDB_NAME=postgres\nDB_USERNAME=postgres\nDB_PASSWORD=postgres\nSYNCHRONIZE=1\n' .env
      ;;
      "MikroORM")
      savePackages "@mikro-orm/postgresql"
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=5432\nDB_NAME=postgres\nDB_USERNAME=postgres\nDB_PASSWORD=postgres\n' .env
      ;;
  esac
cd ..
  return 0
}

function setupMariadbConfig(){
  cd $PROJECT_NAME
  case "$CHOICE_ORMS" in 
      "TypeORM")
      savePackages "mariadb"
      sed -i "14s/postgres/mariadb/" src/configs/typeorm.config.ts
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=3306\nDB_NAME=mariadb\nDB_USERNAME=root\nDB_PASSWORD=\nSYNCHRONIZE=1\n' .env
      ;;
      "MikroORM")
      savePackages "@mikro-orm/mariadb"
      sed -i "2c\import { MariaDbDriver } from '@mikro-orm/mariadb';" src/configs/mikroOrm.config.ts
      sed -i "14c\    driver: MariaDbDriver," src/configs/mikroOrm.config.ts
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=3306\nDB_NAME=mariadb\nDB_USERNAME=root\nDB_PASSWORD=\n' .env
      ;;
  esac
  cd ..
  return 0
}

function setupSqliteConfig(){
  cd $PROJECT_NAME
  case "$CHOICE_ORMS" in 
      "TypeORM")
      savePackages "sqlite3"
      sed -i "14s/postgres/sqlite/" src/configs/typeorm.config.ts
      sed -i "5,8d;15,18d" src/configs/typeorm.config.ts
      sed -i "1i \\#Database configs\nDB_NAME=${PROJECT_NAME}.sqlite\nDB_SYNCHRONIZE=1\n" .env
      ;;
      "MikroORM")
      savePackages "@mikro-orm/sqlite"
      sed -i "2c \\import { SqliteDriver } from '@mikro-orm/sqlite';" src/configs/mikroOrm.config.ts
      sed -i "6,9d;15,18d;14c\    driver: SqliteDriver," src/configs/mikroOrm.config.ts
      sed -i "1i \\#Database configs\nDB_NAME=${PROJECT_NAME}.sqlite\n" .env
      ;;
  esac
  cd ..
  return 0
}