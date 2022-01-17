#!/bin/bash

cat << EOF
┌----------------------------------------------------------------------┐
|This Bash Script is made by Rishab (@Grobo021 on GitHub) to install:- |
|* Vim                                                                 |
|* HTop                                                                |
|* Git                                                                 |
|* ZSH                                                                 |
|* VSCode                                                              |
|* Chromium                                                            |
|* Github CLI                                                          |
|* NodeJS via the Node Version Manager                                 |
|* Rust                                                                |
|* Docker and Docker Compose                                           |
|* Microsoft Fonts                                                     |
|                                                                      |
|Note:- Please pay attention to yay prompts,                           |
|since i don't know how to autofill them *yet*                         |
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

# Update System
sudo pacman -Syu

# Color Output and Parallel Downloads
sudo sed -i "s/#Color/Color/" /etc/pacman.conf
sudo sed -i "s/#ParallelDownloads=5/ParallelDownloads=5/" /etc/pacman.conf

# Install Things 
sudo pacman -S --no-confirm \ 
    vim htop git \
    base-devel \
    p7zip \
    zsh \
    python python-pip

# Install Yay
git clone https://aur.archlinux.org/yay.git/
cd yay
makepkg -si
cd ..
rm -rf yay/

# Change user shell to zsh
chsh -s $(which zsh)

# Install Virt-Manager with QEMU/KVM
yay -S qemu virt-manager ebtables

# Add the person running this script to the libvirt group
sudo usermod -aG libvirt $USER

# Enable and Start Libvirt Daemon
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

# Install VSCode
yay -S visual-studio-code-bin

# Install Github CLI
sudo pacman -S --noconfirm github-cli

# Install Chromium
sudo pacman -S --noconfirm chromium

# Install Microsoft Fonts
./utils/microsoft-fonts-install.sh

# Install NodeJS via Node Version Manager
./utils/nvm-install.sh

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Docker
sudo pacman -S --noconfirm docker

# Install Docker Compose
./utils/docker-compose-install.sh

cat << EOF
┌---------------------------------------------------------------------┐
|All Done! This script has succesfully completed, please reboot so    |
|that changes take effect :)                                          |
└---------------------------------------------------------------------┘
EOF
echo
