//
//  Nonempty.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-25.
//

protocol Nonempty: Collection where Indices: Nonempty { }

// MARK: DefaultIndices

extension DefaultIndices: Nonempty where Elements: Nonempty { }

// MARK: - Collection

extension Nonempty {
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

extension Nonempty where Self: BidirectionalCollection {
    @inlinable var last: Element {
        self.last!
    }
}
