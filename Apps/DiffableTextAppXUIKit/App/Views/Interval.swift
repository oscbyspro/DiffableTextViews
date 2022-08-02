//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import IntervalSliderViews
import SwiftUI

//*============================================================================*
// MARK: * Interval
//*============================================================================*

struct Interval: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let title: String
    let limits: ClosedRange<Int>
    @Binding var unordered: (Int, Int)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ title: String, unordered: Binding<(Int, Int)>, in limits: ClosedRange<Int>) {
        self.title = title; self._unordered = unordered; self.limits = limits
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        VStack(alignment: .leading) {
            label
            IntervalSlider($unordered, in: limits)
            Spacer(minLength: 16).fixedSize()
        }
    }
    
    var label: some View {
        let interval = ClosedRange(unordered)
        let text = Text("\(title): \(interval.lowerBound) to \(interval.upperBound)")
        return text.font(.subheadline.weight(.light)).animation(nil)
    }
}
