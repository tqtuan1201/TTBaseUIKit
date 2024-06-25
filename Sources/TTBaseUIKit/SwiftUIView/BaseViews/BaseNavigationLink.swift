//
//  TTBaseNavigationLink.swift
//
//
//  Created by TuanTruong on 18/10/2023.
//

import Foundation
import SwiftUI
import UIKit

public struct TTBaseNavigationLink<Label, Destination> : View where Label : View, Destination : View {
    
    public let label: () -> Label
    public let destination: () -> Destination
    
    public var isForceBarHidden:Bool = true
    public var isAnimation:Bool = true
    public var isActive: Binding<Bool>? = nil
        
    public init(@ViewBuilder destination: @escaping () -> Destination, @ViewBuilder label: @escaping () -> Label, isForceBarHidden:Bool = true, isAnimation:Bool = true) {
        self.label = label
        self.destination = destination
        self.isForceBarHidden = isForceBarHidden
        self.isAnimation = isAnimation
    }
   
    public init(isActive active:Binding<Bool>,
                @ViewBuilder destination: @escaping () -> Destination,
                @ViewBuilder label: @escaping () -> Label,
                isForceBarHidden:Bool = true,
                isAnimation:Bool = true
    ) {
        self.label = label
        self.destination = destination
        self.isForceBarHidden = isForceBarHidden
        self.isAnimation = isAnimation
        self.isActive = active
    }
    
    
    public var body: some View {
        if let _activeByBinding:Binding<Bool> = self.isActive {
            NavigationLink(isActive: _activeByBinding) {
                self.destination().navigationBarHidden(self.isForceBarHidden)
            } label: {
                self.label()
            }
            .setButtonStyle(isAnimation: self.isAnimation)
            .accentColor(Color.clear)
        } else {
            NavigationLink {
                self.destination().navigationBarHidden(self.isForceBarHidden)
            } label: {
                self.label()
            }
            .setButtonStyle(isAnimation: self.isAnimation)
            .accentColor(Color.clear)
        }
    }
    
}

fileprivate extension NavigationLink {
    
    @ViewBuilder func setButtonStyle(isAnimation:Bool)  -> some View {
        if isAnimation {
            self.buttonStyle(PlainButtonStyle())
        } else {
            self.buttonStyle(NonAnimationButtonStyle())
        }
    }
}
