//
//  NonEmpty.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-25.
//

protocol NonEmpty: Collection where Indices: NonEmpty { }

// MARK: DefaultIndices

extension DefaultIndices: NonEmpty where Elements: NonEmpty { }

// MARK: - Collection

extension NonEmpty {
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

extension NonEmpty where Self: BidirectionalCollection {
    @inlinable var last: Element {
        self.last!
    }
}
