//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Snapshot
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(_ start: Range<Index>, destination: Snapshot.Index) -> Range<Index> {
        let upper = destination.attribute - start.upperBound.attribute
        let lower = destination.attribute - start.lowerBound.attribute
        //=--------------------------------------=
        // MARK: Compare
        //=--------------------------------------=
        let position = upper <= lower
        ? index(start.upperBound, offsetBy: upper)
        : index(start.lowerBound, offsetBy: lower)
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return position ..< position
    }
}
