//
//  Parser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

import Foundation

//*============================================================================*
// MARK: * Parser
//*============================================================================*

@usableFromInline protocol Parser {
    
    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    associatedtype Value: Text
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    /// An instance of self configured to parse system numbers.
    @inlinable static var standard: Self { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Update
    //=------------------------------------------------------------------------=
    
    /// If the parser allows selecting a locale, updates it with the new locale set. Default implementation does nothing.
    @inlinable mutating func update(locale newValue: Locale)
    
    //=------------------------------------------------------------------------=
    // MARK: Parse
    //=------------------------------------------------------------------------=
    
    /// Parses characters by iterating the index and storing the valid characters inside the storage. Completes without effects if the characters are invalid.
    @inlinable func parse<C: Collection>(_ characters: C, index: inout C.Index, value: inout Value) where C.Element == Character
}

//=----------------------------------------------------------------------------=
// MARK: Parser - Implementation
//=----------------------------------------------------------------------------=

extension Parser {
    
    //=------------------------------------------------------------------------=
    // MARK: Update
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(locale newValue: Locale) { }
}

//=----------------------------------------------------------------------------=
// MARK: Parser - Utilities
//=----------------------------------------------------------------------------=

extension Parser {
    
    //=------------------------------------------------------------------------=
    // MARK: Parse
    //=------------------------------------------------------------------------=
    
    /// Creates and returns a new instance if the characters are valid, else it returns nil.
    @inlinable func parse<C: Collection>(_ characters: C) -> Value? where C.Element == Character {
        var value = Value()
        var index = characters.startIndex
        parse(characters, index: &index, value: &value)
        return index == characters.endIndex ? value : nil
    }
}
