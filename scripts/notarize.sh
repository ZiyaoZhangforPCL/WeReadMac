#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   APPLE_ID="you@example.com" \
#   TEAM_ID="ABCDE12345" \
#   APP_SPECIFIC_PASSWORD="xxxx-xxxx-xxxx-xxxx" \
#   ./scripts/notarize.sh dist/WeReadMac.dmg

ARTIFACT="${1:-dist/WeReadMac.dmg}"
APPLE_ID="${APPLE_ID:-}"
TEAM_ID="${TEAM_ID:-}"
APP_SPECIFIC_PASSWORD="${APP_SPECIFIC_PASSWORD:-}"

if [[ ! -f "$ARTIFACT" ]]; then
  echo "error: artifact not found: $ARTIFACT"
  exit 1
fi
if [[ -z "$APPLE_ID" || -z "$TEAM_ID" || -z "$APP_SPECIFIC_PASSWORD" ]]; then
  echo "error: set APPLE_ID, TEAM_ID and APP_SPECIFIC_PASSWORD"
  exit 1
fi
if ! command -v xcrun >/dev/null 2>&1; then
  echo "error: xcrun not found. Install full Xcode."
  exit 1
fi

xcrun notarytool submit "$ARTIFACT" \
  --apple-id "$APPLE_ID" \
  --team-id "$TEAM_ID" \
  --password "$APP_SPECIFIC_PASSWORD" \
  --wait

xcrun stapler staple "$ARTIFACT"
echo "Notarized and stapled: $ARTIFACT"
