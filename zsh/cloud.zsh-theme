if [[ -z $ZSH_THEME_CLOUD_PREFIX ]]; then
    ZSH_THEME_CLOUD_PREFIX='☁'
fi

function hrp2_prompt_info(){
if [[ -z "$HRP2_NETWORK" ]]
then
	echo '⤄'
else
	echo '⇆' 
fi
}

function git_repo(){
if [[ -z $(current_repository) ]]
then
	echo '別'
else
	echo $(current_repository | sed -e 's/.*\///' | sed -e 's/ .*//' | sed -e 's/\.git//')@
fi
}

PROMPT='%{$fg_bold[cyan]%}$ZSH_THEME_CLOUD_PREFIX %{$fg_bold[green]%}%p %{$fg_bold[red]%}$(hrp2_prompt_info) %{$fg_bold[white]%}$ROS_DISTRO %{$fg[green]%}%c %{$fg_bold[cyan]%}$(git_repo)$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}] %{$fg[yellow]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}]"
