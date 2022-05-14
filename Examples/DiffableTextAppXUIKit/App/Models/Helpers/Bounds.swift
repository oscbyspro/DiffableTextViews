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
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
        
    private var _integers: Interval<Int>
    private var _values: ClosedRange<Decimal>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ integers: Interval<Int>) {
        self._integers = integers; let closed = integers.closed; self._values =
        Decimal(string:  Self.number(nines: closed.lowerBound))! ...
        Decimal(string:  Self.number(nines: closed.upperBound))!
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
            
    var values: ClosedRange<Decimal> {
        get { _values   }
    }
    
    var integers: Interval<Int> {
        get { _integers } set { self = Self(newValue) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    private static func number(nines: Int) -> String {
        guard nines != 0 else { return "0" }
        var description = nines  < 0 ? "-" : ""
        description += String(repeating: "9", count: abs(nines))
        return description
    }
}
