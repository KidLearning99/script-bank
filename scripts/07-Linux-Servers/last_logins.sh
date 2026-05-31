#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# last_logins.sh
# SYNOPSIS : Recent successful logins.
# DESCRIPTION: Reports recent user logins from wtmp. Read-only; makes no changes.
# USAGE    : ./last_logins.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Recent successful logins.  ($(hostname) $(ts))"
last -n 25 2>/dev/null | head -25
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
