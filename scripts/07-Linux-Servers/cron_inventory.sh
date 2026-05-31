#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# cron_inventory.sh
# SYNOPSIS : System and per-user cron jobs.
# DESCRIPTION: Inventories scheduled cron tasks. Read-only; makes no changes.
# USAGE    : ./cron_inventory.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# System and per-user cron jobs.  ($(hostname) $(ts))"
echo "== /etc/crontab =="; cat /etc/crontab 2>/dev/null; echo; echo "== /etc/cron.d =="; ls -1 /etc/cron.d 2>/dev/null; echo; echo "== user crontabs =="; for u in $(cut -f1 -d: /etc/passwd); do c=$(crontab -l -u "$u" 2>/dev/null); [ -n "$c" ] && echo "-- $u --" && echo "$c"; done
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
