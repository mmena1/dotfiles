set -Ux EXA_STANDARD_OPTIONS "--group" "--header" "--group-directories-first" "--icons" "--time-style=long-iso" "--color=auto" "--classify"

# function ll -w=ls -w=__exa.git
#     __exa.git --long $EXA_STANDARD_OPTIONS $argv
# end

# Temporal fix since exa --git was disabled in current version
function ll -w=ls -w=exa
    exa --long $EXA_STANDARD_OPTIONS $argv
end

function ls -w=ls -w=exa
    exa $EXA_STANDARD_OPTIONS $argv
end

abbr llt ll --tree
abbr llti ll --tree --git-ignore
abbr lla ll -a
abbr la ls -a