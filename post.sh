#!/usr/bin/env bash
set -e
set -u
set -o pipefail

lines_file="$1"
host="$2"
auth="$3"

line="$(shuf --head-count=1 "$lines_file")"

python='
import json
from sys import argv

print(json.dumps({
    "status": argv[1],
    "language": "en",
    "visibility": "public"
}, separators=(",", ":")))
'
data="$(python3 -c "$python" "$line")"

curl \
  -H "Authorization: Bearer $auth" \
  -H 'Content-Type: application/json' \
  --data "$data" \
  "https://$host/api/v1/statuses"
