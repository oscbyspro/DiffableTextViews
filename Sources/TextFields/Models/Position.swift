//
//  Position.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-23.
//

// MARK: - Position

@usableFromInline struct Position<Scheme: TextFields.Layout> {
    
    // MARK: Properties
    
    @usableFromInline let origin: Origin
    @usableFromInline let offset: Int
    
    // MARK: Initializers
    
    @inlinable init(_ origin: Origin, offset: Int) {
        self.origin = origin
        self.offset = offset
    }
    
    // MARK: Initializers: Static
    
    @inlinable static var start: Self {
        .init(.start, offset: .zero)
    }
    
    @inlinable static var end: Self {
        .init(.end,   offset: .zero)
    }
    
    // MARK: Transformations
    
    @inlinable static func + (position: Self, stride: Int) -> Self {
        .init(position.origin, offset: position.offset + stride)
    }
    
    @inlinable static func - (position: Self, stride: Int) -> Self {
        .init(position.origin, offset: position.offset - stride)
    }
    
    // MARK: Origin
    
    @usableFromInline enum Origin { case start, end }
}
