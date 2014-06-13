#!/bin/zsh

CPUPATH="/sys/devices/system/cpu"
FILE="cpufreq/scaling_governor"

for CPU in $(ls $CPUPATH | grep "cpu[0-9]")
do
	FULLPATH=$CPUPATH/$CPU/$FILE
	CONTENT=$(cat $FULLPATH)

	if [[ $CONTENT = "performance" ]]
	then
		echo "ondemand" | sudo tee $FULLPATH
	else
		echo "performance" | sudo tee $FULLPATH
	fi
done
