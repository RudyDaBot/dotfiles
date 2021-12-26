#!/bin/bash

# Update System
sudo pacman -Syu

# Color Output and Parallel Downloads
sudo sed -i "s/#Color/Color/" /etc/pacman.conf
sudo sed -i "s/#ParallelDownloads=5/ParallelDownloads=5/" /etc/pacman.conf

# Install Vim, Htop and Git
sudo pacman -S vim htop git base-devel

# Install Yay
git clone https://aur.archlinux.org/yay.git/
cd yay
makepkg -si
cd ..
rm -rf yay/

# Install Virt-Manager with QEMU/KVM
yay -S qemu virt-manager ebtables

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
file=./win.iso
if [[ -f win.iso ]]
then
    sudo pacman -S p7zip
    7z e win.iso sources/install.wim
    sudo 7z e install.wim 1/Windows/{Fonts/"*".{ttf,ttc},System32/Licenses/neutral/"*"/"*"/license.rtf} -o/usr/share/fonts/WindowsFonts/
    rm install.wim
    sudo chmod 655 /usr/share/fonts/WindowsFonts/
    fc-cache --force
else
    echo "Windows iso not found, skipping microsoft fonts installation. Please make sure a Windows iso with the name 'win.iso' is present in the same directory as this script"
fi

# Install Python
sudo pacman -S python python-pip

# Install NodeJS via Node Version Manager
version=`python3 getNVMVersion.py`
url="https://raw.githubusercontent.com/nvm-sh/nvm/${version}/install.sh"

curl -o- $url | bash

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo
