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
// MARK: * ProxyTextField x Selection
//*============================================================================*

public extension ProxyTextField.Selection {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var marked: String {
        wrapped.text(in: wrapped.markedTextRange!)!
    }
    
    @inlinable var value: String {
        wrapped.text(in: wrapped.selectedTextRange!)!
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func color(_ color: UIColor) {
        wrapped.tintColor = color
    }

    @inlinable func color(mode: UIView.TintAdjustmentMode) {
        wrapped.tintAdjustmentMode = mode
    }
    
    @inlinable func color(_ color: UIColor, mode: UIView.TintAdjustmentMode) {
        self.color(color); self.color(mode: mode)
    }
}

#endif
