//
//  TextParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

import struct Foundation.Locale

// MARK: - TextParser

public protocol TextParser {
    
    // MARK: Requirements
    
    associatedtype Output: Text
        
    /// If the parser allows selecting a locale, returns a copy of the parser with the new locale set. Default implementation returns an unmodified self.
    @inlinable func locale(_ locale: Locale) -> Self
    
    /// Parses characters by iterating the index and storing the valid characters inside the storage. Completes without effects if the characters are invalid.
    @inlinable func parse<C: Collection>(characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character
    
    /// An instance of self configured to parse system numbers.
    @inlinable static var standard: Self { get }
}

// MARK: - TextParser: Details

public extension TextParser {
    
    // MARK: Implementation
    
    @inlinable func locale(_ locale: Locale) -> Self { self }
    
    // MARK: Utilities
    
    /// Creates and returns a new instance if the characters are valid, else it returns nil.
    @inlinable func parse<C: Collection>(characters: C) -> Output? where C.Element == Character {
        var (output, index) = (Output(), characters.startIndex)
        parse(characters: characters, index: &index, storage: &output)
        return index == characters.endIndex ? output : nil
    }
}
