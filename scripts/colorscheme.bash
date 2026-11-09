#!/usr/bin/env bash
# USAGE: colorscheme.bash [red|yellow|green|blue|purple|black|default] [verbose]
# DESCRIPTION: Apply a colorscheme and the window and pane settings to the running tmux server.

# ==============================================================================
# ARGUMENTS
# ==============================================================================
colorscheme="${1:-default}"
verbose=0
if [[ -n "$2" ]]; then
	verbose=1
fi


# ==============================================================================
# ENVIRONMENT
# ==============================================================================
source "$(dirname "${BASH_SOURCE[0]}")/theme.sh"

if [[ "$colorscheme" == default ]]; then
	colorscheme=blue
	if [[ -n "$LSB_BATCH_JID" ]]; then
		colorscheme=yellow
	fi
fi

if [[ -z "${tmux_chameleon_themes[$colorscheme]}" ]]; then
	echo "ERROR: unknown colorscheme: $colorscheme (choose from: ${tmux_chameleon_theme_names[*]} default)" 1>&2
	exit 1
fi
read -r white lightest light medium dark darkest <<<"${tmux_chameleon_themes[$colorscheme]}"

colour_black_light=colour233
colour_black_dark=colour232
colour_white_light=colour255
colour_white_dark=colour251
tmux_red=colour160
tmux_yellow=colour220


# ==============================================================================
# HELPERS
# ==============================================================================
function print_color() {
	local color_name="$1"
	echo -e "\x1b[38;5;${!color_name}m${color_name}\e[0m"
}

# tmux 2.9 replaced the -fg/-bg options with -style.
# Set all three and hide the errors so any tmux version gets the colors.
function tmux_set_style() {
	local option="$1" fg="${2:-default}" bg="${3:-default}"
	{
		tmux set-option -g "$option-fg" "$fg"
		tmux set-option -g "$option-bg" "$bg"
		tmux set-option -g "$option-style" "bg=$bg,fg=$fg"
	} 2>/dev/null
}

function tmux_set_window_style() {
	local option="$1" fg="${2:-default}" bg="${3:-default}"
	{
		tmux set-window-option -g "$option-fg" "$fg"
		tmux set-window-option -g "$option-bg" "$bg"
		tmux set-window-option -g "$option-style" "bg=$bg,fg=$fg"
	} 2>/dev/null
}


# ==============================================================================
# PRINT COLORS
# ==============================================================================
if ((verbose)); then
	for color_name in "${tmux_chameleon_theme_shades[@]}"; do
		print_color "$color_name"
	done
fi


# ==============================================================================
# SET COLORS
# ==============================================================================
tmux_set_style pane-border        "colour$darkest"
tmux_set_style pane-active-border "colour$medium"

tmux_set_style        status                "colour$medium"
tmux_set_window_style window-status         "colour$white"
tmux_set_window_style window-status-current "colour$light"
tmux_set_window_style window-status-last    "colour$lightest"

tmux_set_style window        "$colour_white_dark"  "$colour_black_dark"
tmux_set_style window-active "$colour_white_light" "$colour_black_light"

tmux_set_style message "colour$light" "$colour_black_dark"


# ==============================================================================
# WINDOWS
# ==============================================================================
tmux set-window-option -g base-index 1
tmux set-option -g renumber-windows on


# ==============================================================================
# PANES
# ==============================================================================
tmux set-window-option -g pane-base-index 1

sync_text="#[fg=$tmux_red][SYNC]#[fg=default]"
sync_indicator="#{?pane_synchronized,$sync_text,}"
prefix_text="#[fg=$tmux_red][PREFIX]#[fg=default]"
prefix_indicator="#{?client_prefix,$prefix_text,}"
readonly_text="#[fg=$tmux_red][READONLY]#[fg=default]"
readonly_indicator="#{?pane_input_off,$readonly_text,}"
pane_size="[#{pane_id}][#{pane_width}x#{pane_height}]"
mode_text="#[fg=$tmux_yellow][#{pane_mode}]#[fg=default]"
mode_indicator="#{?pane_in_mode,$mode_text,$pane_size}"
pane_dir="#[bold]#{pane_current_path}"

tmux set-window-option -g pane-border-status bottom
tmux set-window-option -g pane-border-format "$prefix_indicator$readonly_indicator$sync_indicator$mode_indicator $pane_dir"
