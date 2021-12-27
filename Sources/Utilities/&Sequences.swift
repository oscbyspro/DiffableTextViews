//
//  &Sequences.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

// MARK: - BidirectionalCollection

public extension BidirectionalCollection {
    
    // MARK: Suffix
    
    @inlinable func suffix(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        return try self[startOfSuffix(while: predicate)...]
    }
    
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

// MARK: - RangeReplaceableCollection

public extension RangeReplaceableCollection {
    
    // MARK: Transformations
    
    @inlinable func replacing<C: Collection>(_ range: Range<Index>, with elements: C) -> Self where C.Element == Element {
        var result = self; result.replaceSubrange(range, with: elements); return result
    }
}
