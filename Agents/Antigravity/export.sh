#!/bin/bash
#============================================================
# Antigravity TTBaseUIKit Skills — Export Script
#============================================================
# Exports Antigravity skills into portable .tar.gz archives
# for Cursor, Claude Code, and Codex.
#
# Creates:
#   Installation/antigravity-skills.tar.gz            (Cursor)
#   Installation/ClaudeCode/antigravity-claude-code-skills.tar.gz  (Claude Code)
#   Installation/Codex/antigravity-codex-skills.tar.gz            (Codex)
#
# Usage:
#   bash Agents/Antigravity/export.sh
#============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR"           # Antigravity root — source of all skill content
INSTALL_DIR="$SCRIPT_DIR/Installation"
CLAUDECODE_DIR="$SCRIPT_DIR/Installation/ClaudeCode"
CODEX_DIR="$SCRIPT_DIR/Installation/Codex"
TMP_DIR="$SCRIPT_DIR/../antigravity-export-tmp"

echo "========================================"
echo "  Antigravity Skills — Exporter"
echo "  Version 2.0.0"
echo "========================================"
echo ""
echo "Source:      $SRC_DIR"
echo "Destination: $INSTALL_DIR"
echo "             $CLAUDECODE_DIR"
echo "             $CODEX_DIR"
echo ""

# Skill directories to export
SKILLS=(
    "ttb-skill-init"
    "ttb-skill-uikit"
    "ttb-skill-swiftui"
    "ttb-skill-native-swiftui-components"
    "ttb-skill-bugfix"
    "ttb-skill-refactor"
    "ttb-skill-audit"
    "ttb-skill-shared"      # includes: scripts/, fragments/, templates/, phases/, refs/, ttb-skill-registry.md
)

# Root markdown files to export
ROOT_FILES=(
    "SKILL.md"
    "README.md"
    "README-VI.md"
    "VERSION.md"
    "Tutorial.md"
    "Tutorial-vi.md"
)

# Clean up previous exports
rm -rf "$TMP_DIR"
rm -f "$INSTALL_DIR/antigravity-skills.tar.gz"
rm -f "$CLAUDECODE_DIR/antigravity-claude-code-skills.tar.gz"
rm -f "$CODEX_DIR/antigravity-codex-skills.tar.gz"

#-----------------------------------
# Build staging directory
#-----------------------------------
mkdir -p "$TMP_DIR"

for skill in "${SKILLS[@]}"; do
    src="$SRC_DIR/$skill"
    dst="$TMP_DIR/$skill"
    if [[ -d "$src" ]]; then
        cp -R "$src" "$dst"
    fi
done

for file in "${ROOT_FILES[@]}"; do
    src="$SRC_DIR/$file"
    if [[ -f "$src" ]]; then
        cp "$src" "$TMP_DIR/"
    fi
done

#-----------------------------------
# Package 1: Cursor
#-----------------------------------
echo ""
echo "Creating Cursor package..."
CURSOR_ARCHIVE="$INSTALL_DIR/antigravity-skills.tar.gz"
tar -czf "$CURSOR_ARCHIVE" -C "$TMP_DIR/.." "antigravity-export-tmp"
echo "  [OK] antigravity-skills.tar.gz"

#-----------------------------------
# Package 2: Claude Code
#-----------------------------------
echo "Creating Claude Code package..."
CC_ARCHIVE="$CLAUDECODE_DIR/antigravity-claude-code-skills.tar.gz"
tar -czf "$CC_ARCHIVE" -C "$TMP_DIR/.." "antigravity-export-tmp"
echo "  [OK] antigravity-claude-code-skills.tar.gz"

#-----------------------------------
# Package 3: Codex
#-----------------------------------
echo "Creating Codex package..."
CODEX_ARCHIVE="$CODEX_DIR/antigravity-codex-skills.tar.gz"
tar -czf "$CODEX_ARCHIVE" -C "$TMP_DIR/.." "antigravity-export-tmp"
echo "  [OK] antigravity-codex-skills.tar.gz"

# Cleanup
rm -rf "$TMP_DIR"

#-----------------------------------
# Summary
#-----------------------------------
SIZE1=$(du -h "$CURSOR_ARCHIVE" | cut -f1)
SIZE2=$(du -h "$CC_ARCHIVE" | cut -f1)
SIZE3=$(du -h "$CODEX_ARCHIVE" | cut -f1)

echo ""
echo "========================================"
echo "  Export Complete!"
echo "  Version 2.0.0"
echo "========================================"
echo ""
echo "Cursor package:"
echo "  $CURSOR_ARCHIVE  ($SIZE1)"
echo ""
echo "Claude Code package:"
echo "  $CC_ARCHIVE  ($SIZE2)"
echo ""
echo "Codex package:"
echo "  $CODEX_ARCHIVE  ($SIZE3)"
echo ""
echo "v2.0.0 — 11 Iron Laws, SUIBaseView + TTBaseNavigationLink, navigation ref,"
echo "         token warnings, three-tier SwiftUI, FCR 7-Dimension, tutorials"
echo ""
echo "To install:"
echo ""
echo "  CURSOR:"
echo "    cd Installation"
echo "    bash install.sh"
echo "    (skills -> ~/.cursor/skills/)"
echo ""
echo "  CLAUDE CODE:"
echo "    cd Installation/ClaudeCode"
echo "    bash install.sh"
echo "    (skills -> ~/.claude/skills/)"
echo ""
echo "  CODEX:"
echo "    cd Installation/Codex"
echo "    bash install.sh"
echo "    (skills -> ~/.agents/skills/)"
echo ""
