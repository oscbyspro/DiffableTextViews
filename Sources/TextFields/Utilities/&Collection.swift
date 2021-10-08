//
//  &Collection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

import struct Foundation.NSRange

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

extension Collection {
    // MARK: Traversal: Subscriptable
    
    @inlinable func subscriptableIndex(after index: Index) -> Index? {
        index < endIndex ? self.index(after: index) : nil
    }
    
    @inlinable func subscriptableIndex(before index: Index) -> Index? where Self: BidirectionalCollection {
        index > startIndex ? self.index(before: index) : nil
    }
}

#warning("Decide whether to use Collection.method or Selection.method.")
extension Collection {
    // MARK: Traversal: Predicate
    
    @inlinable func firstIndex(behind index: Index, next: (Index) -> Index?, where predicate: (Element) -> Bool) -> Index? {
        var currentIndex = index
        
        while let otherIndex = next(currentIndex) {
            currentIndex = otherIndex
            
            if predicate(self[currentIndex]) { return currentIndex }
        }
        
        return nil
    }
    
    @inlinable func firstIndex(after index: Index, where predicate: (Element) -> Bool) -> Index? {
        firstIndex(behind: index, next: subscriptableIndex(after:), where: predicate)
    }
    
    @inlinable func firstIndex(before index: Index, where predicate: (Element) -> Bool) -> Index? where Self: BidirectionalCollection {
        firstIndex(behind: index, next: subscriptableIndex(before:), where: predicate)
    }
}
