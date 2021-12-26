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
    
    // MARK: Instances
    
    @usableFromInline static let standard: UIFontDescriptor = {
        UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
    }()
}

// MARK: - UIFontDescriptor: Monospace

extension UIFontDescriptor {
    
    // MARK: Transformations
    
    @inlinable func monospaced(_ monospace: Monospace) -> UIFontDescriptor {
        monospaced(template: monospace.template)
    }
    
    // MARK: Transformations: Helpers
    
    @inlinable func monospaced(template: UIFontDescriptor) -> UIFontDescriptor {
        // https://stackoverflow.com/questions/46642335/how-do-i-get-a-monospace-font-that-respects-acessibility-settings
        var attributes = fontAttributes
        attributes.removeValue(forKey: .family)
        attributes.removeValue(forKey: .name)
        attributes.removeValue(forKey: .nsctFontUIUsage)
        return template.addingAttributes(attributes).withSymbolicTraits(symbolicTraits) ?? template
    }
}

// MARK: - UIFontDescriptor.AttributeName

extension UIFontDescriptor.AttributeName {
    @usableFromInline static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

#endif
