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
// MARK: Declaration
//*============================================================================*

@usableFromInline struct Beam: View, Animatable {
    @usableFromInline typealias Start = GestureState<(CGFloat, CGFloat)?>
    @usableFromInline typealias AnimatableData = AnimatablePair<CGFloat, CGFloat>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline let context: Context
    @usableFromInline var animatableData: AnimatableData
    @usableFromInline let start = Start(initialValue: nil)

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(_ context: Context, between positions: (CGFloat, CGFloat)) {
        self.context = context; self.animatableData = AnimatableData(positions.0, positions.1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    @inlinable var body: some View {
        Path {
            $0.move(to: context.layout.center(animatableData.first))
            $0.addLine(to: context.layout.center(animatableData.second))
        }
        .stroke(Color.accentColor, lineWidth: Constants.thickness)
        .frame(height: Constants.radius)
        .contentShape(Rectangle())
        .gesture(dragGesture)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    @inlinable var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .named(Constants.coordinates)).updating(start) { gesture, start, _ in
            if start == nil { start = context.positions }
            let distance = gesture.location.x - gesture.startLocation.x
            let positions = move(start!, by: distance, in: context.positionsLimits)
            let next = Utilities.map(positions, from: context.positionsLimits, to: context.valuesLimits)
            withAnimation(Constants.dragging) { context.values.wrappedValue = next }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Assumes: distance between values ≤ distance between limits.
    @inlinable func move(_ values: (CGFloat, CGFloat),
        by amount: CGFloat, in limits: ClosedRange<CGFloat>) -> (CGFloat, CGFloat)  {
        var next = (values.0 + amount, values.1 + amount)
        //=--------------------------------------=
        // Utilities
        //=--------------------------------------=
        func autocorrect(_ value: CGFloat) {
            let change = min(max(limits.lowerBound, value), limits.upperBound) - value
            next.0 += change
            next.1 += change
        }
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        autocorrect(next.0); autocorrect(next.1); return next
    }
}