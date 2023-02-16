
set -gx DOTFILES "$HOME/.dotfiles"
# Run scripts
abbr update "source $DOTFILES/scripts/update"
abbr bootstap "source $DOTFILES/scripts/bootstrap"

# Quick jump to dotfiles
abbr dotfiles "code $DOTFILES"

# Show $PATH as a list
alias path "echo $PATH | string replace -ra ':' '\n'"