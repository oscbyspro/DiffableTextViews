//
//  &Collection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

extension Collection {
    // MARK: Indices
    
    @inlinable func index(at offset: Int) -> Index {
        index(startIndex, offsetBy: offset)
    }

    @inlinable func indices(in offsets: Range<Int>) -> Range<Index> {
        let lowerBound: Index = index(startIndex, offsetBy: offsets.lowerBound)
        let upperBound: Index = index(lowerBound, offsetBy: offsets.count)
                
        return lowerBound ..< upperBound
    }
}
