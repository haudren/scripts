#!/bin/zsh

function launch {
if [ -f $1 ]
then
	echo "Launching xflux with "$1" as city"
	load $1
	xflux -l $LATITUDE -g $LONGITUDE > /dev/null	
else 
	echo "Unknown Location, searching on OSM"
	search $1
	echo "Latitude : "$LATITUDE
	echo "Longitude : "$LONGITUDE
	save $1
fi
}

function search {
RAW_XML=$(wget -qO- "http://nominatim.openstreetmap.org/search?q="$1"&format=xml&limit=1" | sed 's/ /\n/g')
LATITUDE=$(echo $RAW_XML | grep lat= | sed 's/lat\=//' | sed "s/'//g")
LONGITUDE=$(echo $RAW_XML | grep lon= | sed 's/lon\=//' | sed "s/'//g")
}
	
function save {
	echo "Would you like to save these coordinates ? " 
	read -r 
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		touch $CITY
		echo $LATITUDE > $CITY
		echo $LONGITUDE >> $CITY
	fi
}

function load {
	read line < "$1"
	LATITUDE=$line
	read line < "$1"
	LONGITUDE=$line
}

cd ~/.flux
CITY=$2
if [ $1 = "launch" ]
then
	echo $CITY > ~/.flux/last_location
	FLUX_PID=$(pgrep xflux)
	if [ $FLUX_PID ]
	then
		echo "Stopping previous flux"
		killall xflux
	fi
	launch $CITY

elif [ $1 = "stop" ]
then
	killall xflux

elif [ $1 = "resume" ]
then
	launch $(cat last_location)
elif [ $1 = "search" ]
then
	search $CITY
	echo "Latitude : "$LATITUDE
	echo "Longitude : "$LONGITUDE
	save $CITY
else
	echo "Unknown command"
fi

