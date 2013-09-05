#!/bin/zsh
for NAME in $@
do
	echo -e $NAME
	7z x $NAME
done
