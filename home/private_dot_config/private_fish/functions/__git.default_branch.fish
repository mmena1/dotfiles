function __git.default_branch
    # Attempt to get the global default branch name from Git configuration
    set -l git_default_branch (git config --get init.defaultBranch)
    if test -z "$git_default_branch"
        # If not configured, default to 'main'
        set git_default_branch "main"
    end

    # Get the remote name, defaulting to 'origin'
    set -l remote (git remote show | head -n 1)
    if test -z "$remote"
        # If no remote is found, use the configured default branch or 'main'
        echo "No remote found, defaulting to '$git_default_branch'"
        echo $git_default_branch
        return
    end

    # Fetch remote information to ensure we have the latest default branch info, 
    # cleaning up any references that doesn't exist anymore, while suppressing direct output
    git remote update $remote --prune > /dev/null 2>&1

    # Extract the default branch name from the 'HEAD branch' line of the 'git remote show' output
    set -l default_branch (git remote show $remote | grep 'HEAD branch' | sed 's/.*: //')
    if test -z "$default_branch"
        echo "Could not determine the default branch from remote, defaulting to '$git_default_branch'"
        echo $git_default_branch
        return
    end

    echo $default_branch
end
