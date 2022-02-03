//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI

//*============================================================================*
// MARK: * Layoutable
//*============================================================================*

@usableFromInline protocol Layoutable {
    
    //=------------------------------------------------------------------------=
    // MARK: Storage
    //=------------------------------------------------------------------------=
    
    @inlinable var layout: Layout { get }
}

//=----------------------------------------------------------------------------=
// MARK: Layoutable - Details
//=----------------------------------------------------------------------------=

extension Layoutable {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
        
    @inlinable var frame: CGRect {
        layout.frame
    }
    
    @inlinable var positions: (CGFloat, CGFloat) {
        layout.positions
    }
    
    @inlinable var positionsLimits: ClosedRange<CGFloat> {
        layout.positionsLimits
    }
}
