#!/bin/bash

if [ "$EUID" -ne 0 ] then 
cat << EOF
┌----------------------------------------------------------------------┐
|Please don't run this script as root. We will ask you for the         |
|password if we need root access.                                      |
└----------------------------------------------------------------------┘
┬─┬ ノ( ゜-゜ノ)
EOF
exit
fi

cat << EOF
┌----------------------------------------------------------------------┐
|This Bash Script is made by Rishab (@Grobo021 on GitHub) to install:  |
|* Vim                                                                 |
|* HTop                                                                |
|* Git                                                                 |
|* ZSH                                                                 |
|* VSCode                                                              |
|* Chromium                                                            |
|* Librewolf                                                           |
|* Github CLI                                                          |
|* Python3 with PiP and Venv                                           |
|* NodeJS via the Node Version Manager                                 |
|* Rust                                                                |
|* Docker and Docker Compose                                           |
|* Flatpak                                                             |
|* Microsoft Fonts                                                     |
|                                                                      |
|Note: Please pay attention to yay prompts                             |
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

# Update System
sudo pacman -Syu

# Color Output and Parallel Downloads
sudo sed -i "s/#Color/Color/" /etc/pacman.conf
sudo sed -i "s/#ParallelDownloads=5/ParallelDownloads=5/" /etc/pacman.conf

# Install Things 
sudo pacman -S --no-confirm \
    # Vim, HTop, GiT
    vim htop git \
    # Important system tools like fakeroot
    base-devel \
    # 7zip but for linux, needed for microsoft fonts
    p7zip \
    # Z Shell
    zsh \
    # Python and PiP package manager
    python python-pip \
    # Github CLI and Chromium
    github-cli chromium \
    # Docker and Flatpak
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
    # QEMU/KVM with Virt-Manager
    qemu virt-manager ebtables \
    # VSCode
    visual-studio-code-bin \
    # Librewolf
    librewolf-bin

# Add the person running this script to the libvirt and docker groups
sudo usermod -aG libvirt $USER
sudo usermod -aG docker $USER

# Enable and Start Libvirt Daemon
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

# Install Microsoft Fonts
./utils/microsoft-fonts-install.sh

# Install NodeJS via Node Version Manager
./utils/nvm-install.sh

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Docker Compose
./utils/docker-compose-install.sh

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
|that changes take effect.                                            |
└---------------------------------------------------------------------┘
(╯°□°）╯︵ ┻━┻ 
EOF
echo
