---
name: "ttb-phase-feature-spec"
description: "Phase 2 of TTBaseUIKit feature workflow: generate detailed specification with data model, file structure, navigation, and API contract."
version: "2.0.0"
---

# ttb-phase-feature-spec — Feature Spec Phase

## Purpose

Generate detailed specification: data model, file structure, navigation, API contract.

## Input
- Feature Research output
- User clarification

## Steps

### 1. Define Data Model
- List all data fields needed
- Identify Codable types
- Map to API response structure
- Design RequestData if POST/PUT needed

### 2. Define Screen Structure
- List all screens needed
- For each screen: name, type (UIKit/SwiftUI), components, navigation
- Define navigation flow (who calls whom, push/present)
- **SwiftUI screens must use SUIBaseView wrapper**
- **Navigation between screens must use TTBaseNavigationLink**

### 3. Define API Contract
- Endpoints needed (GET/POST/PUT/DELETE)
- Request body structure (RequestData)
- Response structure (BaseResponse<[Model]>)
- Error handling approach

### 4. Define File Structure
```
{Feature}/
├── Coordinators/
│   └── {Name}Coordinator.swift
├── ViewControllers/        ← UIKit
│   └── {Name}ViewController.swift
├── Screens/               ← SwiftUI
│   ├── {Name}Screen.swift
│   └── Components/
│       └── {Name}ItemView.swift
├── ViewModels/
│   ├── {Name}ViewModel.swift
│   └── {Name}ListViewModel.swift
├── Models/
│   └── {Name}Model.swift
├── APIs/
│   └── {Name}API.swift
├── CustomViews/
│   ├── {Name}Cell.swift
│   └── {Name}CardView.swift
└── Resources/
    └── Localizable.strings (new keys)
```

### 5. List Localization Keys
- All `XText`/`XTextU` keys
- Format: `"App.{Module}.{Screen}.{Element}" = "Default Value";`

## Output

```
## Feature Spec — {FeatureName}

### Data Model
```swift
// {Name}Model.swift
struct {Name}Model: Codable {
    var id: Int?
    var title: String?
    var subtitle: String?
}
```

### Screen Structure
[Screens with SUIBaseView wrapper]

### Navigation Flow
[Diagram with TTBaseNavigationLink]

### API Contract
[Endpoints]

### Localization Keys
```
"App.{Module}.{Screen}.Nav.Title" = "Title";
"App.{Module}.{Screen}.Button.Submit" = "Submit";
```

### Complexity
[LOW/MEDIUM/HIGH] — [N] files to create
```

## Rules
- Every spec item must map to existing TTBaseUIKit patterns
- Every SwiftUI screen must have a SUIBaseView wrapper plan
- Every navigation must have a TTBaseNavigationLink plan
- Every screen must have a navigation strategy
- Every API call must have error handling
- Every user-facing string must have a localization key
