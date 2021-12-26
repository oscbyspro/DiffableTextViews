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
    
    @inlinable func monospaced(using monospacing: Monospace) -> UIFont {
        UIFont(descriptor: fontDescriptor.adding(monospacing: monospacing), size: pointSize)
    }
}

#endif
