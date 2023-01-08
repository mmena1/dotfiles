# Reference:
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
# https://github.com/jhillyerd/plugin-git/blob/master/functions/__git.init.fish

abbr g          git
abbr gaa        git add --all
abbr gc         git commit -v
abbr gca!       git commit -v --amend
abbr gcan!      git commit -v --no-edit --amend
abbr gco        git checkout
abbr gd         git diff
abbr gcm        git commit -m
abbr gst        git status
abbr gcp        git cherry-pick
abbr gcpa       git cherry-pick --abort
abbr gcpc       git cherry-pick --continue
abbr gf         git fetch
abbr glog       git log --oneline --decorate --color --graph
abbr gloga      git log --oneline --decorate --color --graph --all
abbr glods      "git log --graph --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short"
abbr grb        git rebase
abbr grba       git rebase --abort
abbr grbc       git rebase --continue
abbr grbi       git rebase --interactive
abbr grbm       git rebase \(__git.default_branch\)
abbr grhh       git reset --hard
abbr gco        git checkout
abbr gcb        git checkout -b
abbr gcom       git checkout \(__git.default_branch\)
abbr ggpush     git push origin (__git.current_branch)
abbr ggpull     git pull origin (__git.current_branch)
abbr ggsup      git branch --set-upstream-to=origin/(__git.current_branch)
abbr grset      git remote set-url
abbr grv        git remote -v
abbr gsta       git stash
abbr gstd       git stash drop
abbr gstl       git stash list
abbr gstp       git stash pop
abbr gsts       git stash show --text
abbr gsu        git submodule update
abbr gsur       git submodule update --recursive
abbr gsuri      git submodule update --recursive --init