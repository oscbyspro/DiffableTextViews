//
//  Transformable.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-12-16.
//

// MARK: - Transformable

public protocol Transformable { }

// MARK: - Utilities

public extension Transformable {
    
    // MARK: Transform
    
    @inlinable mutating func transform(using transformation: (Self) -> Self) {
        self = transformation(self)
    }
    
    @inlinable mutating func transform(using transformation: (inout Self) -> Void) {
        transformation(&self)
    }
    
    // MARK: Transforming
    
    @inlinable func transforming(using transformation: (Self) -> Self) -> Self {
        transformation(self)
    }
    
    @inlinable func transforming(using transformation: (inout Self) -> Void) -> Self {
        var result = self; transformation(&result); return result
    }
}
