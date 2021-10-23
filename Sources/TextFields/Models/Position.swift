//
//  Position.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

// MARK: - Position

@usableFromInline struct Position<Scheme: TextFields.Scheme> {
    
    // MARK: Properties
    
    @usableFromInline let origin: Origin
    @usableFromInline let offset: Int
    
    // MARK: Initializers
    
    @inlinable init(_ origin: Origin, offset: Int = 0) {
        self.origin = origin
        self.offset = offset
    }
    
    // MARK: Transformations
    
    @inlinable func after(stride: Int) -> Self {
        .init(origin, offset: offset + stride)
    }
    
    @inlinable func before(stride: Int) -> Self {
        .init(origin, offset: offset - stride)
    }
    
    // MARK: Origin
    
    @usableFromInline enum Origin { case start, end }
}
