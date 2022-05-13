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

struct Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let bounds: CGRect
    let limits: ClosedRange<CGFloat>
    var positions: (CGFloat, CGFloat)

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ values: Values, in bounds: CGRect) {
        self.bounds = bounds
        self.limits = 0...bounds.width
        self.positions = Context.map(
        values.remote.wrappedValue, from: values.limits, to: limits)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    func position(_ item: WritableKeyPath<(CGFloat, CGFloat), CGFloat>) -> CGPoint {
        CGPoint(x: positions[keyPath: item], y: bounds.midY)
    }
}
