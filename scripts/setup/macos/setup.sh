#!/bin/bash

# Bootstrap script for Ubuntu

source ./scripts/lib/echoes.sh
source ./scripts/lib/utils.sh

install_homebrew() {
  bot "Checking brew..."
  echo
  if ! _exists brew ; then
    read -p "Would you like to install Homebrew? [y/N]" -n 1 answer
    echo
    if [[ $answer =~ (yes|y|Y) ]] ;then
      action "Installing homebrew..."
      export NONINTERACTIVE=1
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
      brew analytics off
      ok "Brew installed"
    else
      ok "Skipping"
    fi
  else
    ok "brew already installed"
  fi
}

install_dependencies() {
  bot "Installing dependencies..."
  echo
  read -p "Would you like to install dependencies from the Brewfile? [y/N]" -n 1 answer
    echo
    if [[ $answer =~ (yes|y|Y) ]] ;then
      action "Installing dependencies..."
      if _exists brew ; then
        brew bundle
        ok "Dependencies installed"
      else
        warn "Homebrew not found, skipping..."
      fi
    else
      ok "Skipping"
    fi
}

add_fish_to_known_shells() {
  if ! grep fish /etc/shells > /dev/null 2>&1; then
    sudo sh -c 'echo /opt/homebrew/bin/fish >> /etc/shells'
    bot "Please close this shell window so changes take effect."
    echo
    read -p "Press any key to continue"
    exit 0
  fi
}

main() {
  passwordless_sudo "$*"
  install_homebrew "$*"
  install_dependencies "$*"
  add_fish_to_known_shells "$*"
}

main "$*"
