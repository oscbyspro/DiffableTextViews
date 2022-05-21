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
// MARK: * Bounds
//*============================================================================*

struct Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
        
    private var  _unordered: (Int, Int)
    private(set) var closed: ClosedRange<Decimal>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    init(_ unordered: (Int, Int)) {
        let closed = ClosedRange(unordered); self._unordered = unordered; self.closed =
        Decimal(string: Self.number(nines: closed.lowerBound))! ...
        Decimal(string: Self.number(nines: closed.upperBound))!
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var unordered: (Int, Int) {
        get { _unordered } set { self = Self(newValue) }
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
