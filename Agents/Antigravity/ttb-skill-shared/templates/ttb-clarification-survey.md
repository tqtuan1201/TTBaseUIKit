---
name: "ttb-clarification-survey"
description: "Standard clarification and value-expansion survey patterns for Antigravity preflight gating."
version: "1.1.0"
date_updated: "2026-05-30"
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
- For feature updates, new feature development, and bug fixes, include at least 5 value-expansion questions after the initial analysis.
- If the request is ambiguous/incomplete, ask at least 6 blocker clarification questions before design or development.

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

### Value-Expansion Questions

Ask at least 5 after analyzing feature/update/bug work:

1. Can the target flow be shortened or made safer for the user?
2. Are there adjacent actions, confirmations, or recovery paths that would create more value?
3. Which loading, empty, error, offline, or retry states should be improved with this change?
4. Should analytics, logging, monitoring, or QA hooks be added to validate the outcome?
5. Are accessibility, localization, personalization, or notification behaviors expected?

### Ambiguity Clarification Questions

Ask at least 6 and stop before design/development when requirements are incomplete:

1. What is the business goal, priority, and acceptance criteria?
2. Who is the target user and what exact UX/navigation flow should they follow?
3. What data model, persistence, migration, or lifecycle behavior is required?
4. What API contracts, integrations, failure modes, or offline behavior must be supported?
5. What security, permission, privacy, or abuse-case constraints apply?
6. What performance, scalability, device/version, concurrency, and edge-case scenarios must be handled?

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
