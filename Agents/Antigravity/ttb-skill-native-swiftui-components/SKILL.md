---
name: "ttb-skill-native-swiftui-components"
description: "Build reusable native SwiftUI UI components using 100% standard SwiftUI with TTBaseUIKit design tokens. NO TTBaseSUI wrappers. iOS 14+."
version: "2.0.0"
loadLevel: "domain"
---

# ttb-skill-native-swiftui-components

> Build reusable native SwiftUI UI components using 100% standard SwiftUI with TTBaseUIKit design tokens.
> NO TTBaseSUI wrappers | iOS 14+

## Ba Tầng Tiếp Cận SwiftUI trong TTBaseUIKit

| Tầng | Khi nào | Components |
|-------|---------|-----------|
| **Tầng 1 — TTBaseSUI** | Component TTBaseSUI đã có | `TTBaseSUIButton`, `TTBaseSUIText`, etc. → `/ttb-sui-view` |
| **Tầng 2 — Native Atomic** | TTBaseSUI thiếu atomic component | `Text`, `Button`, `VStack` với tokens → `/native-*` |
| **Tầng 3 — Native Screen** | TTBaseSUI thiếu cả component + layout | SwiftUI primitives + tokens → `/ttb-native-screen` |

**Rule #1: Dùng TTBassSUI wherever it exists. Chỉ Native SwiftUI khi TTBaseSUI không có.**

## Skills in This Set

| Command | Description |
|---------|-------------|
| `/native-text` | Native text: Title, body, caption, badge |
| `/native-button` | Native button: Primary, secondary, destructive, link |
| `/native-card` | Native card: Tappable card, static card |
| `/native-list-row` | Native list row: Icon row, switch row, stepper row |
| `/native-input` | Native input: Text field, secure field, search bar |
| `/native-selector` | Native selector: Toggle, checkbox, radio, segmented |
| `/native-display` | Native display: Avatar, badge, chip, tag, rating |
| `/native-progress` | Native progress: Linear bar, circular, skeleton |
| `/native-divider` | Native divider: Horizontal, vertical, section spacer |
| `/native-tab-bar` | Native tab bar: Tab icon + label |
| `/native-icon` | Native icon: SF Symbol with color/size |
| `/native-bottom-sheet` | Native bottom sheet: Slide-up panel |
| `/native-empty-state` | Native empty state: Illustration + message + action |
| `/native-loading` | Native loading: Spinner, shimmer, skeleton |
| `/native-snackbar` | Native snackbar/toast: Bottom notification |
| `/native-chip` | Native chip/tag: Chip with states |
| `/native-avatar` | Native avatar: Image, initials, status |
| `/native-rating` | Native rating: Star rating, interactive and display |
| `/native-section-header` | Native section header: Section header with action |

## Khi Nào Dùng Tầng Nào

```
┌─────────────────────────────────────────────────────────┐
│ Cần build component mới?                                │
│  ↓                                                      │
│ TTBaseSUI component có chưa?                            │
│  ├── CÓ → Dùng TTBaseSUI → /ttb-sui-view              │
│  └── KHÔNG → Atomic component cần build?              │
│          ├── CÓ → Native SwiftUI + tokens → /native-* │
│          └── KHÔNG → Screen-level → /ttb-native-screen │
└─────────────────────────────────────────────────────────┘
```

### So Sánh: /native-* vs /ttb-native-*

| | `/native-*` | `/ttb-native-screen` |
|--|------------|---------------------|
| Scope | Reusable atomic component | Full screen/view |
| Usage | Inside TTBaseSUI views hoặc screens | Entire screen layout |
| Example | Custom badge, custom chip, chart | Complex screen với custom animation |
| SUIBaseView | Không cần | Cần SUIBaseView wrapper |

### Khi Nào Dùng /native-*

Dùng khi cần build component mà **không có trong TTBaseSUI**:

- Custom `BadgeView` với animation
- Custom `RatingView` với interaction
- Custom `ChipView` với multi-state
- Custom chart component (dùng SwiftUI Charts hoặc Canvas)
- Custom `BottomSheetView` với drag gesture
- Custom `SnackbarView` với queue logic

### Khi Nào Dùng /ttb-native-screen

Dùng khi cần build **toàn bộ screen** mà TTBaseSUI không cung cấp đủ layout primitives.

## Component Architecture

Each component follows this pattern:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  Components/{Category}/{Name}Component.swift
//  {AppName}
//  ⚠️ NATIVE SWIFTUI: Dùng khi TTBaseSUI không có component
//
import SwiftUI
import TTBaseUIKit

// MARK: - {Name}Component
public struct {Name}Component: View {
    var onTap: (() -> Void)?

    public var body: some View {
        // Use Button (not onTapGesture), TTView/TTSize/TTFont tokens
        // iOS 14+ only — no .task, NavigationStack, #Preview
        // Min 44x44 tap target, accessibility labels
    }
}

struct {Name}Component_Previews: PreviewProvider {
    static var previews: some View {
        {Name}Component()
    }
}
```

## Token Access

Full reference: `ttb-skill-shared/refs/ttb-ref-config-tokens.md`

**Colors** (use `TTView.*.toColor()`):
- Text: `textDefColor`, `textHeaderColor`, `textSubTitleColor`
- Background: `viewBgColor`, `viewBgCellColor`, `viewBgSkeleton`
- Button: `buttonBgDef`, `buttonBgWar`, `buttonBgDis`
- Semantic: `notificationBgSuccess`, `notificationBgWarning`, `notificationBgError`
- UI: `iconColor`, `lineDefColor`

**Sizes** (use `TTSize.*`):
- Spacing: `P_S` (4pt), `P_CONS_DEF` (8pt), `P_M` (12pt), `P_L` (16pt), `P_XL` (20pt)
- Heights: `H_BUTTON` (40pt), `H_TEXTFIELD` (35pt), `H_ICON` (40pt)
- Radius: `CORNER_RADIUS` (4pt), `CORNER_PANEL` (8pt)

**Fonts** (use `.system(size: TTFont.*)`):
- `HEADER_SUPER_H` (~24pt), `HEADER_H` (~16pt), `TITLE_H` (~14pt), `SUB_TITLE_H` (~12pt), `SUB_SUB_TITLE_H` (~10pt)

## Iron Laws

1. **iOS 14+ ONLY** — no `.task`, `NavigationStack`, `#Preview`, `.foregroundStyle()`
2. **TTBaseUIKit Tokens ONLY** — `TTView.*.toColor()`, `TTSize.*`, `TTFont.*`
3. **100% Native SwiftUI** — no `TTBaseSUI*` wrappers
4. **Use `Button`** for tappable views — NEVER `onTapGesture` as button substitute
5. **Minimum 44×44** tap target for interactive elements
6. **Accessibility always**: `.accessibilityLabel()`, `.accessibilityHint()`, Dynamic Type support
7. **Body < 40 lines** — extract sub-views to private computed properties
8. **`@ViewBuilder` / `Group`** instead of `AnyView` type erasure
9. **PreviewProvider** at bottom of every component file
10. **MARKER COMMENT** at top of every file

## Component Categories

| Category | Components |
|----------|------------|
| Display | Text, Avatar, Badge, Chip/Tag, Rating, Icon |
| Interactive | Button, Toggle, Checkbox, Radio, Segmented, Slider |
| Input | TextField, SecureField, SearchBar, Stepper |
| Container | Card, ListRow, EmptyState, Loading, Skeleton, Snackbar, BottomSheet |
| Layout | Divider, Spacer, SectionHeader |

## Files in This Skill Set

| File | Purpose |
|------|---------|
| `SKILL.md` | Skill entry point (this file) |
| `refs/ttb-ref-native-design-tokens.md` | Complete design token reference |
| `ttb-skill-native-*.prompt.md` | 20 component prompt files |

## Shared Resources

- `ttb-skill-shared/rules/ttb-rule-anti-patterns.md` — SwiftUI anti-patterns + decision matrix
- `ttb-skill-shared/rules/ttb-rule-coding-standards.md` — File headers, MARK sections
- `ttb-skill-shared/refs/ttb-ref-config-tokens.md` — Color/size/font tokens
- `ttb-skill-shared/refs/ttb-ref-ios14-compatibility.md` — iOS 14 API guide
- `ttb-skill-shared/fragments/ttb-iron-laws.frag.md` — Iron Laws

## Post-Implementation Verification (MANDATORY)

After all files are generated, **run Phase 6 verification**:

1. **Add files to Xcode project** — ensure each `.swift` is registered in `project.pbxproj`
2. **Run verification**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-verify.sh
   ```
3. **Check compliance**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-compliance-check.sh
   ```
4. **Skill is complete only when** `BUILD SUCCEEDED`

**Anti-Loop**: Max 3 build attempts. 3 failures — STOP, document errors.

For full FCR 7-Dimension scoring, see `ttb-skill-shared/phases/ttb-phase-verify.md`.

---

**Version**: 2.0.0 | **Date**: 2026-05-19
**Changelog**: v2.0.0 — Added 3-tier SwiftUI approach clarification. Added `/native-*` vs `/ttb-native-screen` comparison table. Added critical token warnings. Native SwiftUI now strictly a fallback tier. v1.4.0 — Fixed XView/XSize/XFont token references.
