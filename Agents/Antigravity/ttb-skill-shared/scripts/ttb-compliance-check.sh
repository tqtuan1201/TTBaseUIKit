#!/bin/bash
#============================================================
# Antigravity — Compliance Check Script
#============================================================
# Runs all grep-based compliance checks on modified Swift files.
# Replaces ~20 lines of grep commands repeated in every prompt.
#
# Usage:
#   bash ttb-skill-shared/scripts/ttb-compliance-check.sh [files...]
#   bash ttb-skill-shared/scripts/ttb-compliance-check.sh "file1.swift file2.swift"
#
# Defaults to all modified .swift files from git if no args given.
#============================================================

set -e

# Determine files to check
if [[ $# -gt 0 ]]; then
    FILES="$*"
else
    FILES=$(git diff --name-only HEAD 2>/dev/null | grep "\.swift$" | tr '\n' ' ' || echo "")
fi

if [[ -z "$FILES" ]]; then
    echo "No Swift files to check. Skipping."
    exit 0
fi

echo ""
echo "========================================"
echo "  Antigravity — ttb-compliance-check"
echo "========================================"
echo "  Files: $FILES"
echo "========================================"
echo ""

PASS_COUNT=0
FAIL_COUNT=0

# Helper function
check() {
    local label="$1"
    local pattern="$2"
    local description="$3"

    RESULT=$(grep -rn "$pattern" $FILES 2>/dev/null || echo "")
    if [[ -z "$RESULT" ]]; then
        echo -e "  $label  ✅ PASS"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "  $label  ❌ FAIL ($description)"
        echo "    First 3 matches:"
        echo "$RESULT" | head -3 | sed 's/^/      /'
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

#============================================================
# iOS 14+ API Check
#============================================================
echo "── iOS 14+ API Check ─────────────────────────"

check ".task { }"            "Found: .task { } (iOS 15+)"
check "NavigationStack"       "Found: NavigationStack (iOS 16+)"
check "#Preview {"            "Found: #Preview { } (iOS 17+)"
check "\.foregroundStyle"    "Found: .foregroundStyle (iOS 15+)"
check "@Observable"           "Found: @Observable (iOS 17+)"
check "\.clipShape(.rect"    "Found: .clipShape(.rect()) (iOS 16+)"
check "\.scrollIndicators"   "Found: .scrollIndicators (iOS 16+)"

#============================================================
# TTBaseUIKit Components Check
#============================================================
echo ""
echo "── TTBaseUIKit Components Check ───────────────"

check "UILabel()"            "Found: raw UILabel()"
check "UIButton()"           "Found: raw UIButton()"
check "UIView()"            "Found: raw UIView()"
check "UITextField()"        "Found: raw UITextField()"
check "UITableView()"        "Found: raw UITableView()"
check "UIScrollView()"       "Found: raw UIScrollView()"
check "UIActivityIndicatorView()" "Found: raw UIActivityIndicatorView()"

#============================================================
# Config Token Check
#============================================================
echo ""
echo "── Config Token Check ──────────────────────────"

check "UIColor(hex:"         "Found: hardcoded UIColor(hex:)"
check "Color(hex:"           "Found: hardcoded Color(hex:)"
check "CGFloat(8)"          "Found: hardcoded CGFloat(8)"
check "CGFloat(16)"         "Found: hardcoded CGFloat(16)"

#============================================================
# Closure Safety Check
#============================================================
echo ""
echo "── Closure Safety Check ────────────────────────"

# Check onTouchHandler without [weak self]
ONUNSAFE=$(grep -rn "onTouchHandler" $FILES 2>/dev/null | grep -v "\[weak self\]" | grep -v "func " || echo "")
if [[ -z "$ONUNSAFE" ]]; then
    echo -e "  onTouchHandler [weak self]  ✅ PASS"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo -e "  onTouchHandler [weak self]  ❌ FAIL"
    echo "$ONUNSAFE" | head -3 | sed 's/^/      /'
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi

# Check API.share without [weak self]
APIUNSAFE=$(grep -rn "API\.share" $FILES 2>/dev/null | grep -v "\[weak self\]" | grep -v "func " || echo "")
if [[ -z "$APIUNSAFE" ]]; then
    echo -e "  API.share [weak self]    ✅ PASS"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo -e "  API.share [weak self]    ❌ FAIL"
    echo "$APIUNSAFE" | head -3 | sed 's/^/      /'
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi

#============================================================
# MVVM Separation Check
#============================================================
echo ""
echo "── MVVM Separation Check ─────────────────────"

VM_UIKIT=$(grep -l "ViewModel" $FILES 2>/dev/null | xargs grep "import UIKit" 2>/dev/null || echo "")
VM_SWIFTUI=$(grep -l "ViewModel" $FILES 2>/dev/null | xargs grep "import SwiftUI" 2>/dev/null || echo "")

if [[ -z "$VM_UIKIT" ]] && [[ -z "$VM_SWIFTUI" ]]; then
    echo -e "  ViewModel pure         ✅ PASS"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo -e "  ViewModel pure         ❌ FAIL"
    [[ -n "$VM_UIKIT" ]] && echo "    ViewModel importing UIKit: $VM_UIKIT"
    [[ -n "$VM_SWIFTUI" ]] && echo "    ViewModel importing SwiftUI: $VM_SWIFTUI"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi

#============================================================
# Summary
#============================================================
echo ""
echo "========================================"
echo "  COMPLIANCE CHECK SUMMARY"
echo "========================================"
echo ""
echo "  ✅ PASSED: $PASS_COUNT"
echo "  ❌ FAILED: $FAIL_COUNT"
echo ""

if [[ $FAIL_COUNT -eq 0 ]]; then
    echo -e "  ${GREEN}✅ ALL CHECKS PASSED${NC}"
    exit 0
else
    echo -e "  ${RED}❌ VIOLATIONS FOUND — Fix before committing${NC}"
    exit 1
fi
