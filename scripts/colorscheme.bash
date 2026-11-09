#!/usr/bin/env bash
# USAGE: colorscheme.bash [red|yellow|green|blue|purple|black|default] [verbose]
# DESCRIPTION: Apply a colorscheme and the status bar layout to the running tmux server.

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
# Each colorscheme lists: white lightest light medium dark darkest.
red='15 181 203 9 160 52'
yellow='15 229 227 190 11 94'
green='15 156 82 46 70 22'
blue='15 159 87 39 33 26'
purple='15 147 141 129 93 53'
black='239 243 249 249 243 239'

default="$blue"
if [[ -n "$LSB_BATCH_JID" ]]; then
	default="$yellow"
fi

case "$colorscheme" in
	red|yellow|green|blue|purple|black|default) ;;
	*) echo "ERROR: unknown colorscheme: $colorscheme" 1>&2; exit 1;;
esac
read -r white lightest light medium dark darkest <<<"${!colorscheme}"

colour_black_light=colour233
colour_black_dark=colour232
colour_white_light=colour255
colour_white_dark=colour251
tmux_red=colour160
tmux_yellow=colour220

plugin_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"


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
	for color_name in white lightest light medium dark darkest; do
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
# STATUS BAR
# ==============================================================================
tmux set-option -g status-position bottom

# Refresh rate (seconds)
tmux set-option -g status-interval 15

# Hide status bar if only a single window is open; if-shell runs /bin/sh, so these tests use [ ].
# https://schauderbasis.de/posts/hide_tmux_status_bar_if_its_not_needed/
tmux set-hook -g after-new-window      'if "[ #{session_windows} -gt 1 ]" "set-option status on"'
tmux set-hook -g after-kill-pane       'if "[ #{session_windows} -lt 2 ]" "set-option status off"'
tmux set-hook -g pane-exited           'if "[ #{session_windows} -lt 2 ]" "set-option status off"'
tmux set-hook -g window-layout-changed 'if "[ #{session_windows} -lt 2 ]" "set-option status off"'


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

index="#[bold]#I#[nobold]"
activity="#{?window_activity_flag,#[fg=colour9]!#[fg=default],}"
zoomed="#{?window_zoomed_flag,#[fg=default]*,}"
tmux set-window-option -g window-status-format "$index:#W$activity$zoomed"
tmux set-window-option -g window-status-current-format "$index:#W$activity$zoomed"
tmux set-window-option -g window-status-separator " "

# Prevent escape sequences from renaming window
tmux set-window-option -g allow-rename off

# Disable automatic renaming
tmux set-window-option -g automatic-rename off
tmux set-window-option -g automatic-rename-format "unnamed"


# ==============================================================================
# STATUS BAR RIGHT
# ==============================================================================
notify="#($plugin_dir/scripts/status/notify-count)"
memory="#($plugin_dir/scripts/status/mem-usage)"
cpu_usage="#($plugin_dir/scripts/status/cpu-usage)"
size="[#{client_width}x#{client_height}]"
tmux_version="[#{version}]"
host="#($plugin_dir/scripts/status/host)"
time="[#(date +%H:%M)]"
tmux set-option -g status-right "$notify$memory$cpu_usage$size$tmux_version$host$time"
tmux set-option -g status-right-length 60


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
