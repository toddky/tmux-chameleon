#!/usr/bin/env bash
# USAGE: mem-usage.bash
# DESCRIPTION: Print used and total memory in GB as a tmux status segment.

# Used matches free(1): total minus free, buffers, and reclaimable cache, with shared memory counted as used.
awk '
	/^MemTotal:/     { total = $2 }
	/^MemFree:/      { free = $2 }
	/^Buffers:/      { buffers = $2 }
	/^Cached:/       { cached = $2 }
	/^Shmem:/        { shmem = $2 }
	/^SReclaimable:/ { reclaimable = $2 }
	END { printf "[%0.1f/%d GB]", (total - free - buffers - cached + shmem - reclaimable) / 1048576, total / 1048576 }
' /proc/meminfo
