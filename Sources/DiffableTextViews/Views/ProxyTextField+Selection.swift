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

public final class ProxyTextField_Selection {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let wrapped: BasicTextField
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ wrapped: BasicTextField) { self.wrapped = wrapped }
}

//=----------------------------------------------------------------------------=
// MARK: + Setters
//=----------------------------------------------------------------------------=

public extension ProxyTextField_Selection {
    
    //=------------------------------------------------------------------------=
    // MARK: Color
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
