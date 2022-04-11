//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * BidirectionalCollection x Suffix
//*============================================================================*

extension BidirectionalCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: While
    //=------------------------------------------------------------------------=
    
    @inlinable public func suffix(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        try self[startOfSuffix(while: predicate)...]
    }
      
    @inlinable func startOfSuffix(while predicate: (Element) throws -> Bool) rethrows -> Index {
        var index = endIndex
        //=--------------------------------------=
        // MARK: Search
        //=--------------------------------------=
        while index != startIndex {
            let after = index
            formIndex(before: &index)
            if try !predicate(self[index]) { return after }
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return index
    }
}
