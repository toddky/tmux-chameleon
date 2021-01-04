#!/usr/bin/env bash

# --- Parse Arguments ---
colorscheme=${1:-default}
verbose=$2

# TODO: Use actual version calculation
#declare -r version=$(tmux -V | cut -c 6-8)
declare -r version=3.0

# ==============================================================================
# COLORSCHEMES
# ==============================================================================
red='15 181 203 9 160 52'
yellow='15 229 227 190 11 94'
green='15 156 82 46 70 22'
blue='15 159 14 39 33 26'
purple='15 147 141 129 93 53'
black='239 243 249 249 243 239'

default=$blue
[[ -n $LSB_BATCH_JID ]] && default=$yellow

# Set colorscheme
read -r white lightest light medium dark darkest <<<$(eval echo \$$colorscheme)


# --- Print Colors ---
if [[ -n $verbose ]]; then
	function cprint() {
		local color=$1 value
		value=$(eval echo \$$color)
		echo -e "\x1b[38;5;${value}m${color}\e[0m"
	}
	cprint white
	cprint lightest
	cprint light
	cprint medium
	cprint dark
	cprint darkest
fi


# --- Set Option with Brute Force ---
# TODO: '[[ $(echo "$TMUX_VERSION >= 2.9" | bc) -eq 1 ]]'
function tmux_set_style() {
	local option=$1 fg=${2:-default} bg=${3:-default}
	(
		tmux set-option -g $option-fg $fg
		tmux set-option -g $option-bg $bg
		tmux set-option -g $option-style bg=$bg,fg=$fg
	) 2>/dev/null
}
function tmux_set_window_style() {
	local option=$1 fg=${2:-default} bg=${3:-default}
	(
		tmux set-window-option -g $option-fg $fg
		tmux set-window-option -g $option-bg $bg
		tmux set-window-option -g $option-style bg=$bg,fg=$fg
	) 2>/dev/null
}


# ==============================================================================
# MAIN
# ==============================================================================
# Set pane border colors
tmux_set_style pane-border        colour$darkest
tmux_set_style pane-active-border colour$medium

# Set status bar colors
tmux_set_style        status                colour$medium
tmux_set_window_style window-status         colour$white
tmux_set_window_style window-status-current colour$light
tmux_set_window_style window-status-last    colour$lightest

# Set window colors
tmux_set_style window        colour251 colour232
tmux_set_style window-active colour255 colour233

