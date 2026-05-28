---
description: "Accessibility audit for TTBaseUIKit apps: VoiceOver, Dynamic Type, touch targets, color contrast for UIKit and SwiftUI."
---

# ttb-skill-audit-accessibility -- Accessibility Audit

Audit code for accessibility issues in TTBaseUIKit apps.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "audit accessibility", "voiceover", "accessibility", "a11y"

## 6 Accessibility Dimensions

### 1. VoiceOver Support

#### UIKit
| Check | Fix |
|-------|-----|
| Missing `accessibilityLabel` on images | `view.accessibilityLabel = "..."` |
| Missing `accessibilityHint` on buttons | `view.accessibilityHint = "..."` |
| Decorative images not marked | `view.isAccessibilityElement = false` |
| Complex custom views | Implement `UIAccessibilityContainer` |
| Dynamic content not announced | Call `UIAccessibility.post(notification: .screenChanged)` |

#### SwiftUI
| Check | Fix |
|-------|-----|
| Icon-only button | Add `.accessibilityLabel("...")` |
| Decorative image | `.accessibilityHidden(true)` |
| Grouped content | `.accessibilityElement(children: .combine)` |
| Custom actions | `.accessibilityActions()` |

### 2. Touch Targets

| Check | Fix |
|-------|-----|
| Button < 44×44pt | Increase size or hit area |
| Adjacent tappable elements < 8pt apart | Increase spacing |
| Small icon buttons | Add expanded hit area |

### 3. Dynamic Type

#### UIKit
| Check | Fix |
|-------|-----|
| Hardcoded font sizes | Use `UIFontMetrics` + `scaledValue(for:)` |
| Fixed label heights | Remove fixed heights, use auto-layout |
| Scaled images | Use `UIImageView` with `adjustsImageForAccessibilitySize` |

#### SwiftUI
| Check | Fix |
|-------|-----|
| `.font(.system(size: N))` | Use `.font(.body)`, `.font(.headline)` |
| `@ScaledMetric` missing | Add for custom font sizes |
| Fixed frames | Use `nil` for height in `frame()` |

### 4. Color Contrast

| Check | Fix |
|-------|-----|
| Text < 4.5:1 contrast ratio | Darken text or lighten background |
| Large text < 3:1 | Adjust colors |
| UI elements < 3:1 | Increase contrast |
| Never convey info by color alone | Add icon or text label |

### 5. Element Grouping

| Check | Fix |
|-------|-----|
| Related elements not grouped | Use container grouping |
| Step indicator not labeled | Add text labels |
| Charts without data table | Add accessible data representation |

### 6. Reduce Motion

#### SwiftUI
```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion
// Use `reduceMotion` to disable animations
```

#### UIKit
```swift
if UIAccessibility.isReduceMotionEnabled {
    // Disable animations
}
```

## iOS 14+ Accessibility APIs

| API | Use |
|-----|-----|
| `UIAccessibility.post(notification:)` | Announce screen changes |
| `UIAccessibility.isVoiceOverRunning` | Check VoiceOver state |
| `UIAccessibility.isReduceMotionEnabled` | Check Reduce Motion |
| `UIAccessibility.isSwitchControlRunning` | Check Switch Control |
| `traitDidChange` | Respond to trait changes |

## Output Format

```
════════════════════════════════════════════
ACCESSIBILITY AUDIT REPORT
════════════════════════════════════════════

Files Audited: N
Issues Found: N

──────────────────────────────────────────
VOICEOVER ISSUES

  [file:line] {issue}
    Dimension: VoiceOver
    Fix: {code}

──────────────────────────────────────────
TOUCH TARGET ISSUES

  [file:line] {issue}
    Dimension: Touch Targets
    Fix: {code}

──────────────────────────────────────────
DYNAMIC TYPE ISSUES

  [file:line] {issue}
    Dimension: Dynamic Type
    Fix: {code}

──────────────────────────────────────────
COLOR CONTRAST ISSUES

  [file:line] {issue}
    Dimension: Color Contrast
    Fix: {code}

──────────────────────────────────────────
SUMMARY

  Compliance Score: X/10
  WCAG Level: A / AA / AAA
```

## Verification
1. Test with VoiceOver: swipe through all screens
2. Test with Dynamic Type: scale to AX5
3. Test with Reduce Motion: enable and navigate
4. Use Accessibility Inspector (Xcode → Xcode → Open Developer Tool)

## Post-Audit Verification (MANDATORY)

After all audit checks complete, **run Phase 6 verification**:

1. **Run verification**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-verify.sh
   ```
2. **Check compliance**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-compliance-check.sh
   ```
3. **Audit is complete only when** `BUILD SUCCEEDED`

**Anti-Loop**: Max 3 build attempts. 3 failures — STOP, document findings.

For full FCR 7-Dimension scoring, see `ttb-skill-shared/phases/ttb-phase-verify.md`.
