#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# failed_login_report.sh
# SYNOPSIS : Recent failed SSH login attempts.
# DESCRIPTION: Reports failed auth attempts for security review. Read-only; makes no changes.
# USAGE    : ./failed_login_report.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Recent failed SSH login attempts.  ($(hostname) $(ts))"
echo "== failed logins =="; (lastb -n 30 2>/dev/null) || (grep -i "failed password" /var/log/auth.log 2>/dev/null | tail -30) || (grep -i "failed password" /var/log/secure 2>/dev/null | tail -30) || echo "no readable auth log"
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
