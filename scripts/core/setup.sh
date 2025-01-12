#!/bin/bash
set -e

source scripts/core/helpers.sh

source scripts/dependencies/install-fzf.sh

trap cleanupTmpFile EXIT SIGINT SIGTERM

# Get project name form user
get_project_name

# Get the selected package manager
get_package_manager 

# Setup env files
setup_envs

# Generate modular folder structure
source scripts/core/generate_structure.sh

source scripts/core/clean_up.sh

# Setup base appModule
setupAppModule

# Updates the path of the main application file
modifyMainFile

# Removes ESLint and Prettier configuration files.
removePrettierAndESLint

# Removes Test configuration files.
removeTestFiles

source scripts/features/orm_selection.sh 

source scripts/features/database_selection.sh

source scripts/features/other_selection.sh

setupConfigModule

manageEnvFile

source scripts/features/install_dependencies_selection.sh