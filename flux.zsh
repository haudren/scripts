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

