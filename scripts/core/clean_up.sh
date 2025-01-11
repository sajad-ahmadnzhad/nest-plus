#!/bin/bash
source scripts/core/generate_structure.sh

cd src
rm app.controller.ts app.service.ts
mv app.module.ts modules/app
cd ..