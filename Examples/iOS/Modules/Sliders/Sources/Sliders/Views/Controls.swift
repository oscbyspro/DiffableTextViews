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
// MARK: * Controls
//*============================================================================*

@usableFromInline struct Controls: View, HasContext {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let context: Context
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ interval: Interval, in proxy: GeometryProxy) {
        self.context = Context(interval, proxy: proxy)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    @inlinable var body: some View {
        ZStack {
            Beam(context, between: layout.positions)
            Handle(context, value: values.projectedValue.0, position: positions.0)
            Handle(context, value: values.projectedValue.1, position: positions.1)
        }
        .coordinateSpace(name: coordinates)
    }
}
