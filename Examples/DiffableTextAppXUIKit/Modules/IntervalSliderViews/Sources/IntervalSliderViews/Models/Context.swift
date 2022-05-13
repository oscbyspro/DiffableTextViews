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
// MARK: Declaration
//*============================================================================*

final class Context {
    typealias Tuple  = (CGFloat, CGFloat)
    typealias Limits = ClosedRange<CGFloat>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let values: Values
    let layout: Layout
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ values: Values, _ layout: Layout) {
        self.values = values
        self.layout = layout
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var coordinates: UInt8 { 0 }
        
    var animation: Animation {
        .linear(duration: 0.125)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    static func map(_ value: CGFloat, from start: Limits,  to end: Limits) -> CGFloat {
        if  start.lowerBound == start.upperBound { return  end.lowerBound }
        let ratio = (end.upperBound - end.lowerBound) / (start.upperBound - start.lowerBound)
        let proposal = end.lowerBound + ratio * (value - start.lowerBound)
        return min(max(end.lowerBound, proposal), end.upperBound)
    }

    static func map(_ value: Tuple, from start: Limits, to end: Limits) -> Tuple {(
        self.map(value.0, from: start, to: end),
        self.map(value.1, from: start, to: end)
    )}
}
