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

# Homebrew 설치 및 업데이트
echo "\n[0] > Installing or Updating Homebrew ...\n"
if ! command -v brew &> /dev/null; then
  echo "Homebrew is not installed. Installing Homebrew ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed. Updating Homebrew ..."
  brew update
fi

# Ruby 버전 최신으로 업데이트 및 설치
echo "\n[1] > Updating and Installing latest Ruby version ...\n"
if ! command -v rbenv &> /dev/null; then
  echo "rbenv is not installed. Installing rbenv ..."
  brew install rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - zsh)"
fi

LATEST_RUBY_VERSION=$(rbenv install -l | grep -v - | grep -v rc | tail -1)
if ! rbenv versions | grep -q $LATEST_RUBY_VERSION; then
  echo "Installing Ruby $LATEST_RUBY_VERSION ..."
  rbenv install $LATEST_RUBY_VERSION
fi

rbenv global $LATEST_RUBY_VERSION
echo "Ruby version: $(ruby -v)"

# Ruby Bundler 설치
echo "\n[2] > Installing Ruby Bundler ...\n"
gem install bundler

# Bundle 업데이트(Fastlane 설치)
echo "\n[3] > Updating Bundle (with Fastlane) ...\n"
BUNDLE_GEMFILE="${PROJECT_DIR}/Gemfile" bundle update

# tuistenv tuist 제거
echo "\n[4] > Uninstalling Tuist (tuistenv) ...\n"
curl -Ls https://uninstall.tuist.io | bash

# mise 설치
echo "\n[5] > Installing mise ...\n"
curl https://mise.run | sh

# mise 활성화
echo "\n[6] > Activating mise ...\n"
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc

echo "\n---------------------------------"
echo "::: Bootstrap Script Finished :::"
echo "---------------------------------\n"
