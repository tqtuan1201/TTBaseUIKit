---
applyTo: "**/*API.swift"
---

# API Service File Rules — Project Pattern

## Structure
Every API file is a singleton with `RequestAPI` instance:

```swift
class MyFeatureAPI {
    static let share = MyFeatureAPI()
    fileprivate init() {}
    fileprivate let API: RequestAPI = RequestAPI()
}
```

## GET Request
```swift
func getItems(callback: @escaping (_ objects: [MyModel]?, _ res: ResponseMessage) -> ()) {
    var dataItems = RequestAPIDataItem(service: .NONE, platform: .SERVER,
                                       serviceType: .MY_SERVICE,
                                       dataRequest: RequestData(),
                                       httpMethod: .GET, isAuthorization: true)
    dataItems.isSetHttpBody = false
    dataItems.param = "/items"
    API.sendAsSynToCodable(dataItems) { (object: BaseResponse<[MyModel]>?, mess) in
        callback(object?.value, mess)
    }
}
```

## GET by ID
```swift
func getById(id: Int, callback: @escaping (_ object: MyModel?, _ res: ResponseMessage) -> ()) {
    var dataItems = RequestAPIDataItem(service: .NONE, platform: .SERVER,
                                       serviceType: .MY_SERVICE,
                                       dataRequest: RequestData(),
                                       httpMethod: .GET, isAuthorization: true)
    dataItems.isSetHttpBody = false
    dataItems.param = "/\(id)"
    API.sendAsSynToCodable(dataItems) { (object: BaseResponse<MyModel>?, mess) in
        callback(object?.value, mess)
    }
}
```

## POST Request
```swift
func create(requestData: MyRequestData, callback: @escaping (_ res: ResponseMessage) -> ()) {
    let dataItems = RequestAPIDataItem(service: .CREATE_ITEM, platform: .SERVER,
                                       serviceType: .MY_SERVICE,
                                       dataRequest: requestData,
                                       httpMethod: .POST, isAuthorization: true)
    API.sendAsSynToResponseMessage(dataItems) { res in
        callback(res)
    }
}
```

## PUT Request
```swift
func update(requestData: MyRequestData, callback: @escaping (_ res: ResponseMessage) -> ()) {
    var dataItems = RequestAPIDataItem(service: .UPDATE_ITEM, platform: .SERVER,
                                       serviceType: .MY_SERVICE,
                                       dataRequest: requestData,
                                       httpMethod: .PUT, isAuthorization: true)
    dataItems.isSetHttpBody = true
    API.sendAsSynToCodable(dataItems) { (object: ResponseMessage?, mess: ResponseMessage) in
        callback(mess)
    }
}
```

## DELETE Request
```swift
func delete(id: Int, callback: @escaping (_ res: ResponseMessage) -> ()) {
    var dataItems = RequestAPIDataItem(service: .NONE, platform: .SERVER,
                                       serviceType: .MY_SERVICE,
                                       dataRequest: RequestData(),
                                       httpMethod: .DELETE, isAuthorization: true)
    dataItems.isSetHttpBody = true
    dataItems.param = "/\(id)"
    API.sendAsSynToCodable(dataItems) { (object: ResponseMessage?, mess: ResponseMessage) in
        callback(mess)
    }
}
```

## Key Objects
- `RequestAPIDataItem` — configures URL, method, platform, service type
- `RequestData` — base Encodable class (auto-injects token, uid, platform)
- `BaseResponse<T>` — wraps API response with `.value: T?`
- `ResponseMessage` — status object, check with `.onCheckSuccess()`, get error with `.getDes()`

## RequestData Subclass (POST/PUT body)
```swift
class MyRequestData: RequestData {
    var name: String?
    var amount: Int?

    private enum CodingKeys: String, CodingKey { case name, amount }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)   // ← REQUIRED
        var c = encoder.container(keyedBy: CodingKeys.self)
        try? c.encode(self.name, forKey: .name)
        try? c.encode(self.amount, forKey: .amount)
    }
}
```

## RxSwift Reactive (alternative)
```swift
API.sendAsReactiveToToCodable(dataItems)
    .subscribe(onNext: { (response: MyModel) in ... })
    .disposed(by: disposeBag)
```
