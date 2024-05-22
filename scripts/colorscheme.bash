#!/usr/bin/env bash

# --- Parse Arguments ---
colorscheme="${1:-default}"
verbose="$2"

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

colour_black_light=colour233
colour_black_dark=colour232
colour_white_light=colour255
colour_white_dark=colour251

default="$blue"
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
	local option="$1" fg="${2:-default}" bg="${3:-default}"
	(
		tmux set-option -g $option-fg "$fg"
		tmux set-option -g $option-bg "$bg"
		tmux set-option -g $option-style "bg=$bg,fg=$fg"
	) 2>/dev/null
}
function tmux_set_window_style() {
	local option="$1" fg="${2:-default}" bg="${3:-default}"
	(
		tmux set-window-option -g $option-fg "$fg"
		tmux set-window-option -g $option-bg "$bg"
		tmux set-window-option -g $option-style "bg=$bg,fg=$fg"
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
tmux_set_style window        $colour_white_dark  $colour_black_dark
tmux_set_style window-active $colour_white_light $colour_black_light

# Set message colors
tmux_set_style message "colour$light" "$colour_black_dark"

# Position
tmux set-option -g status-position bottom

# Refresh rate (seconds)
tmux set-option -g status-interval 15

# Hide status bar if if only a single window is open
# https://schauderbasis.de/posts/hide_tmux_status_bar_if_its_not_needed/
tmux set-hook -g after-new-window      'if "[ #{session_windows} -gt 1 ]" "set status on"'
tmux set-hook -g after-kill-pane       'if "[ #{session_windows} -lt 2 ]" "set status off"'
tmux set-hook -g pane-exited           'if "[ #{session_windows} -lt 2 ]" "set status off"'
tmux set-hook -g window-layout-changed 'if "[ #{session_windows} -lt 2 ]" "set status off"'


# ==============================================================================
# STATUS BAR LEFT
# ==============================================================================
bold_session="#[bold]#{session_name}#[nobold]"
tmux set-option -g status-left "#[nobold][#{session_id}:$bold_session]"
tmux set-option -g status-left-length 32


# ==============================================================================
# STATUS BAR CENTER
# ==============================================================================
tmux set-window-option -g status-justify centre

# Window status format
index="#[bold]#I#[nobold]"
activity="#{?window_activity_flag,#[fg=colour9]!#[fg=default],}"
zoomed="#{?window_zoomed_flag,#[fg=default]*,}"
tmux set-window-option -g window-status-format "$index:#W$activity$zoomed"
tmux set-window-option -g window-status-separator " "

# Prevent escape sequences from renaming window
tmux set-window-option -g allow-rename off

# Disable automatic renaming
tmux set-window-option -g automatic-rename off
tmux set-window-option -g automatic-rename-format "unnamed"

# Active window format
tmux set-window-option -g window-status-current-format "$index:#W$activity$zoomed"


# ==============================================================================
# STATUS BAR RIGHT
# ==============================================================================
# TODO: Remove hardcoded paths
_tmux_chameleon_path="~/.tmux/plugins/tmux-chameleon"
size="[#{client_width}x#{client_height}]"
_tmux_cpu_usage="#($_tmux_chameleon_path/scripts/cpu-usage.bash)"
host="#($_tmux_chameleon_path/scripts/host.bash)"
memory="#($_tmux_chameleon_path/scripts/mem-usage.bash)"
time="#[fg=$tmux_white][#(date +%H:%M)]#[fg=default]"
tmux_version="[#{version}]"
tmux set-option -g status-right "$memory$_tmux_cpu_usage$size$tmux_version$host$time"
tmux set-option -g status-right-length 60


# ==============================================================================
# WINDOWS
# ==============================================================================

# Start with window number 1
tmux set-window-option -g base-index 1

# Automatically renumber windows
tmux set-option -g renumber-windows on


# ==============================================================================
# PANES
# ==============================================================================

# --- Base Index ---
tmux set-window-option -g pane-base-index 1

# --- Window Format ---
tmux set-option -g window-style "bg=$colour_black_dark,fg=$colour_white_dark"
tmux set-option -g window-active-style "bg=$colour_black_light,fg=$colour_white_light"

# Red
tmux_red=colour160

# --- Border ---
_tmux_sync_text="#[fg=$tmux_red][SYNC]#[fg=default]"
_tmux_sync_indicator="#{?pane_synchronized,$_tmux_sync_text,}"
_tmux_prefix_text="#[fg=$tmux_red][PREFIX]#[fg=default]"
_tmux_prefix_indicator="#{?client_prefix,$_tmux_prefix_text,}"
_tmux_readonly_text="#[fg=$tmux_red][READONLY]#[fg=default]"
_tmux_readonly_indicator="#{?pane_input_off,$_tmux_readonly_text,}"
_tmux_pane_size="[#{pane_width}x#{pane_height}]"
_tmux_mode_text="#[fg=$tmux_yellow][#{pane_mode}]#[fg=default]"
_tmux_mode_indicator="#{?pane_in_mode,$_tmux_mode_text,$_tmux_pane_size}"
_tmux_pane_path="#[bold]#{pane_current_path}"

tmux set-window-option -g pane-border-status bottom
tmux set-window-option -g pane-border-format "$_tmux_prefix_indicator$_tmux_readonly_indicator$_tmux_sync_indicator$_tmux_mode_indicator $_tmux_pane_path"

