//
//  ParamConfig.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 26/11/25.
//

import Foundation

/// A container for library-wide behavioral parameters.
///
/// ParamConfig centralizes tweakable runtime parameters used across TTBaseUIKit
/// features. You can provide a customized instance via TTBaseUIKitConfig to
/// adjust default behaviors without scattering constants throughout your code.
///
/// Typical usage:
/// - Create a ParamConfig, set desired values
/// - Pass it into TTBaseUIKitConfig.withDefaultConfig(..., params:)
/// - Retrieve it later with TTBaseUIKitConfig.getParamConfig()
open class ParamConfig {

    /// The delay window, in hours, before considering an App Store version as "eligible" for in-app update prompts.
    ///
    /// When checking for a new version, TTBaseCheckNewVersion compares the App Store
    /// release date of the version with the current time plus this delay. If the release
    /// is newer than this threshold, the check will not trigger a "has new version" result yet.
    ///
    /// Default: 24 (one day)
    public var delayTimeCheckNewVersion: Int = 24
    
    /// Whether the app should enforce an update when a newer version is detected.
    ///
    /// Set to true to indicate your UI logic should prevent dismissal or require users
    /// to update immediately when TTBaseCheckNewVersion reports a newer version.
    /// This flag is not enforced by TTBaseCheckNewVersion itself; it is intended
    /// for consumers to decide presentation behavior (e.g., blocking dialogs).
    ///
    /// Default: false
    public var forceUpdateNewVersion: Bool = false
    public var isGetNewVersionMessageByAppStore: Bool = true
    
    
    public var appId: String = ""
    
    public var country: String = ""
    
    
    
    /// Creates a new ParamConfig with default values.
    public init() {}
}
