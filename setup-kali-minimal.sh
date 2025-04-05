#!/bin/bash

echo "[+] Updating package lists..."
sudo apt update && sudo apt upgrade -y

echo "[+] Installing essential tools..."
sudo apt install -y \
    sudo curl wget git build-essential \
    net-tools dnsutils unzip gnupg lsb-release \
    software-properties-common htop tmux neofetch

echo "[+] Installing networking & pentesting tools..."
sudo apt install -y \
    nmap netcat-traditional whois \
    tcpdump traceroute wireshark \
    iputils-ping iperf3 \
    burpsuite sqlmap gobuster ffuf \
    nikto seclists dirb wfuzz masscan \
    netdiscover dnsenum

echo "[+] Installing wordlists..."
sudo apt install -y rockyou wordlists seclists
gunzip -f /usr/share/wordlists/rockyou.txt.gz

echo "[+] Installing recon + bug bounty tools..."
sudo apt install -y \
    subfinder amass \
    httpx nuclei assetfinder \
    jq

echo "[+] Installing Python and popular libraries..."
sudo apt install -y python3 python3-pip python3-venv
pip3 install --upgrade pip
pip3 install requests beautifulsoup4 lxml

echo "[+] Installing Golang..."
sudo apt install -y golang

echo "[+] Installing shell & terminal goodies..."
sudo apt install -y \
    zsh fonts-powerline \
    tmux neovim tree bat fzf exa lnav

echo "[+] Installing clipboard support for UTM..."
sudo apt install -y spice-vdagent
sudo systemctl enable --now spice-vdagent

echo "[+] Optional firewall setup..."
sudo apt install -y ufw
sudo ufw enable

echo "[+] Done! You may want to reboot for all changes to apply."

