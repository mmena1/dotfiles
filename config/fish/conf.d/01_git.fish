# Reference:
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
# https://github.com/jhillyerd/plugin-git/blob/master/functions/__git.init.fish

alias g          'git'
alias gaa        'git add --all'
alias gc         'git commit -v'
alias gca!       'git commit -v --amend'
alias gcan!      'git commit -v --no-edit --amend'
alias gco        'git checkout'
alias gd         'git diff'
alias gcm        'git commit -m'
alias gst        'git status'
alias gcp        'git cherry-pick'
alias gcpa       'git cherry-pick --abort'
alias gcpc       'git cherry-pick --continue'
alias gf         'git fetch'
alias glog       'git log --oneline --decorate --color --graph'
alias gloga      'git log --oneline --decorate --color --graph --all'
alias glods      "git log --graph --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short"
alias grb        'git rebase'
alias grba       'git rebase --abort'
alias grbc       'git rebase --continue'
alias grbi       'git rebase --interactive'
alias grbm       "git rebase (__git.default_branch)"
alias grhh       'git reset --hard'
alias gcb        'git checkout -b'
alias gcom       "git checkout (__git.default_branch)"
alias ggpush     "git push origin (__git.current_branch)"
alias ggpull     "git pull origin (__git.current_branch)"
alias ggsup      "git branch --set-upstream-to=origin/(__git.current_branch)"
alias grset      'git remote set-url'
alias grv        'git remote -v'
alias gsta       'git stash'
alias gstd       'git stash drop'
alias gstl       'git stash list'
alias gstp       'git stash pop'
alias gsts       'git stash show --text'
alias gsu        'git submodule update'
alias gsur       'git submodule update --recursive'
alias gsuri      'git submodule update --recursive --init'
