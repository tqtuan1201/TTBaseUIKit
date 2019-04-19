//
//  UITableView+UICollectionView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/18/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation


/// Easier way to create cell identifier
public protocol ReusableView: class {
    /// Get identifier from class
    static var defaultReuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        // Set the Identifier from class name
        return NSStringFromClass(self)
    }
}

/// Extend to easier allow for identifier to be set without much work
extension UITableView {
    
    /// Register cell with automatically setting Identifier
    public func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    /// Get cell with the default reuse cell identifier
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell: \(T.self) with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
}

/// Extend to easier allow for identifier to be set without much work
extension UICollectionView {
    
    /// Register cell with automatically setting Identifier
    public func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    /// Get cell with the default reuse cell identifier
    public func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("Could not dequeue cell: \(T.self) with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
}
