//
//  DigitsParser.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - DigitsParser

@usableFromInline struct DigitsParser: Parser {

    // MARK: Properties
    
    @usableFromInline private(set) var translatables: Set<Character>
    
    // MARK: Initializers
    
    @inlinable init(translatables: Set<Character>) {
        self.translatables = translatables
    }
    
    // MARK: Parse
    
    @inlinable func parse<C: Collection>(_ characters: C, index: inout C.Index, value: inout Digits) where C.Element == Character {
        while index < characters.endIndex {
            let character = characters[index]
            
            guard translatables.contains(character) else { break }
            
            value.append(character)
            characters.formIndex(after: &index)
        }
    }
    
    // MARK: Instances
    
    @usableFromInline static let standard = Self(translatables: Digits.decimals)
}
