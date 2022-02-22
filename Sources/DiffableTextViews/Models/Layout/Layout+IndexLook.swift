//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Index Look
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards - To
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexForwardsTo(start: Index, where predicate: (Index) -> Bool) -> Index? {
        var position = start
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != endIndex {
            if predicate(position) { return position }
            formIndex(after: &position)
        }
        //=--------------------------------------=
        // MARK: Failure == None
        //=--------------------------------------=
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards - Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexForwardsThrough(start: Index, where predicate: (Index) -> Bool) -> Index? {
        var position = start
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != endIndex {
            if predicate(position) { return index(after: position) }
            formIndex(after: &position)
        }
        //=--------------------------------------=
        // MARK: Failure == None
        //=--------------------------------------=
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards - To
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexBackwardsTo(start: Index, where predicate: (Index) -> Bool) -> Index? {
        var position = start
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != startIndex {
            let after = position
            formIndex(before: &position)
            if predicate(position) { return after }
        }
        //=--------------------------------------=
        // MARK: Failure == None
        //=--------------------------------------=
        return nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards - Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexBackwardsThrough(start: Index, where predicate: (Index) -> Bool) -> Index? {
        var position = start
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != startIndex {
            formIndex(before: &position)
            if predicate(position) { return position }
        }
        //=--------------------------------------=
        // MARK: Failure == None
        //=--------------------------------------=
        return nil
    }
}
