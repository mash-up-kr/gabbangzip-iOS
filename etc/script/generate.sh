#!/bin/sh

set -e

echo "=================================================================="
echo "Generate Script"
echo "=================================================================="

EXECUTION_DIR=${PWD}
echo "- Executed From: ${EXECUTION_DIR}"

SCRIPT_PATH=$(readlink -f "$0")
echo "- Script Path: ${SCRIPT_PATH}"

SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
echo "- Script Directory: ${SCRIPT_DIR}"

WORKSPACE_DIR="$(dirname "$(dirname "${SCRIPT_DIR}")")"
echo "- Workspace Directory: ${WORKSPACE_DIR}"

PROJECT_DIR_NAME="Projects"
PROJECT_NAME="App"
PROJECT_DIR="${WORKSPACE_DIR}/${PROJECT_DIR_NAME}/${PROJECT_NAME}"
echo "- Project Directory: ${PROJECT_DIR}"
echo "------------------------------------------------------------------"

echo -e "\n[1] > mise install and use tuist ...\n"
mise install tuist
mise use use tuist@4.13.0

# Tuist install 실행
echo -e "\n[2] > Installing Tuist ...\n"
tuist install --path "${WORKSPACE_DIR}"
tuist 

# Tuist generate 실행 및 프로젝트 open
echo -e "\n[3] > Generating Tuist ...\n"
TUIST_ROOT_DIR=$PWD tuist generate

echo -e "\n----------------------------------"
echo "::: Generate Script Finished :::"
echo -e "----------------------------------\n"
