#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# journal_errors.sh
# SYNOPSIS : Recent error-level journal entries.
# DESCRIPTION: Reports priority<=err logs from journald. Read-only; makes no changes.
# USAGE    : ./journal_errors.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Recent error-level journal entries.  ($(hostname) $(ts))"
command -v journalctl >/dev/null && journalctl -p err -n 50 --no-pager || tail -n 50 /var/log/syslog 2>/dev/null
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
