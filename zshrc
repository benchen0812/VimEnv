
export ZSH="/Users/yenjung/.oh-my-zsh" # Set name of the theme to load --- if set to "random", it will

function virtualenv_info {
  [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`')'
}

# ZSH_THEME="agnoster"
ZSH_THEME="avit"
# ZSH_THEME="typewritten/typewritten"
# export TYPEWRITTEN_CURSOR="block"
# cursor_style_full_block=16

bindkey '^ ' autosuggest-accept

DISABLE_LS_COLORS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(git)
# plugins=(fzf)
plugins=(zsh-autosuggestions)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=245'

# export FZF_BASE="$HOME/.fzf"
source $ZSH/oh-my-zsh.sh


# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi


#
# Example aliases
alias zshconfig="vim ~/.zshrc"
alias vimrcconfig="vim ~/.vimrc"
#
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

# asdf
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# for error
export LC_ALL=en_US.UTF-8


# shell integretion
# source ~/.iterm2_shell_integration.zsh
source ~/.zsh-interactive-cd.plugin.zsh


# FZF

# fgst - pick files from `git status -s`
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

alias glNoGraph='git log --color=always --date=short --format="%ad | %C(auto)%h%d %s %C(auto)%C(bold)%cr% C(auto)[%an]" "$@"'
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"

gcob() {
    local branches branch
    branches=$(git --no-pager branch -vv --color=always ) &&
    branch=$(echo "$branches" | fzf --height 40% --ansi --multi --tac --reverse +m) &&
    git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}


gb() {
  is_in_git_repo &&
    git branch -vv --color=always | grep -v '/HEAD\s' |
    fzf --height 40% --ansi --multi --tac --reverse | sed 's/^..//' | awk '{print $1}' |
    sed 's#^remotes/[^/]*/##'
}

# fshow_preview - git commit browser with previews
glp() {
    glNoGraph |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
                --header "enter to view, alt-y to copy hash" \
                --bind "enter:execute:$_viewGitLogLine   | less -R" \
                --bind "ctrl-y:execute:$_gitLogLineToHash | xclip"
}
gl() {
    glNoGraph |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi  \
                --header "enter to view, alt-y to copy hash" \
                --bind "enter:execute:$_viewGitLogLine   | less -R" \
                --bind "ctrl-y:execute:$_gitLogLineToHash | xclip"
}

glg ()
{
  git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"  | \
   fzf --ansi --no-sort --reverse --tiebreak=index --preview \
   'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' \
   --bind "j:down,k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort,ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF" --preview-window=right:40%
}

 # git commit sha
gh() {
  is_in_git_repo &&
    git log --date=short --color=always --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph |
    fzf --height 40% --ansi --no-sort --reverse --multi | grep -o '[a-f0-9]\{7,\}'
}


grbi() {
  local commit=$(gh)
  [[ -n "$commit" ]] && git rebase -i "$commit"
}

grs() {
  local commit=$(gh)
  [[ -n "$commit" ]] && git reset "$commit"
}

gco() {
  local commit=$(gh)
  [[ -n "$commit" ]] && git checkout "$commit"
}

 # git list stash
gsl() {
  is_in_git_repo &&
    git stash list |
    fzf --height 40% --ansi --no-sort --reverse --multi | grep -o 'stash@{.}'
}

gsa() {
  local stash=$(gsl)
  [[ -n "$stash" ]] && git stash apply "$stash"

}

# gss() {
  # is_in_git_repo &&
    # git status -s |
    # fzf --height 40% --ansi --no-sort --reverse --preview 'git diff --color=always {+2} | diff-so-fancy' | grep -o '{7,\}'
# }

fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
}

alias gcpb="git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' | pbcopy"
alias gcm="git commit"
alias gss="git status"
alias gsc="git stash clear"
alias gpl="git pull origin"
alias grb="git rebase"
alias grbc="git rebase --continue"
alias grbs="git rebase --skip"

alias tn="tmux new -s"
alias tl="tmux ls"
alias ta="tmux attach-session -t"
alias tka="tmux kill-server"
alias tks="tmux kill-session -t"
alias gfo="git fetch origin"
alias grsh="git reset --hard"
alias hco="hub pr checkout"

alias tx="tmuxinator"

grsho() {
  local b="$(git_current_branch)"
  git fetch origin ${b}
  echo "current branch: ${b}"
  git reset --hard origin/${b}
  echo "reset to origin/${b}"
  git log --pretty=format:'%C(yellow)%h %C(bold blue) %ad | %C(reset) %s %C(bold blue) %d %C(yellow)[%an] (%cr)' --graph --date=short -1
}
