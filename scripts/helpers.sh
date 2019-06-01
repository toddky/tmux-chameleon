#!bash
declare -r HELPERS_DIR=$(dirname $(readlink -f ${BASH_SOURCE[0]}))

function tmux-get-option() {
	local option="$1" default_value="$2" option_value
	option_value=$(tmux show-option -gqv "$option")
	if [[ -z "$option_value" ]]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

function chameleon-set-theme() {
	color=$1
	echo Generate $1 scheme
	echo tmux source-file $HELPERS_DIR/chameleon-theme.tmux
}

