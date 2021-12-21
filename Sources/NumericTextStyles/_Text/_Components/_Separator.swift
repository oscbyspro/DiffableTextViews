//
//  Separator.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

import Foundation

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
    
    // MARK: Instances: Static
    
    @usableFromInline static let dot = Self(characters: ".")
}

// MARK: - SeparatorParser

#warning("WIP")
@usableFromInline struct _SeparatorParser: _Parser {
    
    // MARK: Properties
    
    @usableFromInline let separators: [String]
    
    // MARK: Initializers
    
    @inlinable init(separators: [String]) {
        self.separators = separators
    }
    
    // MARK: Parse
    
    @inlinable func parse<C: Collection>(_ characters: C, from index: inout C.Index, into storage: inout _Separator) where C.Element == Character {
        let subsequence = characters[index...]
        
        for separator in separators {
            guard subsequence.starts(with: separator) else { continue }
            
            storage = .dot
            characters.formIndex(&index, offsetBy: separator.count)
            return
        }
    }
    
    // MARK: Instances: Static
    
    @usableFromInline static let dot = Self(separators: [_Separator.dot.characters])
    
    @inlinable static func localized(in locale: Locale) -> Self {
        .init(separators: [locale.decimalSeparator, _Separator.dot.characters].compactMap({ $0 }))
    }
}
