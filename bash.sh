#!/bin/bash

# ----------------------------- VARIABLES ----------------------------- #

DOWNLOADS_DIRECTORY="$HOME/Downloads/Setup"

read -p "Please enter your SUDO password: " -s PASSWORD

# ----------------------------- PROGRAMS ----------------------------- #

ESSENTIALS=(
    build-essential
    vim
    git
    curl
    wget
    zsh
    htop
    net-tools
    openssh-client
    tmux
    rar
    unrar
    zip
    unzip
    p7zip-full
    android-tools-adb
    android-tools-fastboot
    android-tools-mkbootimg
    rclone
    hping3
    ncat
    nmap
    whois
    tor
    openjdk-17-jdk
    maven
    mariadb-client
    mariadb-server
    postgresql
    postgresql-contrib
)

OPTIONALS=(
    fonts-inconsolata
    fonts-cascadia-code
    fonts-firacode
    gedit
    gparted
    gnome-tweaks
    gnome-tweak-tool
    grub-customizer
    flameshot
    qbittorrent
    sqlitebrowser
    firefox
    scrcpy
    peek
    gimp
    telegram-desktop
    obs-studio
    chrome-gnome-shell
    virtualbox
    virtualbox-ext-pack
    gnome-menus
)

# ----------------------------- REQUIREMENTS ----------------------------- #

sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock
sudo dpkg --add-architecture i386

# ----------------------------- EXECUTION ----------------------------- #

# Install programs from essential list #

clear
for program in ${ESSENTIALS[@]}; do

    if ! dpkg -l | grep -q $program; then
        echo $PASSWORD | sudo -S apt install -qq -y $program
    fi
done

# Install programs from optional list #

clear
read -p "Do you want to install OPTIONAL PACKAGES? [Y/n]: " preference
case $preference in 
    Y*|y*|"" )
        for program in ${OPTIONALS[@]}; do
            if ! dpkg -l | grep -q $program; then
                echo $PASSWORD | sudo -S apt install -qq -y $program
            fi
        done
        ;;
    N*|n* ) 
        continue;;
esac

# OhMyZsh #

if ! la $HOME | grep ".oh-my-zsh"; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

clear
echo -e "PLEASE RESTART YOUR COMPUTER TO CONTINUE CHANGES WITH SCRIPT 'zsh.sh'\n"