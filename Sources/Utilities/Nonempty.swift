//
//  Nonempty.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-17.
//

// MARK: - Nonempty

public protocol Nonempty { }

// MARK: - Utilities: Collection

public extension Nonempty where Self: Collection {
    
    // MARK: Descriptions
    
    @inlinable @inline(__always) var isEmpty: Bool {
        false
    }
    
    // MARK: Element
    
    @inlinable @inline(__always) var first: Element {
        first!
    }
    
    // MARK: Index
    
    @inlinable @inline(__always) var firstIndex: Index {
        startIndex
    }
}

// MARK: - Utilities: BidirectionalCollection

public extension Nonempty where Self: BidirectionalCollection {
    
    // MARK: Element
    
    @inlinable @inline(__always) var last: Element {
        last!
    }
    
    // MARK: Index
    
    @inlinable @inline(__always) var lastIndex: Index {
        index(before: endIndex)
    }
}

// MARK: - Implementations

extension DefaultIndices: Nonempty where Elements: Nonempty { }
