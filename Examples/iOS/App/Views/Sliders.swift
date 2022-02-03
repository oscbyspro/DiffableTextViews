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

struct Sliders<Value: Comparable & BinaryInteger>: View {
    typealias Values = Interval<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let title: String
    let limits: ClosedRange<Value>
    let interval: Binding<Values>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ title: String, values: Binding<Values>, limits: ClosedRange<Value>) {
        self.title = title
        self.limits = limits
        self.interval = values
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        GroupBox {
            IntervalSliders(interval.values, in: limits)
        } label: {
            Text(description(interval.wrappedValue.closed))
                .transaction({ $0.animation = nil })
        }
        .frame(maxWidth: .infinity)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    func description(_ values: ClosedRange<Value>) -> String {
        "\(title): \(values.lowerBound) to \(values.upperBound)"
    }
}

