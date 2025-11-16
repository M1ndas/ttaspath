#!/usr/bin/env bash
set -euo pipefail

d="${1:-}"
p="${2:-443}"

if [[ -z "$d" ]]; then
  echo "Usage: $0 <domain or ip> [port]" >&2
  exit 1
fi

# Ensure required commands exist
for cmd in traceroute awk whois; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "Error: required command not found: $cmd" >&2
    exit 2
  }
done

# Run TCP traceroute to 443, extract the first IPv4 per hop, query Team Cymru whois
echo -e "Running with params $d and $p \n" >&2

i=0 
traceroute -Tn -p $p "$d" \
| awk '/^[[:space:]]*[0-9]+[[:space:]]/ { for (i=2; i<=NF; i++) if ($i ~ /^[0-9.]+$/) { print $i; break } }' \
| while read -r ip; do
    whois -h whois.cymru.com -p 43 "$ip" | awk -v i="$i" 'NR>1 { print ++i, "|", $0 }'
    i=$((i+1))
  done
