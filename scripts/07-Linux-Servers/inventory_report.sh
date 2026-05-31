#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# inventory_report.sh
# SYNOPSIS : Host inventory (OS, CPU, memory, disk, net).
# DESCRIPTION: Read-only host inventory snapshot. Read-only; makes no changes.
# USAGE    : ./inventory_report.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Host inventory (OS, CPU, memory, disk, net).  ($(hostname) $(ts))"
uname -a; (grep PRETTY_NAME /etc/os-release 2>/dev/null); nproc; free -h; df -hP; (ip -brief addr 2>/dev/null || ifconfig -a)
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
