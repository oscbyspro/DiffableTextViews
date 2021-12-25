//
//  SignParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - SignParser

@usableFromInline struct SignParser: Parser {

    // MARK: Properties
    
    @usableFromInline let translatables: [Character: Sign]
    
    // MARK: Initializers
    
    @inlinable init(translatables: [Character: Sign]) {
        self.translatables = translatables
    }
    
    // MARK: Parse
    
    @inlinable func parse<C: Collection>(_ characters: C, index: inout C.Index, value: inout Sign) where C.Element == Character {
        if index < characters.endIndex, let sign = translatables[characters[index]] {
            value = sign
            characters.formIndex(after: &index)
        }
    }
    
    // MARK: Translations
    
    @usableFromInline static let negatives: [Character: Sign] = [
        Sign.minus: Sign.negative
    ]
    
    // MARK: Instances
    
    @usableFromInline static let standard = Self(translatables: negatives)
}
