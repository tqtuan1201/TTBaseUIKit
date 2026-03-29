# Phase 2 — English Localization (macOS App)

**Parent:** [plan.md](./plan.md)
**Priority:** High
**Status:** Draft

## Scope

Vietnamese text found in exactly **2 files**:

### File 1: IntegrationGuideView.swift (main source — bulk of changes)

#### [MODIFY] [IntegrationGuideView.swift](file:///Volumes/DataStore/S.JOB/J.PROJECT/P.BUILD_LIB/TTBaseUIKit/TTBDebugPlus/TTBDebugPlus/Views/Guide/IntegrationGuideView.swift)

**Step 2 title & description (line 173-174):**
- `"⚠️ Configure Info.plist (Bắt buộc)"` → `"⚠️ Configure Info.plist (Required)"`
- `"iOS 14+ yêu cầu khai báo quyền..."` → `"iOS 14+ requires local network access declarations in Info.plist. Missing this step causes 'NoAuth -65555' error when NWBrowser attempts Bonjour scanning."`

**Step 2 code block XML comments (lines 176-186):**
- `"Thêm vào Info.plist của app iOS"` → `"Add to your iOS app's Info.plist"`
- `"Bắt buộc: Mô tả lý do truy cập mạng nội bộ"` → `"Required: Describe why local network access is needed"`
- `"Cần quyền truy cập mạng nội bộ..."` → `"Required for connecting to TTBDebugPlus on macOS to stream debug logs."`
- `"Bắt buộc: Khai báo Bonjour service type"` → `"Required: Declare Bonjour service type"`

**Step 2 note (line 189):**
- `"⚠️ QUAN TRỌNG: Nếu thiếu 2 keys..."` → `"⚠️ IMPORTANT: Without these 2 keys, iOS will block NWBrowser with a NoAuth error. After adding them, delete the app from the device and Build & Run again so iOS shows the permission prompt."`

**Step 6 note (line 273):**
- `"Khi chạy lần đầu..."` → `"On first run on a physical device, iOS will show a 'Allow local network access' popup — tap Allow."`

**Troubleshooting section (lines 287-349) — all 6 items:**

| Line | Vietnamese | English |
|------|-----------|---------|
| 287 | `"Lỗi NoAuth (-65555) — Thiếu quyền Local Network"` | `"NoAuth (-65555) — Missing Local Network Permission"` |
| 288 | explanation | iOS 14+ requires... |
| 289 | solution | 1. Open Info.plist → Add... |
| 299 | `"Lỗi posixError(57)..."` | `"posixError(57) — Socket Connection Failed"` |
| 300-301 | explanation + solution | English |
| 308 | `"Không tìm thấy thiết bị"` | `"No device found"` |
| 311-313 | title + explanation + solution | English |
| 323-325 | connection drops | English |
| 332-337 | logs stop | English |
| 344-349 | production safety | English |

**Helper function (line 407):**
- `"Cách xử lý:"` → `"Solution:"`

---

### File 2: Info.plist (Example App)

#### [MODIFY] [Info.plist](file:///Volumes/DataStore/S.JOB/J.PROJECT/P.BUILD_LIB/TTBaseUIKit/TTBaseUIKitExample/TTBaseUIKitExample/Info.plist)

**Line 51:**
- `"Cần quyền truy cập mạng nội bộ để kết nối và gửi log đến TTBDebugPlus trên macOS."` → `"Required for connecting to TTBDebugPlus on macOS to stream debug logs."`

## Verification

- [ ] `grep` for Vietnamese diacriticals returns zero results across entire `TTBDebugPlus/` directory
- [ ] `grep` for Vietnamese diacriticals returns zero results in `TTBaseUIKitExample/Info.plist`
- [ ] macOS app builds and runs without errors
- [ ] Integration Guide tab displays correctly with all English text

## Success Criteria

- All user-visible text in the macOS app is in English
- All code comments/examples in IntegrationGuideView are in English
- Example app Info.plist uses English description
