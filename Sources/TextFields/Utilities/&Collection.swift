//
//  &Collection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

import struct Foundation.NSRange

// MARK: - Collection

extension Collection {
    
    // MARK: Indices
    
    @inlinable func indices(in offsets: Range<Int>) -> Range<Index> {
        let lowerBound: Index = index(startIndex, offsetBy: offsets.lowerBound)
        let upperBound: Index = index(lowerBound, offsetBy: offsets.count)
                
        return lowerBound ..< upperBound
    }
    
    @inlinable func indices(in offsets: NSRange) -> Range<Index> {
        indices(in: offsets.lowerBound ..< offsets.upperBound)
    }
}
