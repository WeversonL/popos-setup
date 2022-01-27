#!/bin/zsh

# ----------------------------- VARIABLES ----------------------------- #

DOWNLOADS_DIRECTORY="$HOME/Downloads/Setup"

echo "Please enter your SUDO password: "
read -s PASSWORD

# ----------------------------- ZINIT-CONFIG ----------------------------- #

if ! zinit zstatus; then
    sh -c "$(curl -fsSL https://git.io/zinit-install)"
    echo -e "zinit light zsh-users/zsh-autosuggestions\nzinit light zsh-users/zsh-completions\nzinit light zdharma-continuum/fast-syntax-highlighting" >> ~/.zshrc
fi

# ----------------------------- ASDF-CONFIG ----------------------------- #

if ! la $HOME | ".asdf"; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0 
    echo ". $""HOME/.asdf/asdf.sh" >> ~/.zshrc
    echo -e "fpath=($""{ASDF_DIR}/completions $""fpath)\nautoload -Uz compinit && compinit" >> ~/.zshrc
    source ~/.zshrc
fi

### JAVA ###

if ! asdf list java; then 
    asdf plugin-add java
    asdf install java openjdk-16.0.2
    asdf install java adoptopenjdk-8.0.312+7
    asdf global java system
    echo ". ~/.asdf/plugins/java/set-java-home.zsh" >> ~/.zshrc
fi

# ----------------------------- MYSQL-CONFIG ----------------------------- #

echo $PASSWORD | sudo service mysql start
sudo mysql_secure_installation

# ----------------------------- DOCKER-CONFIG ----------------------------- #

if docker -v; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update && sudo apt install -qq -y docker-ce docker-ce-cli containerd.io docker-compose

    if ! groups | grep docker; then
        echo $PASSWORD | sudo groupadd docker
    fi

    echo $PASSWORD | sudo usermod -aG docker $USER && newgrp docker

fi

# ----------------------------- CLEAN-CONFIG ----------------------------- #

source ~/.zshrc
sudo apt autoclean -y
sudo apt autoremove -y