#!/usr/bin/env bash
# vps-cleanup.sh — bounded weekly disk upkeep for the VPS.
#
#   vps-cleanup.sh            reclaim
#   vps-cleanup.sh --dry-run  print what would happen, change nothing
#
# Run by vps-cleanup.timer (Sunday 04:30, persistent) as `diab`. Deployed from the
# configs repo — edit there, not on the VPS.
#
# What it reclaims:
#   * Docker build cache, trimmed to CACHE_CEILING (default 3GB) — never wiped: the app
#     stacks rebuild locally on every push (mp3podcasts, redact_pdf, cratch/ai-cookbook,
#     onyx, greek_embassy_bot), so a cold cache makes every deploy slow.
#   * Images no container uses (running or stopped), except the protected build bases
#     below: greek_embassy_bot is built FROM the Playwright image and re-pulling it costs
#     ~3.4GB, so it is kept even with no container attached to it.
#   * Superseded GitHub runner versions and its downloaded update tarballs, the npm cache,
#     apt cache and autoremovable packages, and a journal cap.
#
# Never touched: ~/apps contents, Docker volumes, running containers, ~/.pi, node_modules,
# /swapfile. Idempotent — a second run reports nothing to do.

set -uo pipefail

DRY_RUN=0
[ "${1:-}" = "--dry-run" ] && DRY_RUN=1

CACHE_CEILING="${CACHE_CEILING:-3GB}"
JOURNAL_CEILING="${JOURNAL_CEILING:-200M}"
LOG_DIR="$HOME/logs"
LOG="$LOG_DIR/vps-cleanup.log"
RUNNER_DIR="$HOME/actions-runner"

# Build bases to keep even when no container is attached. Keep this list short and explain
# each entry, or images people rely on will silently vanish.
PROTECTED_RE='^(mcr\.microsoft\.com/playwright|node|alpine|ubuntu|debian|buildpack-deps)'

exec > >(tee -a "$LOG") 2>&1
mkdir -p "$LOG_DIR"

echo "=== vps-cleanup $(date -Is) dry_run=$DRY_RUN ==="
df -h / | tail -1

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  [dry-run] $*"
  else
    "$@"
  fi
}

# --- Docker: build cache, then images nothing uses -----------------------------------
if command -v docker >/dev/null 2>&1; then
  echo "--- docker build cache (ceiling $CACHE_CEILING) ---"
  run docker builder prune -f --keep-storage "$CACHE_CEILING"

  echo "--- docker images not used by any container ---"
  # Resolve in-use images to IDs so a container started from a tag is still counted.
  # Both sides must be FULL ids: `docker images` prints 12-char ids by default while
  # `docker inspect` prints sha256:..., so compare with --no-trunc or every image looks
  # unused.
  in_use="$(docker ps -aq | xargs -r docker inspect --format '{{.Image}}' 2>/dev/null | sort -u)"
  echo "  in-use image ids: $(printf '%s\n' "$in_use" | grep -c .)"
  while read -r id ref; do
    [ -n "${id:-}" ] || continue
    if printf '%s\n' "$in_use" | grep -qxF "$id"; then
      continue
    fi
    # ref may carry several tags; protect if any of them is a known build base.
    if printf '%s\n' "$ref" | grep -qE "$PROTECTED_RE"; then
      echo "  protected: $ref"
      continue
    fi
    echo "  removing: $ref"
    run docker rmi "$id"
  done < <(docker images --no-trunc --format '{{.ID}} {{.Repository}}:{{.Tag}}' | sort -u)
else
  echo "--- docker not present, skipping ---"
fi

# --- GitHub runner: superseded versions and update tarballs ---------------------------
if [ -d "$RUNNER_DIR" ]; then
  echo "--- runner caches ---"
  # Keep the newest bin.<version>; the live service runs whatever runsvc.sh resolves to.
  ls -d "$RUNNER_DIR"/bin.* 2>/dev/null | sort -V | head -n -1 | while read -r old; do
    echo "  removing: $old"
    run rm -rf "$old"
  done
  if [ -d "$HOME/actions-runner-work/_update" ]; then
    echo "  removing: runner update tarballs"
    run rm -rf "$HOME/actions-runner-work/_update"
  fi
fi

# --- package and language caches -----------------------------------------------------
echo "--- caches ---"
if command -v npm >/dev/null 2>&1; then
  run npm cache clean --force
fi
if sudo -n true 2>/dev/null; then
  run sudo -n apt-get clean
  run sudo -n apt-get -y autoremove --purge
  run sudo -n journalctl --vacuum-size="$JOURNAL_CEILING"
else
  echo "  skipping apt/journal: passwordless sudo unavailable"
fi

echo "--- result ---"
df -h / | tail -1
docker system df 2>/dev/null | head -3
echo "=== done ==="
