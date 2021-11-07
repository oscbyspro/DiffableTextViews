//
//  &Collections.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-27.
//

// MARK: - Collections

extension BidirectionalCollection {
    
    // MARK: Transformations

    @inlinable func suffix(while predicate: (Element) -> Bool) -> SubSequence {
        var index = endIndex

        while index != startIndex {
            let after = index
            formIndex(before: &index)
            if !predicate(self[index]) { return self[after...] }
        }
    
        return self[index...]
    }
}
