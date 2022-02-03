//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

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
