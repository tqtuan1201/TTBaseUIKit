---
name: "antigravity-readme-vi"
description: "Vietnamese README — tổng quan hệ thống TTBaseUIKit Antigravity agent v2.0.0."
version: "2.0.0"
---

# Antigravity — Bộ Agent AI cho TTBaseUIKit

**Version**: 2.0.0 | **Min iOS**: 14+ | **Architecture**: MVVM-C

## Tổng quan

Antigravity là hệ thống skill agent AI để xây dựng ứng dụng iOS với **TTBaseUIKit** (UIKit) và **TTBaseSUI** (SwiftUI wrapper). Hệ thống enforce strict workflow 7 phases, 11 Luật Sắt, và FCR 7-Dimension compliance scoring.

## Bắt đầu nhanh

1. Đọc `SKILL.md` (root) để hiểu system overview
2. Chọn skill dựa trên task:
   - **Dự án mới**: `/tts-init` → `ttb-skill-init`
   - **UIKit Feature**: `/tts-uikit` → `ttb-skill-uikit`
   - **SwiftUI Feature**: `/tts-swiftui` → `ttb-skill-swiftui`
   - **Native SwiftUI Components**: `/tts-native` → `ttb-skill-native-swiftui-components`
   - **Sửa Bug**: `/tts-bugfix` → `ttb-skill-bugfix`
   - **Refactor**: `/tts-refactor` → `ttb-skill-refactor`
   - **Audit**: `/tts-audit` → `ttb-skill-audit`

3. Theo workflow của skill qua các phases
4. **Luôn chạy post-build verification** (Phase 6) — `BUILD SUCCEEDED` là bắt buộc

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│  Antigravity Agent System                               │
├─────────────────────────────────────────────────────────┤
│  Core Skills (always loaded)                            │
│  ├── ttb-skill-init    — Khởi tạo dự án              │
│  ├── ttb-skill-uikit  — UIKit feature dev             │
│  ├── ttb-skill-swiftui — SwiftUI feature dev          │
│  └── ttb-skill-bugfix — Sửa bug                      │
│                                                         │
│  Domain Skills (loaded when skill activates)            │
│  ├── ttb-skill-refactor        — Code migration       │
│  └── ttb-skill-native-swiftui   — Native SwiftUI      │
│                                                         │
│  On-Demand Skills (loaded when requested)              │
│  └── ttb-skill-audit   — Performance, a11y, l10n     │
├─────────────────────────────────────────────────────────┤
│  Shared Resources (all skills use)                      │
│  ├── 11 Luật Sắt                                      │
│  ├── 5 Phases (Research → Spec → Impl → Review → Ver)│
│  ├── 5 Rules (coding, anti-patterns, memory, etc.)     │
│  ├── 7 References (TTBaseUIKit, TTBaseSUI, tokens…)   │
│  └── 3 Scripts (precheck, compliance, verify)          │
└─────────────────────────────────────────────────────────┘
```

## 11 Luật Sắt (BẮT BUỘC)

1. **iOS 14+ ONLY** — không dùng iOS 15+/16+/17+ APIs
2. **TTBaseUIKit COMPONENTS** — không dùng raw UIKit khi TTBaseUIKit đã có
3. **TTViewCodable MVVM** — UIKit views sử dụng protocol TTViewCodable
4. **TTBaseSUI FOR SWIFTUI** — dùng TTBaseSUI* wrappers cho SwiftUI
5. **SUIBaseView WRAPPER** — mọi màn hình SwiftUI phải dùng `SUIBaseView`
6. **TTBaseNavigationLink** — mọi navigation giữa các màn hình dùng `TTBaseNavigationLink`
7. **MVVM SEPARATION** — ViewModel không bao giờ import UIKit/SwiftUI
8. **xcodebuild CLI IS LAW** — verify bằng command line
9. **ZERO REGRESSION** — verify code hiện tại vẫn hoạt động
10. **ANTI-LOOP: MAX 3 ROUNDS** — 3 build failures → dừng lại, ghi lại lỗi
11. **XÁC THỰC SAU BUILD BẮT BUỘC** — sau mỗi skill workflow: `BUILD SUCCEEDED`

## Three-Tier SwiftUI Approach

| Tier | Khi nào dùng | Components |
|------|---------------|------------|
| **Tier 1 — TTBaseSUI** | Component đã tồn tại | `TTBaseSUI*` wrappers → `/ttb-sui-*` |
| **Tier 2 — SUIBaseView + TTBaseNavigationLink** | Navigation giữa các màn hình | Pattern bắt buộc |
| **Tier 3 — Native SwiftUI + tokens** | TTBaseSUI không có component | `Text`, `Button`, `VStack` + TTView/TTSize/TTFont |

**Luật: Ưu tiên TTBaseSUI. Chỉ fallback sang Native SwiftUI khi TTBaseSUI không có equivalent.**

## Navigation Patterns

### SwiftUI (BẮT BUỘC)

Mọi màn hình SwiftUI **PHẢI** wrap trong `SUIBaseView`.
Mọi navigation giữa các màn hình **PHẢI** dùng `TTBaseNavigationLink`.

```swift
// Mọi màn hình SwiftUI — Luật Sắt #5
struct HomeScreen: View {
    var body: some View {
        SUIBaseView(
            titleNav: XTextU("App.Home.Nav.Title"),
            isShowBack: true,
            backType: .SWIFTUI,
            isHiddenTabbar: false
        ) {
            content
        }
        .onAppear { /* fetch data */ }
    }

    private var content: some View {
        ScrollView {
            LazyVStack(spacing: TTSize.P_CONS_DEF) {
                ForEach(items) { item in
                    TTBaseNavigationLink(
                        destination: DetailScreen(item: item),
                        label: { ItemCardView(item: item) }
                    )
                }
            }
            .padding(TTSize.P_CONS_DEF)
        }
        .background(TTView.viewBgColor.toColor())
    }
}

// TTBaseNavigationLink variants
// Variant 1: Navigation đơn giản với label closure
TTBaseNavigationLink(destination: { DetailScreen(vm: vm) }, label: { CardView() })

// Variant 2: Active binding cho navigation có điều kiện
TTBaseNavigationLink(isActive: $vm.isShowingDetail) {
    DetailScreen(vm: vm)
}
```

### backType Decision Matrix

| Scenario | backType |
|----------|----------|
| Pure SwiftUI app, navigate giữa các màn hình | `.SWIFTUI` |
| Hybrid app (UIKit nav stack), push lên nav controller | `.POP` |
| Dismiss modal / sheet | `.DISMISS` |
| Pop back về root view controller | `.POP_TO_ROOT` |
| Close entire flow / tab | `.CLOSE_FLOW` |

### UIKit

```swift
// Coordinator pattern — Luật Sắt #7
class DetailCoordinator: TTCoordinator {
    var childCoordinators: [TTCoordinator] = []

    func start() {
        let vc = DetailViewController()
        vc.onDismiss = { [weak self] in self?.dismiss() }
        navigationController.pushViewController(vc, animated: true)
    }
}
```

## FCR 7-Dimension Compliance

| # | Dimension | Weight | Must Pass |
|---|-----------|--------|-----------|
| 1 | iOS 14+ API | 15% | Không iOS 15+/16+/17+ APIs |
| 2 | TTBaseUIKit Compliance | 20% | Tất cả components, không raw UIKit |
| 3 | Config Tokens | 15% | TTView/TTSize/TTFont ở mọi nơi |
| 4 | MVVM Separation | 15% | ViewModel pure, VC mỏng |
| 5 | Closure Safety | 15% | [weak self] ở mọi nơi |
| 6 | Localization | 10% | XText/XTextU với keys |
| 7 | Code Quality | 10% | MARK sections, naming, style |

**Pass Threshold**: ≥ 85% (≥ 8.5/10 avg)

| Score | Status |
|-------|--------|
| ≥ 85% | ✅ READY — Báo cáo thành công |
| 70–84% | ⚠️ NEEDS FIX — Sửa issues → re-verify |
| < 70% | ❌ BLOCKED — DỪNG, escalate |

## ⚠️ Critical Token Warnings

Các token sau **KHÔNG TỒN TẠI** trong TTBaseUIKit:

| ❌ KHÔNG DÙNG | ✅ DÙNG THAY THẾ |
|--------------|------------------|
| `XView` | `TTView` |
| `XSize` | `TTSize` |
| `XFont` | `TTFont` |
| `TTView.colorSuccess` | `TTView.notificationBgSuccess` |
| `TTView.colorWarning` | `TTView.notificationBgWarning` |
| `TTView.colorError` | `TTView.notificationBgError` |
| `TTView.buttonBgHighlight` | Tính thủ công |
| `TTView.buttonBgWarring` | `TTView.buttonBgWar` |
| `TTView.buttonBgDisable` | `TTView.buttonBgDis` |
| `TTView.textThirdTitleColor` | `TTView.textSubTitleColor` |
| `TTView.viewBgSecondaryColor` | `TTView.viewBgColor` |
| `TTView.separatorColor` | `TTView.lineDefColor` |
| `TTView.iconPrimaryColor` | `TTView.iconColor` |
| `TTSize.P_XXL` | `TTSize.P_CONS_DEF * 4` (32pt) |
| `TTSize.SIZE_SUPER_HEADER` | `TTFont.HEADER_SUPER_H` |

## Xác thực sau Build (BẮT BUỘC)

Sau mỗi skill workflow, chạy Phase 6 verification:

```bash
bash ttb-skill-shared/scripts/ttb-verify.sh
bash ttb-skill-shared/scripts/ttb-compliance-check.sh
```

### 5-Layer Verification Stack

| Layer | Kiểm tra |
|-------|----------|
| Layer 1 | Xcode Project Integrity — tất cả `.swift` files trong `project.pbxproj` |
| Layer 2 | xcodebuild CLI — `BUILD SUCCEEDED` |
| Layer 3 | Rules Compliance — iOS 14+, TTBaseUIKit, tokens, closures |
| Layer 4 | Regression Guard — code hiện tại không bị hỏng |
| Layer 5 | FCR 7-Dimension Score — ≥ 85% để pass |

**Anti-Loop**: Tối đa 3 lần build. 3 lần fail → DỪNG, ghi lại lỗi.

## Token Budget

| Danh mục | Tokens/Session |
|----------|----------------|
| Root + Shared SKILL.md | ~1,500 |
| Iron Laws fragment | ~240 |
| Marker fragment | ~40 |
| Domain skill (UIKit/SwiftUI) | ~3,000 |
| On-demand prompts | ~500-2,000 mỗi cái |
| Verify scripts (runtime, zero tokens) | 0 |
| **Tổng per session** | **~5,000-7,000** |
| **Before optimization (v1.0)** | **~12,000-15,000** |
| **Tiết kiệm** | **~50-55%** |

## Cấu trúc thư mục

```
Agents/Antigravity/
├── SKILL.md                              # Root skill (bắt đầu từ đây)
├── ttb-skill-registry.md                 # Index tất cả skills
├── README.md / README-VI.md              # Documentation
├── VERSION.md                            # Lịch sử phiên bản
├── AUDIT-REPORT.md                       # Optimization audit
├── export.sh                             # Archive builder
│
├── ttb-skill-init/                       # Khởi tạo dự án (CHẠY TRƯỚC TIÊN)
│   ├── SKILL.md
│   └── prompts/
│       ├── ttb-skill-init.prompt.md
│       ├── ttb-skill-init-structure.prompt.md
│       ├── ttb-skill-init-ttbaseui-kit.prompt.md
│       ├── ttb-skill-init-localization.prompt.md
│       └── ttb-skill-init-debug.prompt.md
│
├── ttb-skill-uikit/                      # UIKit skill (8 commands)
│   ├── SKILL.md
│   └── ttb-skill-*.prompt.md
│
├── ttb-skill-swiftui/                    # SwiftUI skill (6 commands)
│   ├── SKILL.md
│   ├── ttb-skill-sui-screen.prompt.md
│   ├── ttb-skill-sui-view.prompt.md
│   ├── ttb-skill-sui-list.prompt.md
│   ├── ttb-skill-sui-viewmodel.prompt.md
│   ├── ttb-skill-native-screen.prompt.md
│   ├── ttb-skill-native-view.prompt.md
│   └── ttb-ref-ttbasesui.md
│
├── ttb-skill-native-swiftui-components/   # Native SwiftUI (20 commands)
│   ├── SKILL.md
│   ├── refs/
│   │   └── ttb-ref-native-design-tokens.md
│   └── ttb-skill-native-*.prompt.md
│
├── ttb-skill-bugfix/                     # Workflow sửa bug
│   ├── SKILL.md
│   └── ttb-skill-bugfix.prompt.md
│
├── ttb-skill-refactor/                   # Workflow refactor
│   ├── SKILL.md
│   └── ttb-skill-refactor.prompt.md
│
├── ttb-skill-audit/                      # Workflows audit (3 commands)
│   ├── SKILL.md
│   ├── ttb-skill-audit-performance.prompt.md
│   ├── ttb-skill-audit-accessibility.prompt.md
│   └── ttb-skill-audit-localization.prompt.md
│
└── ttb-skill-shared/                     # Tài nguyên dùng chung
    ├── SKILL.md                          # Index tài nguyên dùng chung
    ├── ttb-skill-registry.md             # Skill index + progressive loading
    ├── scripts/
    │   ├── ttb-verify.sh                # 5-layer post-build verification
    │   ├── ttb-compliance-check.sh       # grep-based compliance checks
    │   └── ttb-precheck.sh              # Pre-skill prerequisite gate
    ├── fragments/
    │   ├── ttb-iron-laws.frag.md        # 11 Luật Sắt bắt buộc
    │   └── ttb-marker.frag.md           # Code generation marker
    ├── rules/
    │   ├── ttb-rule-coding-standards.md
    │   ├── ttb-rule-anti-patterns.md
    │   ├── ttb-rule-memory-leaks.md
    │   └── ttb-rule-comments.md
    ├── phases/
    │   ├── ttb-phase-feature-research.md
    │   ├── ttb-phase-feature-spec.md
    │   ├── ttb-phase-implementation.md
    │   ├── ttb-phase-code-review.md
    │   └── ttb-phase-verify.md          # Xác thực sau build BẮT BUỘC
    └── refs/
        ├── ttb-ref-ttbaseuikit.md
        ├── ttb-ref-ttbasesui.md
        ├── ttb-ref-config-tokens.md
        ├── ttb-ref-swiftui-architecture.md
        ├── ttb-ref-swiftui-performance.md
        ├── ttb-ref-ios14-compatibility.md
        └── ttb-ref-navigation.md           # Navigation pattern reference
```

## Development Workflow

```
User Request
    ↓
[1] Feature Research (Phase 1)
    Research scope, UI patterns, API → Report
    ↓
[2] Feature Spec (Phase 2)
    Data model, file structure, navigation, API contract → Approved spec
    ↓
[3] Design (Skill-specific)
    Select component patterns → Design decisions
    ↓
[4] Implementation (Phase 4)
    Generate files one-by-one → xcodebuild verify each
    ↓
[5] Code Review (Phase 5)
    FCR 7-Dimension audit → Issues list
    ↓
[6] Verification (Phase 6) ← BẮT BUỘC
    xcodebuild CLI → Compliance check → Regression guard → FCR score
    ↓
✅ BUILD SUCCEEDED + FCR ≥ 85% → COMPLETE
❌ BUILD FAILED / FCR < 85% → Fix and re-verify
```

## Installation

Xem `Installation/INSTALL.md` để biết hướng dẫn cài đặt.

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0.0 | 2026-05-19 | Full upgrade: 11 Luật Sắt, SUIBaseView + TTBaseNavigationLink bắt buộc, navigation ref, token warnings, three-tier SwiftUI approach, FCR scoring, progressive loading |
| 1.x | 2026 | Initial release |

## Resources

- [Antigravity SKILL.md](SKILL.md) — Full system documentation
- [Tutorial.md](Tutorial.md) — Hướng dẫn sử dụng: khi nào dùng skill nào, ví dụ prompt, practical guide
- [Skill Registry](ttb-skill-registry.md) — All skills index
- [Shared Resources](ttb-skill-shared/SKILL.md) — Phases, rules, refs
- [Installation Guide](Installation/INSTALL.md) — Hướng dẫn cài đặt
