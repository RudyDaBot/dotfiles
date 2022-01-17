#!/bin/bash
compose_path=/usr/local/lib/docker/cli-plugins
sudo mkdir -p $compose_path

compose_version=`python3 utils/get-repo-version.py docker/compose`
url="https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-linux-x86_64"

sudo wget $url -P $compose_path
