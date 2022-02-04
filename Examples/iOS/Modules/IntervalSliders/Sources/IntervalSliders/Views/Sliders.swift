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
// MARK: * Sliders
//*============================================================================*

@usableFromInline struct Sliders: View, Storageable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ interval: Interval, in proxy: GeometryProxy) {
        self.storage = Storage(interval, proxy: proxy)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    @inlinable var body: some View {
        ZStack {
            Beam(storage, between: layout.positions)
            Handle(storage, value: values.projectedValue.0, position: positions.0)
            Handle(storage, value: values.projectedValue.1, position: positions.1)
        }
        .coordinateSpace(name: coordinates)
    }
}
