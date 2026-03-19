---
description: "Scaffold a new API service singleton with GET/POST/PUT/DELETE methods and RequestData"
---

# Create New API Service

Scaffold a new API service file following the project's singleton pattern.

## Steps

1. Ask for feature/service name (if not given)
2. Create `{Name}API.swift` with:

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
import Foundation

// --- Request Data (if POST/PUT needed) ---
class {Name}RequestData: RequestData {
    var fieldA: String?
    var fieldB: Int?

    private enum CodingKeys: String, CodingKey { case fieldA, fieldB }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var c = encoder.container(keyedBy: CodingKeys.self)
        try? c.encode(self.fieldA, forKey: .fieldA)
        try? c.encode(self.fieldB, forKey: .fieldB)
    }
}

// --- API Singleton ---
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
class {Name}API {
    static let share = {Name}API()
    fileprivate init() {}
    fileprivate let API: RequestAPI = RequestAPI()
}

extension {Name}API {
    // GET list
    func getAll(callback: @escaping (_ objects: [{Name}Model]?, _ res: ResponseMessage) -> ()) {
        var dataItems = RequestAPIDataItem(service: .NONE, platform: .SERVER,
                                           serviceType: .{SERVICE_TYPE},
                                           dataRequest: RequestData(),
                                           httpMethod: .GET, isAuthorization: true)
        dataItems.isSetHttpBody = false
        dataItems.param = "/{endpoint}"
        API.sendAsSynToCodable(dataItems) { (object: BaseResponse<[{Name}Model]>?, mess) in
            callback(object?.value, mess)
        }
    }

    // POST create
    func create(requestData: {Name}RequestData, callback: @escaping (_ res: ResponseMessage) -> ()) {
        let dataItems = RequestAPIDataItem(service: .{SERVICE_NAME}, platform: .SERVER,
                                           serviceType: .{SERVICE_TYPE},
                                           dataRequest: requestData,
                                           httpMethod: .POST, isAuthorization: true)
        API.sendAsSynToResponseMessage(dataItems) { res in callback(res) }
    }
}
```

3. Confirm service type and endpoint before writing

## Plan Output (MANDATORY)

After completing any work, generate a plan file for future context:

1. Create `plans/YYYY-MM-DD-{feature-name}/plan.md`
2. Include: date, goal, files table (NEW/MODIFY/DELETE), patterns & tokens used, context for future upgrades
3. Auto-add plan file to Xcode:
```bash
ruby .agent/skills/ttbase-swiftui/scripts/add_to_xcode_project.rb "{plan_file_path}"
```

> See `instructions/plan-generation.instructions.md` for full templates.
