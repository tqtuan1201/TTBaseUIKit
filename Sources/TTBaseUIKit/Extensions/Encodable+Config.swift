//
//  File.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 8/7/25.
//

import Foundation

// MARK: - 1. Pretty print *any* Encodable as JSON
public extension Encodable {
    /// Prints the receiver as indented JSON (or `debugDescription` if it fails).
    /// - Parameters:
    ///   - prefix: String in front of every line (default ➜ emoji for eye-catching)
    ///   - file, function, line: Auto-filled call-site for quick navigation
    /// - Note: Call from anywhere: `user.pp()` or `viewModel.state.pp("STATE")`
    func prettyPrint(_ prefix: String = "👀 TTBaseUIKit prettyPrint",  // “pretty print”
            file: String = #file,
            function: String = #function,
            line: Int = #line)
    {
        let tag = "[\(URL(fileURLWithPath: file).lastPathComponent):\(line)]"
        let json: String

        if let data = try? JSONEncoder.pretty.encode(self),
           let string = String(data: data, encoding: .utf8)
        {
            json = string
        } else {         // fallback to mirror dump
            json = String(describing: self)
        }

        print("\(prefix) \(tag) \(function):\n\(json)\n")
    }
}

// MARK: - 2. JSONEncoder convenience
private extension JSONEncoder {
    static var pretty: JSONEncoder {
        let enc = JSONEncoder()
        enc.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        return enc
    }
}

// MARK: - 3. Fallback for *non-Encodable* types (e.g. UIView)
public func pp(_ value: Any,
               _ prefix: String = "👀",
               file: String = #file,
               function: String = #function,
               line: Int = #line)
{
    let tag = "[\(URL(fileURLWithPath: file).lastPathComponent):\(line)]"
    debugPrint("\(prefix) \(tag) \(function):")
    dump(value, maxDepth: 4, maxItems: 20)
    print("–––")
}


