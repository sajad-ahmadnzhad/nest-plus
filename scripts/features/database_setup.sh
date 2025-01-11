#!/bin/bash

function setupMysqlConfig(){
  case "$CHOICE_ORMS" in 
      "TypeORM")
      INSTALL_PACKAGES+=("mysql2")
      sed -i '14s/postgres/mysql/' src/configs/typeorm.config.ts
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=3306\nDB_NAME=mysql\nDB_USERNAME=root\nDB_PASSWORD=\nSYNCHRONIZE=1\n' .env
      ;;
      "MikroORM")
      INSTALL_PACKAGES+=("@mikro-orm/mysql" "mysql2")
      sed -i "2c\import { MySqlDriver } from '@mikro-orm/mysql';" src/configs/mikroOrm.config.ts
      sed -i "14c\    driver: MySqlDriver," src/configs/mikroOrm.config.ts
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=3306\nDB_NAME=mysql\nDB_USERNAME=root\nDB_PASSWORD=\n' .env
      ;;
  esac

  return 0
}


function setupPostgresqlConfig(){
  case "$CHOICE_ORMS" in 
      "TypeORM")
      INSTALL_PACKAGES+=("pg")
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=5432\nDB_NAME=postgres\nDB_USERNAME=postgres\nDB_PASSWORD=postgres\nSYNCHRONIZE=1\n' .env
      ;;
      "MikroORM")
      INSTALL_PACKAGES+=("@mikro-orm/postgresql")
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=5432\nDB_NAME=postgres\nDB_USERNAME=postgres\nDB_PASSWORD=postgres\n' .env
      ;;
  esac

  return 0
}

function setupMariadbConfig(){
  case "$CHOICE_ORMS" in 
      "TypeORM")
      INSTALL_PACKAGES+=("mariadb")
      sed -i "14s/postgres/mariadb/" src/configs/typeorm.config.ts
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=3306\nDB_NAME=mariadb\nDB_USERNAME=root\nDB_PASSWORD=\nSYNCHRONIZE=1\n' .env
      ;;
      "MikroORM")
      INSTALL_PACKAGES+=("@mikro-orm/mariadb")
      sed -i "2c\import { MariaDbDriver } from '@mikro-orm/mariadb';" src/configs/mikroOrm.config.ts
      sed -i "14c\    driver: MariaDbDriver," src/configs/mikroOrm.config.ts
      sed -i '1i \\#Database configs\nDB_HOST=localhost\nDB_PORT=3306\nDB_NAME=mariadb\nDB_USERNAME=root\nDB_PASSWORD=\n' .env
      ;;
  esac

  return 0
}

function setupSqliteConfig(){
  case "$CHOICE_ORMS" in 
      "TypeORM")
      INSTALL_PACKAGES+=("sqlite3")
      sed -i "14s/postgres/sqlite/" src/configs/typeorm.config.ts
      sed -i "5,8d;15,18d" src/configs/typeorm.config.ts
      sed -i "1i \\#Database configs\nDB_NAME=${PROJECT_NAME}.sqlite\nDB_SYNCHRONIZE=1\n" .env
      ;;
      "MikroORM")
      INSTALL_PACKAGES+=("@mikro-orm/sqlite")
      sed -i "2c \\import { SqliteDriver } from '@mikro-orm/sqlite';" src/configs/mikroOrm.config.ts
      sed -i "6,9d;15,18d;14c\    driver: SqliteDriver," src/configs/mikroOrm.config.ts
      sed -i "1i \\#Database configs\nDB_NAME=${PROJECT_NAME}.sqlite\n" .env
      ;;
  esac

  return 0
}