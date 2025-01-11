#!/bin/bash
source scripts/core/helpers.sh

bash scripts/dependencies/install-fzf.sh

# Get project name form user
get_project_name

# Get the selected package manager
get_package_manager $PROJECT_NAME

# Setup env files
setup_envs

# Generate modular folder structure
bash scripts/core/generate_structure.sh

# Setup base appModule
setupAppModule

# Updates the path of the main application file
modifyMainFile

# Removes ESLint and Prettier configuration files.
removePrettierAndESLint

# Removes Test configuration files.
removeTestFiles

bash scripts/features/orm_selection.sh

bash scripts/features/database_selection.sh

bash scripts/features/other_selection.sh

setupConfigModule

manageEnvFile

bash scripts/features/install_dependencies_selection.sh