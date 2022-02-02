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
