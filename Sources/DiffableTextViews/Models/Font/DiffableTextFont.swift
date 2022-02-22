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
    
    public static let largeTitle:  Self = .preferred(style: .largeTitle)
    public static let title1:      Self = .preferred(style: .title1)
    public static let title2:      Self = .preferred(style: .title2)
    public static let title3:      Self = .preferred(style: .title3)
    public static let headline:    Self = .preferred(style: .headline)
    public static let subheadline: Self = .preferred(style: .subheadline)
    public static let body:        Self = .preferred(style: .body)
    public static let callout:     Self = .preferred(style: .callout)
    public static let footnote:    Self = .preferred(style: .footnote)
    public static let caption1:    Self = .preferred(style: .caption1)
    public static let caption2:    Self = .preferred(style: .caption2)
    
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
    
    @inlinable static func preferred(style: UIFont.TextStyle) -> Self {
        Self(UIFont.preferredFont(forTextStyle: style))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func size(_ size: CGFloat) -> Self {
        Self(descriptor.withSize(size))
    }

    @inlinable public func monospaced(_ template: MonospaceTemplate = .text) -> Self {
        Self(descriptor.kind(template.descriptor))
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

#endif
