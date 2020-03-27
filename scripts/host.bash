#!/usr/bin/env bash

# Default values
host="$(hostname --short)"
color=colour10

# LSF environment
if [[ -n "$LSB_BATCH_JID" ]]; then
	color=colour11
	host="$LSB_BATCH_JID"
	# TODO: time_left=$(bjobs -noheader -o time_left $job)

# Weird host
elif [[ $host =~ ^s110 ]]; then
	color=colour9
fi

# Print host information
echo -n "#[fg=$color]<$host"

# Linux Standard Base (LSB) information
echo -n "($(lsb_release -rs))"

# End of segment
echo '>#[fg=default]'

