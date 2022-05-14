//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct Bounds {
    typealias Value = Decimal
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
        
    private var _integers: Interval<Int>
    private var _values: ClosedRange<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ integers: Interval<Int>) {
        self._integers = integers
        self._values = Self.map(integers)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
        
    var integers: Interval<Int> {
        get { _integers }
        set { _integers = newValue; _values = Self.map(newValue) }
    }
    
    var values: ClosedRange<Value> { _values }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private static func map(_ integers: Interval<Int>) -> ClosedRange<Value> {
        let closed = integers.closed; return
        Value(string: String.number(nines: closed.lowerBound))! ...
        Value(string: String.number(nines: closed.upperBound))!
    }
}
