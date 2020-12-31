#!/usr/bin/env bash
declare -r CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
declare -r SCRIPTS_DIR="${CURRENT_DIR}/scripts"
source $SCRIPTS_DIR/helpers.sh

function main() {
	local color
	color=$(tmux-get-option '@chameleon-color' 'blue')
	chameleon-set-theme $color
	exit 0
}

main

