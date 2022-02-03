//
//  Interval.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI

//*============================================================================*
// MARK: * Sliders x Interval
//*============================================================================*

@usableFromInline struct Interval: View, Compositeable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let composite: Composite
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ storage: Storage, proxy: GeometryProxy) {
        let layout = Layout(storage, proxy: proxy)
        self.composite = Composite(storage, layout)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    @inlinable var body: some View {
        ZStack {
            Beam(composite)
            Handle(composite, value: values.projectedValue.0, position: positions.0)
            Handle(composite, value: values.projectedValue.1, position: positions.1)
        }
        .coordinateSpace(name: coordinates)
    }
}
