#!/bin/zsh

PULSE="/etc/pulse/default.pa"
MOD="load-module module-udev-detect"
SWITCH=$1

ENABLING=$(grep $MOD $PULSE)

if [[ "$ENABLING" = *ignore* ]] then
	echo "Disabling"
	FILE=$(sed -e "s/$MOD.*/$MOD/" $PULSE)
else
	echo "Enabling"
	FILE=$(sed -e "s/$MOD/$MOD ignore_dB=1/" $PULSE)
fi

echo "Writing $PULSE"
echo $FILE | sudo tee $PULSE > /dev/null
echo "Restarting pulse"
killall pulseaudio
