//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// These methods are all used in response to changes upstream.
//=----------------------------------------------------------------------------=

import Support

//=----------------------------------------------------------------------------=
// MARK: + Autocorrect
//=----------------------------------------------------------------------------=

extension Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ value: inout Value) {
        value = Swift.min(Swift.max(min, value), max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ number: inout Number) {
        autocorrect(&number.sign)
    }

    //=------------------------------------------------------------------------=
    // MARK: Number - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ sign: inout Sign) {
        switch sign {
        case .positive: if max <= .zero, min != .zero { sign.toggle() }
        case .negative: if min >= .zero               { sign.toggle() }
        }
    }
}
