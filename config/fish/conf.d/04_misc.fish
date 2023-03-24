
set -gx DOTFILES "$HOME/.dotfiles"
set -gx PATH "$HOME/.local/bin:$PATH"

# Run scripts
abbr update "source $DOTFILES/scripts/update"
abbr bootstap "source $DOTFILES/scripts/bootstrap"

# Quick jump to dotfiles
abbr dotfiles "code $DOTFILES"
