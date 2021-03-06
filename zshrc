#Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="cloud"
EDITOR="vim"
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ...='cd ../..'
alias -g ....=../../..

alias glcplay='aoss glc-play'

alias fuerte='source /home/herve/ros/fuerte_workspace/setup.zsh'
alias hydro='source /home/herve/ros/hydro_workspace/setup.zsh'
alias indigo='source /home/herve/ros/indigo_workspace/setup.zsh'
alias ladder='source /home/herve/ros/ladder_workspace/setup.zsh'
alias catkin='source /home/herve/ros/catkin_workspace/devel/setup.zsh'
alias catkin_2='source /home/herve/ros/catkin_2/devel/setup.zsh'

alias pkgfuerte='export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/home/herve/ros/fuerte_workspace'
alias pkghydro='export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/home/herve/ros/hydro_workspace'
alias bag_error='/home/herve/scripts/bag_error.py'

alias rosservice='noglob rosservice'

alias latexdiff='latexdiff -c ${HOME}/.latexdiff'

alias cmake='cmake -DCMAKE_EXPORT_COMPILE_COMMANDS:numeric=1'

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
zstyle :omz:plugins:ssh-agent identities clef_lirmm_2_openssh.ppk
plugins=(git autojump thefuck command-not-found pip ssh-agent tmux)
stty stop undef # to unmap ctrl-s

export DISABLE_AUTO_TILE='true'

#Expand fpath:
source $ZSH/oh-my-zsh.sh

#Source all functions
for f in $HOME/scripts/source/*;
do
	source $f;
done

export GUROBI_HOME=/opt/gurobi701/linux64
# Customize to your needs...
export PATH=/opt/texbin:$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:$HOME/scripts/bin:$HOME/.local/bin:$GUROBI_HOME/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$GUROBI_HOME/lib

fpath=($HOME/scripts/completions /usr/share/zsh/site-functions $fpath)
autoload -U compinit
compinit

export TERM=xterm-256color

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
