#!/usr/bin/env bash
declare -r CURRENT_DIR=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
declare -r SCRIPTS_DIR="${CURRENT_DIR}/scripts"
source $SCRIPTS_DIR/helpers.sh

function main() {
	local color
	color=$(tmux-get-option '@chameleon-color' 'blue')
	chameleon-set-theme $color
	exit 0
}

main

