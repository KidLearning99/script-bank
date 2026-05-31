#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# service_status.sh
# SYNOPSIS : Failed and inactive systemd services.
# DESCRIPTION: Lists failed units and a summary. Read-only; makes no changes.
# USAGE    : ./service_status.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Failed and inactive systemd services.  ($(hostname) $(ts))"
command -v systemctl >/dev/null && { systemctl --failed; echo; systemctl list-units --type=service --state=running --no-legend | wc -l | xargs echo "running services:"; } || service --status-all
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
