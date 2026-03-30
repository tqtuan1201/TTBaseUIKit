//
//  LogInterceptor.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 2026-03-27.
//  Hooks into LogViewHelper to intercept logs and forward to TTDebugBridge
//

import Foundation

// MARK: - Log Interceptor
/// Intercepts logs from LogViewHelper and forwards them to the TTDebugBridge
/// for transmission to the macOS debug companion app.
///
/// Call `LogInterceptor.install()` once during app setup to begin intercepting.
public final class LogInterceptor {
    
    public static let shared = LogInterceptor()
    private var isInstalled = false
    
    private init() {}
    
    // MARK: - Install
    /// Swizzle or hook LogViewHelper.add(withLog:) to intercept log entries.
    /// Since we can't swizzle in Swift directly, we use a wrapper approach.
    public func install() {
        guard !isInstalled else { return }
        isInstalled = true
        TTBaseFunc.shared.printLog(object: "[TTDebugBridge] 📝 Log interceptor installed")
    }
    
    // MARK: - Intercept API Log
    /// Called when a new API log is added. Call this from your network layer
    /// after creating the LogViewModel.
    ///
    /// Compatible with the existing RequestAPI.swift pattern:
    /// ```swift
    /// let log = LogViewModel(withName: name, request: request, response: response, urlRequest: urlRequest)
    /// LogViewHelper.share.add(withLog: log)
    /// LogInterceptor.shared.interceptAPILog(log, statusCode: statusCode, method: method, url: url, durationMs: duration)
    /// ```
    public func interceptAPILog(
        _ log: LogViewModel,
        statusCode: Int = 200,
        method: String = "GET",
        url: String = "",
        durationMs: Double = 0
    ) {
        // No state guard here — sendMessage dispatches to queue for thread safety.
        // Messages are buffered if not connected.
        TTDebugBridge.shared.sendAPILog(
            method: method,
            url: url,
            statusCode: statusCode,
            requestHeaders: [:],
            requestBody: log.request,
            responseHeaders: [:],
            responseBody: log.response,
            durationMs: durationMs,
            sizeBytes: log.response.utf8.count
        )
    }
    
    public func interceptConsoleLog(
        message: String,
        level: String = "debug",
        subsystem: String = "app",
        file: String = #file,
        line: Int = #line
    ) {
        // No state guard here — sendMessage dispatches to queue for thread safety.
        // Messages are buffered if not connected.
        let fileName = (file as NSString).lastPathComponent
        TTDebugBridge.shared.sendConsoleLog(
            level: level,
            subsystem: subsystem,
            message: message,
            sourceFile: fileName,
            sourceLine: line
        )
    }
}

// MARK: - XPrint Override
/// Drop-in replacement for print() that also sends to debug bridge
public func TTBPrint(
    _ items: Any...,
    level: String = "debug",
    subsystem: String = "app",
    separator: String = " ",
    terminator: String = "\n",
    file: String = #file,
    line: Int = #line
) {
    let message = items.map { "\($0)" }.joined(separator: separator)
    
    // Standard console output
    print(message, terminator: terminator)
    
    // Forward to debug bridge
    LogInterceptor.shared.interceptConsoleLog(
        message: message,
        level: level,
        subsystem: subsystem,
        file: file,
        line: line
    )
}
