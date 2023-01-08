# Reference:
# https://github.com/gazorby/fish-exa/blob/master/functions/exa_git.fish

function __exa.git -d "Use exa and its git options if in a git repo"
    if git rev-parse --is-inside-work-tree &>/dev/null
        exa $EXA_STANDARD_OPTIONS --git $argv
    else
        exa $EXA_STANDARD_OPTIONS $argv
    end
end