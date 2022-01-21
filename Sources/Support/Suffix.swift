//
//  Suffix.swift
//
//
//  Created by Oscar Byström Ericsson on 2022-01-05.
//

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
        // MARK: Done
        //=--------------------------------------=
        return position
    }
}
