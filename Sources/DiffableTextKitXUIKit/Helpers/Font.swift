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
// MARK: * Font
//*============================================================================*

/// A SwiftUI-esque system font representation compatible with UIFont.
public struct DiffableTextFont {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let standard: Self = .body.monospaced()
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=

    #if !os(tvOS)
    public static let largeTitle  = Self.preferred(.largeTitle)
    #endif
    public static let title1      = Self.preferred(.title1)
    public static let title2      = Self.preferred(.title2)
    public static let title3      = Self.preferred(.title3)
    public static let headline    = Self.preferred(.headline)
    public static let subheadline = Self.preferred(.subheadline)
    public static let body        = Self.preferred(.body)
    public static let callout     = Self.preferred(.callout)
    public static let footnote    = Self.preferred(.footnote)
    public static let caption1    = Self.preferred(.caption1)
    public static let caption2    = Self.preferred(.caption2)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var descriptor: UIFontDescriptor

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ descriptor: UIFontDescriptor) {
        self.descriptor = descriptor
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func preferred(_ style: UIFont.TextStyle) -> Self {
        Self(UIFont.preferredFont(forTextStyle: style).fontDescriptor)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable public func monospaced() -> Self {
        Self(descriptor.withDesign(.monospaced)!)
    }
    
    @inlinable public func size(_ size: CGFloat) -> Self {
        Self(descriptor.withSize(size))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UIKit
//=----------------------------------------------------------------------------=

extension UIKit.UIFont {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public convenience init(_ font: DiffableTextFont) {
        self.init(descriptor: font.descriptor, size: 0)
    }
}

#endif
