#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# open_ports_report.sh
# SYNOPSIS : Listening TCP/UDP ports and processes.
# DESCRIPTION: Reports listening sockets for audit. Read-only; makes no changes.
# USAGE    : ./open_ports_report.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Listening TCP/UDP ports and processes.  ($(hostname) $(ts))"
(ss -tulnp 2>/dev/null || netstat -tulnp 2>/dev/null) | head -50
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
