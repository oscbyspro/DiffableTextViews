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
// MARK: * Contents
//*============================================================================*

public extension ProxyTextField {
    typealias Keyboard = ProxyTextField_Keyboard
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var _keyboard: Keyboard {
        .init(wrapped)
    }
}

//*============================================================================*
// MARK: * ProxyTextField x Keyboard
//*============================================================================*

public final class ProxyTextField_Keyboard {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let wrapped: BasicTextField
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ wrapped: BasicTextField) { self.wrapped = wrapped }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func appearance(_ appearance: UIKeyboardAppearance) {
        wrapped.keyboardAppearance = appearance
    }

    @inlinable public func kind(_ keyboard: UIKeyboardType) {
        wrapped.keyboardType = keyboard
    }
    
    @inlinable public func submit(_ submit: UIReturnKeyType) {
        wrapped.returnKeyType = submit
    }
}

#endif
