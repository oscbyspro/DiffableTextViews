//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import Sliders

//*============================================================================*
// MARK: * NumericScreenSliders
//*============================================================================*

struct NumericScreenSliders: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let title: String
    let limits: Interval<Int>
    @ObservedObject var interval: Source<Interval<Int>>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ title: String, interval: Source<Interval<Int>>, in limits: Interval<Int>) {
        self.title  = title
        self.limits = limits
        self.interval = interval
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        GroupBox(label(interval.content.closed)) {
            Sliders($interval.content.values, in: limits.closed)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    func label(_ values: ClosedRange<Int>) -> String {
        "\(title): \(String(describing: values.lowerBound.description)) to \(String(describing: values.upperBound))"
    }
}
