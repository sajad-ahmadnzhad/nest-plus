#!/bin/bash

function setupSwaggerConfig(){ 
cd src

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

cd ..

INSTALL_PACKAGES+=("@nestjs/swagger")

  return 0
}