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

@usableFromInline struct Beam: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let layout: Layout
    @usableFromInline var animatableData: AnimatablePair<CGFloat, CGFloat>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(_ layout: Layout) {
        self.layout = layout
        self.animatableData = AnimatablePair(layout.values.0, layout.values.1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var center: CGFloat {
        layout.center
    }
    
    @inlinable var thickness: CGFloat {
        Constants.thickness
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    @inlinable var body: some View {
        Path {
            $0.move(to:    CGPoint(x: animatableData.first,  y: center))
            $0.addLine(to: CGPoint(x: animatableData.second, y: center))
        }
        .stroke(Color.accentColor, lineWidth: thickness)
    }
}

