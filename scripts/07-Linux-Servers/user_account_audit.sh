#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# user_account_audit.sh
# SYNOPSIS : Local users, UID 0 accounts and sudo group.
# DESCRIPTION: Audits accounts and privilege for review. Read-only; makes no changes.
# USAGE    : ./user_account_audit.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Local users, UID 0 accounts and sudo group.  ($(hostname) $(ts))"
echo '== UID 0 (root-equivalent) =='
awk -F: '$3==0{print $1}' /etc/passwd
echo
echo '== login-capable users (uid 1000-65533) =='
awk -F: '$3>=1000 && $3<65534{print $1" (uid "$3")"}' /etc/passwd
echo
echo '== sudo / wheel group =='
getent group sudo wheel 2>/dev/null
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
