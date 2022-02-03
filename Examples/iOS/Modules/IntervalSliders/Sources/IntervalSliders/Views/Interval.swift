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
// MARK: * Interval
//*============================================================================*

@usableFromInline struct Interval: View, Layoutable, Storageable {
    
    //=------------------------------------------------------------------------=
    // MARK: Environment
    //=------------------------------------------------------------------------=
    
    @usableFromInline @EnvironmentObject var layout:  Layout
    @usableFromInline @EnvironmentObject var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() { }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    @inlinable var body: some View {
        ZStack {
            Beam(between: layout.positions)
            Handle(values.projectedValue.0, at: positions.0)
            Handle(values.projectedValue.1, at: positions.1)
        }
        .coordinateSpace(name: coordinates)
    }
}
