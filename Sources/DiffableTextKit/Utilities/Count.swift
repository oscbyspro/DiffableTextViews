//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Count
//*============================================================================*

public extension Sequence {
    
    //=------------------------------------------------------------------------=
    // MARK: Where
    //=------------------------------------------------------------------------=
    
    @inlinable func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        //=--------------------------------------=
        // Loop
        //=--------------------------------------=
        for element in self where try predicate(element) {
            count += 1
        }
        //=--------------------------------------=
        // Done
        //=--------------------------------------=
        return count
    }
    
    //=------------------------------------------------------------------------=
    // MARK: While
    //=------------------------------------------------------------------------=
    
    @inlinable func count(while predicate: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        //=--------------------------------------=
        // Loop
        //=--------------------------------------=
        for element in self {
            guard try predicate(element) else { break }
            count += 1
        }
        //=--------------------------------------=
        // Done
        //=--------------------------------------=
        return count
    }
}
