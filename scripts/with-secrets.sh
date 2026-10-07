#!/usr/bin/env bash
# Run one command with Grocerra secrets from the Reevake vault loaded into its environment.
# Usage: scripts/with-secrets.sh NAME [NAME...] -- command [args...]
# Needs REEVAKE_BASE_URL and REEVAKE_AGENT_TOKEN in your environment (never in this repo). See SETUP.md §5.
set -euo pipefail
PROJECT_ID=a3b6b642-dcf7-4fee-a932-99340afdb790
: "${REEVAKE_BASE_URL:?Set REEVAKE_BASE_URL (see SETUP.md)}"
: "${REEVAKE_AGENT_TOKEN:?Set REEVAKE_AGENT_TOKEN (see SETUP.md)}"

usage() { echo "Usage: $0 NAME [NAME...] -- command [args...]" >&2; exit 2; }
names=()
while [ $# -gt 0 ] && [ "$1" != "--" ]; do
  [[ "$1" =~ ^[A-Z][A-Z0-9_]{1,79}$ ]] || { echo "Invalid secret name: $1" >&2; exit 2; }
  names+=("\"$1\""); shift
done
[ "${1:-}" = "--" ] || usage
shift
[ ${#names[@]} -gt 0 ] && [ $# -gt 0 ] || usage

body=$(IFS=,; printf '{"projectId":"%s","names":[%s],"format":"shell"}' "$PROJECT_ID" "${names[*]}")
# The token goes through stdin-fed headers so it never shows up in the process list.
exports=$(printf 'Authorization: Bearer %s\nContent-Type: application/json\n' "$REEVAKE_AGENT_TOKEN" |
  curl -fsS -X POST "$REEVAKE_BASE_URL/api/agent/secrets" -H @- -d "$body")
eval "$exports"
unset exports body REEVAKE_AGENT_TOKEN
exec "$@"
