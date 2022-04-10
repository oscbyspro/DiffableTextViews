//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Collection - Index
//*============================================================================*

public extension Collection {
    
    //=------------------------------------------------------------------------=
    // MARK: After
    //=------------------------------------------------------------------------=

    /// Increments the index while the predicate is true, up to endIndex.
    @inlinable func index(after position: Index,
    while predicate: (Index) throws -> Bool) rethrows -> Index {
        var position = position
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != endIndex {
            if try !predicate(position) { return position }
            formIndex(after: &position)
        }
        //=--------------------------------------=
        // MARK: Return End Index
        //=--------------------------------------=
        return position
    }
}

//*============================================================================*
// MARK: * BidirectionalCollection - Index
//*============================================================================*

public extension BidirectionalCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Before
    //=------------------------------------------------------------------------=

    /// Decrements the index while the predicate is true, down to startIndex.
    @inlinable func index(before position: Index,
    while predicate: (Index) throws -> Bool) rethrows -> Index {
        var position = position
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != startIndex {
            if try !predicate( position) { return position }
            formIndex(before: &position)
        }
        //=--------------------------------------=
        // MARK: Return Start Index
        //=--------------------------------------=
        return position        
    }
}
