//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import SwiftUI
import UIKit

//*============================================================================*
// MARK: * DiffableTextFont
//*============================================================================*

public struct DiffableTextFont {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    public static let largeTitle:  Self = .preferred(.largeTitle)
    public static let title1:      Self = .preferred(.title1)
    public static let title2:      Self = .preferred(.title2)
    public static let title3:      Self = .preferred(.title3)
    public static let headline:    Self = .preferred(.headline)
    public static let subheadline: Self = .preferred(.subheadline)
    public static let body:        Self = .preferred(.body)
    public static let callout:     Self = .preferred(.callout)
    public static let footnote:    Self = .preferred(.footnote)
    public static let caption1:    Self = .preferred(.caption1)
    public static let caption2:    Self = .preferred(.caption2)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var descriptor: UIFontDescriptor

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ descriptor: UIFontDescriptor) {
        self.descriptor = descriptor
    }
    
    @inlinable public init(_ font: UIFont) {
        self.descriptor = font.fontDescriptor
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func preferred(_ style: UIFont.TextStyle) -> Self {
        Self(UIFont.preferredFont(forTextStyle: style))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func size(_ size: CGFloat) -> Self {
        Self(descriptor.withSize(size))
    }

    @inlinable public func monospaced(_ template: Monospaced = .text) -> Self {
        Self(descriptor.kind(template.descriptor))
    }
    
    //*========================================================================*
    // MARK: * Monospaced
    //*========================================================================*
    
    public struct Monospaced {
        
        //=--------------------------------------------------------------------=
        // MARK: Instances
        //=--------------------------------------------------------------------=
        
        public static let text   = Self(     .monospacedSystemFont(ofSize: .zero, weight: .regular))
        public static let digits = Self(.monospacedDigitSystemFont(ofSize: .zero, weight: .regular))
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let descriptor: UIFontDescriptor
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ base: UIFont) { self.descriptor = base.fontDescriptor }
    }
}

//*============================================================================*
// MARK: * DiffableTextFont x SwiftUI.Font
//*============================================================================*

extension SwiftUI.Font {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ font: DiffableTextFont) {
        self.init(UIFont(font))
    }
}

//*============================================================================*
// MARK: * DiffableTextFont x UIKit.UIFont
//*============================================================================*

extension UIKit.UIFont {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public convenience init(_ font: DiffableTextFont) {
        self.init(descriptor: font.descriptor, size: .zero)
    }
}

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
    
    @usableFromInline static let nsctFontUIUsage =
    UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

#endif
