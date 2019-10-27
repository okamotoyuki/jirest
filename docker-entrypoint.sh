#!/bin/ash

if [ $# -gt 1 ] ; then
    command=$1
    shift
    bundle exec exe/jirest $command "$@"
else
    bundle exec exe/jirest $@
fi
