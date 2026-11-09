# USAGE: source theme.sh
# DESCRIPTION: Define the chameleon themes as 256-color numbers, one per shade.

# ==============================================================================
# THEMES
# ==============================================================================
# Arrays keep a stable order for anything that lists every theme or shade.
tmux_chameleon_theme_names=(red yellow green blue purple black)
tmux_chameleon_theme_shades=(white lightest light medium dark darkest)

# -g keeps the table global when this file is sourced from inside a function.
declare -gA tmux_chameleon_themes=(
	[red]='15 181 203 9 160 52'
	[yellow]='15 229 227 190 11 94'
	[green]='15 156 82 46 70 22'
	[blue]='15 159 87 39 33 26'
	[purple]='15 147 141 129 93 97'
	[black]='239 243 249 249 243 239'
)

