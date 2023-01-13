if status is-interactive
    # Set python debugger to ipdb - on fish it must be set with `sset_trace`
    set -x PYTHONBREAKPOINT ipdb.sset_trace
end
