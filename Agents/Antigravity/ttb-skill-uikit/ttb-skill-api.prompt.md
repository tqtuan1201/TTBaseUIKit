---
description: "Scaffold a new API service singleton with GET/POST/PUT/DELETE methods and RequestData."
---

# ttb-skill-api -- API Service Builder

Scaffold a new API service singleton using RequestAPI.

## Mandatory Preflight Execution Gate

Before generating code or modifying files, run `ttb-skill-shared/fragments/ttb-preflight-execution-gate.frag.md`.

Required checks:

- Analyze intent, task type, scope, impacted files/modules, dependencies, architecture constraints, coding standards, and project-specific rules.
- Validate required inputs such as target module, screen/component name, file location, navigation flow, expected output, API contract, state management, routing, localization, naming, and reusable component requirements.
- Detect ambiguity, conflicting requirements, incomplete business logic, unclear UX/navigation, unclear module ownership, and unclear architecture direction.
- Score confidence from `0-100`: execute at `90-100`, execute with warning assumptions at `70-89`, and ask a survey below `70` using `ttb-skill-shared/templates/ttb-clarification-survey.md`.
- Support English, Vietnamese, mixed-language, diacritic-free Vietnamese, and light typo prompts.

## When

User says: "build API", "new service", "add API endpoint"

## Pattern

```swift
// [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  {Name}API.swift
//  {AppName}
//

import Foundation

// --- Request Data ---
class {Name}RequestData: RequestData {
    var fieldA: String?
    var fieldB: Int?

    private enum CodingKeys: String, CodingKey {
        case fieldA, fieldB
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var c = encoder.container(keyedBy: CodingKeys.self)
        try? c.encode(self.fieldA, forKey: .fieldA)
        try? c.encode(self.fieldB, forKey: .fieldB)
    }
}

// --- API Singleton ---
class {Name}API {
    static let share = {Name}API()
    fileprivate init() {}
    fileprivate let API: RequestAPI = RequestAPI()
}

extension {Name}API {
    // GET list
    func getAll(callback: @escaping (_ objects: [{Name}Model]?, _ res: ResponseMessage) -> ()) {
        var dataItems = RequestAPIDataItem(
            service: .NONE,
            platform: .SERVER,
            serviceType: .{SERVICE_TYPE},
            dataRequest: RequestData(),
            httpMethod: .GET,
            isAuthorization: true
        )
        dataItems.isSetHttpBody = false
        dataItems.param = "/{endpoint}"
        API.sendAsSynToCodable(dataItems) { (object: BaseResponse<[{Name}Model]>?, mess) in
            callback(object?.value, mess)
        }
    }

    // GET single
    func getById(id: Int, callback: @escaping (_ object: {Name}Model?, _ res: ResponseMessage) -> ()) {
        var dataItems = RequestAPIDataItem(
            service: .NONE,
            platform: .SERVER,
            serviceType: .{SERVICE_TYPE},
            dataRequest: RequestData(),
            httpMethod: .GET,
            isAuthorization: true
        )
        dataItems.isSetHttpBody = false
        dataItems.param = "/{endpoint}/\(id)"
        API.sendAsSynToCodable(dataItems) { (object: BaseResponse<{Name}Model>?, mess) in
            callback(object?.value, mess)
        }
    }

    // POST create
    func create(requestData: {Name}RequestData, callback: @escaping (_ res: ResponseMessage) -> ()) {
        let dataItems = RequestAPIDataItem(
            service: .{SERVICE_NAME},
            platform: .SERVER,
            serviceType: .{SERVICE_TYPE},
            dataRequest: requestData,
            httpMethod: .POST,
            isAuthorization: true
        )
        API.sendAsSynToResponseMessage(dataItems) { res in
            callback(res)
        }
    }

    // PUT update
    func update(requestData: {Name}RequestData, callback: @escaping (_ res: ResponseMessage) -> ()) {
        let dataItems = RequestAPIDataItem(
            service: .{SERVICE_NAME},
            platform: .SERVER,
            serviceType: .{SERVICE_TYPE},
            dataRequest: requestData,
            httpMethod: .PUT,
            isAuthorization: true
        )
        dataItems.isSetHttpBody = true
        API.sendAsSynToResponseMessage(dataItems) { res in
            callback(res)
        }
    }

    // DELETE
    func delete(id: Int, callback: @escaping (_ res: ResponseMessage) -> ()) {
        var dataItems = RequestAPIDataItem(
            service: .NONE,
            platform: .SERVER,
            serviceType: .{SERVICE_TYPE},
            dataRequest: RequestData(),
            httpMethod: .DELETE,
            isAuthorization: true
        )
        dataItems.isSetHttpBody = true
        dataItems.param = "/{endpoint}/\(id)"
        API.sendAsSynToCodable(dataItems) { (object: ResponseMessage?, mess: ResponseMessage) in
            callback(mess)
        }
    }
}
```

## Rules

1. **Singleton**: `static let share = API()`
2. **RequestData**: always subclass `RequestData`, not `Encodable`
3. **super.encode(to:)**: always call first in `RequestData`
4. **isAuthorization**: set `true` for authenticated endpoints
5. **Response**: always wrapped in `BaseResponse<T>`, access via `.value`
6. **Success check**: callers must check `resMess.onCheckSuccess()`
7. **NEVER import UIKit** in API class

## Post-Implementation Verification (MANDATORY)

After all files are generated, **run Phase 6 verification**:

1. **Add files to Xcode project** — ensure each `.swift` is registered in `project.pbxproj`
2. **Run verification**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-verify.sh
   ```
3. **Check compliance**:
   ```bash
   bash ttb-skill-shared/scripts/ttb-compliance-check.sh
   ```
4. **Skill is complete only when** `BUILD SUCCEEDED`

**Anti-Loop**: Max 3 build attempts. 3 failures — STOP, document errors.

For full FCR 7-Dimension scoring, see `ttb-skill-shared/phases/ttb-phase-verify.md`.
