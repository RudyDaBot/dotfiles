#!/bin/bash
nvm_version=`python3 --release utils/get-repo-version.py nvm-sh/nvm`
url="https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_version}/install.sh"

curl -o- $url | bash
