#!/bin/bash

function setupCorsConfig(){
cd $PROJECT_NAME

touch src/configs/cors.config.ts

cat << 'EOF' > src/configs/cors.config.ts
import { INestApplication } from "@nestjs/common";

export const corsConfig = (app: INestApplication) => {
  const ALLOWED_ORIGINS: string[] =
    JSON.parse(process.env.ALLOWED_ORIGINS || '[]') || [];

  app.enableCors({
    origin: ALLOWED_ORIGINS,
    methods: ["GET", "POST", "PATCH", "PUT", "DELETE"],
    credentials: true,
  });
};
EOF

if grep -q "swagger" src/main.ts; then
    sed -i '12i \\  corsConfig(app);\n' src/main.ts
    sed -i '4i \\import { corsConfig } from "./configs/cors.config"' src/main.ts
else 
    sed -i '9i \\  corsConfig(app);\n' src/main.ts
    sed -i '3a \\import { corsConfig } from "./configs/cors.config"' src/main.ts
fi

sed -i '1i \\#Cors configs\nALLOWED_ORIGINS=[]\n' .env

cd ..    
    return 0
}