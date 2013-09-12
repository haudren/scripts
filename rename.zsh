#!/bin/zsh
ARTIST=$(metaflac --show-tag=ARTIST $1 | sed -e 's/.*=//')
ALBUM=$(metaflac --show-tag=ALBUM $1 | sed -e 's/.*=//')
for file in $@
do
	TRACKNUMBER=$(metaflac --show-tag=TRACKNUMBER $file | sed -e 's/.*=//')
	TITLE=$(metaflac --show-tag=TITLE $file | sed -e 's/.*=//')

	if [ $TRACKNUMBER -ge 10 ]
	then
		FILENAME=$TRACKNUMBER' - '$TITLE'.flac'
	else
		FILENAME='0'$TRACKNUMBER' - '$TITLE'.flac'
	fi
	
	if [ $file != $FILENAME ]
	then
		echo $file' --> '$FILENAME
		mv -u $file $FILENAME
	else
		echo "No change for : "$file
	fi	
done
FOLDER=$ARTIST' - '$ALBUM' [FLAC]'
CURFOLDER=$(pwd | sed -e 's/.*\///')

if [ $FOLDER != $CURFOLDER ]
then 
	echo $(pwd)' --> '$FOLDER
	mkdir ../$FOLDER
	mv * ../$FOLDER
	cd ..
	rm -r $CURFOLDER
	cd $FOLDER
else
	echo "No folder stucture change"
fi
