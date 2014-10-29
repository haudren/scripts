#!/bin/zsh

function note
{
	$EDITOR $HOME/notes/$1.md
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
