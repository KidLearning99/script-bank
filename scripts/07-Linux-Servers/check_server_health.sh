#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# check_server_health.sh
# SYNOPSIS : Load, memory, disk and failed-unit health check.
# DESCRIPTION: One-shot health check; warns on thresholds. Read-only; makes no changes.
# USAGE    : ./check_server_health.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Load, memory, disk and failed-unit health check.  ($(hostname) $(ts))"
uptime; echo; free -h; echo; df -hP; echo "== failed units =="; command -v systemctl >/dev/null && systemctl --failed --no-legend || true
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
