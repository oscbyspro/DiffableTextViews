//
//  OBEFont.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-26.
//

#if canImport(UIKit)

import UIKit
import SwiftUI

// MARK: - OBEFont

#warning("WIP")
public struct OBEFont {
    
    // MARK: Properties
    
    @usableFromInline var descriptor: UIFontDescriptor

    // MARK: Initializers
    
    @inlinable public init(_ descriptor: UIFontDescriptor) {
        self.descriptor = descriptor
    }
    
    @inlinable public init(_ font: UIFont) {
        self.descriptor = font.fontDescriptor
    }
    
    // MARK: Internal
    
    @inlinable func makeUIFont() -> UIFont {
        .init(descriptor: descriptor, size: .zero)
    }
    
    // MARK: Transformations
    
    @inlinable public func size(_ size: CGFloat) -> Self {
        .init(descriptor.withSize(size))
    }
        
    @inlinable public func monospaced(_ monospace: Monospace = .text) -> Self {
        .init(descriptor.monospaced(monospace))
    }
    
    // MARK: Instances
    
    public static let largeTitle:  Self = .preffered(style: .largeTitle)
    public static let title1:      Self = .preffered(style: .title1)
    public static let title2:      Self = .preffered(style: .title2)
    public static let title3:      Self = .preffered(style: .title3)
    public static let headline:    Self = .preffered(style: .headline)
    public static let subheadline: Self = .preffered(style: .subheadline)
    public static let body:        Self = .preffered(style: .body)
    public static let callout:     Self = .preffered(style: .callout)
    public static let footnote:    Self = .preffered(style: .footnote)
    public static let caption1:    Self = .preffered(style: .caption1)
    public static let caption2:    Self = .preffered(style: .caption2)
    
    // MARK: Instances: Helpers
    
    @inlinable static func preffered(style: UIFont.TextStyle) -> Self {
        .init(UIFont.preferredFont(forTextStyle: style))
    }
}

#endif
