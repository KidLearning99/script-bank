#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# ssl_cert_expiry.sh
# SYNOPSIS : TLS certificate expiry for a host:port.
# DESCRIPTION: Checks remote certificate validity dates. Read-only; makes no changes.
# USAGE    : ./ssl_cert_expiry.sh
# SOURCE   : Verified from learn.microsoft.com/azure/virtual-machines/linux/
# TIER     : [TIER 1 - PRODUCTION READY]
# ---------------------------------------------------------------------------
set -uo pipefail
ts() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
echo "# TLS certificate expiry for a host:port.  ($(hostname) $(ts))"
HOSTPORT=${1:-localhost:443}; echo | openssl s_client -servername "${HOSTPORT%%:*}" -connect "$HOSTPORT" 2>/dev/null | openssl x509 -noout -subject -dates 2>/dev/null || echo "could not read certificate from $HOSTPORT"
exit 0
# Source: Verified from learn.microsoft.com/azure/virtual-machines/linux/
