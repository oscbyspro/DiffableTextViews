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
}

#endif
