//
//  OBEFont.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-26.
//

#if canImport(UIKit)

import UIKit

// MARK: - OBEFont

public struct OBEFont {
    
    // MARK: Instances
    
    public static let largeTitle:  Self = .preferred(style: .largeTitle)
    public static let title1:      Self = .preferred(style: .title1)
    public static let title2:      Self = .preferred(style: .title2)
    public static let title3:      Self = .preferred(style: .title3)
    public static let headline:    Self = .preferred(style: .headline)
    public static let subheadline: Self = .preferred(style: .subheadline)
    public static let body:        Self = .preferred(style: .body)
    public static let callout:     Self = .preferred(style: .callout)
    public static let footnote:    Self = .preferred(style: .footnote)
    public static let caption1:    Self = .preferred(style: .caption1)
    public static let caption2:    Self = .preferred(style: .caption2)
    
    // MARK: Properties
    
    @usableFromInline var descriptor: UIFontDescriptor

    // MARK: Initializers
    
    @inlinable public init(_ descriptor: UIFontDescriptor) {
        self.descriptor = descriptor
    }
    
    @inlinable public init(_ font: UIFont) {
        self.descriptor = font.fontDescriptor
    }
    
    // MARK: Initializers: Static
    
    @inlinable static func preferred(style: UIFont.TextStyle) -> Self {
        .init(.preferredFont(forTextStyle: style))
    }
    
    // MARK: Conversions
    
    @inlinable func makeUIFont() -> UIFont {
        .init(descriptor: descriptor, size: .zero)
    }
    
    // MARK: Transformations
    
    @inlinable public func size(_ size: CGFloat) -> Self {
        .init(descriptor.withSize(size))
    }

    @inlinable public func monospaced(_ template: MonospaceTemplate = .text) -> Self {
        .init(descriptor.monospaced(template: template.descriptor))
    }
}

#endif
