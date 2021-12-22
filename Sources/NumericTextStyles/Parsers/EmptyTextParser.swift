//
//  EmptyTextParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - EmptyTextParser

#warning("WIP")
public struct EmptyTextParser<Output: Text>: TextParser {
    
    // MARK: Implementation
    
    @inlinable @inline(__always) init() { }
    
    @inlinable @inline(__always) public func parse<C: Collection>(characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character { }
    
    @inlinable @inline(__always) public static var standard: Self { .init() }
}

