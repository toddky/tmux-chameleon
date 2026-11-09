#!/usr/bin/env bash
# USAGE: colour_palette.bash
# DESCRIPTION: Print all 256 terminal colors with their tmux colour names.

for ((row = 0; row < 32; row++)); do
	for ((column = 0; column < 8; column++)); do
		colour_number=$((8 * row + column))
		printf '\x1b[38;5;%dmcolour%-3d ' "$colour_number" "$colour_number"
	done
	printf '\e[0m\n'
done
