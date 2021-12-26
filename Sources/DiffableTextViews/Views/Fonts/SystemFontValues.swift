//
//  &UIFont.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-26.
//

#if canImport(UIKit)

import UIKit
import Utilities

// MARK: - SystemFontValues

public struct SystemFontValues: Transformable {
    
    // MARK: Properties
    
    @usableFromInline var size: CGFloat?
    @usableFromInline var weight: UIFont.Weight?
    @usableFromInline var instruction: (CGFloat, UIFont.Weight) -> UIFont
    
    // MARK: Initializers
    
    @inlinable init(_ instruction: @escaping (CGFloat, UIFont.Weight) -> UIFont) {
        self.size = nil
        self.weight = nil
        self.instruction = instruction
    }
    
    // MARK: Transformations
    
    @inlinable func make(template font: UIFont) -> UIFont {
        instruction(size ?? font.pointSize, weight ?? font.weight)
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
    
    // MARK: Instances
    
    @inlinable static var standard: Self {
        .init(UIFont.systemFont)
    }
    
    @inlinable static func monospaced(_ monospacing: Monospace = .text) -> Self {
        switch monospacing {
        case .text:   return .init(UIFont.monospacedSystemFont)
        case .digits: return .init(UIFont.monospacedDigitSystemFont)
        }
    }
}

#endif
