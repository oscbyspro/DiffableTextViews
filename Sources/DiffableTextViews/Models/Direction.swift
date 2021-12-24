//
//  Direction.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-29.
//

// MARK: - Direction

@usableFromInline @frozen enum Direction {
    
    // MARK: Instances
    
    case forwards
    case backwards
}

// MARK: - UIKit

#if canImport(UIKit)

import class UIKit.UIPress
import enum  UIKit.UIKeyboardHIDUsage

// MARK: - Direction: Intent

extension Direction {
    
    // MARK: Initializers
    
    @inlinable static func intent(_ presses: Set<UIPress>) -> Self? {
        presses.first?.key.flatMap({ intentions[$0.keyCode] })
    }
    
    // MARK: Translations
    
    @usableFromInline static let intentions: [UIKeyboardHIDUsage: Self] = [
        .keyboardLeftArrow: .backwards, .keyboardRightArrow: .forwards
    ]
}

#endif
