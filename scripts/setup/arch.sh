#!/bin/bash

# Bootstrap script for non-Manjaro Arch distros

source ./scripts/lib/echoes.sh
source ./scripts/lib/utils.sh

require_yay() {
    running "pacman $1 $2"
    if ! pacman -Qi $1 > /dev/null 2>&1 ; then
        action "yay -S $1 $2"
        yay -S $1 $2 > /dev/null 2>&1
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
    require_yay $F --noconfirm --noprovides --answerdiff None --answerclean None --mflags "--noconfirm"
  done

  ok "Installation finished!"
}

install_snapd() {
  bot "Checking snapd..."
  echo
  if ! _exists snap ;then
    echo
    read -p "Would you like to install the snapd store for propietary apps such as MS VSCode? [y/N]" -n 1 answer
    echo
    if [[ $answer =~ (yes|y|Y) ]];then
      action "checking if snapd exists"
      require_yay snapd --noconfirm
      action "enabling apparmor"
      sudo systemctl enable --now snapd.apparmor
      ok
      action "enabling snapd"
      sudo systemctl enable --now snapd.socket
      sudo ln -s /var/lib/snapd/snap /snap
      ok
    else
      ok "Skipping"
    fi
  else
    ok "Snapd already installed!"
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
  install_package_manager "$*"
  install_packages "$*"
  install_snapd "$*"
  install_vscode "$*"

}

main "$*"
