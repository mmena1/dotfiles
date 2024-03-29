# Reference:
# https://github.com/gazorby/fish-exa/blob/master/functions/exa_git.fish

function __eza.git -d "Use eza and its git options if in a git repo"
    if git rev-parse --is-inside-work-tree &>/dev/null
        eza $EZA_STANDARD_OPTIONS --git $argv
    else
        eza $EZA_STANDARD_OPTIONS $argv
    end
end
