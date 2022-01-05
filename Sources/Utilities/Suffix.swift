//
//  Suffix.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-05.
//

//*============================================================================*
// MARK: * BidirectionalCollection
//*============================================================================*

public extension BidirectionalCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Suffix
    //=------------------------------------------------------------------------=
    
    @inlinable func suffix(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        return try self[startOfSuffix(while: predicate)...]
    }
    
    //
    // MARK: Suffix - Start
    //=------------------------------------------------------------------------=
    
    @inlinable func startOfSuffix(while predicate: (Element) throws -> Bool) rethrows -> Index {
        var index = endIndex
        
        while index != startIndex {
            let after = index
            formIndex(before: &index)
            if try !predicate(self[index]) {
                return after
            }
        }
        
        return index
    }
}
