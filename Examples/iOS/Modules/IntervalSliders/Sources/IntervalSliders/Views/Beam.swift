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
// MARK: * Beam
//*============================================================================*

@usableFromInline struct Beam: View, Animatable, Storageable {
    @usableFromInline typealias Start = GestureState<(CGFloat, CGFloat)?>
    @usableFromInline typealias AnimatableData = AnimatablePair<CGFloat, CGFloat>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline let storage: Storage
    @usableFromInline var animatableData: AnimatableData
    @usableFromInline let start = Start(initialValue: nil)

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(_ storage: Storage, between positions: (CGFloat, CGFloat)) {
        self.storage = storage
        self.animatableData = AnimatableData(positions.0, positions.1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    @inlinable var body: some View {
        Path {
            $0.move(to: center(animatableData.first))
            $0.addLine(to: center(animatableData.second))
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
            withAnimation(dragging) { values.wrappedValue = next }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Calculations
    //=------------------------------------------------------------------------=
    
    /// Assumes: distance between values ≤ distance between limits.
    @inlinable func move(_ values: (CGFloat, CGFloat),
        by amount: CGFloat, in limits: ClosedRange<CGFloat>) -> (CGFloat, CGFloat)  {
        var next = (values.0 + amount, values.1 + amount)
        
        func autocorrect(_ value: CGFloat) {
            let change = min(max(limits.lowerBound, value), limits.upperBound) - value
            next.0 += change
            next.1 += change
        }

        autocorrect(next.0); autocorrect(next.1); return next
    }
}
