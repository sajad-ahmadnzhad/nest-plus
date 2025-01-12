#!/bin/bash

cd "$PROJECT_NAME/src"
rm app.controller.ts app.service.ts
mv app.module.ts modules/app
mv app.controller.spec.ts modules/app
cd ../..