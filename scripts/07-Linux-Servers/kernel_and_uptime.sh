#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# kernel_and_uptime.sh
# SYNOPSIS : Kernel version, modules count, uptime.
# DESCRIPTION: Reports kernel and module summary. Read-only; makes no changes.
# USAGE    : ./kernel_and_uptime.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Kernel version, modules count, uptime.  ($(hostname) $(ts))"
uname -r; echo "modules: $(lsmod 2>/dev/null | tail -n +2 | wc -l)"; uptime
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
