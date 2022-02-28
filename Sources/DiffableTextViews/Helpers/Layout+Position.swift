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
// MARK: + Position
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Single
    //=------------------------------------------------------------------------=
    
    @inlinable func index(start: Index, destination: Position) -> Index {
        switch start.position <= destination {
        case  true: return index(after:  start, while: { $0.position < destination })
        case false: return index(before: start, while: { $0.position > destination })
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Double
    //=------------------------------------------------------------------------=

    @inlinable func indices(start: Range<Index>, destination: Range<Position>) -> Range<Index> {
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = index(start: start.upperBound, destination: destination.upperBound)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !destination.isEmpty {
            lowerBound = index(start: start.lowerBound, destination: destination.lowerBound)
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return lowerBound ..< upperBound
    }
}
