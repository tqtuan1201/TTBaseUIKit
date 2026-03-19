---
applyTo: "**/*Model.swift,**/Model/**/*.swift"
---

# Model File Rules — Codable Patterns

## Response Model (from API)
```swift
struct MyModel: Codable {
    var id: Int?
    var name: String?
    var status: String?
    var createdDate: String?
    var items: [SubItemModel]?

    enum CodingKeys: String, CodingKey {
        case id, name, status, createdDate, items
    }
}
```

## Model Rules
- Always use `struct` + `Codable` for response models
- All properties should be `var` and optional (`?`) — API may return null
- Always declare `CodingKeys` enum for explicit mapping
- Nested models should also be `Codable`

## BaseResponse Wrapper
API responses are wrapped: `BaseResponse<MyModel>`, access via `.value`
```swift
// In API callback:
API.sendAsSynToCodable(dataItems) { (object: BaseResponse<MyModel>?, mess) in
    let myModel = object?.value   // the actual model
}
```

## Request Data (POST/PUT body)
```swift
class MyRequestData: RequestData {
    var fieldA: String?
    var fieldB: Int?

    private enum CodingKeys: String, CodingKey { case fieldA, fieldB }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)   // ← always call super
        var c = encoder.container(keyedBy: CodingKeys.self)
        try? c.encode(self.fieldA, forKey: .fieldA)
        try? c.encode(self.fieldB, forKey: .fieldB)
    }
}
```

## Enum in Model
```swift
enum StatusCode: String, Codable {
    case active = "ACTIVE"
    case inactive = "INACTIVE"
    case pending = "PENDING"
}
```

## Date Fields
Dates come as `String` from API. Parse with:
```swift
let date = dateString?.toDate(withFormat: .YYYY_MM_DD_T_HH_MM_SSSSSS_Z)
```
