//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import NumericTextStyles

//*============================================================================*
// MARK: * NumericScreenExample
//*============================================================================*

/// An examples view that observes frequent changes.
struct NumericScreenExample<Format: NumericTextFormat>: View where Format.FormatInput == NumericScreenContext.Value {
    typealias Context = NumericScreenContext
    typealias Integers = Interval<Int>
    typealias Value = Format.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let base: NumericTextStyle<Format>
    @ObservedObject var value: Source<Value>
    @ObservedObject var bounds: Source<Integers>
    @ObservedObject var integer: Source<Integers>
    @ObservedObject var fraction: Source<Integers>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ context: Context, base: NumericTextStyle<Format>) {
        self.base = base
        self.value = context.value
        self.bounds = context.bounds
        self.integer = context.integer
        self.fraction = context.fraction
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Example(value.binding, style: style)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    var style: NumericTextStyle<Format> {
        base.bounds(boundsLimits).precision(integer: integerLimits, fraction: fractionLimits)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    var integerLimits: ClosedRange<Int> {
        integer.content.closed
    }
    
    var fractionLimits: ClosedRange<Int> {
        fraction.content.closed
    }
    
    var boundsLimits: ClosedRange<Value> {
        let ordered = bounds.content.closed
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        func bound(_ length: Int) -> Decimal {
            guard length != 0 else { return 0 }
            var description = length >= 0 ? "" : "-"
            description += String(repeating: "9", count: abs(length))
            return Value(string: description)!
        }
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        return bound(ordered.lowerBound)...bound(ordered.upperBound)
    }
}

