
# vi: filetype=tmux

# ==============================================================================
# WINDOWS
# ==============================================================================

# --- Base Index ---
set-window-option -g base-index 1

# --- Renumber Windows ---
set-option -g renumber-windows on


# ==============================================================================
# PANES
# ==============================================================================

# --- Base Index ---
set-window-option -g pane-base-index 1

# --- Window Format ---
set-option -g window-style "bg=$tmux_black,fg=$tmux_white_dark"
set-option -g window-active-style "bg=$tmux_black_dark,fg=$tmux_white"

# --- Border ---
_tmux_sync_text="#[fg=$tmux_red][SYNC]#[fg=default]"
_tmux_sync_indicator="#{?pane_synchronized,$_tmux_sync_text,}"
_tmux_prefix_text="#[fg=$tmux_red][PREFIX]#[fg=default]"
_tmux_prefix_indicator="#{?client_prefix,$_tmux_prefix_text,}"
_tmux_pane_size="[#{pane_width}x#{pane_height}]"
_tmux_mode_text="#[fg=$tmux_yellow][#{pane_mode}]#[fg=default]"
_tmux_mode_indicator="#{?pane_in_mode,$_tmux_mode_text,$_tmux_pane_size}"
_tmux_pane_path="#[bold]#{pane_current_path}"

set-window-option -g pane-border-status bottom
set-window-option -g pane-border-format "$_tmux_prefix_indicator$_tmux_sync_indicator$_tmux_mode_indicator $_tmux_pane_path"

