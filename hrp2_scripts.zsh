#!/bin/bash

function set_hrp2_host() {
clear_host
	if [[ "$1" == "simu" ]]
	then
		hrp2_ip=$(grep hrp2-simu /etc/hosts | grep -Po '(\d+\.){3}\d+')
	elif [[ "$1" == "jrl" ]]
	then
		hrp2_ip=$(grep hrp2-jrl /etc/hosts | grep -Po '(\d+\.){3}\d+')
	else
		echo "Please select hrp2-simu or hrp2-jrl"
		return
	fi
	hrp2_host=$hrp2_ip"\thrp2"
	file=$(sed -e "s/hrp2-jrl$/hrp2-jrl\n$hrp2_host/" /etc/hosts)
	echo $file | sudo tee /etc/hosts > /dev/null
}

function clear_host() {
	sed -e '/hrp2$/d' /etc/hosts | sudo tee /etc/hosts > /dev/null
}

function set_hrp2_network
{
	export ROBOT_CONTROL="true"
	export HRP2_NETWORK="true"
	export HRP2_HOSTNAME="hrp2"
}

function clear_hrp2_network
{
	unset ROBOT_CONTROL
	unset HRP2_NETWORK
	unset HRP2_HOSTNAME
}

function is_hrp2_network__
{
	[ $HRP2_NETWORK -a $HRP2_NETWORK = "true" ]
}
