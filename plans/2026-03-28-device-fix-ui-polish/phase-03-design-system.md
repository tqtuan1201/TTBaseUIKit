# Phase 3: Design System Refinements

**Parent:** [plan.md](./plan.md)
**Dependencies:** Phase 2
**Priority:** P2 — Polish

---

## Overview

**Date:** 2026-03-28
**Created By:** TuanTruong
**Status:** Draft
**Implementation Status:** Not Started
**Review Status:** Pending

## Key Insights

- CardView background opacity 0.6 looks washed out → increase
- Button styles lack macOS hover states
- Micro-animations missing → app feels static
- Some typography sizes too close together

## Requirements

- [ ] Improve CardView visual weight (opacity, subtle shadow)
- [ ] Add hover states to all button styles
- [ ] Add micro-animations to interactive elements
- [ ] Refine typography scale for better hierarchy

## Related Code Files

| File | Change |
|------|--------|
| `DesignSystem/CardView.swift` | Background opacity, shadow |
| `DesignSystem/ButtonStyles.swift` | Hover states via `@State isHovered` |
| `DesignSystem/Typography.swift` | Minor size adjustments |
| `DesignSystem/Colors.swift` | No changes needed |

## Implementation Steps

### Step 1: CardView Enhancement (10 min)
- Increase fill opacity from 0.6 → 0.75
- Add subtle shadow: `.shadow(color: .black.opacity(0.15), radius: 8, y: 4)`
- Slightly increase border opacity for better definition

### Step 2: Button Hover States (20 min)
- Add `@State var isHovered: Bool = false` to each button style
- Use `.onHover { isHovered = $0 }` to track hover
- Apply subtle background/border change on hover
- TTPrimaryButtonStyle: lighten bg on hover
- TTSecondaryButtonStyle: show border highlight on hover
- TTGhostButtonStyle: show subtle bg on hover

### Step 3: Micro-Animations (15 min)
- ConnectionIndicator: pulsing glow animation for connected state
- Tab selection: smooth underline transition (already has `.easeInOut`, verify)
- Sidebar item selection: spring animation
- Card entry: subtle fade-in on appear

### Step 4: Typography Fine-Tuning (10 min)
- Increase `displayLarge` from 32 → 34 for better headline impact
- `heading3` vs `labelLarge`: same 13pt — differentiate (heading3→16pt)
- Verify all views use consistent typography tokens

## Todo List

- [ ] CardView: opacity, shadow
- [ ] ButtonStyles: hover states
- [ ] Micro-animations: pulse, transitions
- [ ] Typography: scale adjustments

## Success Criteria

- Cards look solid with clear depth separation
- Buttons give visual feedback on hover (macOS expectation)
- App feels alive with subtle animations
- Typography hierarchy is visually clear at a glance

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Hover breaks on non-mouse input | Low | Low | macOS is always mouse/trackpad |
| Animations feel excessive | Low | Medium | Keep subtle — < 300ms durations |

## Next Steps
All 3 phases complete — build & test full app.
