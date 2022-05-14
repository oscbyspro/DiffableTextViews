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

struct _Beam: View, Animatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let center: CGFloat
    var positions: (CGFloat, CGFloat)
    var color: Color
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    static func track(in bounds: CGRect) -> Self {
        Self(center: bounds.midY,
        positions: (bounds.minX, bounds.maxX),
        color: Color.gray.opacity(0.2))
    }
    
    static func color(in bounds: CGRect, at positions: (CGFloat, CGFloat)) -> Self {
        Self(center: bounds.midY,
        positions: positions,
        color: Color.accentColor)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(self.positions.0, self.positions.1) }
        set { self.positions = (newValue.first, newValue.second) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        let thickness = 4.0; let inset = 0.5 * thickness; return Path {
            $0.move(to:    CGPoint(x: positions.0 + inset, y: center))
            $0.addLine(to: CGPoint(x: positions.1 - inset, y: center))
        }
        .stroke(color, style: StrokeStyle(lineWidth: thickness, lineCap: .round))
    }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct Beam_Previews: PreviewProvider {
    
    //=------------------------------------------------------------------------=
    // MARK: Previews
    //=------------------------------------------------------------------------=
    
    static var previews: some View {
        GeometryReader { geometry in
            let bounds = geometry.frame(in: .local)
            
            ZStack {
                _Beam.track(in: bounds)
                _Beam.color(in: bounds, at: (bounds.midX, bounds.maxX))
            }
        }
        .padding().preferredColorScheme(.dark)
    }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct Beam: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let context: Context
    @GestureState var start: (CGFloat, CGFloat)?

    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        _Beam.color(in: context.layout.bounds, at: context.layout.positions).gesture(drag)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var drag: some Gesture {
        DragGesture(coordinateSpace: .named(context.coordinates)).updating($start) { gesture, start, _ in
            if  start == nil { start = context.layout.positions }
            //=----------------------------------=
            // Values
            //=----------------------------------=
            let distance  = gesture.location.x - gesture.startLocation.x
            let positions = move(start!, by: distance, in: context.layout.limits)
            //=----------------------------------=
            // Update
            //=----------------------------------=
            withAnimation(context.animation) {
                context.values.remote = Context.map(
                positions, from: context.layout.limits, to: context.values.limits)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func move(_ positions: (CGFloat, CGFloat), by amount: CGFloat,
    in limits: ClosedRange<CGFloat>) -> (CGFloat, CGFloat)  {
        var next = (positions.0 + amount,  positions.1 + amount)
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
