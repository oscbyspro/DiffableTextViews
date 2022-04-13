//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Collection x Iterate
//*============================================================================*

public extension Collection {
    
    //=------------------------------------------------------------------------=
    // MARK: After
    //=------------------------------------------------------------------------=

    @inlinable func index(after index: Index, while predicate: (Index) throws -> Bool) rethrows -> Index {
        var index = index
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while try predicate(  index) {
            formIndex(after: &index)
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return index
    }
}

//*============================================================================*
// MARK: * BidirectionalCollection x Iterate
//*============================================================================*

public extension BidirectionalCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Before
    //=------------------------------------------------------------------------=

    @inlinable func index(before index: Index, while predicate: (Index) throws -> Bool) rethrows -> Index {
        var index = index
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while try predicate(   index) {
            formIndex(before: &index)
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return index
    }
}
