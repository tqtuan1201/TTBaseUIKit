---
name: "ttb-phase-verify"
description: "Phase 6 (shared) of all TTBaseUIKit workflows: post-build verification — xcodebuild CLI, rules compliance, and regression check. MUST run after every skill workflow."
version: "2.0.0"
---

# ttb-phase-verify — Post-Build Verification Phase

> **MANDATORY** — This phase MUST execute after EVERY skill workflow completes.
> Feature build | Bug fix | Refactor | Audit — ALL workflows.
> Output: BUILD SUCCEEDED + full compliance verification.

## Purpose

After any skill workflow generates or modifies code, verify:
1. The project **builds successfully** via `xcodebuild` CLI
2. All code changes **comply with project rules** (Iron Laws, anti-patterns, TTBaseUIKit patterns)
3. No **regression** was introduced to existing code
4. All **xcodebuild errors** are resolved before reporting completion
5. The final changes do not exceed the approved preflight scope, assumptions, or confidence gate

## When

Trigger **automatically** after:
- `/ttb-uikit` skill completes (screen, list, form, cell, customview, api, coordinator, viewmodel)
- `/ttb-swiftui` skill completes (sui-screen, sui-view, native-screen, native-view, sui-list, sui-viewmodel)
- `/ttb-bugfix` skill completes (fix applied)
- `/ttb-refactor` skill completes (migration done)
- `/ttb-audit` skill completes (fixes applied)

Before verification starts, compare changed files against the preflight `impactedFiles`/`impactedModules`. If new scope appeared during implementation, document it and re-run the preflight gate before continuing.

## 5-Layer Verification Stack

### Layer 1 — Xcode Project Integrity
Ensure all new `.swift` files are registered in `project.pbxproj`.

```
1. Check if new .swift files were created
2. Verify each file is referenced in project.pbxproj
3. If missing → add via AddFilesToXcode or ruby script:
   ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{file_path}"
4. If ruby script unavailable → manual add via Xcode
```

### Layer 2 — xcodebuild CLI Verification
Run `xcodebuild` to confirm the project compiles.

```
cd /path/to/TTBaseUIKitExample

# Determine available simulators
xcrun simctl list devices available | grep -E "iPhone (11|12|13|14|15)" | head -5

# Run build (substitute your scheme and simulator)
xcodebuild -project TTBaseUIKitExample.xcodeproj \
  -scheme TTBaseUIKitExample \
  -destination 'platform=iOS Simulator,name=iPhone 11' \
  build 2>&1 | tail -50
```

**Build Result Mapping:**
| Output | Action |
|--------|--------|
| `BUILD SUCCEEDED` | ✅ Layer 2 PASS → Layer 3 |
| `BUILD FAILED` | ❌ Fix errors → re-run Layer 2 |
| `warning:` (no error) | ⚠️ Review warnings → Layer 3 |

**Anti-Loop**: Max 3 build attempts. After 3 failures:
1. Document ALL errors verbatim
2. STOP — do not proceed
3. Report to user with error summary

### Layer 3 — Project Rules Compliance

Run these checks on all modified/created files:

#### iOS 14+ API Check
```bash
# Check for iOS 15+/16+/17+ APIs (must be ZERO)
grep -rn "\.task {" {modified_files}
grep -rn "NavigationStack" {modified_files}
grep -rn "#Preview {" {modified_files}
grep -rn "\.foregroundStyle" {modified_files}
grep -rn "@Observable" {modified_files}
grep -rn "\.clipShape(.rect" {modified_files}
grep -rn "\.scrollIndicators" {modified_files}
```

#### TTBaseUIKit Components Check
```bash
# Check for raw UIKit (should be ZERO)
grep -rn "UILabel()" {modified_files}
grep -rn "UIButton()" {modified_files}
grep -rn "UIView()" {modified_files} | grep -v "TTBaseUI"
grep -rn "UITextField()" {modified_files}
grep -rn "UITableView()" {modified_files}
grep -rn "UIScrollView()" {modified_files}
```

#### Config Token Check
```bash
# Check for hardcoded values (should be ZERO)
grep -rn "UIColor(hex:" {modified_files}
grep -rn "Color(hex:" {modified_files}
# Check for XView/XSize/XFont (should be TTView/TTSize/TTFont)
grep -rn "XView\." {modified_files}
grep -rn "XSize\." {modified_files}
grep -rn "XFont\." {modified_files}
```

#### Closure Safety Check
```bash
# Check for [weak self] in closures (should be ALL)
grep -rn "onTouchHandler" {modified_files} | grep -v "\[weak self\]"
grep -rn "API\.share\." {modified_files} | grep -v "\[weak self\]"
```

#### MVVM Separation Check
```bash
# ViewModel must NOT import UIKit/SwiftUI
grep -l "ViewModel" {modified_files} | xargs grep -l "import UIKit"
grep -l "ViewModel" {modified_files} | xargs grep -l "import SwiftUI"
```

**Compliance Result Mapping:**
| Violations | Action |
|-----------|--------|
| 0 violations | ✅ PASS → Layer 4 |
| 1-3 violations | ⚠️ FIX → re-run Layer 3 → Layer 4 |
| 4+ violations | ❌ BLOCK → fix all → re-run Layer 3 → Layer 4 |

### Layer 4 — Regression Guard

Verify existing code is not broken:

```
1. Check git status: git diff --stat HEAD
2. List all changed files (excluding project files)
3. For each changed .swift file:
   a. Read the file
   b. Verify it compiles correctly (no obvious syntax errors)
   c. Verify it follows TTBaseUIKit patterns
4. Run a full project build (Layer 2) — if SUCCEEDED, regression is unlikely
5. If build fails, analyze if the failure is related to existing code or new code
```

**Regression Result Mapping:**
| Result | Action |
|--------|--------|
| Full build succeeds | ✅ NO REGRESSION → Layer 5 |
| Build fails on new code | ❌ Fix new code → re-run Layer 2 |
| Build fails on existing code | 🔴 REGRESSION → rollback + fix |

### Layer 5 — FCR 7-Dimension Final Audit

Quick score for all modified files:

| # | Dimension | Weight | Must Pass |
|---|-----------|--------|-----------|
| 1 | iOS 14+ API | 15% | No iOS 15+/16+/17+ APIs |
| 2 | TTBaseUIKit Compliance | 20% | All components, no raw UIKit |
| 3 | Config Tokens | 15% | TTView/TTSize/TTFont everywhere |
| 4 | MVVM Separation | 15% | ViewModel pure, VC thin |
| 5 | Closure Safety | 15% | [weak self] everywhere |
| 6 | Localization | 10% | XText/XTextU with keys |
| 7 | Code Quality | 10% | MARK, naming, style |

**Scoring:**
- **10** = Perfect — no violations
- **8-9** = Minor issues — fix before reporting
- **6-7** = Moderate — requires fix, re-verify
- **< 6** = Blocked — STOP, fix critical issues

**Final Pass Threshold:**
| Score | Status |
|-------|--------|
| ≥ 85 (≥ 8.5 avg) | ✅ **READY** — Report success |
| 70–84 | ⚠️ **NEEDS FIX** — Fix issues → re-verify |
| < 70 | ❌ **BLOCKED** — STOP, escalate |

## Output Format

```
════════════════════════════════════════════════════════════
  POST-BUILD VERIFICATION REPORT
════════════════════════════════════════════════════════════

Skill: {ttb-skill-*}
Date: {YYYY-MM-DD HH:MM}
Files: {N} created / {N} modified

────────────────────────────────────────────────────────────
LAYER 1 — Xcode Project Integrity

  [✅ PASS / ❌ FAIL] All .swift files registered in project.pbxproj

────────────────────────────────────────────────────────────
LAYER 2 — xcodebuild CLI Verification

  Scheme: {SchemeName}
  Simulator: {iPhone XX}
  Result: ✅ BUILD SUCCEEDED / ❌ BUILD FAILED
  Warnings: {N}

  Build Log:
  {last 10 lines of xcodebuild output}

────────────────────────────────────────────────────────────
LAYER 3 — Project Rules Compliance

  iOS 14+ API          [{score}/10] ████████░░ {N} violations
  TTBaseUIKit          [{score}/10] ██████████ {N} violations
  Config Tokens        [{score}/10] ████████░░ {N} violations
  MVVM Separation      [{score}/10] █████████░ {N} violations
  Closure Safety       [{score}/10] ██████████ {N} violations
  Localization         [{score}/10] █████████░ {N} violations

  Result: ✅ PASS / ⚠️ FIX NEEDED / ❌ BLOCKED

────────────────────────────────────────────────────────────
LAYER 4 — Regression Guard

  Changed Files: {list}
  Result: ✅ NO REGRESSION / ❌ REGRESSION DETECTED

────────────────────────────────────────────────────────────
LAYER 5 — FCR 7-Dimension Final Score

  1. iOS 14+ API        [{score}/10]
  2. TTBaseUIKit        [{score}/10]
  3. Config Tokens      [{score}/10]
  4. MVVM Separation    [{score}/10]
  5. Closure Safety     [{score}/10]
  6. Localization       [{score}/10]
  7. Code Quality       [{score}/10]

  OVERALL: {X.X} / 10.0
  COMPLIANCE: [✅ READY / ⚠️ NEEDS FIX / ❌ BLOCKED]

════════════════════════════════════════════════════════════
  VERIFICATION COMPLETE — {STATUS}
════════════════════════════════════════════════════════════
```

## Error Recovery

| Error Type | Recovery Action |
|-----------|----------------|
| `error: file not found` | Add file to Xcode project, re-run |
| `error: ambiguous reference` | Check for duplicate imports or type conflicts |
| `error: cannot find type` | Verify TTBaseUIKit is imported; check module |
| `error: missing argument` | Check function signature, compare with reference |
| `error: value of type` | Check type compatibility, casting |
| `error: no such module` | Verify Package.swift / pod install |
| `warning: expression` | Non-critical, review but can pass Layer 2 |

## Anti-Loop Protocol

```
Round 1: Build → FAIL → Fix → Build
Round 2: Build → FAIL → Fix → Build
Round 3: Build → FAIL → STOP

Document all errors → Report to user → Do NOT proceed
```

## Special Cases

### No New Files Created
If skill made no file changes (e.g., audit-only), skip Layer 1, run Layer 2 only.

### Existing Project Without .xcodeproj
Skip Xcode project integrity check. Run xcodebuild on the found project.

### Build Hangs
If xcodebuild hangs > 5 minutes, kill and retry once. If hangs again, check for infinite loop in code generation.

### Mixed Results
- Layer 2 PASS + Layer 3 FAIL → Fix compliance → re-run Layers 2-3
- Layer 2 FAIL + Layer 3 PASS → Fix build errors → re-run Layer 2

---

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Added XView/XSize/XFont grep check to Layer 3. Fixed grep pattern for UIView() to exclude TTBaseUI. Updated output format. Version bumped.
