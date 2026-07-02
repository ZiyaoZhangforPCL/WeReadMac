#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="$ROOT_DIR/dist"
APP="$DIST/WeReadMac.app"
DMG="$DIST/WeReadMac.dmg"
VOL="WeReadMac"
if [[ ! -d "$APP" ]]; then
  echo "error: $APP not found. Run scripts/build_release.sh first."
  exit 1
fi
rm -f "$DMG"
hdiutil create -volname "$VOL" -srcfolder "$APP" -ov -format UDZO "$DMG"
echo "Created dmg: $DMG"
