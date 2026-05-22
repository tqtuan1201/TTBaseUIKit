#!/bin/bash
# Antigravity routing metadata validation.
#
# Usage:
#   bash ttb-skill-shared/scripts/ttb-routing-validate.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MANIFEST="$ROOT_DIR/ttb-skill-shared/routing/intent-manifest.json"
ALIASES="$ROOT_DIR/ttb-skill-shared/routing/multilingual-aliases.json"

fail() {
  echo "❌ $1"
  exit 1
}

pass() {
  echo "✅ $1"
}

if command -v python3 >/dev/null 2>&1; then
  python3 -m json.tool "$MANIFEST" >/dev/null || fail "Invalid JSON: $MANIFEST"
  python3 -m json.tool "$ALIASES" >/dev/null || fail "Invalid JSON: $ALIASES"
  pass "Routing JSON files are valid"
else
  echo "⚠️ python3 not found; skipping JSON syntax validation"
fi

for skill in "$ROOT_DIR"/ttb-skill-*/SKILL.md; do
  head -n 1 "$skill" | grep -q '^---$' || fail "Missing frontmatter: $skill"
  grep -q '^name:' "$skill" || fail "Missing name: $skill"
  grep -q '^description:' "$skill" || fail "Missing description: $skill"
  grep -q '^version:' "$skill" || fail "Missing version: $skill"
  grep -q '^date_updated:' "$skill" || fail "Missing date_updated: $skill"
  grep -q '^risk:' "$skill" || fail "Missing risk: $skill"
  grep -q '^source:' "$skill" || fail "Missing source: $skill"
  grep -q '^tags:' "$skill" || fail "Missing tags: $skill"
  grep -q '^loadLevel:' "$skill" || fail "Missing loadLevel: $skill"
  grep -q '^## Routing Contract' "$skill" || fail "Missing Routing Contract section: $skill"
done

pass "Core SKILL.md metadata is complete"

grep -q '"/tts-init": "/ttb-init"' "$MANIFEST" || fail "Legacy /tts-init alias missing"
grep -q '"id": "uikit_feature"' "$MANIFEST" || fail "UIKit intent missing"
grep -q '"id": "swiftui_feature"' "$MANIFEST" || fail "SwiftUI intent missing"
grep -q '"id": "bugfix"' "$MANIFEST" || fail "Bugfix intent missing"
grep -q '"tao api login"' "$ALIASES" || fail "Vietnamese API example missing"
grep -q '"generate auth api"' "$ALIASES" || fail "English API example missing"

pass "Routing aliases and required intents are present"
