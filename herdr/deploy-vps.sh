#!/bin/bash
# Deploy the VPS Herdr config from this repo to `ssh vps` and reload it there.
#
# Unlike the Mac, the VPS config is not symlinked: nothing on the VPS reads this
# repo, so run this after editing herdr/config.vps.toml.
#
#   HERDR_VPS_HOST=<ssh-alias>   override the target host (default: vps)

set -euo pipefail

HOST="${HERDR_VPS_HOST:-vps}"
SRC="$(cd "$(dirname "$0")" && pwd)/config.vps.toml"

if [ ! -f "$SRC" ]; then
    echo "Not found: $SRC" >&2
    exit 1
fi

scp -q "$SRC" "$HOST:~/.config/herdr/config.toml"
echo "Copied config.vps.toml to $HOST:~/.config/herdr/config.toml"

# Apply it to the running server. The JSON response carries any diagnostics.
ssh "$HOST" 'herdr server reload-config'
echo ""
echo "Reload requested on $HOST."
