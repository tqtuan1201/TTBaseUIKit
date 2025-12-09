//
//  File.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 21/11/25.
//

import Foundation
import SwiftUI
import UIKit


public struct TTBaseUIViewPreview<View: UIView>: UIViewRepresentable {
    public let builder: () -> View

    public init(_ builder: @escaping () -> View) {
        self.builder = builder
    }

    public func makeUIView(context: Context) -> View {
        builder()
    }

    public func updateUIView(_ view: View, context: Context) {}
}

 struct TTBaseUIViewPreview_Previews: PreviewProvider {
     static var previews: some View {
         TTBaseUIViewPreview {
             let testView:TTBaseUIView = TTBaseUIView()
             testView.setBgColor(UIColor.gray.withAlphaComponent(0.2))
             testView.setConerDef()
             
             let v = TTBaseTwoButtonDiffWidthView.init(withText: "Button 01", right: "Button 02")
             v.backgroundColor = TTView.buttonBgWar.withAlphaComponent(0.2)
             
             testView.addSubview(v)
             
             v.setLeadingAnchor(constant: TTSize.P_CONS_DEF).setTrailingAnchor(constant: TTSize.P_CONS_DEF)
                 
        
             return testView
         }
         .size(height: 200.0)
         .padding()
     }
 }


public struct TTBaseUIViewControllerPreview<VC: UIViewController>: UIViewControllerRepresentable {
    public let builder: () -> VC

    public init(_ builder: @escaping () -> VC) {
        self.builder = builder
    }

    public func makeUIViewController(context: Context) -> VC {
        builder()
    }

    public func updateUIViewController(_ vc: VC, context: Context) {}
}

 struct TTBaseUIViewController_Previews: PreviewProvider {
     static var previews: some View {
         TTBaseUIViewControllerPreview {
             let vc = LogTrackingTableViewController()
             return vc
         }
     }
 }

public struct TTBaseCellPreview<Cell: UIView>: UIViewRepresentable {
    public let size: CGSize
    public let builder: () -> Cell

    public init(size: CGSize, _ builder: @escaping () -> Cell) {
        self.size = size
        self.builder = builder
    }

    public func makeUIView(context: Context) -> UIView {
        let cell = builder()
        cell.frame = CGRect(origin: .zero, size: size)
        return cell
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}
}


 struct TTBaseCellPreviewPreview: PreviewProvider {
     static var previews: some View {
         TTBaseCellPreview(size: .init(width: 340, height: 80)) {
             let cell = TTIconTextSubtextTableViewCell()
             cell.panel.setHeightAnchor(constant: 80.0)
             return cell
         }
         .size(height: 80.0)
         .previewLayout(.sizeThatFits)
     }
 }

