#! /bin/zsh
function calc()
{
	echo "$@" | bc -l
}

alias calc='noglob calc'
