#!/usr/bin/env bash

if ! command -v "docker" > /dev/null 2>&1 ; then
  sudo apt-get -qq install -y ca-certificates curl > /dev/null
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$(. /etc/os-release && echo "$ID") \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get -qq update > /dev/null
  sudo apt-get -qq install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null
  # Check which service manager is available
  if command -v systemctl &>/dev/null; then
    sudo systemctl enable --now docker
  elif command -v service &>/dev/null; then
    sudo service docker start
  else
    echo "Could not determine how to start Docker service"
  fi
  # Add user to docker group
  if ! groups | grep -q docker; then
    sudo usermod -aG docker "$USER"
    echo "You may need to log out and back in for this to take effect"
  fi
  echo "Docker installed successfully"
else
  echo "Docker already installed"
fi
