# Competitive Analysis: Device Screenshot & Recording Tools

**Date:** 2026-03-28

## Category 1: Screen Capture & Annotation (Desktop)

### CleanShot X (Gold Standard)
- **Arrows**: 4 styles incl. curved
- **Step Counter**: Auto-numbered annotations for repro steps
- **Blur/Pixelate**: Secure blur with randomization
- **Shapes**: Rect, filled rect, ellipse, line
- **Text**: 7 predefined styles
- **Spotlight**: Emphasize area by dimming rest of screenshot
- **Highlighter**: Marker-style text highlighting
- **Pencil**: Freehand with auto-smoothing
- **Workflow**: Capture → overlay appears → annotate/copy/save/cloud

### Shottr (Free Alternative)
- Fast, native macOS with OCR text recognition
- Scrolling capture
- Pixel-perfect measurement tools

## Category 2: Bug Reporting Platforms

### Marker.io / BugHerd / Jam.dev
- **Auto-attach metadata**: device model, OS, screen res
- **Auto-repro steps**: Captures user actions before bug
- **Jira integration**: Creates ticket with screenshot + logs + metadata
- **Session replay**: View user session leading to bug
- **Console logs**: Auto-captured with the report

### Key Workflow Pattern
1. Capture screenshot/recording
2. Annotate with arrows, highlights, step numbers
3. Add description (title, severity, priority)
4. Auto-attach device info + environment
5. Export as structured report / create ticket

## Category 3: iOS Screen Mirroring

### QuickTime Player
- Wired USB connection, zero latency
- Movie recording from device as camera source
- Standard macOS tool

### macOS iPhone Mirroring (Sequoia+)
- Native, most responsive
- Mouse/keyboard interaction directly

### Reflector
- Wireless via AirPlay
- Device frames / bezels
- Multi-device simultaneous

## Category 4: In-App Debug Tools

### FLEX (Flipboard Explorer)
- In-app live hierarchy inspection
- Network, data, UI inspector
- No macOS companion needed

### Reveal
- 3D view hierarchy inspection at runtime
- Layout constraint debugging

## Key Insights for TTBDebugPlus

### Must-Have Features (from research)
1. **Step Counter tool** — CleanShot's #1 feature for QA, most requested
2. **Blur/Pixelate** — Essential for hiding sensitive data
3. **Structured bug report** — Title + description + severity + screenshot + device info
4. **Auto device metadata** — Already available via DeviceInfoPayload
5. **Export as Markdown/clipboard** — For pasting into Jira, Linear, GitHub Issues

### Nice-to-Have Features
1. **Spotlight/Highlight tool** — Dim everything except focus area
2. **Comparison view** — Two screenshots side-by-side (before/after)
3. **Measurement/ruler tool** — Pixel-perfect spacing verification
4. **OCR text recognition** — Extract text from screenshots
5. **Pin to desktop** — Keep screenshot floating above other windows

### Recording Limitations
- Current iOS bridge: uses `drawHierarchy` for single-frame screenshot capture
- No ReplayKit integration — true video recording not available via current protocol
- **Realistic approach**: High-frequency screenshot capture (0.5s intervals) + GIF/timelapse export
- Future: Could add ReplayKit on iOS side for true video stream
