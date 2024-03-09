# Initialize Homebrew for macOS systems
if [ (uname) = "Darwin" ]
  eval (/opt/homebrew/bin/brew shellenv)
end
# Remove welcome message
set fish_greeting
# Initialize Starship for an enhanced shell prompt
starship init fish | source
