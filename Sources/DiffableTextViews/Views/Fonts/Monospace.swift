//
//  Monospace.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-26.
//

#if canImport(UIKit)

import UIKit

// MARK: - Monospace

public enum Monospace {
    
    // MARK: Instances
    
    case text
    case digits
    
    // MARK: Utilities
    
    @inlinable func configuration() -> Configuration {
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
        
        // MARK: Utilities
        
        @inlinable func attributes() -> [UIFontDescriptor.AttributeName: Any] {
            [UIFontDescriptor.AttributeName.featureSettings: [[
                UIFontDescriptor.FeatureKey.type: type,
                UIFontDescriptor.FeatureKey.selector: selector
            ]]]
        }
        
        // MARK: Instances
        
        public static let text   = Self(type: kTextSpacingType,   selector: kMonospacedTextSelector)
        public static let digits = Self(type: kNumberSpacingType, selector: kMonospacedNumbersSelector)
    }
}

#endif
