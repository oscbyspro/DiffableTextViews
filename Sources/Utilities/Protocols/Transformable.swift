//
//  Transformable.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-12-16.
//

// MARK: - Transformable

public protocol  Transformable { }
public extension Transformable {
    
    // MARK: Transformations
        
    @inlinable mutating func transform(_ transformation: (inout Self) -> Void) {
        transformation(&self)
    }
        
    @inlinable func transforming(_ transformation: (inout Self) -> Void) -> Self {
        var result = self; transformation(&result); return result
    }
}
