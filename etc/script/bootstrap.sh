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

# Ruby 버전 고정 및 설치
echo "\n[1] > Installing Ruby version from .ruby-version ...\n"
if ! command -v rbenv &> /dev/null; then
  echo "rbenv is not installed. Installing rbenv ..."
  brew install rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - zsh)"
fi

RUBY_VERSION=$(cat "${PROJECT_DIR}/.ruby-version")
if ! rbenv versions | grep -q $RUBY_VERSION; then
  echo "Installing Ruby $RUBY_VERSION ..."
  rbenv install $RUBY_VERSION
fi

rbenv global $RUBY_VERSION
echo "Ruby version: $(ruby -v)"

# Ruby Bundler 설치
echo "\n[2] > Installing Ruby Bundler ...\n"
gem install bundler

# Bundle 업데이트(Fastlane 설치)
echo "\n[3] > Updating Bundle (with Fastlane) ...\n"
BUNDLE_GEMFILE="${PROJECT_DIR}/Gemfile" bundle update

# npm 설치
if ! command -v npm &> /dev/null; then
  echo "\n[4] > Installing npm ...\n"
  brew install node
fi

# grunt-cli 설치
cd "${PROJECT_DIR}"
if ! command -v grunt &> /dev/null; then
  echo "\n[5] > Installing grunt-cli ...\n"
  npm install -g grunt-cli
fi

# 로컬 grunt 설치
if [[ ! -d node_modules/grunt ]]; then
  echo "\n[6] > Installing grunt ...\n"
  npm install
fi

# mise 설치
if ! command -v mise &> /dev/null; then
  echo "\n[7] > Installing mise ...\n"
  curl https://mise.run | sh
else
  echo "mise is already installed."
fi

# mise 활성화
echo "\n[8] > Activating mise ...\n"
if ! grep -q 'eval "$(~/.local/bin/mise activate zsh)"' ~/.zshrc; then
  echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
else
  echo "mise is already activated in ~/.zshrc"
fi

# fastlane match를 통한 development Cert, Provisioning 가져오기
echo "\n[9] > Getting development Cert and Provisioning ...\n"
fastlane match development --readonly

echo "\n---------------------------------"
echo "::: Bootstrap Script Finished :::"
echo "---------------------------------\n"
