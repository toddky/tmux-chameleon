#!/usr/bin/env bash

# MacOS only
which pmset &> /dev/null || exit
echo -n "[$(pmset -g batt | grep -o '[0-9]\{1,3\}%')]"

