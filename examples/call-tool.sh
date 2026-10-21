#!/usr/bin/env bash
# Calls one Paceva tool with an access token you already have
# (see docs/oauth.md for getting one). Usage:
#   TOKEN=... ./call-tool.sh get_today
#   TOKEN=... ./call-tool.sh get_trend '{"metric":"hrv","days":28}'
set -euo pipefail
BASE="${BASE:-https://paceva.app}"
TOOL="${1:-get_today}"
ARGS="${2:-{\}}"

curl -s -X POST "$BASE/api/mcp" \
  -H "authorization: Bearer $TOKEN" \
  -H 'content-type: application/json' \
  -H 'accept: application/json, text/event-stream' \
  -H 'mcp-protocol-version: 2025-06-18' \
  -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"tools/call\",\"params\":{\"name\":\"$TOOL\",\"arguments\":$ARGS}}"
echo
