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

public struct IntervalSlider: View {
 
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let interval: Interval
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ values: Binding<(CGFloat, CGFloat)>,
    in limits: ClosedRange<CGFloat>) {
        self.interval = Interval(values, in: limits)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=

    @inlinable public var body: some View {
        ZStack {
            //=----------------------------------=
            // Track
            //=----------------------------------=
            Track()
            //=----------------------------------=
            // Controls
            //=----------------------------------=
            GeometryReader { geometry in
                Controls(interval, in: geometry)
            }
            .padding(.horizontal, 0.5 * Constants.radius)
        }
        .frame(maxWidth: .infinity)
        .frame(height: Constants.radius)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Initializers
//=----------------------------------------------------------------------------=

extension IntervalSlider {
    
    //=------------------------------------------------------------------------=
    // MARK: Integer
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(_ values: Binding<(T, T)>,
    in limits: ClosedRange<T>) where T: BinaryInteger {
        //=--------------------------------------=
        // Get
        //=--------------------------------------=
        self.init(Binding {(
            CGFloat(values.wrappedValue.0),
            CGFloat(values.wrappedValue.1))
        //=--------------------------------------=
        // Set
        //=--------------------------------------=
        } set: {
            let newValue = (
            T($0.0.rounded()),
            T($0.1.rounded()))
            //=----------------------------------=
            // Must Be Unique
            //=----------------------------------=
            if  values.wrappedValue != newValue {
                values.wrappedValue  = newValue
            }
        //=--------------------------------------=
        // MARK: Limits
        //=--------------------------------------=
        }, in: CGFloat(limits.lowerBound)...CGFloat(limits.upperBound))
    }
}

//*============================================================================*
// MARK: Previews
//*============================================================================*

struct Sliders_Previews: View, PreviewProvider {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State var interval = (1, 5)
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        IntervalSlider($interval, in: 0...6)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Previews
    //=------------------------------------------------------------------------=
    
    static var previews: some View {
        Self().preferredColorScheme(.dark)
    }
}
