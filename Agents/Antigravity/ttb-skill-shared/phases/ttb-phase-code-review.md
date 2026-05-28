---
name: "ttb-phase-code-review"
description: "Phase 5 of TTBaseUIKit feature workflow: review generated code for FCR 7-Dimension compliance across all skill sets."
version: "2.0.0"
---

# ttb-phase-code-review — Code Review Phase

## Purpose

Review generated code for FCR compliance across 7 dimensions.

Also verify that the implementation followed the preflight gate: no unapproved architecture changes, navigation changes, business logic changes, dependency changes, or convention changes were introduced after confidence scoring.

## FCR 7-Dimension Audit

| # | Dimension | Weight | Check |
|---|----------|--------|-------|
| 1 | iOS 14+ API | 15% | No iOS 15+/16+/17+ APIs |
| 2 | TTBaseUIKit Compliance | 20% | All components, no raw UIKit |
| 3 | Config Tokens | 15% | TTView/TTSize/TTFont everywhere |
| 4 | MVVM Separation | 15% | ViewModel pure, VC thin |
| 5 | Closure Safety | 15% | [weak self] everywhere |
| 6 | Localization | 10% | XText/XTextU with Localizable.strings |
| 7 | Code Quality | 10% | MARK sections, naming, style |

## Review Checklist

### Dimension 1: iOS 14+ API
- [ ] No `.task { }` (iOS 15+)
- [ ] No `NavigationStack` (iOS 16+)
- [ ] No `#Preview { }` (iOS 17+)
- [ ] No `.foregroundStyle()` (iOS 15+)
- [ ] No `NavigationLink` with `value` (iOS 16+)
- [ ] No `@Observable` (iOS 17+)

### Dimension 2: TTBaseUIKit Compliance
- [ ] No `UILabel()`, `UIButton()`, etc.
- [ ] TTBaseUITableViewCell extended
- [ ] TTBaseUICollectionViewCell extended
- [ ] TTViewCodable on UIKit VCs
- [ ] SUIBaseView on SwiftUI screens
- [ ] TTBaseNavigationLink for navigation (SwiftUI)

### Dimension 3: Config Tokens
- [ ] No `UIColor(hex:)` with hardcoded hex
- [ ] No hardcoded `8`, `16`, `24` for spacing
- [ ] No hardcoded font sizes
- [ ] TTView/TTSize/TTFont used throughout
- [ ] No XView/XSize/XFont (should be TTView/TTSize/TTFont)

### Dimension 4: MVVM Separation
- [ ] ViewModel imports only Foundation
- [ ] No UIKit types in ViewModel
- [ ] ViewModel callbacks drive UI updates
- [ ] VC thin: no business logic

### Dimension 5: Closure Safety
- [ ] `[weak self]` in all closures
- [ ] `guard let self = self` after weak capture
- [ ] No strong self in API callbacks
- [ ] `deinit` removes observers

### Dimension 6: Localization
- [ ] All user-facing strings use XText/XTextU
- [ ] XTextU for nav titles only
- [ ] XText for buttons, labels, placeholders
- [ ] Localization keys follow convention
- [ ] Keys added to Localizable.strings

### Dimension 7: Code Quality
- [ ] Marker comment in every file
- [ ] MARK sections present
- [ ] Naming follows convention
- [ ] No dead code
- [ ] File < 200 lines

### Preflight Compliance
- [ ] Requirement analysis and task type were identified before implementation
- [ ] Impacted files/modules matched the final diff
- [ ] Missing critical information was clarified or documented as low-risk assumptions
- [ ] Confidence threshold was respected
- [ ] No new architecture/navigation/business logic was invented without approval

## Output Format

```
════════════════════════════════════════════
CODE REVIEW REPORT
════════════════════════════════════════════

Feature: {Name}
Files Reviewed: N

──────────────────────────────────────────
7-DIMENSION FCR AUDIT

  1. iOS 14+ API        [{score}/10] ████████░░ 80%
  2. TTBaseUIKit        [{score}/10] ██████████ 100%
  3. Config Tokens      [{score}/10] ████████░░ 80%
  4. MVVM Separation    [{score}/10] █████████░ 90%
  5. Closure Safety     [{score}/10] ██████████ 100%
  6. Localization       [{score}/10] ████████░░ 80%
  7. Code Quality       [{score}/10] ███████░░░ 70%

  OVERALL: X.X / 10.0

──────────────────────────────────────────
COMPLIANCE: [READY / NEEDS FIX / BLOCKED]

  [READY]  Score >= 85
  [NEEDS FIX]  Score 70-84
  [BLOCKED] Score < 70

──────────────────────────────────────────
ISSUES FOUND

  [file:line] {issue}
    Dimension: {N}
    Fix: {suggestion}

──────────────────────────────────────────
CRITICAL BLOCKERS

  [file:line] {issue}
    Dimension: {N}
    Fix: {code}

──────────────────────────────────────────
PRAISE

  [file:line] {what was done well}
```

## Post-Review Verification (Phase 6)

After code review completes, MANDATORY verification:

1. **xcodebuild CLI**: Run build, must succeed before reporting completion
2. **FCR Final Score**: ≥ 85 to pass, otherwise fix and re-verify
3. **Report**: Output the full `ttb-phase-verify.md` report

**Completion Gate**: No skill workflow is complete until `✅ BUILD SUCCEEDED`.

## Rules
- Every generated file must be reviewed
- All 7 dimensions must be scored
- Critical blockers must be fixed before completion
- Score < 70 blocks feature completion
- **Post-build verification MUST pass** — build succeeds + compliance verified
