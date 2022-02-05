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
// MARK: * Layout
//*============================================================================*

@usableFromInline final class Layout: ObservableObject {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let frame: CGRect
    @usableFromInline var positions: (CGFloat, CGFloat)
    @usableFromInline let positionsLimits: ClosedRange<CGFloat>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ interval: Interval, in proxy: GeometryProxy) {
        self.frame = proxy.frame(in: .local)
        self.positionsLimits = 0...frame.width
        self.positions = map(interval.values.wrappedValue,
        from: interval.valuesLimits, to: positionsLimits)
    }
}

//*============================================================================*
// MARK: * Layout x Access
//*============================================================================*

@usableFromInline protocol HasLayout {
    
    //=------------------------------------------------------------------------=
    // MARK: Layout
    //=------------------------------------------------------------------------=
    
    @inlinable var layout: Layout { get }
}

//=----------------------------------------------------------------------------=
// MARK: Layout x Access - Details
//=----------------------------------------------------------------------------=

extension HasLayout {
    
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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func center(_ x: CGFloat) -> CGPoint {
        CGPoint(x: x, y: frame.midY)
    }
}
