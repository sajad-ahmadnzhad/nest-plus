#!/bin/bash

function setupRedisConfig(){
cd $PROJECT_NAME/src
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

if [ "$CHOICE_ORMS" = "No Database" ]; then
  sed -i '4c\\  imports: [\n    RedisModule.forRoot(redisConfig())\n  ],' "modules/app/app.module.ts"
  sed -i '1a\import { RedisModule } from "@nestjs-modules/ioredis";\nimport redisConfig from "../../configs/redis.config";' modules/app/app.module.ts
else
  sed -i '2a\import { RedisModule } from "@nestjs-modules/ioredis";\nimport redisConfig from "../../configs/redis.config";' modules/app/app.module.ts
  sed -i '9s/$/,/;10i\    RedisModule.forRoot(redisConfig())' "modules/app/app.module.ts"
fi

sed -i '1i \#Redis configs\nREDIS_HOST=localhost\nREDIS_PORT=6379\nDB_PASSWORD=\n' ../.env

cd ../..

savePackages "@nestjs-modules/ioredis"

  return 0
}


function setupRedisCacheManagerConfig() {
cd $PROJECT_NAME/src
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

if [ "$CHOICE_ORMS" != "No Database" ]; then
  sed -i '3i \\import { CacheModule } from "@nestjs/cache-manager";\nimport { cacheConfig } from "../../configs/cache.config";' modules/app/app.module.ts
  sed -i '9s/$/,/' modules/app/app.module.ts
  sed -i '10i \\    CacheModule.registerAsync(cacheConfig())' modules/app/app.module.ts
else
  sed -i '4c \  imports: [\n    CacheModule.registerAsync(cacheConfig())\n  ],' modules/app/app.module.ts
  sed -i '2i \\import { CacheModule } from "@nestjs/cache-manager";\nimport { cacheConfig } from "../../configs/cache.config";' modules/app/app.module.ts
fi

sed -i '1i \#Redis configs\nREDIS_HOST=localhost\nREDIS_PORT=6379\nDB_PASSWORD=\n' ../.env

cd ../..

savePackages "@nestjs/cache-manager" "cache-manager-redis-yet"

return 0
}