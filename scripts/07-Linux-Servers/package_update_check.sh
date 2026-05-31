#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# package_update_check.sh
# SYNOPSIS : Available package updates (no changes).
# DESCRIPTION: Dry-run check for pending updates. Read-only; makes no changes.
# USAGE    : ./package_update_check.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Available package updates (no changes).  ($(hostname) $(ts))"
if command -v apt-get >/dev/null; then apt-get -s upgrade 2>/dev/null | grep -E "^[0-9]+ upgraded"; elif command -v dnf >/dev/null; then dnf check-update || true; elif command -v yum >/dev/null; then yum check-update || true; fi
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
