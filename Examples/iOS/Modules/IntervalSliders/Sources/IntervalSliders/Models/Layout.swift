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
    
    @inlinable init(_ storage: Storage, in proxy: GeometryProxy) {
        self.frame = proxy.frame(in: .local)
        self.positionsLimits = 0...frame.width
        self.positions = map(storage.values.wrappedValue,
        from: storage.valuesLimits, to: positionsLimits)
    }
}
