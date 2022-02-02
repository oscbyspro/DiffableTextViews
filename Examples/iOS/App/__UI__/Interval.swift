//
//  Interval.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-02.
//

import SwiftUI

//*============================================================================*
// MARK: * Interval
//*============================================================================*

struct Interval<Value: Comparable> {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    var values: (Value, Value)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ values: (Value, Value)) { self.values = values }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    var semiopen: Range<Value> {
        values.0 <= values.1 ? values.0..<values.1 : values.1..<values.0
    }
    
    var closed: ClosedRange<Value> {
        values.0 <= values.1 ? values.0...values.1 : values.1...values.0
    }
}

//*============================================================================*
// MARK: * Interval x CGFloat
//*============================================================================*

extension Interval where Value == CGFloat {
    var ui:   Self {
        get { self }
        set { self = newValue }
    }
}

//*============================================================================*
// MARK: * Interval x BinaryInteger
//*============================================================================*

extension Interval where Value: BinaryInteger {
    var ui:   Interval<CGFloat> {
        get { Interval<CGFloat>((CGFloat(values.0), CGFloat(values.1))) }
        set { self = Self((Value(newValue.values.0.rounded()), Value(newValue.values.1.rounded()))) }
    }
}

//*============================================================================*
// MARK: * Interval x BinaryFloatingPoint
//*============================================================================*

extension Interval where Value: BinaryFloatingPoint {
    var ui:   Interval<CGFloat> {
        get { Interval<CGFloat>((CGFloat(values.0), CGFloat(values.1))) }
        set { self = Self((Value(newValue.values.0), Value(newValue.values.1))) }
    }
}
