#!/bin/bash

# Fail on errors
set -e

echo "Starting Minimal Ubuntu Setup..."

# Update and Upgrade
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install Essential Packages
echo "Installing essential packages..."
sudo apt install -y build-essential curl wget git vim net-tools openssh-server

# Optional: Install Desktop Environment
echo "Would you like to install a desktop environment?"
echo "1) Lubuntu (Lightweight)"
echo "2) Xubuntu (Midweight)"
echo "3) Ubuntu Default (Heavier)"
echo "4) No Desktop (Minimal Setup)"
read -p "Enter your choice (1/2/3/4): " DESKTOP_CHOICE

case $DESKTOP_CHOICE in
    1) echo "Installing Lubuntu..."; sudo apt install -y lubuntu-desktop ;;
    2) echo "Installing Xubuntu..."; sudo apt install -y xubuntu-desktop ;;
    3) echo "Installing Ubuntu Desktop..."; sudo apt install -y ubuntu-desktop ;;
    4) echo "Skipping Desktop Installation." ;;
    *) echo "Invalid choice. No desktop will be installed." ;;
esac

# Install Dev Tools (Optional)
echo "Would you like to install development tools (Python, Docker)? (y/n)"
read -p "Enter your choice: " INSTALL_DEV

if [ "$INSTALL_DEV" == "y" ]; then
    echo "Installing development tools..."
    sudo apt install -y python3 python3-pip docker.io
fi

# Final Cleanup
echo "Cleaning up..."
sudo apt autoremove -y

echo "Setup complete! Reboot your system for changes to take effect."
read -p "Reboot now? (y/n): " REBOOT

if [ "$REBOOT" == "y" ]; then
    sudo reboot
else
    echo "Please reboot manually when ready."
fi

