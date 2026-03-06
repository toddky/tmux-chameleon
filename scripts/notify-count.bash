#!/usr/bin/env bash
shopt -s nullglob
notify_dir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/tmux-notify"
files=("$notify_dir"/*.txt)
count=${#files[@]}
(( count )) || exit 0
echo "#[fg=colour9,bold][$count]#[fg=default,nobold]"
