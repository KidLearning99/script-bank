#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# world_writable_audit.sh
# SYNOPSIS : World-writable files (security audit).
# DESCRIPTION: Finds world-writable files outside /tmp. Read-only; makes no changes.
# USAGE    : ./world_writable_audit.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# World-writable files (security audit).  ($(hostname) $(ts))"
find / -xdev -type f -perm -0002 ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null | grep -v "^/tmp" | head -50
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
