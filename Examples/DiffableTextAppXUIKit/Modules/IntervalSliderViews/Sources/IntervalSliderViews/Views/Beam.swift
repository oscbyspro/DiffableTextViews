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
    
    init(_ bounds: CGRect) {
        self.center = bounds.midY
        self.positions = (bounds.minX, bounds.maxX)
        self.color = .gray.opacity(0.2)
    }
    
    init(_ bounds: CGRect, positions: (CGFloat, CGFloat)) {
        self.center = bounds.midY
        self.positions = positions
        self.color = .accentColor
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var thickness: CGFloat { 4 }
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(self.positions.0, self.positions.1) }
        set { self.positions = (newValue.first, newValue.second) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Path {
            $0.move(to:    CGPoint(x: positions.0, y: center))
            $0.addLine(to: CGPoint(x: positions.1, y: center))
        }
        .stroke(color, style: StrokeStyle.init(lineWidth: thickness, lineCap: .round))
        .padding(.horizontal, 0.5 * thickness)
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
                _Beam(bounds)
                _Beam(bounds, positions: (bounds.midX, bounds.maxX))
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
        _Beam(context.layout.bounds, positions: context.layout.positions).gesture(drag)
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
