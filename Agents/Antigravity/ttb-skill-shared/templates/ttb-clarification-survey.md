---
name: "ttb-clarification-survey"
description: "Standard clarification survey patterns for Antigravity preflight gating."
version: "1.0.0"
date_updated: "2026-05-22"
risk: "safe"
source: "internal"
tags: ["survey", "clarification", "requirements", "multilingual"]
---

# Antigravity Clarification Survey Template

Use this template when the preflight confidence is below `70`, requirements are missing, or ambiguity is high.

## Rules

- Ask briefly.
- Prefer multiple choice.
- Group related questions.
- Do not ask what can be discovered from the local codebase.
- Prioritize architecture-critical, behavior-critical, and UX-critical gaps.
- Match the user's language when practical. Vietnamese, English, and mixed-language prompts are all valid.

## Standard Survey Blocks

### Screen / UI Work

1. Target implementation?
   - Existing module pattern
   - UIKit + TTViewCodable
   - SwiftUI + SUIBaseView
   - Native SwiftUI component only

2. Navigation behavior?
   - Push
   - Modal
   - Full-screen modal
   - Existing flow handles navigation

3. Data source?
   - Existing API
   - New API contract provided
   - Mock/static data
   - No data source yet

4. States required?
   - Loading + success + error + empty
   - Success + error only
   - Static UI only

### API / Backend Call Work

1. API contract source?
   - Existing endpoint pattern
   - New endpoint details provided
   - Mock until contract exists

2. Request/response structure?
   - Use existing models
   - Create new Codable models
   - User will provide schema

3. Error handling?
   - Existing `ResMess`/project pattern
   - Custom mapping required
   - Unknown, inspect project first

### Navigation Work

1. Source and destination?
   - Existing source screen to existing destination
   - Existing source screen to new destination
   - New flow

2. Ownership?
   - Existing Coordinator
   - New Coordinator required
   - SwiftUI `TTBaseNavigationLink`
   - Unknown, inspect project first

### Refactor / Migration Work

1. Allowed behavior change?
   - No behavior change
   - Behavior change is expected and specified
   - Unsure, clarify before editing

2. Scope?
   - Single file
   - Single module
   - Cross-module
   - Architecture-level

3. Migration target?
   - TTViewCodable
   - TTBaseUIKit components
   - TTBaseSUI/SUIBaseView
   - Native SwiftUI fallback

### Bugfix Work

1. Evidence available?
   - Error log/stack trace
   - Reproduction steps
   - Failing test/build output
   - Only behavior description

2. Expected behavior?
   - Restore previous behavior
   - Match a new requirement
   - Unknown, clarify before editing

## Vietnamese Short Form

```text
Mình cần xác nhận vài điểm trước khi sửa để tránh sai kiến trúc:

1. Mục tiêu triển khai:
- Theo pattern module hiện có
- UIKit + TTViewCodable
- SwiftUI + SUIBaseView
- Native SwiftUI component

2. Điều hướng:
- Push
- Modal
- Full screen
- Flow hiện có xử lý

3. Dữ liệu:
- API hiện có
- API mới đã có contract
- Mock/static
- Chưa có API
```

## English Short Form

```text
I need to confirm a few architecture-critical points before editing:

1. Target implementation:
- Existing module pattern
- UIKit + TTViewCodable
- SwiftUI + SUIBaseView
- Native SwiftUI component

2. Navigation:
- Push
- Modal
- Full screen
- Existing flow owns it

3. Data:
- Existing API
- New API contract is ready
- Mock/static data
- No API yet
```
