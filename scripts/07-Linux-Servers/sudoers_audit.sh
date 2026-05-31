#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# sudoers_audit.sh
# SYNOPSIS : Sudoers configuration (read-only).
# DESCRIPTION: Shows sudo rules for privilege review. Read-only; makes no changes.
# USAGE    : ./sudoers_audit.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Sudoers configuration (read-only).  ($(hostname) $(ts))"
echo "== /etc/sudoers (non-comment) =="; grep -vE "^\s*#|^\s*$" /etc/sudoers 2>/dev/null; echo; echo "== /etc/sudoers.d =="; for f in /etc/sudoers.d/*; do [ -f "$f" ] && echo "-- $f --" && grep -vE "^\s*#|^\s*$" "$f" 2>/dev/null; done
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
