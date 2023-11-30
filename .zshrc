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

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

alias vim="nvim"

# aws cli
export PATH="$HOME/aws-cli:$PATH"

# clojure awesomeness
export PATH="$HOME/clojure-lsp:$PATH"

# elixir non-awesomeness
# https://github.com/asdf-vm/asdf-erlang/issues/207#issuecomment-883216342
export KERL_CONFIGURE_OPTIONS="--with-ssl=`brew --prefix openssl` \
                               --with-wx-config=`brew --prefix wxwidgets`/bin/wx-config \
                               --without-javac"

# asdf
. "$HOME/.asdf/asdf.sh"
#. "$HOME/.asdf/completions/asdf.bash"
#
# set java home based on asdf
. ~/.asdf/plugins/java/set-java-home.zsh


# source extra zsh completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source "$ZSH/oh-my-zsh.sh"
