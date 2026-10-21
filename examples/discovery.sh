#!/usr/bin/env bash
# Walks Paceva's OAuth discovery the way an MCP client does. No account needed.
set -euo pipefail
BASE="${BASE:-https://paceva.app}"

echo "1. Unauthenticated MCP call -> 401 with a pointer to the metadata"
curl -s -D - -o /dev/null -X POST "$BASE/api/mcp" \
  -H 'content-type: application/json' -d '{}' | grep -i '^www-authenticate'

echo; echo "2. Protected resource metadata"
curl -s "$BASE/.well-known/oauth-protected-resource/api/mcp"; echo

echo; echo "3. Authorization server metadata"
curl -s "$BASE/.well-known/oauth-authorization-server"; echo
