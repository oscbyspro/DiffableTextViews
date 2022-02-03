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

@usableFromInline struct Beam: View, Animatable, Compositeable, Constantsable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let composite: Composite
    @usableFromInline var animatableData: AnimatablePair<CGFloat, CGFloat>
    @usableFromInline var start = GestureState<(CGFloat, CGFloat)?>(initialValue: nil)

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    #warning("FIXME.")
    @inlinable init(_ composite: Composite) {
        self.composite = composite
        self.animatableData = AnimatablePair(
        composite.layout.values.0, composite.layout.values.1)
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
        .frame(height: radius)
        .contentShape(Rectangle())
        .gesture(slide)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    @inlinable var slide: some Gesture {
        DragGesture(coordinateSpace: .named(coordinates)).updating(start) { gesture, start, _ in
            if start == nil { start = positions }
            let distance = gesture.location.x - gesture.startLocation.x
            let positions = move(start!, by: distance, in: positionsLimits)
            let values = Algorithms.convert(positions, from: positionsLimits, to: valuesLimits)
            withAnimation(animation) { composite.storage.values.wrappedValue = values }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
        
    @inlinable func move(_ values: (CGFloat, CGFloat),
        by amount: CGFloat, in limits: ClosedRange<CGFloat>) -> (CGFloat, CGFloat)  {
        var next = (values.0 + amount, values.1 + amount)

        func clamp(with value: CGFloat) {
            let change = min(max(limits.lowerBound, value), limits.upperBound) - value
            next.0 += change
            next.1 += change
        }

        clamp(with: next.0); clamp(with: next.1); return next
    }
}
