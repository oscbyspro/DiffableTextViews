//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Preference
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Single
    //=------------------------------------------------------------------------=
    
    @inlinable func preferred(_ start: Layout.Index, preference: Direction, momentum: Direction?) -> Layout.Index {
        //=--------------------------------------=
        // MARK: Anchor
        //=--------------------------------------=
        if let anchorIndex = snapshot.anchorIndex {
            return index(anchorIndex)
        }
        //=--------------------------------------=
        // MARK: Inspect The Initial Position
        //=--------------------------------------=
        if peek(start, direction: preference).map(nonpassthrough) == true {
            return start
        }
        //=--------------------------------------=
        // MARK: Pick A Direction
        //=--------------------------------------=
        let direction = momentum ?? preference
        //=--------------------------------------=
        // MARK: Try In This Direction
        //=--------------------------------------=
        if let position = firstCaret(start, direction: direction, through: direction != preference) {
            return position
        }
        //=--------------------------------------=
        // MARK: Try In The Other Direction
        //=--------------------------------------=
        if let position = firstCaret(start, direction: direction.reversed(), through: false) {
            return position
        }
        //=--------------------------------------=
        // MARK: Return Layout Start Index
        //=--------------------------------------=
        return startIndex
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Double
    //=------------------------------------------------------------------------=
    
    @inlinable func preferred(_ start: Range<Index>, momentum: Momentum) -> Range<Index> {
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = preferred(start.upperBound, preference: .backwards, momentum: momentum.upper)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !start.isEmpty, upperBound != startIndex {
            lowerBound = preferred(start.lowerBound, preference:  .forwards, momentum: momentum.lower)
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return lowerBound ..< upperBound
    }
}
