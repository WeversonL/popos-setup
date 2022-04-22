#!/usr/bin/env bash

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
rm /var/lib/dpkg/lock-frontend
rm /var/cache/apt/archives/lock
dpkg --add-architecture i386
apt update >/dev/null 2>&1 && apt upgrade -y >/dev/null 2>&1

# ----------------------------- EXECUTION ----------------------------- #
function execution() {

    # Install programs from essential list #
    for program in ${ESSENTIALS[@]}; do
        apt install -y $program >/dev/null 2>&1
    done

    # Install programs from optional list #
    read -p "Do you want to install OPTIONAL PACKAGES? [Y/n]: " preference
    case $preference in
    Y* | y* | "")
        for program in ${OPTIONALS[@]}; do
            apt install -y $program >/dev/null 2>&1
        done
        ;;
    N* | n*)
        continue
        ;;
    esac

    # Install Docker #
    apt remove -y docker docker-engine docker.io containerd runc

    rm -rf /etc/apt/sources.list.d/docker.list

    apt install -y ca-certificates curl gnupg lsb-release

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt update && apt install docker-ce docker-ce-cli containerd.io

    if ! getent group docker >/dev/null 2>&1; then
        groupadd docker >/dev/null 2>&1
    fi

    usermod -aG docker "$NORMAL_USER" && newgrp docker

    # Clean Config #

    apt autoclean -y
    apt autoremove -y

}

# ----------------------------- SCRIPT SETTINGS ----------------------------- #
BUILD_DIRECTORY="/tmp/Downloads"
NORMAL_USER=$(getent passwd 1000 | cut -d ":" -f1)

# Colours Variables
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
LIGHTGRAY='\033[00;37m'
LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LPURPLE='\033[01;35m'
LCYAN='\033[01;36m'
WHITE='\033[01;37m'

function banner() {

    echo -e "$CYAN" ""
    echo -e " ____              ___  ____    ____       _               
|  _ \ ___  _ __  / _ \/ ___|  / ___|  ___| |_ _   _ _ __  
| |_) / _ \| '_ \| | | \___ \  \___ \ / _ \ __| | | | '_ \ 
|  __/ (_) | |_) | |_| |___) |  ___) |  __/ |_| |_| | |_) |
|_|   \___/| .__/ \___/|____/  |____/ \___|\__|\__,_| .__/ 
           |_|                                      |_|    
"
    echo -e "$LIGHTGRAY ---------------------------------------------------------------------------------"
    echo -e "$RESTORE"

}

function checkConnection() {
    echo -e "$LYELLOW [ * ]$RESTORE Checking for internet connection"
    sleep 1
    echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "$RED [ X ]$RESTORE Internet Connection ➜$RED OFFLINE!\n"
        echo -e "$RED Sorry, you really need an internet connection....$RESTORE"
        exit 0
    else
        echo -e "$GREEN [ ✔ ]$RESTORE Internet Connection ➜$GREEN CONNECTED!\n"
        sleep 1
    fi
}

function install() {
    local programName=$1
    echo -e "$CYAN ==>$RESTORE Installing $CYAN$programName$RESTORE...$RESTORE"
}

function installed() {
    local programName=$1
    echo -e "$GREEN ==>$RESTORE INSTALLED $CYAN$programName$RESTORE! $RESTORE\n"
}

function end() {
    echo -e "$CYAN\n Restart your PC and run zsh.sh [with ZSH Shell]..... ;)"
    exit 0
}

function checkSudo() {
    echo -e "$LYELLOW [ * ]$RESTORE Checking for sudo permission"
    sleep 1
    if (($(id -u) != 0)); then
        echo -e "$RED [ X ]$RESTORE Please run as $LYELLOW=> SUDO$RESTORE\n"
        exit
    fi
    echo -e "$GREEN [ ✔ ]$RESTORE Everything is $GREEN=> OK$RESTORE\n"
}

main() {
    banner
    checkSudo
    checkConnection
    execution
}

main
