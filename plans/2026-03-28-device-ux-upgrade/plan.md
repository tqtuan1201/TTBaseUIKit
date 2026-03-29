# Implementation Plan: Device UX Upgrade — Pro Capture & Bug Report

**Date:** 2026-03-28
**Created By:** TuanTruong
**Status:** Draft
**Complexity:** High
**Estimated Effort:** 16-20 hours

## Overview

Overhaul Device view into a professional-grade screen capture, annotation, and bug reporting workstation inspired by CleanShot X, Marker.io, and Shottr. Three core pillars:

1. **Compact Live Preview** — Right-sized preview (not oversized), efficient capture controls
2. **Pro Annotation Editor** — Step counter, blur, spotlight, shapes, text — full-screen overlay
3. **Bug Report Composer** — Structured report with auto-populated device info, export to Markdown/clipboard

## Phases

| # | Phase | Status | File |
|---|-------|--------|------|
| 1 | Compact Layout & Capture Controls | Draft | [phase-01](phase-01-compact-layout.md) |
| 2 | Pro Annotation Editor | Draft | [phase-02](phase-02-pro-annotation.md) |
| 3 | Bug Report Composer | Draft | [phase-03](phase-03-bug-report.md) |
| 4 | Recording & GIF Export | Draft | [phase-04](phase-04-recording-gif.md) |

## Architecture Decision

### Recording Reality Check
- iOS SDK uses `drawHierarchy` per-frame — no ReplayKit video stream
- True 60fps video is infeasible over current WebSocket protocol
- **Decision**: Keep "recording" as rapid screenshot capture (0.3-1.0s intervals) + export as animated GIF or image sequence
- Future: ReplayKit integration is possible but out of scope

### Layout Redesign
- Current: Oversized iPhone bezel (240×480pt) wastes space
- New: Remove decorative bezel, show screenshot at natural aspect ratio with max-height constraint
- Split into 3 zones: Capture Controls (top) | Preview (center) | Gallery (bottom)

## Research
- [Competitive Analysis](research/competitive-analysis.md)
