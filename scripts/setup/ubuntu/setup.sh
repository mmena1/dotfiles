#!/bin/bash

# Bootstrap script for Ubuntu

source ./scripts/lib/echoes.sh
source ./scripts/lib/utils.sh

install_packages() {

  bot "The following packages are going to be installed\n"

  cat ./scripts/setup/ubuntu/packages.txt

  echo

  read -p "Do you want to proceed? [y/N] " -n 1 answer
  echo
  if [[ ! $answer =~ (yes|y|Y) ]];then
    exit 1
  fi

  xargs -a ./scripts/setup/ubuntu/packages.txt sudo apt install -y

  ok "Installation finished!"
}

install_1password() {
  bot "Checking 1password..."
  echo
  if ! _exists 1password ; then
    read -p "Would you like to install 1password? [y/N]" -n 1 answer
    echo
    if [[ $answer =~ (yes|y|Y) ]] ;then
      action "Adding key for apt repo..."
      curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
      action "Adding apt repo..."
      echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
      action "Adding the debsig-verify policy..."
      sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
      curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
      sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
      curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
      action "Installing 1password..."
      sudo apt update && sudo apt install -y 1password
    else
      ok "Skipping"
    fi
  else
    ok "1password already installed"
  fi
}

install_vscode() {
  bot "Checking VSCode..."
  echo
  if ! _exists code ; then
    read -p "Would you like to install vscode? [y/N]" -n 1 answer
    echo
    if [[ $answer =~ (yes|y|Y) ]] ;then
      action "checking if snapd is enabled"
      if _exists snap ;then
        action "snap install code --classic"
        sudo snap install code --classic
        ok
      else
        warn "Please install and enable snapd for VSCode"
      fi
    else
      ok "Skipping"
    fi
  else
    ok "VSCode already installed"
  fi
}

install_starship() {
  bot "Checking starship prompt..."
  if ! _exists starship ; then
    action "curl -sS https://starship.rs/install.sh | sh -s -- -y"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  else
    ok "Starship already installed!"
  fi
}

install_fira_code_nerdfont() {
  bot "Fira Code setup."
  read -p "Would you like to install Fira Code NerdFont to get cool icons on the terminal? [y/N]" -n 1 answer
  echo
  if [[ $answer =~ (yes|y|Y) ]] ;then
    action "Downloading from https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip"
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
    action "Unzipping and adding to ~/.fonts..."
    unzip FiraCode.zip -d ~/.fonts
    fc-cache -fv
    action "rm -rf FiraCode.zip"
    rm -rf FiraCode.zip
  else
    ok "Skipping"
  fi
}

install_github_cli() {
  bot "Checking GitHub CLI..."
  echo
  if ! _exists gh ; then
    read -p "Would you like to install GitHub cli? [y/N]" -n 1 answer
    if [[ $answer =~ (yes|y|Y) ]] ;then
      # Taken from: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
      type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
      && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
      && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
      && sudo apt update \
      && sudo apt install gh -y
    else
      ok "Skipping"
    fi
  else
    ok "GitHub CLI already installed!"
  fi
}

main() {

  passwordless_sudo "$*"
  install_packages "$*"
  install_1password "$*"
  install_vscode "$*"
  install_starship "$*"
  install_fira_code_nerdfont "$*"
  install_github_cli "$*"
}

main "$*"
