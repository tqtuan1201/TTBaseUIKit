//
//  JSONConvertView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Format converter: JSON ↔ YAML, XML, CSV
//

import SwiftUI

struct JSONConvertView: View {
    let jsonString: String
    @State private var selectedFormat: ConvertFormat = .yaml
    @State private var convertResult: ConvertResult?
    @State private var isCopied: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header bar
            convertHeader
            
            Divider().background(Color.ttBorder.opacity(0.2))
            
            if jsonString.isEmpty {
                emptyState
            } else if let result = convertResult {
                if let error = result.error {
                    errorState(error)
                } else {
                    resultView(result.output)
                }
            } else {
                loadingState
            }
        }
        .background(Color.ttBackground)
        .onChange(of: selectedFormat) { _, _ in
            convert()
        }
        .onChange(of: jsonString) { _, _ in
            convert()
        }
        .onAppear {
            convert()
        }
    }
    
    // MARK: - Header
    private var convertHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: "arrow.triangle.swap")
                .font(.ttIcon(TTIcon.lg))
                .foregroundColor(.ttPrimary)
            
            Text("Convert JSON to:")
                .font(TTFont.labelMedium)
                .foregroundColor(.ttTextSecondary)
            
            // Format picker
            HStack(spacing: 2) {
                ForEach(ConvertFormat.allCases.filter { $0 != .json }) { format in
                    Button(action: { selectedFormat = format }) {
                        HStack(spacing: 4) {
                            Image(systemName: format.icon)
                                .font(.ttIcon(TTIcon.sm))
                            Text(format.rawValue)
                                .font(TTFont.labelSmall)
                        }
                        .foregroundColor(selectedFormat == format ? .white : .ttTextTertiary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(selectedFormat == format ? Color.ttPrimary.opacity(0.5) : Color.clear)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Spacer()
            
            // Copy
            Button(action: copyResult) {
                HStack(spacing: 3) {
                    Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                        .font(.ttIcon(TTIcon.sm))
                    Text(isCopied ? "Copied" : "Copy")
                        .font(TTFont.labelSmall)
                }
                .foregroundColor(isCopied ? .ttSuccess : .ttTextSecondary)
            }
            .buttonStyle(.ttGhost)
            .disabled(convertResult?.isSuccess != true)
            
            // Save
            Button(action: saveResult) {
                HStack(spacing: 3) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.ttIcon(TTIcon.sm))
                    Text("Save")
                        .font(TTFont.labelSmall)
                }
                .foregroundColor(.ttTextSecondary)
            }
            .buttonStyle(.ttGhost)
            .disabled(convertResult?.isSuccess != true)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
    
    // MARK: - Result
    private func resultView(_ output: String) -> some View {
        ScrollView([.horizontal, .vertical]) {
            Text(output)
                .font(TTFont.codeMedium)
                .foregroundColor(.ttTextPrimary)
                .textSelection(.enabled)
                .fixedSize(horizontal: true, vertical: false)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: - States
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "arrow.triangle.swap")
                .font(TTFont.heading1)
                .foregroundColor(.ttTextTertiary)
            Text("No JSON data to convert")
                .font(TTFont.labelMedium)
                .foregroundColor(.ttTextSecondary)
            Text("Enter or paste JSON in the Editor tab first")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorState(_ error: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(TTFont.heading1)
                .foregroundColor(.ttWarning)
            Text("Conversion Error")
                .font(TTFont.labelMedium)
                .foregroundColor(.ttWarning)
            Text(error)
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var loadingState: some View {
        HStack(spacing: 8) {
            ProgressView().scaleEffect(0.6)
            Text("Converting...")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Actions
    
    private func convert() {
        guard !jsonString.isEmpty else {
            convertResult = nil
            return
        }
        
        let input = jsonString
        let format = selectedFormat
        Task.detached(priority: .userInitiated) {
            let result: ConvertResult
            switch format {
            case .yaml: result = JSONConvertEngine.toYAML(input)
            case .xml: result = JSONConvertEngine.toXML(input)
            case .csv: result = JSONConvertEngine.toCSV(input)
            case .json: result = ConvertResult(output: input, error: nil)
            }
            
            await MainActor.run {
                convertResult = result
            }
        }
    }
    
    private func copyResult() {
        guard let output = convertResult?.output else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(output, forType: .string)
        isCopied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { isCopied = false }
    }
    
    private func saveResult() {
        guard let output = convertResult?.output else { return }
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "data.\(selectedFormat.fileExtension)"
        panel.begin { response in
            if response == .OK, let url = panel.url {
                try? output.write(to: url, atomically: true, encoding: .utf8)
            }
        }
    }
}
