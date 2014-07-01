#!/bin/zsh

config='xmonad.hs'
single='xmonad.hs'
dual='xmonad_dual_screen.hs'

function set_xmonad
{
	rm $HOME/.xmonad/$config
	ln -s $HOME/scripts/$1 $HOME/.xmonad/$config
}

function restart_xmonad
{
	xmonad --recompile
	xmonad --restart
}

function screen
{
	if [[ $1 == 'single' ]];
	then
		set_xmonad $single
		restart_xmonad
	fi

	if [[ $1 == 'dual' ]];
	then
		set_xmonad $dual
		restart_xmonad
	fi
}
