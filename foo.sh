#!/usr/bin/env bash

_exists() {
  command -v "$1" > /dev/null 2>&1
}

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

function ok() {
  local message=${1:-" "}
  echo -e "$COL_GREEN[ok]$COL_RESET "$message
}

function bot() {
  echo -e "\n$COL_GREEN\[._.]/$COL_RESET - "$1
}

function running() {
  echo -en "$COL_YELLOW ⇒ $COL_RESET"$1": "
}

function action() {
  echo -e "\n$COL_YELLOW[action]:$COL_RESET\n ⇒ $1..."
}

function warn() {
  echo -e "$COL_YELLOW[warning]$COL_RESET "$1
}

function error() {
  echo -e "$COL_RED[error]$COL_RESET "$1
}

function prompt {
  local prompt_message=${1:-"Default prompt message"}
  read -p "$prompt_message [y/N]" -n 1 -r -s answer
  echo  # Ensure newline after input
  if [[ $answer =~ ^[Yy]$ ]]; then
    return 0  # Indicative of 'yes'
  else
    return 1  # Indicative of 'no' or any input other than 'y'
  fi
  
}
# Task Manager for Chezmoi Scripts
# This template provides functions for task management and dependency resolution

# Initialize task tracking
declare -A TASK_STATUS  # Status of tasks (pending, running, completed, skipped, failed)
declare -A TASK_DEPS    # Dependencies for each task
declare -A TASK_FUNCS   # Function to execute for each task
declare -A TASK_DESCS   # Description of each task
declare -a TASK_ORDER   # Order of task execution

# Register a task with dependencies
# Usage: register_task "task_name" "description" "dependency1,dependency2" task_function
register_task() {
  local task_name="$1"
  local task_desc="$2"
  local task_deps="$3"
  local task_func="$4"
  
  TASK_STATUS[$task_name]="pending"
  TASK_DESCS[$task_name]="$task_desc"
  TASK_DEPS[$task_name]="$task_deps"
  TASK_FUNCS[$task_name]="$task_func"
  TASK_ORDER+=("$task_name")
}

# Check if all dependencies for a task are met
check_dependencies() {
  local task_name="$1"
  local deps="${TASK_DEPS[$task_name]}"
  
  if [[ -z "$deps" || "$deps" == "none" ]]; then
    return 0  # No dependencies
  fi
  
  IFS=',' read -ra dep_array <<< "$deps"
  for dep in "${dep_array[@]}"; do
    if [[ "${TASK_STATUS[$dep]}" != "completed" ]]; then
      return 1  # Dependency not met
    fi
  done
  
  return 0  # All dependencies met
}

# Run a specific task
run_task() {
  local task_name="$1"
  
  # Skip if already completed or failed
  if [[ "${TASK_STATUS[$task_name]}" == "completed" || "${TASK_STATUS[$task_name]}" == "failed" || "${TASK_STATUS[$task_name]}" == "skipped" ]]; then
    return
  fi
  
  # Check dependencies
  if ! check_dependencies "$task_name"; then
    TASK_STATUS[$task_name]="pending"  # Keep as pending
    return
  fi
  
  # Run the task
  bot "Running task: ${TASK_DESCS[$task_name]}"
  TASK_STATUS[$task_name]="running"
  
  if prompt "Would you like to run this task?"; then
    # Execute the task function
    if eval "${TASK_FUNCS[$task_name]}"; then
      TASK_STATUS[$task_name]="completed"
      ok "Task completed: $task_name"
    else
      TASK_STATUS[$task_name]="failed"
      error "Task failed: $task_name"
      if ! prompt "Continue despite failure?"; then
        exit 1
      fi
    fi
  else
    TASK_STATUS[$task_name]="skipped"
    warn "Task skipped: $task_name"
  fi
}

# Execute all tasks in order, respecting dependencies
execute_tasks() {
  local max_iterations=100  # Avoid infinite loop
  local iterations=0
  local completed_count=0
  local total_tasks=${#TASK_ORDER[@]}
  
  while (( completed_count < total_tasks && iterations < max_iterations )); do
    iterations=$((iterations + 1))
    
    # Count completed tasks
    completed_count=0
    for task in "${TASK_ORDER[@]}"; do
      if [[ "${TASK_STATUS[$task]}" == "completed" || "${TASK_STATUS[$task]}" == "skipped" || "${TASK_STATUS[$task]}" == "failed" ]]; then
        completed_count=$((completed_count + 1))
      fi
    done
    
    # Try to run pending tasks
    for task in "${TASK_ORDER[@]}"; do
      if [[ "${TASK_STATUS[$task]}" == "pending" ]]; then
        run_task "$task"
      fi
    done
    
    # Break if no progress is being made
    local new_completed_count=0
    for task in "${TASK_ORDER[@]}"; do
      if [[ "${TASK_STATUS[$task]}" == "completed" || "${TASK_STATUS[$task]}" == "skipped" || "${TASK_STATUS[$task]}" == "failed" ]]; then
        new_completed_count=$((new_completed_count + 1))
      fi
    done
    
    if (( new_completed_count == completed_count && completed_count < total_tasks )); then
      error "Dependency deadlock detected. Some tasks cannot be completed."
      exit 1
    fi
  done
  
  if (( iterations >= max_iterations )); then
    error "Maximum iterations reached. Some tasks may not have completed."
    exit 1
  fi
  
  # Final report
  echo
  bot "Task execution summary:"
  for task in "${TASK_ORDER[@]}"; do
    case "${TASK_STATUS[$task]}" in
      "completed") echo -e "$COL_GREEN[✓]$COL_RESET ${TASK_DESCS[$task]}" ;;
      "skipped")   echo -e "$COL_YELLOW[⟳]$COL_RESET ${TASK_DESCS[$task]}" ;;
      "failed")    echo -e "$COL_RED[✗]$COL_RESET ${TASK_DESCS[$task]}" ;;
      *)           echo -e "$COL_RED[?]$COL_RESET ${TASK_DESCS[$task]}" ;;
    esac
  done
}
# Task modules for common installation functions
# This template provides modular installation functions

# System package installation module
package_module() {
  # Check for install candidate using apt-cache policy
  aptCacheExists() {
    apt-cache policy "$1" | grep -q 'Candidate:'
  }
  # Install packages based on OS
  install_packages() {
    install_macos_packages
    return 0
  }
  
  # Install macOS packages with Homebrew
  install_macos_packages() {
    action "Installing macOS packages with Homebrew"
    if ! _exists brew; then
      error "Homebrew not installed"
      return 1
    fi

    # Generate Brewfile
    cat > Brewfile <<EOF
# Generated by Chezmoi - DO NOT EDIT DIRECTLY

# Taps
tap homebrew/cask-fonts

# Formulae
brew "git"
brew "fish"
brew "tmux"
brew "curl"
brew "ripgrep"
brew "starship"
brew "eza"
brew "gh"
brew "bat"
# Casks
cask "visual-studio-code"
cask "font-fira-code"
cask "font-fira-code-nerd-font"

EOF

    # Install using Brewfile
    running "Installing via Brewfile"
    brew bundle install --no-lock || warn "Brewfile installation failed"
    
    return 0
  }
  
  # Install Debian packages with apt
  install_debian_packages() {
    action "Installing Debian packages with apt"
    
    # Convert package string to array
    local all_pkgs=( git fish tmux curl ripgrep build-essential bat cmake htop fonts-noto-color-emoji powerline fonts-powerline tree fonts-firacode vim xclip )
    local valid_pkgs=()
    local invalid_pkgs=()

    # Validate packages
    for pkg in "${all_pkgs[@]}"; do
      if aptCacheExists "$pkg"; then
        valid_pkgs+=("$pkg")
      else
        invalid_pkgs+=("$pkg")
      fi
    done

    # Handle invalid packages
    if [ ${#invalid_pkgs[@]} -gt 0 ]; then
      warn "Skipping invalid/unavailable packages:"
      printf "  - %s\n" "${invalid_pkgs[@]}"
    fi

    # Exit early if no valid packages
    if [ ${#valid_pkgs[@]} -eq 0 ]; then
      warn "No valid packages to install"
      return 0
    fi

    # Proceed with installation
    running "Updating package lists"
    sudo apt-get update -qy || { error "Failed to update packages"; return 1; }

    running "Installing packages (${#valid_pkgs[@]} total)"
    sudo apt-get install -qy --no-install-recommends "${valid_pkgs[@]}" || {
      warn "Bulk install failed - retrying individually"
      
      # Individual installation fallback
      for pkg in "${valid_pkgs[@]}"; do
        running "Installing $pkg"
        sudo apt-get install -qy --no-install-recommends "$pkg" || \
          error "Critical failure: $pkg"
      done
    }

    return 0
  }
}

# ASDF module
asdf_module() {
  # Install ASDF version manager
  install_asdf() {
    if ! _exists asdf; then
      action "Installing ASDF version manager"
      if [[ ! -d ~/.asdf ]]; then
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf || return 1
        source ~/.asdf/asdf.sh
      else
        ok "ASDF directory already exists"
        source ~/.asdf/asdf.sh
      fi
    else
      ok "ASDF already installed"
    fi
    return 0
  }
  
  # Install tools defined in .tool-versions
  install_asdf_tools() {
    if ! _exists asdf; then
      error "ASDF not installed"
      return 1
    fi
    
    if [[ ! -f ~/.tool-versions ]]; then
      error "~/.tool-versions not found"
      return 1
    fi
    
    while read -r line; do
      # get the first word of the line
      tool_name="${line%% *}"
      running "$tool_name"
      
      # is language already installed?
      if ! asdf where $tool_name > /dev/null 2>&1; then
        # does the plugin exist in the remote repos?
        if asdf plugin list all | grep -E "^$tool_name\s" > /dev/null 2>&1; then
          # is the plugin not installed already?
          if ! asdf plugin list | grep "$tool_name" > /dev/null 2>&1; then
            action "asdf plugin-add $tool_name"
            asdf plugin-add $tool_name
          fi
          action "Installing $tool_name"
          asdf install $tool_name || error "Couldn't install $tool_name"
        else
          error "Plugin $tool_name does not exist"
        fi
      else
        ok "$tool_name already installed"
      fi
    done < ~/.tool-versions
    
    return 0
  }
}

# Shell setup module
shell_module() {
  # Configure Fish shell
  setup_fish() {
    if ! _exists fish; then
      error "Fish shell not installed"
      return 1
    fi
    
    # Add fish to /etc/shells if not already there
    local fish_path=$(which fish)
    if ! grep -q "$fish_path" /etc/shells; then
      action "Adding Fish to /etc/shells"
      echo "$fish_path" | sudo tee -a /etc/shells
    fi
    return 0
  }
  
  # Setup Starship prompt
  setup_starship() {
    if ! _exists starship ; then
      action "curl -sS https://starship.rs/install.sh | sh -s -- -y"
      curl -sS https://starship.rs/install.sh | sh -s -- -y > /dev/null
      ok "Starship configured"
    else
      ok "Starship already installed!"
    fi
    
    return 0
  }
}

# Dev tools module
devtools_module() {
  # Setup VSCode
  setup_vscode() {
    bot "Checking VSCode..."
    echo
    warn "VSCode setup not supported on macOS."
    return 0
    if ! _exists code ; then
      if prompt "Would you like to install vscode?" ;then
        action "checking if snapd is enabled"
        if systemctl is-active --quiet snapd ;then
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
  
  # Setup Fonts
  setup_fonts() {
    action "Setting up fonts"
    
    # Font installation for macOS handled via Homebrew casks
    ok "Fonts installed via Homebrew"
    return 0
  }
}

# Docker module
docker_module() {
  setup_docker() {
    return 0
  }
  
  install_docker() {
    bot "Checking Docker"
    echo
    if ! _exists docker ; then
      if prompt "Would you like to install Docker?"; then
        action "Adding Docker official GPG key"
        sudo apt-get -qq install -y ca-certificates curl > /dev/null
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        action "Adding Docker repository to apt sources"
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$(. /etc/os-release && echo "$ID") \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        action "Updating apt packages with the new Docker repository"
        sudo apt-get -qq update > /dev/null
        action "Installing Docker"
        sudo apt-get -qq install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null
      else
        ok "Skipping"
      fi
    else
      ok "Docker already installed"
    fi
  }
  # Setup Docker
  configure_docker() {
    if ! _exists docker; then
      error "Docker not installed"
      return 1
    fi

    action "Ensuring Docker is running"
    # Check which service manager is available
    if command -v systemctl &>/dev/null; then
      sudo systemctl enable --now docker
    elif command -v service &>/dev/null; then
      sudo service docker start
    else
      warn "Could not determine how to start Docker service"
    fi

    # Add user to docker group
    if ! groups | grep -q docker; then
      action "Adding user to docker group"
      sudo usermod -aG docker "$USER"
      warn "You may need to log out and back in for this to take effect"
    fi

    ok "Docker configured"
    return 0
  }
}

# Local setup module
local_module() {
  local_setup() {
    # Run local setup tasks
    setup_ssh_keys
    setup_passwordless_sudo
    set_fish_as_default_shell
    return 0
  }
  # Setup SSH keys
  setup_ssh_keys() {
    if [[ ! -f ~/.ssh/id_ed25519 ]]; then
      if prompt "Generate new SSH key?"; then
        action "Generating SSH key"
        # Prompt for passphrase instead of using empty one
        ssh-keygen -t ed25519 -C "example@email.com" -f ~/.ssh/id_ed25519
        # Start ssh-agent
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_ed25519
        ok "SSH key generated"
      fi
    else
      ok "SSH key already exists"
    fi
    return 0
  }

  setup_passwordless_sudo() {
    if [[ ! "$LOGNAME" =~ ^[a-zA-Z0-9][a-zA-Z0-9_-]*$ ]]; then
      echo "Error: LOGNAME contains invalid characters."
      return 1
    fi
    bot "Verifying passwordless sudo config"
    # Determine sudoers.d directory based on OS
    local sudoers_d_dir="/etc/sudoers.d"
    local includedir_line="@includedir /etc/sudoers.d"
    sudoers_d_dir="/private/etc/sudoers.d"
    includedir_line="#includedir /private/etc/sudoers.d"
    # Check if NOPASSWD entry already exists for the user
    if ! sudo grep -q "NOPASSWD:     ALL" "$sudoers_d_dir/$LOGNAME" > /dev/null 2>&1; then
      echo "No sudoer file found for passwordless operation."
      bot "Enabling passwordless sudo can reduce security. Are you sure you want to proceed?"

      if prompt "Make sudo passwordless?"; then
        # Ensure sudoers.d is included and directory exists
        if ! sudo grep -q "$includedir_line" /etc/sudoers; then
          echo "$includedir_line" | sudo tee -a /etc/sudoers > /dev/null
        fi
        [[ ! -d "$sudoers_d_dir" ]] && sudo mkdir -p "$sudoers_d_dir"

        # Create a temporary file with secure permissions
        local tmpfile=$(sudo mktemp)
        echo -e "Defaults:$LOGNAME !requiretty\n$LOGNAME ALL=(ALL) NOPASSWD: ALL" | sudo tee "$tmpfile" > /dev/null
        # Validate and move if valid
        if sudo visudo -cf "$tmpfile"; then
          sudo install -m 0440 "$tmpfile" "$sudoers_d_dir/$LOGNAME"
          sudo rm -f "$tmpfile"
          echo "You can now run sudo commands without a password!"
        else
          echo "Error in sudoers file"
          sudo rm -f "$tmpfile"
          return 1
        fi
      fi
    else
      echo "Passwordless sudo already configured for $LOGNAME."
    fi
  }

  set_fish_as_default_shell() {
    if prompt "Set Fish as default shell?"; then
      chsh -s "$(which fish)" || error "Failed to set Fish as default shell"
    fi
  }
}
# Initialize modules
package_module
asdf_module
shell_module
devtools_module
docker_module
local_module

# Setup intro
setup_intro() {
  bot "Welcome to the dotfiles setup script"
  echo "This script will set up your development environment"
  echo "It will not install anything without your direct agreement"
  return 0
}

# Homebrew installation
setup_homebrew() {
  if ! _exists brew; then
    action "Installing Homebrew"
    # Download script first
    local brew_install_script=$(mktemp)
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$brew_install_script"
    
    # Verify script exists and has content
    if [[ ! -s "$brew_install_script" ]]; then
      error "Failed to download Homebrew installation script"
      rm -f "$brew_install_script"
      return 1
    fi
    
    # Execute the script
    /bin/bash "$brew_install_script" || { 
      error "Homebrew installation failed"
      rm -f "$brew_install_script"
      return 1
    }
    
    # Clean up
    rm -f "$brew_install_script"
  else
    ok "Homebrew already installed"
  fi
  return 0
}

# Tmux configuration
setup_tmux() {
  if ! _exists tmux; then
    error "Tmux not installed"
    return 1
  fi
  
  local tmux_conf_repo="https://github.com/gpakosz/.tmux.git"
  local tmux_conf_dir="$HOME/.tmux"
  
  if [[ ! -d "$tmux_conf_dir" ]]; then
    action "Cloning tmux configuration"
    git clone "$tmux_conf_repo" "$tmux_conf_dir" || return 1
    ln -sf "$tmux_conf_dir/.tmux.conf" "$HOME/.tmux.conf"
  else
    action "Updating tmux configuration"
    git -C "$tmux_conf_dir" pull || return 1
  fi
  
  ok "Tmux configured"
  return 0
}

# Finish setup
finish_setup() {
  bot "Setup completed!"
  echo "Your development environment is now ready"
  
  return 0
}

# Register all tasks with their dependencies
# Format: register_task "task_id" "description" "dependency1,dependency2" function_name
register_task "intro" "Introduction" "none" setup_intro
register_task "homebrew" "Install Homebrew (macOS)" "intro" setup_homebrew
register_task "packages" "Install system packages" "homebrew" install_packages
register_task "fish" "Configure Fish shell" "packages" setup_fish
register_task "tmux" "Setup Tmux configuration" "packages" setup_tmux
register_task "asdf" "Install ASDF version manager" "packages" install_asdf
register_task "tools" "Install tools from .tool-versions" "asdf" install_asdf_tools
register_task "docker" "Configure Docker" "packages" setup_docker
register_task "vscode" "Setup VSCode and extensions" "packages" setup_vscode
register_task "starship" "Configure Starship prompt" "packages" setup_starship
register_task "fonts" "Setup fonts" "packages" setup_fonts
register_task "local" "Local setup" "packages,fish,tmux,tools,docker,vscode,starship,fonts" local_setup
register_task "finish" "Finish setup" "fish,tmux,tools,docker,vscode,starship,fonts" finish_setup

# Execute all tasks
if ! execute_tasks; then
  error "Setup failed. Please check the logs for errors."
  exit 1
else
  ok "All tasks completed successfully."
fi
