set -Ux EZA_STANDARD_OPTIONS "--group" "--header" "--group-directories-first" "--icons" "--time-style=long-iso" "--color=auto" "--classify"

function ll -w=ls -w=__eza.git
    __eza.git --long $EZA_STANDARD_OPTIONS $argv
end

function ls -w=ls -w=eza
    eza $EZA_STANDARD_OPTIONS $argv
end

abbr llt ll --tree
abbr llti ll --tree --git-ignore
abbr lla ll -a
abbr la ls -a
