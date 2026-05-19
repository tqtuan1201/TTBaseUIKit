---
description: "Performance audit for TTBaseUIKit apps: UIKit and SwiftUI rendering, memory, CPU, main thread issues."
---

# ttb-skill-audit-performance -- Performance Audit

Audit code for performance issues in TTBaseUIKit apps.

## When

User says: "audit performance", "performance issue", "slow", "laggy", "memory"

## Symptom → Category Matrix

| Symptom | Category | Primary Files |
|---------|----------|--------------|
| Slow launch | Startup | AppDelegate, SceneDelegate, VC `viewDidLoad` |
| Laggy scrolling | Rendering | Table/Collection cells, SwiftUI `body` |
| High CPU | CPU | Loops, repeated layout passes, heavy computation |
| Memory growth | Memory | Retain cycles, image caching, large data |
| UI freezes | Main Thread | Sync operations on main, no dispatch |
| Excessive re-renders | SwiftUI | `@Published` on large objects, no `Equatable` |

## UIKit Audit Checklist

| # | Check | Symptom |
|---|-------|--------|
| 1 | `viewDidLoad` doing heavy work | Slow launch |
| 2 | Network calls on main thread | UI freezes |
| 3 | Large image loading without caching | Memory growth |
| 4 | `tableView.reloadData()` on every data change | Laggy scrolling |
| 5 | Complex constraints recalculated often | CPU spike |
| 6 | Missing cell reuse (`dequeueReusableCell`) | Memory growth |
| 7 | Heavy computation in `cellForRowAt` | Laggy scrolling |
| 8 | `layoutIfNeeded` in tight loops | CPU spike |
| 9 | Missing `prepareForReuse()` in cells | Memory growth |
| 10 | Notification observers not removed | Memory leak |

## SwiftUI Audit Checklist

| # | Check | Symptom |
|---|-------|--------|
| 1 | `body` > 40 lines | Excessive re-renders |
| 2 | `@Published` on large model objects | Excessive re-renders |
| 3 | Missing `Equatable` conformance | Excessive re-renders |
| 4 | Creating new views in `body` | Excessive re-renders |
| 5 | Heavy work in `.onAppear` without loading state | UI freezes |
| 6 | `@StateObject` on passed-in VM | Memory leak |
| 7 | Large `LazyVStack` without `id` | Laggy scrolling |
| 8 | Image decoding on main thread | UI freezes |
| 9 | Sync operations in View init | Slow launch |
| 10 | Missing `.aspectRatio` on images | Memory spike |

## Diagnosis → Remediation

| Issue | Remediation |
|-------|------------|
| `viewDidLoad` heavy work | Move to async/background, show skeleton |
| Sync network on main | Move to `DispatchQueue.global().async` |
| Large images | Downsample with `UIGraphicsImageRenderer`, cache |
| `reloadData()` | Use `performBatchUpdates`, `reloadRows` |
| Complex cell layout | Pre-calculate heights, simplify layout |
| Cell reuse issue | `prepareForReuse()` + reset state |
| SwiftUI re-renders | Use `Equatable`, `@equatable`, extract subviews |
| Large `@Published` | Publish only changed fields |
| Missing loading state | Show skeleton/loading view |
| Memory growth | Profile with Instruments, check retain cycles |

## Output Format

```
════════════════════════════════════════════
PERFORMANCE AUDIT REPORT
════════════════════════════════════════════

Files Audited: N
Issues Found: N (CRITICAL: N, HIGH: N, MEDIUM: N)

──────────────────────────────────────────
CRITICAL ISSUES

  [file:line] {issue description}
    Symptom: {symptom}
    Category: {category}
    Remediation: {steps}

──────────────────────────────────────────
HIGH ISSUES

  [file:line] {issue description}
    Symptom: {symptom}
    Category: {category}
    Remediation: {steps}

──────────────────────────────────────────
SUMMARY

  Compliance Score: X/10
  Risk: {LOW / MEDIUM / HIGH / CRITICAL}
```

## Verification
After applying fixes:
1. Profile with Instruments (Allocations, Time Profiler)
2. Check for improved frames in scrolling
3. Monitor memory growth under load

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
