#!/bin/bash
#============================================================
# Antigravity — Pre-Skill Prerequisite Checker
#============================================================
# Phase 0 (Pre-Check) for all TTBaseUIKit skill workflows.
# Validates that the project meets all prerequisites BEFORE
# any skill runs. This prevents confusing build failures.
#
# Usage:
#   bash ttb-skill-shared/scripts/ttb-precheck.sh [project_path]
#
# Defaults:
#   project_path: TTBaseUIKitExample/
#
# Exit codes:
#   0 = All prerequisites met, ready to run skills
#   1 = Missing prerequisites, skills will fail
#============================================================

set -e

PROJECT_PATH="${1:-TTBaseUIKitExample}"
SCHEME="${SCHEME:-TTBaseUIKitExample}"
MAX_ATTEMPTS=3

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "========================================"
echo "  Antigravity — ttb-precheck"
echo "========================================"
echo "  Project: $PROJECT_PATH"
echo "========================================"
echo ""

PASS_COUNT=0
FAIL_COUNT=0

#============================================================
# Helper function
#============================================================
check() {
    local label="$1"
    local condition="$2"
    local fix="$3"

    if eval "$condition"; then
        echo -e "  $label  ${GREEN}✅ PASS${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "  $label  ${RED}❌ FAIL${NC}"
        if [[ -n "$fix" ]]; then
            echo -e "        ${YELLOW}Fix: $fix${NC}"
        fi
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

#============================================================
# Check 1: TTBaseUIKit dependency
#============================================================
echo "── TTBaseUIKit Dependency ─────────────────────"

# Check SPM Package.swift
if [[ -f "$PROJECT_PATH/Package.swift" ]]; then
    if grep -q "TTBaseUIKit" "$PROJECT_PATH/Package.swift" 2>/dev/null; then
        check "SPM: TTBaseUIKit" "true"
    else
        check "SPM: TTBaseUIKit" "false" "Add TTBaseUIKit to Package.swift dependencies"
    fi
# Check CocoaPods
elif [[ -f "$PROJECT_PATH/Podfile" ]]; then
    if grep -q "TTBaseUIKit" "$PROJECT_PATH/Podfile" 2>/dev/null; then
        check "CocoaPods: TTBaseUIKit" "true"
    else
        check "CocoaPods: TTBaseUIKit" "false" "Add TTBaseUIKit to Podfile"
    fi
# Check local path reference
elif [[ -d "$PROJECT_PATH/../Sources/TTBaseUIKit" ]] || [[ -d "../TTBaseUIKit" ]]; then
    check "Local: TTBaseUIKit" "true"
else
    check "Dependency: TTBaseUIKit" "false" "Install TTBaseUIKit via SPM, CocoaPods, or local path"
fi

#============================================================
# Check 2: TTBaseUIKitConfig initialization
#============================================================
echo ""
echo "── TTBaseUIKitConfig Initialization ──────────────"

APP_DELEGATE="$PROJECT_PATH/App/AppDelegate.swift"
if [[ -f "$APP_DELEGATE" ]]; then
    if grep -q "TTBaseUIKitConfig" "$APP_DELEGATE" 2>/dev/null; then
        check "AppDelegate: TTBaseUIKitConfig" "true"
    else
        check "AppDelegate: TTBaseUIKitConfig" "false" "Initialize TTBaseUIKitConfig in AppDelegate"
    fi
else
    check "AppDelegate: File exists" "false" "Create AppDelegate.swift and initialize TTBaseUIKitConfig"
fi

#============================================================
# Check 3: Localizable.strings exists
#============================================================
echo ""
echo "── Localization ──────────────────────────────"

LOCALE_FILE=""
if [[ -f "$PROJECT_PATH/TTBaseUIKitExample/Localizable.strings" ]]; then
    LOCALE_FILE="$PROJECT_PATH/TTBaseUIKitExample/Localizable.strings"
elif [[ -f "$PROJECT_PATH/Localizable.strings" ]]; then
    LOCALE_FILE="$PROJECT_PATH/Localizable.strings"
elif [[ -f "$PROJECT_PATH/TTBaseUIKitExample/en.lproj/Localizable.strings" ]]; then
    LOCALE_FILE="$PROJECT_PATH/TTBaseUIKitExample/en.lproj/Localizable.strings"
fi

if [[ -n "$LOCALE_FILE" && -f "$LOCALE_FILE" ]]; then
    check "Localizable.strings" "true"
    # Verify it has at least one key
    if grep -q '"App\.' "$LOCALE_FILE" 2>/dev/null; then
        check "  Sample keys present" "true"
    else
        check "  Sample keys present" "false" "Add at least one key like \"App.Common.Title\""
    fi
else
    check "Localizable.strings" "false" "Create Localizable.strings file"
fi

#============================================================
# Check 4: iOS Deployment Target >= 14.0
#============================================================
echo ""
echo "── iOS Deployment Target ──────────────────────"

DEPLOY_TARGET=""
if [[ -f "$PROJECT_PATH/TTBaseUIKitExample.xcodeproj/project.pbxproj" ]]; then
    PB_PATH="$PROJECT_PATH/TTBaseUIKitExample.xcodeproj/project.pbxproj"
elif [[ -f "$PROJECT_PATH/project.pbxproj" ]]; then
    PB_PATH="$PROJECT_PATH/project.pbxproj"
fi

if [[ -n "$PB_PATH" && -f "$PB_PATH" ]]; then
    DEPLOY_TARGET=$(grep -o "IPHONEOS_DEPLOYMENT_TARGET = [0-9.]*" "$PB_PATH" 2>/dev/null | head -1 | grep -o "[0-9.]*")
    if [[ -n "$DEPLOY_TARGET" ]]; then
        MAJOR=$(echo "$DEPLOY_TARGET" | cut -d. -f1)
        if [[ "$MAJOR" -ge 14 ]]; then
            check "Deployment Target: iOS $DEPLOY_TARGET" "true"
        else
            check "Deployment Target: iOS $DEPLOY_TARGET" "false" "Set IPHONEOS_DEPLOYMENT_TARGET >= 14.0"
        fi
    else
        check "Deployment Target: Found" "false" "Set IPHONEOS_DEPLOYMENT_TARGET >= 14.0"
    fi
else
    check "Xcode Project: Found" "false" "Open project in Xcode and set deployment target"
fi

#============================================================
# Summary
#============================================================
echo ""
echo "========================================"
echo "  PRE-CHECK SUMMARY"
echo "========================================"
echo ""
echo "  ✅ PASSED: $PASS_COUNT"
echo "  ❌ FAILED: $FAIL_COUNT"
echo ""

if [[ $FAIL_COUNT -eq 0 ]]; then
    echo -e "  ${GREEN}✅ ALL PREREQUISITES MET${NC}"
    echo "  Ready to run TTBaseUIKit skill workflows."
    echo ""
    exit 0
else
    echo -e "  ${RED}❌ PREREQUISITES NOT MET${NC}"
    echo "  Please fix the above issues before running any skill."
    echo "  Run /ttb-init to set up the project foundation."
    echo ""
    exit 1
fi
