//
//  File.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 28/7/25.
//

import Foundation
import UIKit
import OSLog

public struct TTBaseJailbreakDetectorConfiguration {

    public var suspiciousFilePaths: [String]?

    public var sandboxFilePaths: [String]?

    public var suspiciousURLs: [String]?

    public var sandboxTestString = "."

    public var haltAfterFailure = true

    public var automaticallyPassSimulator = true

    public var loggingEnabled = false

    public var logType = OSLogType.info

    public static var `default`: TTBaseJailbreakDetectorConfiguration {
        let filePaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/etc/apt",
            "/usr/bin/ssh",
            "/usr/sbin/sshd",
            "/private/var/lib/apt"
        ]

        let sandboxFilesPaths = [
            "/private/jailbreak_detector.txt"
        ]

        let suspiciousURLs = [
            "cydia://package/com.example.package"
        ]

        return TTBaseJailbreakDetectorConfiguration(suspiciousFilePaths: filePaths,
                                              sandboxFilePaths: sandboxFilesPaths,
                                              suspiciousURLs: suspiciousURLs)
    }

    public init(suspiciousFilePaths: [String]? = nil, sandboxFilePaths: [String]? = nil, suspiciousURLs: [String]? = nil) {
        self.suspiciousFilePaths = suspiciousFilePaths
        self.sandboxFilePaths = sandboxFilePaths
        self.suspiciousURLs = suspiciousURLs
    }
    
    
}

public class TTBaseJailbreakDetector {
    public static let shared: TTBaseJailbreakDetector = TTBaseJailbreakDetector()
    private init() {}
    
    public var isSafe: Bool {
        return self.detectJailbreak() == .Pass
    }
    
    public enum FailureReason: CustomStringConvertible {
        case suspiciousFileExists(filePath: String)
        case suspiciousFileIsReadable(filePath: String)
        case appSandbox(filePath: String)
        case suspiciousURLScheme(url: String)

        public var description: String {
            switch self {
            case .suspiciousFileExists(let filePath):
                return "Detected suspicious file at \(filePath)"
            case .suspiciousFileIsReadable(let filePath):
                return "Suspicious file can be opened at \(filePath)"
            case .appSandbox(let filePath):
                return "Able to write outside sandbox to \(filePath)"
            case .suspiciousURLScheme(let url):
                return "Can open suspicious URL scheme \(url)"
            }
        }
    }

    public enum TTBaseJailbreakResult {
        case Pass
        case Jailbreak
        case Simulator
        case MacCatalyst
    }

    private let configuration: TTBaseJailbreakDetectorConfiguration = .default

    private let log = OSLog(subsystem: "com.github.conmulligan.JailbreakDetector", category: "Jailbreak Detection")
    
    private var shouldPassSimulator: Bool {
        #if targetEnvironment(simulator)
        let isSimulator = true
        #else
        let isSimulator = false
        #endif
        return isSimulator && configuration.automaticallyPassSimulator
    }

    private var isMacCatalyst: Bool {
        #if targetEnvironment(macCatalyst)
        return true
        #else
        return false
        #endif
    }

    
    public func detectJailbreak() -> TTBaseJailbreakResult {
        if self.shouldPassSimulator { return .Simulator }
        if self.isMacCatalyst { return .MacCatalyst }
        if let _ = checkSuspiciousFiles(), configuration.haltAfterFailure { return .Jailbreak }
        if let _ = checkAppSandbox(), configuration.haltAfterFailure { return .Jailbreak }
        if let _ = checkSuspiciousURLs(), configuration.haltAfterFailure { return .Jailbreak }
        return .Pass
    }
}

extension TTBaseJailbreakDetector {
    private func checkSuspiciousFiles() -> [FailureReason]? {
        guard let suspiciousFilePaths = configuration.suspiciousFilePaths else { return nil }
        var reasons = [FailureReason]()

        // Check each suspicious file path.
        for path in suspiciousFilePaths {
            // Check if suspicious file exists.
            if FileManager.default.fileExists(atPath: path) {
                let reason = FailureReason.suspiciousFileExists(filePath: path)
                reasons.append(reason)

                if configuration.loggingEnabled {
                    os_log("Check failed: %s", log: log, type: configuration.logType, reason.description)
                }

                if configuration.haltAfterFailure {
                    return reasons
                }
            }

            // Check if suspicious file is readable.
            let file = fopen(path, "r")
            if file != nil {
                fclose(file)
                let reason = FailureReason.suspiciousFileIsReadable(filePath: path)
                reasons.append(reason)

                if configuration.loggingEnabled {
                    os_log("Check failed: %s", log: log, type: configuration.logType, reason.description)
                }

                if configuration.haltAfterFailure {
                    return reasons
                }
            }
        }

        return reasons.isEmpty ? nil : reasons
    }

    private func checkAppSandbox() -> [FailureReason]? {
        guard let sandboxFilePaths = configuration.sandboxFilePaths else { return nil }

        // The failure reasons.
        var reasons = [FailureReason]()

        do {
            // Check each sandbox file path.
            for path in sandboxFilePaths {
                try configuration.sandboxTestString.write(toFile: path, atomically: true, encoding: .utf8)
                try FileManager.default.removeItem(atPath: path)

                let reason = FailureReason.appSandbox(filePath: path)
                reasons.append(reason)

                if configuration.loggingEnabled {
                    os_log("Check failed: %s", log: log, type: configuration.logType, reason.description)
                }

                if configuration.haltAfterFailure {
                    return reasons
                }
            }
        } catch {
            // Ignore error since it's expected in a non-jailbroken context.
        }

        return reasons.isEmpty ? nil : reasons
    }

    private func checkSuspiciousURLs() -> [FailureReason]? {
        guard let suspiciousURLs = configuration.suspiciousURLs else { return nil }

        // The failure reasons.
        var reasons = [FailureReason]()

        // Check each suspicous URL.
        for path in suspiciousURLs {
            if let url = URL(string: path), UIApplication.shared.canOpenURL(url) {
                let reason = FailureReason.suspiciousURLScheme(url: path)
                reasons.append(reason)

                if configuration.loggingEnabled {
                    os_log("Check failed: %s", log: log, type: configuration.logType, reason.description)
                }

                if configuration.haltAfterFailure {
                    return reasons
                }
            }
        }

        return reasons.isEmpty ? nil : reasons
    }
}

