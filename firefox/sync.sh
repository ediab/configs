#!/bin/bash
# Sync Firefox profile configs into this repo.
# Run this to refresh the backup after making Firefox changes.

PROFILE="$HOME/Library/Application Support/Firefox/Profiles/iaqaaxy6.default-release"
DEST="$(cd "$(dirname "$0")" && pwd)"

if [ ! -d "$PROFILE" ]; then
    echo "Profile not found: $PROFILE"
    exit 1
fi

# Core configs
cp "$PROFILE/prefs.js"              "$DEST/"
cp "$PROFILE/extensions.json"       "$DEST/"
cp "$PROFILE/extension-preferences.json" "$DEST/"
cp "$PROFILE/extension-settings.json"    "$DEST/"
cp "$PROFILE/containers.json"       "$DEST/"
cp "$PROFILE/handlers.json"         "$DEST/"
cp "$PROFILE/search.json.mozlz4"    "$DEST/"

# Chrome CSS and theme
cp "$PROFILE/chrome/userChrome.css"   "$DEST/chrome/"
cp "$PROFILE/chrome/userContent.css"  "$DEST/chrome/"
rsync -a --delete "$PROFILE/chrome/theme/" "$DEST/chrome/theme/"

# Bookmark backups
rsync -a --delete "$PROFILE/bookmarkbackups/" "$DEST/bookmarkbackups/"

echo "Firefox configs synced."
