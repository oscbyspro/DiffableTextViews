//
//  Separator.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

import struct Foundation.Locale

// MARK: - Separator

#warning("WIP")
@usableFromInline struct _Separator: _Text {
    @usableFromInline typealias Parser = _SeparatorParser
    
    // MARK: Properties
    
    @usableFromInline let characters: String
    
    // MARK: Initializers
    
    @inlinable init() {
        self.characters = ""
    }
    
    @inlinable init(characters: String) {
        self.characters = characters
    }
    
    // MARK: Instances: Static
    
    @usableFromInline static let dot = Self(characters: ".")
    
    // MARK: Parsers: Static

    @inlinable @inline(__always) static var parser: Parser { .dot }
}

// MARK: - SeparatorParser

#warning("WIP")
@usableFromInline struct _SeparatorParser: _Parser {
    @usableFromInline typealias Output = _Separator

    // MARK: Properties
    
    @usableFromInline let separators: [String]
    
    // MARK: Initializers
    
    @inlinable init(separators: [String]) {
        self.separators = separators
    }
    
    // MARK: Transformations
    
    @inlinable func locale(_ locale: Locale) -> _SeparatorParser {
        .init(separators: separators + [locale.decimalSeparator].compactMap({ $0 }))
    }
    
    // MARK: Parse
    
    @inlinable func parse<C: Collection>(_ characters: C, from index: inout C.Index, into storage: inout Output) where C.Element == Character {
        let subsequence = characters[index...]
        
        for separator in separators.reversed() {
            guard subsequence.starts(with: separator) else { continue }
            
            storage = .dot
            characters.formIndex(&index, offsetBy: separator.count)
            return
        }
    }
    
    // MARK: Instances: Static
    
    @usableFromInline static let dot = Self(separators: [Output.dot.characters])
}
