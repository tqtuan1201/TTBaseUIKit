---
name: "ttb-router-examples"
description: "Routing examples and expected skill selections for Antigravity semantic routing."
version: "1.0.0"
date_updated: "2026-05-22"
risk: "safe"
source: "internal"
tags: ["routing", "examples", "qa", "multilingual"]
---

# Router Examples

Use these examples as regression tests for prompt routing.

| User Prompt | Expected Route | Confidence | Reason |
|-------------|----------------|------------|--------|
| `/ttb-uikit-api create login service` | `/ttb-uikit-api` | 1.00 | Explicit command |
| `tạo api login` | `/ttb-uikit-api` | 0.88 | Vietnamese API intent |
| `tao api login` | `/ttb-uikit-api` | 0.88 | Diacritic-free Vietnamese |
| `viet api auth` | `/ttb-uikit-api` | 0.84 | Shorthand API intent |
| `generate auth api` | `/ttb-uikit-api` | 0.90 | English API intent |
| `build endpoint for products` | `/ttb-uikit-api` | 0.82 | Endpoint maps to RequestAPI service |
| `create ProductDetail UIKit screen` | `/ttb-uikit-screen` | 0.91 | UIKit + screen artifact |
| `tạo màn hình danh sách SwiftUI` | `/ttb-sui-list` | 0.89 | SwiftUI + list artifact |
| `tao man hinh swiftui` | `/ttb-sui-screen` | 0.87 | Diacritic-free SwiftUI screen |
| `make native SwiftUI rating component` | `/ttb-native-rating` | 0.90 | Native component artifact |
| `fix crash when tapping checkout` | `/ttb-bugfix` | 0.91 | Crash symptom |
| `sửa lỗi UI không update` | `/ttb-bugfix` | 0.86 | Bug symptom in Vietnamese |
| `refactor raw UIKit labels to TTBaseUIKit` | `/ttb-refactor-uikit` | 0.88 | Migration intent |
| `audit localization keys` | `/ttb-audit-localization` | 0.90 | Audit type explicit |
| `kiểm tra hiệu năng màn hình ProductList` | `/ttb-audit-performance` | 0.86 | Performance audit intent |
| `create screen` | clarify | 0.62 | Framework missing |
| `clean up bug in API` | `/ttb-bugfix` then maybe `/ttb-refactor` | 0.78 | Bug term wins before cleanup |

## Regression Rule

Any future routing change must keep these examples stable unless `intent-manifest.json` documents a deliberate migration.
