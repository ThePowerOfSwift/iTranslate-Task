//
//  Reusable.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 22/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit

// MARK: Protocol definition

/// Make your `UITableViewCell` and `UICollectionViewCell` subclasses
/// conform to this protocol when they are *not* NIB-based but only code-based
/// to be able to dequeue them in a type-safe manner
public protocol Reusable: class {
  /// The reuse identifier to use when registering and later dequeuing a reusable cell
  static var reuseIdentifier: String { get }
}

/// Make your `UITableViewCell` and `UICollectionViewCell` subclasses
/// conform to this typealias when they *are* NIB-based
/// to be able to dequeue them in a type-safe manner
public typealias NibReusable = Reusable & NibLoadable

// MARK: - Default implementation

public extension Reusable {
  /// By default, use the name of the class as String for its reuseIdentifier
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}
