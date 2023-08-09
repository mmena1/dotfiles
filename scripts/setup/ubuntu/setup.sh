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
      action "checking if snapd is enabled"
      if _exists snap ;then
        action "snap install 1password"
        sudo snap install 1password
        ok
      else
        warn "Please install and enable snapd for 1password"
      fi
    else
      ok "Skipping"
    fi
  else
    ok "1password already installed"
  fi
}

install_asdf() {
  bot "Checking asdf..."
  echo
  if ! _exists asdf ; then
    read -p "Would you like to install asdf? [y/N]" -n 1 answer
    echo
    if [[ $answer =~ (yes|y|Y) ]] ;then
      action "Cloning git repo..."
      git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0
      action "Appending source command to config.fish..."
      echo "source ~/.asdf/asdf.fish" >> ~/.config/fish/config.fish
      action "Configuring completions..."
      mkdir -p ~/.config/fish/completions && ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
    else
      ok "Skipping"
    fi
  else
    ok "asdf already installed"
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

main() {

  passwordless_sudo "$*"
  install_packages "$*"
  install_1password "$*"
  install_asdf "$*"
  install_vscode "$*"

}

main "$*"
