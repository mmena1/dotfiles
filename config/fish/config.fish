if status is-interactive
    # Set python debugger to ipdb - on fish it must be set with `sset_trace`
    set -x PYTHONBREAKPOINT ipdb.sset_trace
end

# Haskell setup
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /home/mmena/.ghcup/bin $PATH # ghcup-env