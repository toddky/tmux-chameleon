
# vi: filetype=tmux

# ==============================================================================
# MAIN SETTINGS
# ==============================================================================

# Position
set-option -g status-position bottom

# Refresh rate (seconds)
set-option -g status-interval 15


# ==============================================================================
# LEFT
# ==============================================================================
_tmux_session_name="#[bold]#{session_name}#[nobold]"
set-option -g status-left "#[nobold][#{session_id}:$_tmux_session_name]"
set-option -g status-left-length 32


# ==============================================================================
# CENTER
# ==============================================================================
set-window-option -g status-justify centre

# Window status format
_tmux_window_index="#[bold]#I#[nobold]"
_tmux_activity_flag="#[fg=colour9]!#[fg=default]"
_tmux_window_activity="#{?window_activity_flag,$tmux_activity_flag,}"
_tmux_window_flag="#[fg=default]*"
_tmux_window_zoomed="#{?window_zoomed_flag,$_tmux_window_flag,}"
set-window-option -g window-status-format "$_tmux_window_index:#W$_tmux_window_activity$_tmux_window_zoomed"
set-window-option -g window-status-separator " "

# Prevent escape sequences from renaming window
set-window-option -g allow-rename off

# Disable automatic renaming
set-window-option -g automatic-rename off
set-window-option -g automatic-rename-format "unnamed"

# Status activity format
set-window-option -g window-status-activity-attr none

# Active window format
set-window-option -g window-status-current-format "$_tmux_window_index:#W$_tmux_window_activity$_tmux_window_zoomed"


# ==============================================================================
# RIGHT
# ==============================================================================
# TODO: Remove hardcoded paths
_tmux_chameleon_path="~/.tmux/plugins/tmux-chameleon"
_tmux_client_size="[#{client_width}x#{client_height}]"
_tmux_cpu_usage="#($_tmux_chameleon_path/scripts/cpu-usage.bash)"
_tmux_host="#($_tmux_chameleon_path/scripts/host.bash)"
_tmux_mem_usage="#($_tmux_chameleon_path/scripts/mem-usage.bash)"
_tmux_time="#[fg=$tmux_white][#(date +%H:%M)]#[fg=default]"
_tmux_version="[#{version}]"
set-option -g status-right "$_tmux_mem_usage$_tmux_cpu_usage$_tmux_client_size$_tmux_version$_tmux_host$_tmux_time"
set-option -g status-right-length 60

