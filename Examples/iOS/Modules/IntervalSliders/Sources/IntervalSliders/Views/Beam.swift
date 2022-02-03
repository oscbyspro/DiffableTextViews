//
//  Beam.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI

//*============================================================================*
// MARK: * Beam
//*============================================================================*

@usableFromInline struct Beam: View, HasComposite, HasConstants {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let composite: Composite
    @usableFromInline var animatableData: AnimatablePair<CGFloat, CGFloat>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(_ composite: Composite) {
        self.composite = composite
        self.animatableData = AnimatablePair(composite.layout.positions.0, composite.layout.positions.1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    @inlinable var body: some View {
        Path {
            $0.move(to:    CGPoint(x: animatableData.first,  y: frame.midY))
            $0.addLine(to: CGPoint(x: animatableData.second, y: frame.midY))
        }
        .stroke(Color.accentColor, lineWidth: thickness)
    }
}

