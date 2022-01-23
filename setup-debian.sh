#!/bin/bash

cat << EOF
┌----------------------------------------------------------------------┐
|This Bash Script is made by Rishab (@Grobo021 on GitHub) to install:- |
|* Vim                                                                 |
|* HTop                                                                |
|* Git                                                                 |
|* ZSH                                                                 |
|* VSCode                                                              |
|* Chrome                                                              |
|* Github CLI                                                          |
|* Python3 with PiP and Venv                                           |
|* NodeJS via the Node Version Manager                                 |
|* Rust                                                                |
|* Docker and Docker Compose                                           |
|* Flatpak                                                             |
|* Microsoft Fonts                                                     |
|                                                                      |
|Optionally: This script can also run `./utils/venv-create.sh` for you |
└----------------------------------------------------------------------┘
EOF

while true; do
    read -p "Do you wish to run the setup script? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Add Universe and Multiverse repos
sudo add-apt-repository universe
sudo add-apt-repository multiverse
sudo apt-get update

# Install Things
sudo apt-get --assume-yes install \
	vim htop git \
	ovmf virt-manager \
	p7zip-full p7zip-rar \
	software-properties-common apt-transport-https \
	python3 python3-pip python3-venv \
	zsh

# Change user shell to zsh
chsh -s $(which zsh)

# Add the person running this script to the libvirt group
sudo usermod -aG libvirt $USER

# Enable Libvirt Daemon
sudo systemctl enable libvirtd

# Install VSCode 
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt-get update
sudo apt-get install --assume-yes code

# Install Github CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

sudo apt-get update
sudo apt-get install --assume-yes gh

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# Install Microsoft Fonts
./utils/microsoft-fonts-install.sh

# Install NodeJS via Node Version Manager
./utils/nvm-install.sh

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install --assume-yes docker-ce docker-ce-cli containerd.io

# Install Docker Compose
./utils/docker-compose-install.sh

# Install Flatpak
sudo apt install flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Run Virtual Python Environment Script
while true; do
    read -p "Do you wish to run the virtual python environment script? " yn
    case $yn in
        [Yy]* ) ./utils/venv-create.sh --noconfirm;; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

cat << EOF
┌---------------------------------------------------------------------┐
|All Done! This script has succesfully completed, please reboot so    |
|that changes take effect :)                                          |
└---------------------------------------------------------------------┘
(╯°□°）╯︵ ┻━┻ 
EOF
echo
