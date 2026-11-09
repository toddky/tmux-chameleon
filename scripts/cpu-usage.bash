#!/usr/bin/env bash
# USAGE: cpu-usage.bash
# DESCRIPTION: Print CPU usage over the next second as a colored tmux status segment.

# ==============================================================================
# HELPERS
# ==============================================================================
# Prints the total and idle jiffies from the aggregate cpu line.
function cpu_times() {
	awk '/^cpu[[:space:]]/ { for (i = 2; i <= NF; i++) total += $i; print total, $5 }' /proc/stat
}


# ==============================================================================
# MEASURE USAGE
# ==============================================================================
read -r total_start idle_start < <(cpu_times)
sleep 1
read -r total_end idle_end < <(cpu_times)

total_delta=$((total_end - total_start))
if [[ -z "$total_start" || -z "$total_end" ]] || ((total_delta <= 0)); then
	echo "#[fg=colour9][??%]#[fg=default]"
	exit 0
fi
idle_percent=$((100 * (idle_end - idle_start) / total_delta))
usage_percent=$((100 - idle_percent))

# REVISIT: Another way to get percentage
#percent=$(LC_NUMERIC=en_US.UTF-8 top -bn2 -d 0.01 | grep "Cpu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')


# ==============================================================================
# PRINT USAGE
# ==============================================================================
color=9
if ((usage_percent < 40)); then
	color=10
elif ((usage_percent < 80)); then
	color=11
fi
echo "#[fg=colour$color][$usage_percent%]#[fg=default]"
