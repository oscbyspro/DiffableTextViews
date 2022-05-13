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

struct NumberScreenIntegerInterval: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let title: String
    let limits: ClosedRange<Int>
    @ObservedObject var interval: Observable<Interval<Int>>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ title: String, interval: Observable<Interval<Int>>, in limits: ClosedRange<Int>) {
        self.title  = title
        self.limits = limits
        self.interval = interval
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var description: String {
        let interval = interval.wrapped.closed
        return "\(title): \(interval.lowerBound) to \(interval.upperBound)"
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(description).font(.subheadline.weight(.light))
            IntervalSlider($interval.wrapped.values, in: limits)
        }
    }
}
