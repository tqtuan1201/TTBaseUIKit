#!/bin/bash
#============================================================
# Antigravity TTBaseUIKit Skills — Codex Installer
#============================================================
# Installs all Antigravity skills to ~/.agents/skills/
#
# Codex USER skills location: $HOME/.agents/skills
# Codex reads SKILL.md files inside each skill folder.
#
# Run from the Codex folder:
#   cd Installation/Codex
#   bash install.sh
#
# Reference: https://developers.openai.com/codex/skills
#============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$HOME/.agents/skills"
EXTRACTED_DIR="$SCRIPT_DIR/antigravity-export-tmp"

cleanup() {
    rm -rf "$EXTRACTED_DIR"
}
trap cleanup EXIT

echo "========================================"
echo "  Antigravity Skills — Codex Installer"
echo "  Version 2.3.0"
echo "========================================"
echo ""
echo "Installation folder: $SCRIPT_DIR"
echo "Destination:         $SKILLS_DIR"
echo ""

# Check archive exists
if [[ ! -f "$SCRIPT_DIR/antigravity-codex-skills.tar.gz" ]]; then
    echo "ERROR: antigravity-codex-skills.tar.gz not found"
    echo "Make sure you run this script from the Codex folder."
    echo ""
    echo "If you modified skill files, regenerate the archive first:"
    echo "  cd path/to/TTBaseUIKit"
    echo "  bash Agents/Antigravity/export.sh"
    exit 1
fi

# Create skills directory if needed
mkdir -p "$SKILLS_DIR"

if [[ ! -w "$SKILLS_DIR" ]]; then
    echo "ERROR: Destination is not writable: $SKILLS_DIR"
    echo ""
    echo "Fix ownership, then re-run installer:"
    echo "  sudo chown -R \"$USER\":staff \"$HOME/.agents\""
    echo "  bash \"$SCRIPT_DIR/install.sh\""
    exit 1
fi

# Extract the archive
echo "Extracting skills archive..."
tar -xzf "$SCRIPT_DIR/antigravity-codex-skills.tar.gz" -C "$SCRIPT_DIR/"

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
        echo "  [SKIP] $skill (not found in archive)"
    fi
done

# Copy root documentation as standalone Codex skills
# Codex expects SKILL.md with YAML frontmatter in each folder
echo ""
echo "Installing root documentation as Codex skills..."
echo ""

for file in "SKILL.md" "README.md" "README-VI.md" "VERSION.md" "Tutorial.md" "Tutorial-vi.md"; do
    src="$EXTRACTED_DIR/$file"
    dst="$SKILLS_DIR/antigravity-$file"
    if [[ -f "$src" ]]; then
        # Convert root docs to Codex-compatible format: folder + SKILL.md
        skill_name="antigravity-$file"
        skill_dir="$SKILLS_DIR/$skill_name"
        mkdir -p "$skill_dir"

        # For markdown files without frontmatter, prepend YAML frontmatter
        if [[ "$file" == "SKILL.md" || "$file" == "README.md" || "$file" == "README-VI.md" || "$file" == "VERSION.md" || "$file" == "Tutorial.md" || "$file" == "Tutorial-vi.md" ]]; then
            # Check if frontmatter already exists
            if head -n 1 "$src" | grep -q "^---"; then
                # Has frontmatter — copy as-is
                cp "$src" "$skill_dir/SKILL.md"
            else
                # No frontmatter — add Codex-compatible frontmatter
                {
                    echo "---"
                    echo "name: $skill_name"
                    case "$file" in
                        "SKILL.md")
                            echo "description: Antigravity TTBaseUIKit root skill. Triggered when user asks about Antigravity overview, commands, or 11 Iron Laws."
                            ;;
                        "README.md")
                            echo "description: Antigravity TTBaseUIKit overview and quick reference. English version."
                            ;;
                        "README-VI.md")
                            echo "description: Antigravity TTBaseUIKit overview and quick reference. Vietnamese version."
                            ;;
                        "VERSION.md")
                            echo "description: Antigravity TTBaseUIKit version history and changelog."
                            ;;
                        "Tutorial.md")
                            echo "description: Antigravity tutorial — when to use each skill, prompt examples, practical guide. English version."
                            ;;
                        "Tutorial-vi.md")
                            echo "description: Antigravity tutorial — when to use each skill, prompt examples, practical guide. Vietnamese version."
                            ;;
                    esac
                    echo "version: \"2.3.0\""
                    echo "---"
                    echo ""
                    cat "$src"
                } > "$skill_dir/SKILL.md"
            fi
        else
            cp "$src" "$skill_dir/SKILL.md"
        fi

        echo "  [OK] $skill_name"
    else
        echo "  [SKIP] antigravity-$file (not found in archive)"
    fi
done

echo ""
echo "========================================"
echo "  Installation Complete!"
echo "========================================"
echo ""
echo "Installed skills:"
for skill in "${SKILLS[@]}"; do
    echo "  - ~/.agents/skills/$skill/"
done
echo "  - ~/.agents/skills/antigravity-SKILL.md/"
echo "  - ~/.agents/skills/antigravity-README.md/"
echo "  - ~/.agents/skills/antigravity-README-VI.md/"
echo "  - ~/.agents/skills/antigravity-VERSION.md/"
echo "  - ~/.agents/skills/antigravity-Tutorial.md/"
echo "  - ~/.agents/skills/antigravity-Tutorial-vi.md/"
echo ""
echo "Total: $(( ${#SKILLS[@]} + 6 )) skill sets"
echo ""
echo "Next step: Restart Codex or run"
echo "  ls ~/.agents/skills"
echo "to verify installation."
echo ""
echo "Codex reads skills from:"
echo "  - \$HOME/.agents/skills/  (USER level — this install)"
echo "  - .agents/skills/        (REPO level)"
echo "  - /etc/codex/skills/      (ADMIN level)"
echo ""
echo "v2.3.0 — cross-functional analysis gate, value-expansion questions, ambiguity clarification gate"
