if [ $1 =  "grenoble" ]
then
	xflux -l 45.2 -g 5.7

elif [ $1 = "tsukuba" ]
then
	xflux -l 36.1 -g 140.1

else 
	echo "Unknown Location"
fi

