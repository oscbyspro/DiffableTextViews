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
// MARK: * ProxyTextField x Keyboard
//*============================================================================*

public extension ProxyTextField.Keyboard {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func appearance(_ appearance: UIKeyboardAppearance) {
        wrapped.keyboardAppearance = appearance
    }
    
    @inlinable func submit(_ submit: UIReturnKeyType) {
        wrapped.returnKeyType = submit
    }
    
    @inlinable func view(_ keyboard: UIKeyboardType) {
        wrapped.keyboardType = keyboard
    }
}

#endif
