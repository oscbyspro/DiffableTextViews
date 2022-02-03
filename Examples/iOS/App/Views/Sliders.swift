//
//  Sliders.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI
import IntervalSliders

//*============================================================================*
// MARK: * Sliders
//*============================================================================*

struct Sliders<Value: BinaryInteger>: View {
    typealias Interval = iOS.Interval<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let title: String
    let interval: Binding<Interval>
    let limits: Interval
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        GroupBox(description) {
            IntervalSliders(interval.values, in: limits.closed)
        }
        .frame(maxWidth: .infinity)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    var description: String {
        let bounds = interval.wrappedValue.closed
        return "\(title): \(bounds.lowerBound) to \(bounds.upperBound)"
    }
}

