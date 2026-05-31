#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# systemd_timers.sh
# SYNOPSIS : Active systemd timers (scheduled jobs).
# DESCRIPTION: Lists timers and next run times. Read-only; makes no changes.
# USAGE    : ./systemd_timers.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Active systemd timers (scheduled jobs).  ($(hostname) $(ts))"
command -v systemctl >/dev/null && systemctl list-timers --all --no-pager || echo 'systemd not present'
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
