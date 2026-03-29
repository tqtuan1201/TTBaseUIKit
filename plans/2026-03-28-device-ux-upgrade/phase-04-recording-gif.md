# Phase 4: Recording & GIF Export

> Parent: [plan.md](plan.md) | Depends on: Phase 1

**Date:** 2026-03-28
**Created By:** TuanTruong
**Status:** Draft
**Priority:** P1 — Enhancement
**Implementation Status:** Pending
**Review Status:** Pending

## Key Insights

Real video recording requires ReplayKit on iOS side — out of scope for current protocol. The practical approach is rapid screenshot capture + export formats.

Current "recording" captures screenshots at 2s intervals — too slow for meaningful animation. We need 0.3-0.5s intervals for smooth GIF output.

## Requirements

1. **Faster capture rate** — Configurable 0.3s to 5s intervals
2. **GIF export** — Assemble captured frames into animated GIF
3. **Image sequence export** — Export as numbered PNG files in a folder
4. **Recording session management** — Start/stop with visual feedback
5. **Timelapse mode** — Capture at long intervals, play back as fast animation
6. **Frame preview** — Scrub through recorded frames like video timeline

## Architecture

### Recording Flow

```
Start Recording
    │
    ├── Set interval (0.3s default for GIF, 2-5s for timelapse)
    ├── Begin timer-based rapid screenshot requests
    ├── Accumulate ScreenshotItems in recording session
    ├── Show frame count + elapsed time + recording dot
    │
Stop Recording
    │
    ├── Session complete: N frames captured
    ├── Show export options:
    │   ├── Export as GIF (with speed control)
    │   ├── Export as Image Sequence (folder of PNGs)
    │   └── Discard session
    │
    └── GIF Assembly:
        ├── Use CGImageDestination with kUTTypeGIF
        ├── Configure frame delay from interval
        └── Save to file, offer share
```

### GIF Assembly (macOS native)

```swift
import ImageIO
import UniformTypeIdentifiers

func createGIF(from frames: [NSImage], frameDelay: Double) -> URL? {
    let url = FileManager.default.temporaryDirectory
        .appendingPathComponent("TTBDebug_\(Int(Date().timeIntervalSince1970)).gif")
    
    guard let destination = CGImageDestinationCreateWithURL(
        url as CFURL, UTType.gif.identifier as CFString, frames.count, nil
    ) else { return nil }
    
    let gifProperties = [kCGImagePropertyGIFDictionary: [
        kCGImagePropertyGIFLoopCount: 0
    ]]
    CGImageDestinationSetProperties(destination, gifProperties as CFDictionary)
    
    let frameProperties = [kCGImagePropertyGIFDictionary: [
        kCGImagePropertyGIFDelayTime: frameDelay
    ]]
    
    for frame in frames {
        if let cgImage = frame.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            CGImageDestinationAddImage(destination, cgImage, frameProperties as CFDictionary)
        }
    }
    
    CGImageDestinationFinalize(destination)
    return url
}
```

## Related Code Files

- `ViewModels/ScreenCaptureViewModel.swift` — Add recording session state, GIF export
- `Views/Device/RecordingExportView.swift` — NEW: post-recording export sheet
- `Views/Device/DeviceView.swift` — Recording controls in toolbar

## Implementation Steps

### 1. Recording session model
```swift
struct RecordingSession {
    var frames: [ScreenshotItem]
    var startTime: Date
    var interval: TimeInterval
    var isActive: Bool
}
```

### 2. Faster capture intervals
- Minimum 0.3s interval (practical floor for base64 JPEG over WebSocket)
- Reduce JPEG quality during recording (0.4 vs 0.7 for static captures)
- Smaller maxWidth during recording (750 vs 1170) for bandwidth

### 3. GIF export
- Use native `CGImageDestination` API (no dependencies)
- Configurable playback speed (0.5x, 1x, 2x)
- Show progress during assembly

### 4. Export sheet
- Post-recording dialog with frame scrubber
- Preview first/last frame
- Export buttons: GIF, Image Sequence, Share
- Frame count + duration display

### 5. Frame timeline scrubber
- Horizontal slider to scrub through captured frames
- Shows frame number and timestamp
- Click frame to view full-size

## Todo

- [ ] RecordingSession model
- [ ] Faster intervals (0.3s min, reduced quality/width)
- [ ] GIF assembly using CGImageDestination
- [ ] RecordingExportView sheet
- [ ] Frame timeline scrubber
- [ ] Export as image sequence (folder of PNGs)
- [ ] Playback speed control for GIF
- [ ] Progress indicator during export

## Success Criteria

- GIF created from 10+ frames plays smoothly
- Export sheet shows frame count, duration, preview
- Image sequence creates correctly numbered files
- Recording at 0.3s intervals works without overwhelming WebSocket

## Risk Assessment

- **Medium**: 0.3s interval may be too fast for WebSocket — may need throttle
- **Low**: GIF assembly via CGImageDestination is well-documented macOS API
- **Low**: Image sequence is just file writing
