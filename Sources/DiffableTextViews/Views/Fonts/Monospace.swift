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
        
        public static let text   = Self(type: kTextSpacingType,   selector: kMonospacedTextSelector)
        public static let digits = Self(type: kNumberSpacingType, selector: kMonospacedNumbersSelector)
    }
}

#endif
