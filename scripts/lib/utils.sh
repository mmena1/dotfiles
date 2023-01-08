#!/usr/bin/env bash

_exists() {
  command -v "$1" > /dev/null 2>&1
}

passwordless_sudo() {
  if ! sudo -nv > /dev/null 2>&1 ;then
    echo "Please provide your sudo password:"
    sudo -v
  fi
  # Keep-alive: update existing sudo time stamp until the script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  # Do we need to ask for sudo password or is it already passwordless?
  if ! sudo grep -q 'NOPASSWD:     ALL' /etc/sudoers.d/$LOGNAME > /dev/null 2>&1 ;then
    echo "no sudoer file"

    bot "Do you want to run sudo without a password?"

    read -r -p "Make sudo passwordless? [y/N] " -n 1 answer
    echo

    if [[ $answer =~ (yes|y|Y) ]];then
        if ! sudo grep -q "@includedir /etc/sudoers.d" /etc/sudoers; then
          echo '@includedir /etc/sudoers.d' | sudo tee -a /etc/sudoers > /dev/null
        fi
        echo -e "Defaults:$LOGNAME    !requiretty\n$LOGNAME ALL=(ALL) NOPASSWD:     ALL" | sudo tee /etc/sudoers.d/$LOGNAME
        echo "You can now run sudo commands without password!"
    fi
  fi
}
