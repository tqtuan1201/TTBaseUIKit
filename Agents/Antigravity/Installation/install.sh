#!/bin/bash
#============================================================
# Antigravity TTBaseUIKit Skills — Installation Script
#============================================================
# Installs all Antigravity skills to ~/.cursor/skills/
# Run from the Installation folder:
#   cd Antigravity/Installation
#   bash install.sh
#============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$HOME/.cursor/skills"

echo "========================================"
echo "  Antigravity Skills — Installer"
echo "  Version 2.0.0"
echo "========================================"
echo ""
echo "Installation folder: $SCRIPT_DIR"
echo "Destination:         $SKILLS_DIR"
echo ""

# Check archive exists
if [[ ! -f "$SCRIPT_DIR/antigravity-skills.tar.gz" ]]; then
    echo "ERROR: antigravity-skills.tar.gz not found in $SCRIPT_DIR"
    echo "Make sure you run this script from the Installation folder."
    echo ""
    echo "If you modified skill files, regenerate the archive first:"
    echo "  cd path/to/TTBaseUIKit"
    echo "  bash Agents/Antigravity/export.sh"
    exit 1
fi

# Create skills directory if needed
mkdir -p "$SKILLS_DIR"

# Extract the archive
echo "Extracting skills archive..."
tar -xzf "$SCRIPT_DIR/antigravity-skills.tar.gz" -C "$SCRIPT_DIR/"

EXTRACTED_DIR="$SCRIPT_DIR/antigravity-export-tmp"

if [[ ! -d "$EXTRACTED_DIR" ]]; then
    echo "ERROR: Failed to extract archive."
    exit 1
fi

echo "Installing skill sets..."
echo ""

# Skill directories to install
SKILLS=(
    "ttb-skill-init"
    "ttb-skill-uikit"
    "ttb-skill-swiftui"
    "ttb-skill-native-swiftui-components"
    "ttb-skill-bugfix"
    "ttb-skill-refactor"
    "ttb-skill-audit"
    "ttb-skill-shared"
)

for skill in "${SKILLS[@]}"; do
    src="$EXTRACTED_DIR/$skill"
    dst="$SKILLS_DIR/$skill"
    if [[ -d "$src" ]]; then
        rm -rf "$dst"
        cp -R "$src" "$SKILLS_DIR/"
        echo "  [OK] $skill"
    else
        echo "  [SKIP] $skill (not found)"
    fi
done

# Copy root files as standalone skill documents
echo ""
echo "Installing root files..."
echo ""

for file in "SKILL.md" "README.md" "README-VI.md" "VERSION.md" "Tutorial.md" "Tutorial-vi.md"; do
    src="$EXTRACTED_DIR/$file"
    dst="$SKILLS_DIR/antigravity-$file"
    if [[ -f "$src" ]]; then
        cp "$src" "$dst"
        echo "  [OK] antigravity-$file"
    fi
done

# Cleanup extracted folder
rm -rf "$EXTRACTED_DIR"

echo ""
echo "========================================"
echo "  Installation Complete!"
echo "========================================"
echo ""
echo "Installed skills:"
for skill in "${SKILLS[@]}"; do
    echo "  - ~/.cursor/skills/$skill"
done
echo "  - ~/.cursor/skills/antigravity-SKILL.md"
echo "  - ~/.cursor/skills/antigravity-README.md"
echo "  - ~/.cursor/skills/antigravity-README-VI.md"
echo "  - ~/.cursor/skills/antigravity-VERSION.md"
echo "  - ~/.cursor/skills/antigravity-Tutorial.md"
echo "  - ~/.cursor/skills/antigravity-Tutorial-vi.md"
echo ""
echo "Total: $(( ${#SKILLS[@]} + 6 )) skill sets"
echo ""
echo "Next step: Restart Cursor (Cmd+Q) or click"
echo "the refresh button in Cursor Settings > Skills"
echo "to activate the new skills."
echo ""
echo "v2.0.0 — 11 Iron Laws, SUIBaseView + TTBaseNavigationLink"
