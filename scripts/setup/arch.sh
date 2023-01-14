#!/bin/bash

# Bootstrap script for non-Manjaro Arch distros

source ./scripts/lib/echoes.sh
source ./scripts/lib/utils.sh

require_yay() {
    running "pacman $1 $2"
    if ! pacman -Qi $1 > /dev/null 2>&1 ; then
        action "yay -S $1 $2"
        yay -S $1 $2
        if [[ $? != 0 ]]; then
            error "failed to install $1! aborting..."
            # exit -1
        fi
    fi
    ok
}

install_package_manager() {
  bot "Looking for yay package manager"
  echo
  if ! _exists yay ; then
    read -p "Yay not found. Do you want to install it (required)? [y/N] " -n 1 answer
    echo
    if [[ ! $answer =~ (yes|y|Y) ]];then
      exit 1
    fi
    action "git clone https://aur.archlinux.org/yay-bin.git ~"
    git clone https://aur.archlinux.org/yay-bin.git ~
    ok
    action "makepkg -si --noconfirm"
    cd ~/yay-bin
    makepkg -si --noconfirm
    ok
  else
    echo "Yay binary found. Skipping... "
  fi
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
    require_yay $F --noconfirm --noprovides --answerdiff None --answerclean None --mflags "--noconfirm" > /dev/null 2>&1
  done

  ok "Installation finished!"
}

install_vscode() {
  bot "VSCode"
  echo
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
  install_package_manager "$*"
  install_packages "$*"
  install_vscode "$*"

}

main "$*"
