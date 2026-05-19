//
//  SetupDevicesViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 13/5/26.
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//

import Foundation
import Combine

@MainActor
class SetupDevicesViewModel: ObservableObject {
    @Published var isDeviceConfirmed = false

    func toggleCheckbox() {
        isDeviceConfirmed.toggle()
    }

    func continueToNextStep() {
        // Handle continue to next step
        print("Continue to next step - Device confirmed: \(isDeviceConfirmed)")
    }
}
