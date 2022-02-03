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

@usableFromInline struct Beam: View, Animatable, Layoutable, Storageable {
    @usableFromInline typealias Start = GestureState<(CGFloat, CGFloat)?>
    @usableFromInline typealias AnimatableData = AnimatablePair<CGFloat, CGFloat>

    //=------------------------------------------------------------------------=
    // MARK: Environment
    //=------------------------------------------------------------------------=

    @usableFromInline @EnvironmentObject var layout: Layout
    @usableFromInline @EnvironmentObject var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let start = Start(initialValue: nil)
    @usableFromInline var animatableData: AnimatableData

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(between positions: (CGFloat, CGFloat)) {
        self.animatableData = AnimatableData(positions.0, positions.1)
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
        .gesture(drag)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    @inlinable var drag: some Gesture {
        DragGesture(coordinateSpace: .named(coordinates)).updating(start) { gesture, start, _ in
            if start == nil { start = positions }
            let distance = gesture.location.x - gesture.startLocation.x
            let positions = move(start!, by: distance, in: positionsLimits)
            let next = map(positions, from: positionsLimits, to: valuesLimits)
            withAnimation(slide) { values.wrappedValue = next }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Calculations
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
