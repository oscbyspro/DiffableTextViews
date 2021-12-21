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
    
    // MARK: Properties
    
    @usableFromInline let characters: String
    
    // MARK: Initializers
    
    @inlinable init() {
        self.characters = ""
    }

    @inlinable init(characters: String) {
        self.characters = characters
    }
    
    // MARK: Getters
    
    @inlinable @inline(__always) var isEmpty: Bool {
        characters.isEmpty
    }
    
    // MARK: Characters: Static
    
    @usableFromInline static let dot: Character = "."
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
    
    @inlinable func parse<C: Collection>(characters: C, index: inout C.Index, storage: inout Output) where C.Element == Character {
        let subsequence = characters[index...]
        
        for separator in separators {
            guard subsequence.starts(with: separator) else { continue }
            
            storage = Output(characters: String(Output.dot))
            characters.formIndex(&index, offsetBy: separator.count)
            break
        }
    }
    
    // MARK: Instances: Static
    
    @usableFromInline static let standard = Self(separators: [String(Output.dot)])
}
