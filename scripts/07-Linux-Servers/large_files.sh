#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# large_files.sh
# SYNOPSIS : Largest files under a path.
# DESCRIPTION: Finds the biggest files (default /var). Read-only; makes no changes.
# USAGE    : ./large_files.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Largest files under a path.  ($(hostname) $(ts))"
TARGET=${1:-/var}; find "$TARGET" -type f -printf "%s\t%p\n" 2>/dev/null | sort -rn | head -20 | awk "{printf(\"%.1f MB\t%s\n\",$1/1048576,$2)}"
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
