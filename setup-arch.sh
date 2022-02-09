#!/bin/bash

if [[ "$EUID" == 0 ]]
then 
cat << EOF
┌──────────────────────────────────────────────────────────────────────┐
│Please don't run this script as root as it may break you system.      │
│We will ask you for the password if we need root access.              │
└──────────────────────────────────────────────────────────────────────┘
┬─┬ ノ( ゜-゜ノ)
EOF
exit
fi

cat << EOF
┌──────────────────────────────────────────────────────────────────────┐
│This Bash Script is made by Rishab (@Grobo021 on GitHub) to install:  │
│* Vim                                                                 │
│* HTop                                                                │
│* Git                                                                 │
│* ZSH                                                                 │
│* VSCode                                                              │
│* Chromium                                                            │
│* Librewolf                                                           │
│* Github CLI                                                          │
│* Python3 with PiP and Venv                                           │
│* NodeJS via the Node Version Manager                                 │
│* Rust                                                                │
│* Docker and Docker Compose                                           │
│* Flatpak                                                             │
│                                                                      │
│Note: Please pay attention to yay prompts                             │
│                                                                      │
│Optionally: This script can also run ./utils/venv-create.sh for you   │
│Optionally: This script can also install Microsoft Fonts              │
└──────────────────────────────────────────────────────────────────────┘
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
sudo pacman -S --noconfirm \
    vim htop git \
    base-devel \
    p7zip \
    zsh \
    python python-pip \
    github-cli chromium \
    docker flatpak

# Install Yay
git clone https://aur.archlinux.org/yay.git/
cd yay
makepkg -si
cd ..
rm -rf yay/

# Change user shell to zsh
chsh -s $(which zsh)

# Install More things
yay -S \
    qemu virt-manager ebtables \
    visual-studio-code-bin \
    librewolf-bin

# Add the person running this script to the libvirt and docker groups
sudo usermod -aG libvirt $USER
sudo usermod -aG docker $USER

# Enable and Start Libvirt Daemon
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

# Install NodeJS via Node Version Manager
./utils/nvm-install.sh

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Docker Compose
./utils/docker-compose-install.sh

# Run Virtual Python Environment Script
while true; do
    read -p "Do you wish to run the virtual python environment script? " yn1
    case $yn1 in
        [Yy]* ) ./utils/venv-create.sh --noconfirm; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Install Microsoft fonts
while true; do
    read -p "Do you wish to install Microsoft Fonts? " yn2
    case $yn2 in
	[Yy]* ) ./utils/microsoft-fonts-install.sh; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

cat << EOF
┌─────────────────────────────────────────────────────────────────────┐
│All Done! This script has succesfully completed, please reboot so    │
│that changes take effect.                                            │
└─────────────────────────────────────────────────────────────────────┘
(╯°□°）╯︵ ┴─┴ 
EOF
echo
