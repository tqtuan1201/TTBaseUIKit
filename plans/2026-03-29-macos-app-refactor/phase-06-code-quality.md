# Phase 06: Code Quality & Performance

**Parent Plan:** [plan.md](plan.md)
**Dependencies:** Phase 01–05
**Date:** 2026-03-29
**Created By:** TuanTruong
**Priority:** P2 — Medium
**Status:** ⬜ TODO
**Review:** ⬜ Pending

## Overview

Final polish pass: migrate remaining `@StateObject`/`ObservableObject` to `@Observable`, optimize memory usage, add performance monitoring, and ensure code consistency.

## Key Insights

- `AppState` uses `ObservableObject` + `@StateObject` — should migrate to `@Observable`
- `ConnectionManager` already uses `@Observable` — good
- Some ViewModels use `ObservableObject` — inconsistent
- Large in-memory log arrays (up to 10000 entries) need ring buffer
- NotificationCenter usage can be replaced with direct state binding
- Preview providers should cover all major views

## Requirements

1. Migrate all `ObservableObject` to `@Observable` macro
2. Replace NotificationCenter patterns with direct state/callbacks
3. Implement ring buffer for log storage (avoid array growth)
4. Add memory usage monitoring for self-diagnostics
5. Ensure all previews work in Xcode
6. Remove dead code and unused imports

## Implementation Steps

1. **Migrate AppState** from `ObservableObject` → `@Observable`
   - Update all `@EnvironmentObject` → `@Environment(AppState.self)`
   - Remove `@Published` wrappers
2. **Migrate ViewModels** that still use `ObservableObject`
   - `ConsoleViewModel`, `FeedbackViewModel`, `PerformanceViewModel`
   - `NetworkViewModel`
3. **Replace NotificationCenter usage**
   - `.clearConsole`, `.captureScreenshot`, `.exportSession`
   - Use direct method calls via Environment
4. **Optimize log storage**
   - Implement `RingBuffer<T>` for console/API logs
   - Configurable capacity (from Settings `maxLogEntries`)
   - Automatic oldest-entry eviction
5. **Performance audit**
   - Profile with Time Profiler
   - Check for unnecessary view body recomputations
   - Add `Equatable` conformance to model structs
   - Use `@State` for locally-scoped state only
6. **Code cleanup**
   - `swiftlint` or manual pass for unused imports
   - Remove `#if os(macOS)` guards (this is macOS-only app)
   - Consistent file header comments
   - Ensure all previews compile

## Todo List

- [ ] Migrate `AppState` to `@Observable`
- [ ] Update all `@EnvironmentObject` → `@Environment`
- [ ] Migrate remaining ViewModels to `@Observable`
- [ ] Remove NotificationCenter patterns
- [ ] Create `RingBuffer<T>` utility
- [ ] Replace `Array.append` with ring buffer in ConnectionManager
- [ ] Remove `#if os(macOS)` guards
- [ ] Remove unused imports
- [ ] Verify all previews compile
- [ ] Profile with Instruments

## Success Criteria

- [ ] Zero `ObservableObject` remaining (all `@Observable`)
- [ ] Zero NotificationCenter usage for internal communication
- [ ] Log storage uses ring buffer with configurable capacity
- [ ] All preview providers work in Xcode
- [ ] No compiler warnings
- [ ] Memory usage stable under sustained log ingestion

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| @Observable migration breaks bindings | Medium | High | Migrate one file at a time, test |
| Ring buffer breaks existing log display | Low | Medium | Keep old implementation as fallback |
| Preview failures | Low | Low | Fix iteratively |
