#!/bin/zsh

config='xmonad.hs'
single='xmonad.hs'
dual='xmonad_dual_screen.hs'

function black_screen
{
	echo "Turning off screen in 1 second"
	sleep 1 && xset dpms force off
}

function get_resolution
{
	scrlist=$(xrandr | grep " connected")
	scrarr=(${(f)scrlist})
	resx=0
	resy=0
	for scr in ${scrarr[@]}
	do
		dim=$(echo $scr | grep -o '[0-9]\+x[0-9]\+')
		curx=$(echo $dim | cut -d x -f 1)
		cury=$(echo $dim | cut -d x -f 2)
		((resx = resx + curx))
		((resy = cury > resy ? cury : resy))
	done
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
	ln -s $HOME/scripts/xmonad/$1 $HOME/.xmonad/$config
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

function get_inactive_screens
{
	screens=$(xrandr | grep "disconnected" | sed -e 's/\s.*//')
	screens=(${(f)screens})
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
		echo 'Switching to single'
		set_screens
		scr_mode single
	fi
}

function set_screens
{
	get_inactive_screens
	echo "Disactivating all disconnected screens"
	for screen in ${screens[@]}
	do
		xrandr --output $screen --off
	done

	get_active_screens
	if [[ $screens =~ "eDP1" ]]
	then
		echo 'eDP1 is primary'
		primary="eDP1"
	else
		set -- $screens
		primary=$1
		echo primary" is primary"
	fi
	screens=$(echo $screens | sed -e "s/\b$primary\b//g")

	xcom="xrandr --output "$primary" --auto"
	previous=$primary

	for screen in $screens
	do
		echo $screen" is secondary"
		xcom=$xcom" --output "$screen" --auto --right-of "$previous
		previous=$screen
	done
	echo "Found all screens"
	eval $xcom
}

