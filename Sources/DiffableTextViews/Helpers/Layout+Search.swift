//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Search
//=----------------------------------------------------------------------------=

extension Layout {

    //=------------------------------------------------------------------------=
    // MARK: Forwards To
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexForwardsTo(from start: Index, where predicate: (Index) -> Bool) -> Index? {
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
    // MARK: Forwards Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexForwardsThrough(from start: Index, where predicate: (Index) -> Bool) -> Index? {
        firstIndexForwardsTo(from: start, where: predicate).map(index(after:))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards To
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexBackwardsTo(from start: Index, where predicate: (Index) -> Bool) -> Index? {
        firstIndexBackwardsThrough(from: start, where: predicate).map(index(after:))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndexBackwardsThrough(from start: Index, where predicate: (Index) -> Bool) -> Index? {
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
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards / Backwards / To / Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstIndex(_ start: Index, direction: Direction, through: Bool) -> Index? {
        switch (direction, through) {
        case (.forwards,  false): return firstIndexForwardsTo(from:       start, where: nonpassthrough)
        case (.forwards,   true): return firstIndexForwardsThrough(from:  start, where: nonpassthrough)
        case (.backwards, false): return firstIndexBackwardsTo(from:      start, where: nonpassthrough)
        case (.backwards,  true): return firstIndexBackwardsThrough(from: start, where: nonpassthrough)
        }
    }
}
