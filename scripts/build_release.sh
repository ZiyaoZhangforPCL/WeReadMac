#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT="$ROOT_DIR/WeReadMac.xcodeproj"
SCHEME="WeReadMac"
CONFIGURATION="Release"
DERIVED_DATA="$ROOT_DIR/build/DerivedData"
EXPORT_PATH="$ROOT_DIR/dist"
if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "error: xcodebuild not found. Please install full Xcode."
  exit 1
fi
if ! xcodebuild -version >/dev/null 2>&1; then
  echo "error: xcodebuild is not usable. Run: sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"
  exit 1
fi
mkdir -p "$EXPORT_PATH"
xcodebuild -project "$PROJECT" -scheme "$SCHEME" -configuration "$CONFIGURATION" -derivedDataPath "$DERIVED_DATA" clean build
APP_PATH="$DERIVED_DATA/Build/Products/$CONFIGURATION/WeReadMac.app"
if [[ ! -d "$APP_PATH" ]]; then
  echo "error: app not found at $APP_PATH"
  exit 1
fi
rm -rf "$EXPORT_PATH/WeReadMac.app"
cp -R "$APP_PATH" "$EXPORT_PATH/WeReadMac.app"
echo "Built app: $EXPORT_PATH/WeReadMac.app"
