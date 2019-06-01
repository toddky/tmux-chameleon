
# vi: filetype=sh

tmux_black=colour16
tmux_black_white=colour246
tmux_black_light=colour243
tmux_black_medium=colour0
tmux_black_dark=colour233
tmux_blue=colour33
tmux_blue_white=colour159
tmux_blue_light=colour14
tmux_blue_medium=colour39
tmux_blue_dark=colour19
tmux_green=colour82
tmux_green_white=colour156
tmux_green_light=colour46
tmux_green_medium=colour34
tmux_green_dark=colour22
tmux_grey=colour234
tmux_pink=colour159
tmux_red=colour9
tmux_white=colour15
tmux_white_dark=colour253
tmux_yellow=colour11

tmux_activity_flag="#[fg=$tmux_red]!#[fg=default]"


# ==============================================================================
# MESSAGE
# ==============================================================================
set-option -g message-fg $tmux_yellow
set-option -g message-bg $tmux_grey
set-option -g message-attr default


# ==============================================================================
# WINDOW STATUS
# ==============================================================================
set-window-option -g window-status-fg $tmux_white
set-window-option -g window-status-bg default
set-window-option -g window-status-attr dim


# ==============================================================================
# STATUS
# ==============================================================================
set-option -g status-bg $tmux_grey
set-option -g status-attr dim

# ==============================================================================
# LEFT
# ==============================================================================
set-option -g status-left-attr dim

