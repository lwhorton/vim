export ZSH="$HOME/.oh-my-zsh"

# zsh plugs
plugins=(
  git
  dotenv
  zsh-dircolors-solarized
)

# set zsh profile
#ZSH_THEME="agnoster"

# customize prompt beyond zsh profile's default
PROMPT="%n %D:%* %~ > "

# load ssh agent
sshinit() {
    eval "$(ssh-agent -s)"
    if [ -z "$1" ]
    then
        ssh-add ~/.ssh/lwhorton-github-2023
    else
        ssh-add ~/.ssh/"$1"
    fi
}
sshinit

# better ls
alias ls='ls -GFh'
alias ll='ls -l'

# save comand history for all sessions (ctrl-r search)
export PROMPT_COMMAND='history -a'

# shortcut docker
alias dc="docker-compose"

# java env manager
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# open chrome insecurely
alias insecure-chrome='open -a Google\ Chrome --args --disable-web-security'

alias vim="nvim"

# autocompletions for brew
if [ -n "$(which brew)" ] && [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

# autocompletions for git
source ~/git-completion.bash

# aws cli
export PATH="$HOME/aws-cli:$PATH"

# clojure awesomeness
export PATH="$HOME/clojure-lsp:$PATH"

. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash

source $ZSH/oh-my-zsh.sh
