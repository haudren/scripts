#!/bin/zsh

function compliance_config
{
	rosservice call /load_config $1
}
