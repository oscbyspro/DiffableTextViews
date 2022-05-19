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

struct _Handle: View {
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        shape.fill(.gray).overlay(border).shadow(color: .black.opacity(0.15), radius: 2, y: 2)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var shape: some InsettableShape {
        Circle()
    }
    
    var border: some View {
        shape.strokeBorder(Color.gray.opacity(0.15), lineWidth: 0.5)
    }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct Handle_Previews: PreviewProvider {
    
    //=------------------------------------------------------------------------=
    // MARK: Previews
    //=------------------------------------------------------------------------=
    
    static var previews: some View {
        _Handle()
            .frame(width: 27, height: 27)
            .preferredColorScheme(.dark)
    }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct Handle: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let context: Context
    let item: WritableKeyPath<(CGFloat, CGFloat), CGFloat>

    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        _Handle().gesture(drag).position(context.layout.position(item))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    @inlinable var drag: some Gesture {
        DragGesture(coordinateSpace: .named(context.coordinates)).onChanged { gesture in
            //=----------------------------------=
            // Update
            //=----------------------------------=
            withAnimation(context.animation) {
                context.values.remote[keyPath: item] = Context.map(
                gesture.location.x, from: context.layout.limits, to: context.values.limits)
            }
        }
    }
}
