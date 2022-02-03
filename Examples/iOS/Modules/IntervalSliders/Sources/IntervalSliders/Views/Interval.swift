//
//  Interval.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI

//*============================================================================*
// MARK: * Interval
//*============================================================================*

@usableFromInline struct Interval: View, Constantsable, Layoutable, Storageable {
    
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
            Beam(layout.positions)
            Handle(values.projectedValue.0, at: positions.0)
            Handle(values.projectedValue.1, at: positions.1)
        }
        .coordinateSpace(name: coordinates)
    }
}
