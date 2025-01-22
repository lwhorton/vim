# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="zhann"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# this must happen before plugin installation
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh
LESS=FRSX

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# init homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# init direnv
eval "$(direnv hook zsh)"

# init fzf
. <(fzf --zsh)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/luke/dev/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/luke/dev/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/luke/dev/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/luke/dev/google-cloud-sdk/completion.zsh.inc'; fi

## generic aliases
alias vim="nvim"
alias dc="docker compose"
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# git aliases
git_prune_merged() {
  # $1 = days old, defaulting to 30
  local DAYS_OLD=30
  local DRY_RUN=true
  for arg in "$@"; do
    case $arg in 
      --days-old=*)
        DAYS_OLD="${arg#*=}"
        shift
        ;;
      --delete)
        DRY_RUN=false
        shift
        ;;
      *)
        echo "Unknown argument: $arg"
        return 1
        ;;
    esac
  done

  git checkout -q main || { echo "main branch doesnt exist?" ; exit 1; }

  # macos
  local cutoff=$(date -v-"$DAYS_OLD"d +%s)
  local merged_branches=$(git branch --merged main | sed 's/^..//')
  local branches_to_delete=()
  git for-each-ref refs/heads/ "--format=%(refname:short) %(committerdate:unix)" | while read branch last_commit; do
    # skip these branches
    if [ "$branch" = "main" ]; then
      continue
    fi

    echo "Considering $branch ..."

    if [ "$last_commit" -lt "$cutoff" ]; then
      if echo "$merged_branches" | grep -q "^$branch$"; then
        branches_to_delete+=("$branch")
      fi
    fi
  done

  if [ "$DRY_RUN" = true ]; then
    echo "Dry run: The following branches would be deleted:"
    echo "${branches_to_delete[@]}"
  else
    echo "Deleting the following branches:"
    echo "${branches_to_delete[@]}"
    git branch -D "${branches_to_delete[@]}"
  fi
}
alias git-prune-merged='git_prune_merged'

## work aliases
# simbe
alias sbbe="cd ~/dev/work/simbe_cloud"
alias sbfe="cd ~/dev/work/simbe_web_clients"
alias sbdo="cd ~/dev/work/simbe_cloud_docker"
alias sbpx-older="~/dev/work/cloud-sql-proxy --port 5432 simbe-cloud:us-central1:simbe simbe-cloud:us-central1:heartbeats simbe-cloud:us-central1:simbe-etl simbe-cloud:us-central1:simbe-heartbeats"
alias sbpx-old="~/dev/work/cloud-sql-proxy --port 5434 simbe-cloud:us-central1:simbe-etl simbe-cloud:us-central1:simbe-heartbeats"

# ssh proxies, in this order: alloy, our 3 redis hosts (gcp, captures, telemetry)
alias sbpx="ssh -i ~/.ssh/luke-horton-simberobotics-1 \
  -N -L localhost:5432:10.38.50.28:5432 \
  -L localhost:6379:10.38.49.28:6379 \
  -L localhost:6380:10.38.49.4:6379 \
  -L localhost:6381:10.38.49.12:6379 \
  luke.horton@35.188.191.82 
  "


# summarize parent directories if necessary
abbreviate_path() {
    # Get the current directory path
    local path="${PWD/#$HOME/~}"
    local -a path_parts
    path_parts=("${(@s:/:)path}")
    local abbr_path=""
    local len=${#path_parts}

    # Loop through each part of the path except the last one
    for (( i=1; i<$len; i++ )); do
        local part="${path_parts[i]}"
        # Abbreviate to the first characters, or keep the whole if shorter
        local abbr="${part[1,2]}"
        abbr_path+="${abbr}/"
    done

    # Ensure the last directory is always shown in full, and handle root ("/")
    abbr_path+="${path_parts[-1]}"
    [[ $path == "/" ]] && abbr_path="/"

    # Trim the path to fit a maximum length, ensuring the last directory is visible
    local max_length=30
    local path_length=${#abbr_path}
    if (( path_length > max_length )); then
        abbr_path="../${abbr_path[-max_length,-1]}"
    fi

    echo "$abbr_path"
}
#PROMPT='[%T] $(summarize_directories)$ '

# use kitty's theme to color the prompt
theme_conf="$HOME/.config/kitty/Gruvbox Dark.conf"

# Extract colors
foreground_color=$(grep 'foreground' $theme_conf | awk '{print $2}')
background_color=$(grep 'background' $theme_conf | awk '{print $2}')
color0=$(grep 'color0' $theme_conf | awk '{print $2}')
color1=$(grep 'color1' $theme_conf | awk '{print $2}')
color2=$(grep 'color2' $theme_conf | awk '{print $2}')
color3=$(grep 'color3' $theme_conf | awk '{print $2}')

# Define colors for prompt
PROMPT='%F{$color2}$(date "+%m/%d %H:%M:%S")%f ${USER}@$(hostname -s | cut -c 1-8) %F{$color3}$(abbreviate_path)%f> '
PS1=$PROMPT

# enable zsh syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# enable mise version management (like asdf, but better)
eval "$(/Users/luke/.local/bin/mise activate zsh)"

# configure GPG keys
export GPG_TTY=$(tty)
