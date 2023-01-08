#!/bin/bash

# Bootstrap script for Manjaro

source ./scripts/lib/echoes.sh
source ./scripts/lib/utils.sh

require_pamac() {
    running "pacman $1 $2"
    if ! pacman -Qi $1 > /dev/null 2>&1 ; then
        action "pamac install $1 $2"
        sudo pamac install $1 $2
        if [[ $? != 0 ]]; then
            error "failed to install $1! aborting..."
            # exit -1
        fi
    fi
    ok
}

install_packages() {

  bot "The following packages are going to be installed\n"

  cat ./scripts/setup/pkglist.txt

  echo

  read -p "Do you want to proceed? [y/N] " -n 1 answer
  echo
  if [[ ! $answer =~ (yes|y|Y) ]];then
    exit 1
  fi

  for F in $(cat ./scripts/setup/pkglist.txt); do
    require_pamac $F --no-confirm
  done

  ok "Installation finished!"
}

install_vscode() {
  bot "VSCode"
  read -p "Would you like to install vscode? [y/N]" -n 1 answer
  echo
    if [[ $answer =~ (yes|y|Y) ]];then
        action "checking if snapd is enabled"
        if [ ! systemctl is-enabled snapd > /dev/null 2>&1 ];then
          action "enabling snapd"
          sudo systemctl enable --now snapd.socket
          ln -s /var/lib/snapd/snap /snap
          ok
        fi
        action "snap install code --classic"
        snap install code --classic
        ok
    else
      ok "Skipping"
    fi
}

main() {

  passwordless_sudo "$*"
  install_packages "$*"
  install_vscode "$*"

}

main "$*"
