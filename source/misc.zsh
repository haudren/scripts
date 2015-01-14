#!/bin/zsh

function tex_src()
{
	apt-file -x search '/'$1'.sty$'
}
