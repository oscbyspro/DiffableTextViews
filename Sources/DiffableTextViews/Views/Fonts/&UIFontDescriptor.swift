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

    // MARK: Instances
    
    @usableFromInline static let standard = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
}

// MARK: - UIFontDescriptor: Monospace

extension UIFontDescriptor {
    
    // MARK: Transformations
    
    /// [Question](https://stackoverflow.com/questions/46642335)
    @inlinable func monospaced(template: UIFontDescriptor) -> UIFontDescriptor {
        var attributes = fontAttributes
        attributes.removeValue(forKey: .family)
        attributes.removeValue(forKey: .name)
        attributes.removeValue(forKey: .nsctFontUIUsage)
        let descriptor = template.addingAttributes(attributes)
        return descriptor.withSymbolicTraits(symbolicTraits) ?? descriptor
    }
}

// MARK: - UIFontDescriptor.AttributeName

extension UIFontDescriptor.AttributeName {
    @usableFromInline static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

#endif
