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
    
    @inlinable func firstCaretForwardsTo(from start: Index, where predicate: (Index) -> Bool) -> Index? {
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
    
    @inlinable func firstCaretForwardsThrough(from start: Index, where predicate: (Index) -> Bool) -> Index? {
        firstCaretForwardsTo(from: start, where: predicate).map(index(after:))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards To
    //=------------------------------------------------------------------------=
    
    @inlinable func firstCaretBackwardsTo(from start: Index, where predicate: (Index) -> Bool) -> Index? {
        firstCaretBackwardsThrough(from: start, where: predicate).map(index(after:))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards Through
    //=------------------------------------------------------------------------=
    
    @inlinable func firstCaretBackwardsThrough(from start: Index, where predicate: (Index) -> Bool) -> Index? {
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
    
    @inlinable func firstCaret(_ start: Index, direction: Direction, through: Bool) -> Index? {
        switch (direction, through) {
        case (.forwards,  false): return firstCaretForwardsTo(from:       start, where: nonpassthrough)
        case (.forwards,   true): return firstCaretForwardsThrough(from:  start, where: nonpassthrough)
        case (.backwards, false): return firstCaretBackwardsTo(from:      start, where: nonpassthrough)
        case (.backwards,  true): return firstCaretBackwardsThrough(from: start, where: nonpassthrough)
        }
    }
}
