#!/bin/zsh

config='xmonad.hs'
single='xmonad.hs'
dual='xmonad_dual_screen.hs'

function get_resolution
{
	dim=$(xdpyinfo | grep 'dimensions' | sed -e 's/\s*dimensions:\s*//' | sed -e 's/\s*pixels.*//')
	resx=$(echo $dim | cut -d x -f 1)
	resy=$(echo $dim | cut -d x -f 2)
}

function select_wallpaper
{
	get_resolution
	wallpaper=$HOME/Pictures/wallpaper
	res_wallpaper=$wallpaper"_"$resx"_"$resy
	if [[ -f $res_wallpaper ]];
	then
		xloadimage -onroot -fullscreen $res_wallpaper
	else
		xloadimage -onroot -fullscreen $wallpaper
	fi
}


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

function scr_mode
{
	if [[ $1 == 'single' ]];
	then
		set_xmonad $single
	fi

	if [[ $1 == 'dual' ]];
	then
		set_xmonad $dual
	fi
	restart_xmonad
	select_wallpaper
}
