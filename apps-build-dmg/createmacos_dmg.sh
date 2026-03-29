#!/bin/bash

# Move to the directory where this script is located
cd "$(dirname "$0")"

# --- CONFIGURATION ---
APP_NAME="TTBDebugPlus"
# Check if your app is inside a 'macos' folder or directly in the current folder
APP_FILE="macos/TTBDebugPlus.app" 
DMG_NAME="TTBDebugPlus-Installer.dmg"
VOL_NAME="TTBDebugPlus — Smart debugs"
README_FILE="README.txt"
HELP_URL="https://tqtuan1201.github.io/public/docs/ttbaseuikit/"
BACKGROUND_IMG="installer_background.png"
STAGING_DIR="./dist"

echo "---------------------------------------------------"
echo "🚀 Starting Professional DMG Build Process..."
echo "---------------------------------------------------"

# 1. Validation: Check for app and background
if [ ! -d "$APP_FILE" ] || [ ! -f "$BACKGROUND_IMG" ]; then
    echo "❌ ERROR: Missing '$APP_FILE' or '$BACKGROUND_IMG'!"
    echo "👉 Ensure your .app is inside the 'macos' folder and the image is next to this script."
    exit 1
fi

# 2. Install dependencies
if ! command -v create-dmg &> /dev/null; then
    echo "📦 Installing 'create-dmg' via Homebrew..."
    brew install create-dmg
fi

# 3. Prepare staging area
echo "🧹 Cleaning and preparing staging area..."
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"

# Copy the app into the staging folder
cp -R "$APP_FILE" "$STAGING_DIR/"

# Create the README.txt inside the staging folder (FIXED PATH)
echo -e "--- TTBaseDebug Plus ---\n\nINSTALLATION:\n1. Drag the '$APP_NAME' icon into the 'Applications' folder shortcut.\n2. Open your Applications folder and launch the app.\n\nDOCUMENTATION & SUPPORT:\n$HELP_URL" > "$STAGING_DIR/$README_FILE"

# 4. Create the DMG
echo "📦 Packaging DMG..."

create-dmg \
  --volname "$VOL_NAME" \
  --background "$BACKGROUND_IMG" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 120 \
  --icon "$APP_NAME.app" 200 220 \
  --app-drop-link 600 220 \
  --icon "$README_FILE" 400 310 \
  --hide-extension "$APP_NAME.app" \
  --hdiutil-quiet \
  "$DMG_NAME" \
  "$STAGING_DIR/"

# 5. Final Cleanup
rm -rf "$STAGING_DIR"

echo "---------------------------------------------------"
echo "✅ SUCCESS! $DMG_NAME is ready."
open .