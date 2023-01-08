# Enable aliases to be sudo’ed
#   http://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

# Disabling conflicting oh-my-zsh aliases
unalias ls 2>/dev/null
unalias la 2>/dev/null
unalias ll 2>/dev/null

# ls and ll are aliased to use exa by the ls plugin
alias llt='ll --tree'
alias llti='ll --tree --git-ignore'
alias lla='ll -a'

# Run scripts
alias update="source $DOTFILES/scripts/update"
alias bootstap="source $DOTFILES/scripts/bootstrap"

# Quick jump to dotfiles
alias dotfiles="code $DOTFILES"

# Quick reload of zsh environment
alias reload="source $HOME/.zshrc"

# Show $PATH in readable view
alias path='echo -e ${PATH//:/\\n}'
