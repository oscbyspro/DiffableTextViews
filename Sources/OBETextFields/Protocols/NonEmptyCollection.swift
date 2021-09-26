//
//  NonEmptyCollection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-25.
//

protocol NonEmptyCollection: Collection where Indices: NonEmptyCollection { }

// MARK: DefaultIndices

extension DefaultIndices: NonEmptyCollection where Elements: NonEmptyCollection { }

// MARK: - Collection

extension NonEmptyCollection {
    @inlinable var first: Element {
        self.first!
    }
    
    @inlinable func min() -> Element where Element: Comparable {
        self.min()!
    }
    
    @inlinable func max() -> Element where Element: Comparable {
        self.max()!
    }
}

// MARK: - BidirectionalCollection

extension NonEmptyCollection where Self: BidirectionalCollection {
    @inlinable var last: Element {
        self.last!
    }
}
