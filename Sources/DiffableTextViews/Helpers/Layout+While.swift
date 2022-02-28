//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#warning("Think about these.")
//=----------------------------------------------------------------------------=
// MARK: + While
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: After
    //=------------------------------------------------------------------------=
    
    @inlinable func index(after start: Index, while predicate: (Index) -> Bool) -> Index {
        var position = start
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != endIndex {
            guard predicate(position) else { return position }
            formIndex(after: &position)
        }
        //=--------------------------------------=
        // MARK: Position == Layout End Index
        //=--------------------------------------=
        return position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Before
    //=------------------------------------------------------------------------=

    @inlinable func index(before start: Index, while predicate: (Index) -> Bool) -> Index {
        var position = start
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while position != startIndex {
            guard predicate(position) else { return position }
            formIndex(before: &position)
        }
        //=--------------------------------------=
        // MARK: Position == Layout Start Index
        //=--------------------------------------=
        return position
    }
}

