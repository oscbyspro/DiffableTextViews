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

// MARK: - Direction: UIKit

#if canImport(UIKit)

import class UIKit.UIPress
import enum  UIKit.UIKeyboardHIDUsage

// MARK: - Direction: Intent

extension Direction {
    
    // MARK: Initializers
    
    @inlinable init?(presses: Set<UIPress>) {
        guard let key = presses.first?.key else { return nil }
        guard let direction = Self.intentions[key.keyCode] else { return nil }
        self = direction
    }
    
    // MARK: Translations
    
    @usableFromInline static let intentions: [UIKeyboardHIDUsage: Direction] = [
        .keyboardRightArrow: .forwards,
        .keyboardLeftArrow: .backwards,
    ]
}

#endif
