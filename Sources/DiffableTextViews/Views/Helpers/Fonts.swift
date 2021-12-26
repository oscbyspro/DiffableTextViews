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
    
    @inlinable static func monospaced(_ monospacing: Monospacing = .text) -> Self {
        switch monospacing {
        case .text:   return .init(UIFont.monospacedSystemFont)
        case .digits: return .init(UIFont.monospacedDigitSystemFont)
        }
    }
}

// MARK: - Monospacing

public enum Monospacing {
    
    // MARK: Instances
    
    case text
    case digits
    
    // MARK: Getters
    
    @inlinable var configuration: Configuration {
        switch self {
        case .text:   return .text
        case .digits: return .digits
        }
    }

    // MARK: Components
    
    public struct Configuration {
        
        // MARK: Properties
        
        @usableFromInline let type: Int
        @usableFromInline let selector: Int
        
        // MARK: Initializers
        
        @inlinable init(type: Int, selector: Int) {
            self.type = type
            self.selector = selector
        }
        
        // MARK: Instances
        
        public static let text   = Self(type: kTextSpacingType,   selector: kMonospacedNumbersSelector)
        public static let digits = Self(type: kNumberSpacingType, selector: kMonospacedNumbersSelector)
    }
}

// MARK: - UIFont

extension UIFont {
    
    // MARK: Getters
    
    @inlinable var weight: UIFont.Weight {
        guard let weightNumber = traits[.weight] as? NSNumber else {
            return .regular
        }
        
        return UIFont.Weight(rawValue: CGFloat(weightNumber.doubleValue))
    }

    @inlinable var traits: [UIFontDescriptor.TraitKey: Any] {
        fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any] ?? [:]
    }
    
    // MARK: Transformations
    
    @inlinable func monospaced(using monospacing: Monospacing) -> UIFont {
        UIFont(descriptor: fontDescriptor.adding(monospacing: monospacing), size: pointSize)
    }
}

// MARK: - UIFontDescriptor

extension UIFontDescriptor {
    
    // MARK: Transformations
    
    @inlinable func adding(monospacing: Monospacing) -> UIFontDescriptor {
        let configuration = monospacing.configuration
        
        return addingAttributes([
            UIFontDescriptor.AttributeName.featureSettings: [[
                UIFontDescriptor.FeatureKey.type: configuration.type,
                UIFontDescriptor.FeatureKey.selector: configuration.selector
            ]]
        ])
    }
}

#endif
