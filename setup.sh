#!/bin/bash

# Add Universe and Multiverse repos
sudo add-apt-repository universe
sudo add-apt-repository multiverse
sudo apt-get update

# Install NVim, Htop and Git
sudo apt-get install vim htop git

# Install Virt-Manager with QEMU/KVM
sudo apt-get install -y ovmf virt-manager

# Get QEMU User credentials
read -p "Enter username for QEMU user: " qemuUser
read -sp "Enter password for QEMU user: " qemuPass

# Create QEMU user with a user id less than 1000
sudo useradd -m -r -p $qemuPass -u 196 $qemuUser

# Add QEMU user to the sudo and libvirt groups
sudo usermod -aG sudo,libvirt $qemuUser

# Add the person running this script to the libvirt group
sudo usermod -aG libvirt $USER

# Make QEMU use our new QEMU user
sudo sed -i "s/#user = \"root\"/user = \"$qemuUser\"/" /etc/libvirt/qemu.conf

# Enable Libvirt Daemon
sudo systemctl enable libvirtd

# Add Microsoft Packages to the apt sources
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm packages.microsoft.gpg

# Install VSCode
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install code

# Install Github CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt-get update
sudo apt-get install gh

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# Install Microsoft Fonts
file=./win.iso
if [[ -f win.iso ]]
then
    sudo apt-get install p7zip-full p7zip-rar
    7z e win.iso sources/install.wim
    sudo 7z e install.wim 1/Windows/{Fonts/"*".{ttf,ttc},System32/Licenses/neutral/"*"/"*"/license.rtf} -o/usr/share/fonts/WindowsFonts/
    rm install.wim
    sudo chmod 655 /usr/share/fonts/WindowsFonts/
    fc-cache --force
else
    echo "Windows iso not found, skipping microsoft fonts installation. Please make sure a Windows iso with the name 'win.iso' is present in the same directory as this script"
fi

# Install Python      
sudo apt-get install python3 python3-pip python3-venv

# Install NodeJS via Node Version Manager
version=`python3 getNVMVersion.py`
url="https://raw.githubusercontent.com/nvm-sh/nvm/${version}/install.sh"

curl -o- $url | bash

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo
