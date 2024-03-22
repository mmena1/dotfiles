function __git.default_branch
    # Get the remote name, defaulting to 'origin'
    set -l remote (git remote show | head -n 1)
    if test -z "$remote"
        echo "No remote found"
        return 1
    end

    # Fetch remote information to ensure we have the latest default branch info
    git remote update $remote --prune

    # Get the default branch from the remote
    set -l default_branch (git remote show $remote | grep 'HEAD branch' | sed 's/.*: //')
    if test -z "$default_branch"
        echo "Could not determine the default branch"
        return 1
    end

    echo $default_branch
end
