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

function get_active_screens
{
	screens=$(xrandr | grep " connected" | sed -e 's/\s.*//')
}

function nr_screens
{
	get_active_screens
	nr_scr=$(echo $screens | wc -l)
}

function switch_screens
{
	nr_screens
	if [[ $nr_scr -gt 1 ]]
	then
		echo 'Switching to dual'
		set_screens
		scr_mode dual
	else
		set_screens
		scr_mode single
	fi
}

function set_screens
{
	get_active_screens
	if [[ $screens =~ "eDP-1-0" ]]
	then
		primary="eDP-1-0"
	else
		set -- $screens
		primary=$1
	fi
	screens=$(echo $screens | sed -e "s/\b$primary\b//g")

	xcom="xrandr --output "$primary" --auto"
	previous=$primary

	for screen in $screens
	do
		xcom=$xcom" --output "$screen" --auto --right-of "$previous
		previous=$screen
	done
	eval $xcom
}

