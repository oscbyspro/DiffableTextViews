//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// These methods are all used in response to changes downstream (input).
//=----------------------------------------------------------------------------=

import Support

//=----------------------------------------------------------------------------=
// MARK: + Autovalidate
//=----------------------------------------------------------------------------=

extension Bounds {

    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ number: Number) throws {
        try autovalidate(number.sign)
    }

    //=------------------------------------------------------------------------=
    // MARK: Number - Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ sign: Sign) throws {
        guard sign == sign.transform(autocorrect) else {
            throw Info([.mark(sign), "is not in", .mark(self)])
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Value x Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ value: Value, _ number: inout Number) throws {
        //=--------------------------------------=
        // MARK: Validate, Autocorrect
        //=--------------------------------------=
        if try edge(value), number.removeSeparatorAsSuffix() {
            Info.print([.autocorrection, .mark(number), "does not fit a fraction separator"])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Value x Number - Location
    //=------------------------------------------------------------------------=
    
    @inlinable func edge(_ value: Value) throws -> Bool {
        if min < value  && value < max { return false }
        //=--------------------------------------=
        // MARK: Value == Max
        //=--------------------------------------=
        if value == max { return value > .zero || min == max }
        //=--------------------------------------=
        // MARK: Value == Min
        //=--------------------------------------=
        if value == min { return value < .zero || min == max }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        throw Info([.mark(value), "is not in", .mark(self)])
    }
}
