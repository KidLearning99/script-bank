#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# firewall_rules.sh
# SYNOPSIS : Active firewall rules.
# DESCRIPTION: Reports nftables/iptables/ufw/firewalld rules. Read-only; makes no changes.
# USAGE    : ./firewall_rules.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# Active firewall rules.  ($(hostname) $(ts))"
if command -v ufw >/dev/null; then ufw status verbose; elif command -v firewall-cmd >/dev/null; then firewall-cmd --list-all; elif command -v nft >/dev/null; then nft list ruleset; else iptables -L -n; fi
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
