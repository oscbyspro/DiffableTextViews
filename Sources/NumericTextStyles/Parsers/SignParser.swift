//
//  SignParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - SignParser

@usableFromInline struct SignParser: Parser {
    @usableFromInline typealias Translatables = [Character: Sign]

    // MARK: Properties
    
    @usableFromInline private(set) var translatables: Translatables
    
    // MARK: Initializers
    
    @inlinable init(translatables: Translatables) {
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
