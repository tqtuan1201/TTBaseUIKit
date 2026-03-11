# Pattern: Dashboard Layout

## Intent
- Combine header, summary cards, and content lists

## UIKit Building Blocks
- `TTBaseUIViewController`
- `TTBaseShadowPanelView` for summary cards
- `TTBaseUITableView` for content

## SwiftUI Building Blocks
- `TTBaseSUIVStack`
- `TTBaseSUIHStack`
- `TTBaseSUIView` for cards

## Rules
- Use `TTSize.P_M` or `TTSize.P_L` for outer padding
- Use `TTView.viewDefColor` for base background
