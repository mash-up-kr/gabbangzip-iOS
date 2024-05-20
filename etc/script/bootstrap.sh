#!/bin/sh

set -e

echo "=================================================================="
echo "Bootstrap Script"
echo "=================================================================="

EXECUTION_DIR=${PWD}
echo "- Executed From: ${EXECUTION_DIR}"

SCRIPT_PATH=$(readlink -f "$0")
echo "- Script Path: ${SCRIPT_PATH}"

SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
echo "- Script Directory: ${SCRIPT_DIR}"

WORKSPACE_DIR="$(dirname "$(dirname "${SCRIPT_DIR}")")"
echo "- Workspace Directory: ${WORKSPACE_DIR}"

PROJECT_DIR="${WORKSPACE_DIR}"
echo "- Project Directory: ${PROJECT_DIR}"
echo "------------------------------------------------------------------"

# Ruby Bundler 설치
echo "\n[1] > Installing Ruby Bundler ...\n"
gem install bundler

# Bundle 업데이트(Fastlane 설치)
echo "\n[2] > Updating Bundle(with Fastlane) ...\n"
BUNDLE_GEMFILE="${PROJECT_DIR}/Gemfile" bundle update

# tuistenv tuist 제거
echo "\n[3] > Uninstalling Tuist (tuistenv) ...\n"
curl -Ls https://uninstall.tuist.io | bash

# mise 설치
echo "\n[4] > Installing mise ...\n"
curl https://mise.run | sh

# mise 활성화
echo "\n[5] > Activating mise ...\n"
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc

echo "\n---------------------------------"
echo "::: Bootstrap Script Finished :::"
echo "---------------------------------\n"
