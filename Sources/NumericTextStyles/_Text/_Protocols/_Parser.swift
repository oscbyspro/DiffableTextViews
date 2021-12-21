//
//  Parser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

import struct Foundation.Locale

// MARK: - Parser

#warning("WIP")
@usableFromInline protocol _Parser {
    
    // MARK: Requirements
    
    associatedtype Output: _Text
    
    /// If the parser allows selecting a locale, returns a copy of the parser with the new locale set. Default implementation returns an unmodified self.
    @inlinable func locale(_ locale: Locale) -> Self
    
    @inlinable func parse<C: Collection>(characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character
}

// MARK: - Defaults

extension _Parser {
    
    // MARK: Implementation
    
    @inlinable func locale(_ locale: Locale) -> Self { self }
}
