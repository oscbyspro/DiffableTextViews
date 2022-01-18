//
//  Count.swift
//
//
//  Created by Oscar Byström Ericsson on 2022-01-08.
//

//*============================================================================*
// MARK: * Sequence - Count
//*============================================================================*

public extension Sequence {
    
    //=------------------------------------------------------------------------=
    // MARK: While
    //=------------------------------------------------------------------------=
    
    @inlinable func count(while predicate: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        
        for element in self {
            guard try predicate(element) else { break }
            count += 1
        }
        
        return count
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Where
    //=------------------------------------------------------------------------=
    
    @inlinable func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        
        for element in self where try predicate(element) {
            count += 1
        }
        
        return count
    }
}
