#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

fail=0
check_file() {
  if [[ -e "$1" ]]; then
    echo "OK   $1"
  else
    echo "MISS $1"
    fail=1
  fi
}

check_contains() {
  local file="$1"
  local text="$2"
  if grep -q "$text" "$file"; then
    echo "OK   $file contains: $text"
  else
    echo "MISS $file contains: $text"
    fail=1
  fi
}

check_file Package.swift
check_file WeReadMac.xcodeproj/project.pbxproj
check_file WeReadMac.xcodeproj/xcshareddata/xcschemes/WeReadMac.xcscheme
check_file WeReadMac/Info.plist
check_file WeReadMac/WeReadMac.entitlements
check_file WeReadMac/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json
check_file scripts/build_release.sh
check_file scripts/make_dmg.sh

plutil -lint WeReadMac/Info.plist
plutil -lint WeReadMac/WeReadMac.entitlements
plutil -lint WeReadMac/Config/ExportOptions.plist

check_contains WeReadMac.xcodeproj/project.pbxproj "PRODUCT_BUNDLE_IDENTIFIER ="
check_contains WeReadMac.xcodeproj/project.pbxproj "CODE_SIGN_ENTITLEMENTS = WeReadMac/WeReadMac.entitlements"
check_contains WeReadMac.xcodeproj/project.pbxproj "ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon"

icon_count=$(find WeReadMac/Resources/Assets.xcassets/AppIcon.appiconset -name '*.png' | wc -l | tr -d ' ')
if [[ "$icon_count" == "10" ]]; then
  echo "OK   AppIcon png count = 10"
else
  echo "MISS AppIcon png count expected 10, got $icon_count"
  fail=1
fi

swift build

exit "$fail"
