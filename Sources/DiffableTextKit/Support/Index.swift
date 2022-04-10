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
    @inlinable func index(after index: Index,
    while predicate: (Index) throws -> Bool) rethrows -> Index {
        var index = index
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while index != endIndex {
            if try !predicate(index) { return index }
            formIndex(after: &index)
        }
        //=--------------------------------------=
        // MARK: Return End Index
        //=--------------------------------------=
        return index
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
    @inlinable func index(before index: Index,
    while predicate: (Index) throws -> Bool) rethrows -> Index {
        var index = index
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while index != startIndex {
            if try !predicate( index) { return index }
            formIndex(before: &index)
        }
        //=--------------------------------------=
        // MARK: Return Start Index
        //=--------------------------------------=
        return index
    }
}
