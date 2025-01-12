#!/bin/bash

# Generate folder structure
cd "$PROJECT_NAME/src"
mkdir common configs modules modules/app
cd common
mkdir pipes filters guards middlewares enums decorators utils
cd ../../..