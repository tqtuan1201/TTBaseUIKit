//
//  HARExporter.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Export API logs as HAR 1.2 (HTTP Archive) format, compatible with Chrome DevTools & Proxyman
//

import Foundation
import AppKit

// MARK: - HAR Exporter
enum HARExporter {
    
    /// Generate HAR 1.2 JSON string from API log entries
    static func generate(from entries: [APILogPayload], creatorName: String = "TTBDebugPlus", creatorVersion: String = "2.3.0") -> String {
        let harLog = HARLog(
            version: "1.2",
            creator: HARCreator(name: creatorName, version: creatorVersion),
            entries: entries.map { convertEntry($0) }
        )
        let har = HARRoot(log: harLog)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        if let data = try? encoder.encode(har),
           let json = String(data: data, encoding: .utf8) {
            return json
        }
        return "{}"
    }
    
    /// Export and save to file via NSSavePanel
    static func exportToFile(entries: [APILogPayload], suggestedName: String = "session") {
        let harJSON = generate(from: entries)
        
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.json]
        panel.nameFieldStringValue = "\(suggestedName).har"
        panel.title = "Export HAR Archive"
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                try? harJSON.write(to: url, atomically: true, encoding: .utf8)
            }
        }
    }
    
    /// Copy HAR to clipboard
    static func copyToClipboard(entries: [APILogPayload]) {
        let har = generate(from: entries)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(har, forType: .string)
    }
    
    // MARK: - Private Conversion
    
    private static func convertEntry(_ entry: APILogPayload) -> HAREntry {
        let startTime = Date(timeIntervalSince1970: entry.timestamp / 1000)
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        return HAREntry(
            startedDateTime: iso.string(from: startTime),
            time: entry.durationMs,
            request: HARRequest(
                method: entry.method.uppercased(),
                url: entry.url,
                httpVersion: "HTTP/1.1",
                headers: entry.requestHeaders.map { HARHeader(name: $0.key, value: $0.value) },
                queryString: extractQueryParams(from: entry.url),
                postData: entry.requestBody.isEmpty ? nil : HARPostData(
                    mimeType: entry.requestHeaders["content-type"] ?? "application/json",
                    text: entry.requestBody
                ),
                headersSize: -1,
                bodySize: entry.requestBody.utf8.count
            ),
            response: HARResponse(
                status: entry.statusCode,
                statusText: HTTPURLResponse.localizedString(forStatusCode: entry.statusCode),
                httpVersion: "HTTP/1.1",
                headers: entry.responseHeaders.map { HARHeader(name: $0.key, value: $0.value) },
                content: HARContent(
                    size: entry.sizeBytes,
                    mimeType: entry.responseHeaders["content-type"] ?? "application/json",
                    text: entry.responseBody
                ),
                redirectURL: "",
                headersSize: -1,
                bodySize: entry.sizeBytes
            ),
            cache: HARCache(),
            timings: HARTimings(
                send: 0,
                wait: entry.durationMs,
                receive: 0
            )
        )
    }
    
    private static func extractQueryParams(from urlString: String) -> [HARQueryParam] {
        guard let comps = URLComponents(string: urlString) else { return [] }
        return (comps.queryItems ?? []).map { HARQueryParam(name: $0.name, value: $0.value ?? "") }
    }
}

// MARK: - HAR Data Models (1.2 spec)
struct HARRoot: Codable { let log: HARLog }
struct HARLog: Codable { let version: String; let creator: HARCreator; let entries: [HAREntry] }
struct HARCreator: Codable { let name: String; let version: String }

struct HAREntry: Codable {
    let startedDateTime: String
    let time: Double
    let request: HARRequest
    let response: HARResponse
    let cache: HARCache
    let timings: HARTimings
}

struct HARRequest: Codable {
    let method: String; let url: String; let httpVersion: String
    let headers: [HARHeader]; let queryString: [HARQueryParam]
    let postData: HARPostData?
    let headersSize: Int; let bodySize: Int
}

struct HARResponse: Codable {
    let status: Int; let statusText: String; let httpVersion: String
    let headers: [HARHeader]; let content: HARContent
    let redirectURL: String; let headersSize: Int; let bodySize: Int
}

struct HARHeader: Codable { let name: String; let value: String }
struct HARQueryParam: Codable { let name: String; let value: String }
struct HARPostData: Codable { let mimeType: String; let text: String }
struct HARContent: Codable { let size: Int; let mimeType: String; let text: String }
struct HARCache: Codable {}
struct HARTimings: Codable { let send: Double; let wait: Double; let receive: Double }
