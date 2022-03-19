//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// This file contains methods used in response to changes downstream.
//=----------------------------------------------------------------------------=

import DiffableTextKit

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
    // MARK: Number - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ sign: Sign) throws {
        guard sign == sign.transformed(autocorrect) else {
            throw Info([.mark(sign), "is not in", .mark(self)])
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ value: Value, _ number: inout Number) throws {
        if try edge(value), number.removeSeparatorAsSuffix() {
            Info.print([.autocorrection, .mark(number), "does not fit a fraction separator"])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Value - Helpers
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
        if value == min { return value < .zero }
        //=--------------------------------------=
        // MARK: Value Is Out Of Bounds
        //=--------------------------------------=
        throw Info([.mark(value), "is not in", .mark(self)])
    }
}
