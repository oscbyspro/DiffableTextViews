//
//  Parser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

import struct Foundation.Locale
import protocol Utilities.Transformable

// MARK: - Parser

@usableFromInline protocol Parser: Transformable {
    
    // MARK: Requirements
    
    associatedtype Value: Text
    
    /// If the parser allows selecting a locale, updates it with the new locale set. Default implementation does nothing.
    @inlinable mutating func update(locale newValue: Locale)
    
    /// Parses characters by iterating the index and storing the valid characters inside the storage. Completes without effects if the characters are invalid.
    @inlinable func parse<C: Collection>(_ characters: C, index: inout C.Index, value: inout Value) where C.Element == Character
    
    /// An instance of self configured to parse system numbers.
    @inlinable static var standard: Self { get }
}

extension Parser {
    
    // MARK: Implementation
    
    @inlinable mutating func update(locale newValue: Locale) { }
    
    // MARK: Utilities
    
    /// Creates and returns a new instance if the characters are valid, else it returns nil.
    @inlinable func parse<C: Collection>(_ characters: C) -> Value? where C.Element == Character {
        var value = Value()
        var index = characters.startIndex
        parse(characters, index: &index, value: &value)
        return index == characters.endIndex ? value : nil
    }
}
