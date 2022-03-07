//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// This file contains methods used in response to changes upstream.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Autocorrect
//=----------------------------------------------------------------------------=

extension Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ number: inout Number) {
        number.trim(max: upper)
    }
}
