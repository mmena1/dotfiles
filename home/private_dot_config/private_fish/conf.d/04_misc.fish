
set -gx DOTFILES "$HOME/.local/share/chezmoi"
set -gx PATH "$HOME/.local/bin:$PATH"

# Quick jump to dotfiles
abbr dotfiles "code $DOTFILES"
