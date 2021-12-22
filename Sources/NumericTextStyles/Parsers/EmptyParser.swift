//
//  EmptyParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - EmptyParser

@usableFromInline struct EmptyParser<Output: Text>: Parser {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) init() { }
    
    @inlinable @inline(__always) public func parse<C: Collection>(_ characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character { }
    
    @inlinable @inline(__always) public static var standard: Self { .init() }
}
