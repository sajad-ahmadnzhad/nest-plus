#!/bin/bash
source helpers.sh

# Get project name form user
get_project_name

# Get the selected package manager
get_package_manager $PROJECT_NAME

# Setup env files
setup_envs