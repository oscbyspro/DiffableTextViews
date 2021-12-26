//
//  &SystemFontValues.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-26.
//

#if canImport(UIKit)

import UIKit
import Utilities

// MARK: - SystemFontValues

/// UIFont configuration object.
///
/// - Adopts current size and weight unless specified.
///
public struct SystemFontValues: Transformable {
    
    // MARK: Properties
    
    @usableFromInline var size: CGFloat?
    @usableFromInline var weight: UIFont.Weight?
    @usableFromInline var make: (CGFloat, UIFont.Weight) -> UIFont
    
    // MARK: Initializers
    
    @inlinable init(_ make: @escaping (CGFloat, UIFont.Weight) -> UIFont) {
        self.size = nil
        self.weight = nil
        self.make = make
    }
    
    // MARK: Transformations
    
    @inlinable func make(template font: UIFont) -> UIFont {
        make(size ?? font.pointSize, weight ?? font.weight)
    }
}

// MARK: - SystemFontValues: Public

public extension SystemFontValues {
    
    // MARK: Transformations
    
    @inlinable func size(_ size: CGFloat) -> Self {
        transforming({ $0.size = size })
    }
    
    @inlinable func weight(_ weight: UIFont.Weight) -> Self {
        transforming({ $0.weight = weight })
    }
    
    @inlinable func monospaced(_ monospace: Monospace = .text) -> Self {
        switch monospace {
        case .text:   return transforming({ $0.make = UIFont.monospacedSystemFont      })
        case .digits: return transforming({ $0.make = UIFont.monospacedDigitSystemFont })
        }
    }
    
    // MARK: Instances
    
    @inlinable static var system: Self {
        .init(UIFont.systemFont)
    }
}

#endif
