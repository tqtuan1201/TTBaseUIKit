# Pattern: Skeleton Loading

## Intent
- Display placeholder shimmer for loading states

## UIKit Building Blocks
- `TTBaseSkeletonMarkView`
- `UIView.getGradientSkeletonLayer()`
- `UIView.onStartSkeletonCustomViewAnimation(...)`

## SwiftUI Building Blocks
- `.skeleton(active:isShimmering:)` in `View+Config+Extension.swift`

## Rules
- Use `TTView.viewBgSkeleton` and gradient tokens
