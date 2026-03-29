# Phase 6: Quality Assurance & Build Verification

> Parent: [plan.md](plan.md)
> Depends on: [Phase 5](phase-05-ux-polish.md)

## Overview

**Date:** 2026-03-29
**Priority:** High
**Status:** ⬜ TODO
**Estimated Effort:** 4h

Final verification: compile checks, design token compliance audit, file size audit, runtime smoke tests.

## Requirements

1. Zero compile errors
2. Zero design token violations (no hardcoded fonts/colors in Views)
3. No view file exceeds 300 lines
4. App launches and all tabs render without crash
5. All keyboard shortcuts work

## Implementation Steps

### 1. Compile Verification
```bash
cd TTBDebugPlus && xcodebuild -project TTBDebugPlus.xcodeproj -scheme TTBDebugPlus -sdk macosx build
```

### 2. Design Token Compliance Audit
```bash
# Font violations (must be 0)
grep -rn "\.font(\.system(" TTBDebugPlus/Views/ --include="*.swift" | wc -l

# Raw color violations (must be 0)
grep -rn "\.foregroundColor(\.\(white\|blue\|green\|yellow\|red\|gray\))" TTBDebugPlus/Views/ --include="*.swift" | wc -l

# Hardcoded hex colors in views (must be 0)
grep -rn "Color(hex:" TTBDebugPlus/Views/ --include="*.swift" | wc -l
```

### 3. File Size Audit
```bash
# No file > 300 lines
find TTBDebugPlus/Views/ -name "*.swift" -exec wc -l {} + | sort -rn | head -10
```

### 4. Runtime Smoke Test
- Launch app
- Click through all tabs (Console, Network, Device, Performance, DevTools, Feedback, Guide)
- Verify sidebar navigation
- Verify keyboard shortcuts (⌘1-6, ⌘K, ⌘?, ↑/↓)
- Verify menu bar extra opens

### 5. Post-Refactor Documentation
Update `docs/codebase-summary.md` with:
- New DesignSystem file list
- Updated View directory structure
- Design token reference

## Todo List

- [ ] Full build passes
- [ ] Font violations = 0
- [ ] Color violations = 0  
- [ ] File size audit passes
- [ ] All tabs render
- [ ] Keyboard shortcuts work
- [ ] Menu bar extra works
- [ ] Update codebase-summary.md

## Success Criteria

- Clean build with 0 errors, 0 warnings (excluding system warnings)
- All verification scripts pass
- App runs without crashes through all tabs
