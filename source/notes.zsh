#!/bin/zsh

function note
{
	if [[ -z "$1" ]]
	then
		notes
	else
		$EDITOR $HOME/notes/$1.md
	fi
}

function notes
{
	ls $HOME/notes | sed -e 's/\..*//'
}

function view
{
	inf=$HOME/notes/$1.md
	outf=$HOME/notes/.output/$1.html
	echo "<link href=\"http://kevinburke.bitbucket.org/markdowncss/markdown.css\" rel=\"stylesheet\"></link>" > $outf
	cmark $inf > $outf
	firefox $outf
}
