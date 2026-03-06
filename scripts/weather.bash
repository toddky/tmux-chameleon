#!/usr/bin/env bash
# https://github.com/chubin/wttr.in

# https://github.com/2KAbhishek/tmux2k/blob/main/scripts/weather.sh
declare -A weather_icons=(
    ["Clear"]="󰖙"
    ["Cloud"]=""
    ["Drizzle"]="󰖗"
    ["Fog"]=""
    ["Haze"]="󰼰"
    ["Mist"]=""
    ["Overcast"]=""
    ["Rain"]=""
    ["Sand"]=""
    ["Shower"]=""
    ["Smoke"]=""
    ["Snow"]=""
    ["Sunny"]="󰖙"
    ["Thunderstorm"]=""
    ["Tornado"]="󰼸"
    ["Windy"]="󰖝"
)

format="%l+-+%C+%t+%w"
weather="$(curl "http://wttr.in/Austin?u&format=$format" 2>/dev/null)"
RETVAL=$?
if ! ((RETVAL)); then
	echo "[$weather]"
fi
