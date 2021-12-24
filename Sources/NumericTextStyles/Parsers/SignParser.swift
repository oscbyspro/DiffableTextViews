//
//  SignParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - SignParser

@usableFromInline struct SignParser: Parser {
    @usableFromInline typealias Translations = [Character: Sign]

    // MARK: Properties
    
    @usableFromInline let signs: Translations
    
    // MARK: Initializers
    
    @inlinable init(signs: Translations) {
        self.signs = signs
    }
    
    // MARK: Parse
    
    @inlinable func parse<C: Collection>(_ characters: C, index: inout C.Index, value: inout Sign) where C.Element == Character {
        if index < characters.endIndex, let sign = signs[characters[index]] {
            value = sign
            characters.formIndex(after: &index)
        }
    }
    
    // MARK: Maps
    
    @usableFromInline static let negatives: Translations = [
        Sign.minus: Sign.negative
    ]
    
    // MARK: Instances
    
    @usableFromInline static let standard = Self(signs: negatives)
}

