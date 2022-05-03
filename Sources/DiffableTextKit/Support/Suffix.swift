//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: Extension
//*============================================================================*

public extension BidirectionalCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: While
    //=------------------------------------------------------------------------=
    
    @inlinable func suffix(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        try self[startOfSuffix(while: predicate)...]
    }
      
    @inlinable internal func startOfSuffix(while predicate: (Element) throws -> Bool) rethrows -> Index {
        var index = endIndex
        //=--------------------------------------=
        // Search
        //=--------------------------------------=
        while index != startIndex {
            let after = index
            formIndex(before: &index)
            if try !predicate(self[index]) { return after }
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return index
    }
}
