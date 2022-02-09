#!/bin/bash
nvm_version=`python3 ./utils/get-repo-version.py --release nvm-sh/nvm`
url="https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_version}/install.sh"

curl -o- $url | zsh
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc
