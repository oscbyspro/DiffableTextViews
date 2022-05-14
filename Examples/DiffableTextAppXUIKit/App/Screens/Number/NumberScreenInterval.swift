//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI
import IntervalSliderViews

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct NumberScreenInterval: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let title: String
    let limits: ClosedRange<Int>
    @Binding var interval: Interval<Int>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ title: String, interval: Binding<Interval<Int>>, in limits: ClosedRange<Int>) {
        self.title = title; self._interval = interval; self.limits = limits
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        VStack(alignment: .leading) {
            text(interval.closed)
            IntervalSlider($interval.values, in: limits)
        }
    }
    
    func text(_ interval: ClosedRange<Int>) -> Text {
        Text("\(title): \(interval.lowerBound) to \(interval.upperBound)")
            .font(.subheadline.weight(.light))
    }
}
