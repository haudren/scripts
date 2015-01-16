#!/bin/zsh

function tex_src()
{
	apt-file -x search '/'$1'.sty$'
}

function build()
{
	if [[ ! -d build ]]
	then
		echo "Make dir"
		mkdir build
	fi

	if [[ $1 == "debug" ]]
	then
		BUILDTYPE=Debug
	elif [[ $1 == "release" ]]
	then
		BUILDTYPE=Release
	else
		echo "Please supply debug/release"
		return 1
	fi

	cd build
	cmake -DCMAKE_BUILD_TYPE=$BUILDTYPE ..
	make
	cd ..
}
