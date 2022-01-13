#!/bin/bash

# Update System
sudo pacman -Syu

# Color Output and Parallel Downloads
sudo sed -i "s/#Color/Color/" /etc/pacman.conf
sudo sed -i "s/#ParallelDownloads=5/ParallelDownloads=5/" /etc/pacman.conf

# Install Things 
sudo pacman -S vim htop git base-devel p7zip

# Install Yay
git clone https://aur.archlinux.org/yay.git/
cd yay
makepkg -si
cd ..
rm -rf yay/

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
sudo pacman -S github-cli

# Install Chromium
sudo pacman -S chromium

# Install Microsoft Fonts
./microsoft-fonts-install.sh

# Install Python
sudo pacman -S python python-pip

# Install NodeJS via Node Version Manager
version=`python3 getNVMVersion.py`
url="https://raw.githubusercontent.com/nvm-sh/nvm/${version}/install.sh"

curl -o- $url | bash

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo
