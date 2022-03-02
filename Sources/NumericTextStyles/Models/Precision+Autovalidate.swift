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

import Support

//=----------------------------------------------------------------------------=
// MARK: + Autovalidate
//=----------------------------------------------------------------------------=

extension Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ number: inout Number, _ count: Count) throws {
        let capacity = try capacity(count)
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        if capacity.fraction <= 0 || capacity.value <= 0, number.removeSeparatorAsSuffix() {
            Info.print([.autocorrection, .mark(number), "does not fit a fraction separator"])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Number - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func capacity(_ count: Count) throws -> Count {
        let capacity = upper.transform(&-, count)
        //=--------------------------------------=
        // MARK: Validate Each Component
        //=--------------------------------------=
        if let component = capacity.first(where: { $0 < 0 }) {
            throw Info([.mark(component), "digits exceed max precision", .mark(upper[component])])
        }
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return capacity
    }
}
