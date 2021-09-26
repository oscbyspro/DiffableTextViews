//
//  &Collection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

extension Collection {
    /// - Complexity: O(1) if the collection conforms to RandomAccessCollection; otherwise O(k) where k is the absolute value of offset.
    @inlinable func index(at offset: Int) -> Index {
        index(startIndex, offsetBy: offset)
    }

    /// - Complexity: O(1) if the collection conforms to RandomAccessCollection; otherwise O(k) where k is the maximum absolute value of offsets.
    @inlinable func indices(in offsets: Range<Int>) -> Indices {
        let lowerBound: Index = index(startIndex, offsetBy: offsets.lowerBound)
        let upperBound: Index = index(lowerBound, offsetBy: offsets.count)
                
        return indices[lowerBound ..< upperBound]
    }
}
