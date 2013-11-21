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
	echo "Unknown Location"
fi
}

if [ $1 = "launch" ]
then
	echo $2 > ~/.flux
	launch $2

elif [ $1 = "stop" ]
then
	killall xflux

elif [ $1 = "resume" ]
then
	launch $(cat ~/.flux)

else
	echo "Unknown command"
fi

