#!/usr/bin/env bash
shopt -s nullglob
notify_dir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/tmux-notify"
files=("$notify_dir"/*.txt)

# Only count panes that still exist
count=0
for notify_file in "${files[@]}"; do
	pane_id="$(basename "$notify_file" .txt)"
	session_name="$(tmux display-message -t "%${pane_id}" -p '#{session_name}' 2>/dev/null)"
	[[ -n "$session_name" ]] && (( count++ ))
done

(( count )) || exit 0
echo "#[fg=colour9,bold][$count]#[fg=default,nobold]"
