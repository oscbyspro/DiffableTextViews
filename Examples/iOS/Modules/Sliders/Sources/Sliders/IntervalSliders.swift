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
// MARK: * IntervalSliders
//*============================================================================*

public struct IntervalSliders: View, HasInterval {
 
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let interval: Interval
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ values: Binding<(CGFloat, CGFloat)>, in limits: ClosedRange<CGFloat>) {
        self.interval = Interval(values, in: limits)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    @inlinable public var body: some View {
        foundation.overlay(sliders)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    @inlinable var foundation: some View {
        Track().frame(maxWidth: .infinity, minHeight: radius, maxHeight: radius)
    }
    
    @inlinable var sliders: some View {
        GeometryReader {
            Sliders(interval, in: $0)
        }
        .padding(.horizontal, 0.5 * radius)
    }
}

//=----------------------------------------------------------------------------=
// MARK: IntervalSliders x Initializers
//=----------------------------------------------------------------------------=

extension IntervalSliders {
    
    //=------------------------------------------------------------------------=
    // MARK: Binary - Integer
    //=------------------------------------------------------------------------=
    
    @inlinable public init<Value>(_ values: Binding<(Value, Value)>,
        in limits: ClosedRange<Value>) where Value: BinaryInteger {
        //=--------------------------------------=
        // MARK: Get
        //=--------------------------------------=
        self.init(Binding {(
            CGFloat(values.wrappedValue.0),
            CGFloat(values.wrappedValue.1))
        //=--------------------------------------=
        // MARK: Set
        //=--------------------------------------=
        } set: { xxxxxxxxxxx in let newValue = (
            Value(xxxxxxxxxxx.0.rounded()),
            Value(xxxxxxxxxxx.1.rounded()))
            //=----------------------------------=
            // MARK: Set Nonduplicate Values
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
// MARK: * IntervalSliders x Previews
//*============================================================================*

struct SlidersPreviews: View, PreviewProvider {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State var interval = (1, 5)
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        IntervalSliders($interval, in: 0...6)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Previews
    //=------------------------------------------------------------------------=
    
    static var previews: some View {
        Self().preferredColorScheme(.dark)
    }
}
