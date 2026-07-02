#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 com.example.WeReadMac"
  exit 1
fi
BUNDLE_ID="$1"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PBX="$ROOT_DIR/WeReadMac.xcodeproj/project.pbxproj"
python3 - "$PBX" "$BUNDLE_ID" <<'PY'
from pathlib import Path
import re, sys
path = Path(sys.argv[1])
bundle = sys.argv[2]
s = path.read_text()
s2 = re.sub(r'PRODUCT_BUNDLE_IDENTIFIER = [^;]+;', f'PRODUCT_BUNDLE_IDENTIFIER = {bundle};', s)
path.write_text(s2)
print(f'Updated bundle id to {bundle}')
PY
