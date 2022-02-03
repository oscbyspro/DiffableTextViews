//
//  IntervalUI.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI
import IntervalSliders

//*============================================================================*
// MARK: * IntervalUI
//*============================================================================*

struct IntervalUI<Value: Comparable & BinaryInteger>: View {
    
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
        GroupBox {
            IntervalSliders(interval.values, in: limits)
        } label: {
            description(interval.wrappedValue.closed).transaction({ $0.animation = nil })
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    func description(_ values: ClosedRange<Value>) -> some View {
        Text("\(title): \(String(describing: values.lowerBound.description)) to \(String(describing: values.upperBound))")
    }
}

