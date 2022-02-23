//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Support

//=----------------------------------------------------------------------------=
// MARK: + Value
//=----------------------------------------------------------------------------=

extension Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ value: inout Value) {
        value = Swift.min(Swift.max(min, value), max)
    }

    //=------------------------------------------------------------------------=
    // MARK: Validate
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(_ value: Value) throws -> Location {
        if min < value && value < max { return .body }
        //=--------------------------------------=
        // MARK: Value == Max
        //=--------------------------------------=
        if value == max {
            return value > .zero || min == max ? .edge : .body
        }
        //=--------------------------------------=
        // MARK: Value == Min
        //=--------------------------------------=
        if value == min {
            return value < .zero || min == max ? .edge : .body
        }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        throw Info([.mark(value), "is not in", .mark(self)])
    }
}
