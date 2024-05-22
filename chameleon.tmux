#!/usr/bin/env bash
declare -r CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
declare -r SCRIPTS_DIR="${CURRENT_DIR}/scripts"

# REVISIT: Use this
function tmux-get-option() {
	local option="$1" default_value="$2" option_value
	option_value=$(tmux show-option -gqv "$option")
	if [[ -z "$option_value" ]]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

color=blue
"$SCRIPTS_DIR/colorscheme.bash" "$color"

