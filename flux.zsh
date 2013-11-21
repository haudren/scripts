#!/bin/zsh

function launch {
if [ $1 =  "grenoble" ]
then
	echo "Launching xflux for Grenoble, France"
	xflux -l 45.2 -g 5.7 > /dev/null

elif [ $1 = "tsukuba" ]
then
	echo "Launching xflux for Tsukuba, Japan"
	xflux -l 36.1 -g 140.1 > /dev/null

else 
	echo "Unknown Location, searching on OSM"
	search $2
fi
}

function search {
RAW_XML=$(wget -qO- "http://nominatim.openstreetmap.org/search?q="$1"&format=xml&limit=1" | sed 's/ /\n/g')
LATITUDE=$(echo $RAW_XML | grep lat= | sed 's/lat\=//' | sed "s/'//g")
LONGITUDE=$(echo $RAW_XML | grep lon= | sed 's/lon\=//' | sed "s/'//g")
echo $LATITUDE"\n"$LONGITUDE
}

if [ $1 = "launch" ]
then
	echo $2 > ~/.flux
	FLUX_PID=$(pgrep xflux)
	if [ $FLUX_PID ]
	then
		echo "Stopping previous flux"
		killall xflux
	fi
	launch $2

elif [ $1 = "stop" ]
then
	killall xflux

elif [ $1 = "resume" ]
then
	launch $(cat ~/.flux)
elif [ $1 = "search" ]
then
	search $2

else
	echo "Unknown command"
fi

