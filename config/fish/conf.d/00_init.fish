if [ (uname) = "Darwin" ]
  eval (/opt/homebrew/bin/brew shellenv)
end
set fish_greeting                # Remove welcome message
starship init fish | source      # Initilizes Starship
