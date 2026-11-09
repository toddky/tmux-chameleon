#!/usr/bin/env bash
# USAGE: demo.sh [theme...]
# DESCRIPTION: Preview chameleon themes in the terminal: pane borders, status bar, message line, and shades.

# ==============================================================================
# ARGUMENTS
# ==============================================================================
selected_themes=()
while [[ $# -ge 1 ]]; do
	arg="$1" && shift
	case "$arg" in
		--help) sed -n 's/^# //p' "${BASH_SOURCE[0]}" | head -2; exit 0;;
		-*) echo "ERROR: unknown argument: $arg" 1>&2; exit 1;;
		*) selected_themes+=("$arg");;
	esac
done


# ==============================================================================
# ENVIRONMENT
# ==============================================================================
source "$(dirname "${BASH_SOURCE[0]}")/theme.sh"

if ((${#selected_themes[@]} == 0)); then
	selected_themes=("${tmux_chameleon_theme_names[@]}")
fi
for theme in "${selected_themes[@]}"; do
	[[ -z "${tmux_chameleon_themes[$theme]}" ]] || continue
	echo "ERROR: unknown theme: $theme (choose from: ${tmux_chameleon_theme_names[*]})" 1>&2
	exit 1
done

# Match colour_black_* and colour_white_* in colorscheme.bash.
inactive_pane_bg=232
active_pane_bg=233
inactive_pane_fg=251
active_pane_fg=255

# Match the fixed colors the status segment scripts print.
segment_green=10

width=96
reset=$'\e[0m'
bold=$'\e[1m'
nobold=$'\e[22m'


# ==============================================================================
# HELPERS
# ==============================================================================
function fg() {
	printf '\e[38;5;%sm' "$1"
}

function bg() {
	printf '\e[48;5;%sm' "$1"
}

function repeat() {
	local text="$1" num_repeats="$2" result=''
	for ((index = 0; index < num_repeats; index++)); do
		result+="$text"
	done
	printf '%s' "$result"
}

# Draws one pane body line and its bottom border, which carries the pane-border-format text.
function print_pane() {
	local pane_bg="$1" pane_fg="$2" command="$3" border_color="$4" pane_id="$5"
	printf '%s%s%-*s%s\n' "$(bg "$pane_bg")" "$(fg "$pane_fg")" "$width" "  \$ $command" "$reset"

	local pane_size="[%${pane_id}][80x24]" pane_dir='~/src'
	local num_dashes=$((width - 2 - ${#pane_size} - 1 - ${#pane_dir}))
	local border="$(fg "$border_color")$(repeat ─ 2)$pane_size $bold$pane_dir$nobold$(repeat ─ "$num_dashes")"
	printf '%s%s\n' "$border" "$reset"
}

function print_status_bar() {
	local left_text='[$0:main]'
	local left="$(fg "$medium")[\$0:${bold}main${nobold}]"

	# Window 1 was last visited, window 2 is current, window 3 is any other window.
	local center_text='1:logs 2:vim 3:bash'
	local center="$(fg "$lightest")${bold}1${nobold}:logs $(fg "$light")${bold}2${nobold}:vim $(fg "$white")${bold}3${nobold}:bash"

	local right_text='[17.6/23 GB][5%][+100%][96x40][3.5a][host][12:34]'
	local right="$(fg "$medium")[17.6/23 GB]$(fg "$segment_green")[5%][+100%]$(fg "$medium")[96x40][3.5a]"
	right+="$(fg "$segment_green")[host]$(fg "$medium")[12:34]"

	# status-justify centre centers the window list in the space left between status-left and status-right.
	local free_width=$((width - ${#left_text} - ${#center_text} - ${#right_text}))
	local left_gap=$((free_width / 2))
	local right_gap=$((free_width - left_gap))
	((left_gap >= 1)) || left_gap=1
	((right_gap >= 1)) || right_gap=1
	printf '%s%*s%s%*s%s%s\n' "$left" "$left_gap" '' "$center" "$right_gap" '' "$right" "$reset"
}

function print_message() {
	printf '%s%s%-*s%s\n' "$(bg "$inactive_pane_bg")" "$(fg "$light")" "$width" 'Configuration loaded!' "$reset"
}

function print_shades() {
	local shade
	printf '  '
	for shade in "${tmux_chameleon_theme_shades[@]}"; do
		printf '%s██%s %s=%s  ' "$(fg "${!shade}")" "$reset" "$shade" "${!shade}"
	done
	printf '\n'
}


# ==============================================================================
# PRINT THEMES
# ==============================================================================
for theme in "${selected_themes[@]}"; do
	read -r white lightest light medium dark darkest <<<"${tmux_chameleon_themes[$theme]}"
	printf '\n%s%s%s\n' "$bold" "$theme" "$reset"
	print_pane "$inactive_pane_bg" "$inactive_pane_fg" 'make test' "$darkest" 1
	print_pane "$active_pane_bg" "$active_pane_fg" 'vim theme.sh' "$medium" 2
	print_status_bar
	print_message
	print_shades
done
printf '\n'
