//
//  NonemptyCollection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-17.
//

// MARK: - NonemptyCollection

public protocol NonemptyCollection: Collection { }

// MARK: - NonemptyCollection + DefaultIndices

extension DefaultIndices: NonemptyCollection where Elements: NonemptyCollection { }

// MARK: - Utilities: Collection

public extension NonemptyCollection {
    
    // MARK: Index
    
    @inlinable var firstIndex: Index {
        startIndex
    }
    
    // MARK: Element
    
    @inlinable var first: Element {
        first!
    }
}

// MARK: - Utilities: BidirectionalCollection

public extension NonemptyCollection where Self: BidirectionalCollection {
    
    // MARK: Index
    
    @inlinable var lastIndex: Index {
        index(before: endIndex)
    }
    
    // MARK: Element
    
    @inlinable var last: Element {
        last!
    }
}
