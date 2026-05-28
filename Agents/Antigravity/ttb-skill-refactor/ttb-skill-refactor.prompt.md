---
description: "Refactor TTBaseUIKit code: migrate to TTViewCodable, replace raw UIKit with TTBaseUIKit, TTBaseSUI adoption, clean MVVM separation."
---

# ttb-skill-refactor -- Refactor Workflow

Refactor existing TTBaseUIKit code: migrate to TTViewCodable, replace raw UIKit, TTBaseSUI adoption, clean MVVM separation.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "refactor", "clean up code", "restructure", "migrate to TTViewCodable"

## Scope Commands

| Command | Scope |
|---------|-------|
| `/ttb-refactor-uikit` | UIKit → TTViewCodable, TTBaseUIKit |
| `/ttb-refactor-swiftui` | Native SwiftUI → TTBaseSUI |

## Refactoring UIKit

### Phase 1 -- MVVM Separation
| Issue | Fix |
|-------|-----|
| ViewModel imports UIKit | Remove UIKit, use Foundation only |
| VC contains business logic | Move to ViewModel |
| VC directly calls API | Route through ViewModel |
| VC formats data for display | Move formatter to VM or Model |
| Missing BaseViewModel | Create with callbacks |

### Phase 2 -- TTViewCodable Adoption
| Issue | Fix |
|-------|-----|
| VC does not implement TTViewCodable | Implement with all 6 methods |
| Missing MARK sections | Add: Properties, UI Components, Lifecycle, TTViewCodable, Actions |
| Wrong inheritance | Extend `BaseUIViewController` |

### Phase 3 -- Component Replacement
| Raw UIKit | TTBaseUIKit |
|-----------|------------|
| `UILabel()` | `TTBaseUILabel(withType:text:align:)` |
| `UIButton()` | `TTBaseUIButton(textString:type:isSetHeight:)` |
| `UITextField()` | `TTBaseUITextField(withPlaceholder:type:)` |
| `UIView()` container | `TTBaseUIView()` or `BaseShadowPanelView()` |
| `UITableView()` | `TTBaseUITableView(frame:style:)` |
| `UIScrollView()` | `BaseScrollViewController` or `BaseScrollUIStackView` |
| `UIStackView()` | `TTBaseUIStackView()` |
| `UICollectionView()` | `TTBaseUICollectionView(...)` |

### Phase 4 -- Constraint Refactoring
| Raw Constraint | TTBaseUIKit Chain |
|---------------|------------------|
| `NSLayoutConstraint.activate([])` | `view.setLeadingAnchor()...done()` |
| `translatesAutoresizingMaskIntoConstraints = false` | Remove (TTBaseUIKit does this) |
| Hardcoded `16` | `TTSize.P_CONS_DEF * 2` |
| Hardcoded `44` | `TTSize.H_BUTTON` |

### Phase 5 -- Handler Refactoring
| Bad Pattern | Good Pattern |
|------------|--------------|
| `addTarget(self, action:)` | `onTouchHandler = { [weak self] _ in }` |
| Inline complex closure | Extract to `private func` |
| `self.` without weak | `[weak self]` + `self?.` |

## Refactoring SwiftUI

### Phase 1 -- Component Migration (TTBaseSUI)
| Native SwiftUI | TTBaseSUI |
|----------------|----------|
| `Text("...")` | `TTBaseSUIText(withType:text:align:)` |
| `Button(...)` | `TTBaseSUIButton(type:title:)` |
| `Image("...")` | `TTBaseSUIImage(withname:conner:)` |
| `VStack { }` | `TTBaseSUIVStack(alignment:spacing:)` |
| `HStack { }` | `TTBaseSUIHStack(alignment:spacing:)` |
| `ZStack { }` | `TTBaseSUIZStack(alignment:bg:)` |
| `Spacer()` | `TTBaseSUISpacer()` |
| `ScrollView { }` | `TTBaseSUIScroll { }` |
| `LazyVStack { }` | `TTBaseSUILazyVStack(...)` |
| `Divider()` | `BaseHorizontalDivider()` |
| `NavigationView` as screen wrapper | `SUIBaseView(backType:title:type:isHiddenTabbar:backAction:)` |

### Phase 2 -- Modifier Migration
| Native SwiftUI | TTBaseUIKit |
|----------------|------------|
| `.background(Color.white)` | `.bg(byDef: .white)` |
| `.cornerRadius(8)` | `.corner(byDef: 8)` |
| `.padding()` | `.pAll()` |
| `.frame(maxWidth: .infinity)` | `.maxWidth()` |
| `.shadow(...)` | `.baseShadow()` |
| `.redacted(reason:)` | `.skeleton()` |
| `.onTapGesture { }` | `.onTapHandle { }` |

### Phase 3 -- iOS 14+ Compliance
| Higher iOS | iOS 14+ Replacement |
|-----------|-------------------|
| `.foregroundStyle()` | `.foregroundColor()` |
| `NavigationStack { }` | `SUIBaseView` |
| `#Preview { }` | `PreviewProvider` |
| `.task { }` | `.onAppear { Task { } }` |
| `@Observable` | `ObservableObject` + `@Published` |

### Phase 4 -- View Composition
| Issue | Fix |
|-------|-----|
| `body` > 40 lines | Extract subviews to dedicated `View` structs |
| Computed property returning `some View` | Extract to separate `View` struct |
| Business logic in `body` | Move to `onAppear` or ViewModel |
| Sub-views not in `CustomViews/` | Move to `{Feature}/CustomViews/` |

## Rules

1. **ZERO behavioral change** -- refactoring must not alter functionality
2. **One change at a time** -- don't mix architecture with style changes
3. **Verify compilation** -- ensure xcodebuild succeeds after each phase
4. **No new features** -- refactoring does not add functionality
5. **Preserve git history** -- commit each phase separately if possible

## Post-Refactor Verification (MANDATORY)

After all refactoring is complete, **run Phase 6 verification**:

1. **Run verification**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-verify.sh
   ```
2. **Check compliance**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-compliance-check.sh
   ```
3. **Refactor is complete only when** `BUILD SUCCEEDED`

**Anti-Loop**: Max 3 build attempts. 3 failures — STOP, document errors.

For full FCR 7-Dimension scoring, see `ttb-skill-shared/phases/ttb-phase-verify.md`.
