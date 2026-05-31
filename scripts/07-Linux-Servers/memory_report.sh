#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# memory_report.sh
# SYNOPSIS : Memory and swap usage detail.
# DESCRIPTION: Reports RAM, swap and top memory consumers. Read-only; makes no changes.
# USAGE    : ./memory_report.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Memory and swap usage detail.  ($(hostname) $(ts))"
free -h; echo; echo "== top mem procs =="; ps -eo pid,comm,%mem --sort=-%mem | head -6; echo; cat /proc/meminfo | head -5
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
