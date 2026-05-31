#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# network_interfaces.sh
# SYNOPSIS : Interfaces, routes and DNS config.
# DESCRIPTION: Reports network configuration read-only. Read-only; makes no changes.
# USAGE    : ./network_interfaces.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Interfaces, routes and DNS config.  ($(hostname) $(ts))"
(ip -brief addr 2>/dev/null || ifconfig -a); echo; echo "== routes =="; (ip route 2>/dev/null || route -n); echo; echo "== resolv.conf =="; cat /etc/resolv.conf 2>/dev/null
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
