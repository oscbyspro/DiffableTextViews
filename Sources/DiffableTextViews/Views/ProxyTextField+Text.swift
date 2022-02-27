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
// MARK: * ProxyTextField x Text
//*============================================================================*

public final class ProxyTextField_Text {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let wrapped: BasicTextField
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ wrapped: BasicTextField) { self.wrapped = wrapped }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var value: String {
        wrapped.text! // force unwrapping is OK
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Appearance
    //=------------------------------------------------------------------------=

    @inlinable public func color(_ color: UIColor) {
        wrapped.textColor = color
    }

    @inlinable public func font(_ font: UIFont) {
        wrapped.font = font
    }
    
    @inlinable public func font(_ font: DiffableTextFont) {
        wrapped.font = UIFont(font)
    }

    //=------------------------------------------------------------------------=
    // MARK: System
    //=------------------------------------------------------------------------=
    
    @inlinable public func content(_ content: UITextContentType) {
        wrapped.textContentType = content
    }
}

#endif
