#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# mounted_filesystems.sh
# SYNOPSIS : Mounted filesystems and types.
# DESCRIPTION: Lists mounts, types and options. Read-only; makes no changes.
# USAGE    : ./mounted_filesystems.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Mounted filesystems and types.  ($(hostname) $(ts))"
(findmnt -A 2>/dev/null) || (mount | column -t)
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
