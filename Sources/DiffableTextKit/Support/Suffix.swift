//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * BidirectionalCollection - Suffix
//*============================================================================*

public extension BidirectionalCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: While
    //=------------------------------------------------------------------------=
    
    @inlinable func suffix(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        try self[startOfSuffix(while: predicate)...]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: While - Start
    //=------------------------------------------------------------------------=
    
    @inlinable internal func startOfSuffix(while predicate: (Element) throws -> Bool) rethrows -> Index {
        var position = endIndex
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        while position != startIndex {
            let after = position
            formIndex(before: &position)
            if try !predicate(self[position]) { return after }
        }
        //=--------------------------------------=
        // MARK: Position == Start Index
        //=--------------------------------------=
        return position
    }
}