#!/usr/bin/env bash

# Variables
job=$LSB_BATCH_JID
host=$(hostname --short)

# --- LSF Environment ---
if [[ -n $job ]]; then
	# TODO: time_left=$(bjobs -noheader -o time_left $job)
	echo "#[fg=colour11][$job]#[fg=default]"

# --- Weird Host ---
elif [[ $host =~ ^s110 ]]; then
	echo "#[fg=colour9][$(hostname --short)]#[fg=default]"

# --- Regular Host ---
else
	echo "#[fg=colour10][$(hostname --short)]#[fg=default]"
fi

