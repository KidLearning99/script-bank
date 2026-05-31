#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# top_processes.sh
# SYNOPSIS : Top processes by CPU and memory.
# DESCRIPTION: Shows the heaviest processes. Read-only; makes no changes.
# USAGE    : ./top_processes.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Top processes by CPU and memory.  ($(hostname) $(ts))"
echo "== by CPU =="; ps -eo pid,comm,%cpu --sort=-%cpu | head -11; echo; echo "== by MEM =="; ps -eo pid,comm,%mem --sort=-%mem | head -11
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
