//
//  &UIFontDescriptor.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-26.
//

#if canImport(UIKit)

import UIKit

// MARK: - UIFontDescriptor

extension UIFontDescriptor {
    
    // MARK: Getters
    
    @inlinable var traits: [UIFontDescriptor.TraitKey: Any] {
        object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any] ?? [:]
    }
    
    // MARK: Transformations
    
    @inlinable func adding(monospacing: Monospace) -> UIFontDescriptor {
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
