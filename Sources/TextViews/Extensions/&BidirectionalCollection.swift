//
//  BidirectionalCollection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-27.
//


// MARK: - BidirectionalCollection

extension BidirectionalCollection {
    
    // MARK: Suffix
    
    @inlinable func suffix(while predicate: (Element) -> Bool) -> SubSequence {
        var index = endIndex
        

        loop: while index != startIndex {
            let after = index
            formIndex(before: &index)
            if !predicate(self[index]) { return self[after...] }
        }
    
        return self[index...]
    }
}

