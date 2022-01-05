//
//  Count.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-05.
//

//*============================================================================*
// MARK: * Sequence
//*============================================================================*

public extension Sequence {
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
    
    @inlinable func count(while predicate: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        
        for element in self {
            guard try predicate(element) else { break }
            count += 1
        }
        
        return count
    }
}
