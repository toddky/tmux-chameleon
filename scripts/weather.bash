#!/usr/bin/env bash
# https://github.com/chubin/wttr.in
format="%l+-+%C+%t+%w"
weather="$(curl "http://wttr.in/Austin?u&format=$format" 2>/dev/null)"
RETVAL=$?
if ! ((RETVAL)); then
	echo "[$weather]"
fi
