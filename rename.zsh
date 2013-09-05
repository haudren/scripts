#!/bin/zsh
for file in $@
do
	TITLE=$(metaflac --show-tag=TITLE $file | sed -e 's/.*=//')
	NUM=$(metaflac --show-tag=TRACKNUMBER $file | sed -e 's/.*=//')
	if [ "$NUM" -lt "10" ]
	then
		NEWNUM=0$NUM
	else
		NEWNUM=$NUM
	fi
	NEWFILE=$NEWNUM" - "$TITLE".flac"
	mv $file $NEWFILE
	echo $1" ==> "$NEWFILE
done
