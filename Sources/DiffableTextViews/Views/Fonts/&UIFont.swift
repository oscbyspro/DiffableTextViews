//
//  &UIFont.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-26.
//

#if canImport(UIKit)

import UIKit

// MARK: - UIFont

extension UIFont {
    
    // MARK: Getters
    
    @inlinable var weight: UIFont.Weight {
        guard let nsnumber = fontDescriptor.traits[.weight] as? NSNumber else {
            return .regular
        }
        
        return UIFont.Weight(rawValue: nsnumber.doubleValue)
    }
    
    // MARK: Transformations
        
    @inlinable func monospaced(_ monospace: Monospace) -> UIFont {
        adding(attributes: monospace.configuration().attributes())        
    }
    
    // MARK: Transformations: Helpers
    
    @inlinable func with(descriptor: UIFontDescriptor) -> UIFont {
        UIFont(descriptor: descriptor, size: pointSize)
    }
    
    @inlinable func adding(attributes: [UIFontDescriptor.AttributeName: Any]) -> UIFont {
        with(descriptor: fontDescriptor.addingAttributes(attributes))
    }
}

#endif
