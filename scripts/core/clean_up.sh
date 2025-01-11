#!/bin/bash
source generate_structure.sh

cd src
rm app.controller.ts app.service.ts
mv app.module.ts modules/app
cd ..