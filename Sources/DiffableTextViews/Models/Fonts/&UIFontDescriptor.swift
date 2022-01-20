//
//  &UIFontDescriptor.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-26.
//

#if canImport(UIKit)

import UIKit

//*============================================================================*
// MARK: * UIFontDescriptor
//*============================================================================*

extension UIFontDescriptor {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=--------------------------------------------------------------------=
    
    /// [Inspiration](https://stackoverflow.com/questions/46642335)
    @inlinable func kind(_ template: UIFontDescriptor) -> UIFontDescriptor {
        var attributes = fontAttributes
        attributes.removeValue(forKey: .family)
        attributes.removeValue(forKey: .name)
        attributes.removeValue(forKey: .nsctFontUIUsage)
        let descriptor = template.addingAttributes(attributes)
        return descriptor.withSymbolicTraits(symbolicTraits) ?? descriptor
    }
}

//*============================================================================*
// MARK: * UIFontDescriptor.AttributeName
//*============================================================================*

extension UIFontDescriptor.AttributeName {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

#endif
