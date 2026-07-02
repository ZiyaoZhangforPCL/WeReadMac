#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
APP_DIR="$ROOT_DIR/dist/WeReadMac.app"
CONTENTS="$APP_DIR/Contents"
MACOS="$CONTENTS/MacOS"
RESOURCES="$CONTENTS/Resources"

swift build -c release
BIN_PATH="$(swift build -c release --show-bin-path)/WeReadMac"
if [[ ! -x "$BIN_PATH" ]]; then
  echo "error: binary not found at $BIN_PATH"
  exit 1
fi

rm -rf "$APP_DIR"
mkdir -p "$MACOS" "$RESOURCES"
cp "$BIN_PATH" "$MACOS/WeReadMac"
cp WeReadMac/Info.plist "$CONTENTS/Info.plist"
cp -R WeReadMac/Resources/Assets.xcassets "$RESOURCES/Assets.xcassets"
if command -v iconutil >/dev/null 2>&1; then
  ICONSET="$ROOT_DIR/build/AppIcon.iconset"
  rm -rf "$ICONSET"
  mkdir -p "$ICONSET"
  cp WeReadMac/Resources/Assets.xcassets/AppIcon.appiconset/icon_16x16.png "$ICONSET/icon_16x16.png"
  cp WeReadMac/Resources/Assets.xcassets/AppIcon.appiconset/icon_16x16@2x.png "$ICONSET/icon_16x16@2x.png"
  cp WeReadMac/Resources/Assets.xcassets/AppIcon.appiconset/icon_32x32.png "$ICONSET/icon_32x32.png"
  cp WeReadMac/Resources/Assets.xcassets/AppIcon.appiconset/icon_32x32@2x.png "$ICONSET/icon_32x32@2x.png"
  cp WeReadMac/Resources/Assets.xcassets/AppIcon.appiconset/icon_128x128.png "$ICONSET/icon_128x128.png"
  cp WeReadMac/Resources/Assets.xcassets/AppIcon.appiconset/icon_128x128@2x.png "$ICONSET/icon_128x128@2x.png"
  cp WeReadMac/Resources/Assets.xcassets/AppIcon.appiconset/icon_256x256.png "$ICONSET/icon_256x256.png"
  cp WeReadMac/Resources/Assets.xcassets/AppIcon.appiconset/icon_256x256@2x.png "$ICONSET/icon_256x256@2x.png"
  cp WeReadMac/Resources/Assets.xcassets/AppIcon.appiconset/icon_512x512.png "$ICONSET/icon_512x512.png"
  cp WeReadMac/Resources/Assets.xcassets/AppIcon.appiconset/icon_512x512@2x.png "$ICONSET/icon_512x512@2x.png"
  iconutil -c icns "$ICONSET" -o "$RESOURCES/AppIcon.icns"
fi
python3 - "$CONTENTS/Info.plist" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1])
s=p.read_text()
for k,v in {
'$(DEVELOPMENT_LANGUAGE)':'en',
'$(EXECUTABLE_NAME)':'WeReadMac',
'$(PRODUCT_BUNDLE_IDENTIFIER)':'com.zhangzy.WeReadMac',
'$(PRODUCT_NAME)':'WeReadMac',
'$(MARKETING_VERSION)':'1.0.0',
'$(CURRENT_PROJECT_VERSION)':'1',
'$(MACOSX_DEPLOYMENT_TARGET)':'13.0',
}.items():
    s=s.replace(k,v)
s=s.replace('<key>CFBundleIconName</key>\n    <string>AppIcon</string>', '<key>CFBundleIconFile</key>\n    <string>AppIcon</string>\n    <key>CFBundleIconName</key>\n    <string>AppIcon</string>')
p.write_text(s)
PY

if command -v codesign >/dev/null 2>&1; then
  codesign --force --deep --sign - "$APP_DIR" >/dev/null 2>&1 || true
fi

echo "Packaged temporary app: $APP_DIR"
echo "Open it with: open '$APP_DIR'"
