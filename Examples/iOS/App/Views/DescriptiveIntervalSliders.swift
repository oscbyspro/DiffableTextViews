//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import IntervalSliders

//*============================================================================*
// MARK: * Sliders
//*============================================================================*

struct Sliders<Value: Comparable & BinaryInteger>: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let title: String
    let limits: ClosedRange<Value>
    let interval: Binding<Interval<Value>>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ title: String, values: Binding<Interval<Value>>, limits: ClosedRange<Value>) {
        self.title = title
        self.limits = limits
        self.interval = values
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        GroupBox(label(interval.wrappedValue.closed)) {
            IntervalSliders(interval.values, in: limits)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    func label(_ values: ClosedRange<Value>) -> String {
        "\(title): \(String(describing: values.lowerBound.description)) to \(String(describing: values.upperBound))"
    }
}

