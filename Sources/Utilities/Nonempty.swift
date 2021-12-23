//
//  Nonempty.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-17.
//

// MARK: - Nonempty

public protocol Nonempty { }

// MARK: - Nonempty: Collection

public extension Nonempty where Self: Collection {
    
    // MARK: Descriptions
    
    @inlinable var isEmpty: Bool {
        false
    }
    
    // MARK: Element
    
    @inlinable var first: Element {
        first!
    }
    
    // MARK: Index
    
    @inlinable var firstIndex: Index {
        startIndex
    }
}

// MARK: - Nonempty: BidirectionalCollection

public extension Nonempty where Self: BidirectionalCollection {
    
    // MARK: Element
    
    @inlinable var last: Element {
        last!
    }
    
    // MARK: Index
    
    @inlinable var lastIndex: Index {
        index(before: endIndex)
    }
}

// MARK: - Implementations

extension DefaultIndices: Nonempty where Elements: Nonempty { }
