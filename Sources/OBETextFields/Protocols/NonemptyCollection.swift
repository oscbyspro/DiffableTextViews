//
//  NonemptyCollection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-25.
//

protocol NonemptyCollection: Collection where Indices: NonemptyCollection { }

// MARK: DefaultIndices

extension DefaultIndices: NonemptyCollection where Elements: NonemptyCollection { }

// MARK: - Collection

extension NonemptyCollection {
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

extension NonemptyCollection where Self: BidirectionalCollection {
    @inlinable var last: Element {
        self.last!
    }
}
