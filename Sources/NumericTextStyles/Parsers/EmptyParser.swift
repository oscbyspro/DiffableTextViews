//
//  EmptyParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - EmptyParser

@usableFromInline struct EmptyParser<Output: Text>: Parser {
    
    // MARK: Implementation
    
    @inlinable init() { }
    
    @inlinable public func parse<C: Collection>(_ characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character { }
    
    @inlinable public static var standard: Self { .init() }
}
