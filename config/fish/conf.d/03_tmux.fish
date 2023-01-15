if status is-interactive
    if [ -z "$TMUX" ]
        # Look for the main session:
        # if attached, create a new one
        # if not, create the main session or attach it if exists but is detached
        if tmux lsc -t main 2>&1 | grep -q attached
            exec tmux
        else
            exec tmux new-session -A -s main
        end
    end
end
