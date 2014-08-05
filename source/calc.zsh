#! /bin/zsh
function calc()
{
echo "$@" | bc -l
}
