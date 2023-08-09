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

  xargs -a packages.txt apt install -y

  ok "Installation finished!"
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
  install_vscode "$*"

}

main "$*"
