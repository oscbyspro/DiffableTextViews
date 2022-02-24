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
// MARK: + Components
//=----------------------------------------------------------------------------=

extension Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ components: inout Components) {
        components.trim(max: upper)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Components x Capacity
//=----------------------------------------------------------------------------=

extension Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Calculate / Validate
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
        // MARK: Return Capacity On Success
        //=--------------------------------------=
        return capacity
    }
}
