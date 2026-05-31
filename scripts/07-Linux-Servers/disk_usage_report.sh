#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# disk_usage_report.sh
# SYNOPSIS : Largest directories under a path.
# DESCRIPTION: Reports top space consumers (default /var). Read-only; makes no changes.
# USAGE    : ./disk_usage_report.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Largest directories under a path.  ($(hostname) $(ts))"
TARGET=${1:-/var}; du -xh "$TARGET" 2>/dev/null | sort -rh | head -20
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
