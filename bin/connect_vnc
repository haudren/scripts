#!/bin/zsh
ssh-add /home/herve/.ssh/private_herve.ppk
ssh -C -f -L 5900:localhost:5900 $1\
	x11vnc -safer -localhost -nopw -once -display :0\
	&& sleep 5\
	&& vncviewer localhost:0
